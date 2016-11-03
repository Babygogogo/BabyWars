
local ModelFogMap = require("src.global.functions.class")("ModelFogMap")

local GridIndexFunctions = require("src.app.utilities.GridIndexFunctions")
local SingletonGetters   = require("src.app.utilities.SingletonGetters")

local IS_SERVER        = require("src.app.utilities.GameConstantFunctions").isServer()
local WebSocketManager = (not IS_SERVER) and (require("src.app.utilities.WebSocketManager")) or (nil)

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

local function createSerializableDataForVisibilityMapForPath(map, mapSize)
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

local function createVisibilityMapForPathWithData(data, mapSize)
    if (not data) then
        return createSingleMap(mapSize, 0)
    end

    local map           = createSingleMap(mapSize, 0)
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

local function updateMapForArmy(map, mapSize, origin, vision, modifier)
    if (vision) then
        assert((modifier == 1) or (modifier == -1), "ModelFogMap-updateMapForArmy() invalid modifier: " .. (modifier or ""))
        for _, gridIndex in pairs(GridIndexFunctions.getGridsWithinDistance(origin, 0, vision, mapSize)) do
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
    local mapSize                = SingletonGetters.getModelTileMap(sceneWarFileName):getMapSize()
    self.m_DataForInitialization = nil
    self.m_MapSize               = mapSize

    if (not data) then
        self.m_StateForForcingFog   = "None"
        self.m_VisibilityMapForPath = createSingleMap(mapSize, 0)
    else
        self.m_StateForForcingFog               = data.stateForForcingFog
        self.m_ExpiringTurnIndexForForcingFog   = data.expiringTurnIndexForForcingFog
        self.m_ExpiringPlayerIndexForForcingFog = data.expiringPlayerIndexForForcingFog
        self.m_VisibilityMapForPath             = createVisibilityMapForPathWithData(data.visibilityMapForPath, mapSize)
    end

    if (IS_SERVER) then
        self.m_VisibilityMapsForArmy = {}
        for playerIndex = 1, SingletonGetters.getModelPlayerManager(sceneWarFileName):getPlayersCount() do
            self.m_VisibilityMapsForArmy[playerIndex] = createSingleMap(mapSize, 0)
            self:resetMapForArmyForPlayerIndex(playerIndex)
        end
    else
        self.m_VisibilityMapsForArmy = {[self.m_PlayerIndexLoggedIn] = createSingleMap(mapSize, 0)}
        self:resetMapForArmyForPlayerIndex(self.m_PlayerIndexLoggedIn)
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
        visibilityMapForPath             = createSerializableDataForVisibilityMapForPath(self.m_VisibilityMapForPath, self:getMapSize()),
    }
end

function ModelFogMap:toSerializableTableForPlayerIndex(playerIndex)
    return {
        stateForForcingFog               = self.m_StateForForcingFog,
        expiringTurnIndexForForcingFog   = self.m_ExpiringTurnIndexForForcingFog,
        expiringPlayerIndexForForcingFog = self.m_ExpiringPlayerIndexForForcingFog,
        visibilityMapForPath             = (SingletonGetters.getModelTurnManager(self.m_SceneWarFileName):getPlayerIndex() == playerIndex)
            and (createSerializableDataForVisibilityMapForPath(self.m_VisibilityMapForPath, self:getMapSize()))
            or  (nil),
    }
end

--------------------------------------------------------------------------------
-- The callback functions on start running/script events.
--------------------------------------------------------------------------------
function ModelFogMap:onStartRunning(sceneWarFileName)
    self.m_SceneWarFileName    = sceneWarFileName
    self.m_IsFogOfWarByDefault = SingletonGetters.getModelScene(sceneWarFileName):isFogOfWarByDefault()
    if (not IS_SERVER) then
        local _, playerIndexLoggedIn = SingletonGetters.getModelPlayerManager():getModelPlayerWithAccount(WebSocketManager.getLoggedInAccountAndPassword())
        self.m_PlayerIndexLoggedIn   = playerIndexLoggedIn
    end

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

function ModelFogMap:resetMapForArmyForPlayerIndex(playerIndex)
    assert(self:isInitialized(), "ModelFogMap:resetMapForArmyForPlayerIndex() the maps have not been initialized yet.")
    if (not IS_SERVER) then
        assert(playerIndex == self.m_PlayerIndexLoggedIn,
            "ModelFogMap:resetMapForArmyForPlayerIndex() invalid playerIndex on the client: " .. (playerIndex or ""))
    end

    local sceneWarFileName = self.m_SceneWarFileName
    local modelTileMap     = SingletonGetters.getModelTileMap(sceneWarFileName)
    local modelUnitMap     = SingletonGetters.getModelUnitMap(sceneWarFileName)
    local visibilityMap    = self.m_VisibilityMapsForArmy[playerIndex]
    local mapSize          = self:getMapSize()
    local width, height    = mapSize.width, mapSize.height
    local gridIndex        = {}

    fillSingleMapWithValue(visibilityMap, mapSize, 0)
    for x = 1, width do
        for y = 1, height do
            gridIndex.x, gridIndex.y = x, y
            updateMapForArmy(visibilityMap, mapSize, gridIndex, getVisionForModelTileOrUnit(modelTileMap:getModelTile(gridIndex), playerIndex), 1)
            updateMapForArmy(visibilityMap, mapSize, gridIndex, getVisionForModelTileOrUnit(modelUnitMap:getModelUnit(gridIndex), playerIndex), 1)
        end
    end

    return self
end

function ModelFogMap:clearMapForPath()
    assert(self:isInitialized(), "ModelFogMap:clearMapForPath() the map have not been initialized yet.")
    fillSingleMapWithValue(self.m_VisibilityMapForPath, self:getMapSize(), 0)

    return self
end

function ModelFogMap:hasFogOnGridForPlayerIndex(gridIndex, playerIndex)
    if (not IS_SERVER) then
        assert(playerIndex == self.m_PlayerIndexLoggedIn,
            "ModelFogMap:hasFogOnGridForPlayerIndex() invalid playerIndex on the client: " .. (playerIndex or ""))
    end

    if (not self:isFogOfWarCurrently()) then
        return false
    else
        local x, y              = gridIndex.x, gridIndex.y
        local playerIndexInTurn = SingletonGetters.getModelTurnManager(self.m_SceneWarFileName):getPlayerIndex()
        local mapForArmy        = self.m_VisibilityMapsForArmy[playerIndex]
        local mapForPath        = (playerIndexInTurn == playerIndex) and (self.m_VisibilityMapForPath) or (nil)
        return not (((mapForArmy) and (mapForArmy[x][y] > 0)) or ((mapForPath) and (mapForPath[x][y] > 0)))
    end
end

return ModelFogMap
