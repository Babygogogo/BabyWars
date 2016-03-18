
local ViewUnit = class("ViewUnit", cc.Sprite)

local TypeChecker       = require("app.utilities.TypeChecker")
local TemplateViewUnits = require("res.data.GameConstant").Mapping_TiledIdToTemplateViewTileOrUnit
local GridSize          = require("res.data.GameConstant").GridSize
local AnimationLoader   = require("app.utilities.AnimationLoader")

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewUnit:ctor(param)
    self:ignoreAnchorPointForPosition(true)

	return self
end

function ViewUnit:updateWithTiledID(tiledID)
    assert(TypeChecker.isTiledID(tiledID))
    if (self.m_TiledID == tiledID) then
        return
    end

    local template = TemplateViewUnits[tiledID]
    assert(template, "ViewUnit:updateWithTiledID() failed to get the template with param tiledID.")

    self.m_TiledID = tiledID
    self:stopAllActions()
        :playAnimationForever(AnimationLoader.getAnimationWithTiledID(tiledID))

    return self
end

return ViewUnit
