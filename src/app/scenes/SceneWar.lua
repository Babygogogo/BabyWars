
local SceneWar = class("SceneWar", cc.Scene)

local Actor            = require("global.actors.Actor")
local TypeChecker      = require("app.utilities.TypeChecker")
local ComponentManager = require("global.components.ComponentManager")

local function onCleanup(scene)
    print("SceneWar-onCleanup")
end

local function initNodeEvents(scene)
    local function onNodeEvent(event)
        if event == "cleanup" then
            onCleanup(scene)
        end
    end
    
    scene:registerScriptHandler(onNodeEvent)
end

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

local function createChildrenActors(param)
	local sceneData = requireSceneData(param)
	assert(TypeChecker.isWarSceneData(sceneData))

    local warFieldActor = Actor.createWithModelAndViewName("ModelWarField", sceneData.WarField, "ViewWarField", sceneData.WarField)
	assert(warFieldActor, "SceneWar--createChildrenActors() failed to create a WarField actor.")

    local hudActor = Actor.createWithModelAndViewName("ModelSceneWarHUD", nil, "ViewSceneWarHUD")
    assert(hudActor, "SceneWar--createChildrenActors() failed to create a HUD actor.")

	return {WarFieldActor = warFieldActor, SceneWarHUDActor = hudActor}
end

local function initWithChildrenActors(scene, actors)
    scene.m_WarFieldActor = actors.WarFieldActor
    assert(scene.m_WarFieldActor, "SceneWar--initWithChildrenActors() failed to retrieve the WarField actor.")

    scene.m_SceneWarHUDActor = actors.SceneWarHUDActor
    assert(scene.m_SceneWarHUDActor, "SceneWar--initWithChildrenActors() failed to retrieve the SceneWarHUD actor.")
end

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

    local eventDispatcher = scene:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(scene.m_TouchListener, scene)
--    eventDispatcher:addEventListenerWithFixedPriority(touchListener, 1)
end

local function getChildrenViewsFromButtomToTop(scene)
    local views = {}
    
    views[#views + 1] = scene.m_WarFieldActor:getView()
    views[#views + 1] = scene.m_SceneWarHUDActor:getView()
    
    return views
end

local function initWithChildrenViews(scene, viewsFromButtomToTop)
    scene:removeAllChildren()

    for _, view in ipairs(viewsFromButtomToTop) do
        scene:addChild(view)
    end
end

function SceneWar:ctor(param)
    initNodeEvents(self)

	if (param) then
        self:load(param)
    end
	
	return self
end

function SceneWar:load(param)
	initWithChildrenActors(self, createChildrenActors(param))
    initWithTouchListener(self, createTouchListener(self:getTouchableChildrenViews()))
    initWithChildrenViews(self, getChildrenViewsFromButtomToTop(self))
        
	return self
end

function SceneWar.createInstance(param)
	local scene = SceneWar.new():load(param)
	assert(scene, "SceneWar.createInstance() failed.")
	
	return scene
end

function SceneWar:getTouchableChildrenViews()
    local views = {}
    local getTouchableViewFromActor = require("app.utilities.GetTouchableViewFromActor")

    -- TODO: Add more children views. Be careful of the order of the views!
    views[#views + 1] = getTouchableViewFromActor(self.m_SceneWarHUDActor)
    views[#views + 1] = getTouchableViewFromActor(self.m_WarFieldActor)
    
    return views
end

return SceneWar
