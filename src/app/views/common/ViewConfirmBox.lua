
local ViewConfirmBox = class("ViewConfirmBox", cc.Node)

local LocalizationFunctions = require("app.utilities.LocalizationFunctions")

local BACKGROUND_WIDTH  = 600
local BACKGROUND_HEIGHT = display.height * 0.5
local BACKGROUND_POSITION_X = (display.width  - BACKGROUND_WIDTH)  / 2
local BACKGROUND_POSITION_Y = (display.height - BACKGROUND_HEIGHT) / 2
local BACKGROUND_CAPINSETS  = {x = 4, y = 6, width = 1, height = 1}

local TEXT_WIDTH  = 580
local TEXT_HEIGHT = display.height * 0.3
local TEXT_POSITION_X = (display.width - TEXT_WIDTH) / 2
local TEXT_POSITION_Y = (display.height - TEXT_HEIGHT) / 2 * 1.2

local BUTTON_WIDTH        = 200
local BUTTON_HEIGHT       = display.height * 0.1
local BUTTON_TEXTURE_NAME = "c03_t06_s01_f01.png"
local BUTTON_CAPINSETS    = {x = 1, y = BUTTON_HEIGHT - 7, width = 1, height = 1}

local BUTTON_YES_POS_X      = (display.width  - BUTTON_WIDTH)  / 2 - BUTTON_WIDTH  * 0.66
local BUTTON_YES_POS_Y      = (display.height - BUTTON_HEIGHT) / 2 - BUTTON_HEIGHT * 1.5
local BUTTON_YES_FONT_COLOR = {r = 96,  g = 224, b = 88}

local BUTTON_NO_POS_X      = (display.width  - BUTTON_WIDTH)  / 2 + BUTTON_WIDTH  * 0.66
local BUTTON_NO_POS_Y      = (display.height - BUTTON_HEIGHT) / 2 - BUTTON_HEIGHT * 1.5
local BUTTON_NO_FONT_COLOR = {r = 240, g = 80, b = 56}

local TEXT_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local TEXT_OUTLINE_WIDTH = 2

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createConfirmButton(posX, posY, textColor, text, callback)
    local button = ccui.Button:create()
    button:loadTextureNormal(BUTTON_TEXTURE_NAME, ccui.TextureResType.plistType)

        :ignoreAnchorPointForPosition(true)
        :setPosition(posX, posY)

        :setScale9Enabled(true)
        :setCapInsets(BUTTON_CAPINSETS)
        :setContentSize(BUTTON_WIDTH, BUTTON_HEIGHT)

        :setZoomScale(-0.05)

        :setTitleFontName("res/fonts/msyhbd.ttc")
        :setTitleFontSize(30)
        :setTitleColor(textColor)
        :setTitleText(text)

        :addTouchEventListener(function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                callback()
            end
        end)

    button:getTitleRenderer():enableOutline(TEXT_OUTLINE_COLOR, TEXT_OUTLINE_WIDTH)

    return button
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initBackground(self)
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", BACKGROUND_CAPINSETS)
    background:ignoreAnchorPointForPosition(true)
        :setPosition(BACKGROUND_POSITION_X, BACKGROUND_POSITION_Y)

        :setContentSize(BACKGROUND_WIDTH, BACKGROUND_HEIGHT)

    self.m_Background = background
    self:addChild(background)
end

local function initConfirmTextLabel(self)
    local label = cc.Label:createWithTTF("", "res/fonts/msyhbd.ttc", 25)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(TEXT_POSITION_X, TEXT_POSITION_Y)

        :setDimensions(TEXT_WIDTH, TEXT_HEIGHT)
        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
        :setVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)

        :setTextColor({r = 255, g = 255, b = 255})
        :enableOutline(TEXT_OUTLINE_COLOR, TEXT_OUTLINE_WIDTH)

    self.m_ConfirmTextLabel = label
    self:addChild(label)
end

local function initButtonYes(self)
    local button = createConfirmButton(BUTTON_YES_POS_X, BUTTON_YES_POS_Y, BUTTON_YES_FONT_COLOR,
        LocalizationFunctions.getLocalizedText(28),
        function()
            if (self.m_Model) then
                self.m_Model:onConfirmYes()
            end
        end)

    self.m_ButtonYes = button
    self:addChild(button)
end

local function initButtonNo(self)
    local button = createConfirmButton(BUTTON_NO_POS_X, BUTTON_NO_POS_Y, BUTTON_NO_FONT_COLOR,
        LocalizationFunctions.getLocalizedText(29),
        function()
            if (self.m_Model) then
                self.m_Model:onConfirmNo()
            end
        end)

    self.m_ButtonNo = button
    self:addChild(button)
end

local function initTouchListener(self)
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    local isTouchWithinBackground = false

    listener:registerScriptHandler(function(touch, event)
        isTouchWithinBackground = require("app.utilities.DisplayNodeFunctions").isTouchWithinNode(touch, self.m_Background)
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)

    listener:registerScriptHandler(function(touch, event)
        if (not isTouchWithinBackground) and (self.m_Model) then
            self.m_Model:onConfirmCancel()
        end
    end, cc.Handler.EVENT_TOUCH_ENDED)

    self.m_TouchListener = listener
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewConfirmBox:ctor(param)
    initBackground(      self)
    initConfirmTextLabel(self)
    initButtonYes(       self)
    initButtonNo(        self)
    initTouchListener(   self)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewConfirmBox:setConfirmText(text)
    self.m_ConfirmTextLabel:setString(text)

    return self
end

function ViewConfirmBox:setEnabled(enabled)
    self:setVisible(enabled)
    self.m_TouchListener:setEnabled(enabled)

    return self
end

return ViewConfirmBox
