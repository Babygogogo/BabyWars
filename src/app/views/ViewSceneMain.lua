
local ViewSceneMain = class("ViewSceneMain", cc.Scene)

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
    view:addChild(background)
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewSceneMain:ctor(param)
    initWithBackground(self, createBackground())

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewSceneMain:setWarListView(view)
    if (self.m_WarListView) then
        self:removeChildren(self.m_WarListView)
    end

    self.m_WarListView = view
    self:addChild(view)

    return self
end

return ViewSceneMain
