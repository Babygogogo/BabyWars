
local ModelFogMap = requireBW("src.global.functions.class")("ModelFogMap")

local GridIndexFunctions     = requireBW("src.app.utilities.GridIndexFunctions")
local SingletonGetters       = requireBW("src.app.utilities.SingletonGetters")
local SkillModifierFunctions = requireBW("src.app.utilities.SkillModifierFunctions")
local WarFieldManager        = requireBW("src.app.utilities.WarFieldManager")

local canRevealHidingPlacesWithUnits = SkillModifierFunctions.canRevealHidingPlacesWithUnits
local getGridsWithinDistance         = GridIndexFunctions.getGridsWithinDistance
local getModelPlayerManager          = SingletonGetters.getModelPlayerManager
local getModelTileMap                = SingletonGetters.getModelTileMap
local getModelUnitMap                = SingletonGetters.getModelUnitMap
local getPlayerIndexLoggedIn         = SingletonGetters.getPlayerIndexLoggedIn

local math          = math
local pairs, ipairs = pairs, ipairs

local IS_SERVER               = requireBW("src.app.utilities.GameConstantFunctions").isServer()
local FORCING_FOG_CODE        = {
    None  = 0,
    Fog   = 1,
    Clear = 2,
}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
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

local function createSerializableDataForMapsForPaths(self, targetPlayerIndex)
    local maps    = self.m_MapsForPaths
    local mapSize = self:getMapSize()
    local data    = {}

    if (not targetPlayerIndex) then
        for index, map in ipairs(maps) do
            data[index] = createSerializableDataForSingleMapForPaths(map, mapSize, index)
        end
    else
        local modelPlayerManager = SingletonGetters.getModelPlayerManager(self.m_ModelSceneWar)
        local teamIndex          = modelPlayerManager:getModelPlayer(targetPlayerIndex):getTeamIndex()
        modelPlayerManager:forEachModelPlayer(function(modelPlayer, playerIndex)
            if ((modelPlayer:isAlive()) and (modelPlayer:getTeamIndex() == teamIndex)) then
                data[playerIndex] = createSerializableDataForSingleMapForPaths(maps[playerIndex], mapSize, playerIndex)
            end
        end)
    end

    return data
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
function ModelFogMap:ctor(param, warFieldFileName)
    param = param or {}
    self.m_MapSize                          = WarFieldManager.getMapSize(warFieldFileName)
    self.m_ForcingFogCode                   = param.forcingFogCode or FORCING_FOG_CODE.None
    self.m_ExpiringPlayerIndexForForcingFog = param.expiringPlayerIndexForForcingFog
    self.m_ExpiringTurnIndexForForcingFog   = param.expiringTurnIndexForForcingFog
    self.m_MapsForPaths                     = {}
    self.m_MapsForTiles                     = {}
    self.m_MapsForUnits                     = {}

    local mapSize      = self.m_MapSize
    local mapsForPaths = param.mapsForPaths
    for playerIndex = 1, WarFieldManager.getPlayersCount(warFieldFileName) do
        self.m_MapsForPaths[playerIndex] = createSingleMap(mapSize, 0)
        self.m_MapsForTiles[playerIndex] = createSingleMap(mapSize, 0)
        self.m_MapsForUnits[playerIndex] = createSingleMap(mapSize, 0)

        if ((mapsForPaths) and (mapsForPaths[playerIndex])) then
            self:resetMapForPathsForPlayerIndex(playerIndex, mapsForPaths[playerIndex].encodedFogMapForPaths)
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
        mapsForPaths                     = createSerializableDataForMapsForPaths(self),
    }
end

function ModelFogMap:toSerializableTableForPlayerIndex(playerIndex)
    return {
        forcingFogCode                   = self.m_ForcingFogCode,
        expiringTurnIndexForForcingFog   = self.m_ExpiringTurnIndexForForcingFog,
        expiringPlayerIndexForForcingFog = self.m_ExpiringPlayerIndexForForcingFog,
        mapsForPaths                     = createSerializableDataForMapsForPaths(self, playerIndex),
    }
end

--------------------------------------------------------------------------------
-- The callback functions on start running/script events.
--------------------------------------------------------------------------------
function ModelFogMap:onStartRunning(modelWar)
    self.m_ModelSceneWar            = modelWar
    self.m_IsFogOfWarByDefault = modelWar:isFogOfWarByDefault()

    if ((IS_SERVER) or (SingletonGetters.isTotalReplay(modelWar))) then
        for playerIndex = 1, getModelPlayerManager(modelWar):getPlayersCount() do
            self:resetMapForTilesForPlayerIndex(playerIndex)
                :resetMapForUnitsForPlayerIndex(playerIndex)
        end
    else
        local modelPlayerManager = SingletonGetters.getModelPlayerManager(modelWar)
        local teamIndex          = modelPlayerManager:getModelPlayer(SingletonGetters.getPlayerIndexLoggedIn(modelWar)):getTeamIndex()
        modelPlayerManager:forEachModelPlayer(function(modelPlayer, playerIndex)
            if ((modelPlayer:isAlive()) and (modelPlayer:getTeamIndex() == teamIndex)) then
                self:resetMapForTilesForPlayerIndex(playerIndex)
                    :resetMapForUnitsForPlayerIndex(playerIndex)
            end
        end)
    end

    self:updateView()

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelFogMap:updateView()
    if (self.m_View) then
        self.m_View:updateWithModelFogMap(self)
    end

    return self
end

function ModelFogMap:getModelWar()
    assert(self.m_ModelSceneWar, "ModelFogMap:getModelWar() the method onStartRunning has not been called yet.")
    return self.m_ModelSceneWar
end

function ModelFogMap:getMapSize()
    return self.m_MapSize
end

function ModelFogMap:isFogOfWarCurrently()
    return (self:isEnablingFogByForce())
        or ((self.m_IsFogOfWarByDefault) and (not self:isDisablingFogByForce()))
end

function ModelFogMap:isEnablingFogByForce()
    return self.m_ForcingFogCode == FORCING_FOG_CODE.Fog
end

function ModelFogMap:isDisablingFogByForce()
    return self.m_ForcingFogCode == FORCING_FOG_CODE.Clear
end

function ModelFogMap:resetMapForPathsForPlayerIndex(playerIndex, data)
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
    local playerIndex           = modelUnit:getPlayerIndex()
    local canRevealHidingPlaces = canRevealHidingPlacesWithUnits(getModelPlayerManager(self.m_ModelSceneWar):getModelPlayer(playerIndex):getModelSkillConfiguration())
    local visibilityMap         = self.m_MapsForPaths[playerIndex]
    local mapSize               = self:getMapSize()
    for _, pathNode in ipairs(path) do
        updateMapForPaths(visibilityMap, mapSize, pathNode, modelUnit:getVisionForPlayerIndex(playerIndex, pathNode), canRevealHidingPlaces)
    end

    return self
end

function ModelFogMap:updateMapForPathsForPlayerIndexWithFlare(playerIndex, origin, radius)
    local visibilityMap = self.m_MapsForPaths[playerIndex]
    for _, gridIndex in pairs(getGridsWithinDistance(origin, 0, radius, self:getMapSize())) do
        visibilityMap[gridIndex.x][gridIndex.y] = 2
    end

    return self
end

function ModelFogMap:resetMapForTilesForPlayerIndex(playerIndex, visionModifier)
    local visibilityMap = self.m_MapsForTiles[playerIndex]
    local mapSize       = self:getMapSize()
    visionModifier      = visionModifier or 0
    fillSingleMapWithValue(visibilityMap, mapSize, 0)
    getModelTileMap(self.m_ModelSceneWar):forEachModelTile(function(modelTile)
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
    local visibilityMap = self.m_MapsForUnits[playerIndex]
    local mapSize       = self:getMapSize()
    visionModifier      = visionModifier or 0
    fillSingleMapWithValue(visibilityMap, mapSize, 0)
    getModelUnitMap(self.m_ModelSceneWar):forEachModelUnitOnMap(function(modelUnit)
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

    if (not self:isFogOfWarCurrently()) then
        return 2, 1, 1
    else
        local x, y = gridIndex.x, gridIndex.y
        return self.m_MapsForPaths[playerIndex][x][y],
            (self.m_MapsForTiles[playerIndex][x][y] > 0) and (1) or (0),
            (self.m_MapsForUnits[playerIndex][x][y] > 0) and (1) or (0)
    end
end

function ModelFogMap:getVisibilityOnGridForTeamIndex(gridIndex, teamIndex)
    local visibilityForPath, visibilityForTile, visibilityForUnit = 0, 0, 0
    SingletonGetters.getModelPlayerManager(self.m_ModelSceneWar):forEachModelPlayer(function(modelPlayer, playerIndex)
        if ((modelPlayer:isAlive()) and (modelPlayer:getTeamIndex() == teamIndex)) then
            local v1, v2, v3 = self:getVisibilityOnGridForPlayerIndex(gridIndex, playerIndex)
            visibilityForPath = math.max(visibilityForPath, v1)
            visibilityForTile = math.max(visibilityForTile, v2)
            visibilityForUnit = math.max(visibilityForUnit, v3)
        end
    end)

    return visibilityForPath, visibilityForTile, visibilityForUnit
end

return ModelFogMap
