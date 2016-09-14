
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
--     而一旦玩家确定行动，则发送action到服务器，该action通常会导致战局数据按玩家操作及游戏规则而改变。
--]]--------------------------------------------------------------------------------

local ModelActionPlanner = class("ModelActionPlanner")

local AnimationLoader             = require("src.app.utilities.AnimationLoader")
local AttackableGridListFunctions = require("src.app.utilities.AttackableGridListFunctions")
local GridIndexFunctions          = require("src.app.utilities.GridIndexFunctions")
local LocalizationFunctions       = require("src.app.utilities.LocalizationFunctions")
local MovePathFunctions           = require("src.app.utilities.MovePathFunctions")
local ReachableAreaFunctions      = require("src.app.utilities.ReachableAreaFunctions")
local SingletonGetters            = require("src.app.utilities.SingletonGetters")
local WebSocketManager            = require("src.app.utilities.WebSocketManager")
local Actor                       = require("src.global.actors.Actor")

local createPathForDispatch    = MovePathFunctions.createPathForDispatch
local getLocalizedText         = LocalizationFunctions.getLocalizedText
local getModelPlayerManager    = SingletonGetters.getModelPlayerManager
local getModelTileMap          = SingletonGetters.getModelTileMap
local getModelUnitMap          = SingletonGetters.getModelUnitMap
local getScriptEventDispatcher = SingletonGetters.getScriptEventDispatcher

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
            return modelTileMap:getModelTile(gridIndex):getMoveCostWithModelUnit(modelUnit)
        end
    end
end

local function canUnitStayInGrid(modelUnit, gridIndex, modelUnitMap, modelTileMap)
    if (GridIndexFunctions.isEqual(modelUnit:getGridIndex(), gridIndex)) then
        return true
    else
        local existingModelUnit = modelUnitMap:getModelUnit(gridIndex)
        local tileType          = modelTileMap:getModelTile(gridIndex):getTileType()
        return (not existingModelUnit)                                                                       or
            (modelUnit:canJoinModelUnit(existingModelUnit))                                                  or
            (existingModelUnit.canLoadModelUnit and existingModelUnit:canLoadModelUnit(modelUnit, tileType))
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
    if (not modelTileMap:getModelTile(loaderEndingGridIndex):getMoveCostWithModelUnit(droppingModelUnit)) then
        return {}
    end

    local mapSize  = modelTileMap:getMapSize()
    local grids    = {}
    for _, gridIndex in pairs(GridIndexFunctions.getAdjacentGrids(loaderEndingGridIndex)) do
        if ((GridIndexFunctions.isWithinMap(gridIndex, mapSize))                               and
            (modelTileMap:getModelTile(gridIndex):getMoveCostWithModelUnit(droppingModelUnit)) and
            (not isDropGridSelected(gridIndex, dropDestinations)))                             then

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

    local modelUnitMap             = getModelUnitMap()
    local modelTileMap             = getModelTileMap()
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
    local nextMoveCost = getMoveCost(gridIndex, self.m_FocusModelUnit, getModelUnitMap(), getModelTileMap())

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
            return getMoveCost(gridIndex, focusModelUnit, getModelUnitMap(), getModelTileMap())
        end
    )

    if (self.m_View) then
        self.m_View:setReachableArea(self.m_ReachableArea)
    end
end

--------------------------------------------------------------------------------
-- The functions for dispatching events.
--------------------------------------------------------------------------------
local function dispatchEvtPreviewBattleDamage(self, attackDamage, counterDamage)
    getScriptEventDispatcher():dispatchEvent({
        name          = "EvtPreviewBattleDamage",
        attackDamage  = attackDamage,
        counterDamage = counterDamage,
    })
end

local function dispatchEvtPreviewNoBattleDatame(self)
    getScriptEventDispatcher():dispatchEvent({name = "EvtPreviewNoBattleDamage"})
end

--------------------------------------------------------------------------------
-- The functions for sending actions to the server.
--------------------------------------------------------------------------------
local function createAndSendAction(rawAction)
    rawAction.actionID         = SingletonGetters.getActionId() + 1
    rawAction.sceneWarFileName = SingletonGetters.getSceneWarFileName()
    WebSocketManager.sendAction(rawAction)

    SingletonGetters.getModelMessageIndicator():showPersistentMessage(getLocalizedText(80, "TransferingData"))
    getScriptEventDispatcher():dispatchEvent({
        name    = "EvtIsWaitingForServerResponse",
        waiting = true,
    })
end

local function sendActionJoinModelUnit(self)
    createAndSendAction({
        actionName   = "JoinModelUnit",
        path         = createPathForDispatch(self.m_MovePath),
        launchUnitID = self.m_LaunchUnitID,
    })
end

local function sendActionAttack(self, targetGridIndex)
    createAndSendAction({
        actionName      = "Attack",
        path            = createPathForDispatch(self.m_MovePath),
        targetGridIndex = GridIndexFunctions.clone(targetGridIndex),
        launchUnitID    = self.m_LaunchUnitID,
    })
end

local function sendActionCaptureModelTile(self)
    createAndSendAction({
        actionName   = "CaptureModelTile",
        path         = createPathForDispatch(self.m_MovePath),
        launchUnitID = self.m_LaunchUnitID,
    })
end

local function sendActionBuildModelTile(self)
    createAndSendAction({
        actionName   = "BuildModelTile",
        path         = createPathForDispatch(self.m_MovePath),
        launchUnitID = self.m_LaunchUnitID,
    })
end

local function sendActionProduceModelUnitOnUnit(self)
    createAndSendAction({
        actionName = "ProduceModelUnitOnUnit",
        path       = createPathForDispatch(self.m_MovePath),
    })
end

local function sendActionSupplyModelUnit(self)
    createAndSendAction({
        actionName   = "SupplyModelUnit",
        path         = createPathForDispatch(self.m_MovePath),
        launchUnitID = self.m_LaunchUnitID,
    })
end

local function sendActionWait(self)
    createAndSendAction({
        actionName   = "Wait",
        path         = createPathForDispatch(self.m_MovePath),
        launchUnitID = self.m_LaunchUnitID,
    })
end

local function sendActionProduceOnTile(self, gridIndex, tiledID)
    createAndSendAction({
        actionName = "ProduceOnTile",
        gridIndex  = GridIndexFunctions.clone(gridIndex),
        tiledID    = tiledID,
    })
end

local function sendActionLoadModelUnit(self)
    createAndSendAction({
        actionName   = "LoadModelUnit",
        path         = createPathForDispatch(self.m_MovePath),
        launchUnitID = self.m_LaunchUnitID,
    })
end

local function sendActionDropModelUnit(self)
    local dropDestinations = {}
    for _, dropDestination in ipairs(self.m_SelectedDropDestinations) do
        dropDestinations[#dropDestinations + 1] = {
            unitID    = dropDestination.unitID,
            gridIndex = dropDestination.gridIndex,
        }
    end

    createAndSendAction({
        actionName       = "DropModelUnit",
        path             = createPathForDispatch(self.m_MovePath),
        dropDestinations = dropDestinations,
        launchUnitID     = self.m_LaunchUnitID,
    })
end

local function sendActionLaunchSilo(self, targetGridIndex)
    createAndSendAction({
        actionName      = "LaunchSilo",
        path            = createPathForDispatch(self.m_MovePath),
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
        local loaderModelUnit = getModelUnitMap():getModelUnit(destination)
        local tileType        = getModelTileMap():getModelTile(destination):getTileType()
        if ((loaderModelUnit)                                                    and
            (loaderModelUnit.canLoadModelUnit)                                   and
            (loaderModelUnit:canLoadModelUnit(self.m_FocusModelUnit, tileType))) then
            return {
                name     = getLocalizedText(78, "LoadModelUnit"),
                callback = function()
                    sendActionLoadModelUnit(self)
                end
            }
        end
    end
end

local function getActionJoinModelUnit(self)
    local existingModelUnit = getModelUnitMap():getModelUnit(getMovePathDestination(self.m_MovePath))
    if ((#self.m_MovePath > 1)                                       and
        (existingModelUnit)                                          and
        (self.m_FocusModelUnit:canJoinModelUnit(existingModelUnit))) then
        return {
            name     = getLocalizedText(78, "JoinModelUnit"),
            callback = function()
                sendActionJoinModelUnit(self)
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
            name     = getLocalizedText(78, "Attack"),
            callback = function()
                setStateChoosingAttackTarget(self, getMovePathDestination(self.m_MovePath))
            end,
        }
    end
end

local function getActionCapture(self)
    local modelTile = getModelTileMap():getModelTile(getMovePathDestination(self.m_MovePath))
    if ((self.m_FocusModelUnit.canCaptureModelTile) and (self.m_FocusModelUnit:canCaptureModelTile(modelTile))) then
        return {
            name     = getLocalizedText(78, "CaptureModelTile"),
            callback = function()
                sendActionCaptureModelTile(self)
            end,
        }
    else
        return nil
    end
end

local function getActionBuildModelTile(self)
    local tileType       = getModelTileMap():getModelTile(getMovePathDestination(self.m_MovePath)):getTileType()
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
            name     = getLocalizedText(78, "BuildModelTile"),
            icon     = icon,
            callback = function()
                sendActionBuildModelTile(self)
            end,
        }
    end
end

local function getActionSupplyModelUnit(self)
    local focusModelUnit = self.m_FocusModelUnit
    if (not focusModelUnit.canSupplyModelUnit) then
        return nil
    end

    local modelUnitMap = getModelUnitMap()
    for _, gridIndex in pairs(GridIndexFunctions.getAdjacentGrids(getMovePathDestination(self.m_MovePath), modelUnitMap:getMapSize())) do
        local modelUnit = modelUnitMap:getModelUnit(gridIndex)
        if ((modelUnit)                                     and
            (modelUnit ~= focusModelUnit)                   and
            (focusModelUnit:canSupplyModelUnit(modelUnit))) then
            return {
                name     = getLocalizedText(78, "SupplyModelUnit"),
                callback = function()
                    sendActionSupplyModelUnit(self)
                end,
            }
        end
    end

    return nil
end

local function getSingleActionLaunchModelUnit(self, unitID)
    local beginningGridIndex = self.m_MovePath[1].gridIndex
    local icon               = Actor.createView("sceneWar.ViewUnit")
    icon:updateWithModelUnit(getModelUnitMap():getFocusModelUnit(beginningGridIndex, unitID))
        :setScale(0.5)

    return {
        name     = getLocalizedText(78, "LaunchModelUnit"),
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
    local modelUnitMap = getModelUnitMap()
    local modelTile    = getModelTileMap():getModelTile(getMovePathDestination(self.m_MovePath))
    for _, unitID in ipairs(focusModelUnit:getLoadUnitIdList()) do
        local launchModelUnit = modelUnitMap:getLoadedModelUnitWithUnitId(unitID)
        if ((launchModelUnit:getState() == "idle")                 and
            (modelTile:getMoveCostWithModelUnit(launchModelUnit))) then
            actions[#actions + 1] = getSingleActionLaunchModelUnit(self, unitID)
        end
    end

    return actions
end

local function getSingleActionDropModelUnit(self, unitID)
    local icon = Actor.createView("sceneWar.ViewUnit"):updateWithModelUnit(getModelUnitMap():getLoadedModelUnitWithUnitId(unitID))
    icon:ignoreAnchorPointForPosition(true)
        :setScale(0.5)

    return {
        name     = getLocalizedText(78, "DropModelUnit"),
        icon     = icon,
        callback = function()
            setStateChoosingDropDestination(self, unitID)
        end,
    }
end

local function getActionsDropModelUnit(self)
    local focusModelUnit        = self.m_FocusModelUnit
    local dropDestinations      = self.m_SelectedDropDestinations
    local modelTileMap          = getModelTileMap()
    local loaderEndingGridIndex = getMovePathDestination(self.m_MovePath)

    if ((not focusModelUnit.getCurrentLoadCount)                                                               or
        (focusModelUnit:getCurrentLoadCount() <= #dropDestinations)                                            or
        (not focusModelUnit:canDropModelUnit(modelTileMap:getModelTile(loaderEndingGridIndex):getTileType()))) then
        return {}
    end

    local actions = {}
    local loaderBeginningGridIndex = self.m_FocusModelUnit:getGridIndex()
    local modelUnitMap             = getModelUnitMap()

    for _, unitID in ipairs(focusModelUnit:getLoadUnitIdList()) do
        if (not isModelUnitDropped(unitID, dropDestinations)) then
            local droppingModelUnit = getModelUnitMap():getLoadedModelUnitWithUnitId(unitID)
            if (#getAvailableDropGrids(droppingModelUnit, loaderBeginningGridIndex, loaderEndingGridIndex, modelUnitMap, modelTileMap, dropDestinations) > 0) then
                actions[#actions + 1] = getSingleActionDropModelUnit(self, unitID)
            end
        end
    end

    return actions
end

local function getActionLaunchSilo(self)
    local focusModelUnit = self.m_FocusModelUnit
    local modelTile      = getModelTileMap():getModelTile(getMovePathDestination(self.m_MovePath))

    if ((focusModelUnit.canLaunchSiloOnTileType) and
        (focusModelUnit:canLaunchSiloOnTileType(modelTile:getTileType()))) then
        return {
            name     = getLocalizedText(78, "LaunchSilo"),
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
        local fund           = getModelPlayerManager():getModelPlayer(self.m_LoggedInPlayerIndex):getFund()
        local icon           = cc.Sprite:create()
        icon:setAnchorPoint(0, 0)
            :setScale(0.5)
            :playAnimationForever(AnimationLoader.getUnitAnimationWithTiledId(produceTiledId))

        return {
            name        = getLocalizedText(78, "ProduceModelUnitOnUnit"),
            icon        = icon,
            isAvailable = (focusModelUnit:getCurrentMaterial() >= 1)                      and
                (focusModelUnit:getMovableProductionCost() <= fund)                       and
                (focusModelUnit:getCurrentLoadCount() < focusModelUnit:getMaxLoadCount()),
            callback    = function()
                sendActionProduceModelUnitOnUnit(self)
            end,
        }
    end
end

local function getActionWait(self)
    local existingUnitModel = getModelUnitMap():getModelUnit(getMovePathDestination(self.m_MovePath))
    if (not existingUnitModel) or (self.m_FocusModelUnit == existingUnitModel) then
        return {
            name     = getLocalizedText(78, "Wait"),
            callback = function()
                sendActionWait(self)
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
        name     = getLocalizedText(78, "Wait"),
        callback = function()
            sendActionDropModelUnit(self)
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

        getModelUnitMap():setPreviewLaunchUnitVisible(false)
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

    getScriptEventDispatcher():dispatchEvent({name = "EvtActionPlannerIdle"})
end

local function canSetStatePreviewingAttackableArea(self, gridIndex)
    local modelUnit = getModelUnitMap():getModelUnit(gridIndex)
    return (modelUnit)                                             and
        (modelUnit.getAttackRangeMinMax)                           and
        (modelUnit:getPlayerIndex() ~= self.m_LoggedInPlayerIndex)
end

setStatePreviewingAttackableArea = function(self, gridIndex)
    self.m_State = "previewingAttackableArea"
    local modelUnit = getModelUnitMap():getModelUnit(gridIndex)
    for _, existingModelUnit in pairs(self.m_PreviewAttackModelUnits) do
        if (modelUnit == existingModelUnit) then
            return
        end
    end

    self.m_PreviewAttackModelUnits[#self.m_PreviewAttackModelUnits + 1] = modelUnit
    self.m_PreviewAttackableArea = AttackableGridListFunctions.createAttackableArea(gridIndex, getModelTileMap(), getModelUnitMap(), self.m_PreviewAttackableArea)

    if (self.m_View) then
        self.m_View:setPreviewAttackableArea(self.m_PreviewAttackableArea)
            :setPreviewAttackableAreaVisible(true)
        modelUnit:showMovingAnimation()
    end
end

local function canSetStatePreviewingReachableArea(self, gridIndex)
    local modelUnit = getModelUnitMap():getModelUnit(gridIndex)
    return (modelUnit)                                             and
        (not modelUnit.getAttackRangeMinMax)                       and
        (modelUnit:getPlayerIndex() ~= self.m_LoggedInPlayerIndex)
end

setStatePreviewingReachableArea = function(self, gridIndex)
    self.m_State = "previewingReachableArea"

    local modelUnit              = getModelUnitMap():getModelUnit(gridIndex)
    self.m_PreviewReachModelUnit = modelUnit
    self.m_PreviewReachableArea  = ReachableAreaFunctions.createArea(
        gridIndex,
        math.min(modelUnit:getMoveRange(), modelUnit:getCurrentFuel()),
        function(gridIndex)
            return getMoveCost(gridIndex, modelUnit, getModelUnitMap(), getModelTileMap())
        end
    )

    if (self.m_View) then
        self.m_View:setPreviewReachableArea(self.m_PreviewReachableArea)
            :setPreviewReachableAreaVisible(true)
        modelUnit:showMovingAnimation()
    end
end

local function canSetStateChoosingProductionTarget(self, gridIndex)
    if (self.m_PlayerIndexInTurn ~= self.m_LoggedInPlayerIndex) then
        return false
    else
        local modelTile = getModelTileMap():getModelTile(gridIndex)
        return (not getModelUnitMap():getModelUnit(gridIndex))       and
            (modelTile:getPlayerIndex() == self.m_LoggedInPlayerIndex) and
            (modelTile.getProductionList)
    end
end

setStateChoosingProductionTarget = function(self, gridIndex)
    self.m_State = "choosingProductionTarget"
    local modelTile      = getModelTileMap():getModelTile(gridIndex)
    local productionList = modelTile:getProductionList()

    for _, listItem in ipairs(productionList) do
        listItem.callback = function()
            sendActionProduceOnTile(self, gridIndex, listItem.tiledID)
        end
    end

    getScriptEventDispatcher():dispatchEvent({
        name           = "EvtActionPlannerChoosingProductionTarget",
        productionList = productionList,
    })
end

local function canSetStateMakingMovePath(self, beginningGridIndex, launchUnitID)
    if (self.m_PlayerIndexInTurn ~= self.m_LoggedInPlayerIndex) then
        return false
    else
        local modelUnit = getModelUnitMap():getFocusModelUnit(beginningGridIndex, launchUnitID)
        return (modelUnit) and (modelUnit:canDoAction(self.m_LoggedInPlayerIndex))
    end
end

setStateMakingMovePath = function(self, beginningGridIndex, launchUnitID)
    local focusModelUnit = getModelUnitMap():getFocusModelUnit(beginningGridIndex, launchUnitID)
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
            getModelUnitMap():setPreviewLaunchUnit(focusModelUnit, beginningGridIndex)
                :setPreviewLaunchUnitVisible(true)
        else
            getModelUnitMap():setPreviewLaunchUnitVisible(false)
        end
    end

    getScriptEventDispatcher():dispatchEvent({name = "EvtActionPlannerMakingMovePath"})
end

setStateChoosingAction = function(self, destination, launchUnitID)
    local beginningGridIndex = self.m_MovePath[1].gridIndex
    local focusModelUnit     = getModelUnitMap():getFocusModelUnit(beginningGridIndex, launchUnitID)
    if (self.m_FocusModelUnit ~= focusModelUnit) then
        self.m_FocusModelUnit  = focusModelUnit
        destination            = beginningGridIndex
        resetReachableArea(self, focusModelUnit)
    end

    updateMovePathWithDestinationGrid(self, destination)
    self.m_State              = "choosingAction"
    self.m_AttackableGridList = AttackableGridListFunctions.createList(createPathForDispatch(self.m_MovePath), launchUnitID)
    self.m_LaunchUnitID       = launchUnitID

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
            getModelUnitMap():setPreviewLaunchUnitVisible(false)
        end
    end

    getScriptEventDispatcher():dispatchEvent({
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

    getScriptEventDispatcher():dispatchEvent({name = "EvtActionPlannerChoosingAttackTarget"})
end

setStateChoosingSiloTarget = function(self)
    self.m_State = "choosingSiloTarget"

    getScriptEventDispatcher():dispatchEvent({name = "EvtActionPlannerChoosingSiloTarget"})
end

setStateChoosingDropDestination = function(self, unitID)
    self.m_State = "choosingDropDestination"

    local droppingModelUnit   = getModelUnitMap():getLoadedModelUnitWithUnitId(unitID)
    self.m_AvailableDropGrids = getAvailableDropGrids(droppingModelUnit, self.m_FocusModelUnit:getGridIndex(), getMovePathDestination(self.m_MovePath), getModelUnitMap(), getModelTileMap(), self.m_SelectedDropDestinations)
    self.m_DroppingUnitID     = unitID

    if (self.m_View) then
        self.m_View:setDroppableGrids(self.m_AvailableDropGrids)
            :setDroppableGridsVisible(true)
            :setDropDestinations(self.m_SelectedDropDestinations)
            :setDropDestinationsVisible(true)
            :setPreviewDropDestinationVisible(false)
    end

    getScriptEventDispatcher():dispatchEvent({name = "EvtActionPlannerChoosingDropDestination"})
end

setStateChoosingAdditionalDropAction = function(self)
    self.m_State = "choosingAdditionalDropAction"

    if (self.m_View) then
        self.m_View:setDroppableGridsVisible( false)
            :setPreviewDropDestinationVisible(false)
            :setDropDestinations(self.m_SelectedDropDestinations)
            :setDropDestinationsVisible(true)
    end

    getScriptEventDispatcher():dispatchEvent({
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

local function onEvtWarCommandMenuUpdated(self, event)
    if (event.isEnabled) then
        setStateIdle(self, not self.m_IsWaitingForServerResponse)
    end
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
                self.m_View:setPreviewDropDestination(gridIndex, getModelUnitMap():getLoadedModelUnitWithUnitId(self.m_DroppingUnitID))
                    :setPreviewDropDestinationVisible(true)
            else
                self.m_View:setPreviewDropDestinationVisible(false)
            end
        end
    end

    self.m_CursorGridIndex = GridIndexFunctions.clone(gridIndex)
end

local function onEvtGridSelected(self, event)
    if (self.m_IsWaitingForServerResponse) then
        return
    end

    local state     = self.m_State
    local gridIndex = event.gridIndex

    if (state == "idle") then
        if     (canSetStateMakingMovePath(          self, gridIndex)) then setStateMakingMovePath(          self, gridIndex)
        elseif (canSetStateChoosingProductionTarget(self, gridIndex)) then setStateChoosingProductionTarget(self, gridIndex)
        elseif (canSetStatePreviewingAttackableArea(self, gridIndex)) then setStatePreviewingAttackableArea(self, gridIndex)
        elseif (canSetStatePreviewingReachableArea( self, gridIndex)) then setStatePreviewingReachableArea( self, gridIndex)
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
        elseif (canUnitStayInGrid(self.m_FocusModelUnit, gridIndex, getModelUnitMap(), getModelTileMap())) then
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
                sendActionAttack(self, gridIndex)
            else
                dispatchEvtPreviewBattleDamage(self, listNode.estimatedAttackDamage, listNode.estimatedCounterDamage)
            end
        end
    elseif (state == "choosingSiloTarget") then
        if (GridIndexFunctions.isEqual(gridIndex, self.m_CursorGridIndex)) then
            sendActionLaunchSilo(self, gridIndex)
        elseif (GridIndexFunctions.getDistance(gridIndex, self.m_CursorGridIndex) > 2) then
            setStateChoosingAction(self, getMovePathDestination(self.m_MovePath), self.m_LaunchUnitID)
        end
    elseif (state == "choosingDropDestination") then
        if (isDropGridAvailable(gridIndex, self.m_AvailableDropGrids)) then
            pushBackDropDestination(self.m_SelectedDropDestinations, self.m_DroppingUnitID, gridIndex, getModelUnitMap():getLoadedModelUnitWithUnitId(self.m_DroppingUnitID))
            if (not canDoAdditionalDropAction(self)) then
                sendActionDropModelUnit(self)
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

--------------------------------------------------------------------------------
-- The callback functions on start running/script events.
--------------------------------------------------------------------------------
function ModelActionPlanner:onStartRunning(sceneWarFileName)
    getScriptEventDispatcher()
        :addEventListener("EvtGridSelected",               self)
        :addEventListener("EvtMapCursorMoved",             self)
        :addEventListener("EvtPlayerIndexUpdated",         self)
        :addEventListener("EvtModelWeatherUpdated",        self)
        :addEventListener("EvtIsWaitingForServerResponse", self)
        :addEventListener("EvtWarCommandMenuUpdated",      self)

    local playerAccount = WebSocketManager.getLoggedInAccountAndPassword()
    SingletonGetters.getModelPlayerManager():forEachModelPlayer(function(modelPlayer, playerIndex)
        if (modelPlayer:getAccount() == playerAccount) then
            self.m_LoggedInPlayerIndex = playerIndex
        end
    end)
    assert(self.m_LoggedInPlayerIndex,
        "ModelActionPlanner:onStartRunning() failed to find the player index for the logged-in player.")

    if (self.m_View) then
        self.m_View:setMapSize(getModelTileMap():getMapSize())
    end

    return self
end

function ModelActionPlanner:onEvent(event)
    local name = event.name
    if     (name == "EvtGridSelected")               then onEvtGridSelected(              self, event)
    elseif (name == "EvtPlayerIndexUpdated")         then onEvtPlayerIndexUpdated(        self, event)
    elseif (name == "EvtModelWeatherUpdated")        then onEvtModelWeatherUpdated(       self, event)
    elseif (name == "EvtMapCursorMoved")             then onEvtMapCursorMoved(            self, event)
    elseif (name == "EvtIsWaitingForServerResponse") then onEvtIsWaitingForServerResponse(self, event)
    elseif (name == "EvtWarCommandMenuUpdated")      then onEvtWarCommandMenuUpdated(     self, event)
    end

    return self
end

return ModelActionPlanner
