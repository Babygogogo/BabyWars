
local ViewSceneWar = class("ViewSceneWar", cc.Scene)

local WAR_HUD_Z_ORDER    = 1
local WAR_FIELD_Z_ORDER  = 0
local BACKGROUND_Z_ORDER = -1

--------------------------------------------------------------------------------
-- The background.
--------------------------------------------------------------------------------
local function createBackground()
    return cc.LayerGradient:create({r = 0,   g = 0,   b = 0},
--                                   {r = 240, g = 80, b = 56},  -- red
--                                   {r = 96,  g = 88, b = 240}, -- blue
--                                   {r = 216, g = 208, b = 8},  -- yellow
                                   {r = 96,  g = 224, b = 88}, -- green
                                   {x = -1,  y = 1})
end

local function initWithBackground(self, background)
    self.m_Background = background
    self:addChild(background, BACKGROUND_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewSceneWar:ctor(param)
    initWithBackground(self, createBackground())

    return self
end

function ViewSceneWar:setViewWarField(view)
    assert(self.m_ViewWarField == nil, "ViewSceneWar:setViewWarField() the view has been set.")

    self.m_ViewWarField = view
    self:addChild(view, WAR_FIELD_Z_ORDER)

    return self
end

function ViewSceneWar:setViewWarHud(view)
    assert(self.m_ViewWarHud == nil, "ViewSceneWar:setViewWarHud() the view has been set.")

    self.m_ViewWarHud = view
    self:addChild(view, WAR_HUD_Z_ORDER)

    return self
end

return ViewSceneWar
