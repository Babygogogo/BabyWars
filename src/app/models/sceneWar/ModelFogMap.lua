
local ModelFogMap = require("src.global.functions.class")("ModelFogMap")

local GridIndexFunctions = require("src.app.utilities.GridIndexFunctions")
local SingletonGetters   = require("src.app.utilities.SingletonGetters")

local IS_SERVER        = require("src.app.utilities.GameConstantFunctions").isServer()
local WebSocketManager = (not IS_SERVER) and (require("src.app.utilities.WebSocketManager")) or (nil)

local getGridsWithinDistance = GridIndexFunctions.getGridsWithinDistance
local getModelTileMap        = SingletonGetters.getModelTileMap
local getModelUnitMap        = SingletonGetters.getModelUnitMap
local getPlayerIndexLoggedIn = SingletonGetters.getPlayerIndexLoggedIn

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function setInitialized(self, initialized)
    self.m_IsInitialized = initialized
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

local function createSerializableDataForSingleMapForUnits(map, mapSize)
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

local function createSerializableDataForMapsForUnits(maps, mapSize, playerIndex)
    if (playerIndex) then
        return {[playerIndex] = createSerializableDataForSingleMapForUnits(maps[playerIndex], mapSize)}
    else
        local data = {}
        for index, map in ipairs(maps) do
            data[index] = createSerializableDataForSingleMapForUnits(map, mapSize)
        end
        return data
    end
end

local function fillMapForUnitWithData(map, mapSize, data)
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

local function getVisionForModelTileOrUnit(modelTileOrUnit, playerIndex)
    return ((modelTileOrUnit) and (modelTileOrUnit.getVisionForPlayerIndex))
        and (modelTileOrUnit:getVisionForPlayerIndex(playerIndex))
        or (nil)
end

local function updateMapForTiles(map, mapSize, origin, vision, modifier)
    assert((modifier == 1) or (modifier == -1), "ModelFogMap-updateMapForTiles() invalid modifier: " .. (modifier or ""))
    if (vision) then
        for _, gridIndex in pairs(getGridsWithinDistance(origin, 0, vision, mapSize)) do
            map[gridIndex.x][gridIndex.y] = map[gridIndex.x][gridIndex.y] + modifier
        end
    end
end

local function updateMapForUnits(map, mapSize, origin, vision, canSeeThrough)
    if (not vision) then
        return
    end

    for _, gridIndex in pairs(getGridsWithinDistance(origin, 0, vision, mapSize)) do
        map[gridIndex.x][gridIndex.y] = 2
    end

    local visibility = (canSeeThrough) and (2) or (1)
    for _, gridIndex in pairs(getGridsWithinDistance(origin, 2, vision, mapSize)) do
        map[gridIndex.x][gridIndex.y] = visibility
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
    self.m_MapsForTiles          = {}
    self.m_MapsForUnits          = {}

    if (not data) then
        self.m_StateForForcingFog   = "None"
    else
        self.m_StateForForcingFog               = data.stateForForcingFog
        self.m_ExpiringTurnIndexForForcingFog   = data.expiringTurnIndexForForcingFog
        self.m_ExpiringPlayerIndexForForcingFog = data.expiringPlayerIndexForForcingFog
    end

    if (IS_SERVER) then
        local mapsForUnits = (data) and (data.mapsForUnits) or (nil)
        for playerIndex = 1, SingletonGetters.getModelPlayerManager(sceneWarFileName):getPlayersCount() do
            self.m_MapsForTiles[playerIndex] = createSingleMap(mapSize, 0)
            self.m_MapsForUnits[playerIndex] = createSingleMap(mapSize, 0)
            self:resetMapForTilesForPlayerIndex(playerIndex)
            self:resetMapForUnitsForPlayerIndex(playerIndex, mapsForUnits and mapsForUnits[playerIndex] or nil)
        end
    else
        local playerIndex = getPlayerIndexLoggedIn()
        self.m_MapsForTiles[playerIndex] = createSingleMap(mapSize, 0)
        self.m_MapsForUnits[playerIndex] = createSingleMap(mapSize, 0)
        self:resetMapForTilesForPlayerIndex(playerIndex)
        self:resetMapForUnitsForPlayerIndex(playerIndex, data and data.mapsForUnits and data.mapsForUnits[playerIndex])
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
        mapsForUnits                     = createSerializableDataForMapsForUnits(self.m_MapsForUnits, self:getMapSize()),
    }
end

function ModelFogMap:toSerializableTableForPlayerIndex(playerIndex)
    return {
        stateForForcingFog               = self.m_StateForForcingFog,
        expiringTurnIndexForForcingFog   = self.m_ExpiringTurnIndexForForcingFog,
        expiringPlayerIndexForForcingFog = self.m_ExpiringPlayerIndexForForcingFog,
        mapsForUnits                     = createSerializableDataForMapsForUnits(self.m_MapsForUnits, self:getMapSize(), playerIndex),
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

function ModelFogMap:resetMapForTilesForPlayerIndex(playerIndex)
    assert(self:isInitialized(), "ModelFogMap:resetMapForTilesForPlayerIndex() the maps have not been initialized yet.")
    if (not IS_SERVER) then
        assert(playerIndex == getPlayerIndexLoggedIn(), "ModelFogMap:resetMapForTilesForPlayerIndex() invalid playerIndex on the client: " .. (playerIndex or ""))
    end

    local visibilityMap = self.m_MapsForTiles[playerIndex]
    local mapSize       = self:getMapSize()
    fillSingleMapWithValue(visibilityMap, mapSize, 0)
    getModelTileMap(self.m_SceneWarFileName):forEachModelTile(function(modelTile)
        updateMapForTiles(visibilityMap, mapSize, modelTile:getGridIndex(), getVisionForModelTileOrUnit(modelTile, playerIndex), 1)
    end)

    return self
end

function ModelFogMap:resetMapForUnitsForPlayerIndex(playerIndex, data)
    assert(self:isInitialized(), "ModelFogMap:resetMapForUnitsForPlayerIndex() the map have not been initialized yet.")
    if (not IS_SERVER) then
        assert(playerIndex == getPlayerIndexLoggedIn(), "ModelFogMap:resetMapForUnitsForPlayerIndex() invalid playerIndex on the client: " .. (playerIndex or ""))
    end

    local visibilityMap = self.m_MapsForUnits[playerIndex]
    local mapSize       = self:getMapSize()
    if (data) then
        fillMapForUnitWithData(visibilityMap, mapSize, data)
        return
    end

    fillSingleMapWithValue(visibilityMap, mapSize, 0)
    getModelUnitMap(self.m_SceneWarFileName):forEachModelUnitOnMap(function(modelUnit)
        -- TODO: check if the units can see through hiding places.
        updateMapForUnits(visibilityMap, mapSize, modelUnit:getGridIndex(), getVisionForModelTileOrUnit(modelUnit, playerIndex), false)
    end)

    return self
end

function ModelFogMap:hasFogOnGridForPlayerIndex(gridIndex, playerIndex)
    if (not IS_SERVER) then
        assert(playerIndex == getPlayerIndexLoggedIn(), "ModelFogMap:hasFogOnGridForPlayerIndex() invalid playerIndex on the client: " .. (playerIndex or ""))
    end

    if (not self:isFogOfWarCurrently()) then
        return false
    else
        local x, y        = gridIndex.x, gridIndex.y
        local mapForTiles = self.m_MapsForTiles[playerIndex]
        local mapForUnits = self.m_MapsForUnits[playerIndex]
        return not (((mapForTiles) and (mapForTiles[x][y] > 0)) or ((mapForUnits) and (mapForUnits[x][y] > 0)))
    end
end

return ModelFogMap
