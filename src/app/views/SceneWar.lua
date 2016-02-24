
local SceneWar = class("SceneWar", cc.Scene)

local Actor            = require("global.actors.Actor")
local TypeChecker      = require("app.utilities.TypeChecker")
local ComponentManager = require("global.components.ComponentManager")

local function requireSceneData(param)
	local t = type(param)
	if (t == "table") then
		return param
	elseif (t == "string") then
		return require("res.data.warScene." .. param)
	else
		return nil
	end
end

local function createWarFieldActor(warFieldData)
    return Actor.createWithModelAndViewName("ModelWarField", warFieldData, "ViewWarField", warFieldData)
end

local function createChildrenActors(param)
	local sceneData = requireSceneData(param)
	assert(TypeChecker.isWarSceneData(sceneData))

	local warFieldActor = createWarFieldActor(sceneData.WarField)
	assert(warFieldActor, "SceneWar--createChildrenActors() failed to create WarField actor.")

	return {WarFieldActor = warFieldActor}	
end

local function updateViewsWithTouch(views, touch, touchType, event)
    for _, view in ipairs(views) do
        local isTouchSwallowed = view:handleAndSwallowTouch(touch, touchType, event)
        if (isTouchSwallowed) then
            return
        end
    end
end
    
function SceneWar:getTouchableChildrenViews()
    local views = {}
    views[#views + 1] = require("app.utilities.GetTouchableViewFromActor")(self.m_WarFieldActor)
    -- TODO: Add more children views. Be careful of the order of the views!
    
    return views
end

function SceneWar:createTouchListener()
    local views = self:getTouchableChildrenViews()
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

function SceneWar:resetTouchListener()
    local eventDispatcher = self:getEventDispatcher()
    if (self.m_TouchListener) then
        eventDispatcher:removeEventListener(self.m_TouchListener)
    end
    
    self.m_TouchListener = self:createTouchListener()
    eventDispatcher:addEventListenerWithSceneGraphPriority(self.m_TouchListener, self)
end

function SceneWar:ctor(param)
	if (param) then
        self:load(param)
    end
	
	return self
end

function SceneWar:load(param)
	local actorsInScene = createChildrenActors(param)
	assert(actorsInScene, "SceneWar:load() failed to create actors in scene with param.")
	
	self.m_WarFieldActor = actorsInScene.WarFieldActor
	self:removeAllChildren()
		:addChild(self.m_WarFieldActor:getView())

    self:resetTouchListener()
        
	return self
end

function SceneWar.createInstance(param)
	local SceneWar = SceneWar.new():load(param)
	assert(SceneWar, "SceneWar.createInstance() failed.")
	
	return SceneWar
end

return SceneWar
