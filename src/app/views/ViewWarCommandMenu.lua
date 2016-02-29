
local ViewWarCommandMenu = class("ViewWarCommandMenu", cc.Node)

local CONTENT_SIZE_WIDTH  = 250
local CONTENT_SIZE_HEIGHT = display.height * 0.8
local POSITION_X = (display.width - CONTENT_SIZE_WIDTH) / 2
local POSITION_Y = (display.height - CONTENT_SIZE_HEIGHT) / 2

local function createBackground()
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", {x = 4, y = 5, width = 1, height = 1})
    background:ignoreAnchorPointForPosition(true)

    background.m_TouchSwallower = require("app.utilities.CreateTouchSwallowerForNode")(background)
    background:getEventDispatcher():addEventListenerWithSceneGraphPriority(background.m_TouchSwallower, background)

    return background
end

local function initWithBackground(view, background)
    view.m_Background = background
    view:addChild(background)
end

local function createListView()
    local listView = ccui.ListView:create()
    listView:ignoreAnchorPointForPosition(true)
        :setPosition(5, 6)

        :setItemsMargin(5)
        :setGravity(ccui.ListViewGravity.centerHorizontal)
        :setCascadeOpacityEnabled(true)

    return listView    
end

local function initWithListView(view, listView)
    view.m_ListView = listView
    view:addChild(listView)
end

local function createTouchListener(view)
    local touchListener = cc.EventListenerTouchOneByOne:create()
    touchListener:setSwallowTouches(true)
    
	touchListener:registerScriptHandler(function()
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)
    
    touchListener:registerScriptHandler(function()
        view:setEnabled(false)
    end, cc.Handler.EVENT_TOUCH_ENDED)
    
    return touchListener
end

local function initWithTouchListener(view, touchListener)
    view.m_TouchListener = touchListener
    view:getEventDispatcher():addEventListenerWithSceneGraphPriority(view.m_TouchListener, view)
end

function ViewWarCommandMenu:ctor(param)
    initWithBackground(self, createBackground())
    initWithListView(self, createListView())
    initWithTouchListener(self, createTouchListener(self))
    
    self:setContentSize(CONTENT_SIZE_WIDTH, CONTENT_SIZE_HEIGHT)
        
        :ignoreAnchorPointForPosition(true)
        :setPosition(POSITION_X, POSITION_Y)

        :setCascadeOpacityEnabled(true)
        :setOpacity(180)

	if (param) then
        self:load(param)
    end

	return self
end

function ViewWarCommandMenu:load(param)
    return self
end

function ViewWarCommandMenu.createInstance(param)
    local view = ViewWarCommandMenu.new():load(param)
    assert(view, "ViewWarCommandMenu.createInstance() failed.")

    return view
end

function ViewWarCommandMenu:setContentSize(width, height)
    self.m_Background:setContentSize(width, height)
    self.m_ListView:setContentSize(width - 10, height - 14) -- 10/14 are the height/width of the edging of background
    
    return self
end

function ViewWarCommandMenu:pushBackItem(item)
    self.m_ListView:pushBackCustomItem(item)
    
    return self
end

function ViewWarCommandMenu:removeAllItems()
    self.m_ListView:removeAllItems()
    
    return self
end

function ViewWarCommandMenu:setEnabled(enabled)
    if (enabled) then
        self:setVisible(true)
        self:getEventDispatcher():resumeEventListenersForTarget(self, true)
    else
        self:setVisible(false)
        self:getEventDispatcher():pauseEventListenersForTarget(self, true)
    end
    
    return self
end

return ViewWarCommandMenu
