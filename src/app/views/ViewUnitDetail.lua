
local ViewUnitDetail = class("ViewUnitDetail", cc.Node)

local BACKGROUND_SIZE_WIDTH  = display.width * 0.7
local BACKGROUND_SIZE_HEIGHT = display.height * 0.7
local BACKGROUND_POSITION_X = (display.width  - BACKGROUND_SIZE_WIDTH) / 2
local BACKGROUND_POSITION_Y = (display.height - BACKGROUND_SIZE_HEIGHT) / 2

local function createScreenBackground()
    local background = cc.LayerColor:create({r = 0, g = 0, b = 0, a = 160})
    background:setContentSize(display.width, display.height)
        :ignoreAnchorPointForPosition(true)

    return background
end

local function initWithScreenBackground(view, background)
    view.m_ScreenBackground = background
    view:addChild(background)
end

local function createDetailBackground()
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", {x = 4, y = 5, width = 1, height = 1})
    background:ignoreAnchorPointForPosition(true)
        :setPosition(BACKGROUND_POSITION_X, BACKGROUND_POSITION_Y)

        :setContentSize(BACKGROUND_SIZE_WIDTH, BACKGROUND_SIZE_HEIGHT)

    background.m_TouchSwallower = require("app.utilities.CreateTouchSwallowerForNode")(background)
    background:getEventDispatcher():addEventListenerWithSceneGraphPriority(background.m_TouchSwallower, background)

    return background
end

local function initWithDetailBackground(view, background)
    view.m_DetailBackground = background
    view:addChild(background)
end

local function createLabel()
    local label = cc.Label:createWithTTF("", "res/fonts/msyhbd.ttc", 25)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(BACKGROUND_POSITION_X + 5, BACKGROUND_POSITION_Y + 6)

        :setDimensions(BACKGROUND_SIZE_WIDTH - 10, BACKGROUND_SIZE_HEIGHT - 14)

        :setTextColor({r = 255, g = 255, b = 255})
        :enableOutline({r = 0, g = 0, b = 0}, 2)

    return label
end

local function initWithLabel(view, label)
    view.m_Label = label
    view:addChild(label)
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

function ViewUnitDetail:ctor(param)
    initWithScreenBackground(self, createScreenBackground())
    initWithDetailBackground(self, createDetailBackground())
    initWithLabel(self, createLabel())
    initWithTouchListener(self, createTouchListener(self))

    self:setCascadeOpacityEnabled(true)
        :setOpacity(180)

    if (param) then
        self:load(param)
    end

    return self
end

function ViewUnitDetail:load(param)
    return self
end

function ViewUnitDetail.createInstance(param)
    local view = ViewUnitDetail:create():load(param)
    assert(view, "ViewUnitDetail.createInstance() failed.")

    return view
end

function ViewUnitDetail:updateWithModelUnit(unit)
    self.m_Label:setString(unit:getDescription())

    return self
end

function ViewUnitDetail:setEnabled(enabled)
    if (enabled) then
        self:setVisible(true)
        self:getEventDispatcher():resumeEventListenersForTarget(self, true)
    else
        self:setVisible(false)
        self:getEventDispatcher():pauseEventListenersForTarget(self, true)
    end

    return self
end

return ViewUnitDetail
