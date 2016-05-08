
-- ViewMapCursor is actually a node(as large as the field) that contains the cursor.
local ViewMapCursor = class("ViewMapCursor", cc.Node)

local GridIndexFunctions = require("app.utilities.GridIndexFunctions")
local AnimationLoader    = require("app.utilities.AnimationLoader")

local PULSE_IN_DURATION = 0.15
local PULSE_OUT_DURATION = 0.15
local PULSE_INTERVAL_DURATION = 0.3

local GRID_SIZE = require("app.utilities.GameConstantFunctions").getGridSize()
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

local LOWER_RIGHT_CORNER_OUTER_POSITION_X =  31 + GRID_SIZE.width
local LOWER_RIGHT_CORNER_INNER_POSITION_X =  21 + GRID_SIZE.width
local LOWER_RIGHT_CORNER_OUTER_POSITION_Y = -31
local LOWER_RIGHT_CORNER_INNER_POSITION_Y = -21

local TARGET_CURSOR_OFFSET_X = - GRID_SIZE.width  / 2
local TARGET_CURSOR_OFFSET_Y = - GRID_SIZE.height / 2

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createCornerPulseAction(outerX, outerY, innerX, innerY)
    local pulseIn  = cc.MoveTo:create(PULSE_IN_DURATION,  {x = innerX, y = innerY})
    local pulseOut = cc.MoveTo:create(PULSE_OUT_DURATION, {x = outerX, y = outerY})
    local interval = cc.DelayTime:create(PULSE_INTERVAL_DURATION)

    return cc.RepeatForever:create(cc.Sequence:create(pulseIn, pulseOut, interval))
end

--------------------------------------------------------------------------------
-- The composition normal cursor.
--------------------------------------------------------------------------------
local function createUpperLeftCorner()
    local corner = cc.Sprite:createWithSpriteFrameName("c03_t07_s06_f01.png")
    corner:setAnchorPoint(0.5, 0.5)
        :setPosition(UPPER_LEFT_CORNER_OUTER_POSITION_X, UPPER_LEFT_CORNER_OUTER_POSITION_Y)

    corner.m_PulseAction = createCornerPulseAction(UPPER_LEFT_CORNER_OUTER_POSITION_X, UPPER_LEFT_CORNER_OUTER_POSITION_Y,
                                                   UPPER_LEFT_CORNER_INNER_POSITION_X, UPPER_LEFT_CORNER_INNER_POSITION_Y)
    corner:runAction(corner.m_PulseAction)

    return corner
end

local function initWithUpperLeftCorner(self, corner)
    self.m_UpperLeftCorner = corner
    self:addChild(corner)
end

local function createUpperRightCorner()
    local corner = cc.Sprite:createWithSpriteFrameName("c03_t07_s06_f01.png")
    corner:setAnchorPoint(0.5, 0.5)
        :setRotation(90)
        :setPosition(UPPER_RIGHT_CORNER_OUTER_POSITION_X, UPPER_RIGHT_CORNER_OUTER_POSITION_Y)

    corner.m_PulseAction = createCornerPulseAction(UPPER_RIGHT_CORNER_OUTER_POSITION_X, UPPER_RIGHT_CORNER_OUTER_POSITION_Y,
                                                   UPPER_RIGHT_CORNER_INNER_POSITION_X, UPPER_RIGHT_CORNER_INNER_POSITION_Y)
    corner:runAction(corner.m_PulseAction)

    return corner
end

local function initWithUpperRightCorner(self, corner)
    self.m_UpperRightCorner = corner
    self:addChild(corner)
end

local function createLowerLeftCorner()
    local corner = cc.Sprite:createWithSpriteFrameName("c03_t07_s06_f01.png")
    corner:setAnchorPoint(0.5, 0.5)
        :setRotation(-90)
        :setPosition(LOWER_LEFT_CORNER_OUTER_POSITION_X, LOWER_LEFT_CORNER_OUTER_POSITION_Y)

    corner.m_PulseAction = createCornerPulseAction(LOWER_LEFT_CORNER_OUTER_POSITION_X, LOWER_LEFT_CORNER_OUTER_POSITION_Y,
                                                   LOWER_LEFT_CORNER_INNER_POSITION_X, LOWER_LEFT_CORNER_INNER_POSITION_Y)
    corner:runAction(corner.m_PulseAction)

    return corner
end

local function initWithLowerLeftCorner(self, corner)
    self.m_LowerLeftCorner = corner
    self:addChild(corner)
end

local function createLowerRightCorner()
    local corner = cc.Sprite:createWithSpriteFrameName("c03_t07_s07_f01.png")
    corner:setAnchorPoint(0.5, 0.5)
        :setPosition(LOWER_RIGHT_CORNER_OUTER_POSITION_X, LOWER_RIGHT_CORNER_OUTER_POSITION_Y)

    corner.m_PulseAction = createCornerPulseAction(LOWER_RIGHT_CORNER_OUTER_POSITION_X, LOWER_RIGHT_CORNER_OUTER_POSITION_Y,
                                                   LOWER_RIGHT_CORNER_INNER_POSITION_X,  LOWER_RIGHT_CORNER_INNER_POSITION_Y)
    corner:runAction(corner.m_PulseAction)

    return corner
end

local function initWithLowerRightCorner(self, corner)
    self.m_LowerRightCorner = corner
    self:addChild(corner)
end

local function createNormalCursor()
    local cursor = cc.Node:create()
    cursor:setAnchorPoint(0.5, 0.5)
        :ignoreAnchorPointForPosition(true)

    initWithUpperLeftCorner( cursor, createUpperLeftCorner())
    initWithUpperRightCorner(cursor, createUpperRightCorner())
    initWithLowerLeftCorner( cursor, createLowerLeftCorner())
    initWithLowerRightCorner(cursor, createLowerRightCorner())

    return cursor
end

local function initWithNormalCursor(self, cursor)
    self.m_NormalCursor = cursor
    self:addChild(cursor)
end

--------------------------------------------------------------------------------
-- The composition target cursor.
--------------------------------------------------------------------------------
local function createTargetCursor()
    local cursor = cc.Sprite:create()
    cursor:ignoreAnchorPointForPosition(true)
        :playAnimationForever(display.getAnimationCache("TargetCursor"))

    return cursor
end

local function initWithTargetCursor(self, cursor)
    self.m_TargetCursor = cursor
    self:addChild(cursor)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewMapCursor:ctor(param)
    self:ignoreAnchorPointForPosition(true)

    initWithNormalCursor(self, createNormalCursor())
    initWithTargetCursor(self, createTargetCursor())

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

return ViewMapCursor
