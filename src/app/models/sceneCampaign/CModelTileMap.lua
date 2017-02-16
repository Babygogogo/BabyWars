
local CModelTileMap = requireBW("src.global.functions.class")("CModelTileMap")

local VisibilityFunctions    = requireBW("src.app.utilities.VisibilityFunctions")
local WarFieldManager        = requireBW("src.app.utilities.WarFieldManager")
local Actor                  = requireBW("src.global.actors.Actor")

local ceil          = math.ceil
local isTileVisible = VisibilityFunctions.isTileVisibleToPlayerIndex

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getXYWithPositionIndex(positionIndex, height)
    local x = ceil(positionIndex / height)
    return x, positionIndex - (x - 1) * height
end

local function createEmptyMap(width)
    local map = {}
    for x = 1, width do
        map[x] = {}
    end

    return map
end

local function createActorTilesMapWithWarFieldFileName(warFieldFileName)
    local templateWarField = WarFieldManager.getWarFieldData(warFieldFileName)
    local baseLayer        = templateWarField.layers[1]
    local objectLayerData  = templateWarField.layers[2].data
    local width, height    = baseLayer.width, baseLayer.height
    local baseLayerData    = baseLayer.data
    local map              = createEmptyMap(width)

    for x = 1, width do
        for y = 1, height do
            local idIndex = x + (height - y) * width
            local actorData = {
                positionIndex = (x - 1) * height + y,
                objectID      = objectLayerData[idIndex],
                baseID        = baseLayerData[idIndex],
                GridIndexable = {x = x, y = y},
            }
            map[x][y] = Actor.createWithModelAndViewInstance(
                Actor.createModel("sceneCampaign.CModelTile", actorData),
                Actor.createView( "sceneWar.ViewTile")
            )
        end
    end

    return map, {width = width, height = height}
end

local function updateActorTilesMapWithTilesData(map, height, tiles)
    if (tiles) then
        for positionIndex, singleTileData in pairs(tiles) do
            local x, y = getXYWithPositionIndex(positionIndex, height)
            singleTileData.GridIndexable = (singleTileData.GridIndexable) or ({x = x, y = y})
            map[x][y]:getModel():ctor(singleTileData)
        end
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function CModelTileMap:ctor(param, warFieldFileName)
    local map, mapSize = createActorTilesMapWithWarFieldFileName(warFieldFileName)
    updateActorTilesMapWithTilesData(map, mapSize.height, (param) and (param.tiles) or (nil))

    self.m_ActorTilesMap = map
    self.m_MapSize       = mapSize

    return self
end

function CModelTileMap:initView()
    local view = self.m_View
    assert(view, "CModelTileMap:initView() no view is attached to the owner actor of the model.")
    view:removeAllChildren()

    local mapSize = self:getMapSize()
    for y = mapSize.height, 1, -1 do
        for x = mapSize.width, 1, -1 do
            view:addChild(self.m_ActorTilesMap[x][y]:getView())
        end
    end

    return self
end

function CModelTileMap:updateOnModelFogMapStartedRunning()
    local playerIndex = 1
    self:forEachModelTile(function(modelTile)
        modelTile:initHasFogOnClient(not isTileVisible(self.m_ModelSceneCampaign, modelTile:getGridIndex(), playerIndex))
            :updateView()
    end)

    return self
end

--------------------------------------------------------------------------------
-- The function for serialization.
--------------------------------------------------------------------------------
function CModelTileMap:toSerializableTable()
    local tiles = {}
    self:forEachModelTile(function(modelTile)
        tiles[modelTile:getPositionIndex()] = modelTile:toSerializableTable()
    end)

    return {tiles = tiles}
end

--------------------------------------------------------------------------------
-- The callback functions on start running/script events.
--------------------------------------------------------------------------------
function CModelTileMap:onStartRunning(modelSceneCampaign)
    self.m_ModelSceneCampaign = modelSceneCampaign
    self:forEachModelTile(function(modelTile)
        modelTile:onStartRunning(modelSceneCampaign)
    end)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function CModelTileMap:getMapSize()
    return self.m_MapSize
end

function CModelTileMap:getModelTile(gridIndex)
    return self.m_ActorTilesMap[gridIndex.x][gridIndex.y]:getModel()
end

function CModelTileMap:getModelTileWithPositionIndex(positionIndex)
    local x, y = getXYWithPositionIndex(positionIndex, self:getMapSize().height)
    return self.m_ActorTilesMap[x][y]:getModel()
end

function CModelTileMap:forEachModelTile(func)
    local mapSize = self:getMapSize()
    for x = 1, mapSize.width do
        for y = 1, mapSize.height do
            func(self.m_ActorTilesMap[x][y]:getModel(), x, y)
        end
    end

    return self
end

return CModelTileMap
