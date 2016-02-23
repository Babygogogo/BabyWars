
local SceneWar = class("SceneWar", cc.Scene)

local Actor            = require("global.actors.Actor")
local TypeChecker      = require("app.utilities.TypeChecker")
local ComponentManager = require("global.components.ComponentManager")

local function findResponsiveView(index, views, touch, touchType, event)
    if (index and views[index]) then
        return index, views[index] 
    else
        for i, view in ipairs(views) do
            if (view:isResponsiveToTouch(touch, touchType, event)) then
                return i, view 
            end
        end
        
        return 0
    end
end

local function findAndUpdateResponsiveView(viewIndex, views, touch, touchType, event)
    local index, view = findResponsiveView(viewIndex, views, touch, touchType, event)
    if (view) then
        view:onTouch(touch, touchType, event)
    end
   
    return index
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

function SceneWar:getChildrenViews()
    local views = {}
    views[#views + 1] = self.m_WarFieldActor and self.m_WarFieldActor:getView() or nil
    -- TODO: Add more children views.
    
    return views
end

function SceneWar:createTouchListener()
    local views = self:getChildrenViews()
    local responsiveViewIndex = 0

   	local function onTouchBegan(touch, event)
        responsiveViewIndex = findAndUpdateResponsiveView(responsiveViewIndex, views, touch, cc.Handler.EVENT_TOUCH_BEGAN, event)
        
    	return true
	end
    
	local function onTouchMoved(touch, event)
        responsiveViewIndex = findAndUpdateResponsiveView(responsiveViewIndex, views, touch, cc.Handler.EVENT_TOUCH_MOVED, event)
	end
    
    local function onTouchCancelled(touch, event)
        findAndUpdateResponsiveView(responsiveViewIndex, views, touch, cc.Handler.EVENT_TOUCH_CANCELLED, event)
        responsiveViewIndex = 0
    end   
     
    local function onTouchEnded(touch, event)
        findAndUpdateResponsiveView(responsiveViewIndex, views, touch, cc.Handler.EVENT_TOUCH_ENDED, event)
        responsiveViewIndex = 0
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
    if (self.m_TouchListener) then eventDispatcher:removeEventListener(self.m_TouchListener) end
    
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
	
	local warFieldActor = actorsInScene.WarFieldActor

	self.m_WarFieldActor = warFieldActor
	self:removeAllChildren()
		:addChild(warFieldActor:getView())

    self:resetTouchListener()
        
	return self
end

function SceneWar.createInstance(param)
	local SceneWar = SceneWar.new():load(param)
	assert(SceneWar, "SceneWar.createInstance() failed.")
	
	return SceneWar
end

return SceneWar
