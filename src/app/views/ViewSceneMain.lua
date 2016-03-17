
local ViewSceneMain = class("ViewSceneMain", cc.Scene)

local BACKGROUND_Z_ORDER    = 0
local WAR_LIST_VIEW_Z_ORDER = 1

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
        if (self.m_WarListView == view) then
            return
        else
            self:removeChild(self.m_WarListView)
        end
    end

    self.m_WarListView = view
    self:addChild(view, WAR_LIST_VIEW_Z_ORDER)

    return self
end

return ViewSceneMain
