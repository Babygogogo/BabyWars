
local ViewTile = class("ViewTile", cc.Sprite)

local ComponentManager  = require("global.components.ComponentManager")
local TypeChecker       = require("app.utilities.TypeChecker")
local TemplateViewTiles = require("res.data.GameConstant").Mapping_TiledIdToTemplateViewTileOrUnit
local AnimationLoader   = require("app.utilities.AnimationLoader")

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewTile:ctor(param)
    self:ignoreAnchorPointForPosition(true)

	return self
end

function ViewTile:updateWithTiledID(tiledID)
    assert(TypeChecker.isTiledID(tiledID))
    if (self.m_TiledID == tiledID) then
        return
    end

    local template = TemplateViewTiles[tiledID]
    assert(template, "ViewTile:updateWithTiledID() failed to get the template view with param tiledID.")

    self.m_TiledID = tiledID
    self:stopAllActions()
        :playAnimationForever(AnimationLoader.getAnimationWithTiledID(tiledID))

    return self
end

return ViewTile
