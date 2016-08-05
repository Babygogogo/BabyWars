
--[[--------------------------------------------------------------------------------
-- ModelActionPlanner用于在战局给玩家规划单位和地形的行动。
--
-- 主要职责及使用场景：
--   在玩家点击特定单位时，生成其可移动范围、可用操作菜单、可攻击范围、预估攻击伤害等相关数据
--   在玩家点击特定地形时，生成可用的单位建造菜单
--
-- 其他：
--   - 本类生成的操作菜单均传给ModelActionMenu来显示，而移动范围、路径等由ViewActionPlanner显示。
--
--   - 在玩家确定行动前，无论如何操作，都不会改变战局的数据。
--     而一旦玩家确定行动，则发送“EvtPlayerRequestDoAction”事件，该事件最终会导致战局数据按玩家操作及游戏规则而改变。
--]]--------------------------------------------------------------------------------

local ModelActionPlanner = class("ModelActionPlanner")

local GridIndexFunctions          = require("src.app.utilities.GridIndexFunctions")
local ReachableAreaFunctions      = require("src.app.utilities.ReachableAreaFunctions")
local MovePathFunctions           = require("src.app.utilities.MovePathFunctions")
local AttackableGridListFunctions = require("src.app.utilities.AttackableGridListFunctions")
local WebSocketManager            = require("src.app.utilities.WebSocketManager")
local LocalizationFunctions       = require("src.app.utilities.LocalizationFunctions")
local AnimationLoader             = require("src.app.utilities.AnimationLoader")
local Actor                       = require("src.global.actors.Actor")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getMovePathDestination(movePath)
    return movePath[#movePath].gridIndex
end

local function getMoveCost(gridIndex, modelUnit, modelUnitMap, modelTileMap)
    if (not GridIndexFunctions.isWithinMap(gridIndex, modelUnitMap:getMapSize())) then
        return nil
    else
        local existingModelUnit = modelUnitMap:getModelUnit(gridIndex)
        if ((existingModelUnit) and (existingModelUnit:getPlayerIndex() ~= modelUnit:getPlayerIndex())) then
            return nil
        else
            return modelTileMap:getModelTile(gridIndex):getMoveCost(modelUnit:getMoveType())
        end
    end
end

local function canUnitStayInGrid(modelUnit, gridIndex, modelUnitMap)
    if (GridIndexFunctions.isEqual(modelUnit:getGridIndex(), gridIndex)) then
        return true
    else
        local existingModelUnit = modelUnitMap:getModelUnit(gridIndex)
        return (not existingModelUnit)                                                            or
            (modelUnit:canJoinModelUnit(existingModelUnit))                                       or
            (existingModelUnit.canLoadModelUnit and existingModelUnit:canLoadModelUnit(modelUnit))
    end
end

local function isDropGridAvailable(gridIndex, availableDropGrids)
    for _, availableGridIndex in pairs(availableDropGrids) do
        if (GridIndexFunctions.isEqual(gridIndex, availableGridIndex)) then
            return true
        end
    end

    return false
end

local function isDropGridSelected(gridIndex, selectedDropDestinations)
    for _, dropDestination in pairs(selectedDropDestinations) do
        if (GridIndexFunctions.isEqual(gridIndex, dropDestination.gridIndex)) then
            return true
        end
    end

    return false
end

local function getAvailableDropGrids(droppingModelUnit, loaderBeginningGridIndex, loaderEndingGridIndex, modelUnitMap, modelTileMap, dropDestinations)
    local moveType = droppingModelUnit:getMoveType()
    if (not modelTileMap:getModelTile(loaderEndingGridIndex):getMoveCost(moveType)) then
        return {}
    end

    local mapSize = modelTileMap:getMapSize()
    local grids   = {}
    for _, gridIndex in pairs(GridIndexFunctions.getAdjacentGrids(loaderEndingGridIndex)) do
        if ((GridIndexFunctions.isWithinMap(gridIndex, mapSize))         and
            (modelTileMap:getModelTile(gridIndex):getMoveCost(moveType)) and
            (not isDropGridSelected(gridIndex, dropDestinations))) then

            if ((not modelUnitMap:getModelUnit(gridIndex))                         or
                (GridIndexFunctions.isEqual(gridIndex, loaderBeginningGridIndex))) then
                grids[#grids + 1] = gridIndex
            end
        end
    end

    return grids
end

local function pushBackDropDestination(dropDestinations, unitID, destination, modelUnit)
    dropDestinations[#dropDestinations + 1] = {
        unitID    = unitID,
        gridIndex = destination,
        modelUnit = modelUnit,
    }
end

local function popBackDropDestination(dropDestinations)
    local dropDestination = dropDestinations[#dropDestinations]
    dropDestinations[#dropDestinations] = nil

    return dropDestination
end

local function isModelUnitDropped(unitID, dropDestinations)
    for _, dropDestination in pairs(dropDestinations) do
        if (unitID == dropDestination.unitID) then
            return true
        end
    end

    return false
end

local function canDoAdditionalDropAction(self)
    local focusModelUnit   = self.m_FocusModelUnit
    local dropDestinations = self.m_SelectedDropDestinations
    if (focusModelUnit:getCurrentLoadCount() <= #dropDestinations) then
        return false
    end

    local modelUnitMap             = self.m_ModelUnitMap
    local modelTileMap             = self.m_ModelTileMap
    local loaderBeginningGridIndex = focusModelUnit:getGridIndex()
    local loaderEndingGridIndex    = getMovePathDestination(self.m_MovePath)
    for _, unitID in pairs(focusModelUnit:getLoadUnitIdList()) do
        if ((not isModelUnitDropped(unitID, dropDestinations)) and
            (#getAvailableDropGrids(modelUnitMap:getLoadedModelUnitWithUnitId(unitID), loaderBeginningGridIndex, loaderEndingGridIndex, modelUnitMap, modelTileMap, dropDestinations) > 0)) then
            return true
        end
    end

    return false
end

--------------------------------------------------------------------------------
-- The functions for MovePath and ReachableArea.
--------------------------------------------------------------------------------
local function updateMovePathWithDestinationGrid(self, gridIndex)
    local maxRange     = math.min(self.m_FocusModelUnit:getMoveRange(), self.m_FocusModelUnit:getCurrentFuel())
    local nextMoveCost = getMoveCost(gridIndex, self.m_FocusModelUnit, self.m_ModelUnitMap, self.m_ModelTileMap)

    if ((not MovePathFunctions.truncateToGridIndex(self.m_MovePath, gridIndex))                        and
        (not MovePathFunctions.extendToGridIndex(self.m_MovePath, gridIndex, nextMoveCost, maxRange))) then
        self.m_MovePath = MovePathFunctions.createShortestPath(gridIndex, self.m_ReachableArea)
    end

    if (self.m_View) then
        self.m_View:setMovePath(self.m_MovePath)
    end
end

local function resetMovePath(self, gridIndex)
    self.m_MovePath       = {{
        gridIndex     = GridIndexFunctions.clone(gridIndex),
        totalMoveCost = 0,
    }}
    if (self.m_View) then
        self.m_View:setMovePath(self.m_MovePath)
    end
end

local function resetReachableArea(self, focusModelUnit)
    self.m_ReachableArea = ReachableAreaFunctions.createArea(
        focusModelUnit:getGridIndex(),
        math.min(focusModelUnit:getMoveRange(), focusModelUnit:getCurrentFuel()),
        function(gridIndex)
            return getMoveCost(gridIndex, focusModelUnit, self.m_ModelUnitMap, self.m_ModelTileMap)
        end
    )

    if (self.m_View) then
        self.m_View:setReachableArea(self.m_ReachableArea)
    end
end

--------------------------------------------------------------------------------
-- The functions for dispatching EvtPlayerRequestDoAction.
--------------------------------------------------------------------------------
local function dispatchEvtPreviewBattleDamage(self, attackDamage, counterDamage)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name          = "EvtPreviewBattleDamage",
        attackDamage  = attackDamage,
        counterDamage = counterDamage,
    })
end

local function dispatchEvtPreviewNoBattleDatame(self)
    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtPreviewNoBattleDamage"})
end

local function dispatchEventJoinModelUnit(self)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name         = "EvtPlayerRequestDoAction",
        actionName   = "JoinModelUnit",
        path         = MovePathFunctions.createPathForDispatch(self.m_MovePath),
        launchUnitID = self.m_LaunchUnitID,
    })
end

local function dispatchEventAttack(self, targetGridIndex)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name            = "EvtPlayerRequestDoAction",
        actionName      = "Attack",
        path            = MovePathFunctions.createPathForDispatch(self.m_MovePath),
        targetGridIndex = GridIndexFunctions.clone(targetGridIndex),
        launchUnitID    = self.m_LaunchUnitID,
    })
end

local function dispatchEventCaptureModelTile(self)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name         = "EvtPlayerRequestDoAction",
        actionName   = "CaptureModelTile",
        path         = MovePathFunctions.createPathForDispatch(self.m_MovePath),
        launchUnitID = self.m_LaunchUnitID,
    })
end

local function dispatchEventBuildModelTile(self)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name         = "EvtPlayerRequestDoAction",
        actionName   = "BuildModelTile",
        path         = MovePathFunctions.createPathForDispatch(self.m_MovePath),
        launchUnitID = self.m_LaunchUnitID,
    })
end

local function dispatchEventProduceModelUnitOnUnit(self)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name       = "EvtPlayerRequestDoAction",
        actionName = "ProduceModelUnitOnUnit",
        path       = MovePathFunctions.createPathForDispatch(self.m_MovePath),
    })
end

local function dispatchEventSupplyModelUnit(self)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name         = "EvtPlayerRequestDoAction",
        actionName   = "SupplyModelUnit",
        path         = MovePathFunctions.createPathForDispatch(self.m_MovePath),
        launchUnitID = self.m_LaunchUnitID,
    })
end

local function dispatchEventWait(self)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name         = "EvtPlayerRequestDoAction",
        actionName   = "Wait",
        path         = MovePathFunctions.createPathForDispatch(self.m_MovePath),
        launchUnitID = self.m_LaunchUnitID,
    })
end

local function dispatchEventProduceOnTile(self, gridIndex, tiledID)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name       = "EvtPlayerRequestDoAction",
        actionName = "ProduceOnTile",
        gridIndex  = GridIndexFunctions.clone(gridIndex),
        tiledID    = tiledID,
    })
end

local function dispatchEventLoadModelUnit(self)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name         = "EvtPlayerRequestDoAction",
        actionName   = "LoadModelUnit",
        path         = MovePathFunctions.createPathForDispatch(self.m_MovePath),
        launchUnitID = self.m_LaunchUnitID,
    })
end

local function dispatchEventDropModelUnit(self)
    local dropDestinations = {}
    for _, dropDestination in ipairs(self.m_SelectedDropDestinations) do
        dropDestinations[#dropDestinations + 1] = {
            unitID    = dropDestination.unitID,
            gridIndex = dropDestination.gridIndex,
        }
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({
        name             = "EvtPlayerRequestDoAction",
        actionName       = "DropModelUnit",
        path             = MovePathFunctions.createPathForDispatch(self.m_MovePath),
        dropDestinations = dropDestinations,
        launchUnitID     = self.m_LaunchUnitID,
    })
end

local function dispatchEventLaunchSilo(self, targetGridIndex)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name            = "EvtPlayerRequestDoAction",
        actionName      = "LaunchSilo",
        path            = MovePathFunctions.createPathForDispatch(self.m_MovePath),
        targetGridIndex = targetGridIndex,
        launchUnitID    = self.m_LaunchUnitID,
    })
end

--------------------------------------------------------------------------------
-- The functions for available action list.
--------------------------------------------------------------------------------
local setStateIdle
local setStatePreviewingAttackableArea
local setStatePreviewingReachableArea
local setStateChoosingProductionTarget
local setStateMakingMovePath
local setStateChoosingAction
local setStateChoosingAttackTarget
local setStateChoosingSiloTarget
local setStateChoosingDropDestination
local setStateChoosingAdditionalDropAction

local function getActionLoadModelUnit(self)
    local destination = getMovePathDestination(self.m_MovePath)
    if (GridIndexFunctions.isEqual(self.m_FocusModelUnit:getGridIndex(), destination)) then
        return nil
    else
        local loaderModelUnit = self.m_ModelUnitMap:getModelUnit(destination)
        if ((loaderModelUnit)                                          and
            (loaderModelUnit.canLoadModelUnit)                         and
            (loaderModelUnit:canLoadModelUnit(self.m_FocusModelUnit))) then
            return {
                name     = LocalizationFunctions.getLocalizedText(78, "LoadModelUnit"),
                callback = function()
                    dispatchEventLoadModelUnit(self)
                end
            }
        end
    end
end

local function getActionJoinModelUnit(self)
    local existingModelUnit = self.m_ModelUnitMap:getModelUnit(getMovePathDestination(self.m_MovePath))
    if ((#self.m_MovePath > 1)                                       and
        (existingModelUnit)                                          and
        (self.m_FocusModelUnit:canJoinModelUnit(existingModelUnit))) then
        return {
            name     = LocalizationFunctions.getLocalizedText(78, "JoinModelUnit"),
            callback = function()
                dispatchEventJoinModelUnit(self)
            end
        }
    else
        return nil
    end
end

local function getActionAttack(self)
    if (#self.m_AttackableGridList == 0) then
        return nil
    else
        return {
            name     = LocalizationFunctions.getLocalizedText(78, "Attack"),
            callback = function()
                setStateChoosingAttackTarget(self, getMovePathDestination(self.m_MovePath))
            end,
        }
    end
end

local function getActionCapture(self)
    local modelTile = self.m_ModelTileMap:getModelTile(getMovePathDestination(self.m_MovePath))
    if ((self.m_FocusModelUnit.canCaptureModelTile) and (self.m_FocusModelUnit:canCaptureModelTile(modelTile))) then
        return {
            name     = LocalizationFunctions.getLocalizedText(78, "CaptureModelTile"),
            callback = function()
                dispatchEventCaptureModelTile(self)
            end,
        }
    else
        return nil
    end
end

local function getActionBuildModelTile(self)
    local tileType       = self.m_ModelTileMap:getModelTile(getMovePathDestination(self.m_MovePath)):getTileType()
    local focusModelUnit = self.m_FocusModelUnit

    if ((focusModelUnit.canBuildOnTileType)           and
        (focusModelUnit:canBuildOnTileType(tileType)) and
        (focusModelUnit:getCurrentMaterial() > 0))    then
        local buildTiledId = focusModelUnit:getBuildTiledIdWithTileType(tileType)
        local icon         = cc.Sprite:create()
        icon:setAnchorPoint(0, 0)
            :setScale(0.5)
            :playAnimationForever(AnimationLoader.getTileAnimationWithTiledId(buildTiledId))

        return {
            name     = LocalizationFunctions.getLocalizedText(78, "BuildModelTile"),
            icon     = icon,
            callback = function()
                dispatchEventBuildModelTile(self)
            end,
        }
    end
end

local function getActionSupplyModelUnit(self)
    local focusModelUnit = self.m_FocusModelUnit
    if (not focusModelUnit.canSupplyModelUnit) then
        return nil
    end

    local modelUnitMap = self.m_ModelUnitMap
    for _, gridIndex in pairs(GridIndexFunctions.getAdjacentGrids(getMovePathDestination(self.m_MovePath), modelUnitMap:getMapSize())) do
        local modelUnit = modelUnitMap:getModelUnit(gridIndex)
        if ((modelUnit)                                     and
            (modelUnit ~= focusModelUnit)                   and
            (focusModelUnit:canSupplyModelUnit(modelUnit))) then
            return {
                name     = LocalizationFunctions.getLocalizedText(78, "SupplyModelUnit"),
                callback = function()
                    dispatchEventSupplyModelUnit(self)
                end,
            }
        end
    end

    return nil
end

local function getSingleActionLaunchModelUnit(self, unitID)
    local beginningGridIndex = self.m_MovePath[1].gridIndex
    local icon               = Actor.createView("sceneWar.ViewUnit")
    icon:updateWithModelUnit(self.m_ModelUnitMap:getFocusModelUnit(beginningGridIndex, unitID))
        :setScale(0.5)

    return {
        name     = LocalizationFunctions.getLocalizedText(78, "LaunchModelUnit"),
        icon     = icon,
        callback = function()
            setStateMakingMovePath(self, beginningGridIndex, unitID)
        end,
    }
end

local function getActionsLaunchModelUnit(self)
    local focusModelUnit = self.m_FocusModelUnit
    if ((#self.m_MovePath ~= 1)                    or
        (not focusModelUnit.canLaunchModelUnit)    or
        (not focusModelUnit:canLaunchModelUnit())) then
        return {}
    end

    local actions      = {}
    local modelUnitMap = self.m_ModelUnitMap
    local modelTile    = self.m_ModelTileMap:getModelTile(getMovePathDestination(self.m_MovePath))
    for _, unitID in ipairs(focusModelUnit:getLoadUnitIdList()) do
        local launchModelUnit = modelUnitMap:getLoadedModelUnitWithUnitId(unitID)
        if ((launchModelUnit:getState() == "idle")                  and
            (modelTile:getMoveCost(launchModelUnit:getMoveType()))) then
            actions[#actions + 1] = getSingleActionLaunchModelUnit(self, unitID)
        end
    end

    return actions
end

local function getSingleActionDropModelUnit(self, unitID)
    local icon = Actor.createView("sceneWar.ViewUnit"):updateWithModelUnit(self.m_ModelUnitMap:getLoadedModelUnitWithUnitId(unitID))
    icon:ignoreAnchorPointForPosition(true)
        :setScale(0.5)

    return {
        name     = LocalizationFunctions.getLocalizedText(78, "DropModelUnit"),
        icon     = icon,
        callback = function()
            setStateChoosingDropDestination(self, unitID)
        end,
    }
end

local function getActionsDropModelUnit(self)
    local focusModelUnit   = self.m_FocusModelUnit
    local dropDestinations = self.m_SelectedDropDestinations

    if ((not focusModelUnit.getCurrentLoadCount) or
        (focusModelUnit:getCurrentLoadCount() <= #dropDestinations) or
        (not focusModelUnit:canDropModelUnit())) then
        return {}
    end

    local actions = {}
    local loaderBeginningGridIndex = self.m_FocusModelUnit:getGridIndex()
    local loaderEndingGridIndex    = getMovePathDestination(self.m_MovePath)
    local modelUnitMap             = self.m_ModelUnitMap
    local modelTileMap             = self.m_ModelTileMap

    for _, unitID in ipairs(focusModelUnit:getLoadUnitIdList()) do
        if (not isModelUnitDropped(unitID, dropDestinations)) then
            local droppingModelUnit = self.m_ModelUnitMap:getLoadedModelUnitWithUnitId(unitID)
            if (#getAvailableDropGrids(droppingModelUnit, loaderBeginningGridIndex, loaderEndingGridIndex, modelUnitMap, modelTileMap, dropDestinations) > 0) then
                actions[#actions + 1] = getSingleActionDropModelUnit(self, unitID)
            end
        end
    end

    return actions
end

local function getActionLaunchSilo(self)
    local focusModelUnit = self.m_FocusModelUnit
    local modelTile      = self.m_ModelTileMap:getModelTile(getMovePathDestination(self.m_MovePath))

    if ((focusModelUnit.canLaunchSiloOnTileType) and
        (focusModelUnit:canLaunchSiloOnTileType(modelTile:getTileType()))) then
        return {
            name     = LocalizationFunctions.getLocalizedText(78, "LaunchSilo"),
            callback = function()
                setStateChoosingSiloTarget(self)
            end,
        }
    else
        return nil
    end
end

local function getActionProduceModelUnitOnUnit(self)
    local focusModelUnit = self.m_FocusModelUnit
    if ((self.m_LaunchUnitID)                            or
        (#self.m_MovePath ~= 1)                          or
        (not focusModelUnit.getCurrentMaterial)          or
        (not focusModelUnit.getMovableProductionTiledId) or
        (not focusModelUnit.getCurrentLoadCount))        then
        return nil
    else
        local produceTiledId = focusModelUnit:getMovableProductionTiledId()
        local icon           = cc.Sprite:create()
        icon:setAnchorPoint(0, 0)
            :setScale(0.5)
            :playAnimationForever(AnimationLoader.getUnitAnimationWithTiledId(produceTiledId))

        return {
            name        = LocalizationFunctions.getLocalizedText(78, "ProduceModelUnitOnUnit"),
            icon        = icon,
            isAvailable = (focusModelUnit:getCurrentMaterial() >= 1)                                and
                (focusModelUnit:getMovableProductionCost() <= self.m_LoggedInModelPlayer:getFund()) and
                (focusModelUnit:getCurrentLoadCount() < focusModelUnit:getMaxLoadCount()),
            callback    = function()
                dispatchEventProduceModelUnitOnUnit(self)
            end,
        }
    end
end

local function getActionWait(self)
    local existingUnitModel = self.m_ModelUnitMap:getModelUnit(getMovePathDestination(self.m_MovePath))
    if (not existingUnitModel) or (self.m_FocusModelUnit == existingUnitModel) then
        return {
            name     = LocalizationFunctions.getLocalizedText(78, "Wait"),
            callback = function()
                dispatchEventWait(self)
            end
        }
    else
        return nil
    end
end

local function getAvailableActionList(self)
    local actionLoad = getActionLoadModelUnit(self)
    if (actionLoad) then
        return {actionLoad}
    end
    local actionJoin = getActionJoinModelUnit(self)
    if (actionJoin) then
        return {actionJoin}
    end

    local list = {}
    list[#list + 1] = getActionAttack(                self)
    list[#list + 1] = getActionCapture(               self)
    list[#list + 1] = getActionBuildModelTile(        self)
    list[#list + 1] = getActionSupplyModelUnit(       self)
    for _, action in ipairs(getActionsLaunchModelUnit(self)) do
        list[#list + 1] = action
    end
    for _, action in ipairs(getActionsDropModelUnit(self)) do
        list[#list + 1] = action
    end
    list[#list + 1] = getActionLaunchSilo(            self)
    list[#list + 1] = getActionProduceModelUnitOnUnit(self)
    list[#list + 1] = getActionWait(                  self)

    assert(#list > 0, "ModelActionPlanner-getAvailableActionList() the generated list has no valid action item.")
    return list
end

local function getAdditionalDropActionList(self)
    local list = {}
    for _, action in ipairs(getActionsDropModelUnit(self)) do
        list[#list + 1] = action
    end
    list[#list + 1] = {
        name     = LocalizationFunctions.getLocalizedText(78, "Wait"),
        callback = function()
            dispatchEventDropModelUnit(self)
        end,
    }

    return list
end

--------------------------------------------------------------------------------
-- The set state functions.
--------------------------------------------------------------------------------
setStateIdle = function(self, resetUnitAnimation)
    if (self.m_View) then
        self.m_View:setReachableAreaVisible( false)
            :setAttackableGridsVisible(       false)
            :setMovePathVisible(              false)
            :setMovePathDestinationVisible(   false)
            :setDroppableGridsVisible(        false)
            :setPreviewDropDestinationVisible(false)
            :setDropDestinationsVisible(      false)
            :setPreviewAttackableAreaVisible( false)
            :setPreviewReachableAreaVisible(  false)

        self.m_ModelUnitMap:setPreviewLaunchUnitVisible(false)
        if ((resetUnitAnimation) and (self.m_FocusModelUnit)) then
            self.m_FocusModelUnit:showNormalAnimation()
        end
        for _, modelUnit in pairs(self.m_PreviewAttackModelUnits) do
            modelUnit:showNormalAnimation()
        end
        if (self.m_PreviewReachModelUnit) then
            self.m_PreviewReachModelUnit:showNormalAnimation()
        end
    end

    self.m_State                    = "idle"
    self.m_FocusModelUnit           = nil
    self.m_PreviewAttackModelUnits  = {}
    self.m_PreviewAttackableArea    = {}
    self.m_PreviewReachModelUnit    = nil
    self.m_LaunchUnitID             = nil
    self.m_SelectedDropDestinations = {}

    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtActionPlannerIdle"})
end

local function canSetStatePreviewingAttackableArea(self, gridIndex)
    local modelUnit = self.m_ModelUnitMap:getModelUnit(gridIndex)
    return (modelUnit)                                             and
        (modelUnit.getAttackRangeMinMax)                           and
        (modelUnit:getPlayerIndex() ~= self.m_LoggedInPlayerIndex)
end

setStatePreviewingAttackableArea = function(self, gridIndex)
    self.m_State = "previewingAttackableArea"
    local modelUnit = self.m_ModelUnitMap:getModelUnit(gridIndex)
    for _, existingModelUnit in pairs(self.m_PreviewAttackModelUnits) do
        if (modelUnit == existingModelUnit) then
            return
        end
    end

    self.m_PreviewAttackModelUnits[#self.m_PreviewAttackModelUnits + 1] = modelUnit
    self.m_PreviewAttackableArea = AttackableGridListFunctions.createAttackableArea(gridIndex, self.m_ModelTileMap, self.m_ModelUnitMap, self.m_PreviewAttackableArea)

    if (self.m_View) then
        self.m_View:setPreviewAttackableArea(self.m_PreviewAttackableArea)
            :setPreviewAttackableAreaVisible(true)
        modelUnit:showMovingAnimation()
    end
end

local function canSetStatePreviewingReachableArea(self, gridIndex)
    local modelUnit = self.m_ModelUnitMap:getModelUnit(gridIndex)
    return (modelUnit)                                             and
        (not modelUnit.getAttackRangeMinMax)                       and
        (modelUnit:getPlayerIndex() ~= self.m_LoggedInPlayerIndex)
end

setStatePreviewingReachableArea = function(self, gridIndex)
    self.m_State = "previewingReachableArea"

    local modelUnit              = self.m_ModelUnitMap:getModelUnit(gridIndex)
    self.m_PreviewReachModelUnit = modelUnit
    self.m_PreviewReachableArea  = ReachableAreaFunctions.createArea(
        gridIndex,
        math.min(modelUnit:getMoveRange(), modelUnit:getCurrentFuel()),
        function(gridIndex)
            return getMoveCost(gridIndex, modelUnit, self.m_ModelUnitMap, self.m_ModelTileMap)
        end
    )

    if (self.m_View) then
        self.m_View:setPreviewReachableArea(self.m_PreviewReachableArea)
            :setPreviewReachableAreaVisible(true)
        modelUnit:showMovingAnimation()
    end
end

local function canSetStateChoosingProductionTarget(self, gridIndex)
    local modelTile = self.m_ModelTileMap:getModelTile(gridIndex)
    return (not self.m_ModelUnitMap:getModelUnit(gridIndex))       and
        (modelTile:getPlayerIndex() == self.m_LoggedInPlayerIndex) and
        (modelTile.getProductionList)
end

setStateChoosingProductionTarget = function(self, gridIndex)
    self.m_State = "choosingProductionTarget"
    local modelTile      = self.m_ModelTileMap:getModelTile(gridIndex)
    local productionList = modelTile:getProductionList(self.m_LoggedInModelPlayer)

    for _, listItem in ipairs(productionList) do
        listItem.callback = function()
            dispatchEventProduceOnTile(self, gridIndex, listItem.tiledID)
        end
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({
        name           = "EvtActionPlannerChoosingProductionTarget",
        productionList = productionList,
    })
end

local function canSetStateMakingMovePath(self, beginningGridIndex, launchUnitID)
    local modelUnit = self.m_ModelUnitMap:getFocusModelUnit(beginningGridIndex, launchUnitID)
    return (modelUnit) and (modelUnit:canDoAction(self.m_LoggedInPlayerIndex))
end

setStateMakingMovePath = function(self, beginningGridIndex, launchUnitID)
    local focusModelUnit = self.m_ModelUnitMap:getFocusModelUnit(beginningGridIndex, launchUnitID)
    if (self.m_FocusModelUnit ~= focusModelUnit) then
        self.m_FocusModelUnit = focusModelUnit
        resetReachableArea(self, focusModelUnit)
        resetMovePath(self, beginningGridIndex)
    end

    self.m_State          = "makingMovePath"
    self.m_LaunchUnitID   = launchUnitID

    focusModelUnit:showMovingAnimation()
    if (self.m_View) then
        self.m_View:setReachableAreaVisible(true)
            :setAttackableGridsVisible(false)
            :setMovePathVisible(true)
            :setMovePathDestinationVisible(false)

        if (launchUnitID) then
            self.m_ModelUnitMap:setPreviewLaunchUnit(focusModelUnit, beginningGridIndex)
                :setPreviewLaunchUnitVisible(true)
        else
            self.m_ModelUnitMap:setPreviewLaunchUnitVisible(false)
        end
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtActionPlannerMakingMovePath"})
end

setStateChoosingAction = function(self, destination, launchUnitID)
    local beginningGridIndex = self.m_MovePath[1].gridIndex
    local focusModelUnit     = self.m_ModelUnitMap:getFocusModelUnit(beginningGridIndex, launchUnitID)
    if (self.m_FocusModelUnit ~= focusModelUnit) then
        self.m_FocusModelUnit  = focusModelUnit
        destination            = beginningGridIndex
        resetReachableArea(self, focusModelUnit)
    end

    self.m_State              = "choosingAction"
    self.m_AttackableGridList = AttackableGridListFunctions.createList(self.m_FocusModelUnit, destination, self.m_ModelTileMap, self.m_ModelUnitMap, self.m_ModelWeather)
    self.m_LaunchUnitID       = launchUnitID
    updateMovePathWithDestinationGrid(self, destination)

    if (self.m_View) then
        self.m_View:setReachableAreaVisible(false)
            :setAttackableGridsVisible(false)
            :setMovePathVisible(true)
            :setMovePathDestination(destination)
            :setMovePathDestinationVisible(true)
            :setDroppableGridsVisible(false)
            :setPreviewDropDestinationVisible(false)
            :setDropDestinationsVisible(false)

        if (not launchUnitID) then
            self.m_ModelUnitMap:setPreviewLaunchUnitVisible(false)
        end
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({
        name = "EvtActionPlannerChoosingAction",
        list = getAvailableActionList(self)
    })
end

setStateChoosingAttackTarget = function(self, destination)
    self.m_State = "choosingAttackTarget"

    if (self.m_View) then
        self.m_View:setAttackableGrids(self.m_AttackableGridList)
            :setAttackableGridsVisible(true)
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtActionPlannerChoosingAttackTarget"})
end

setStateChoosingSiloTarget = function(self)
    self.m_State = "choosingSiloTarget"

    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtActionPlannerChoosingSiloTarget"})
end

setStateChoosingDropDestination = function(self, unitID)
    self.m_State = "choosingDropDestination"

    local droppingModelUnit   = self.m_ModelUnitMap:getLoadedModelUnitWithUnitId(unitID)
    self.m_AvailableDropGrids = getAvailableDropGrids(droppingModelUnit, self.m_FocusModelUnit:getGridIndex(), getMovePathDestination(self.m_MovePath), self.m_ModelUnitMap, self.m_ModelTileMap, self.m_SelectedDropDestinations)
    self.m_DroppingUnitID     = unitID

    if (self.m_View) then
        self.m_View:setDroppableGrids(self.m_AvailableDropGrids)
            :setDroppableGridsVisible(true)
            :setDropDestinations(self.m_SelectedDropDestinations)
            :setDropDestinationsVisible(true)
            :setPreviewDropDestinationVisible(false)
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtActionPlannerChoosingDropDestination"})
end

setStateChoosingAdditionalDropAction = function(self)
    self.m_State = "choosingAdditionalDropAction"

    if (self.m_View) then
        self.m_View:setDroppableGridsVisible( false)
            :setPreviewDropDestinationVisible(false)
            :setDropDestinations(self.m_SelectedDropDestinations)
            :setDropDestinationsVisible(true)
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({
        name = "EvtActionPlannerChoosingAction",
        list = getAdditionalDropActionList(self),
    })
end

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtPlayerIndexUpdated(self, event)
    self.m_PlayerIndexInTurn = event.playerIndex
    setStateIdle(self, true)
end

local function onEvtModelWeatherUpdated(self, event)
    self.m_ModelWeather = event.modelWeather
end

local function onEvtIsWaitingForServerResponse(self, event)
    setStateIdle(self, false)
    self.m_IsWaitingForServerResponse = event.waiting
end

local function onEvtMapCursorMoved(self, event)
    if ((self.m_IsWaitingForServerResponse)                       or
        (self.m_PlayerIndexInTurn ~= self.m_LoggedInPlayerIndex)) then
        return
    end

    local state     = self.m_State
    local gridIndex = event.gridIndex

    if (state == "choosingProductionTarget") then
        setStateIdle(self, true)
    elseif (state == "makingMovePath") then
        if (ReachableAreaFunctions.getAreaNode(self.m_ReachableArea, gridIndex)) then
            updateMovePathWithDestinationGrid(self, gridIndex)
        end
    elseif (state == "choosingAttackTarget") then
        local listNode = AttackableGridListFunctions.getListNode(self.m_AttackableGridList, gridIndex)
        if (listNode) then
            dispatchEvtPreviewBattleDamage(self, listNode.estimatedAttackDamage, listNode.estimatedCounterDamage)
        else
            dispatchEvtPreviewNoBattleDatame(self)
        end
    elseif (state == "choosingDropDestination") then
        if (self.m_View) then
            if (isDropGridAvailable(gridIndex, self.m_AvailableDropGrids)) then
                self.m_View:setPreviewDropDestination(gridIndex, self.m_ModelUnitMap:getLoadedModelUnitWithUnitId(self.m_DroppingUnitID))
                    :setPreviewDropDestinationVisible(true)
            else
                self.m_View:setPreviewDropDestinationVisible(false)
            end
        end
    end

    self.m_CursorGridIndex = GridIndexFunctions.clone(gridIndex)
end

local function onEvtGridSelected(self, event)
    if ((self.m_IsWaitingForServerResponse)                       or
        (self.m_PlayerIndexInTurn ~= self.m_LoggedInPlayerIndex)) then
        return
    end

    local state     = self.m_State
    local gridIndex = event.gridIndex

    if (state == "idle") then
        if (canSetStateMakingMovePath(self, gridIndex)) then
            setStateMakingMovePath(self, gridIndex)
        elseif (canSetStateChoosingProductionTarget(self, gridIndex)) then
            setStateChoosingProductionTarget(self, gridIndex)
        elseif (canSetStatePreviewingAttackableArea(self, gridIndex)) then
            setStatePreviewingAttackableArea(self, gridIndex)
        elseif (canSetStatePreviewingReachableArea(self, gridIndex)) then
            setStatePreviewingReachableArea(self, gridIndex)
        end
    elseif (state == "choosingProductionTarget") then
        setStateIdle(self, true)
    elseif (state == "makingMovePath") then
        if (not ReachableAreaFunctions.getAreaNode(self.m_ReachableArea, gridIndex)) then
            if (self.m_LaunchUnitID) then
                setStateChoosingAction(self, self.m_MovePath[1].gridIndex)
            else
                setStateIdle(self, true)
            end
        elseif (canUnitStayInGrid(self.m_FocusModelUnit, gridIndex, self.m_ModelUnitMap)) then
            if ((self.m_LaunchUnitID) and (GridIndexFunctions.isEqual(self.m_FocusModelUnit:getGridIndex(), gridIndex))) then
                setStateChoosingAction(self, self.m_MovePath[1].gridIndex)
            else
                setStateChoosingAction(self, gridIndex, self.m_LaunchUnitID)
            end
        end
    elseif (state == "choosingAction") then
        setStateMakingMovePath(self, self.m_MovePath[1].gridIndex, self.m_LaunchUnitID)
    elseif (state == "choosingAttackTarget") then
        local listNode = AttackableGridListFunctions.getListNode(self.m_AttackableGridList, gridIndex)
        if (not listNode) then
            setStateChoosingAction(self, getMovePathDestination(self.m_MovePath), self.m_LaunchUnitID)
        else
            if (GridIndexFunctions.isEqual(self.m_CursorGridIndex, gridIndex)) then
                dispatchEventAttack(self, gridIndex)
            else
                dispatchEvtPreviewBattleDamage(self, listNode.estimatedAttackDamage, listNode.estimatedCounterDamage)
            end
        end
    elseif (state == "choosingSiloTarget") then
        if (GridIndexFunctions.isEqual(gridIndex, self.m_CursorGridIndex)) then
            dispatchEventLaunchSilo(self, gridIndex)
        elseif (GridIndexFunctions.getDistance(gridIndex, self.m_CursorGridIndex) > 2) then
            setStateChoosingAction(self, getMovePathDestination(self.m_MovePath), self.m_LaunchUnitID)
        end
    elseif (state == "choosingDropDestination") then
        if (isDropGridAvailable(gridIndex, self.m_AvailableDropGrids)) then
            pushBackDropDestination(self.m_SelectedDropDestinations, self.m_DroppingUnitID, gridIndex, self.m_ModelUnitMap:getLoadedModelUnitWithUnitId(self.m_DroppingUnitID))
            if (not canDoAdditionalDropAction(self)) then
                dispatchEventDropModelUnit(self)
            else
                setStateChoosingAdditionalDropAction(self)
            end
        else
            if (#self.m_SelectedDropDestinations == 0) then
                setStateChoosingAction(self, getMovePathDestination(self.m_MovePath), self.m_LaunchUnitID)
            else
                setStateChoosingAdditionalDropAction(self)
            end
        end
    elseif (state == "choosingAdditionalDropAction") then
        setStateChoosingDropDestination(self, popBackDropDestination(self.m_SelectedDropDestinations).unitID)
    elseif (state == "previewingAttackableArea") then
        if (canSetStatePreviewingAttackableArea(self, gridIndex)) then
            setStatePreviewingAttackableArea(self, gridIndex)
        else
            setStateIdle(self, true)
        end
    elseif (state == "previewingReachableArea") then
        setStateIdle(self, true)
    else
        error("ModelActionPlanner-onEvtGridSelected() the state of the planner is invalid.")
    end

    self.m_CursorGridIndex = GridIndexFunctions.clone(gridIndex)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelActionPlanner:ctor(param)
    self.m_State                      = "idle"
    self.m_IsWaitingForServerResponse = false
    self.m_PreviewAttackModelUnits    = {}
    self.m_SelectedDropDestinations   = {}

    return self
end

function ModelActionPlanner:initView()
    return self
end

function ModelActionPlanner:setModelUnitMap(model)
    assert(self.m_ModelUnitMap == nil, "ModelActionPlanner:setModelUnitMap() the model has been set already.")
    self.m_ModelUnitMap = model

    return self
end

function ModelActionPlanner:setModelTileMap(model)
    assert(self.m_ModelTileMap == nil, "ModelActionPlanner:setModelTileMap() the model has been set already.")
    self.m_ModelTileMap = model

    if (self.m_View) then
        self.m_View:setMapSize(model:getMapSize())
    end

    return self
end

function ModelActionPlanner:setModelPlayerManager(modelPlayerManager)
    assert(self.m_ModelPlayerManager == nil, "ModelActionPlanner:setModelPlayerManager() the model has been set.")
    self.m_ModelPlayerManager = modelPlayerManager

    local playerAccount = WebSocketManager.getLoggedInAccountAndPassword()
    modelPlayerManager:forEachModelPlayer(function(modelPlayer, playerIndex)
        if (modelPlayer:getAccount() == playerAccount) then
            self.m_LoggedInModelPlayer = modelPlayer
            self.m_LoggedInPlayerIndex = playerIndex
        end
    end)

    return self
end

function ModelActionPlanner:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelActionPlanner:setRootScriptEventDispatcher() the dispatcher has been set already.")

    self.m_RootScriptEventDispatcher = dispatcher
    dispatcher:addEventListener("EvtGridSelected",         self)
        :addEventListener("EvtMapCursorMoved",             self)
        :addEventListener("EvtPlayerIndexUpdated",         self)
        :addEventListener("EvtModelWeatherUpdated",        self)
        :addEventListener("EvtIsWaitingForServerResponse", self)

    return self
end

function ModelActionPlanner:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "ModelActionPlanner:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")

    self.m_RootScriptEventDispatcher:removeEventListener("EvtIsWaitingForServerResponse", self)
        :removeEventListener("EvtModelWeatherUpdated", self)
        :removeEventListener("EvtPlayerIndexUpdated",  self)
        :removeEventListener("EvtMapCursorMoved",      self)
        :removeEventListener("EvtGridSelected",        self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
function ModelActionPlanner:onEvent(event)
    local name = event.name
    if     (name == "EvtGridSelected")               then onEvtGridSelected(              self, event)
    elseif (name == "EvtPlayerIndexUpdated")         then onEvtPlayerIndexUpdated(        self, event)
    elseif (name == "EvtModelWeatherUpdated")        then onEvtModelWeatherUpdated(       self, event)
    elseif (name == "EvtMapCursorMoved")             then onEvtMapCursorMoved(            self, event)
    elseif (name == "EvtIsWaitingForServerResponse") then onEvtIsWaitingForServerResponse(self, event)
    end

    return self
end

return ModelActionPlanner
