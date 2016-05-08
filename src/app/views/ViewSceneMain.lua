
local ViewSceneMain = class("ViewSceneMain", cc.Scene)

local CONFIRM_BOX_Z_ORDER       = 99
local VERSION_INDICATOR_Z_ORDER = 2
local WAR_LIST_Z_ORDER          = 1
local BACKGROUND_Z_ORDER        = 0

--------------------------------------------------------------------------------
-- The composition game version indicator.
--------------------------------------------------------------------------------
local function createVersionIndicator()
    local indicator = cc.Label:createWithTTF("", "res/fonts/msyhbd.ttc", 25)
    indicator:ignoreAnchorPointForPosition(true)
        :setPosition(display.width - 220, 10)
        :setDimensions(220, 40)

        :setTextColor({r = 255, g = 255, b = 255})
        :enableOutline({r = 0,  g = 0,   b = 0}, 2)

    return indicator
end

local function initWithVersionIndicator(self, indicator)
    self.m_VersionIndicator = indicator
    self:addChild(indicator, VERSION_INDICATOR_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The composition background.
--------------------------------------------------------------------------------
local function createBackground()
    local background = cc.Sprite:createWithSpriteFrameName("c03_t05_s01_f01.png")
    background:move(display.center)

    return background
end

local function initWithBackground(self, background)
    self.m_Background = background
    self:addChild(background, BACKGROUND_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewSceneMain:ctor(param)
    initWithBackground(      self, createBackground())
    initWithVersionIndicator(self, createVersionIndicator())

    return self
end

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

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewSceneMain:setGameVersion(version)
    self.m_VersionIndicator:setString("Version: " .. version)

    return self
end

return ViewSceneMain
