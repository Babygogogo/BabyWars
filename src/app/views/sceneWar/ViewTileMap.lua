
local ViewTileMap = class("ViewTileMap", cc.Node)

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewTileMap:ctor(param)
    self:ignoreAnchorPointForPosition(true)

    return self
end

return ViewTileMap
