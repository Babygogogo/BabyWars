
local ViewUnitDetail = class("ViewUnitDetail", cc.Node)

local BACKGROUND_WIDTH  = display.width * 0.7
local BACKGROUND_HEIGHT = display.height * 0.7
local BACKGROUND_POSITION_X = (display.width  - BACKGROUND_WIDTH) / 2
local BACKGROUND_POSITION_Y = (display.height - BACKGROUND_HEIGHT) / 2

local DESCRIPTION_WIDTH      = BACKGROUND_WIDTH - 10
local DESCRIPTION_HEIGHT     = 80
local DESCRIPTION_POSITION_X = BACKGROUND_POSITION_X + 5
local DESCRIPTION_POSITION_Y = BACKGROUND_POSITION_Y + BACKGROUND_HEIGHT - DESCRIPTION_HEIGHT - 8

local MOVEMENT_INFO_WIDTH      = BACKGROUND_WIDTH - 10
local MOVEMENT_INFO_HEIGHT     = 40
local MOVEMENT_INFO_POSITION_X = BACKGROUND_POSITION_X + 5
local MOVEMENT_INFO_POSITION_Y = DESCRIPTION_POSITION_Y - MOVEMENT_INFO_HEIGHT

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

        :setContentSize(BACKGROUND_WIDTH, BACKGROUND_HEIGHT)

    background.m_TouchSwallower = require("app.utilities.CreateTouchSwallowerForNode")(background)
    background:getEventDispatcher():addEventListenerWithSceneGraphPriority(background.m_TouchSwallower, background)

    return background
end

local function initWithDetailBackground(view, background)
    view.m_DetailBackground = background
    view:addChild(background)
end

local function createDescription()
    local bottomLine = cc.Scale9Sprite:createWithSpriteFrameName("c03_t06_s01_f01.png", {x = 2, y = 0, width = 1, height = 1})
    bottomLine:ignoreAnchorPointForPosition(true)
        :setPosition(DESCRIPTION_POSITION_X + 5, DESCRIPTION_POSITION_Y)
        :setContentSize(DESCRIPTION_WIDTH - 10, DESCRIPTION_HEIGHT)

    local label = cc.Label:createWithTTF("", "res/fonts/msyhbd.ttc", 25)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(DESCRIPTION_POSITION_X, DESCRIPTION_POSITION_Y)

        :setDimensions(DESCRIPTION_WIDTH, DESCRIPTION_HEIGHT)

        :setTextColor({r = 255, g = 255, b = 255})
        :enableOutline({r = 0, g = 0, b = 0}, 2)

    local description = cc.Node:create()
    description:ignoreAnchorPointForPosition(true)
        :addChild(bottomLine)
        :addChild(label)

    description.m_BottomLine   = bottomLine
    description.m_Label        = label
    description.setDescription = function(self, description)
        self.m_Label:setString(description)
    end

    return description
end

local function initWithDescription(view, description)
    view.m_Description = description
    view:addChild(description)
end

local function updateDescriptionWithModelUnit(description, unit)
    description:setDescription(unit:getDescription())
end

local function createMovementInfo()
    local bottomLine = cc.Scale9Sprite:createWithSpriteFrameName("c03_t06_s01_f01.png", {x = 2, y = 0, width = 1, height = 1})
    bottomLine:ignoreAnchorPointForPosition(true)
        :setPosition(MOVEMENT_INFO_POSITION_X + 5, MOVEMENT_INFO_POSITION_Y)
        :setContentSize(MOVEMENT_INFO_WIDTH - 10, MOVEMENT_INFO_HEIGHT)

    local label = cc.Label:createWithTTF("", "res/fonts/msyhbd.ttc", 25)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(MOVEMENT_INFO_POSITION_X, MOVEMENT_INFO_POSITION_Y)

        :setDimensions(MOVEMENT_INFO_WIDTH, MOVEMENT_INFO_HEIGHT)

        :setTextColor({r = 255, g = 255, b = 255})
        :enableOutline({r = 0, g = 0, b = 0}, 2)

    local info = cc.Node:create()
    info:ignoreAnchorPointForPosition(true)
        :addChild(bottomLine)
        :addChild(label)

    info.m_BottomLine = bottomLine
    info.m_Label      = label
    info.setMovement  = function(self, range, moveType)
        self.m_Label:setString("Movement:    " .. "Range: " .. range .. "    Type: " .. moveType)
    end

    return info
end

local function initWithMovementInfo(view, info)
    view.m_MovementInfo = info
    view:addChild(info)
end

local function updateMovementInfoWithModelUnit(info, unit)
    info:setMovement(unit:getMovementRange(), unit:getMovementType())
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
    initWithDescription(self, createDescription())
    initWithMovementInfo(self, createMovementInfo())
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
    updateDescriptionWithModelUnit(self.m_Description, unit)
    updateMovementInfoWithModelUnit(self.m_MovementInfo, unit)

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
