
local ModelActionPlanner = class("ModelActionPlanner")

local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

--------------------------------------------------------------------------------
-- The callback functions on EvtPlayerSelectedGrid.
--------------------------------------------------------------------------------
local function canUnitTakeAction(model, unitModel)
    return (unitModel) and (unitModel:getPlayerIndex() == model.m_PlayerIndex) and (unitModel:getState() == "idle")
end

local function getRangeConsumption(gridIndex, unitModel, unitMapModel, tileMapModel)
    local tileActor = tileMapModel:getTileActor(gridIndex)
    if (not tileActor) then
        return nil
    end

    local existingUnitActor = unitMapModel:getUnitActor(gridIndex)
    -- TODO: add the unite feature.
    if (existingUnitActor) then
        return nil
    end

    return tileActor:getModel():getMoveCostWithMoveType(unitModel:getMovementType())
end

local function createEmptyReachableGrids()
    local grids = {}
    grids.updateGrid = function(self, gridIndex, prevGridIndex, remainingRange)
        local x, y = gridIndex.x, gridIndex.y
        self[x] = self[x] or {}
        self[x][y] = self[x][y] or {}

        local grid = self[x][y]
        if (not grid.remainingRange) or (grid.remainingRange < remainingRange) then
            grid.prevGridIndex = prevGridIndex
            grid.remainingRange = remainingRange

            return true
        else
            return false
        end
    end

    return grids
end

local function getReachableGridsForUnit(unitModel, unitMapModel, tileMapModel)
    local range = math.min(unitModel:getMovementRange(), unitModel:getCurrentFuel())
    local origin = unitModel:getGridIndex()

    local reachableGrids = createEmptyReachableGrids()
    local availableGridList = {
        {gridIndex = origin, remainingRange = range}
    }
    local listIndex = 1
    while (listIndex <= #availableGridList) do
        local listItem         = availableGridList[listIndex]
        local currentGridIndex = listItem.gridIndex
        local remainingRange   = listItem.remainingRange

        if (reachableGrids:updateGrid(currentGridIndex, listItem.prevGridIndex, remainingRange)) then
            for _, nextGridIndex in ipairs(GridIndexFunctions.getAdjacentGrids(currentGridIndex)) do
                local rangeConsumption = getRangeConsumption(nextGridIndex, unitModel, unitMapModel, tileMapModel)
                if (rangeConsumption) and (remainingRange >= rangeConsumption) then
                    availableGridList[#availableGridList + 1] = {
                        gridIndex = nextGridIndex, prevGridIndex = currentGridIndex, remainingRange = remainingRange - rangeConsumption
                    }
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
            model.m_State = "moving"
            local reachableGrids = getReachableGridsForUnit(unit:getModel(), model.m_UnitMapModel, model.m_TileMapModel)
            if (model.m_View) then
                model.m_View:showReachableGrids(reachableGrids)
            end
        end
    elseif (model.m_State == "moving") then
        -- TODO: remove codes below and add correct ones.
        model.m_State = "idle"
        if (model.m_View) then
            model.m_View:hideReachableGrids()
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
        :addEventListener("EvtPlayerSwitched", self)

    return self
end

function ModelActionPlanner:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtPlayerSwitched", self)
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
    end

    return self
end

return ModelActionPlanner
