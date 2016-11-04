
local VisibilityFunctions = {}

local GridIndexFunctions = require("src.app.utilities.GridIndexFunctions")
local SingletonGetters   = require("src.app.utilities.SingletonGetters")
local TableFunctions     = require("src.app.utilities.TableFunctions")

local getAdjacentGrids = GridIndexFunctions.getAdjacentGrids
local getModelFogMap   = SingletonGetters.getModelFogMap
local getModelTileMap  = SingletonGetters.getModelTileMap
local getModelUnitMap  = SingletonGetters.getModelUnitMap

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function isModelUnitDiving(modelUnit)
    return (modelUnit.isDiving) and (modelUnit:isDiving())
end

local function generateSingleUnitData(modelUnitMap, modelUnit)
    local data    = modelUnit:toSerializableTable()
    data.isLoaded = modelUnitMap:getLoadedModelUnitWithUnitId(modelUnit:getUnitId()) ~= nil

    return data
end

local function generateUnitsData(sceneWarFileName, modelUnit)
    local modelUnitMap = getModelUnitMap(sceneWarFileName)
    local data         = {[modelUnit:getUnitId()] = generateSingleUnitData(modelUnitMap, modelUnit)}
    for _, loadedModelUnit in pairs(modelUnitMap:getLoadedModelUnitsWithLoader(modelUnit, true) or {}) do
        data[loadedModelUnit:getUnitId()] = generateSingleUnitData(modelUnitMap, loadedModelUnit)
    end

    return data
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex(sceneWarFileName, gridIndex, isDiving, unitPlayerIndex, opponentPlayerIndex)
    assert(type(unitPlayerIndex)     == "number", "VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex() invalid unitPlayerIndex: " .. (unitPlayerIndex or ""))
    assert(type(opponentPlayerIndex) == "number", "VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex() invalid opponentPlayerIndex: " .. (opponentPlayerIndex or ""))
    -- TODO: deal with the fog of war.
    if ((unitPlayerIndex == opponentPlayerIndex) or (not isDiving)) then
        return true
    else
        local modelUnitMap = getModelUnitMap(sceneWarFileName)
        for _, adjacentGridIndex in ipairs(getAdjacentGrids(gridIndex, modelUnitMap:getMapSize())) do
            local adjacentModelUnit = modelUnitMap:getModelUnit(adjacentGridIndex)
            if ((adjacentModelUnit) and (adjacentModelUnit:getPlayerIndex() == opponentPlayerIndex)) then
                return true
            end
        end

        return false
    end
end

function VisibilityFunctions.isTileVisibleToPlayerIndex(sceneWarFileName, gridIndex, targetPlayerIndex)
    local modelTile = getModelTileMap(sceneWarFileName):getModelTile(gridIndex)
    if (modelTile:getPlayerIndex() == targetPlayerIndex) then
        return true
    else
        local visibilityForTiles, visibilityForUnits = getModelFogMap(sceneWarFileName):getVisibilityOnGridForPlayerIndex(gridIndex, targetPlayerIndex)
        if (visibilityForUnits == 2) then
            return true
        elseif ((visibilityForUnits == 1) or (visibilityForTiles == 1)) then
            return not modelTile.canHideUnitType
        else
            return false
        end
    end
end

function VisibilityFunctions.getRevealedUnitsDataWithPath(sceneWarFileName, path, modelUnit, isModelUnitDestroyed)
    -- TODO: deal with fog of war.
    local modelUnitMap  = getModelUnitMap(sceneWarFileName)
    local gridIndex     = path[#path]
    local playerIndex   = modelUnit:getPlayerIndex()
    local revealedUnits

    if (not isModelUnitDestroyed) then
        for _, adjacentGridIndex in ipairs(getAdjacentGrids(gridIndex, modelUnitMap:getMapSize())) do
            local adjacentModelUnit = modelUnitMap:getModelUnit(adjacentGridIndex)
            if ((adjacentModelUnit)                                                                                                                                                                    and
                (not VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex(sceneWarFileName, adjacentGridIndex, isModelUnitDiving(adjacentModelUnit), adjacentModelUnit:getPlayerIndex(), playerIndex))) then
                revealedUnits = TableFunctions.union(revealedUnits, generateUnitsData(sceneWarFileName, adjacentModelUnit))
            end
        end
    end

    return revealedUnits
end

return VisibilityFunctions
