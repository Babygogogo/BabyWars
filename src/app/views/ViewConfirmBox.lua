
local ViewConfirmBox = class("ViewConfirmBox", cc.Node)

local backgroundWidth, backgroundHeight = 600, display.height * 0.5
local textWidth,       textHeight       = 580, display.height * 0.3
local buttonWidth,     buttonHeight     = 200, display.height * 0.1

local function createTouchSwallower(node)
    local swallower = cc.EventListenerTouchOneByOne:create()
    swallower:setSwallowTouches(true)
        :registerScriptHandler(function(touch, event)
            local locationInNodeSpace = node:convertToNodeSpace(touch:getLocation())
            local x, y = locationInNodeSpace.x, locationInNodeSpace.y
            
            local contentSize = node:getContentSize()
            local width, height = contentSize.width, contentSize.height

            return (x >= 0) and (y >= 0) and (x <= width) and (y <= height)
        end, cc.Handler.EVENT_TOUCH_BEGAN)
        
    return swallower
end

local function createBackground()
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", {x = 4, y = 5, width = 1, height = 1})
    background:ignoreAnchorPointForPosition(true)
        :setPosition((display.width - backgroundWidth) / 2, (display.height - backgroundHeight) / 2)
        
        :setContentSize(backgroundWidth, backgroundHeight)
        
        :setOpacity(200)

    background.m_TouchSwallower = createTouchSwallower(background)
    background:getEventDispatcher():addEventListenerWithSceneGraphPriority(background.m_TouchSwallower, background)
    
    return background
end

local function createText()
    local text = ccui.Text:create()
    text:ignoreAnchorPointForPosition(true)
        :setPosition((display.width - textWidth) / 2,
                     (display.height - textHeight) / 2 * 1.2)
        
        :ignoreContentAdaptWithSize(false)
        :setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
        :setTextVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)
        :setContentSize(textWidth, textHeight)
        
        :setFontSize(30)
        :setColor({r = 0, g = 0, b = 0})
--        :setText("ViewConfirmBox\n ViewConfirmBox\n ViewConfirmBox\n ViewConfirmBox\n ViewConfirmBox\n ViewConfirmBox\n")

    return text
end

local function createButtonYes(callback)
    local button = ccui.Button:create()
    button:loadTextureNormal("c03_t01_s01_f01.png", ccui.TextureResType.plistType)
    
        :ignoreAnchorPointForPosition(true)
        :setPosition((display.width - buttonWidth) / 2 - buttonWidth * 0.66,
                     (display.height - buttonHeight) / 2 - buttonHeight * 1.5)
    
        :setScale9Enabled(true)
        :setCapInsets({x = 4, y = 5, width = 1, height = 1})
        :setContentSize(buttonWidth, buttonHeight)
    
        :setZoomScale(-0.05)
        
        :setTitleFontSize(30)
        :setTitleColor({r = 0, g = 0, b = 0})
        :setTitleText("Yes")
    
        :setOpacity(180)
    
        :addTouchEventListener(function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                callback()
            end
        end)
    
    return button
end

local function createButtonNo(callback)
    local button = ccui.Button:create()
    button:loadTextureNormal("c03_t01_s01_f01.png", ccui.TextureResType.plistType)
    
        :ignoreAnchorPointForPosition(true)
        :setPosition((display.width - buttonWidth) / 2 + buttonWidth * 0.66,
                     (display.height - buttonHeight) / 2 - buttonHeight * 1.5)

        :setScale9Enabled(true)
        :setCapInsets({x = 4, y = 5, width = 1, height = 1})
        :setContentSize(buttonWidth, buttonHeight)
    
        :setZoomScale(-0.05)
    
        :setTitleFontSize(30)
        :setTitleColor({r = 0, g = 0, b = 0})
        :setTitleText("No")
        
        :setOpacity(180)
        
        :addTouchEventListener(function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                callback()
            end
        end)
    
    return button
end

function ViewConfirmBox:initChildrenViews()
    self.m_Background = createBackground()
    self:addChild(self.m_Background)
    
    self.m_Text = createText()
    self:addChild(self.m_Text)
    
    self.m_ButtonYes = createButtonYes(function ()
        self:onConfirmYes()
    end)
    self:addChild(self.m_ButtonYes)
    
    self.m_ButtonNo = createButtonNo(function ()
        self:onConfirmNo()
    end)
    self:addChild(self.m_ButtonNo)
    
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
    self.m_Text:setString(text)
    
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

--[[
function ViewConfirmBox:setEnabled(enabled)
    self:setVisible(enabled)
    self.m_TouchListener:setEnabled(enabled)
    self.m_Background.m_TouchSwallower:setEnabled(enabled)
    
    return self
end
]]

return ViewConfirmBox
