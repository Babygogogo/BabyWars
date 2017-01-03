
local ModelFogMap = require("src.global.functions.class")("ModelFogMap")

local GridIndexFunctions     = require("src.app.utilities.GridIndexFunctions")
local SingletonGetters       = require("src.app.utilities.SingletonGetters")
local SkillModifierFunctions = require("src.app.utilities.SkillModifierFunctions")

local canRevealHidingPlacesWithUnits = SkillModifierFunctions.canRevealHidingPlacesWithUnits
local getGridsWithinDistance         = GridIndexFunctions.getGridsWithinDistance
local getModelPlayerManager          = SingletonGetters.getModelPlayerManager
local getModelScene                  = SingletonGetters.getModelScene
local getModelTileMap                = SingletonGetters.getModelTileMap
local getModelUnitMap                = SingletonGetters.getModelUnitMap
local getPlayerIndexLoggedIn         = SingletonGetters.getPlayerIndexLoggedIn

local IS_SERVER               = require("src.app.utilities.GameConstantFunctions").isServer()
local TEMPLATE_WAR_FIELD_PATH = "res.data.templateWarField."
local FORCING_FOG_CODE        = {
    None  = 0,
    Fog   = 1,
    Clear = 2,
}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getMapSizeAndPlayersCountWithWarFieldFileName(warFieldFileName)
    local mapData = require(TEMPLATE_WAR_FIELD_PATH .. warFieldFileName)
    return {width = mapData.width, height = mapData.height}, mapData.playersCount
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

local function createSerializableDataForSingleMapForPaths(map, mapSize, playerIndex)
    local width, height = mapSize.width, mapSize.height
    local array         = {}
    for x = 1, width do
        local column = map[x]
        local offset = (x - 1) * height
        for y = 1, height do
            array[offset + y] = column[y]
        end
    end

    return {
        playerIndex           = playerIndex,
        encodedFogMapForPaths = table.concat(array),
    }
end

local function createSerializableDataForMapsForPaths(maps, mapSize, playerIndex)
    if (playerIndex) then
        return {[playerIndex] = createSerializableDataForSingleMapForPaths(maps[playerIndex], mapSize, playerIndex)}
    else
        local data = {}
        for index, map in ipairs(maps) do
            data[index] = createSerializableDataForSingleMapForPaths(map, mapSize, index)
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
function ModelFogMap:ctor(param, warFieldFileName, isTotalReplay)
    param = param or {}
    local mapSize, playersCount             = getMapSizeAndPlayersCountWithWarFieldFileName(warFieldFileName)
    self.m_IsTotalReplay                    = isTotalReplay
    self.m_MapSize                          = mapSize
    self.m_ForcingFogCode                   = param.forcingFogCode or FORCING_FOG_CODE.None
    self.m_ExpiringPlayerIndexForForcingFog = param.expiringPlayerIndexForForcingFog
    self.m_ExpiringTurnIndexForForcingFog   = param.expiringTurnIndexForForcingFog
    self.m_MapsForPaths                     = {}
    self.m_MapsForTiles                     = {}
    self.m_MapsForUnits                     = {}

    local mapsForPaths = param.mapsForPaths
    if ((IS_SERVER) or (isTotalReplay)) then
        for playerIndex = 1, playersCount do
            self.m_MapsForPaths[playerIndex] = createSingleMap(mapSize, 0)
            self.m_MapsForTiles[playerIndex] = createSingleMap(mapSize, 0)
            self.m_MapsForUnits[playerIndex] = createSingleMap(mapSize, 0)
            self:resetMapForPathsForPlayerIndex(playerIndex, (mapsForPaths) and (mapsForPaths[playerIndex].encodedFogMapForPaths) or (nil))
        end
    else
        for playerIndex, mapData in pairs(mapsForPaths) do
            self.m_MapsForPaths[playerIndex] = createSingleMap(mapSize, 0)
            self.m_MapsForTiles[playerIndex] = createSingleMap(mapSize, 0)
            self.m_MapsForUnits[playerIndex] = createSingleMap(mapSize, 0)
            self:resetMapForPathsForPlayerIndex(playerIndex, mapData.encodedFogMapForPaths)
        end
    end

    return self
end

function ModelFogMap:initView()
    self.m_View:setMapSize(self:getMapSize())

    return self
end

--------------------------------------------------------------------------------
-- The functions for serialization.
--------------------------------------------------------------------------------
function ModelFogMap:toSerializableTable()
    return {
        forcingFogCode                   = self.m_ForcingFogCode,
        expiringTurnIndexForForcingFog   = self.m_ExpiringTurnIndexForForcingFog,
        expiringPlayerIndexForForcingFog = self.m_ExpiringPlayerIndexForForcingFog,
        mapsForPaths                     = createSerializableDataForMapsForPaths(self.m_MapsForPaths, self:getMapSize()),
    }
end

function ModelFogMap:toSerializableTableForPlayerIndex(playerIndex)
    return {
        forcingFogCode                   = self.m_ForcingFogCode,
        expiringTurnIndexForForcingFog   = self.m_ExpiringTurnIndexForForcingFog,
        expiringPlayerIndexForForcingFog = self.m_ExpiringPlayerIndexForForcingFog,
        mapsForPaths                     = createSerializableDataForMapsForPaths(self.m_MapsForPaths, self:getMapSize(), playerIndex),
    }
end

--------------------------------------------------------------------------------
-- The callback functions on start running/script events.
--------------------------------------------------------------------------------
function ModelFogMap:onStartRunning(modelSceneWar, sceneWarFileName)
    self.m_SceneWarFileName    = sceneWarFileName
    self.m_IsFogOfWarByDefault = getModelScene(sceneWarFileName):isFogOfWarByDefault()

    if ((IS_SERVER) or (self.m_IsTotalReplay)) then
        for playerIndex = 1, getModelPlayerManager(sceneWarFileName):getPlayersCount() do
            self:resetMapForTilesForPlayerIndex(playerIndex)
                :resetMapForUnitsForPlayerIndex(playerIndex)
        end
    else
        local playerIndex = getPlayerIndexLoggedIn(modelSceneWar)
        self:resetMapForTilesForPlayerIndex(playerIndex)
            :resetMapForUnitsForPlayerIndex(playerIndex)
    end

    self:updateView()

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelFogMap:getMapSize()
    return self.m_MapSize
end

function ModelFogMap:isFogOfWarCurrently()
    return (self:isEnablingFogByForce())
        or ((self.m_IsFogOfWarByDefault) and (not self:isDisablingFogByForce()))
end

function ModelFogMap:isEnablingFogByForce()
    return self.m_ForcingFogCode == "Enabled"
end

function ModelFogMap:isDisablingFogByForce()
    return self.m_ForcingFogCode == "Disabled"
end

function ModelFogMap:resetMapForPathsForPlayerIndex(playerIndex, data)
    assert((IS_SERVER) or (not self.m_SceneWarFileName) or (self.m_IsTotalReplay) or (playerIndex == getPlayerIndexLoggedIn()),
        "ModelFogMap:resetMapForPathsForPlayerIndex() invalid playerIndex on the client: " .. (playerIndex or ""))

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
    assert((IS_SERVER) or (self.m_IsTotalReplay) or (playerIndex == getPlayerIndexLoggedIn()),
        "ModelFogMap:updateMapForPathsWithModelUnitAndPath() invalid playerIndex on the client: " .. (playerIndex or ""))

    local canRevealHidingPlaces = canRevealHidingPlacesWithUnits(getModelPlayerManager(self.m_SceneWarFileName):getModelPlayer(playerIndex):getModelSkillConfiguration())
    local visibilityMap         = self.m_MapsForPaths[playerIndex]
    local mapSize               = self:getMapSize()
    for _, pathNode in ipairs(path) do
        updateMapForPaths(visibilityMap, mapSize, pathNode, modelUnit:getVisionForPlayerIndex(playerIndex, pathNode), canRevealHidingPlaces)
    end

    return self
end

function ModelFogMap:updateMapForPathsForPlayerIndexWithFlare(playerIndex, origin, radius)
    assert((IS_SERVER) or (self.m_IsTotalReplay) or (playerIndex == getPlayerIndexLoggedIn()),
        "ModelFogMap:updateMapForPathsForPlayerIndexWithFlare() invalid playerIndex on the client: " .. (playerIndex or ""))

    local visibilityMap = self.m_MapsForPaths[playerIndex]
    for _, gridIndex in pairs(getGridsWithinDistance(origin, 0, radius, self:getMapSize())) do
        visibilityMap[gridIndex.x][gridIndex.y] = 2
    end

    return self
end

function ModelFogMap:resetMapForTilesForPlayerIndex(playerIndex, visionModifier)
    assert((IS_SERVER) or (self.m_IsTotalReplay) or (playerIndex == getPlayerIndexLoggedIn()),
        "ModelFogMap:resetMapForTilesForPlayerIndex() invalid playerIndex on the client: " .. (playerIndex or ""))

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
    assert((IS_SERVER) or (self.m_IsTotalReplay) or (playerIndex == getPlayerIndexLoggedIn()),
        "ModelFogMap:resetMapForUnitsForPlayerIndex() invalid playerIndex on the client: " .. (playerIndex or ""))

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

    assert((IS_SERVER) or (self.m_IsTotalReplay) or (playerIndex == getPlayerIndexLoggedIn()),
        "ModelFogMap:getVisibilityOnGridForPlayerIndex() invalid playerIndex on the client: " .. (playerIndex or ""))

    if (not self:isFogOfWarCurrently()) then
        return 2, 1, 1
    else
        local x, y = gridIndex.x, gridIndex.y
        return self.m_MapsForPaths[playerIndex][x][y],
            (self.m_MapsForTiles[playerIndex][x][y] > 0) and (1) or (0),
            (self.m_MapsForUnits[playerIndex][x][y] > 0) and (1) or (0)
    end
end

function ModelFogMap:updateView()
    if (self.m_View) then
        self.m_View:updateWithModelFogMap()
    end

    return self
end

return ModelFogMap
