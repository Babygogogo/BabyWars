
local ViewSceneWar = class("ViewSceneWar", cc.Scene)

local MESSAGE_INDICATOR_Z_ORDER = 2
local WAR_HUD_Z_ORDER           = 1
local WAR_FIELD_Z_ORDER         = 0
local BACKGROUND_Z_ORDER        = -1

--------------------------------------------------------------------------------
-- The composition background.
--------------------------------------------------------------------------------
local function initBackground(self)
    local background = cc.LayerGradient:create(
        {r = 0,   g = 0,   b = 0},
        {r = 96,  g = 224, b = 88}, -- green
        {x = -1,  y = 1}
    )

    self.m_Background = background
    self:addChild(background, BACKGROUND_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewSceneWar:ctor(param)
    initBackground(self)

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

function ViewSceneWar:setViewMessageIndicator(view)
    assert(self.m_ViewMessageIndicator == nil, "ViewSceneWar:setViewMessageIndicator() the view has been set.")

    self.m_ViewMessageIndicator = view
    self:addChild(view, MESSAGE_INDICATOR_Z_ORDER)

    return self
end

return ViewSceneWar
