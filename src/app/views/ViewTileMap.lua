
local ViewTileMap = class("ViewTileMap", cc.Node)

local TILE_BASE_Z_ORDER   = 0
local TILE_OBJECT_Z_ORDER = 1

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewTileMap:ctor(param)
    self:ignoreAnchorPointForPosition(true)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewTileMap:addViewTileBase(base)
    self:addChild(base, TILE_BASE_Z_ORDER)

    return self
end

function ViewTileMap:addViewTileObject(object)
    self:addChild(object, TILE_OBJECT_Z_ORDER)

    return self
end

return ViewTileMap
