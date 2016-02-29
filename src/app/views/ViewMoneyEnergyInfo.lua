
local ViewMoneyEnergyInfo = class("ViewMoneyEnergyInfo", ccui.Button)

local CONTENT_SIZE_WIDTH, CONTENT_SIZE_HEIGHT = 220, 100 
local LEFT_POSITION_X = 20
local LEFT_POSITION_Y = display.height - CONTENT_SIZE_HEIGHT - 20
local RIGHT_POSITION_X = display.width - CONTENT_SIZE_WIDTH - 20
local RIGHT_POSITION_Y = LEFT_POSITION_Y

local function moveToLeftSide(view)
    view:setPosition(LEFT_POSITION_X, LEFT_POSITION_Y)
end

local function moveToRightSide(view)
    view:setPosition(RIGHT_POSITION_X, RIGHT_POSITION_Y)
end

local function init(view)
    view:loadTextureNormal("c03_t01_s01_f01.png", ccui.TextureResType.plistType)
    
        :ignoreAnchorPointForPosition(true)
    
        :setScale9Enabled(true)
        :setCapInsets({x = 4, y = 5, width = 1, height = 1})
        :setContentSize(CONTENT_SIZE_WIDTH, CONTENT_SIZE_HEIGHT)
    
        :setZoomScale(-0.05)

        :setOpacity(200)
        :setCascadeOpacityEnabled(true)

        :setTitleFontName("res/fonts/msyhbd.ttc")
        :setTitleFontSize(30)
        :setTitleColor({r = 255, g = 255, b = 255})
        :setTitleText("G:   123456\nEN: 10/0/10")
        
        :addTouchEventListener(function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                if (view.m_Model) then
                    view.m_Model:onPlayerTouch()
                end
            end
        end)

    view:getTitleRenderer():enableOutline({r = 0, g = 0, b = 0}, 2)
    
    moveToRightSide(view)
end

local function adjustPositionOnTouch(view, touch)
    local touchLocation = touch:getLocation()
    if (touchLocation.y > display.height / 2) then
        if (touchLocation.x <= display.width / 2) then
            moveToRightSide(view)
        else
            moveToLeftSide(view)
        end
    end
end

function ViewMoneyEnergyInfo:ctor(param)
    init(self)
    
    if (param) then
        self:load(param)
    end
        
    return self
end

function ViewMoneyEnergyInfo:load(param)
    return self
end

function ViewMoneyEnergyInfo.createInstance(param)
    local view = ViewMoneyEnergyInfo.new():load(param)
    assert(view, "ViewMoneyEnergyInfo.createInstance() failed.")
    
    return view
end

function ViewMoneyEnergyInfo:handleAndSwallowTouch(touch, touchType, event)
    if (touchType == cc.Handler.EVENT_TOUCH_BEGAN) then
        self.m_IsTouchMoved = false
        return false
    elseif (touchType == cc.Handler.EVENT_TOUCH_MOVED) then
        self.m_IsTouchMoved = true
        return false
    elseif (touchType == cc.Handler.EVENT_TOUCH_CANCELLED) then
        return false
    elseif (touchType == cc.Handler.EVENT_TOUCH_ENDED) then
        if (not self.m_IsTouchMoved) then
            adjustPositionOnTouch(self, touch)
        end
        
        return false
    end
end

return ViewMoneyEnergyInfo
