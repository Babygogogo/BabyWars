
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

local MESSAGE_INDICATOR_WIDTH  = display.width
local MESSAGE_INDICATOR_HEIGHT = 80
local MESSAGE_INDICATOR_POS_X  = 0
local MESSAGE_INDICATOR_POS_Y  = display.height - MESSAGE_INDICATOR_HEIGHT

local VERSION_INDICATOR_WIDTH  = 250
local VERSION_INDICATOR_HEIGHT = 40
local VERSION_INDICATOR_POS_X  = display.width - 250
local VERSION_INDICATOR_POS_Y  = 10

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createLabel(posX, posY, width, height, text)
    local label = cc.Label:createWithTTF(text or "", FONT_NAME, FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(posX, posY)
        :setDimensions(width, height)

        :setTextColor(FONT_COLOR)
        :enableOutline(FONT_OUTLINE_COLOR, FONT_OUTLINE_WIDTH)

    return label
end

--------------------------------------------------------------------------------
-- The composition message indicator.
--------------------------------------------------------------------------------
local function createMessageIndicator()
    local indicator = createLabel(MESSAGE_INDICATOR_POS_X, MESSAGE_INDICATOR_POS_Y, MESSAGE_INDICATOR_WIDTH, MESSAGE_INDICATOR_HEIGHT)
    indicator:setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
        :setVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)

    indicator.showMessage = function(self, msg)
        self:setVisible(true)
            :setOpacity(255)
            :setString(msg)

            :stopAllActions()
            :runAction(cc.Sequence:create(
                cc.DelayTime:create(2),
                cc.FadeOut:create(1),
                cc.CallFunc:create(function() self:setVisible(false) end)
            ))
    end

    return indicator
end

local function initWithMessageIndicator(self, indicator)
    self.m_MessageIndicator = indicator
    self:addChild(indicator, MESSAGE_INDICATOR_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The composition game version indicator.
--------------------------------------------------------------------------------
local function createVersionIndicator()
    return createLabel(VERSION_INDICATOR_POS_X, VERSION_INDICATOR_POS_Y, VERSION_INDICATOR_WIDTH, VERSION_INDICATOR_HEIGHT)
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
    initWithMessageIndicator(self, createMessageIndicator())
    initWithVersionIndicator(self, createVersionIndicator())

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

function ViewSceneMain:setGameVersion(version)
    self.m_VersionIndicator:setString("BabyWars v" .. version)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewSceneMain:showMessage(msg)
    self.m_MessageIndicator:showMessage(msg)

    return self
end

return ViewSceneMain
