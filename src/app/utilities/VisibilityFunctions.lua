
local VisibilityFunctions = {}

local GameConstantFunctions  = require("src.app.utilities.GameConstantFunctions")
local GridIndexFunctions     = require("src.app.utilities.GridIndexFunctions")
local SingletonGetters       = require("src.app.utilities.SingletonGetters")
local SkillModifierFunctions = require("src.app.utilities.SkillModifierFunctions")
local TableFunctions         = require("src.app.utilities.TableFunctions")

local canRevealHidingPlacesForTiles = SkillModifierFunctions.canRevealHidingPlacesForTiles
local canRevealHidingPlacesForUnits = SkillModifierFunctions.canRevealHidingPlacesForUnits
local getAdjacentGrids              = GridIndexFunctions.getAdjacentGrids
local getGridsWithinDistance        = GridIndexFunctions.getGridsWithinDistance
local getModelFogMap                = SingletonGetters.getModelFogMap
local getModelPlayerManager         = SingletonGetters.getModelPlayerManager
local getModelTileMap               = SingletonGetters.getModelTileMap
local getModelUnitMap               = SingletonGetters.getModelUnitMap

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

local function hasUnitWithPlayerIndexOnAdjacentGrid(sceneWarFileName, gridIndex, playerIndex)
    local modelUnitMap = getModelUnitMap(sceneWarFileName)
    for _, adjacentGridIndex in ipairs(getAdjacentGrids(gridIndex, modelUnitMap:getMapSize())) do
        local adjacentModelUnit = modelUnitMap:getModelUnit(adjacentGridIndex)
        if ((adjacentModelUnit) and (adjacentModelUnit:getPlayerIndex() == playerIndex)) then
            return true
        end
    end

    return false
end

local function hasUnitWithPlayerIndexOnGrid(sceneWarFileName, gridIndex, playerIndex)
    local modelUnit = getModelUnitMap(sceneWarFileName):getModelUnit(gridIndex)
    return (modelUnit) and (modelUnit:getPlayerIndex() == playerIndex)
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
    local canRevealHidingPlaces = canRevealHidingPlacesForUnits(getModelPlayerManager(sceneWarFileName):getModelPlayer(playerIndex):getModelSkillConfiguration())
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

local function getVisionForBuiltTile(sceneWarFileName, gridIndex, builder)
    local oldTileType             = getModelTileMap(sceneWarFileName):getModelTile(gridIndex):getTileType()
    local newTileType             = GameConstantFunctions.getTileTypeWithTiledId(builder:getBuildTiledIdWithTileType(oldTileType))
    local template                = GameConstantFunctions.getTemplateModelTileWithTileType(newTileType).VisionOwner
    local modelSkillConfiguration = getModelPlayerManager(sceneWarFileName):getModelPlayer(builder:getPlayerIndex()):getModelSkillConfiguration()
    return template.vision + SkillModifierFunctions.getVisionModifierForTiles(modelSkillConfiguration)
end

local function getVisionForCapturedTile(sceneWarFileName, gridIndex, playerIndex)
    local tileType                = getModelTileMap(sceneWarFileName):getModelTile(gridIndex):getTileType()
    tileType                      = (tileType ~= "Headquarters") and (tileType) or ("City")
    local template                = GameConstantFunctions.getTemplateModelTileWithTileType(tileType).VisionOwner
    local modelSkillConfiguration = getModelPlayerManager(sceneWarFileName):getModelPlayer(playerIndex):getModelSkillConfiguration()
    return template.vision + SkillModifierFunctions.getVisionModifierForTiles(modelSkillConfiguration)
end

local function generateTilesData(modelTile, mapSize)
    local data = modelTile:toSerializableTable()
    if (not data) then
        return nil
    else
        local gridIndex = modelTile:getGridIndex()
        return {[(gridIndex.x - 1) * mapSize.height + gridIndex.y] = data}
    end
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

local function getRevealedTilesAndUnitsForPlayerIndexOnGettingBuilding(sceneWarFileName, origin, vision, playerIndex)
    local modelTileMap          = getModelTileMap(sceneWarFileName)
    local modelUnitMap          = getModelUnitMap(sceneWarFileName)
    local mapSize               = modelTileMap:getMapSize()
    local canRevealHidingPlaces = canRevealHidingPlacesForTiles(getModelPlayerManager(sceneWarFileName):getModelPlayer(playerIndex):getModelSkillConfiguration())
    local revealedTiles, revealedUnits

    for _, gridIndex in pairs(getGridsWithinDistance(origin, 0, vision, mapSize)) do
        local modelTile = modelTileMap:getModelTile(gridIndex)
        if (not VisibilityFunctions.isTileVisibleToPlayerIndex(sceneWarFileName, gridIndex, playerIndex)) then
            if ((canRevealHidingPlaces)                          or
                (not modelTile.canHideUnitType)                  or
                (GridIndexFunctions.isEqual(origin, gridIndex))) then
                revealedTiles = TableFunctions.union(revealedTiles, generateTilesData(modelTile, mapSize))
            end
        end

        local modelUnit = modelUnitMap:getModelUnit(gridIndex)
        if (modelUnit) then
            local unitType = modelUnit:getUnitType()
            if (not VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex(sceneWarFileName, gridIndex, unitType, isModelUnitDiving(modelUnit), modelUnit:getPlayerIndex(), playerIndex)) then
                if ((canRevealHidingPlaces)                    or
                    (not modelTile.canHideUnitType)            or
                    (not modelTile:canHideUnitType(unitType))) then
                    revealedUnits = TableFunctions.union(revealedUnits, generateUnitsData(sceneWarFileName, modelUnit))
                end
            end
        end
    end

    return revealedTiles, revealedUnits
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
        return hasUnitWithPlayerIndexOnAdjacentGrid(sceneWarFileName, gridIndex, targetPlayerIndex)
    end

    local modelTile = getModelTileMap(sceneWarFileName):getModelTile(gridIndex)
    if (modelTile:getPlayerIndex() == targetPlayerIndex) then
        return true
    else
        local visibilityForPaths, visibilityForTiles, visibilityForUnits = getModelFogMap(sceneWarFileName):getVisibilityOnGridForPlayerIndex(gridIndex, targetPlayerIndex)
        if (visibilityForPaths == 2) then
            return true
        elseif ((visibilityForPaths == 0) and (visibilityForTiles == 0) and (visibilityForUnits == 0)) then
            return false
        elseif ((not modelTile.canHideUnitType) or (not modelTile:canHideUnitType(unitType))) then
            return true
        elseif (hasUnitWithPlayerIndexOnAdjacentGrid(sceneWarFileName, gridIndex, targetPlayerIndex)) then
            return true
        else
            local skillConfiguration = getModelPlayerManager(sceneWarFileName):getModelPlayer(targetPlayerIndex):getModelSkillConfiguration()
            return ((visibilityForTiles == 1)                               and (canRevealHidingPlacesForTiles(skillConfiguration))) or
                (  ((visibilityForPaths == 1) or (visibilityForUnits == 1)) and (canRevealHidingPlacesForUnits(skillConfiguration)))
        end
    end
end

function VisibilityFunctions.isTileVisibleToPlayerIndex(sceneWarFileName, gridIndex, targetPlayerIndex)
    local modelTile = getModelTileMap(sceneWarFileName):getModelTile(gridIndex)
    if (modelTile:getPlayerIndex() == targetPlayerIndex) then
        return true
    else
        local visibilityForPaths, visibilityForTiles, visibilityForUnits = getModelFogMap(sceneWarFileName):getVisibilityOnGridForPlayerIndex(gridIndex, targetPlayerIndex)
        if (visibilityForPaths == 2) then
            return true
        elseif ((visibilityForPaths == 0) and (visibilityForTiles == 0) and (visibilityForUnits == 0)) then
            return false
        elseif (not modelTile.canHideUnitType) then
            return true
        elseif ((hasUnitWithPlayerIndexOnAdjacentGrid(sceneWarFileName, gridIndex, targetPlayerIndex))  or
            (    hasUnitWithPlayerIndexOnGrid(        sceneWarFileName, gridIndex, targetPlayerIndex))) then
            return true
        else
            local skillConfiguration = getModelPlayerManager(sceneWarFileName):getModelPlayer(targetPlayerIndex):getModelSkillConfiguration()
            return ((visibilityForTiles == 1)                               and (canRevealHidingPlacesForTiles(skillConfiguration))) or
                (  ((visibilityForPaths == 1) or (visibilityForUnits == 1)) and (canRevealHidingPlacesForUnits(skillConfiguration)))
        end
    end
end

local isUnitVisible = VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex
local isTileVisible = VisibilityFunctions.isTileVisibleToPlayerIndex

function VisibilityFunctions.getRevealedTilesAndUnitsData(sceneWarFileName, path, modelUnit, isModelUnitDestroyed)
    local modelTileMap  = getModelTileMap(sceneWarFileName)
    local modelUnitMap  = getModelUnitMap(sceneWarFileName)
    local mapSize       = modelUnitMap:getMapSize()
    local playerIndex   = modelUnit:getPlayerIndex()
    local visibilityMap = createVisibilityMapWithPath(sceneWarFileName, path, modelUnit)
    local revealedTiles, revealedUnits

    for x = 1, mapSize.width do
        for y = 1, mapSize.height do
            local visibility = visibilityMap[x][y]
            if (visibility) then
                local gridIndex = {x = x, y = y}
                if (not isTileVisible(sceneWarFileName, gridIndex, playerIndex)) then
                    local modelTile = modelTileMap:getModelTile(gridIndex)
                    if ((visibility == 2) or (not modelTile.canHideUnitType)) then
                        revealedTiles = TableFunctions.union(revealedTiles, generateTilesData(modelTile, mapSize))
                    end
                end

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

    return revealedTiles, revealedUnits
end

function VisibilityFunctions.getRevealedTilesAndUnitsDataForBuild(sceneWarFileName, origin, builder)
    return getRevealedTilesAndUnitsForPlayerIndexOnGettingBuilding(sceneWarFileName, origin, getVisionForBuiltTile(sceneWarFileName, origin, builder), builder:getPlayerIndex())
end

function VisibilityFunctions.getRevealedTilesAndUnitsDataForCapture(sceneWarFileName, origin, playerIndex)
    return getRevealedTilesAndUnitsForPlayerIndexOnGettingBuilding(sceneWarFileName, origin, getVisionForCapturedTile(sceneWarFileName, origin, playerIndex), playerIndex)
end

function VisibilityFunctions.getRevealedTilesAndUnitsDataForFlare(sceneWarFileName, origin, radius, playerIndex)
    local modelTileMap = getModelTileMap(sceneWarFileName)
    local modelUnitMap = getModelUnitMap(sceneWarFileName)
    local mapSize      = modelTileMap:getMapSize()
    local revealedTiles, revealedUnits

    for _, gridIndex in pairs(getGridsWithinDistance(origin, 0, radius, mapSize)) do
        local modelTile = modelTileMap:getModelTile(gridIndex)
        if (not VisibilityFunctions.isTileVisibleToPlayerIndex(sceneWarFileName, gridIndex, playerIndex)) then
            revealedTiles = TableFunctions.union(revealedTiles, generateTilesData(modelTile, mapSize))
        end

        local modelUnit = modelUnitMap:getModelUnit(gridIndex)
        if ((modelUnit)                                                                                                                and
            (not isModelUnitDiving(modelUnit))                                                                                         and
            (not isUnitVisible(sceneWarFileName, gridIndex, modelUnit:getUnitType(), false, modelUnit:getPlayerIndex(), playerIndex))) then
            revealedUnits = TableFunctions.union(revealedUnits, generateUnitsData(sceneWarFileName, modelUnit))
        end
    end

    return revealedTiles, revealedUnits
end

return VisibilityFunctions
