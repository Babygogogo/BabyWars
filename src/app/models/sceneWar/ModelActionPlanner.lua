
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

local GridIndexFunctions          = require("app.utilities.GridIndexFunctions")
local ReachableAreaFunctions      = require("app.utilities.ReachableAreaFunctions")
local MovePathFunctions           = require("app.utilities.MovePathFunctions")
local AttackableGridListFunctions = require("app.utilities.AttackableGridListFunctions")
local WebSocketManager            = require("app.utilities.WebSocketManager")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getMoveCost(gridIndex, modelUnit, modelUnitMap, modelTileMap, modelPlayer)
    local existingUnit = modelUnitMap:getModelUnit(gridIndex)
    if ((existingUnit) and (existingUnit:getPlayerIndex() ~= modelUnit:getPlayerIndex())) then
        return nil
    else
        local modelTile = modelTileMap:getModelTile(gridIndex)
        return (modelTile) and (modelTile:getMoveCost(modelUnit:getMoveType(), modelPlayer)) or (nil)
    end
end

local function getMoveRange(modelUnit, modelPlayer, modelWeather)
    return math.min(modelUnit:getMoveRange(modelPlayer, modelWeather), modelUnit:getCurrentFuel())
end

local function canUnitStayInGrid(modelUnit, gridIndex, modelUnitMap)
    if (GridIndexFunctions.isEqual(modelUnit:getGridIndex(), gridIndex)) then
        return true
    else
        local existingModelUnit = modelUnitMap:getModelUnit(gridIndex)
        return (not existingModelUnit) or
               (existingModelUnit:canJoin(modelUnit)) or
               (existingModelUnit.canLoad and existingModelUnit:canLoad(modelUnit))
    end
end

--------------------------------------------------------------------------------
-- The functions for MovePath.
--------------------------------------------------------------------------------
local function updateMovePathWithDestinationGrid(self, gridIndex)
    local maxRange     = getMoveRange(self.m_FocusModelUnit, self.m_ModelPlayerLoggedIn, self.m_ModelWeather)
    local nextMoveCost = getMoveCost(gridIndex, self.m_FocusModelUnit, self.m_ModelUnitMap, self.m_ModelTileMap, self.m_ModelPlayerLoggedIn)

    if ((not MovePathFunctions.truncateToGridIndex(self.m_MovePath, gridIndex)) and
        (not MovePathFunctions.extendToGridIndex(self.m_MovePath, gridIndex, nextMoveCost, maxRange))) then
        self.m_MovePath = MovePathFunctions.createShortestPath(gridIndex, self.m_ReachableArea)
    end
end

local function resetMovePath(self, focusModelUnit)
    if (self.m_FocusModelUnit ~= focusModelUnit) or (self.m_State == "idle") then
        self.m_MovePath       = {{
            gridIndex     = GridIndexFunctions.clone(focusModelUnit:getGridIndex()),
            totalMoveCost = 0,
        }}
        if (self.m_View) then
            self.m_View:setMovePath(self.m_MovePath)
        end
    end
end

--------------------------------------------------------------------------------
-- The functions for ReachableArea.
--------------------------------------------------------------------------------
local function resetReachableArea(self, focusModelUnit)
    if (self.m_FocusModelUnit ~= focusModelUnit) or (self.m_State == "idle") then
        self.m_ReachableArea = ReachableAreaFunctions.createArea(
            focusModelUnit:getGridIndex(),
            getMoveRange(focusModelUnit, self.m_ModelPlayerLoggedIn, self.m_ModelWeather),
            function(gridIndex)
                return getMoveCost(gridIndex, focusModelUnit, self.m_ModelUnitMap, self.m_ModelTileMap, self.m_ModelPlayerLoggedIn)
            end)

        if (self.m_View) then
            self.m_View:setReachableGrids(self.m_ReachableArea)
        end
    end
end

--------------------------------------------------------------------------------
-- The functions for dispatching EvtPlayerRequestDoAction.
--------------------------------------------------------------------------------
local function dispatchEventJoin(self)
    print("The Join action is selected, but not implemented.")
end

local function dispatchEventAttack(self, targetGridIndex)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name            = "EvtPlayerRequestDoAction",
        actionName      = "Attack",
        path            = self.m_MovePath,
        targetGridIndex = GridIndexFunctions.clone(targetGridIndex),
    })
end

local function dispatchEventCapture(self)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name       = "EvtPlayerRequestDoAction",
        actionName = "Capture",
        path       = self.m_MovePath,
    })
end

local function dispatchEventWait(self)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name       = "EvtPlayerRequestDoAction",
        actionName = "Wait",
        path       = self.m_MovePath,
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

--------------------------------------------------------------------------------
-- The functions for avaliable action list.
--------------------------------------------------------------------------------
local setStateIdle, setStateChoosingProductionTarget, setStateMakingMovePath, setStateChoosingAction, setStateChoosingAttackTarget

local function getActionJoin(self, destination)
    if (not GridIndexFunctions.isEqual(self.m_FocusModelUnit:getGridIndex(), destination)) then
        local existingUnitModel = self.m_ModelUnitMap:getModelUnit(destination)
        if (existingUnitModel and existingUnitModel:canJoin(self.m_FocusModelUnit)) then
            return {
                name     = "Join",
                callback = function()
                    dispatchEventJoin(self)
                end
            }
        end
    else
        return nil
    end
end

local function getActionAttack(self, destination)
    if (#self.m_AttackableGridList > 0) then
        return {
            name     = "Attack",
            callback = function()
                setStateChoosingAttackTarget(self, destination)
            end
        }
    end
end

local function getActionCapture(self, destination)
    local modelTile = self.m_ModelTileMap:getModelTile(destination)
    if ((self.m_FocusModelUnit.canCapture) and (self.m_FocusModelUnit:canCapture(modelTile))) then
        return {
            name     = "Capture",
            callback = function()
                dispatchEventCapture(self)
            end,
        }
    else
        return nil
    end
end

local function getActionWait(self, destination)
    local existingUnitModel = self.m_ModelUnitMap:getModelUnit(destination)
    if (not existingUnitModel) or (self.m_FocusModelUnit == existingUnitModel) then
        return {
            name = "Wait",
            callback = function()
                dispatchEventWait(self)
            end
        }
    else
        return nil
    end
end

local function getAvaliableActionList(self, destination)
    local actionJoin = getActionJoin(self, destination)
    if (actionJoin) then
        return {actionJoin}
    end

    local list = {}
    list[#list + 1] = getActionAttack( self, destination)
    list[#list + 1] = getActionCapture(self, destination)
    list[#list + 1] = getActionWait(   self, destination)

    assert(#list > 0, "ModelActionPlanner-getAvaliableActionList() the generated list has no valid action item.")
    return list
end

--------------------------------------------------------------------------------
-- The set state functions.
--------------------------------------------------------------------------------
setStateIdle = function(self)
    self.m_State          = "idle"
    self.m_FocusModelUnit = nil

    if (self.m_View) then
        self.m_View:setReachableGridsVisible(false)
            :setAttackableGridsVisible(false)
            :setMovePathVisible(false)
            :setMovePathDestinationVisible(false)
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtActionPlannerIdle"})
end

setStateChoosingProductionTarget = function(self, modelTile)
    self.m_State = "choosingProductionTarget"
    local productionList = modelTile:getProductionList(self.m_ModelPlayerLoggedIn)
    local gridIndex      = modelTile:getGridIndex()

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

setStateMakingMovePath = function(self, focusModelUnit)
    resetReachableArea(self, focusModelUnit)
    resetMovePath(     self, focusModelUnit)
    self.m_State          = "makingMovePath"
    self.m_FocusModelUnit = focusModelUnit

    if (self.m_View) then
        self.m_View:setReachableGridsVisible(true)
            :setAttackableGridsVisible(false)
            :setMovePathVisible(true)
            :setMovePathDestinationVisible(false)
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtActionPlannerMakingMovePath"})
end

setStateChoosingAction = function(self, destination)
    updateMovePathWithDestinationGrid(self, destination)
    self.m_Destination        = destination or self.m_Destination
    self.m_AttackableGridList = AttackableGridListFunctions.createList(self.m_FocusModelUnit, self.m_Destination, self.m_ModelTileMap, self.m_ModelUnitMap)
    self.m_State              = "choosingAction"

    if (self.m_View) then
        self.m_View:setReachableGridsVisible(false)
            :setAttackableGridsVisible(false)
            :setMovePath(self.m_MovePath)
            :setMovePathVisible(true)
            :setMovePathDestination(self.m_Destination)
            :setMovePathDestinationVisible(true)
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtActionPlannerChoosingAction", list = getAvaliableActionList(self, destination)})
end

setStateChoosingAttackTarget = function(self, destination)
    self.m_State = "choosingAttackTarget"

    if (self.m_View) then
        self.m_View:setAttackableGrids(self.m_AttackableGridList)
            :setAttackableGridsVisible(true)
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtActionPlannerChoosingAttackTarget"})
end

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtPlayerIndexUpdated(self, event)
    self.m_PlayerIndexInTurn = event.playerIndex
    setStateIdle(self)
end

local function onEvtModelWeatherUpdated(self, event)
    self.m_ModelWeather = event.modelWeather
end

local function onEvtPlayerRequestDoAction(self, event)
    setStateIdle(self)
end

local function onEvtPlayerMovedCursor(self, event)
    if (self.m_PlayerIndexInTurn ~= self.m_PlayerIndexLoggedIn) then
        return
    end

    local state     = self.m_State
    local gridIndex = event.gridIndex

    if (state == "idle") then
        return
    elseif (state == "choosingProductionTarget") then
        setStateIdle(self)
    elseif (state == "makingMovePath") then
        if (ReachableAreaFunctions.getAreaNode(self.m_ReachableArea, gridIndex)) then
            updateMovePathWithDestinationGrid(self, gridIndex)
            if (self.m_View) then
                self.m_View:setMovePath(self.m_MovePath)
                    :setMovePathVisible(true)
            end
        end
    elseif (state == "choosingAttackTarget") then
        local listNode = AttackableGridListFunctions.getListNode(self.m_AttackableGridList, gridIndex)
        if (listNode) then
            self.m_RootScriptEventDispatcher:dispatchEvent({
                name          = "EvtPlayerPreviewAttackTarget",
                attackDamage  = listNode.estimatedAttackDamage,
                counterDamage = listNode.estimatedCounterDamage
            })
        else
            self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtPlayerPreviewNoAttackTarget"})
        end
    end
end

local function onEvtGridSelected(self, event)
    if (self.m_PlayerIndexInTurn ~= self.m_PlayerIndexLoggedIn) then
        return
    end

    local state     = self.m_State
    local gridIndex = event.gridIndex

    if (state == "idle") then
        local modelUnit = self.m_ModelUnitMap:getModelUnit(gridIndex)
        if (modelUnit) then
            if (modelUnit:canDoAction(self.m_PlayerIndexLoggedIn)) then
                modelUnit:showMovingAnimation()
                setStateMakingMovePath(self, modelUnit)
            end
        else
            local modelTile = self.m_ModelTileMap:getModelTile(gridIndex)
            if ((modelTile:getPlayerIndex() == self.m_PlayerIndexLoggedIn) and (modelTile.getProductionList)) then
                setStateChoosingProductionTarget(self, modelTile)
            end
        end
    elseif (state == "choosingProductionTarget") then
        setStateIdle(self)
    elseif (state == "makingMovePath") then
        if (not ReachableAreaFunctions.getAreaNode(self.m_ReachableArea, gridIndex)) then
            self.m_FocusModelUnit:showNormalAnimation()
            setStateIdle(self)
        elseif (canUnitStayInGrid(self.m_FocusModelUnit, gridIndex, self.m_ModelUnitMap)) then
            setStateChoosingAction(self, gridIndex)
        end
    elseif (state == "choosingAction") then
        setStateMakingMovePath(self, self.m_FocusModelUnit)
    elseif (state == "choosingAttackTarget") then
        if (AttackableGridListFunctions.getListNode(self.m_AttackableGridList, gridIndex)) then
            dispatchEventAttack(self, gridIndex)
        else
            setStateChoosingAction(self, self.m_Destination)
        end
    else
        error("ModelActionPlanner-onEvtGridSelected() the state of the planner is invalid.")
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelActionPlanner:ctor(param)
    self.m_State = "idle"

    return self
end

function ModelActionPlanner:initView()
    assert(self.m_View, "ModelActionPlanner:initView() no view is attached to the owner actor of the model.")

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

    return self
end

function ModelActionPlanner:setModelPlayerManager(modelPlayerManager)
    local playerAccount = WebSocketManager.getLoggedInAccountAndPassword()
    modelPlayerManager:forEachModelPlayer(function(modelPlayer, playerIndex)
        if (modelPlayer:getAccount() == playerAccount) then
            self.m_ModelPlayerLoggedIn = modelPlayer
            self.m_PlayerIndexLoggedIn = playerIndex
        end
    end)

    self.m_ModelPlayerManager = modelPlayerManager

    return self
end

function ModelActionPlanner:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelActionPlanner:setRootScriptEventDispatcher() the dispatcher has been set already.")

    self.m_RootScriptEventDispatcher = dispatcher
    dispatcher:addEventListener("EvtGridSelected",    self)
        :addEventListener("EvtPlayerMovedCursor",     self)
        :addEventListener("EvtPlayerIndexUpdated",    self)
        :addEventListener("EvtModelWeatherUpdated",   self)
        :addEventListener("EvtPlayerRequestDoAction", self)

    return self
end

function ModelActionPlanner:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "ModelActionPlanner:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")

    self.m_RootScriptEventDispatcher:removeEventListener("EvtPlayerRequestDoAction", self)
        :removeEventListener("EvtModelWeatherUpdated", self)
        :removeEventListener("EvtPlayerIndexUpdated",  self)
        :removeEventListener("EvtPlayerMovedCursor",   self)
        :removeEventListener("EvtGridSelected",        self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
function ModelActionPlanner:onEvent(event)
    local name = event.name
    if (name == "EvtGridSelected") then
        onEvtGridSelected(self, event)
    elseif (name == "EvtPlayerIndexUpdated") then
        onEvtPlayerIndexUpdated(self, event)
    elseif (name == "EvtModelWeatherUpdated") then
        onEvtModelWeatherUpdated(self, event)
    elseif (name == "EvtPlayerMovedCursor") then
        onEvtPlayerMovedCursor(self, event)
    elseif (name == "EvtPlayerRequestDoAction") then
        onEvtPlayerRequestDoAction(self, event)
    end

    return self
end

return ModelActionPlanner
