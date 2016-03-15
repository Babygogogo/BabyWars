
local ViewSceneWar = class("ViewSceneWar", cc.Scene)

local SCENE_HUD_Z_ORDER  = 1
local WAR_FIELD_Z_ORDER  = 0
local BACKGROUND_Z_ORDER = -1

--------------------------------------------------------------------------------
-- The background.
--------------------------------------------------------------------------------
local function createBackground()
    return cc.LayerGradient:create({r = 0,   g = 0,   b = 0},
--                                   {r = 240, g = 80, b = 56},  -- red
--                                   {r = 96,  g = 88, b = 240}, -- blue
--                                   {r = 216, g = 208, b = 8},  -- yellow
                                   {r = 96,  g = 224, b = 88}, -- green
                                   {x = -1,  y = 1})
end

local function initWithBackground(view, background)
    view.m_Background = background
    view:addChild(background, BACKGROUND_Z_ORDER)
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
    assert(not scene.m_TouchListener, "ViewSceneWar-initWithTouchListener() the scene already has a touch listener.")
    scene.m_TouchListener = touchListener

    scene:getEventDispatcher():addEventListenerWithSceneGraphPriority(scene.m_TouchListener, scene)
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewSceneWar:ctor(param)
    initWithBackground(self, createBackground())

	if (param) then
        self:load(param)
    end

	return self
end

function ViewSceneWar:load(param)
	return self
end

function ViewSceneWar.createInstance(param)
	local scene = ViewSceneWar.new():load(param)
	assert(scene, "ViewSceneWar.createInstance() failed.")

	return scene
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewSceneWar:initTouchListener(touchableChildrenViews)
    initWithTouchListener(self, createTouchListener(touchableChildrenViews))

    return self
end

function ViewSceneWar:setWarFieldView(view)
    if (self.m_WarFieldView) then
        self:removeChild(self.m_WarFieldView)
    end

    self.m_WarFieldView = view
    self:addChild(view, WAR_FIELD_Z_ORDER)

    return self
end

function ViewSceneWar:setSceneHudView(view)
    if (self.m_SceneHudView) then
        self:removeChild(self.m_SceneHudView)
    end

    self.m_SceneHudView = view
    self:addChild(view, SCENE_HUD_Z_ORDER)

    return self
end

return ViewSceneWar
