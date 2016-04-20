
local ViewUnit = class("ViewUnit", cc.Node)

local TypeChecker           = require("app.utilities.TypeChecker")
local AnimationLoader       = require("app.utilities.AnimationLoader")
local GridIndexFunctions    = require("app.utilities.GridIndexFunctions")
local GameConstantFunctions = require("app.utilities.GameConstantFunctions")

local GRID_SIZE              = GameConstantFunctions.getGridSize()
local COLOR_IDLE             = {r = 255, g = 255, b = 255}
local COLOR_ACTIONED         = {r = 170, g = 170, b = 170}
local MOVE_DURATION_PER_GRID = 0.1

local STATE_INDICATOR_POSITION_X = 3
local STATE_INDICATOR_POSITION_Y = 0
local HP_INDICATOR_POSITION_X = GRID_SIZE.width - 24 -- 24 is the width of the indicator
local HP_INDICATOR_POSITION_Y = 0

local STATE_INDICATOR_DURATION = 0.8

local HP_INDICATOR_Z_ORDER    = 1
local STATE_INDICATOR_Z_ORDER = 1
local UNIT_SPRITE_Z_ORDER     = 0

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createActionMoveAlongPath(path, callback)
    local steps = {}
    for i = 2, #path do
        steps[#steps + 1] = cc.MoveTo:create(MOVE_DURATION_PER_GRID, GridIndexFunctions.toPositionTable(path[i]))
    end

    steps[#steps + 1] = cc.CallFunc:create(callback)
    return cc.Sequence:create(unpack(steps))
end

local function getLevelIndicatorFrame(unit)
    if ((unit.getLevel) and (unit:getLevel() > 0)) then
        return cc.SpriteFrameCache:getInstance():getSpriteFrame("c02_t99_s05_f0" .. level .. ".png")
    else
        return nil
    end
end

local function getFuelIndicatorFrame(unit)
    if ((unit.isFuelInShort) and (unit:isFuelInShort())) then
        return cc.SpriteFrameCache:getInstance():getSpriteFrame("c02_t99_s02_f01.png")
    else
        return nil
    end
end

local function getAmmoIndicatorFrame(unit)
    if ((unit.isPrimaryWeaponAmmoInShort) and (unit:isPrimaryWeaponAmmoInShort())) then
        return cc.SpriteFrameCache:getInstance():getSpriteFrame("c02_t99_s02_f02.png")
    else
        return nil
    end
end

local function getSubmergedIndicatorFrame(unit)
    if ((unit.isSumberged) and (unit:isSumberged())) then
        return cc.SpriteFrameCache:getInstance():getSpriteFrame("c02_t99_s03_f0" .. unit:getPlayerIndex() .. ".png")
    else
        return nil
    end
end

local function getCaptureIndicatorFrame(unit)
    if ((unit.isCapturing) and (unit:isCapturing())) then
        return cc.SpriteFrameCache:getInstance():getSpriteFrame("c02_t99_s04_f0" .. unit:getPlayerIndex() .. ".png")
    else
        return nil
    end
end

--------------------------------------------------------------------------------
-- The unit sprite.
--------------------------------------------------------------------------------
local function createUnitSprite()
    local sprite = cc.Sprite:create()
    sprite:ignoreAnchorPointForPosition(true)

    return sprite
end

local function initWithUnitSprite(self, sprite)
    self.m_UnitSprite = sprite
    self:addChild(sprite, UNIT_SPRITE_Z_ORDER)
end

local function updateUnitSprite(self, tiledID)
    assert(TypeChecker.isTiledID(tiledID))
    if (self.m_TiledID ~= tiledID) then
        self.m_TiledID = tiledID

        local unitName    = GameConstantFunctions.getUnitNameWithTiledId(tiledID)
        local playerIndex = GameConstantFunctions.getPlayerIndexWithTiledId(tiledID)
        self.m_UnitSprite:stopAllActions()
            :playAnimationForever(AnimationLoader.getUnitAnimation(unitName, playerIndex, "normal"))
    end
end

--------------------------------------------------------------------------------
-- The unit state.
--------------------------------------------------------------------------------
local function updateUnitState(self, state)
    if (state == "idle") then
        self:setColor(COLOR_IDLE)
    elseif (state == "actioned") then
        self:setColor(COLOR_ACTIONED)
    else
        error("ViewUnit-updateUnitState() unrecognized unit state.")
    end
end

--------------------------------------------------------------------------------
-- The hp indicator.
--------------------------------------------------------------------------------
local function createHpIndicator()
    local indicator = cc.Sprite:createWithSpriteFrameName("c02_t99_s01_f00.png")
    indicator:ignoreAnchorPointForPosition(true)
        :setPosition(HP_INDICATOR_POSITION_X, HP_INDICATOR_POSITION_Y)
        :setVisible(false)

    return indicator
end

local function initWithHpIndicator(self, indicator)
    self.m_HpIndicator = indicator
    self:addChild(indicator, HP_INDICATOR_Z_ORDER)
end

local function updateHpIndicator(indicator, hp)
    if ((hp >= 10) or (hp < 0)) then
        indicator:setVisible(false)
    else
        indicator:setVisible(true)
            :setSpriteFrame("c02_t99_s01_f0" .. hp .. ".png")
    end
end

--------------------------------------------------------------------------------
-- The state indicator.
--------------------------------------------------------------------------------
local function createStateIndicator()
    local indicator = cc.Sprite:createWithSpriteFrameName("c02_t99_s02_f01.png")
    indicator:ignoreAnchorPointForPosition(true)
        :setPosition(STATE_INDICATOR_POSITION_X, STATE_INDICATOR_POSITION_Y)
        :setVisible(true)

    return indicator
end

local function initWithStateIndicator(self, indicator)
    self.m_StateIndicator = indicator
    self:addChild(indicator, STATE_INDICATOR_Z_ORDER)
end

local function updateStateIndicator(indicator, unit)
    local frames = {}
    frames[#frames + 1] = getLevelIndicatorFrame(    unit)
    frames[#frames + 1] = getFuelIndicatorFrame(     unit)
    frames[#frames + 1] = getAmmoIndicatorFrame(     unit)
    frames[#frames + 1] = getSubmergedIndicatorFrame(unit)
    frames[#frames + 1] = getCaptureIndicatorFrame(  unit)

    indicator:stopAllActions()
    if (#frames == 0) then
        indicator:setVisible(false)
    else
        indicator:setVisible(true)
            :playAnimationForever(display.newAnimation(frames, STATE_INDICATOR_DURATION))
    end
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewUnit:ctor(param)
    self:ignoreAnchorPointForPosition(true)
        :setCascadeColorEnabled(true)

    initWithUnitSprite(    self, createUnitSprite())
    initWithHpIndicator(   self, createHpIndicator())
    initWithStateIndicator(self, createStateIndicator())

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewUnit:updateWithModelUnit(unit)
    updateUnitSprite(    self,                  unit:getTiledID())
    updateUnitState(     self,                  unit:getState())
    updateHpIndicator(   self.m_HpIndicator,    unit:getNormalizedCurrentHP())
    updateStateIndicator(self.m_StateIndicator, unit)
end

function ViewUnit:moveAlongPath(path, callbackOnFinish)
    self:runAction(createActionMoveAlongPath(path, callbackOnFinish))

    return self
end

return ViewUnit
