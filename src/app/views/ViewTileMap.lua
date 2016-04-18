
local ViewTileMap = class("ViewTileMap", cc.Node)

local TILE_BASE_Z_ORDER   = 0
local TILE_OBJECT_Z_ORDER = 1

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createEmptyMap(width, height)
    local map = {}
    for i = 1, width do
        map[i] = {}
    end

    return map
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewTileMap:ctor(param)
    self:ignoreAnchorPointForPosition(true)

    return self
end

function ViewTileMap:setMapSize(mapSize)
    assert(not (self.m_BaseMap or self.m_ObjectMap), "ViewTileMap:setMapSize() the map already exists.")

    local width, height = mapSize.width, mapSize.height
    self.m_BaseMap   = createEmptyMap(width, height)
    self.m_ObjectMap = createEmptyMap(width, height)
    self.m_MapSize   = {width = width, height = height}

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewTileMap:addViewTileBase(base, gridIndex)
    local x, y = gridIndex.x, gridIndex.y
    assert(not self.m_BaseMap[x][y], "ViewTileMap:addViewTileBase() the tile base already exists.")

    self.m_BaseMap[x][y] = base
    self:addChild(base, TILE_BASE_Z_ORDER)

    return self
end

function ViewTileMap:addViewTileObject(object, gridIndex)
    local x, y = gridIndex.x, gridIndex.y
    assert(not self.m_ObjectMap[x][y], "ViewTileMap:addViewTileObject() the tile object already exists.")

    self.m_ObjectMap[x][y] = object
    self:addChild(object, TILE_OBJECT_Z_ORDER)

    return self
end

function ViewTileMap:removeViewTileObject(gridIndex)
    local x, y = gridIndex.x, gridIndex.y
    assert(self.m_ObjectMap[x][y], "ViewTileMap:removeViewTileObject() the tile object doesn't exists.")

    self:removeChild(self.m_ObjectMap[x][y])
    self.m_ObjectMap[x][y] = nil

    return self
end

return ViewTileMap
