
local ModelActionPlanner = class("ModelActionPlanner")

local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getMaxRange(unitModel)
    return math.min(unitModel:getMovementRange(), unitModel:getCurrentFuel())
end

local function getRangeConsumption(gridIndex, unitModel, unitMapModel, tileMapModel, weather)
    local tileActor = tileMapModel:getTileActor(gridIndex)
    if (not tileActor) then
        return nil
    end

    local existingUnit = unitMapModel:getUnitActor(gridIndex)
    if (existingUnit) and (existingUnit:getModel():getPlayerIndex() ~= unitModel:getPlayerIndex())then
        return nil
    end

    return tileActor:getModel():getMoveCost(unitModel:getMovementType(), weather)
end

local function getReachableGrid(grids, gridIndex)
    if (grids and gridIndex and grids[gridIndex.x]) then
        return grids[gridIndex.x][gridIndex.y]
    else
        return nil
    end
end

local function canUnitTakeAction(model, unitModel)
    return (unitModel) and (unitModel:getPlayerIndex() == model.m_PlayerIndex) and (unitModel:getState() == "idle")
end

local function canUnitStayInGrid(unitModel, gridIndex, unitMapModel)
    if (GridIndexFunctions.isEqual(unitModel:getGridIndex(), gridIndex)) then
        return true
    else
        local existingUnitModel = unitMapModel:getUnitModel(gridIndex)
        return (not existingUnitModel) or
               (existingUnitModel:canJoin(unitModel)) or
               (existingUnitModel.canLoad and existingUnitModel:canLoad(unitModel))
    end
end

local function canAttackTargetOnGridIndex(attacker, destination, gridIndex, tileMapModel, unitMapModel)
    if (not GridIndexFunctions.isWithinMap(gridIndex, tileMapModel:getMapSize())) then
        return false
    end

    if (attacker:canAttackTarget(tileMapModel:getTileModel(gridIndex), destination)) then
        return true
    else
        return attacker:canAttackTarget(unitMapModel:getUnitModel(gridIndex), destination)
    end
end

--------------------------------------------------------------------------------
-- The functions for MovePath.
--------------------------------------------------------------------------------
local function hasGridInMovePath(path, gridIndex)
    for i, pathItem in ipairs(path) do
        if (GridIndexFunctions.isEqual(gridIndex, pathItem.gridIndex)) then
            return true, i
        end
    end

    return false
end

local function truncateMovePathToGrid(path, gridIndex)
    local hasGrid, index = hasGridInMovePath(path, gridIndex)
    if (hasGrid) then
        for i = index + 1, #path do
            path[i] = nil
        end

        return true
    else
        return false
    end
end

local function extendMovePathToGrid(path, gridIndex, nextRangeConsumption, maxRange)
    local length = #path
    local rangeConsumption = path[length].rangeConsumption + nextRangeConsumption

    if (hasGridInMovePath(path, gridIndex)) or
       (not GridIndexFunctions.isAdjacent(path[length].gridIndex, gridIndex)) or
       (rangeConsumption > maxRange) then
        return false
    else
        path[length + 1] = {
            gridIndex        = gridIndex,
            rangeConsumption = rangeConsumption
        }

        return true
    end
end

local function createShortestMovePathToGrid(gridIndex, reachableGrids)
    local gridItem = getReachableGrid(reachableGrids, gridIndex)
    assert(gridItem, "ModelActionPlanner-createShortestMovePathToGrid() the grid is not reachable.")

    local reversePath = {}
    local x, y = gridIndex.x, gridIndex.y
    while (gridItem) do
        reversePath[#reversePath + 1] = {
            gridIndex        = {x = x, y = y},
            rangeConsumption = gridItem.rangeConsumption
        }

        if (not gridItem.prevGridIndex) then
            gridItem = nil
        else
            x, y = gridItem.prevGridIndex.x, gridItem.prevGridIndex.y
            gridItem = getReachableGrid(reachableGrids, gridItem.prevGridIndex)
        end
    end

    local path, length = {}, #reversePath
    for i = 1, length do
        path[i] = reversePath[length - i + 1]
    end

    return path
end

local function updateMovePathWithDestinationGrid(self, gridIndex)
    local maxRange             = getMaxRange(self.m_FocusUnitModel)
    local nextRangeConsumption = getRangeConsumption(gridIndex, self.m_FocusUnitModel, self.m_UnitMapModel, self.m_TileMapModel, self.m_CurrentWeather)

    if (not truncateMovePathToGrid(self.m_MovePath, gridIndex)) and
       (not extendMovePathToGrid(self.m_MovePath, gridIndex, nextRangeConsumption, maxRange)) then
        self.m_MovePath = createShortestMovePathToGrid(gridIndex, self.m_ReachableGrids)
    end
end

local function resetMovePath(self, focusUnitModel)
    if (self.m_FocusUnitModel ~= focusUnitModel) or (self.m_State == "idle") then
        self.m_MovePath       = {{
            gridIndex        = focusUnitModel:getGridIndex(),
            rangeConsumption = 0
        }}
        if (self.m_View) then
            self.m_View:setMovePath(self.m_MovePath)
        end
    end
end

--------------------------------------------------------------------------------
-- The funcitons for ReachableGrids.
--------------------------------------------------------------------------------
local function updateReachableGrids(grids, gridIndex, prevGridIndex, rangeConsumption)
    local x, y = gridIndex.x, gridIndex.y
    grids[x] = grids[x] or {}
    grids[x][y] = grids[x][y] or {}

    local grid = grids[x][y]
    if (not grid.rangeConsumption) or (grid.rangeConsumption > rangeConsumption) then
        grid.prevGridIndex    = prevGridIndex
        grid.rangeConsumption = rangeConsumption

        return true
    else
        return false
    end
end

local function pushBackToAvailableGridList(list, gridIndex, prevGridIndex, rangeConsumption)
    list[#list + 1] = {
        gridIndex        = gridIndex,
        prevGridIndex    = prevGridIndex,
        rangeConsumption = rangeConsumption
    }
end

local function getReachableGridsForUnit(unitModel, unitMapModel, tileMapModel, weather)
    local maxRange = getMaxRange(unitModel)
    local reachableGrids, availableGridList = {}, {}
    pushBackToAvailableGridList(availableGridList, unitModel:getGridIndex(), nil, 0)

    local listIndex = 1
    while (listIndex <= #availableGridList) do
        local listItem         = availableGridList[listIndex]
        local currentGridIndex = listItem.gridIndex
        local rangeConsumption = listItem.rangeConsumption

        if (updateReachableGrids(reachableGrids, currentGridIndex, listItem.prevGridIndex, rangeConsumption, maxRange)) then
            for _, nextGridIndex in ipairs(GridIndexFunctions.getAdjacentGrids(currentGridIndex)) do
                local nextRangeConsumption = getRangeConsumption(nextGridIndex, unitModel, unitMapModel, tileMapModel, weather)
                if (nextRangeConsumption) and (rangeConsumption + nextRangeConsumption <= maxRange) then
                    pushBackToAvailableGridList(availableGridList, nextGridIndex, currentGridIndex, rangeConsumption + nextRangeConsumption)
                end
            end
        end

        listIndex = listIndex + 1
    end

    return reachableGrids
end

local function resetReachableGrids(self, focusUnitModel)
    if (self.m_FocusUnitModel ~= focusUnitModel) then
        self.m_ReachableGrids = getReachableGridsForUnit(focusUnitModel, self.m_UnitMapModel, self.m_TileMapModel, self.m_CurrentWeather)
        if (self.m_View) then
            self.m_View:setReachableGrids(self.m_ReachableGrids)
        end
    end
end

--------------------------------------------------------------------------------
-- The funcitons for AttackableGrids.
--------------------------------------------------------------------------------
local function getAttackableGrids(attacker, destination, tileMapModel, unitMapModel)
    if (not attacker.canAttackTarget) or
       ((not attacker:canAttackAfterMove()) and (not GridIndexFunctions.isEqual(attacker:getGridIndex(), destination))) then
        return {}
    end

    local minRange, maxRange = attacker:getAttackRangeMinMax()
    return GridIndexFunctions.getGridsWithinDistance(destination, minRange, maxRange, function(gridIndex)
        return canAttackTargetOnGridIndex(attacker, destination, gridIndex, tileMapModel, unitMapModel)
    end)
end

--------------------------------------------------------------------------------
-- The functions for avaliable action list.
--------------------------------------------------------------------------------
local setStateIdle, setStateMakingMovePath, setStateChoosingAction, setStateChoosingAttackTarget

local function getActionJoin(self, destination)
    if (not GridIndexFunctions.isEqual(self.m_FocusUnitModel:getGridIndex(), destination)) then
        local existingUnitModel = self.m_UnitMapModel:getUnitModel(destination)
        if (existingUnitModel and existingUnitModel:canJoin(self.m_FocusUnitModel)) then
            return {
                name     = "Join",
                callback = function()
                    print("The Join action is selected, but not implemented.")
                end
            }
        end
    else
        return nil
    end
end

local function getActionAttack(self, destination)
    if (#self.m_AttackableGrids > 0) then
        return {
            name     = "Attack",
            callback = function()
                setStateChoosingAttackTarget(self, destination)
            end
        }
    end
end

local function getActionWait(self, destination)
    local existingUnitModel = self.m_UnitMapModel:getUnitModel(destination)
    if (not existingUnitModel) or (self.m_FocusUnitModel == existingUnitModel) then
        return {
            name = "Wait",
            callback = function()
                self.m_RootScriptEventDispatcher:dispatchEvent({
                    name       = "EvtPlayerRequestDoAction",
                    actionName = "Wait",
                    path       = self.m_MovePath,
                })
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
    resetReachableGrids(self, focusUnitModel)
    resetMovePath(      self, focusUnitModel)
    self.m_State          = "makingMovePath"
    self.m_FocusUnitModel = focusUnitModel

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
    self.m_AttackableGrids = getAttackableGrids(self.m_FocusUnitModel, self.m_Destination, self.m_TileMapModel, self.m_UnitMapModel)
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
        self.m_View:setAttackableGrids(self.m_AttackableGrids)
            :setAttackableGridsVisible(true)
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtActionPlannerChoosingAttackTarget"})
end

--------------------------------------------------------------------------------
-- The callback functions on EvtPlayerSelectedGrid.
--------------------------------------------------------------------------------
local function onEvtPlayerSelectedGrid(self, gridIndex)
    if (self.m_State == "idle") then
        local unit = self.m_UnitMapModel:getUnitActor(gridIndex)
        if (unit) and (canUnitTakeAction(self, unit:getModel())) then
            setStateMakingMovePath(self, unit:getModel())
        end
    elseif (self.m_State == "makingMovePath") then
        if (not getReachableGrid(self.m_ReachableGrids, gridIndex)) then
            setStateIdle(self)
        elseif (canUnitStayInGrid(self.m_FocusUnitModel, gridIndex, self.m_UnitMapModel)) then
            setStateChoosingAction(self, gridIndex)
        end
    elseif (self.m_State == "choosingAction") then
        setStateMakingMovePath(self, self.m_FocusUnitModel)
    elseif (self.m_State == "choosingAttackTarget") then
        -- TODO: enable to attack.
        setStateChoosingAction(self, self.m_Destination)
    else
        error("ModelActionPlanner-onEvtPlayerSelectedGrid() the state of the planner is invalid.")
    end
end

--------------------------------------------------------------------------------
-- The callback functions on EvtTurnStarted.
--------------------------------------------------------------------------------
local function onEvtTurnStarted(self, event)
    self.m_PlayerIndex = event.playerIndex
    setStateIdle(self)
end

--------------------------------------------------------------------------------
-- The callback functions on EvtPlayerMovedCursor.
--------------------------------------------------------------------------------
local function onEvtPlayerMovedCursor(model, gridIndex)
    if (model.m_State == "idle") then
        return
    elseif (model.m_State == "makingMovePath") then
        if (getReachableGrid(model.m_ReachableGrids, gridIndex)) then
            updateMovePathWithDestinationGrid(model, gridIndex)
            if (model.m_View) then
                model.m_View:setMovePath(model.m_MovePath)
                    :setMovePathVisible(true)
            end
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
    self.m_UnitMapModel = model

    return self
end

function ModelActionPlanner:setModelTileMap(model)
    self.m_TileMapModel = model

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node/script events.
--------------------------------------------------------------------------------
function ModelActionPlanner:onEnter(rootActor)
    self.m_RootScriptEventDispatcher = rootActor:getModel():getScriptEventDispatcher()
    self.m_RootScriptEventDispatcher:addEventListener("EvtPlayerSelectedGrid", self)
        :addEventListener("EvtPlayerMovedCursor", self)
        :addEventListener("EvtTurnStarted", self)
        :addEventListener("EvtWeatherChanged", self)

    return self
end

function ModelActionPlanner:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtWeatherChanged", self)
        :removeEventListener("EvtTurnStarted", self)
        :removeEventListener("EvtPlayerMovedCursor", self)
        :removeEventListener("EvtPlayerSelectedGrid", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

function ModelActionPlanner:onEvent(event)
    if (event.name == "EvtPlayerSelectedGrid") then
        onEvtPlayerSelectedGrid(self, event.gridIndex)
    elseif (event.name == "EvtTurnStarted") then
        onEvtTurnStarted(self, event)
    elseif (event.name == "EvtWeatherChanged") then
        self.m_CurrentWeather = event.weather
    elseif (event.name == "EvtPlayerMovedCursor") then
        onEvtPlayerMovedCursor(self, event.gridIndex)
    end

    return self
end

return ModelActionPlanner
