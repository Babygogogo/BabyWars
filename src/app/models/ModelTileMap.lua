
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

local function createTileActorsMapWithTiledLayers(objectLayer, baseLayer)
    local width, height = baseLayer.width, baseLayer.height
    local objectMap, baseMap = createEmptyMap(width), createEmptyMap(width)

    for x = 1, width do
        for y = 1, height do
            local idIndex = x + (height - y) * width
            local objectID, baseID = objectLayer.data[idIndex], baseLayer.data[idIndex]
            local actorData = {objectID = objectID, baseID = baseID, GridIndexable = {gridIndex = {x = x, y = y}}}

            if (objectID > 0) then
                objectMap[x][y] = Actor.createWithModelAndViewName("ModelTileObject", actorData, "ViewTile", actorData)
            end
            baseMap[x][y] = Actor.createWithModelAndViewName("ModelTileBase", actorData, "ViewTile", actorData)
        end
    end

    return objectMap, baseMap, {width = width, height = height}
end

local function updateTileActorsMapWithGridsData(objectMap, baseMap, mapSize, gridsData)
    for _, gridData in ipairs(gridsData) do
        local gridIndex = gridData.GridIndexable.gridIndex
        assert(GridIndexFunctions.isWithinMap(gridIndex, mapSize), "ModelTileMap-updateTileActorsMapWithGridsData() the data of overwriting grid is invalid.")
        local x, y = gridIndex.x, gridIndex.y

        local objectID = gridData.objectID
        local objectActor = objectMap[x][y]
        if (not objectID) then
            if (objectActor) then
                objectActor:getModel():ctor(gridData)
            end
        elseif (objectID == 0) then
            objectMap[x][y] = nil
        else
            if (objectActor) then
                objectActor:getModel():ctor(gridData)
            else
                gridData.baseID = gridData.baseID or baseMap[x][y]:getModel():getTiledID()
                objectMap[x][y] = Actor.createWithModelAndViewName("ModelTileObject", gridData, "ViewTile", gridData)
            end
        end

        baseMap[x][y]:getModel():ctor(gridData)
    end
end

--------------------------------------------------------------------------------
-- The composition tile actors map.
--------------------------------------------------------------------------------
local function createTileActorsMapWithTemplate(mapData)
    local templateMapData = requireMapData(mapData.template)
    local objectMap, baseMap, mapSize = createTileActorsMapWithTiledLayers(getTiledTileObjectLayer(templateMapData), getTiledTileBaseLayer(templateMapData))
    updateTileActorsMapWithGridsData(objectMap, baseMap, mapSize, mapData.grids or {})

    return objectMap, baseMap, mapSize
end

local function createTileActorsMapWithoutTemplate(mapData)
    local objectMap, baseMap, mapSize = createTileActorsMapWithTiledLayers(getTiledTileObjectLayer(mapData), getTiledTileBaseLayer(mapData))
    updateTileActorsMapWithGridsData(objectMap, baseMap, mapSize, mapData.grids or {})

    return objectMap, baseMap, mapSize
end

local function createTileActorsMap(param)
    local mapData = requireMapData(param)
    if (mapData.template) then
        return createTileActorsMapWithTemplate(mapData)
    else
        return createTileActorsMapWithoutTemplate(mapData)
    end
end

local function initWithTileActorsMap(self, objectMap, baseMap, mapSize)
    self.m_ObjectMap = objectMap
    self.m_BaseMap = baseMap
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
            local objectActor = self.m_ObjectMap[x][y]
            if (objectActor) then
                view:addViewTileObject(objectActor:getView())
            end

            view:addViewTileBase(self.m_BaseMap[x][y]:getView())
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
        return self.m_ObjectMap[gridIndex.x][gridIndex.y] or self.m_BaseMap[gridIndex.x][gridIndex.y]
    else
        return nil
    end
end

function ModelTileMap:getModelTile(gridIndex)
    local tileActor = self:getActorTile(gridIndex)
    return tileActor and tileActor:getModel() or nil
end

function ModelTileMap:doActionAttack(action)
    assert(action.targetType == "tile", "ModelTileMap:doActionAttack() the param action is invalid.")
    action.target:doActionAttack(action, false)

    return self
end

return ModelTileMap
