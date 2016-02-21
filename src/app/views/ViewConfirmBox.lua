
local ViewConfirmBox = class("ViewConfirmBox", cc.Node)

local backgroundWidth, backgroundHeight = 600, display.height * 0.5
local textWidth,       textHeight       = 580, display.height * 0.3
local buttonWidth,     buttonHeight     = 200, display.height * 0.1

local function enableSwallowingTouchesForView(view)
    local touchListener = cc.EventListenerTouchOneByOne:create()
    touchListener:setSwallowTouches(true)
        :registerScriptHandler(function(touch, event)
            local locationInNodeSpace = view:convertToNodeSpace(touch:getLocation())
            local x, y = locationInNodeSpace.x, locationInNodeSpace.y
            
            local contentSize = view:getContentSize()
            local width, height = contentSize.width, contentSize.height

            return (x >= 0) and (y >= 0) and (x <= width) and (y <= height)
        end, cc.Handler.EVENT_TOUCH_BEGAN)
        
    view:getEventDispatcher():addEventListenerWithSceneGraphPriority(touchListener, view)
    
    return view
end

local function createBackground()
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", {x = 4, y = 5, width = 1, height = 1})
    background:ignoreAnchorPointForPosition(true)
        :setPosition((display.width - backgroundWidth) / 2, (display.height - backgroundHeight) / 2)
        
        :setContentSize(backgroundWidth, backgroundHeight)
        
        :setOpacity(200)

    enableSwallowingTouchesForView(background)
    
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
    
    self.m_ButtonYes = createButtonYes(self.onConfirmYes)
    self:addChild(self.m_ButtonYes)
    
    self.m_ButtonNo = createButtonNo(self.onConfirmNo)
    self:addChild(self.m_ButtonNo)
    
    return self
end

function ViewConfirmBox:initTouchListener()
    local eventDispatcher = self:getEventDispatcher()
    
    local touchListener = cc.EventListenerTouchOneByOne:create()
    touchListener:setSwallowTouches(true)
    
	touchListener:registerScriptHandler(function()
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)
    touchListener:registerScriptHandler(function()
        self:onConfirmCancel()
    end, cc.Handler.EVENT_TOUCH_ENDED)   

    eventDispatcher:addEventListenerWithSceneGraphPriority(touchListener, self)
    
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
    print("ViewConfirmBox:onConfirmYes")
end

function ViewConfirmBox:onConfirmNo()
    print("ViewConfirmBox:onConfirmNo")
end

function ViewConfirmBox:onConfirmCancel()
    print("ViewConfirmBox:onConfirmCancel")
end
    
return ViewConfirmBox
