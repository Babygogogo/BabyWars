
local ViewMapCursor = class("ViewMapCursor", cc.Node)

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

function ViewMapCursor:ctor(param)
    self:setAnchorPoint(0.5, 0.5)
        :ignoreAnchorPointForPosition(true)

    initWithUpperLeftCorner( self, createUpperLeftCorner())
    initWithUpperRightCorner(self, createUpperRightCorner())
    initWithLowerLeftCorner( self, createLowerLeftCorner())
    initWithLowerRightCorner(self, createLowerRightCorner())
    
    if (param) then
        self:load(param)
    end
    
    return self
end

function ViewMapCursor:load(param)
    return self
end

function ViewMapCursor.createInstance(param)
    local view = ViewMapCursor:create():load(param)
    assert(view, "ViewMapCursor.createInstance() failed.")
    
    return view
end

return ViewMapCursor
