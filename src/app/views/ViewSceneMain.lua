
local ViewSceneMain = class("ViewSceneMain", cc.Scene)

local CONFIRM_BOX_Z_ORDER = 99
local WAR_LIST_Z_ORDER    = 1
local BACKGROUND_Z_ORDER  = 0

--------------------------------------------------------------------------------
-- The composition background.
--------------------------------------------------------------------------------
local function createBackground()
    local background = cc.Sprite:createWithSpriteFrameName("c03_t05_s01_f01.png")
    background:move(display.center)

    return background
end

local function initWithBackground(view, background)
    view.m_Background = background
    view:addChild(background, BACKGROUND_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewSceneMain:ctor(param)
    initWithBackground(self, createBackground())

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewSceneMain:setViewConfirmBox(view)
    assert(self.m_ViewConfirmBox == nil, "ViewSceneMain:setViewConfirmBox() the view has been set already.")

    self.m_ViewConfirmBox = view
    self:addChild(view, CONFIRM_BOX_Z_ORDER)

    return self
end

function ViewSceneMain:setViewWarList(view)
    assert(self.m_ViewWarList == nil, "ViewSceneMain:setViewWarList() the view has been set already.")

    self.m_ViewWarList = view
    self:addChild(view, WAR_LIST_Z_ORDER)

    return self
end

return ViewSceneMain
