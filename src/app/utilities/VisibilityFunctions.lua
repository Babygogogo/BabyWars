
local VisibilityFunctions = {}

local GameConstantFunctions  = requireBW("src.app.utilities.GameConstantFunctions")
local GridIndexFunctions     = requireBW("src.app.utilities.GridIndexFunctions")
local SingletonGetters       = requireBW("src.app.utilities.SingletonGetters")
local SkillModifierFunctions = requireBW("src.app.utilities.SkillModifierFunctions")
local TableFunctions         = requireBW("src.app.utilities.TableFunctions")

local canRevealHidingPlacesWithTilesForSkillGroup = SkillModifierFunctions.canRevealHidingPlacesWithTilesForSkillGroup
local canRevealHidingPlacesWithTiles              = SkillModifierFunctions.canRevealHidingPlacesWithTiles
local canRevealHidingPlacesWithUnitsForSkillGroup = SkillModifierFunctions.canRevealHidingPlacesWithUnitsForSkillGroup
local canRevealHidingPlacesWithUnits              = SkillModifierFunctions.canRevealHidingPlacesWithUnits
local getAdjacentGrids                            = GridIndexFunctions.getAdjacentGrids
local getGridsWithinDistance                      = GridIndexFunctions.getGridsWithinDistance
local getModelFogMap                              = SingletonGetters.getModelFogMap
local getModelPlayerManager                       = SingletonGetters.getModelPlayerManager
local getModelTileMap                             = SingletonGetters.getModelTileMap
local getModelTurnManager                         = SingletonGetters.getModelTurnManager
local getModelUnitMap                             = SingletonGetters.getModelUnitMap
local getVisionModifierForTilesForSkillGroup      = SkillModifierFunctions.getVisionModifierForTilesForSkillGroup
local getVisionModifierForTiles                   = SkillModifierFunctions.getVisionModifierForTiles
local getVisionModifierForUnitsForSkillGroup      = SkillModifierFunctions.getVisionModifierForUnitsForSkillGroup
local getVisionModifierForUnits                   = SkillModifierFunctions.getVisionModifierForUnits
local isTotalReplay                               = SingletonGetters.isTotalReplay

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function isModelUnitDiving(modelUnit)
    return (modelUnit.isDiving) and (modelUnit:isDiving())
end

local function isUnitHiddenByTileToPlayerIndex(modelSceneWar, modelUnit, playerIndex)
    local modelTile = getModelTileMap(modelSceneWar):getModelTile(modelUnit:getGridIndex())
    return (modelTile:getPlayerIndex() ~= playerIndex)       and
        (modelTile.canHideUnitType)                          and
        (modelTile:canHideUnitType(modelUnit:getUnitType()))
end

local function hasUnitWithPlayerIndexOnAdjacentGrid(modelSceneWar, gridIndex, playerIndex)
    local modelUnitMap = getModelUnitMap(modelSceneWar)
    for _, adjacentGridIndex in ipairs(getAdjacentGrids(gridIndex, modelUnitMap:getMapSize())) do
        local adjacentModelUnit = modelUnitMap:getModelUnit(adjacentGridIndex)
        if ((adjacentModelUnit) and (adjacentModelUnit:getPlayerIndex() == playerIndex)) then
            return true
        end
    end

    return false
end

local function hasUnitWithPlayerIndexOnGrid(modelSceneWar, gridIndex, playerIndex)
    local modelUnit = getModelUnitMap(modelSceneWar):getModelUnit(gridIndex)
    return (modelUnit) and (modelUnit:getPlayerIndex() == playerIndex)
end

local function createEmptyMap(mapSize)
    local map = {}
    for x = 1, mapSize.width do
        map[x] = {}
    end

    return map
end

local function createVisibilityMapWithPathNodes(modelSceneWar, pathNodes, modelUnit)
    local playerIndex           = modelUnit:getPlayerIndex()
    local canRevealHidingPlaces = canRevealHidingPlacesWithUnits(getModelPlayerManager(modelSceneWar):getModelPlayer(playerIndex):getModelSkillConfiguration())
    local mapSize               = getModelTileMap(modelSceneWar):getMapSize()
    local visibilityMap         = createEmptyMap(mapSize)

    for _, pathNode in ipairs(pathNodes) do
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

local function getVisionForBuiltTile(modelSceneWar, gridIndex, builder)
    local oldTileType             = getModelTileMap(modelSceneWar):getModelTile(gridIndex):getTileType()
    local newTileType             = GameConstantFunctions.getTileTypeWithTiledId(builder:getBuildTiledIdWithTileType(oldTileType))
    local template                = GameConstantFunctions.getTemplateModelTileWithTileType(newTileType).VisionOwner
    local modelSkillConfiguration = getModelPlayerManager(modelSceneWar):getModelPlayer(builder:getPlayerIndex()):getModelSkillConfiguration()
    return template.vision + getVisionModifierForTiles(modelSkillConfiguration)
end

local function getVisionForCapturedTile(modelSceneWar, gridIndex, playerIndex)
    local tileType                = getModelTileMap(modelSceneWar):getModelTile(gridIndex):getTileType()
    tileType                      = (tileType ~= "Headquarters") and (tileType) or ("City")
    local template                = GameConstantFunctions.getTemplateModelTileWithTileType(tileType).VisionOwner
    local modelSkillConfiguration = getModelPlayerManager(modelSceneWar):getModelPlayer(playerIndex):getModelSkillConfiguration()
    return template.vision + getVisionModifierForTiles(modelSkillConfiguration)
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

local function generateUnitsData(modelSceneWar, modelUnit)
    local modelUnitMap = getModelUnitMap(modelSceneWar)
    local data         = {[modelUnit:getUnitId()] = generateSingleUnitData(modelUnitMap, modelUnit)}
    for _, loadedModelUnit in pairs(modelUnitMap:getLoadedModelUnitsWithLoader(modelUnit, true) or {}) do
        data[loadedModelUnit:getUnitId()] = generateSingleUnitData(modelUnitMap, loadedModelUnit)
    end

    return data
end

local function getRevealedTilesAndUnitsForPlayerIndexOnGettingBuilding(modelSceneWar, origin, vision, playerIndex)
    local modelTileMap          = getModelTileMap(modelSceneWar)
    local modelUnitMap          = getModelUnitMap(modelSceneWar)
    local mapSize               = modelTileMap:getMapSize()
    local canRevealHidingPlaces = canRevealHidingPlacesWithTiles(getModelPlayerManager(modelSceneWar):getModelPlayer(playerIndex):getModelSkillConfiguration())
    local revealedTiles, revealedUnits

    for _, gridIndex in pairs(getGridsWithinDistance(origin, 0, vision, mapSize)) do
        local modelTile = modelTileMap:getModelTile(gridIndex)
        if (not VisibilityFunctions.isTileVisibleToPlayerIndex(modelSceneWar, gridIndex, playerIndex)) then
            if ((canRevealHidingPlaces)                          or
                (not modelTile.canHideUnitType)                  or
                (GridIndexFunctions.isEqual(origin, gridIndex))) then
                revealedTiles = TableFunctions.union(revealedTiles, generateTilesData(modelTile, mapSize))
            end
        end

        local modelUnit = modelUnitMap:getModelUnit(gridIndex)
        if (modelUnit) then
            local unitType = modelUnit:getUnitType()
            if (not VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex(modelSceneWar, gridIndex, unitType, isModelUnitDiving(modelUnit), modelUnit:getPlayerIndex(), playerIndex)) then
                if ((canRevealHidingPlaces)                    or
                    (not modelTile.canHideUnitType)            or
                    (not modelTile:canHideUnitType(unitType))) then
                    revealedUnits = TableFunctions.union(revealedUnits, generateUnitsData(modelSceneWar, modelUnit))
                end
            end
        end
    end

    return revealedTiles, revealedUnits
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex(modelSceneWar, gridIndex, unitType, isDiving, unitPlayerIndex, targetPlayerIndex, canRevealWithTiles, canRevealWithUnits)
    assert(type(unitType)          == "string", "VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex() invalid unitType: " .. (unitType or ""))
    assert(type(unitPlayerIndex)   == "number", "VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex() invalid unitPlayerIndex: " .. (unitPlayerIndex or ""))
    assert(type(targetPlayerIndex) == "number", "VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex() invalid targetPlayerIndex: " .. (targetPlayerIndex or ""))
    if ((isTotalReplay(modelSceneWar)) or (unitPlayerIndex == targetPlayerIndex)) then
        return true
    elseif (isDiving) then
        return hasUnitWithPlayerIndexOnAdjacentGrid(modelSceneWar, gridIndex, targetPlayerIndex)
    end

    local modelTile = getModelTileMap(modelSceneWar):getModelTile(gridIndex)
    if (modelTile:getPlayerIndex() == targetPlayerIndex) then
        return true
    else
        local visibilityForPaths, visibilityForTiles, visibilityForUnits = getModelFogMap(modelSceneWar):getVisibilityOnGridForPlayerIndex(gridIndex, targetPlayerIndex)
        if (visibilityForPaths == 2) then
            return true
        elseif ((visibilityForPaths == 0) and (visibilityForTiles == 0) and (visibilityForUnits == 0)) then
            return false
        elseif ((not modelTile.canHideUnitType) or (not modelTile:canHideUnitType(unitType))) then
            return true
        elseif (hasUnitWithPlayerIndexOnAdjacentGrid(modelSceneWar, gridIndex, targetPlayerIndex)) then
            return true
        else
            local skillConfiguration = getModelPlayerManager(modelSceneWar):getModelPlayer(targetPlayerIndex):getModelSkillConfiguration()
            canRevealWithTiles = (not canRevealWithTiles) and (canRevealHidingPlacesWithTiles(skillConfiguration)) or (canRevealWithTiles)
            canRevealWithUnits = (not canRevealWithUnits) and (canRevealHidingPlacesWithUnits(skillConfiguration)) or (canRevealWithUnits)
            return ((visibilityForTiles == 1) and (canRevealWithTiles)) or
                (   (visibilityForUnits == 1) and (canRevealWithUnits))
        end
    end
end

function VisibilityFunctions.isTileVisibleToPlayerIndex(modelSceneWar, gridIndex, targetPlayerIndex, canRevealWithTiles, canRevealWithUnits)
    local modelTile     = getModelTileMap(modelSceneWar):getModelTile(gridIndex)
    if (modelTile:getPlayerIndex() == targetPlayerIndex) then
        return true
    else
        local visibilityForPaths, visibilityForTiles, visibilityForUnits = getModelFogMap(modelSceneWar):getVisibilityOnGridForPlayerIndex(gridIndex, targetPlayerIndex)
        if (visibilityForPaths == 2) then
            return true
        elseif ((visibilityForPaths == 0) and (visibilityForTiles == 0) and (visibilityForUnits == 0)) then
            return false
        elseif (not modelTile.canHideUnitType) then
            return true
        elseif ((hasUnitWithPlayerIndexOnAdjacentGrid(modelSceneWar, gridIndex, targetPlayerIndex))  or
            (    hasUnitWithPlayerIndexOnGrid(        modelSceneWar, gridIndex, targetPlayerIndex))) then
            return true
        else
            local skillConfiguration = getModelPlayerManager(modelSceneWar):getModelPlayer(targetPlayerIndex):getModelSkillConfiguration()
            canRevealWithTiles = (not canRevealWithTiles) and (canRevealHidingPlacesWithTiles(skillConfiguration)) or (canRevealWithTiles)
            canRevealWithUnits = (not canRevealWithUnits) and (canRevealHidingPlacesWithUnits(skillConfiguration)) or (canRevealWithUnits)
            return ((visibilityForTiles == 1) and (canRevealWithTiles)) or
                (   (visibilityForUnits == 1) and (canRevealWithUnits))
        end
    end
end

local isUnitVisible = VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex
local isTileVisible = VisibilityFunctions.isTileVisibleToPlayerIndex

function VisibilityFunctions.getRevealedTilesAndUnitsData(modelSceneWar, pathNodes, modelUnit, isModelUnitDestroyed)
    local modelTileMap  = getModelTileMap(modelSceneWar)
    local modelUnitMap  = getModelUnitMap(modelSceneWar)
    local mapSize       = modelUnitMap:getMapSize()
    local playerIndex   = modelUnit:getPlayerIndex()
    local visibilityMap = createVisibilityMapWithPathNodes(modelSceneWar, pathNodes, modelUnit)
    local revealedTiles, revealedUnits

    for x = 1, mapSize.width do
        for y = 1, mapSize.height do
            local visibility = visibilityMap[x][y]
            if (visibility) then
                local gridIndex = {x = x, y = y}
                if (not isTileVisible(modelSceneWar, gridIndex, playerIndex)) then
                    local modelTile = modelTileMap:getModelTile(gridIndex)
                    if ((visibility == 2) or (not modelTile.canHideUnitType)) then
                        revealedTiles = TableFunctions.union(revealedTiles, generateTilesData(modelTile, mapSize))
                    end
                end

                local revealUnit = modelUnitMap:getModelUnit(gridIndex)
                if ((revealUnit)                                                                                                                 and
                    (not isModelUnitDiving(revealUnit))                                                                                          and
                    (not isUnitVisible(modelSceneWar, gridIndex, revealUnit:getUnitType(), false, revealUnit:getPlayerIndex(), playerIndex))) then
                    if ((visibility == 2) or (not isUnitHiddenByTileToPlayerIndex(modelSceneWar, revealUnit, playerIndex))) then
                        revealedUnits = TableFunctions.union(revealedUnits, generateUnitsData(modelSceneWar, revealUnit))
                    end
                end
            end
        end
    end

    if (not isModelUnitDestroyed) then
        for _, adjacentGridIndex in ipairs(getAdjacentGrids(pathNodes[#pathNodes], mapSize)) do
            local adjacentModelUnit = modelUnitMap:getModelUnit(adjacentGridIndex)
            if ((adjacentModelUnit)                                                                                                                               and
                (isModelUnitDiving(adjacentModelUnit))                                                                                                            and
                (not isUnitVisible(modelSceneWar, adjacentGridIndex, adjacentModelUnit:getUnitType(), true, adjacentModelUnit:getPlayerIndex(), playerIndex))) then
                revealedUnits = TableFunctions.union(revealedUnits, generateUnitsData(modelSceneWar, adjacentModelUnit))
            end
        end
    end

    return revealedTiles, revealedUnits
end

function VisibilityFunctions.getRevealedTilesAndUnitsDataForBuild(modelSceneWar, origin, builder)
    return getRevealedTilesAndUnitsForPlayerIndexOnGettingBuilding(modelSceneWar, origin, getVisionForBuiltTile(modelSceneWar, origin, builder), builder:getPlayerIndex())
end

function VisibilityFunctions.getRevealedTilesAndUnitsDataForCapture(modelSceneWar, origin, playerIndex)
    return getRevealedTilesAndUnitsForPlayerIndexOnGettingBuilding(modelSceneWar, origin, getVisionForCapturedTile(modelSceneWar, origin, playerIndex), playerIndex)
end

function VisibilityFunctions.getRevealedTilesAndUnitsDataForFlare(modelSceneWar, origin, radius, playerIndex)
    local modelTileMap = getModelTileMap(modelSceneWar)
    local modelUnitMap = getModelUnitMap(modelSceneWar)
    local mapSize      = modelTileMap:getMapSize()
    local revealedTiles, revealedUnits

    for _, gridIndex in pairs(getGridsWithinDistance(origin, 0, radius, mapSize)) do
        local modelTile = modelTileMap:getModelTile(gridIndex)
        if (not VisibilityFunctions.isTileVisibleToPlayerIndex(modelSceneWar, gridIndex, playerIndex)) then
            revealedTiles = TableFunctions.union(revealedTiles, generateTilesData(modelTile, mapSize))
        end

        local modelUnit = modelUnitMap:getModelUnit(gridIndex)
        if ((modelUnit)                                                                                                                and
            (not isModelUnitDiving(modelUnit))                                                                                         and
            (not isUnitVisible(modelSceneWar, gridIndex, modelUnit:getUnitType(), false, modelUnit:getPlayerIndex(), playerIndex))) then
            revealedUnits = TableFunctions.union(revealedUnits, generateUnitsData(modelSceneWar, modelUnit))
        end
    end

    return revealedTiles, revealedUnits
end

function VisibilityFunctions.getRevealedTilesAndUnitsDataForSkillActivation(modelSceneWar, skillGroupID)
    local playerIndex            = getModelTurnManager(modelSceneWar):getPlayerIndex()
    local modelSkillGroup        = getModelPlayerManager(modelSceneWar):getModelPlayer(playerIndex):getModelSkillConfiguration():getModelSkillGroupWithId(skillGroupID)
    local canRevealWithTiles     = canRevealHidingPlacesWithTilesForSkillGroup(modelSkillGroup, true)
    local canRevealWithUnits     = canRevealHidingPlacesWithUnitsForSkillGroup(modelSkillGroup, true)
    local modelFogMap            = getModelFogMap(modelSceneWar)
    local visionModifierForTiles = getVisionModifierForTilesForSkillGroup(modelSkillGroup, true)
    local visionModifierForUnits = getVisionModifierForUnitsForSkillGroup(modelSkillGroup, true)
    if ((not modelFogMap:isFogOfWarCurrently()) and (not canRevealWithTiles) and (not canRevealWithUnits) and (visionModifierForTiles == 0) and (visionModifierForUnits == 0)) then
        return
    end

    local modelUnitMap             = getModelUnitMap(modelSceneWar)
    local mapSize                  = modelUnitMap:getMapSize()
    local oldVisibilityMapForTiles = createEmptyMap(mapSize)
    local oldVisibilityMapForUnits = createEmptyMap(mapSize)
    local width, height            = mapSize.width, mapSize.height
    for x = 1, width do
        for y = 1, height do
            local gridIndex = {x = x, y = y}
            if (isTileVisible(modelSceneWar, gridIndex, playerIndex)) then
                oldVisibilityMapForTiles[x][y] = true
            end
            local modelUnit = modelUnitMap:getModelUnit(gridIndex)
            if ((modelUnit)                                                                                                                                   and
                (isUnitVisible(modelSceneWar, gridIndex, modelUnit:getUnitType(), isModelUnitDiving(modelUnit), modelUnit:getPlayerIndex(), playerIndex))) then
                oldVisibilityMapForUnits[x][y] = true
            end
        end
    end

    if (visionModifierForTiles > 0) then
        modelFogMap:resetMapForTilesForPlayerIndex(playerIndex, visionModifierForTiles)
    end
    if (visionModifierForUnits > 0) then
        modelFogMap:resetMapForUnitsForPlayerIndex(playerIndex, visionModifierForUnits)
    end
    local modelTileMap = getModelTileMap(modelSceneWar)
    local revealedTiles, revealedUnits
    for x = 1, width do
        for y = 1, height do
            local gridIndex = {x = x, y = y}
            if ((not oldVisibilityMapForTiles[x][y])                                                             and
                (isTileVisible(modelSceneWar, gridIndex, playerIndex, canRevealWithTiles, canRevealWithUnits))) then
                revealedTiles = TableFunctions.union(revealedTiles, generateTilesData(modelTileMap:getModelTile(gridIndex), mapSize))
            end

            local modelUnit = modelUnitMap:getModelUnit(gridIndex)
            if ((modelUnit)                                                                                                                                                                           and
                (not oldVisibilityMapForUnits[x][y])                                                                                                                                                  and
                (isUnitVisible(modelSceneWar, gridIndex, modelUnit:getUnitType(), isModelUnitDiving(modelUnit), modelUnit:getPlayerIndex(), playerIndex, canRevealWithTiles, canRevealWithUnits))) then
                revealedUnits = TableFunctions.union(revealedUnits, generateUnitsData(modelSceneWar, modelUnit))
            end
        end
    end

    if (visionModifierForTiles > 0) then
        modelFogMap:resetMapForTilesForPlayerIndex(playerIndex)
    end
    if (visionModifierForUnits > 0) then
        modelFogMap:resetMapForUnitsForPlayerIndex(playerIndex)
    end

    return revealedTiles, revealedUnits
end

return VisibilityFunctions
