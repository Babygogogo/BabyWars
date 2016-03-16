
local ViewTileMap = class("ViewTileMap", cc.Node)

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewTileMap:ctor(param)
    if (param) then
        self:load(param)
    end

    return self
end

function ViewTileMap:load(param)
    return self
end

function ViewTileMap.createInstance(param)
    local view = ViewTileMap.new():load(param)
    assert(view, "ViewTileMap.createInstance() failed.")

    return view
end

return ViewTileMap
