
-- ViewMapCursor is actually a node(as large as the field) that contains the cursor.
local ViewMapCursor = class("ViewMapCursor", cc.Node)

local GridIndexFunctions = requireBW("src.app.utilities.GridIndexFunctions")
local AnimationLoader    = requireBW("src.app.utilities.AnimationLoader")

local PULSE_IN_DURATION = 0.15
local PULSE_OUT_DURATION = 0.15
local PULSE_INTERVAL_DURATION = 0.3

local GRID_SIZE = requireBW("src.app.utilities.GameConstantFunctions").getGridSize()
local UPPER_LEFT_CORNER_OUTER_POSITION_X = -6
local UPPER_LEFT_CORNER_INNER_POSITION_X =  4
local UPPER_LEFT_CORNER_OUTER_POSITION_Y =  6 + GRID_SIZE.height
local UPPER_LEFT_CORNER_INNER_POSITION_Y = -4 + GRID_SIZE.height

local UPPER_RIGHT_CORNER_OUTER_POSITION_X =  6 + GRID_SIZE.width
local UPPER_RIGHT_CORNER_INNER_POSITION_X = -4 + GRID_SIZE.width
local UPPER_RIGHT_CORNER_OUTER_POSITION_Y =  6 + GRID_SIZE.height
local UPPER_RIGHT_CORNER_INNER_POSITION_Y = -4 + GRID_SIZE.height

local LOWER_LEFT_CORNER_OUTER_POSITION_X = -6
local LOWER_LEFT_CORNER_INNER_POSITION_X =  4
local LOWER_LEFT_CORNER_OUTER_POSITION_Y = -6
local LOWER_LEFT_CORNER_INNER_POSITION_Y =  4

local LOWER_RIGHT_CORNER_OUTER_POSITION_X =  25 + GRID_SIZE.width
local LOWER_RIGHT_CORNER_INNER_POSITION_X =  15 + GRID_SIZE.width
local LOWER_RIGHT_CORNER_OUTER_POSITION_Y = -25
local LOWER_RIGHT_CORNER_INNER_POSITION_Y = -15

local TARGET_CURSOR_OFFSET_X = - GRID_SIZE.width
local TARGET_CURSOR_OFFSET_Y = - GRID_SIZE.height
local SILO_CURSOR_OFFSET_X   = - GRID_SIZE.width  * 2
local SILO_CURSOR_OFFSET_Y   = - GRID_SIZE.height * 2

--------------------------------------------------------------------------------
-- The composition normal cursor.
--------------------------------------------------------------------------------
local function createCornerPulseAction(outerX, outerY, innerX, innerY)
    local pulseIn  = cc.MoveTo:create(PULSE_IN_DURATION,  {x = innerX, y = innerY})
    local pulseOut = cc.MoveTo:create(PULSE_OUT_DURATION, {x = outerX, y = outerY})
    local interval = cc.DelayTime:create(PULSE_INTERVAL_DURATION)

    return cc.RepeatForever:create(cc.Sequence:create(pulseIn, pulseOut, interval))
end

local function initUpperLeftCorner(cursor)
    local corner = cc.Sprite:createWithSpriteFrameName("c03_t07_s06_f01.png")
    corner:setAnchorPoint(0.5, 0.5)
        :setPosition(UPPER_LEFT_CORNER_OUTER_POSITION_X, UPPER_LEFT_CORNER_OUTER_POSITION_Y)

    corner.m_PulseAction = createCornerPulseAction(UPPER_LEFT_CORNER_OUTER_POSITION_X, UPPER_LEFT_CORNER_OUTER_POSITION_Y,
                                                   UPPER_LEFT_CORNER_INNER_POSITION_X, UPPER_LEFT_CORNER_INNER_POSITION_Y)
    corner:runAction(corner.m_PulseAction)

    cursor.m_UpperLeftCorner = corner
    cursor:addChild(corner)
end

local function initUpperRightCorner(cursor)
    local corner = cc.Sprite:createWithSpriteFrameName("c03_t07_s06_f01.png")
    corner:setAnchorPoint(0.5, 0.5)
        :setRotation(90)
        :setPosition(UPPER_RIGHT_CORNER_OUTER_POSITION_X, UPPER_RIGHT_CORNER_OUTER_POSITION_Y)

    corner.m_PulseAction = createCornerPulseAction(UPPER_RIGHT_CORNER_OUTER_POSITION_X, UPPER_RIGHT_CORNER_OUTER_POSITION_Y,
                                                   UPPER_RIGHT_CORNER_INNER_POSITION_X, UPPER_RIGHT_CORNER_INNER_POSITION_Y)
    corner:runAction(corner.m_PulseAction)

    cursor.m_UpperRightCorner = corner
    cursor:addChild(corner)
end

local function initLowerLeftCorner(cursor)
    local corner = cc.Sprite:createWithSpriteFrameName("c03_t07_s06_f01.png")
    corner:setAnchorPoint(0.5, 0.5)
        :setRotation(-90)
        :setPosition(LOWER_LEFT_CORNER_OUTER_POSITION_X, LOWER_LEFT_CORNER_OUTER_POSITION_Y)

    corner.m_PulseAction = createCornerPulseAction(LOWER_LEFT_CORNER_OUTER_POSITION_X, LOWER_LEFT_CORNER_OUTER_POSITION_Y,
                                                   LOWER_LEFT_CORNER_INNER_POSITION_X, LOWER_LEFT_CORNER_INNER_POSITION_Y)
    corner:runAction(corner.m_PulseAction)

    cursor.m_LowerLeftCorner = corner
    cursor:addChild(corner)
end

local function initLowerRightCorner(cursor)
    local corner = cc.Sprite:createWithSpriteFrameName("c03_t07_s07_f01.png")
    corner:setAnchorPoint(0.5, 0.5)
        :setPosition(LOWER_RIGHT_CORNER_OUTER_POSITION_X, LOWER_RIGHT_CORNER_OUTER_POSITION_Y)

    corner.m_PulseAction = createCornerPulseAction(LOWER_RIGHT_CORNER_OUTER_POSITION_X, LOWER_RIGHT_CORNER_OUTER_POSITION_Y,
                                                   LOWER_RIGHT_CORNER_INNER_POSITION_X,  LOWER_RIGHT_CORNER_INNER_POSITION_Y)
    corner:runAction(corner.m_PulseAction)

    cursor.m_LowerRightCorner = corner
    cursor:addChild(corner)
end

local function initNormalCursor(self)
    local cursor = cc.Node:create()
    cursor:setAnchorPoint(0.5, 0.5)
        :ignoreAnchorPointForPosition(true)

    initUpperLeftCorner( cursor)
    initUpperRightCorner(cursor)
    initLowerLeftCorner( cursor)
    initLowerRightCorner(cursor)

    self.m_NormalCursor = cursor
    self:addChild(cursor)
end

--------------------------------------------------------------------------------
-- The composition target/silo cursor.
--------------------------------------------------------------------------------
local function initTargetCursor(self)
    local cursor = cc.Sprite:create()
    cursor:ignoreAnchorPointForPosition(true)
        :playAnimationForever(display.getAnimationCache("TargetCursor"))

    self.m_TargetCursor = cursor
    self:addChild(cursor)
end

local function initSiloCursor(self)
    local cursor = cc.Sprite:createWithSpriteFrameName("c03_t07_s10_f01.png")
    cursor:ignoreAnchorPointForPosition(true)

    self.m_SiloCursor = cursor
    self:addChild(cursor)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewMapCursor:ctor(param)
    self:ignoreAnchorPointForPosition(true)

    initNormalCursor(self)
    initTargetCursor(self)
    initSiloCursor(  self)

    return self
end

function ViewMapCursor:setTouchListener(listener)
    assert(self.m_TouchListener == nil, "ViewMapCursor:setTouchListener() the listener has been set.")

    self.m_TouchListener = listener
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)

    return self
end

function ViewMapCursor:setMouseListener(listener)
    assert(self.m_MouseListener == nil, "ViewMapCursor:setMouseListener() the listener has been set.")

    self.m_MouseListener = listener
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewMapCursor:setPosition(x, y)
    self.m_NormalCursor:setPosition(x, y)
    self.m_TargetCursor:setPosition(x + TARGET_CURSOR_OFFSET_X, y + TARGET_CURSOR_OFFSET_Y)
    self.m_SiloCursor  :setPosition(x + SILO_CURSOR_OFFSET_X,   y + SILO_CURSOR_OFFSET_Y)

    return self
end

function ViewMapCursor:getPosition()
    return self.m_NormalCursor:getPosition()
end

function ViewMapCursor:setNormalCursorVisible(visible)
    self.m_NormalCursor:setVisible(visible)

    return self
end

function ViewMapCursor:setTargetCursorVisible(visible)
    self.m_TargetCursor:setVisible(visible)

    return self
end

function ViewMapCursor:setSiloCursorVisible(visible)
    self.m_SiloCursor:setVisible(visible)

    return self
end

return ViewMapCursor
