
local SceneWar = class("SceneWar", cc.Scene)

local function createTouchListener(views)
    local dispatchAndSwallowTouch = require("app.utilities.DispatchAndSwallowTouch")
    
   	local function onTouchBegan(touch, event)
        dispatchAndSwallowTouch(views, touch, cc.Handler.EVENT_TOUCH_BEGAN, event)
    	return true
	end
    
	local function onTouchMoved(touch, event)
        dispatchAndSwallowTouch(views, touch, cc.Handler.EVENT_TOUCH_MOVED, event)
	end
    
    local function onTouchCancelled(touch, event)
        dispatchAndSwallowTouch(views, touch, cc.Handler.EVENT_TOUCH_CANCELLED, event)
    end   
     
    local function onTouchEnded(touch, event)
        dispatchAndSwallowTouch(views, touch, cc.Handler.EVENT_TOUCH_ENDED, event)
    end

    local touchListener = cc.EventListenerTouchOneByOne:create()
	touchListener:registerScriptHandler(onTouchBegan,     cc.Handler.EVENT_TOUCH_BEGAN)
	touchListener:registerScriptHandler(onTouchMoved,     cc.Handler.EVENT_TOUCH_MOVED)
    touchListener:registerScriptHandler(onTouchCancelled, cc.Handler.EVENT_TOUCH_CANCELLED)
    touchListener:registerScriptHandler(onTouchEnded,     cc.Handler.EVENT_TOUCH_ENDED)
    
    return touchListener
end

local function initWithTouchListener(scene, touchListener)
    assert(not scene.m_TouchListener, "SceneWar-initWithTouchListener() the scene already has a touch listener.")
    scene.m_TouchListener = touchListener

    scene:getEventDispatcher():addEventListenerWithSceneGraphPriority(scene.m_TouchListener, scene)
end

function SceneWar:ctor(param)
    self.m_Model = require("app.models.ModelSceneWar"):create()
    self.m_Model.m_View = self

	if (param) then
        self:load(param)
    end
	
	return self
end

function SceneWar:load(param)
    self.m_Model:load(param)
    
	return self
end

function SceneWar.createInstance(param)
	local scene = SceneWar.new():load(param)
	assert(scene, "SceneWar.createInstance() failed.")
	
	return scene
end

function SceneWar:getModel()
    return self.m_Model
end

function SceneWar:initTouchListener(touchableChildrenViews)
    initWithTouchListener(self, createTouchListener(touchableChildrenViews))
    
    return self
end

return SceneWar
