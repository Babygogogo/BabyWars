
-- ViewMapCursor is actually a node(as large as the field) that contains the cursor.
local ViewMapCursor = class("ViewMapCursor", cc.Node)

local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

local PULSE_IN_DURATION = 0.15
local PULSE_OUT_DURATION = 0.15
local PULSE_INTERVAL_DURATION = 0.3

local GRID_SIZE = require("res.data.GameConstant").GridSize
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

local function createCornerPulseAction(outerX, outerY, innerX, innerY)
    local pulseIn  = cc.MoveTo:create(PULSE_IN_DURATION,  {x = innerX, y = innerY})
    local pulseOut = cc.MoveTo:create(PULSE_OUT_DURATION, {x = outerX, y = outerY})
    local interval = cc.DelayTime:create(PULSE_INTERVAL_DURATION)

    return cc.RepeatForever:create(cc.Sequence:create(pulseIn, pulseOut, interval))
end

--------------------------------------------------------------------------------
-- The composition cursor.
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

local function initWithUpperLeftCorner(view, corner)
    view.m_UpperLeftCorner = corner
    view:addChild(corner)
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

local function initWithUpperRightCorner(view, corner)
    view.m_UpperRightCorner = corner
    view:addChild(corner)
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

local function initWithLowerLeftCorner(view, corner)
    view.m_LowerLeftCorner = corner
    view:addChild(corner)
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

local function initWithLowerRightCorner(view, corner)
    view.m_LowerRightCorner = corner
    view:addChild(corner)
end

local function createCursor()
    local cursor = cc.Node:create()
    cursor:setAnchorPoint(0.5, 0.5)
        :ignoreAnchorPointForPosition(true)

    initWithUpperLeftCorner( cursor, createUpperLeftCorner())
    initWithUpperRightCorner(cursor, createUpperRightCorner())
    initWithLowerLeftCorner( cursor, createLowerLeftCorner())
    initWithLowerRightCorner(cursor, createLowerRightCorner())

    return cursor
end

local function initWithCursor(view, cursor)
    view.m_Cursor = cursor
    view:addChild(cursor)
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewMapCursor:ctor(param)
    self:ignoreAnchorPointForPosition(true)

    initWithCursor(self, createCursor())

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewMapCursor:setTouchListener(listener)
    local eventDispatcher = self:getEventDispatcher()
    if (self.m_TouchListener) then
        if (self.m_TouchListener == listener) then
            return self
        else
            eventDispatcher:removeEventListener(self.m_TouchListener)
        end
    end

    self.m_TouchListener = listener
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

    return self
end

function ViewMapCursor:setMouseListener(listener)
    local eventDispatcher = self:getEventDispatcher()
    if (self.m_MouseListener) then
        if (self.m_MouseListener == listener) then
            return self
        else
            eventDispatcher:removeEventListener(self.m_MouseListener)
        end
    end

    self.m_MouseListener = listener
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

    return self
end

function ViewMapCursor:setPosition(x, y)
    self.m_Cursor:setPosition(x, y)

    return self
end

return ViewMapCursor
