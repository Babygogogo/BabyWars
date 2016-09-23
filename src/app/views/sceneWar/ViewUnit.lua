
local ViewUnit = class("ViewUnit", cc.Node)

local AnimationLoader       = require("src.app.utilities.AnimationLoader")
local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")
local GridIndexFunctions    = require("src.app.utilities.GridIndexFunctions")
local SingletonGetters      = require("src.app.utilities.SingletonGetters")

local GRID_SIZE              = GameConstantFunctions.getGridSize()
local COLOR_IDLE             = {r = 255, g = 255, b = 255}
local COLOR_ACTIONED         = {r = 170, g = 170, b = 170}
local MOVE_DURATION_PER_GRID = 0.15

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
local function createActionMoveAlongPath(self, path, callback)
    local steps = {}
    local playerIndexMod = self.m_Model:getPlayerIndex() % 2

    for i = 2, #path do
        local currentX, previousX = path[i].x, path[i - 1].x
        if (currentX < previousX) then
            steps[#steps + 1] = cc.CallFunc:create(function()
                self.m_UnitSprite:setFlippedX(playerIndexMod == 1)
            end)
        elseif (currentX > previousX) then
            steps[#steps + 1] = cc.CallFunc:create(function()
                self.m_UnitSprite:setFlippedX(playerIndexMod == 0)
            end)
        end

        steps[#steps + 1] = cc.MoveTo:create(MOVE_DURATION_PER_GRID, GridIndexFunctions.toPositionTable(path[i]))
    end

    steps[#steps + 1] = cc.CallFunc:create(function()
        self.m_UnitSprite:setFlippedX(false)
    end)
    steps[#steps + 1] = cc.CallFunc:create(callback)

    return cc.Sequence:create(unpack(steps))
end

local function getSkillIndicatorFrame(unit)
    if (not unit:getSceneWarFileName()) then
        return nil
    end

    local playerIndex = unit:getPlayerIndex()
    local modelPlayer = SingletonGetters.getModelPlayerManager():getModelPlayer(playerIndex)
    local id          = modelPlayer:getModelSkillConfiguration():getActivatingSkillGroupId()
    if (not id) then
        return nil
    elseif (id == 1) then
        return cc.SpriteFrameCache:getInstance():getSpriteFrame("c02_t99_s08_f0" .. playerIndex .. ".png")
    else
        return cc.SpriteFrameCache:getInstance():getSpriteFrame("c02_t99_s07_f0" .. playerIndex .. ".png")
    end
end

local function getLevelIndicatorFrame(unit)
    if ((unit.getCurrentPromotion) and (unit:getCurrentPromotion() > 0)) then
        return cc.SpriteFrameCache:getInstance():getSpriteFrame("c02_t99_s05_f0" .. unit:getCurrentPromotion() .. ".png")
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
    if ((unit.isCapturingModelTile) and (unit:isCapturingModelTile())) then
        return cc.SpriteFrameCache:getInstance():getSpriteFrame("c02_t99_s04_f0" .. unit:getPlayerIndex() .. ".png")
    else
        return nil
    end
end

local function getBuildIndicatorFrame(unit)
    if ((unit.isBuildingModelTile) and (unit:isBuildingModelTile())) then
        return cc.SpriteFrameCache:getInstance():getSpriteFrame("c02_t99_s04_f0" .. unit:getPlayerIndex() .. ".png")
    else
        return nil
    end
end

local function getLoadIndicatorFrame(unit)
    if ((unit.getCurrentLoadCount) and (unit:getCurrentLoadCount() ~= 0)) then
        return cc.SpriteFrameCache:getInstance():getSpriteFrame("c02_t99_s06_f0" .. unit:getPlayerIndex() .. ".png")
    else
        return nil
    end
end

local function getMaterialIndicatorFrame(unit)
    if ((unit.isMaterialInShort) and (unit:isMaterialInShort())) then
        return cc.SpriteFrameCache:getInstance():getSpriteFrame("c02_t99_s02_f04.png")
    else
        return nil
    end
end

local function playSpriteAnimation(sprite, tiledID, state)
    if (state == "moving") then
        sprite:setPosition(-18, 0)
    else
        sprite:setPosition(0, 0)
    end

    local unitName       = GameConstantFunctions.getUnitTypeWithTiledId(tiledID)
    local playerIndex    = GameConstantFunctions.getPlayerIndexWithTiledId(tiledID)
    sprite:stopAllActions()
        :playAnimationForever(AnimationLoader.getUnitAnimation(unitName, playerIndex, state))
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
    if (self.m_TiledID ~= tiledID) then
        playSpriteAnimation(self.m_UnitSprite, tiledID, "normal")
    end
end

--------------------------------------------------------------------------------
-- The unit state.
--------------------------------------------------------------------------------
local function updateUnitState(self, state)
    if (self.m_State ~= state) then
        if (state == "idle") then
            self:setColor(COLOR_IDLE)
        elseif (state == "actioned") then
            self:setColor(COLOR_ACTIONED)
        end
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

local function updateStateIndicator(self, unit)
    local frames = {}
    frames[#frames + 1] = getSkillIndicatorFrame(    unit)
    frames[#frames + 1] = getLevelIndicatorFrame(    unit)
    frames[#frames + 1] = getFuelIndicatorFrame(     unit)
    frames[#frames + 1] = getAmmoIndicatorFrame(     unit)
    frames[#frames + 1] = getSubmergedIndicatorFrame(unit)
    frames[#frames + 1] = getCaptureIndicatorFrame(  unit)
    frames[#frames + 1] = getBuildIndicatorFrame(    unit)
    frames[#frames + 1] = getLoadIndicatorFrame(     unit)
    frames[#frames + 1] = getMaterialIndicatorFrame( unit)

    local indicator = self.m_StateIndicator
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
    self.m_IsShowingNormalAnimation = true

    initWithUnitSprite(    self, createUnitSprite())
    initWithHpIndicator(   self, createHpIndicator())
    initWithStateIndicator(self, createStateIndicator())

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewUnit:updateWithModelUnit(unit)
    local tiledID = unit:getTiledId()
    local state   = unit:getState()
    updateUnitSprite(    self,               tiledID)
    updateUnitState(     self,               state)
    updateHpIndicator(   self.m_HpIndicator, unit:getNormalizedCurrentHP())
    updateStateIndicator(self,               unit)

    self.m_TiledID     = tiledID
    self.m_State       = state

    return self
end

function ViewUnit:showNormalAnimation()
    if (not self.m_IsShowingNormalAnimation) then
        self.m_UnitSprite:setFlippedX(false)
        playSpriteAnimation(self.m_UnitSprite, self.m_TiledID, "normal")

        self.m_IsShowingNormalAnimation = true
    end

    return self
end

function ViewUnit:showMovingAnimation()
    if (self.m_IsShowingNormalAnimation) then
        playSpriteAnimation(self.m_UnitSprite, self.m_TiledID, "moving")

        self.m_IsShowingNormalAnimation = false
    end

    return self
end

function ViewUnit:moveAlongPath(path, callbackOnFinish)
    self:setVisible(true)
        :showMovingAnimation()
        :setPosition(GridIndexFunctions.toPosition(path[1]))
        :runAction(createActionMoveAlongPath(self, path, callbackOnFinish))

    return self
end

return ViewUnit
