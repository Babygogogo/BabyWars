
local ViewTile = class("ViewTile", cc.Node)

local TILE_OBJECT_Z_ORDER = 1
local TILE_BASE_Z_ORDER   = 0

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

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewTile:setViewObjectWithTiledId(objectID)
    assert(objectID, "ViewTile:setViewObjectWithTiledId() the param objectID is invalid.")

    if (objectID > 0) then
        if ((not self.m_ObjectID) or (self.m_ObjectID == 0)) then
            self.m_ViewObject = cc.Sprite:create()
            self.m_ViewObject:ignoreAnchorPointForPosition(true)
            self:addChild(self.m_ViewObject, TILE_OBJECT_Z_ORDER)
        end
        if (self.m_ObjectID ~= objectID) then
            self.m_ViewObject:playAnimationForever(AnimationLoader.getTileAnimationWithTiledId(objectID))
        end
    else
        if ((self.m_ObjectID) and (self.m_ObjectID > 0)) then
            self:removeChild(self.m_ViewObject)
            self.m_ViewObject = nil
        end
    end

    self.m_ObjectID = objectID
    return self
end

function ViewTile:setViewBaseWithTiledId(baseID)
    assert(baseID > 0, "ViewTile:setViewObjectWithTiledId() the param baseID is invalid.")

    if (not self.m_BaseID) then
        self.m_ViewBase = cc.Sprite:create()
        self.m_ViewBase:ignoreAnchorPointForPosition(true)
        self:addChild(self.m_ViewBase, TILE_BASE_Z_ORDER)
    end
    if (self.m_BaseID ~= baseID) then
        self.m_ViewBase:playAnimationForever(AnimationLoader.getTileAnimationWithTiledId(baseID))
    end

    self.m_BaseID = baseID
    return self
end

return ViewTile
