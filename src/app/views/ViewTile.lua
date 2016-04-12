
local ViewTile = class("ViewTile", cc.Sprite)

local ComponentManager      = require("global.components.ComponentManager")
local TypeChecker           = require("app.utilities.TypeChecker")
local AnimationLoader       = require("app.utilities.AnimationLoader")
local GameConstantFunctions = require("app.utilities.GameConstantFunctions")

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewTile:ctor(param)
    self:ignoreAnchorPointForPosition(true)

    return self
end

function ViewTile:updateWithTiledID(tiledID)
    if (tiledID ~= self.m_TiledID) then
        self.m_TiledID = tiledID
        if (tiledID > 0) then
            self:playAnimationForever(AnimationLoader.getTileAnimationWithTiledId(tiledID))
        else
            self:stopAllActions()
        end
    end

    return self
end

return ViewTile
