
local ModelActionPlanner = class("ModelActionPlanner")

local GridIndexFunctions          = require("app.utilities.GridIndexFunctions")
local ReachableAreaFunctions      = require("app.utilities.ReachableAreaFunctions")
local MovePathFunctions           = require("app.utilities.MovePathFunctions")
local AttackableGridListFunctions = require("app.utilities.AttackableGridListFunctions")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getMoveCost(gridIndex, modelUnit, modelUnitMap, modelTileMap)
    local existingUnit = modelUnitMap:getModelUnit(gridIndex)
    if ((existingUnit) and (existingUnit:getPlayerIndex() ~= modelUnit:getPlayerIndex())) then
        return nil
    end

    local modelTile = modelTileMap:getModelTile(gridIndex)
    return (modelTile) and (modelTile:getMoveCost(modelUnit:getMoveType())) or (nil)
end

local function canUnitStayInGrid(unitModel, gridIndex, unitMapModel)
    if (GridIndexFunctions.isEqual(unitModel:getGridIndex(), gridIndex)) then
        return true
    else
        local existingUnitModel = unitMapModel:getModelUnit(gridIndex)
        return (not existingUnitModel) or
               (existingUnitModel:canJoin(unitModel)) or
               (existingUnitModel.canLoad and existingUnitModel:canLoad(unitModel))
    end
end

--------------------------------------------------------------------------------
-- The functions for MovePath.
--------------------------------------------------------------------------------
local function updateMovePathWithDestinationGrid(self, gridIndex)
    local maxRange     = self.m_FocusModelUnit:getMoveRange(self.m_FocusModelUnit:getCurrentFuel())
    local nextMoveCost = getMoveCost(gridIndex, self.m_FocusModelUnit, self.m_ModelUnitMap, self.m_ModelTileMap)

    if ((not MovePathFunctions.truncateToGridIndex(self.m_MovePath, gridIndex)) and
        (not MovePathFunctions.extendToGridIndex(self.m_MovePath, gridIndex, nextMoveCost, maxRange))) then
        self.m_MovePath = MovePathFunctions.createShortestPath(gridIndex, self.m_ReachableArea)
    end
end

local function resetMovePath(self, focusUnitModel)
    if (self.m_FocusModelUnit ~= focusUnitModel) or (self.m_State == "idle") then
        self.m_MovePath       = {{
            gridIndex     = GridIndexFunctions.clone(focusUnitModel:getGridIndex()),
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
local function resetReachableArea(self, focusUnitModel)
    if (self.m_FocusModelUnit ~= focusUnitModel) or (self.m_State == "idle") then
        self.m_ReachableArea = ReachableAreaFunctions.createArea(focusUnitModel:getGridIndex(), focusUnitModel:getMoveRange(focusUnitModel:getCurrentFuel()), function(gridIndex)
            return getMoveCost(gridIndex, focusUnitModel, self.m_ModelUnitMap, self.m_ModelTileMap)
        end)

        if (self.m_View) then
            self.m_View:setReachableGrids(self.m_ReachableArea)
        end
    end
end

--------------------------------------------------------------------------------
-- The functions for dispatching EvtPlayerRequestDoAction.
--------------------------------------------------------------------------------
local function dispatchEventWait(self)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name       = "EvtPlayerRequestDoAction",
        actionName = "Wait",
        path       = self.m_MovePath,
    })
end

local function dispatchEventJoin(self)
    print("The Join action is selected, but not implemented.")
end

local function dispatchEventAttack(self, targetGridIndex)
    local listNode = AttackableGridListFunctions.getListNode(self.m_AttackableGridList, targetGridIndex)
    print("ModelActionPlanner-dispatchEventAttack()", listNode.estimatedAttackDamage, listNode.estimatedCounterDamage)

    self.m_RootScriptEventDispatcher:dispatchEvent({
        name            = "EvtPlayerRequestDoAction",
        actionName      = "Attack",
        path            = self.m_MovePath,
        targetGridIndex = GridIndexFunctions.clone(targetGridIndex),
    })
end

--------------------------------------------------------------------------------
-- The functions for avaliable action list.
--------------------------------------------------------------------------------
local setStateIdle, setStateMakingMovePath, setStateChoosingAction, setStateChoosingAttackTarget

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
    list[#list + 1] = getActionAttack(self, destination)
    list[#list + 1] = getActionWait(  self, destination)

    assert(#list > 0, "ModelActionPlanner-getAvaliableActionList() the generated list has no valid action item.")
    return list
end

--------------------------------------------------------------------------------
-- The set state functions.
--------------------------------------------------------------------------------
setStateIdle = function(self)
    self.m_State = "idle"
    if (self.m_View) then
        self.m_View:setReachableGridsVisible(false)
            :setAttackableGridsVisible(false)
            :setMovePathVisible(false)
            :setMovePathDestinationVisible(false)
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtActionPlannerIdle"})
end

setStateMakingMovePath = function(self, focusUnitModel)
    resetReachableArea(self, focusUnitModel)
    resetMovePath(      self, focusUnitModel)
    self.m_State          = "makingMovePath"
    self.m_FocusModelUnit = focusUnitModel

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
    self.m_Destination     = destination or self.m_Destination
    self.m_AttackableGridList = AttackableGridListFunctions.createList(self.m_FocusModelUnit, self.m_Destination, self.m_ModelTileMap, self.m_ModelUnitMap)
    self.m_State           = "choosingAction"

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
-- The callback functions on EvtPlayerSelectedGrid.
--------------------------------------------------------------------------------
local function onEvtPlayerSelectedGrid(self, gridIndex)
    if (self.m_State == "idle") then
        local modelUnit = self.m_ModelUnitMap:getModelUnit(gridIndex)
        if ((modelUnit) and (modelUnit:canDoAction(self.m_PlayerIndex))) then
            setStateMakingMovePath(self, modelUnit)
        end
    elseif (self.m_State == "makingMovePath") then
        if (not ReachableAreaFunctions.getAreaNode(self.m_ReachableArea, gridIndex)) then
            setStateIdle(self)
        elseif (canUnitStayInGrid(self.m_FocusModelUnit, gridIndex, self.m_ModelUnitMap)) then
            setStateChoosingAction(self, gridIndex)
        end
    elseif (self.m_State == "choosingAction") then
        setStateMakingMovePath(self, self.m_FocusModelUnit)
    elseif (self.m_State == "choosingAttackTarget") then
        -- TODO: enable to attack.
        if (AttackableGridListFunctions.getListNode(self.m_AttackableGridList, gridIndex)) then
            dispatchEventAttack(self, gridIndex)
        else
            setStateChoosingAction(self, self.m_Destination)
        end
    else
        error("ModelActionPlanner-onEvtPlayerSelectedGrid() the state of the planner is invalid.")
    end
end

--------------------------------------------------------------------------------
-- The callback functions on EvtTurnPhaseBeginning.
--------------------------------------------------------------------------------
local function onEvtTurnPhaseBeginning(self, event)
    self.m_PlayerIndex = event.playerIndex
    setStateIdle(self)
end

--------------------------------------------------------------------------------
-- The callback functions on EvtPlayerMovedCursor.
--------------------------------------------------------------------------------
local function onEvtPlayerMovedCursor(self, gridIndex)
    if (self.m_State == "idle") then
        return
    elseif (self.m_State == "makingMovePath") then
        if (ReachableAreaFunctions.getAreaNode(self.m_ReachableArea, gridIndex)) then
            updateMovePathWithDestinationGrid(self, gridIndex)
            if (self.m_View) then
                self.m_View:setMovePath(self.m_MovePath)
                    :setMovePathVisible(true)
            end
        end
    elseif (self.m_State == "choosingAttackTarget") then
        local listNode = AttackableGridListFunctions.getListNode(self.m_AttackableGridList, gridIndex)
        if (listNode) then
            self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtPlayerPreviewAttackTarget", attackDamage = listNode.estimatedAttackDamage, counterDamage = listNode.estimatedCounterDamage})
        else
            self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtPlayerPreviewNoAttackTarget"})
        end
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializer.
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
    self.m_ModelUnitMap = model

    return self
end

function ModelActionPlanner:setModelTileMap(model)
    self.m_ModelTileMap = model

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node/script events.
--------------------------------------------------------------------------------
function ModelActionPlanner:onEnter(rootActor)
    self.m_RootScriptEventDispatcher = rootActor:getModel():getScriptEventDispatcher()
    self.m_RootScriptEventDispatcher:addEventListener("EvtPlayerSelectedGrid", self)
        :addEventListener("EvtPlayerMovedCursor", self)
        :addEventListener("EvtTurnPhaseBeginning", self)
        :addEventListener("EvtWeatherChanged", self)
        :addEventListener("EvtPlayerRequestDoAction", self)

    return self
end

function ModelActionPlanner:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtPlayerRequestDoAction", self)
        :removeEventListener("EvtWeatherChanged", self)
        :removeEventListener("EvtTurnPhaseBeginning", self)
        :removeEventListener("EvtPlayerMovedCursor", self)
        :removeEventListener("EvtPlayerSelectedGrid", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

function ModelActionPlanner:onEvent(event)
    local name = event.name
    if (name == "EvtPlayerSelectedGrid") then
        onEvtPlayerSelectedGrid(self, event.gridIndex)
    elseif (name == "EvtTurnPhaseBeginning") then
        onEvtTurnPhaseBeginning(self, event)
    elseif (name == "EvtWeatherChanged") then
        self.m_CurrentWeather = event.weather
    elseif (name == "EvtPlayerMovedCursor") then
        onEvtPlayerMovedCursor(self, event.gridIndex)
    elseif (name == "EvtPlayerRequestDoAction") then
        setStateIdle(self)
    end

    return self
end

return ModelActionPlanner
