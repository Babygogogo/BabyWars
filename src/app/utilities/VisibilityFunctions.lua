
local VisibilityFunctions = {}

local GridIndexFunctions     = require("src.app.utilities.GridIndexFunctions")
local SingletonGetters       = require("src.app.utilities.SingletonGetters")
local SkillModifierFunctions = require("src.app.utilities.SkillModifierFunctions")
local TableFunctions         = require("src.app.utilities.TableFunctions")

local getAdjacentGrids       = GridIndexFunctions.getAdjacentGrids
local getGridsWithinDistance = GridIndexFunctions.getGridsWithinDistance
local getModelFogMap         = SingletonGetters.getModelFogMap
local getModelPlayerManager  = SingletonGetters.getModelPlayerManager
local getModelTileMap        = SingletonGetters.getModelTileMap
local getModelUnitMap        = SingletonGetters.getModelUnitMap

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function isModelUnitDiving(modelUnit)
    return (modelUnit.isDiving) and (modelUnit:isDiving())
end

local function isUnitHiddenByTileToPlayerIndex(sceneWarFileName, modelUnit, playerIndex)
    local modelTile = getModelTileMap(sceneWarFileName):getModelTile(modelUnit:getGridIndex())
    return (modelTile:getPlayerIndex() ~= playerIndex)       and
        (modelTile.canHideUnitType)                          and
        (modelTile:canHideUnitType(modelUnit:getUnitType()))
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

local function createEmptyMap(mapSize)
    local map = {}
    for x = 1, mapSize.width do
        map[x] = {}
    end

    return map
end

local function createVisibilityMapWithPath(sceneWarFileName, path, modelUnit)
    local playerIndex           = modelUnit:getPlayerIndex()
    local canRevealHidingPlaces = SkillModifierFunctions.canRevealHidingPlacesForUnits(getModelPlayerManager(sceneWarFileName):getModelPlayer(playerIndex):getModelSkillConfiguration())
    local mapSize               = getModelTileMap(sceneWarFileName):getMapSize()
    local visibilityMap         = createEmptyMap(mapSize)

    for _, pathNode in ipairs(path) do
        local vision = modelUnit:getVisionForPlayerIndex(playerIndex, pathNode)
        if (canRevealHidingPlaces) then
            for _, gridIndex in pairs(getGridsWithinDistance(pathNode, 0, vision, mapSize)) do
                visibilityMap[gridIndex.x][gridIndex.y] = 2
            end
        else
            for _, gridIndex in pairs(getGridsWithinDistance(pathNode, 0, 1, mapSize)) do
                visibilityMap[gridIndex.x][gridIndex.y] = 2
            end
            for _, gridIndex in pairs(getGridsWithinDistance(pathNode, 2, vision, mapSize)) do
                visibilityMap[gridIndex.x][gridIndex.y] = visibilityMap[gridIndex.x][gridIndex.y] or 1
            end
        end
    end

    return visibilityMap
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

local isUnitVisible = VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex
local isTileVisible = VisibilityFunctions.isTileVisibleToPlayerIndex

function VisibilityFunctions.getRevealedUnitsDataWithPath(sceneWarFileName, path, modelUnit, isModelUnitDestroyed)
    local modelUnitMap  = getModelUnitMap(sceneWarFileName)
    local mapSize       = modelUnitMap:getMapSize()
    local playerIndex   = modelUnit:getPlayerIndex()
    local visibilityMap = createVisibilityMapWithPath(sceneWarFileName, path, modelUnit)
    local revealedUnits

    for x = 1, mapSize.width do
        for y = 1, mapSize.height do
            local visibility = visibilityMap[x][y]
            if (visibility) then
                local gridIndex  = {x = x, y = y}
                local revealUnit = modelUnitMap:getModelUnit(gridIndex)
                if ((revealUnit)                                                                                                                 and
                    (not isModelUnitDiving(revealUnit))                                                                                          and
                    (not isUnitVisible(sceneWarFileName, gridIndex, revealUnit:getUnitType(), false, revealUnit:getPlayerIndex(), playerIndex))) then
                    if ((visibility == 2) or (not isUnitHiddenByTileToPlayerIndex(sceneWarFileName, revealUnit, playerIndex))) then
                        revealedUnits = TableFunctions.union(revealedUnits, generateUnitsData(sceneWarFileName, revealUnit))
                    end
                end
            end
        end
    end

    if (not isModelUnitDestroyed) then
        for _, adjacentGridIndex in ipairs(getAdjacentGrids(path[#path], mapSize)) do
            local adjacentModelUnit = modelUnitMap:getModelUnit(adjacentGridIndex)
            if ((adjacentModelUnit)                                                                                                                               and
                (isModelUnitDiving(adjacentModelUnit))                                                                                                            and
                (not isUnitVisible(sceneWarFileName, adjacentGridIndex, adjacentModelUnit:getUnitType(), true, adjacentModelUnit:getPlayerIndex(), playerIndex))) then
                revealedUnits = TableFunctions.union(revealedUnits, generateUnitsData(sceneWarFileName, adjacentModelUnit))
            end
        end
    end

    return revealedUnits
end

return VisibilityFunctions
