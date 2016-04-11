
local ModelTileMap = class("ModelTileMap")

local Actor              = require("global.actors.Actor")
local TypeChecker        = require("app.utilities.TypeChecker")
local MapFunctions       = require("app.utilities.MapFunctions")
local ViewTile           = require("app.views.ViewTile")
local ModelTile          = require("app.models.ModelTile")
local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function requireMapData(param)
    local t = type(param)
    if (t == "string") then
        return require("data.tileMap." .. param)
    elseif (t == "table") then
        return param
    else
        return error("ModelTileMap-requireMapData() the param is invalid.")
    end
end

local function getTiledTileBaseLayer(tiledData)
    local layer = tiledData.layers[1]
    assert(layer, "ModelTileMap-getTiledTileBaseLayer() the param tiledData has no tile base layer.")

    return layer
end

local function getTiledTileObjectLayer(tiledData)
    local layer = tiledData.layers[2]
    assert(layer, "ModelTileMap-getTiledTileObjectLayer() the param tiledData has no tile object layer.")

    return layer
end

local function createEmptyMap(width)
    local map = {}
    for x = 1, width do
        map[x] = {}
    end

    return map
end

local function createActorTile(objectID, baseID, x, y)
    local actorData = {objectID = objectID, baseID = baseID, GridIndexable = {gridIndex = {x = x, y = y}}}
    return Actor.createWithModelAndViewName("ModelTile", actorData, "ViewTile", actorData)
end

local function createTileActorsMapWithTiledLayers(objectLayer, baseLayer)
    local width, height = baseLayer.width, baseLayer.height
    local map = createEmptyMap(width)

    for x = 1, width do
        for y = 1, height do
            local idIndex = x + (height - y) * width
            local objectTiledID, baseTiledID = objectLayer.data[idIndex], baseLayer.data[idIndex]
            map[x][y] = createActorTile(objectTiledID, baseTiledID, x, y)
        end
    end

    return map, {width = width, height = height}
end

local function updateTileActorsMapWithGridsData(map, mapSize, gridsData)
    for _, gridData in ipairs(gridsData) do
        local gridIndex = gridData.GridIndexable.gridIndex
        assert(GridIndexFunctions.isWithinMap(gridIndex, mapSize), "ModelTileMap-updateTileActorsMapWithGridsData() the data of overwriting grid is invalid.")
        map[gridIndex.x][gridIndex.y]:getModel():ctor(gridData)
    end
end

--------------------------------------------------------------------------------
-- The composition tile actors map.
--------------------------------------------------------------------------------
local function createTileActorsMapWithTemplate(mapData)
    local templateMapData = requireMapData(mapData.template)
    local map, mapSize = createTileActorsMapWithTiledLayers(getTiledTileObjectLayer(templateMapData), getTiledTileBaseLayer(templateMapData))
    updateTileActorsMapWithGridsData(map, mapSize, mapData.grids or {})

    return map, mapSize
end

local function createTileActorsMapWithoutTemplate(mapData)
    local map, mapSize = createTileActorsMapWithTiledLayers(getTiledTileObjectLayer(mapData), getTiledTileBaseLayer(mapData))
    updateTileActorsMapWithGridsData(map, mapSize, mapData.grids or {})

    return map, mapSize
end

local function createTileActorsMap(param)
    local mapData = requireMapData(param)
    if (mapData.template) then
        return createTileActorsMapWithTemplate(mapData)
    else
        return createTileActorsMapWithoutTemplate(mapData)
    end
end

local function initWithTileActorsMap(self, map, mapSize)
    self.m_TileActorsMap = map
    self.m_MapSize = mapSize
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelTileMap:ctor(param)
    initWithTileActorsMap(self, createTileActorsMap(param))

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelTileMap:initView()
    local view = self.m_View
    assert(view, "ModelTileMap:initView() no view is attached to the owner actor of the model.")

    view:removeAllChildren()

    local mapSize = self:getMapSize()
    for y = mapSize.height, 1, -1 do
        for x = mapSize.width, 1, -1 do
            view:addChild(self.m_TileActorsMap[x][y]:getView())
        end
    end

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node/script events.
--------------------------------------------------------------------------------
function ModelTileMap:onEnter(rootActor)
    self.m_RootScriptEventDispatcher = rootActor:getModel():getScriptEventDispatcher()
    self.m_RootScriptEventDispatcher:addEventListener("EvtPlayerMovedCursor", self)
        :addEventListener("EvtTurnPhaseBeginning", self)

    return self
end

function ModelTileMap:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtTurnPhaseBeginning", self)
        :removeEventListener("EvtPlayerMovedCursor", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

function ModelTileMap:onEvent(event)
    if (event.name == "EvtPlayerMovedCursor") then
        local modelTile = self:getModelTile(event.gridIndex)
        assert(modelTile, "ModelTileMap:onEvent() failed to get the tile model with event.gridIndex.")
        self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtPlayerTouchTile", tileModel = modelTile})
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelTileMap:getMapSize()
    return self.m_MapSize
end

function ModelTileMap:getActorTile(gridIndex)
    if (GridIndexFunctions.isWithinMap(gridIndex, self:getMapSize())) then
 --       return self.m_TileObjectMap[gridIndex.x][gridIndex.y] or self.m_TileBaseMap[gridIndex.x][gridIndex.y]
        return self.m_TileActorsMap[gridIndex.x][gridIndex.y]
    else
        return nil
    end
end

function ModelTileMap:getModelTile(gridIndex)
    local tileActor = self:getActorTile(gridIndex)
    return tileActor and tileActor:getModel() or nil
end

return ModelTileMap
