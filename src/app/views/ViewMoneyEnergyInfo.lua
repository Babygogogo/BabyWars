
local ViewMoneyEnergyInfo = class("ViewMoneyEnergyInfo", cc.Node)

local CONTENT_SIZE_WIDTH, CONTENT_SIZE_HEIGHT = 200, 100 
local LEFT_POSITION_X,  LEFT_POSITION_Y  = 20, display.height - CONTENT_SIZE_HEIGHT - 20
local RIGHT_POSITION_X, RIGHT_POSITION_Y = display.width - CONTENT_SIZE_WIDTH - 20, LEFT_POSITION_Y

local function loadBackground(view)
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", {x = 4, y = 5, width = 1, height = 1})
    background:ignoreAnchorPointForPosition(true)

        :setContentSize(CONTENT_SIZE_WIDTH, CONTENT_SIZE_HEIGHT)
        
        :setOpacity(200)

    view.m_Background = background
    view:addChild(background)
end

function ViewMoneyEnergyInfo:ctor(param)
    loadBackground(self)
    self:ignoreAnchorPointForPosition(true)
        :moveToRightSide()
    
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
