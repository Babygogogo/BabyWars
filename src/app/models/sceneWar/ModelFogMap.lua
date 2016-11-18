
local ModelFogMap = require("src.global.functions.class")("ModelFogMap")

local GridIndexFunctions     = require("src.app.utilities.GridIndexFunctions")
local SingletonGetters       = require("src.app.utilities.SingletonGetters")
local SkillModifierFunctions = require("src.app.utilities.SkillModifierFunctions")

local IS_SERVER        = require("src.app.utilities.GameConstantFunctions").isServer()
local WebSocketManager = (not IS_SERVER) and (require("src.app.utilities.WebSocketManager")) or (nil)

local canRevealHidingPlacesForUnits = SkillModifierFunctions.canRevealHidingPlacesForUnits
local getGridsWithinDistance        = GridIndexFunctions.getGridsWithinDistance
local getModelPlayerManager         = SingletonGetters.getModelPlayerManager
local getModelTileMap               = SingletonGetters.getModelTileMap
local getModelUnitMap               = SingletonGetters.getModelUnitMap
local getPlayerIndexLoggedIn        = SingletonGetters.getPlayerIndexLoggedIn

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function setInitialized(self, initialized)
    self.m_IsInitialized = initialized
end

local function getVisionForModelTileOrUnit(modelTileOrUnit, playerIndex, visionModifier)
    if ((modelTileOrUnit) and (modelTileOrUnit.getVisionForPlayerIndex)) then
        local vision = modelTileOrUnit:getVisionForPlayerIndex(playerIndex)
        if (vision) then
            return vision + visionModifier
        end
    end
    return nil
end

local function fillArray(array, size, value)
    for i = 1, size do
        array[i] = value
    end

    return array
end

local function fillSingleMapWithValue(map, mapSize, value)
    local width, height = mapSize.width, mapSize.height
    for x = 1, width do
        fillArray(map[x], height, value)
    end

    return map
end

local function createSingleMap(mapSize, defaultValue)
    local map           = {}
    local width, height = mapSize.width, mapSize.height
    for x = 1, width do
        map[x] = fillArray({}, height, defaultValue)
    end

    return map
end

local function createSerializableDataForSingleMapForPaths(map, mapSize)
    local width, height = mapSize.width, mapSize.height
    local array         = {}
    for x = 1, width do
        local column = map[x]
        local offset = (x - 1) * height
        for y = 1, height do
            array[offset + y] = column[y]
        end
    end

    return table.concat(array)
end

local function createSerializableDataForMapsForPaths(maps, mapSize, playerIndex)
    if (playerIndex) then
        return {[playerIndex] = createSerializableDataForSingleMapForPaths(maps[playerIndex], mapSize)}
    else
        local data = {}
        for index, map in ipairs(maps) do
            data[index] = createSerializableDataForSingleMapForPaths(map, mapSize)
        end
        return data
    end
end

local function fillMapForPathsWithData(map, mapSize, data)
    local width, height = mapSize.width, mapSize.height
    local byteFor0      = string.byte("0")
    local bytesForData  = {string.byte(data, 1, -1)}
    for x = 1, width do
        local column = map[x]
        local offset = (x - 1) * height
        for y = 1, height do
            column[y] = bytesForData[offset + y] - byteFor0
        end
    end

    return map
end

local function updateMapForPaths(map, mapSize, origin, vision, canRevealHidingPlaces)
    if (vision) then
        if (canRevealHidingPlaces) then
            for _, gridIndex in pairs(getGridsWithinDistance(origin, 0, vision, mapSize)) do
                map[gridIndex.x][gridIndex.y] = 2
            end
        else
            for _, gridIndex in pairs(getGridsWithinDistance(origin, 0, 1, mapSize)) do
                map[gridIndex.x][gridIndex.y] = 2
            end
            for _, gridIndex in pairs(getGridsWithinDistance(origin, 2, vision, mapSize)) do
                map[gridIndex.x][gridIndex.y] = math.max(1, map[gridIndex.x][gridIndex.y])
            end
        end
    end
end

local function updateMapForTilesOrUnits(map, mapSize, origin, vision, modifier)
    assert((modifier == 1) or (modifier == -1), "ModelFogMap-updateMapForTilesOrUnits() invalid modifier: " .. (modifier or ""))
    if (vision) then
        for _, gridIndex in pairs(getGridsWithinDistance(origin, 0, vision, mapSize)) do
            map[gridIndex.x][gridIndex.y] = map[gridIndex.x][gridIndex.y] + modifier
        end
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelFogMap:ctor(param)
    if (not param) then
        assert(IS_SERVER, "ModelFogMap:ctor() param can't be nil on the client.")
    else
        self.m_DataForInitialization = param
    end

    return self
end

function ModelFogMap:initialize()
    assert(not self:isInitialized(), "ModelFogMap:initialize() the map has been initialized already.")
    assert(self.m_SceneWarFileName, "ModelFogMap:initialize() the onStartRunning() hasn't been called yet.")
    setInitialized(self, true)

    local data                   = self.m_DataForInitialization
    local sceneWarFileName       = self.m_SceneWarFileName
    local mapSize                = getModelTileMap(sceneWarFileName):getMapSize()
    self.m_DataForInitialization = nil
    self.m_MapSize               = mapSize
    self.m_MapsForPaths          = {}
    self.m_MapsForTiles          = {}
    self.m_MapsForUnits          = {}

    if (not data) then
        self.m_StateForForcingFog = "None"
    else
        self.m_StateForForcingFog               = data.stateForForcingFog
        self.m_ExpiringTurnIndexForForcingFog   = data.expiringTurnIndexForForcingFog
        self.m_ExpiringPlayerIndexForForcingFog = data.expiringPlayerIndexForForcingFog
    end

    if (IS_SERVER) then
        local mapsForPaths = (data) and (data.mapsForPaths) or (nil)
        for playerIndex = 1, getModelPlayerManager(sceneWarFileName):getPlayersCount() do
            self.m_MapsForPaths[playerIndex] = createSingleMap(mapSize, 0)
            self.m_MapsForTiles[playerIndex] = createSingleMap(mapSize, 0)
            self.m_MapsForUnits[playerIndex] = createSingleMap(mapSize, 0)
            self:resetMapForPathsForPlayerIndex(playerIndex, mapsForPaths and mapsForPaths[playerIndex] or nil)
                :resetMapForTilesForPlayerIndex(playerIndex)
                :resetMapForUnitsForPlayerIndex(playerIndex)
        end
    else
        local playerIndex = getPlayerIndexLoggedIn()
        self.m_MapsForPaths[playerIndex] = createSingleMap(mapSize, 0)
        self.m_MapsForTiles[playerIndex] = createSingleMap(mapSize, 0)
        self.m_MapsForUnits[playerIndex] = createSingleMap(mapSize, 0)
        self:resetMapForPathsForPlayerIndex(playerIndex, data and data.mapsForPaths and data.mapsForPaths[playerIndex])
            :resetMapForTilesForPlayerIndex(playerIndex)
            :resetMapForUnitsForPlayerIndex(playerIndex)
    end

    return self
end

--------------------------------------------------------------------------------
-- The functions for serialization.
--------------------------------------------------------------------------------
function ModelFogMap:toSerializableTable()
    return {
        stateForForcingFog               = self.m_StateForForcingFog,
        expiringTurnIndexForForcingFog   = self.m_ExpiringTurnIndexForForcingFog,
        expiringPlayerIndexForForcingFog = self.m_ExpiringPlayerIndexForForcingFog,
        mapsForPaths                     = createSerializableDataForMapsForPaths(self.m_MapsForPaths, self:getMapSize()),
    }
end

function ModelFogMap:toSerializableTableForPlayerIndex(playerIndex)
    return {
        stateForForcingFog               = self.m_StateForForcingFog,
        expiringTurnIndexForForcingFog   = self.m_ExpiringTurnIndexForForcingFog,
        expiringPlayerIndexForForcingFog = self.m_ExpiringPlayerIndexForForcingFog,
        mapsForPaths                     = createSerializableDataForMapsForPaths(self.m_MapsForPaths, self:getMapSize(), playerIndex),
    }
end

--------------------------------------------------------------------------------
-- The callback functions on start running/script events.
--------------------------------------------------------------------------------
function ModelFogMap:onStartRunning(sceneWarFileName)
    self.m_SceneWarFileName    = sceneWarFileName
    self.m_IsFogOfWarByDefault = SingletonGetters.getModelScene(sceneWarFileName):isFogOfWarByDefault()

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelFogMap:isInitialized()
    return self.m_IsInitialized
end

function ModelFogMap:getMapSize()
    return self.m_MapSize
end

function ModelFogMap:isFogOfWarCurrently()
    return (self:isEnablingFogByForce())
        or ((self.m_IsFogOfWarByDefault) and (not self:isDisablingFogByForce()))
end

function ModelFogMap:isEnablingFogByForce()
    return self.m_StateForForcingFog == "Enabled"
end

function ModelFogMap:isDisablingFogByForce()
    return self.m_StateForForcingFog == "Disabled"
end

function ModelFogMap:resetMapForPathsForPlayerIndex(playerIndex, data)
    assert(self:isInitialized(), "ModelFogMap:resetMapForPathsForPlayerIndex() the map have not been initialized yet.")
    if (not IS_SERVER) then
        assert(playerIndex == getPlayerIndexLoggedIn(), "ModelFogMap:resetMapForPathsForPlayerIndex() invalid playerIndex on the client: " .. (playerIndex or ""))
    end

    local visibilityMap = self.m_MapsForPaths[playerIndex]
    local mapSize       = self:getMapSize()
    if (data) then
        fillMapForPathsWithData(visibilityMap, mapSize, data)
    else
        fillSingleMapWithValue(visibilityMap, mapSize, 0)
    end

    return self
end

function ModelFogMap:updateMapForPathsWithModelUnitAndPath(modelUnit, path)
    local playerIndex = modelUnit:getPlayerIndex()
    if (not IS_SERVER) then
        assert(playerIndex == getPlayerIndexLoggedIn(), "ModelFogMap:updateMapForPathsWithModelUnitAndPath() invalid playerIndex on the client: " .. (playerIndex or ""))
    end

    local canRevealHidingPlaces = canRevealHidingPlacesForUnits(getModelPlayerManager(self.m_SceneWarFileName):getModelPlayer(playerIndex):getModelSkillConfiguration())
    local visibilityMap         = self.m_MapsForPaths[playerIndex]
    local mapSize               = self:getMapSize()
    for _, pathNode in ipairs(path) do
        updateMapForPaths(visibilityMap, mapSize, pathNode, modelUnit:getVisionForPlayerIndex(playerIndex, pathNode), canRevealHidingPlaces)
    end

    return self
end

function ModelFogMap:updateMapForPathsForPlayerIndexWithFlare(playerIndex, origin, radius)
    if (not IS_SERVER) then
        assert(playerIndex == getPlayerIndexLoggedIn(), "ModelFogMap:updateMapForPathsForPlayerIndexWithFlare() invalid playerIndex on the client: " .. (playerIndex or ""))
    end

    local visibilityMap = self.m_MapsForPaths[playerIndex]
    for _, gridIndex in pairs(getGridsWithinDistance(origin, 0, radius, self:getMapSize())) do
        visibilityMap[gridIndex.x][gridIndex.y] = 2
    end

    return self
end

function ModelFogMap:resetMapForTilesForPlayerIndex(playerIndex, visionModifier)
    assert(self:isInitialized(), "ModelFogMap:resetMapForTilesForPlayerIndex() the maps have not been initialized yet.")
    if (not IS_SERVER) then
        assert(playerIndex == getPlayerIndexLoggedIn(), "ModelFogMap:resetMapForTilesForPlayerIndex() invalid playerIndex on the client: " .. (playerIndex or ""))
    end

    local visibilityMap = self.m_MapsForTiles[playerIndex]
    local mapSize       = self:getMapSize()
    visionModifier      = visionModifier or 0
    fillSingleMapWithValue(visibilityMap, mapSize, 0)
    getModelTileMap(self.m_SceneWarFileName):forEachModelTile(function(modelTile)
        updateMapForTilesOrUnits(visibilityMap, mapSize, modelTile:getGridIndex(), getVisionForModelTileOrUnit(modelTile, playerIndex, visionModifier) , 1)
    end)

    return self
end

function ModelFogMap:updateMapForTilesForPlayerIndexOnGettingOwnership(playerIndex, gridIndex, vision)
    updateMapForTilesOrUnits(self.m_MapsForTiles[playerIndex], self:getMapSize(), gridIndex, vision, 1)

    return self
end

function ModelFogMap:updateMapForTilesForPlayerIndexOnLosingOwnership(playerIndex, gridIndex, vision)
    updateMapForTilesOrUnits(self.m_MapsForTiles[playerIndex], self:getMapSize(), gridIndex, vision, -1)

    return self
end

function ModelFogMap:resetMapForUnitsForPlayerIndex(playerIndex, visionModifier)
    assert(self:isInitialized(), "ModelFogMap:resetMapForUnitsForPlayerIndex() the maps have not been initialized yet.")
    if (not IS_SERVER) then
        assert(playerIndex == getPlayerIndexLoggedIn(), "ModelFogMap:resetMapForUnitsForPlayerIndex() invalid playerIndex on the client: " .. (playerIndex or ""))
    end

    local visibilityMap = self.m_MapsForUnits[playerIndex]
    local mapSize       = self:getMapSize()
    visionModifier      = visionModifier or 0
    fillSingleMapWithValue(visibilityMap, mapSize, 0)
    getModelUnitMap(self.m_SceneWarFileName):forEachModelUnitOnMap(function(modelUnit)
        updateMapForTilesOrUnits(visibilityMap, mapSize, modelUnit:getGridIndex(), getVisionForModelTileOrUnit(modelUnit, playerIndex, visionModifier), 1)
    end)

    return self
end

function ModelFogMap:updateMapForUnitsForPlayerIndexOnUnitArrive(playerIndex, gridIndex, vision)
    updateMapForTilesOrUnits(self.m_MapsForUnits[playerIndex], self:getMapSize(), gridIndex, vision, 1)

    return self
end

function ModelFogMap:updateMapForUnitsForPlayerIndexOnUnitLeave(playerIndex, gridIndex, vision)
    updateMapForTilesOrUnits(self.m_MapsForUnits[playerIndex], self:getMapSize(), gridIndex, vision, -1)

    return self
end

function ModelFogMap:getVisibilityOnGridForPlayerIndex(gridIndex, playerIndex)
    -- This function returns 3 numbers, indicating the visibility calculated with the move paths/tiles/units of the playerIndex.
    -- Each visibility can be 0 or 1:
    -- 0: The grid is out of vision completely.
    -- 1: The grid is in vision, but it's not sure that it is visible or not.
    -- The visibility of paths can also be 2:
    -- 2: The grid is in vision and is visible to the playerIndex.

    -- The skills that enable the tiles/units to see through the hiding places are ignored for the maps for tiles/units, while they are considered for the maps for move paths.
    -- To check if a tile/unit is visible to a player, use functions in VisibilityFunctions.

    if (not IS_SERVER) then
        assert(playerIndex == getPlayerIndexLoggedIn(), "ModelFogMap:getVisibilityOnGridForPlayerIndex() invalid playerIndex on the client: " .. (playerIndex or ""))
    end

    if (not self:isFogOfWarCurrently()) then
        return 2, 1, 1
    else
        local x, y = gridIndex.x, gridIndex.y
        return self.m_MapsForPaths[playerIndex][x][y],
            (self.m_MapsForTiles[playerIndex][x][y] > 0) and (1) or (0),
            (self.m_MapsForUnits[playerIndex][x][y] > 0) and (1) or (0)
    end
end

return ModelFogMap
