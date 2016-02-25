
local ViewMoneyEnergyInfo = class("ViewMoneyEnergyInfo", ccui.Button)

local CONTENT_SIZE_WIDTH, CONTENT_SIZE_HEIGHT = 220, 100 
local LEFT_POSITION_X = 20
local LEFT_POSITION_Y = display.height - CONTENT_SIZE_HEIGHT - 20
local RIGHT_POSITION_X = display.width - CONTENT_SIZE_WIDTH - 20
local RIGHT_POSITION_Y = LEFT_POSITION_Y

local function initAppearance(view)
    view:loadTextureNormal("c03_t01_s01_f01.png", ccui.TextureResType.plistType)
    
        :ignoreAnchorPointForPosition(true)
        :moveToRightSide()
    
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

    view:getTitleRenderer():enableOutline({r = 0, g = 0, b = 0}, 2)
end

function ViewMoneyEnergyInfo:ctor(param)
    initAppearance(self)
    
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
            local touchLocation = touch:getLocation()
            if (touchLocation.y > display.height / 2) then
                if (touchLocation.x <= display.width / 2) then
                    self:moveToRightSide()
                else
                    self:moveToLeftSide()
                end
            end
        end
        
        return false
    end
end

function ViewMoneyEnergyInfo:moveToLeftSide()
    self:move(LEFT_POSITION_X, LEFT_POSITION_Y)
    
    return self
end

function ViewMoneyEnergyInfo:moveToRightSide()
    self:move(RIGHT_POSITION_X, RIGHT_POSITION_Y)
    
    return self
end

return ViewMoneyEnergyInfo
