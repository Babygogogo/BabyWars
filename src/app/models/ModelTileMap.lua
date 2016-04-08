
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

local function createActorTile(tiledID, x, y, isTileBase)
    if (tiledID == 0) then
        return nil
    else
        local actorData = {tiledID = tiledID, GridIndexable = {gridIndex = {x = x, y = y}}}
        local actor = Actor.createWithModelAndViewName("ModelTile", actorData, "ViewTile", actorData)
        assert(actor:getModel():isTileBase() == isTileBase, "ModelTileMap-createActorTile() the created actor is invalid.")

        return actor
    end
end

local function createActorTileObjectAndBase(objectTiledID, baseTiledID, x, y)
    local actorObject = createActorTile(objectTiledID, x, y, false)
    if (actorObject) and (actorObject:getModel():isFullGrid()) then
        return actorObject, nil
    else
        return actorObject, createActorTile(baseTiledID, x, y, true)
    end
end

--------------------------------------------------------------------------------
-- The composition tile actors.
--------------------------------------------------------------------------------
local function createTileActorsMapWithTemplate(mapData)
    local templateMapData = requireMapData(mapData.template)
    local tiledBaseLayer, tiledObjectLayer = getTiledTileBaseLayer(templateMapData), getTiledTileObjectLayer(templateMapData)
    local width, height = tiledBaseLayer.width, tiledBaseLayer.height
    local baseMap, objectMap = createEmptyMap(width), createEmptyMap(width)
    local mapSize = {width = width, height = height}

    for x = 1, width do
        for y = 1, height do
            local idIndex = x + (height - y) * width
            local objectTiledID, baseTiledID = tiledObjectLayer.data[idIndex], tiledBaseLayer.data[idIndex]
            objectMap[x][y], baseMap[x][y] = createActorTileObjectAndBase(objectTiledID, baseTiledID, x, y)
        end
    end

    for _, gridData in ipairs(mapData.grids or {}) do
        local gridIndex = gridData.GridIndexable.gridIndex
        assert(GridIndexFunctions.isWithinMap(gridIndex, mapSize), "ModelTileMap-createTileActorsMapWithTemplate() the data of overwriting grid is invalid.")
        local x, y = gridIndex.x, gridIndex.y

        if (gridData.tiledID == 0) then
            if (not baseMap[x][y]) then
                baseMap[x][y] = createActorTile(tiledBaseLayer.data[x + (height - y) * width], x, y, true)
            end
            objectMap[x][y] = nil
        else
            local existingActor = objectMap[x][y]
            if (existingActor) then
                existingActor:getModel():ctor(gridData)
                existingActor:getView():ctor(gridData)

                if (not baseMap[x][y]) then
                    baseMap[x][y] = createActorTile(tiledBaseLayer.data[x + (height - y) * width], x, y, true)
                end
            else
                objectMap[x][y] = Actor.createWithModelAndViewName("ModelTile", gridData, "ViewTile", gridData)
            end
        end
    end

    return objectMap, baseMap, mapSize
end

local function createTileActorsMapWithoutTemplate(mapData)
    local tiledLayer = getTiledTileBaseLayer(mapData)
    assert(tiledLayer, "ModelTileMap-createTileActorsMapWithoutTemplate() the param mapData is expected to have a tiled layer.")

    local map = MapFunctions.createGridActorsMapWithTiledLayer(tiledLayer, "ModelTile", "ViewTile")
    assert(map, "ModelTileMap-createTileActorsMapWithoutTemplate() failed to create the map.")

    return map
end

local function createTileActorsMap(param)
    local mapData = requireMapData(param)
--[[
    local tileActorsMap = (mapData.template == nil) and
        createTileActorsMapWithoutTemplate(mapData) or
        createTileActorsMapWithTemplate(mapData)

    assert(tileActorsMap, "ModelTileMap--createTileActorsMap() failed to create tile actors map.")
    assert(not MapFunctions.hasNilGrid(tileActorsMap), "ModelTileMap--createTileActorsMap() some tiles are missing in the created map.")

    return tileActorsMap
]]
    return createTileActorsMapWithTemplate(mapData)
end

local function initWithTileActorsMap(model, objectMap, baseMap, mapSize)
    model.m_TileObjectMap = objectMap
    model.m_TileBaseMap = baseMap
    model.m_MapSize = mapSize
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

    local baseActors   = self.m_TileBaseMap
    local mapSize      = self:getMapSize()

    for y = mapSize.height, 1, -1 do
        for x = mapSize.width, 1, -1 do
            local baseActor = baseActors[x][y]
            if (baseActor) then
                view:addChild(baseActor:getView())
            end
        end
    end

    local objectActors = self.m_TileObjectMap
    for y = mapSize.height, 1, -1 do
        for x = mapSize.width, 1, -1 do
            local objectActor = objectActors[x][y]
            if (objectActor) then
                view:addChild(objectActor:getView())
            end
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
        return self.m_TileObjectMap[gridIndex.x][gridIndex.y] or self.m_TileBaseMap[gridIndex.x][gridIndex.y]
    else
        return nil
    end
end

function ModelTileMap:getModelTile(gridIndex)
    local tileActor = self:getActorTile(gridIndex)
    return tileActor and tileActor:getModel() or nil
end

return ModelTileMap
