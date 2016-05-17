
local ViewErrorIndicator = class("ViewErrorIndicator", cc.Node)

local WIDTH, HEIGHT = display.width, display.height

local BACKGROUND_COLOR = {r = 0, g = 0, b = 0, a = 160}

local FONT_NAME          = "res/fonts/msyhbd.ttc"
local FONT_SIZE          = 18
local FONT_COLOR         = {r = 255, g = 255, b = 255}
local FONT_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local FONT_OUTLINE_WIDTH = 1

--------------------------------------------------------------------------------
-- The composition background.
--------------------------------------------------------------------------------
local function createBackground()
    local background = cc.LayerColor:create(BACKGROUND_COLOR)
    background:setContentSize(WIDTH, HEIGHT)
        :ignoreAnchorPointForPosition(true)

    return background
end

local function initWithBackground(self, background)
    self.m_Background = background
    self:addChild(background)
end

--------------------------------------------------------------------------------
-- The composition label.
--------------------------------------------------------------------------------
local function createLabel(msg)
    local label = cc.Label:createWithTTF("", FONT_NAME, FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)
        :setDimensions(WIDTH, HEIGHT)

        :setTextColor(FONT_COLOR)
        :enableOutline(FONT_OUTLINE_COLOR, FONT_OUTLINE_WIDTH)

        -- TODO: truncate the msg if it's too long
        :setString(msg)

    return label
end

local function initWithLabel(self, label)
    self.m_Label = label
    self:addChild(label)
end

--------------------------------------------------------------------------------
-- The touch listener.
--------------------------------------------------------------------------------
local function createTouchListener(self)
    local touchListener = cc.EventListenerTouchAllAtOnce:create()
    touchListener:registerScriptHandler(function()
        self:removeFromParent()
    end, cc.Handler.EVENT_TOUCHES_BEGAN)

    return touchListener
end

local function initWithTouchListener(self, listener)
    self.m_TouchListener = listener
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewErrorIndicator:ctor(errorMsg)
    initWithBackground(   self, createBackground())
    initWithLabel(        self, createLabel(errorMsg))
    initWithTouchListener(self, createTouchListener(self))

    return self
end

return ViewErrorIndicator
