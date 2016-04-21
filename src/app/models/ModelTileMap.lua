
local ModelTileMap = class("ModelTileMap")

local Actor              = require("global.actors.Actor")
local TypeChecker        = require("app.utilities.TypeChecker")
local MapFunctions       = require("app.utilities.MapFunctions")
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

local function iterateAllActorTiles(tileMap, mapSize, func)
    local width, height = mapSize.width, mapSize.height
    for x = 1, width do
        for y = 1, height do
            local actorTile = tileMap[x][y]
            if (actorTile) then
                func(actorTile)
            end
        end
    end
end

local function createTileActorsMapWithTiledLayers(objectLayer, baseLayer)
    local width, height = baseLayer.width, baseLayer.height
    local map = createEmptyMap(width)

    for x = 1, width do
        for y = 1, height do
            local idIndex = x + (height - y) * width
            local actorData = {
                objectID = objectLayer.data[idIndex],
                baseID   = baseLayer.data[idIndex],
                GridIndexable = {gridIndex = {x = x, y = y}}
            }

            map[x][y] = Actor.createWithModelAndViewName("ModelTile", actorData, "ViewTile", actorData)
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
-- The callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtPlayerMovedCursor(self, event)
    local modelTile = self:getModelTile(event.gridIndex)
    assert(modelTile, "ModelTileMap:onEvent() failed to get the tile model with event.gridIndex.")
    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtPlayerTouchTile", modelTile = modelTile})
end

local function onEvtDestroyModelTile(self, event)
    self:getModelTile(event.gridIndex):destroyModelTileObject()
end

local function onEvtDestroyViewTile(self, event)
    self:getModelTile(event.gridIndex):destroyViewTileObject()
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
    self.m_ActorTilesMap = map
    self.m_MapSize       = mapSize
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
            view:addChild(self.m_ActorTilesMap[x][y]:getView())
        end
    end

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node/script events.
--------------------------------------------------------------------------------
function ModelTileMap:onEnter(rootActor)
    local dispatcher = rootActor:getModel():getScriptEventDispatcher()
    self.m_RootScriptEventDispatcher = dispatcher
    dispatcher:addEventListener("EvtDestroyModelTile", self)
        :addEventListener("EvtDestroyViewTile",    self)
        :addEventListener("EvtPlayerMovedCursor",  self)
        :addEventListener("EvtTurnPhaseBeginning", self)

    iterateAllActorTiles(self.m_ActorTilesMap, self.m_MapSize, function(actorTile)
        actorTile:getModel():setRootScriptEventDispatcher(dispatcher)
    end)

    return self
end

function ModelTileMap:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtTurnPhaseBeginning", self)
        :removeEventListener("EvtPlayerMovedCursor", self)
        :removeEventListener("EvtDestroyViewTile",   self)
        :removeEventListener("EvtDestroyModelTile",  self)
    self.m_RootScriptEventDispatcher = nil

    iterateAllActorTiles(self.m_ActorTilesMap, self.m_MapSize, function(actorTile)
        actorTile:getModel():unsetRootScriptEventDispatcher()
    end)

    return self
end

function ModelTileMap:onEvent(event)
    local eventName = event.name
    if (eventName == "EvtPlayerMovedCursor") then
        onEvtPlayerMovedCursor(self, event)
    elseif (eventName == "EvtDestroyModelTile") then
        onEvtDestroyModelTile(self, event)
    elseif (eventName == "EvtDestroyViewTile") then
        onEvtDestroyViewTile(self, event)
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
        return self.m_ActorTilesMap[gridIndex.x][gridIndex.y]
    else
        return nil
    end
end

function ModelTileMap:getModelTile(gridIndex)
    local tileActor = self:getActorTile(gridIndex)
    return tileActor and tileActor:getModel() or nil
end

function ModelTileMap:doActionAttack(action)
    self:getModelTile(action.path[1]):doActionAttack(action, false)
    self:getModelTile(action.target:getGridIndex()):doActionAttack(action, false)

    return self
end

function ModelTileMap:doActionCapture(action)
    if (action.prevTarget) then
        action.prevTarget:doActionCapture(action)
    end
    action.nextTarget:doActionCapture(action)

    return self
end

function ModelTileMap:doActionWait(action)
    self:getModelTile(action.path[1]):doActionWait(action)

    return self
end

return ModelTileMap
