
local ViewConfirmBox = class("ViewConfirmBox", cc.Node)

local BACKGROUND_WIDTH  = 600
local BACKGROUND_HEIGHT = display.height * 0.5
local BACKGROUND_POSITION_X = (display.width - BACKGROUND_WIDTH) / 2
local BACKGROUND_POSITION_Y = (display.height - BACKGROUND_HEIGHT) / 2

local TEXT_WIDTH  = 580
local TEXT_HEIGHT = display.height * 0.3
local TEXT_POSITION_X = (display.width - TEXT_WIDTH) / 2
local TEXT_POSITION_Y = (display.height - TEXT_HEIGHT) / 2 * 1.2

local BUTTON_WIDTH  = 200
local BUTTON_HEIGHT = display.height * 0.1
local BUTTON_YES_POSITION_X = (display.width  - BUTTON_WIDTH)  / 2 - BUTTON_WIDTH  * 0.66
local BUTTON_YES_POSITION_Y = (display.height - BUTTON_HEIGHT) / 2 - BUTTON_HEIGHT * 1.5
local BUTTON_NO_POSITION_X = (display.width  - BUTTON_WIDTH)  / 2 + BUTTON_WIDTH * 0.66
local BUTTON_NO_POSITION_Y = (display.height - BUTTON_HEIGHT) / 2 - BUTTON_HEIGHT * 1.5

local TEXT_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local TEXT_OUTLINE_WIDTH = 2

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createConfirmButton(posX, posY, color, text, callback)
    local button = ccui.Button:create()
    button:loadTextureNormal("c03_t01_s01_f01.png", ccui.TextureResType.plistType)

        :ignoreAnchorPointForPosition(true)
        :setPosition(posX, posY)

        :setScale9Enabled(true)
        :setCapInsets({x = 4, y = 5, width = 1, height = 1})
        :setContentSize(BUTTON_WIDTH, BUTTON_HEIGHT)

        :setZoomScale(-0.05)

        :setTitleFontName("res/fonts/msyhbd.ttc")
        :setTitleFontSize(30)
        :setTitleColor(color)
        :setTitleText(text)

        :setOpacity(200)

        :addTouchEventListener(function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                callback()
            end
        end)

    button:getTitleRenderer():enableOutline(TEXT_OUTLINE_COLOR, TEXT_OUTLINE_WIDTH)

    return button
end

--------------------------------------------------------------------------------
-- The composition background.
--------------------------------------------------------------------------------
local function createBackground()
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", {x = 4, y = 5, width = 1, height = 1})
    background:ignoreAnchorPointForPosition(true)
        :setPosition(BACKGROUND_POSITION_X, BACKGROUND_POSITION_Y)

        :setContentSize(BACKGROUND_WIDTH, BACKGROUND_HEIGHT)

        :setOpacity(220)

    background.m_TouchSwallower = require("app.utilities.CreateTouchSwallowerForNode")(background)
    background:getEventDispatcher():addEventListenerWithSceneGraphPriority(background.m_TouchSwallower, background)

    return background
end

local function initWithBackground(view, background)
    view.m_Background = background
    view:addChild(background)
end

--------------------------------------------------------------------------------
-- The composition comfirm text label.
--------------------------------------------------------------------------------
local function createLabel()
    local text = cc.Label:createWithTTF("", "res/fonts/msyhbd.ttc", 25)
    text:ignoreAnchorPointForPosition(true)
        :setPosition(TEXT_POSITION_X, TEXT_POSITION_Y)

        :setDimensions(TEXT_WIDTH, TEXT_HEIGHT)
        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
        :setVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)

        :setTextColor({r = 255, g = 255, b = 255})
        :enableOutline(TEXT_OUTLINE_COLOR, TEXT_OUTLINE_WIDTH)

    return text
end

local function initWithLabel(view, label)
    view.m_Label = label
    view:addChild(label)
end

--------------------------------------------------------------------------------
-- The composition comfirm yes/no button.
--------------------------------------------------------------------------------
local function createButtonYes(view)
    local callback = function()
        if (view.m_Model) then
            view.m_Model:onConfirmYes()
        end
    end

    return createConfirmButton(BUTTON_YES_POSITION_X, BUTTON_YES_POSITION_Y,
                               {r = 104, g = 248, b = 200}, "Yes", callback)
end

local function initWithButtonYes(view, button)
    view.m_ButtonYes = button
    view:addChild(button)
end

local function createButtonNo(view)
    local callback = function()
        if (view.m_Model) then
            view.m_Model:onConfirmNo()
        end
    end

    return createConfirmButton(BUTTON_NO_POSITION_X, BUTTON_NO_POSITION_Y,
                               {r = 240, g = 80, b = 56}, "No", callback)
end

local function initWithButtonNo(view, button)
    view.m_ButtonNo = button
    view:addChild(button)
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewConfirmBox:ctor(param)
    initWithBackground(self, createBackground())
    initWithLabel(     self, createLabel())
    initWithButtonYes( self, createButtonYes(self))
    initWithButtonNo(  self, createButtonNo(self))

    self:setCascadeOpacityEnabled(true)
        :setOpacity(220)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewConfirmBox:setConfirmText(text)
    self.m_Label:setString(text)

    return self
end

function ViewConfirmBox:setTouchListener(listener)
    local eventDispatcher = self:getEventDispatcher()
    if (self.m_TouchListener) then
        if (self.m_TouchListener == listener) then
            return self
        else
            eventDispatcher:removeEventListener(self.m_TouchListener)
        end
    end

    self.m_TouchListener = listener
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

    return self
end

function ViewConfirmBox:setEnabled(enabled)
    if (enabled) then
        self:setVisible(true)
        self:getEventDispatcher():resumeEventListenersForTarget(self, true)
    else
        self:setVisible(false)
        self:getEventDispatcher():pauseEventListenersForTarget(self, true)
    end

    return self
end

return ViewConfirmBox
