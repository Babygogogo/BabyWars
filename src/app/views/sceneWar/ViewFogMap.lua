
local ViewFogMap = class("ViewFogMap", cc.Node)

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewFogMap:ctor(param)
    self:ignoreAnchorPointForPosition(true)

    return self
end

return ViewFogMap
