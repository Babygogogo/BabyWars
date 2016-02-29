
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

local function createLabel()
    local text = cc.Label:createWithTTF("", "res/fonts/msyhbd.ttc", 25)
    text:ignoreAnchorPointForPosition(true)
        :setPosition(TEXT_POSITION_X, TEXT_POSITION_Y)
        
        :setDimensions(TEXT_WIDTH, TEXT_HEIGHT)
        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
        :setVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)

        :setTextColor({r = 255, g = 255, b = 255})
        :enableOutline({r = 0, g = 0, b = 0}, 2)
--        :setText("ViewConfirmBox\n ViewConfirmBox\n ViewConfirmBox\n ViewConfirmBox\n ViewConfirmBox\n ViewConfirmBox\n")

    return text
end

local function createButtonYes(callback)
    local button = ccui.Button:create()
    button:loadTextureNormal("c03_t01_s01_f01.png", ccui.TextureResType.plistType)
    
        :ignoreAnchorPointForPosition(true)
        :setPosition(BUTTON_YES_POSITION_X, BUTTON_YES_POSITION_Y)
    
        :setScale9Enabled(true)
        :setCapInsets({x = 4, y = 5, width = 1, height = 1})
        :setContentSize(BUTTON_WIDTH, BUTTON_HEIGHT)
    
        :setZoomScale(-0.05)
        
        :setTitleFontName("res/fonts/msyhbd.ttc")
        :setTitleFontSize(30)
        :setTitleColor({r = 104, g = 248, b = 200})
        :setTitleText("Yes")
    
        :setOpacity(200)
    
        :addTouchEventListener(function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                callback()
            end
        end)

    button:getTitleRenderer():enableOutline({r = 0, g = 0, b = 0}, 2)
    
    return button
end

local function createButtonNo(callback)
    local button = ccui.Button:create()
    button:loadTextureNormal("c03_t01_s01_f01.png", ccui.TextureResType.plistType)
    
        :ignoreAnchorPointForPosition(true)
        :setPosition(BUTTON_NO_POSITION_X, BUTTON_NO_POSITION_Y)

        :setScale9Enabled(true)
        :setCapInsets({x = 4, y = 5, width = 1, height = 1})
        :setContentSize(BUTTON_WIDTH, BUTTON_HEIGHT)
    
        :setZoomScale(-0.05)
    
        :setTitleFontName("res/fonts/msyhbd.ttc")
        :setTitleFontSize(30)
        :setTitleColor({r = 240, g = 80, b = 56})
        :setTitleText("No")
        
        :setOpacity(200)
        
        :addTouchEventListener(function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                callback()
            end
        end)

    button:getTitleRenderer():enableOutline({r = 0, g = 0, b = 0}, 2)
    
    return button
end

function ViewConfirmBox:initChildrenViews()
    self.m_Background = createBackground()
    self:addChild(self.m_Background)
    
    self.m_Label = createLabel()
    self:addChild(self.m_Label)
    
    self.m_ButtonYes = createButtonYes(function ()
        self:onConfirmYes()
    end)
    self:addChild(self.m_ButtonYes)
    
    self.m_ButtonNo = createButtonNo(function ()
        self:onConfirmNo()
    end)
    self:addChild(self.m_ButtonNo)
    
    self:setCascadeOpacityEnabled(true)
        :setOpacity(220)
        
    return self
end

function ViewConfirmBox:initTouchListener()
    local touchListener = cc.EventListenerTouchOneByOne:create()
    touchListener:setSwallowTouches(true)
    
	touchListener:registerScriptHandler(function()
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)
    
    touchListener:registerScriptHandler(function()
        self:onConfirmCancel()
    end, cc.Handler.EVENT_TOUCH_ENDED)

    self.m_TouchListener = touchListener
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(self.m_TouchListener, self)
    
    return self
end

function ViewConfirmBox:ctor(param)
    self:initChildrenViews()
        :initTouchListener()
end

function ViewConfirmBox:load(param)
    return self
end

function ViewConfirmBox:createInstance(param)
    local view = ViewConfirmBox.new():load(param)
    assert(view, "ViewConfirmBox:createInstance() failed.")
    
    return view
end

function ViewConfirmBox:setConfirmText(text)
    self.m_Label:setString(text)
    
    return self
end

function ViewConfirmBox:onConfirmYes()
    if (self.m_Model) then self.m_Model:onConfirmYes() end
    
    return self
end

function ViewConfirmBox:onConfirmNo()
    if (self.m_Model) then self.m_Model:onConfirmNo() end

    return self
end

function ViewConfirmBox:onConfirmCancel()
    if (self.m_Model) then self.m_Model:onConfirmCancel() end
    
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
