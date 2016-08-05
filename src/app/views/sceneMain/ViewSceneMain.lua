
local ViewSceneMain = class("ViewSceneMain", cc.Scene)

local CONFIRM_BOX_Z_ORDER       = 99
local MESSAGE_INDICATOR_Z_ORDER = 3
local VERSION_INDICATOR_Z_ORDER = 2
local MAIN_MENU_Z_ORDER         = 2
local WAR_LIST_Z_ORDER          = 1
local BACKGROUND_Z_ORDER        = 0

local FONT_NAME          = "res/fonts/msyhbd.ttc"
local FONT_SIZE          = 25
local FONT_COLOR         = {r = 255, g = 255, b = 255}
local FONT_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local FONT_OUTLINE_WIDTH = 2

local VERSION_INDICATOR_POS_X  = 15
local VERSION_INDICATOR_POS_Y  = 10
local VERSION_INDICATOR_WIDTH  = display.width  - VERSION_INDICATOR_POS_X * 2
local VERSION_INDICATOR_HEIGHT = display.height - VERSION_INDICATOR_POS_Y * 2

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initBackground(self)
    local background = cc.Sprite:createWithSpriteFrameName("c04_t01_s01_f01.png")
    background:move(display.center)

    self.m_Background = background
    self:addChild(background, BACKGROUND_Z_ORDER)
end

local function initVersionIndicator(self)
    local indicator = cc.Label:createWithTTF("", FONT_NAME, FONT_SIZE)
    indicator:ignoreAnchorPointForPosition(true)
        :setPosition(VERSION_INDICATOR_POS_X, VERSION_INDICATOR_POS_Y)

        :setDimensions(VERSION_INDICATOR_WIDTH, VERSION_INDICATOR_HEIGHT)
        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
        :setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM)

        :setTextColor(FONT_COLOR)
        :enableOutline(FONT_OUTLINE_COLOR, FONT_OUTLINE_WIDTH)

    self.m_VersionIndicator = indicator
    self:addChild(indicator, VERSION_INDICATOR_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewSceneMain:ctor(param)
    initBackground(      self)
    initVersionIndicator(self)

    return self
end

function ViewSceneMain:setViewConfirmBox(view)
    assert(self.m_ViewConfirmBox == nil, "ViewSceneMain:setViewConfirmBox() the view has been set already.")

    self.m_ViewConfirmBox = view
    self:addChild(view, CONFIRM_BOX_Z_ORDER)

    return self
end

function ViewSceneMain:setViewMainMenu(view)
    assert(self.m_ViewMainMenu == nil, "ViewSceneMain:setViewMainMenu() the view has been set.")

    self.m_ViewMainMenu = view
    self:addChild(view, MAIN_MENU_Z_ORDER)

    return self
end

function ViewSceneMain:setViewMessageIndicator(view)
    assert(self.m_ViewMessageIndicator == nil, "ViewSceneMain:setViewMessageIndicator() the view has been set.")

    self.m_ViewMessageIndicator = view
    self:addChild(view, MESSAGE_INDICATOR_Z_ORDER)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewSceneMain:setGameVersion(version)
    self.m_VersionIndicator:setString("BabyWars v" .. version)

    return self
end

return ViewSceneMain
