
local ViewTile = class("ViewTile", cc.Node)

local ComponentManager      = require("global.components.ComponentManager")
local TypeChecker           = require("app.utilities.TypeChecker")
local AnimationLoader       = require("app.utilities.AnimationLoader")
local GameConstantFunctions = require("app.utilities.GameConstantFunctions")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createChildView()
    local view = cc.Sprite:create()
    view:ignoreAnchorPointForPosition(true)

    return view
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewTile:ctor(param)
    self:ignoreAnchorPointForPosition(true)

    self.m_ViewBase = createChildView()
    self:addChild(self.m_ViewBase)

    self.m_ViewObject = createChildView()
    self:addChild(self.m_ViewObject)

    return self
end

function ViewTile:updateWithTiledID(objectID, baseID)
    if (objectID ~= self.m_ObjectID) then
        self.m_ViewObject:stopAllActions()
        self.m_ObjectID = objectID

        if ((objectID) and (objectID > 0)) then
            self.m_ViewObject:playAnimationForever(AnimationLoader.getTileAnimationWithTiledId(objectID))
        end
    end

    assert(baseID > 0, "ViewTile:updateWithTiledID() the param baseID is invalid.")
    if (baseID ~= self.m_BaseID) then
        self.m_ViewBase:stopAllActions()
        self.m_BaseID = baseID
        self.m_IsViewBaseShown = false
    end

    if (GameConstantFunctions.doesViewTileFillGrid(objectID)) then
        self.m_ViewBase:stopAllActions()
        self.m_IsViewBaseShown = false
    elseif (not self.m_IsViewBaseShown) then
        self.m_ViewBase:playAnimationForever(AnimationLoader.getTileAnimationWithTiledId(self.m_BaseID))
        self.m_IsViewBaseShown = true
    end

    return self
end

return ViewTile
