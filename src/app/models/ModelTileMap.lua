
local ModelTileMap = class("ModelTileMap")

local TypeChecker        = require("app.utilities.TypeChecker")
local MapFunctions       = require("app.utilities.MapFunctions")
local ViewTile           = require("app.views.ViewTile")
local ModelTile          = require("app.models.ModelTile")
local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

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

local function getTiledTileLayer(tiledData)
    return tiledData.layers[1]
end

--------------------------------------------------------------------------------
-- The composition tile actors.
--------------------------------------------------------------------------------
local function createTileActorsMapWithTemplate(mapData)
    assert(type(mapData.template) == "string", "ModelTileMap-createTileActorsMapWithTemplate() the param mapData.template is expected to be a file name.")
    local templateTiledLayer = getTiledTileLayer(requireMapData(mapData.template))
    assert(templateTiledLayer, "ModelTileMap-createTileActorsMapWithTemplate() the template of the param mapData is expected to have a tiled layer.")

    local map = MapFunctions.createGridActorsMapWithTiledLayer(templateTiledLayer, "ModelTile", "ViewTile")
    assert(map, "ModelTileMap-createTileActorsMapWithTemplate() failed to create the template tile actors map.")

    if (mapData.grids) then
        map = MapFunctions.updateGridActorsMapWithGridsData(map, mapData.grids, "ModelTile", "ViewTile")
        assert(map, "ModelTileMap-createTileActorsMapWithTemplate() failed to update the tile actors map with the param mapData.grids.")
    end

    map.m_TemplateName = mapData.template
    map.m_Name         = mapData.name

    return map
end

local function createTileActorsMapWithoutTemplate(mapData)
    local tiledLayer = getTiledTileLayer(mapData)
    assert(tiledLayer, "ModelTileMap-createTileActorsMapWithoutTemplate() the param mapData is expected to have a tiled layer.")

    local map = MapFunctions.createGridActorsMapWithTiledLayer(tiledLayer, "ModelTile", "ViewTile")
    assert(map, "ModelTileMap-createTileActorsMapWithoutTemplate() failed to create the map.")

    return map
end

local function createTileActorsMap(param)
    local mapData = requireMapData(param)
    local tileActorsMap = (mapData.template == nil) and
        createTileActorsMapWithoutTemplate(mapData) or
        createTileActorsMapWithTemplate(mapData)

    assert(tileActorsMap, "ModelTileMap--createTileActorsMap() failed to create tile actors map.")
    assert(not MapFunctions.hasNilGrid(tileActorsMap), "ModelTileMap--createTileActorsMap() some tiles are missing in the created map.")

    return tileActorsMap
end

local function initWithTileActorsMap(model, map)
    model.m_TileActorsMap = map
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

    local tileActors = self.m_TileActorsMap
    local mapSize = tileActors.size
    for y = mapSize.height, 1, -1 do
        for x = mapSize.width, 1, -1 do
            view:addChild(tileActors[x][y]:getView())
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
        :addEventListener("EvtTurnStarted", self)

    return self
end

function ModelTileMap:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtTurnStarted", self)
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
    return self.m_TileActorsMap.size
end

function ModelTileMap:getActorTile(gridIndex)
    if (GridIndexFunctions.isWithinMap(gridIndex, self:getMapSize())) then
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
