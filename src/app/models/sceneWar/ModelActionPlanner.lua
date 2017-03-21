
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

local Producible                  = requireBW("src.app.components.Producible")
local ActionCodeFunctions         = requireBW("src.app.utilities.ActionCodeFunctions")
local AnimationLoader             = requireBW("src.app.utilities.AnimationLoader")
local AttackableGridListFunctions = requireBW("src.app.utilities.AttackableGridListFunctions")
local GridIndexFunctions          = requireBW("src.app.utilities.GridIndexFunctions")
local LocalizationFunctions       = requireBW("src.app.utilities.LocalizationFunctions")
local MovePathFunctions           = requireBW("src.app.utilities.MovePathFunctions")
local ReachableAreaFunctions      = requireBW("src.app.utilities.ReachableAreaFunctions")
local SingletonGetters            = requireBW("src.app.utilities.SingletonGetters")
local WebSocketManager            = requireBW("src.app.utilities.WebSocketManager")
local Actor                       = requireBW("src.global.actors.Actor")

local createPathForDispatch    = MovePathFunctions.createPathForDispatch
local getLocalizedText         = LocalizationFunctions.getLocalizedText
local getModelFogMap           = SingletonGetters.getModelFogMap
local getModelMessageIndicator = SingletonGetters.getModelMessageIndicator
local getModelPlayerManager    = SingletonGetters.getModelPlayerManager
local getModelTileMap          = SingletonGetters.getModelTileMap
local getModelTurnManager      = SingletonGetters.getModelTurnManager
local getModelUnitMap          = SingletonGetters.getModelUnitMap
local getPlayerIndexLoggedIn   = SingletonGetters.getPlayerIndexLoggedIn
local getScriptEventDispatcher = SingletonGetters.getScriptEventDispatcher
local isTotalReplay            = SingletonGetters.isTotalReplay

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getPathNodesDestination(pathNodes)
    return pathNodes[#pathNodes]
end

local function getMoveCost(gridIndex, modelUnit, modelUnitMap, modelTileMap)
    if (not GridIndexFunctions.isWithinMap(gridIndex, modelUnitMap:getMapSize())) then
        return nil
    else
        local existingModelUnit = modelUnitMap:getModelUnit(gridIndex)
        if ((existingModelUnit)                                                                                                                and
            (not getModelPlayerManager(self.m_ModelSceneWar):isSameTeamIndex(existingModelUnit:getPlayerIndex(), modelUnit:getPlayerIndex()))) then
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

    local modelUnitMap             = getModelUnitMap(self.m_ModelSceneWar)
    local modelTileMap             = getModelTileMap(self.m_ModelSceneWar)
    local loaderBeginningGridIndex = focusModelUnit:getGridIndex()
    local loaderEndingGridIndex    = getPathNodesDestination(self.m_PathNodes)
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
    local nextMoveCost = getMoveCost(gridIndex, self.m_FocusModelUnit, getModelUnitMap(self.m_ModelSceneWar), getModelTileMap(self.m_ModelSceneWar))

    if ((not MovePathFunctions.truncateToGridIndex(self.m_PathNodes, gridIndex))                        and
        (not MovePathFunctions.extendToGridIndex(self.m_PathNodes, gridIndex, nextMoveCost, maxRange))) then
        self.m_PathNodes = MovePathFunctions.createShortestPath(gridIndex, self.m_ReachableArea)
    end

    if (self.m_View) then
        self.m_View:setMovePath(self.m_PathNodes)
    end
end

local function resetMovePath(self, gridIndex)
    self.m_PathNodes = {{
        x             = gridIndex.x,
        y             = gridIndex.y,
        totalMoveCost = 0,
    }}
    if (self.m_View) then
        self.m_View:setMovePath(self.m_PathNodes)
    end
end

local function resetReachableArea(self, focusModelUnit)
    self.m_ReachableArea = ReachableAreaFunctions.createArea(
        focusModelUnit:getGridIndex(),
        math.min(focusModelUnit:getMoveRange(), focusModelUnit:getCurrentFuel()),
        function(gridIndex)
            return getMoveCost(gridIndex, focusModelUnit, getModelUnitMap(self.m_ModelSceneWar), getModelTileMap(self.m_ModelSceneWar))
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
    getScriptEventDispatcher(self.m_ModelSceneWar):dispatchEvent({
        name          = "EvtPreviewBattleDamage",
        attackDamage  = attackDamage,
        counterDamage = counterDamage,
    })
end

local function dispatchEvtPreviewNoBattleDatame(self)
    getScriptEventDispatcher(self.m_ModelSceneWar):dispatchEvent({name = "EvtPreviewNoBattleDamage"})
end

--------------------------------------------------------------------------------
-- The functions for sending actions to the server.
--------------------------------------------------------------------------------
local function createAndSendAction(self, rawAction)
    local modelSceneWar = self.m_ModelSceneWar
    rawAction.warID     = SingletonGetters.getWarId(modelSceneWar)
    rawAction.actionID  = SingletonGetters.getActionId(modelSceneWar) + 1
    WebSocketManager.sendAction(rawAction)

    getModelMessageIndicator(modelSceneWar):showPersistentMessage(getLocalizedText(80, "TransferingData"))
    getScriptEventDispatcher(modelSceneWar):dispatchEvent({
        name    = "EvtIsWaitingForServerResponse",
        waiting = true,
    })
end

local function sendActionAttack(self, targetGridIndex)
    createAndSendAction(self, {
        actionCode      = ActionCodeFunctions.getActionCode("ActionAttack"),
        path            = createPathForDispatch(self.m_PathNodes),
        targetGridIndex = GridIndexFunctions.clone(targetGridIndex),
        launchUnitID    = self.m_LaunchUnitID,
    })
end

local function sendActionBuildModelTile(self)
    createAndSendAction(self, {
        actionCode   = ActionCodeFunctions.getActionCode("ActionBuildModelTile"),
        path         = createPathForDispatch(self.m_PathNodes),
        launchUnitID = self.m_LaunchUnitID,
    })
end

local function sendActionCaptureModelTile(self)
    createAndSendAction(self, {
        actionCode   = ActionCodeFunctions.getActionCode("ActionCaptureModelTile"),
        path         = createPathForDispatch(self.m_PathNodes),
        launchUnitID = self.m_LaunchUnitID,
    })
end

local function sendActionDive(self)
    createAndSendAction(self, {
        actionCode   = ActionCodeFunctions.getActionCode("ActionDive"),
        path         = createPathForDispatch(self.m_PathNodes),
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

    createAndSendAction(self, {
        actionCode       = ActionCodeFunctions.getActionCode("ActionDropModelUnit"),
        path             = createPathForDispatch(self.m_PathNodes),
        dropDestinations = dropDestinations,
        launchUnitID     = self.m_LaunchUnitID,
    })
end

local function sendActionJoinModelUnit(self)
    createAndSendAction(self, {
        actionCode   = ActionCodeFunctions.getActionCode("ActionJoinModelUnit"),
        path         = createPathForDispatch(self.m_PathNodes),
        launchUnitID = self.m_LaunchUnitID,
    })
end

local function sendActionLaunchFlare(self, gridIndex)
    createAndSendAction(self, {
        actionCode      = ActionCodeFunctions.getActionCode("ActionLaunchFlare"),
        path            = createPathForDispatch(self.m_PathNodes),
        launchUnitID    = self.m_LaunchUnitID,
        targetGridIndex = gridIndex,
    })
end

local function sendActionLaunchSilo(self, targetGridIndex)
    createAndSendAction(self, {
        actionCode      = ActionCodeFunctions.getActionCode("ActionLaunchSilo"),
        path            = createPathForDispatch(self.m_PathNodes),
        launchUnitID    = self.m_LaunchUnitID,
        targetGridIndex = targetGridIndex,
    })
end

local function sendActionLoadModelUnit(self)
    createAndSendAction(self, {
        actionCode   = ActionCodeFunctions.getActionCode("ActionLoadModelUnit"),
        path         = createPathForDispatch(self.m_PathNodes),
        launchUnitID = self.m_LaunchUnitID,
    })
end

local function sendActionProduceModelUnitOnTile(self, gridIndex, tiledID)
    createAndSendAction(self, {
        actionCode = ActionCodeFunctions.getActionCode("ActionProduceModelUnitOnTile"),
        gridIndex  = GridIndexFunctions.clone(gridIndex),
        tiledID    = tiledID,
    })
end

local function sendActionProduceModelUnitOnUnit(self)
    createAndSendAction(self, {
        actionCode = ActionCodeFunctions.getActionCode("ActionProduceModelUnitOnUnit"),
        path       = createPathForDispatch(self.m_PathNodes),
    })
end

local function sendActionSupplyModelUnit(self)
    createAndSendAction(self, {
        actionCode   = ActionCodeFunctions.getActionCode("ActionSupplyModelUnit"),
        path         = createPathForDispatch(self.m_PathNodes),
        launchUnitID = self.m_LaunchUnitID,
    })
end

local function sendActionSurface(self)
    createAndSendAction(self, {
        actionCode   = ActionCodeFunctions.getActionCode("ActionSurface"),
        path         = createPathForDispatch(self.m_PathNodes),
        launchUnitID = self.m_LaunchUnitID,
    })
end

local function sendActionWait(self)
    createAndSendAction(self, {
        actionCode   = ActionCodeFunctions.getActionCode("ActionWait"),
        path         = createPathForDispatch(self.m_PathNodes),
        launchUnitID = self.m_LaunchUnitID,
    })
end

--------------------------------------------------------------------------------
-- The functions for available action list.
--------------------------------------------------------------------------------
local setStatePreviewingAttackableArea
local setStatePreviewingReachableArea
local setStateChoosingProductionTarget
local setStateMakingMovePath
local setStateChoosingAction
local setStateChoosingAttackTarget
local setStateChoosingFlareTarget
local setStateChoosingSiloTarget
local setStateChoosingDropDestination
local setStateChoosingAdditionalDropAction

local function getActionLoadModelUnit(self)
    local destination = getPathNodesDestination(self.m_PathNodes)
    if (GridIndexFunctions.isEqual(self.m_FocusModelUnit:getGridIndex(), destination)) then
        return nil
    else
        local loaderModelUnit = getModelUnitMap(self.m_ModelSceneWar):getModelUnit(destination)
        local tileType        = getModelTileMap(self.m_ModelSceneWar):getModelTile(destination):getTileType()
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
    local existingModelUnit = getModelUnitMap(self.m_ModelSceneWar):getModelUnit(getPathNodesDestination(self.m_PathNodes))
    if ((#self.m_PathNodes > 1)                                      and
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
                setStateChoosingAttackTarget(self, getPathNodesDestination(self.m_PathNodes))
            end,
        }
    end
end

local function getActionCapture(self)
    local modelTile = getModelTileMap(self.m_ModelSceneWar):getModelTile(getPathNodesDestination(self.m_PathNodes))
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

local function getActionDive(self)
    local focusModelUnit = self.m_FocusModelUnit
    if ((focusModelUnit.canDive) and (focusModelUnit:canDive())) then
        return {
            name     = getLocalizedText(78, "Dive"),
            callback = function()
                sendActionDive(self)
            end,
        }
    end
end

local function getActionBuildModelTile(self)
    local tileType       = getModelTileMap(self.m_ModelSceneWar):getModelTile(getPathNodesDestination(self.m_PathNodes)):getTileType()
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

    local modelUnitMap = getModelUnitMap(self.m_ModelSceneWar)
    for _, gridIndex in pairs(GridIndexFunctions.getAdjacentGrids(getPathNodesDestination(self.m_PathNodes), modelUnitMap:getMapSize())) do
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

local function getActionSurface(self)
    local focusModelUnit = self.m_FocusModelUnit
    if ((focusModelUnit.isDiving) and (focusModelUnit:isDiving())) then
        return {
            name     = getLocalizedText(78, "Surface"),
            callback = function()
                sendActionSurface(self)
            end,
        }
    end
end

local function getSingleActionLaunchModelUnit(self, unitID)
    local beginningGridIndex = self.m_PathNodes[1]
    local icon               = Actor.createView("sceneWar.ViewUnit")
    icon:updateWithModelUnit(getModelUnitMap(self.m_ModelSceneWar):getFocusModelUnit(beginningGridIndex, unitID))
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
    if ((#self.m_PathNodes ~= 1)                   or
        (not focusModelUnit.canLaunchModelUnit)    or
        (not focusModelUnit:canLaunchModelUnit())) then
        return {}
    end

    local actions      = {}
    local modelUnitMap = getModelUnitMap(self.m_ModelSceneWar)
    local modelTile    = getModelTileMap(self.m_ModelSceneWar):getModelTile(getPathNodesDestination(self.m_PathNodes))
    for _, unitID in ipairs(focusModelUnit:getLoadUnitIdList()) do
        local launchModelUnit = modelUnitMap:getLoadedModelUnitWithUnitId(unitID)
        if ((launchModelUnit:isStateIdle())                        and
            (modelTile:getMoveCostWithModelUnit(launchModelUnit))) then
            actions[#actions + 1] = getSingleActionLaunchModelUnit(self, unitID)
        end
    end

    return actions
end

local function getSingleActionDropModelUnit(self, unitID)
    local icon = Actor.createView("sceneWar.ViewUnit")
    icon:updateWithModelUnit(getModelUnitMap(self.m_ModelSceneWar):getLoadedModelUnitWithUnitId(unitID))
        :ignoreAnchorPointForPosition(true)
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
    local modelTileMap          = getModelTileMap(self.m_ModelSceneWar)
    local loaderEndingGridIndex = getPathNodesDestination(self.m_PathNodes)

    if ((not focusModelUnit.getCurrentLoadCount)                                                               or
        (focusModelUnit:getCurrentLoadCount() <= #dropDestinations)                                            or
        (not focusModelUnit:canDropModelUnit(modelTileMap:getModelTile(loaderEndingGridIndex):getTileType()))) then
        return {}
    end

    local actions = {}
    local loaderBeginningGridIndex = self.m_FocusModelUnit:getGridIndex()
    local modelUnitMap             = getModelUnitMap(self.m_ModelSceneWar)

    for _, unitID in ipairs(focusModelUnit:getLoadUnitIdList()) do
        if (not isModelUnitDropped(unitID, dropDestinations)) then
            local droppingModelUnit = getModelUnitMap(self.m_ModelSceneWar):getLoadedModelUnitWithUnitId(unitID)
            if (#getAvailableDropGrids(droppingModelUnit, loaderBeginningGridIndex, loaderEndingGridIndex, modelUnitMap, modelTileMap, dropDestinations) > 0) then
                actions[#actions + 1] = getSingleActionDropModelUnit(self, unitID)
            end
        end
    end

    return actions
end

local function getActionLaunchFlare(self)
    local focusModelUnit = self.m_FocusModelUnit
    if ((not getModelFogMap(self.m_ModelSceneWar):isFogOfWarCurrently()) or
        (#self.m_PathNodes ~= 1)                                         or
        (not focusModelUnit.getCurrentFlareAmmo)                         or
        (focusModelUnit:getCurrentFlareAmmo() == 0))                     then
        return nil
    else
        return {
            name     = getLocalizedText(78, "LaunchFlare"),
            callback = function()
                setStateChoosingFlareTarget(self)
            end,
        }
    end
end

local function getActionLaunchSilo(self)
    local focusModelUnit = self.m_FocusModelUnit
    local modelTile      = getModelTileMap(self.m_ModelSceneWar):getModelTile(getPathNodesDestination(self.m_PathNodes))

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
        (#self.m_PathNodes ~= 1)                         or
        (not focusModelUnit.getCurrentMaterial)          or
        (not focusModelUnit.getMovableProductionTiledId) or
        (not focusModelUnit.getCurrentLoadCount))        then
        return nil
    else
        local produceTiledId     = focusModelUnit:getMovableProductionTiledId()
        local modelPlayerManager = getModelPlayerManager(self.m_ModelSceneWar)
        local fund               = modelPlayerManager:getModelPlayer(getPlayerIndexLoggedIn(self.m_ModelSceneWar)):getFund()
        local icon               = cc.Sprite:create()
        icon:setAnchorPoint(0, 0)
            :setScale(0.5)
            :playAnimationForever(AnimationLoader.getUnitAnimationWithTiledId(produceTiledId))

        return {
            name        = string.format("%s\n%d",
                getLocalizedText(78, "ProduceModelUnitOnUnit"),
                Producible.getProductionCostWithTiledId(produceTiledId, modelPlayerManager)
            ),
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
    local existingUnitModel = getModelUnitMap(self.m_ModelSceneWar):getModelUnit(getPathNodesDestination(self.m_PathNodes))
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
    list[#list + 1] = getActionDive(                  self)
    list[#list + 1] = getActionSurface(               self)
    list[#list + 1] = getActionBuildModelTile(        self)
    list[#list + 1] = getActionSupplyModelUnit(       self)
    for _, action in ipairs(getActionsLaunchModelUnit(self)) do
        list[#list + 1] = action
    end
    for _, action in ipairs(getActionsDropModelUnit(self)) do
        list[#list + 1] = action
    end
    list[#list + 1] = getActionLaunchFlare(           self)
    list[#list + 1] = getActionLaunchSilo(            self)
    list[#list + 1] = getActionProduceModelUnitOnUnit(self)

    local itemWait = getActionWait(self)
    assert((#list > 0) or (itemWait), "ModelActionPlanner-getAvailableActionList() the generated list has no valid action item.")
    return list, itemWait
end

local function getAdditionalDropActionList(self)
    local list = {}
    for _, action in ipairs(getActionsDropModelUnit(self)) do
        list[#list + 1] = action
    end

    return list, {
        name     = getLocalizedText(78, "Wait"),
        callback = function()
            sendActionDropModelUnit(self)
        end,
    }
end

--------------------------------------------------------------------------------
-- The set state functions.
--------------------------------------------------------------------------------
local function canSetStatePreviewingAttackableArea(self, gridIndex)
    local modelSceneWar = self.m_ModelSceneWar
    local modelUnit     = getModelUnitMap(modelSceneWar):getModelUnit(gridIndex)
    if ((not modelUnit) or (not modelUnit.getAttackRangeMinMax)) then
        return false
    elseif ((isTotalReplay(modelSceneWar)) or (not modelUnit:isStateIdle())) then
        return true
    else
        local playerIndexLoggedIn = getPlayerIndexLoggedIn(modelSceneWar)
        return (playerIndexLoggedIn ~= modelUnit:getPlayerIndex()) or (playerIndexLoggedIn ~= getModelTurnManager(modelSceneWar):getPlayerIndex())
    end
end

setStatePreviewingAttackableArea = function(self, gridIndex)
    self.m_State = "previewingAttackableArea"
    local modelUnit = getModelUnitMap(self.m_ModelSceneWar):getModelUnit(gridIndex)
    for _, existingModelUnit in pairs(self.m_PreviewAttackModelUnits) do
        if (modelUnit == existingModelUnit) then
            return
        end
    end

    self.m_PreviewAttackModelUnits[#self.m_PreviewAttackModelUnits + 1] = modelUnit
    self.m_PreviewAttackableArea = AttackableGridListFunctions.createAttackableArea(gridIndex, getModelTileMap(self.m_ModelSceneWar), getModelUnitMap(self.m_ModelSceneWar), self.m_PreviewAttackableArea)

    if (self.m_View) then
        self.m_View:setPreviewAttackableArea(self.m_PreviewAttackableArea)
            :setPreviewAttackableAreaVisible(true)
        modelUnit:showMovingAnimation()
    end
end

local function canSetStatePreviewingReachableArea(self, gridIndex)
    local modelSceneWar = self.m_ModelSceneWar
    local modelUnit     = getModelUnitMap(modelSceneWar):getModelUnit(gridIndex)
    if ((not modelUnit) or (modelUnit.getAttackRangeMinMax)) then
        return false
    elseif ((isTotalReplay(modelSceneWar)) or (not modelUnit:isStateIdle())) then
        return true
    else
        local playerIndexLoggedIn = getPlayerIndexLoggedIn(modelSceneWar)
        return (playerIndexLoggedIn ~= modelUnit:getPlayerIndex()) or (playerIndexLoggedIn ~= getModelTurnManager(modelSceneWar):getPlayerIndex())
    end
end

setStatePreviewingReachableArea = function(self, gridIndex)
    self.m_State = "previewingReachableArea"

    local modelUnit              = getModelUnitMap(self.m_ModelSceneWar):getModelUnit(gridIndex)
    self.m_PreviewReachModelUnit = modelUnit
    self.m_PreviewReachableArea  = ReachableAreaFunctions.createArea(
        gridIndex,
        math.min(modelUnit:getMoveRange(), modelUnit:getCurrentFuel()),
        function(gridIndex)
            return getMoveCost(gridIndex, modelUnit, getModelUnitMap(self.m_ModelSceneWar), getModelTileMap(self.m_ModelSceneWar))
        end
    )

    if (self.m_View) then
        self.m_View:setPreviewReachableArea(self.m_PreviewReachableArea)
            :setPreviewReachableAreaVisible(true)
        modelUnit:showMovingAnimation()
    end
end

local function canSetStateChoosingProductionTarget(self, gridIndex)
    if (isTotalReplay(self.m_ModelSceneWar)) then
        return false
    else
        local playerIndexLoggedIn = getPlayerIndexLoggedIn(self.m_ModelSceneWar)
        local modelTurnManager    = getModelTurnManager(self.m_ModelSceneWar)
        if ((modelTurnManager:getPlayerIndex() ~= playerIndexLoggedIn) or
            (not modelTurnManager:isTurnPhaseMain()))                  then
            return false
        else
            local modelTile = getModelTileMap(self.m_ModelSceneWar):getModelTile(gridIndex)
            return (not getModelUnitMap(self.m_ModelSceneWar):getModelUnit(gridIndex))  and
                (modelTile:getPlayerIndex() == playerIndexLoggedIn) and
                (modelTile.getProductionList)
        end
    end
end

setStateChoosingProductionTarget = function(self, gridIndex)
    self.m_State = "choosingProductionTarget"
    local modelTile      = getModelTileMap(self.m_ModelSceneWar):getModelTile(gridIndex)
    local productionList = modelTile:getProductionList()

    for _, listItem in ipairs(productionList) do
        listItem.callback = function()
            sendActionProduceModelUnitOnTile(self, gridIndex, listItem.tiledID)
        end
    end

    getScriptEventDispatcher(self.m_ModelSceneWar):dispatchEvent({
        name           = "EvtActionPlannerChoosingProductionTarget",
        productionList = productionList,
    })
end

local function canSetStateMakingMovePath(self, beginningGridIndex, launchUnitID)
    if (isTotalReplay(self.m_ModelSceneWar)) then
        return false
    else
        local playerIndexLoggedIn = getPlayerIndexLoggedIn(self.m_ModelSceneWar)
        local modelTurnManager    = getModelTurnManager(self.m_ModelSceneWar)
        if ((modelTurnManager:getPlayerIndex() ~= playerIndexLoggedIn) or
            (not modelTurnManager:isTurnPhaseMain()))                  then
            return false
        else
            local modelUnit = getModelUnitMap(self.m_ModelSceneWar):getFocusModelUnit(beginningGridIndex, launchUnitID)
            return (modelUnit) and (modelUnit:isStateIdle()) and (modelUnit:getPlayerIndex() == playerIndexLoggedIn)
        end
    end
end

setStateMakingMovePath = function(self, beginningGridIndex, launchUnitID)
    local focusModelUnit = getModelUnitMap(self.m_ModelSceneWar):getFocusModelUnit(beginningGridIndex, launchUnitID)
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
            getModelUnitMap(self.m_ModelSceneWar):setPreviewLaunchUnit(focusModelUnit, beginningGridIndex)
                :setPreviewLaunchUnitVisible(true)
        else
            getModelUnitMap(self.m_ModelSceneWar):setPreviewLaunchUnitVisible(false)
        end
    end

    getScriptEventDispatcher(self.m_ModelSceneWar):dispatchEvent({name = "EvtActionPlannerMakingMovePath"})
end

setStateChoosingAction = function(self, destination, launchUnitID)
    local beginningGridIndex = self.m_PathNodes[1]
    local focusModelUnit     = getModelUnitMap(self.m_ModelSceneWar):getFocusModelUnit(beginningGridIndex, launchUnitID)
    if (self.m_FocusModelUnit ~= focusModelUnit) then
        self.m_FocusModelUnit  = focusModelUnit
        destination            = beginningGridIndex
        resetReachableArea(self, focusModelUnit)
    end

    updateMovePathWithDestinationGrid(self, destination)
    self.m_State              = "choosingAction"
    self.m_AttackableGridList = AttackableGridListFunctions.createList(self.m_ModelSceneWar, self.m_PathNodes, launchUnitID)
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
            :setFlareGridsVisible(false)

        if (not launchUnitID) then
            getModelUnitMap(self.m_ModelSceneWar):setPreviewLaunchUnitVisible(false)
        end
    end

    local list, itemWait = getAvailableActionList(self)
    getScriptEventDispatcher(self.m_ModelSceneWar):dispatchEvent({
        name     = "EvtActionPlannerChoosingAction",
        list     = list,
        itemWait = itemWait,
    })
end

setStateChoosingAttackTarget = function(self, destination)
    self.m_State = "choosingAttackTarget"

    if (self.m_View) then
        self.m_View:setAttackableGrids(self.m_AttackableGridList)
            :setAttackableGridsVisible(true)
    end

    getScriptEventDispatcher(self.m_ModelSceneWar):dispatchEvent({name = "EvtActionPlannerChoosingAttackTarget"})
end

setStateChoosingFlareTarget = function(self)
    self.m_State = "choosingFlareTarget"

    if (self.m_View) then
        self.m_View:setFlareGrids(getPathNodesDestination(self.m_PathNodes), self.m_FocusModelUnit:getMaxFlareRange())
            :setFlareGridsVisible(true)
    end

    getScriptEventDispatcher(self.m_ModelSceneWar):dispatchEvent({name = "EvtActionPlannerChoosingFlareTarget"})
end

setStateChoosingSiloTarget = function(self)
    self.m_State = "choosingSiloTarget"

    getScriptEventDispatcher(self.m_ModelSceneWar):dispatchEvent({name = "EvtActionPlannerChoosingSiloTarget"})
end

setStateChoosingDropDestination = function(self, unitID)
    self.m_State = "choosingDropDestination"

    local droppingModelUnit   = getModelUnitMap(self.m_ModelSceneWar):getLoadedModelUnitWithUnitId(unitID)
    self.m_AvailableDropGrids = getAvailableDropGrids(droppingModelUnit, self.m_FocusModelUnit:getGridIndex(), getPathNodesDestination(self.m_PathNodes), getModelUnitMap(self.m_ModelSceneWar), getModelTileMap(self.m_ModelSceneWar), self.m_SelectedDropDestinations)
    self.m_DroppingUnitID     = unitID

    if (self.m_View) then
        self.m_View:setDroppableGrids(self.m_AvailableDropGrids)
            :setDroppableGridsVisible(true)
            :setDropDestinations(self.m_SelectedDropDestinations)
            :setDropDestinationsVisible(true)
            :setPreviewDropDestinationVisible(false)
    end

    getScriptEventDispatcher(self.m_ModelSceneWar):dispatchEvent({name = "EvtActionPlannerChoosingDropDestination"})
end

setStateChoosingAdditionalDropAction = function(self)
    self.m_State = "choosingAdditionalDropAction"

    if (self.m_View) then
        self.m_View:setDroppableGridsVisible( false)
            :setPreviewDropDestinationVisible(false)
            :setDropDestinations(self.m_SelectedDropDestinations)
            :setDropDestinationsVisible(true)
    end

    local list, itemWait = getAdditionalDropActionList(self)
    getScriptEventDispatcher(self.m_ModelSceneWar):dispatchEvent({
        name     = "EvtActionPlannerChoosingAction",
        list     = list,
        itemWait = itemWait,
    })
end

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtPlayerIndexUpdated(self, event)
    self:setStateIdle(true)
end

local function onEvtIsWaitingForServerResponse(self, event)
    self:setStateIdle(false)
    self.m_IsWaitingForServerResponse = event.waiting
end

local function onEvtWarCommandMenuUpdated(self, event)
    if (event.modelWarCommandMenu:isEnabled()) then
        self:setStateIdle(not self.m_IsWaitingForServerResponse)
    end
end

local function onEvtMapCursorMoved(self, event)
    if ((isTotalReplay(self.m_ModelSceneWar))                                                     or
        (self.m_IsWaitingForServerResponse)                                                       or
        (getModelTurnManager(self.m_ModelSceneWar):getPlayerIndex() ~= getPlayerIndexLoggedIn(self.m_ModelSceneWar))) then
        return
    end

    local state     = self.m_State
    local gridIndex = event.gridIndex

    if (state == "choosingProductionTarget") then
        self:setStateIdle(true)
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
                self.m_View:setPreviewDropDestination(gridIndex, getModelUnitMap(self.m_ModelSceneWar):getLoadedModelUnitWithUnitId(self.m_DroppingUnitID))
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
        self:setStateIdle(true)
    elseif (state == "makingMovePath") then
        if (not ReachableAreaFunctions.getAreaNode(self.m_ReachableArea, gridIndex)) then
            if (self.m_LaunchUnitID) then
                setStateChoosingAction(self, self.m_PathNodes[1])
            else
                self:setStateIdle(true)
            end
        elseif (canUnitStayInGrid(self.m_FocusModelUnit, gridIndex, getModelUnitMap(self.m_ModelSceneWar), getModelTileMap(self.m_ModelSceneWar))) then
            if ((self.m_LaunchUnitID) and (GridIndexFunctions.isEqual(self.m_FocusModelUnit:getGridIndex(), gridIndex))) then
                setStateChoosingAction(self, self.m_PathNodes[1])
            else
                setStateChoosingAction(self, gridIndex, self.m_LaunchUnitID)
            end
        end
    elseif (state == "choosingAction") then
        setStateMakingMovePath(self, self.m_PathNodes[1], self.m_LaunchUnitID)
    elseif (state == "choosingAttackTarget") then
        local listNode = AttackableGridListFunctions.getListNode(self.m_AttackableGridList, gridIndex)
        if (not listNode) then
            setStateChoosingAction(self, getPathNodesDestination(self.m_PathNodes), self.m_LaunchUnitID)
        else
            if (GridIndexFunctions.isEqual(self.m_CursorGridIndex, gridIndex)) then
                sendActionAttack(self, gridIndex)
            else
                dispatchEvtPreviewBattleDamage(self, listNode.estimatedAttackDamage, listNode.estimatedCounterDamage)
            end
        end
    elseif (state == "choosingFlareTarget") then
        local destination = getPathNodesDestination(self.m_PathNodes)
        if (GridIndexFunctions.getDistance(gridIndex, destination) > self.m_FocusModelUnit:getMaxFlareRange()) then
            setStateChoosingAction(self, destination, self.m_LaunchUnitID)
        elseif (GridIndexFunctions.isEqual(gridIndex, self.m_CursorGridIndex)) then
            sendActionLaunchFlare(self, gridIndex)
        end
    elseif (state == "choosingSiloTarget") then
        if (GridIndexFunctions.isEqual(gridIndex, self.m_CursorGridIndex)) then
            sendActionLaunchSilo(self, gridIndex)
        elseif (GridIndexFunctions.getDistance(gridIndex, self.m_CursorGridIndex) > 2) then
            setStateChoosingAction(self, getPathNodesDestination(self.m_PathNodes), self.m_LaunchUnitID)
        end
    elseif (state == "choosingDropDestination") then
        if (isDropGridAvailable(gridIndex, self.m_AvailableDropGrids)) then
            pushBackDropDestination(self.m_SelectedDropDestinations, self.m_DroppingUnitID, gridIndex, getModelUnitMap(self.m_ModelSceneWar):getLoadedModelUnitWithUnitId(self.m_DroppingUnitID))
            if (not canDoAdditionalDropAction(self)) then
                sendActionDropModelUnit(self)
            else
                setStateChoosingAdditionalDropAction(self)
            end
        else
            if (#self.m_SelectedDropDestinations == 0) then
                setStateChoosingAction(self, getPathNodesDestination(self.m_PathNodes), self.m_LaunchUnitID)
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
            self:setStateIdle(true)
        end
    elseif (state == "previewingReachableArea") then
        self:setStateIdle(true)
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

--------------------------------------------------------------------------------
-- The callback functions on start running/script events.
--------------------------------------------------------------------------------
function ModelActionPlanner:onStartRunning(modelSceneWar)
    self.m_ModelSceneWar    = modelSceneWar
    getScriptEventDispatcher(modelSceneWar)
        :addEventListener("EvtGridSelected",               self)
        :addEventListener("EvtMapCursorMoved",             self)
        :addEventListener("EvtPlayerIndexUpdated",         self)
        :addEventListener("EvtIsWaitingForServerResponse", self)
        :addEventListener("EvtWarCommandMenuUpdated",      self)

    if (self.m_View) then
        self.m_View:setMapSize(getModelTileMap(modelSceneWar):getMapSize())
    end
    self:setStateIdle(true)

    return self
end

function ModelActionPlanner:onEvent(event)
    local name = event.name
    if     (name == "EvtGridSelected")               then onEvtGridSelected(              self, event)
    elseif (name == "EvtPlayerIndexUpdated")         then onEvtPlayerIndexUpdated(        self, event)
    elseif (name == "EvtMapCursorMoved")             then onEvtMapCursorMoved(            self, event)
    elseif (name == "EvtIsWaitingForServerResponse") then onEvtIsWaitingForServerResponse(self, event)
    elseif (name == "EvtWarCommandMenuUpdated")      then onEvtWarCommandMenuUpdated(     self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelActionPlanner:setStateIdle(resetUnitAnimation)
    if (self.m_View) then
        self.m_View:setReachableAreaVisible(  false)
            :setAttackableGridsVisible(       false)
            :setMovePathVisible(              false)
            :setMovePathDestinationVisible(   false)
            :setDroppableGridsVisible(        false)
            :setPreviewDropDestinationVisible(false)
            :setDropDestinationsVisible(      false)
            :setPreviewAttackableAreaVisible( false)
            :setPreviewReachableAreaVisible(  false)
            :setFlareGridsVisible(            false)

        getModelUnitMap(self.m_ModelSceneWar):setPreviewLaunchUnitVisible(false)
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

    getScriptEventDispatcher(self.m_ModelSceneWar):dispatchEvent({name = "EvtActionPlannerIdle"})

    return self
end

return ModelActionPlanner
