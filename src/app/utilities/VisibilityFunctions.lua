
local VisibilityFunctions = {}

local GridIndexFunctions     = require("src.app.utilities.GridIndexFunctions")
local SingletonGetters       = require("src.app.utilities.SingletonGetters")
local SkillModifierFunctions = require("src.app.utilities.SkillModifierFunctions")
local TableFunctions         = require("src.app.utilities.TableFunctions")

local getAdjacentGrids      = GridIndexFunctions.getAdjacentGrids
local getModelFogMap        = SingletonGetters.getModelFogMap
local getModelPlayerManager = SingletonGetters.getModelPlayerManager
local getModelTileMap       = SingletonGetters.getModelTileMap
local getModelUnitMap       = SingletonGetters.getModelUnitMap

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
function VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex(sceneWarFileName, gridIndex, unitType, isDiving, unitPlayerIndex, targetPlayerIndex)
    assert(type(unitType)          == "string", "VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex() invalid unitType: " .. (unitType or ""))
    assert(type(unitPlayerIndex)   == "number", "VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex() invalid unitPlayerIndex: " .. (unitPlayerIndex or ""))
    assert(type(targetPlayerIndex) == "number", "VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex() invalid targetPlayerIndex: " .. (targetPlayerIndex or ""))
    if (unitPlayerIndex == targetPlayerIndex) then
        return true
    elseif (isDiving) then
        local modelUnitMap = getModelUnitMap(sceneWarFileName)
        for _, adjacentGridIndex in ipairs(getAdjacentGrids(gridIndex, modelUnitMap:getMapSize())) do
            local adjacentModelUnit = modelUnitMap:getModelUnit(adjacentGridIndex)
            if ((adjacentModelUnit) and (adjacentModelUnit:getPlayerIndex() == targetPlayerIndex)) then
                return true
            end
        end

        return false
    end

    local modelTile = getModelTileMap(sceneWarFileName):getModelTile(gridIndex)
    if (modelTile:getPlayerIndex() == targetPlayerIndex) then
        return true
    end

    local visibilityForTiles, visibilityForUnits = getModelFogMap(sceneWarFileName):getVisibilityOnGridForPlayerIndex(gridIndex, targetPlayerIndex)
    if (visibilityForUnits == 2) then
        return true
    elseif ((visibilityForUnits == 0) and (visibilityForTiles == 0)) then
        return false
    elseif ((not modelTile.canHideUnitType) or (not modelTile:canHideUnitType(unitType))) then
        return true
    else
        local skillConfiguration = getModelPlayerManager(sceneWarFileName):getModelPlayer(targetPlayerIndex):getModelSkillConfiguration()
        if (((visibilityForTiles == 1) and (SkillModifierFunctions.canRevealHidingPlacesForTiles(skillConfiguration)))  or
            ((visibilityForUnits == 1) and (SkillModifierFunctions.canRevealHidingPlacesForUnits(skillConfiguration)))) then
            return true
        else
            return false
        end
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
        elseif ((visibilityForUnits == 0) and (visibilityForTiles == 0)) then
            return false
        elseif (not modelTile.canHideUnitType) then
            return true
        else
            local skillConfiguration = getModelPlayerManager(sceneWarFileName):getModelPlayer(targetPlayerIndex):getModelSkillConfiguration()
            if (((visibilityForTiles == 1) and (SkillModifierFunctions.canRevealHidingPlacesForTiles(skillConfiguration)))  or
                ((visibilityForUnits == 1) and (SkillModifierFunctions.canRevealHidingPlacesForUnits(skillConfiguration)))) then
                return true
            else
                return false
            end
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
                (not VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex(sceneWarFileName, adjacentGridIndex, adjacentModelUnit:getUnitType(), isModelUnitDiving(adjacentModelUnit), adjacentModelUnit:getPlayerIndex(), playerIndex))) then
                revealedUnits = TableFunctions.union(revealedUnits, generateUnitsData(sceneWarFileName, adjacentModelUnit))
            end
        end
    end

    return revealedUnits
end

return VisibilityFunctions
