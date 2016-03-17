
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

    self.m_TouchListener = cc.EventListenerTouchOneByOne:create()
    self.m_TouchListener:registerScriptHandler(function()
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)
    self.m_TouchListener:registerScriptHandler(function()
        local mainSceneActor = require("global.actors.Actor").createWithModelAndViewName(nil, nil, "ViewZoomTest")
        assert(mainSceneActor, "main() failed to create a main scene actor.")
        require("global.actors.ActorManager").setAndRunRootActor(mainSceneActor, "FADE", 2)
    end, cc.Handler.EVENT_TOUCH_ENDED)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(self.m_TouchListener, self)

    return self
end

function ViewZoomTest:load(param)
    return self
end

function ViewZoomTest.createInstance(param)
    return ViewZoomTest:create()
end

return ViewZoomTest
