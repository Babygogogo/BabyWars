
local ModelActionPlanner = class("ModelActionPlanner")

local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getMaxRange(unitModel)
    return math.min(unitModel:getMovementRange(), unitModel:getCurrentFuel())
end

local function getRangeConsumption(gridIndex, unitModel, unitMapModel, tileMapModel)
    local tileActor = tileMapModel:getTileActor(gridIndex)
    if (not tileActor) then
        return nil
    end

    local existingUnitActor = unitMapModel:getUnitActor(gridIndex)
    -- TODO: add the unite feature.
    if (existingUnitActor) and (existingUnitActor:getModel():getPlayerIndex() ~= unitModel:getPlayerIndex())then
        return nil
    end

    return tileActor:getModel():getMoveCostWithMoveType(unitModel:getMovementType())
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

local function updateMovePathWithDestinationGrid(gridIndex, model)
    local focusUnitModel       = model.m_FocusUnitActor:getModel()
    local maxRange             = getMaxRange(focusUnitModel)
    local nextRangeConsumption = getRangeConsumption(gridIndex, focusUnitModel, model.m_UnitMapModel, model.m_TileMapModel)

    if (not truncateMovePathToGrid(model.m_MovePath, gridIndex)) and
       (not extendMovePathToGrid(model.m_MovePath, gridIndex, nextRangeConsumption, maxRange)) then
        model.m_MovePath = createShortestMovePathToGrid(gridIndex, model.m_ReachableGrids)
    end
end

--------------------------------------------------------------------------------
-- The callback functions on EvtPlayerSelectedGrid.
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

local function getReachableGridsForUnit(unitModel, unitMapModel, tileMapModel)
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
                local nextRangeConsumption = getRangeConsumption(nextGridIndex, unitModel, unitMapModel, tileMapModel)
                if (nextRangeConsumption) and (rangeConsumption + nextRangeConsumption <= maxRange) then
                    pushBackToAvailableGridList(availableGridList, nextGridIndex, currentGridIndex, rangeConsumption + nextRangeConsumption)
                end
            end
        end

        listIndex = listIndex + 1
    end

    return reachableGrids
end

local function onEvtPlayerSelectedGrid(model, gridIndex)
    if (model.m_State == "idle") then
        local unit = model.m_UnitMapModel:getUnitActor(gridIndex)
        if (unit) and (canUnitTakeAction(model, unit:getModel())) then
            model.m_State          = "makingMovePath"
            model.m_FocusUnitActor = unit
            model.m_ReachableGrids = getReachableGridsForUnit(unit:getModel(), model.m_UnitMapModel, model.m_TileMapModel)
            model.m_MovePath       = {{
                gridIndex        = unit:getModel():getGridIndex(),
                rangeConsumption = 0
            }}

            if (model.m_View) then
                model.m_View:showReachableGrids(model.m_ReachableGrids)
            end
        end
    elseif (model.m_State == "makingMovePath") then
        local selectedReachableGrid = getReachableGrid(model.m_ReachableGrids, gridIndex)
        if (not selectedReachableGrid) then
            model.m_State = "idle"
            if (model.m_View) then
                model.m_View:hideReachableGrids()
                model.m_View:hideMovePath()
            end
        else
            updateMovePathWithDestinationGrid(gridIndex, model)
            if (model.m_View) then
                model.m_View:showMovePath(model.m_MovePath)
            end
        end
    end
end

--------------------------------------------------------------------------------
-- The callback functions on EvtPlayerMovedCursor.
--------------------------------------------------------------------------------
local function onEvtPlayerMovedCursor(model, gridIndex)
    if (model.m_State == "idle") then
        return
    end

    -- TODO: make the path.
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

function ModelActionPlanner:setUnitMapModel(model)
    self.m_UnitMapModel = model

    return self
end

function ModelActionPlanner:setTileMapModel(model)
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
        :addEventListener("EvtPlayerSwitched", self)

    return self
end

function ModelActionPlanner:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtPlayerSwitched", self)
        :removeEventListener("EvtPlayerMovedCursor", self)
        :removeEventListener("EvtPlayerSelectedGrid", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

function ModelActionPlanner:onEvent(event)
    if (event.name == "EvtPlayerSelectedGrid") then
        onEvtPlayerSelectedGrid(self, event.gridIndex)
    elseif (event.name == "EvtPlayerSwitched") then
        self.m_PlayerIndex = event.playerIndex
    elseif (event.name == "EvtWeatherChanged") then
        self.m_CurrentWeather = event.weather
    elseif (event.name == "EvtPlayerMovedCursor") then

    end

    return self
end

return ModelActionPlanner
