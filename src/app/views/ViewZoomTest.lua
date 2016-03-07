
local ViewZoomTest = class("ViewZoomTest", cc.Scene)

function ViewZoomTest:ctor()
    self.m_Background = cc.Sprite:createWithSpriteFrameName("c03_t05_s01_f01.png")
    self.m_Background:ignoreAnchorPointForPosition(true)
    self:addChild(self.m_Background)
    
    self.m_Listener = cc.EventListenerMouse:create()
    self.m_Listener:registerScriptHandler(function(event)
        local width = self.m_Background:getContentSize().width
        local height = self.m_Background:getContentSize().height
        local cursorPosInNode = self.m_Background:convertToNodeSpace(cc.Director:getInstance():convertToGL(event:getLocation()))
        local ax, ay = cursorPosInNode.x / width, cursorPosInNode.y / height
        self.m_Background:setAnchorPoint(ax, ay)
 
        local scale = self.m_Background:getScale() + event:getScrollY() / 100
        self.m_Background:setScale(scale)

    end, cc.Handler.EVENT_MOUSE_SCROLL)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(self.m_Listener, self)
    
    return self
end

function ViewZoomTest:load(param)
    return self
end

function ViewZoomTest.createInstance(param)
    return ViewZoomTest:create()
end

return ViewZoomTest
