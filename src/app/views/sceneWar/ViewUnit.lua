
local ViewUnit = class("ViewUnit", cc.Node)

local AnimationLoader       = requireBW("src.app.utilities.AnimationLoader")
local GameConstantFunctions = requireBW("src.app.utilities.GameConstantFunctions")
local GridIndexFunctions    = requireBW("src.app.utilities.GridIndexFunctions")
local SingletonGetters      = requireBW("src.app.utilities.SingletonGetters")
local VisibilityFunctions   = requireBW("src.app.utilities.VisibilityFunctions")

local getModelFogMap           = SingletonGetters.getModelFogMap
local getModelMapCursor        = SingletonGetters.getModelMapCursor
local getModelPlayerManager    = SingletonGetters.getModelPlayerManager
local getPlayerIndexLoggedIn   = SingletonGetters.getPlayerIndexLoggedIn
local getScriptEventDispatcher = SingletonGetters.getScriptEventDispatcher
local isUnitVisible            = VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex

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
local function createStepsForActionMoveAlongPath(self, path, isDiving)
    local modelWar            = self.m_Model:getModelSceneWar()
    local isReplay            = SingletonGetters.isTotalReplay(modelWar)
    local playerIndex         = self.m_Model:getPlayerIndex()
    local playerIndexMod      = playerIndex % 2
    local playerIndexLoggedIn = (not isReplay) and (getPlayerIndexLoggedIn(modelWar)) or (nil)
    local unitType            = self.m_Model:getUnitType()
    local isAlwaysVisible     = (isReplay) or (playerIndex == playerIndexLoggedIn)

    local steps               = {cc.CallFunc:create(function()
        getModelMapCursor(modelWar):setMovableByPlayer(false)
        if (isAlwaysVisible) then
            self:setVisible(true)
        end
    end)}

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

        if (not isAlwaysVisible) then
            if (isDiving) then
                if ((i == #path)                                                                                      and
                    (isUnitVisible(modelWar, path[i], unitType, isDiving, playerIndex, playerIndexLoggedIn))) then
                    steps[#steps + 1] = cc.Show:create()
                else
                    steps[#steps + 1] = cc.Hide:create()
                end
            else
                if ((isUnitVisible(modelWar, path[i - 1], unitType, isDiving, playerIndex, playerIndexLoggedIn))  or
                    (isUnitVisible(modelWar, path[i],     unitType, isDiving, playerIndex, playerIndexLoggedIn))) then
                    steps[#steps + 1] = cc.Show:create()
                else
                    steps[#steps + 1] = cc.Hide:create()
                end
            end
        end

        steps[#steps + 1] = cc.MoveTo:create(MOVE_DURATION_PER_GRID, GridIndexFunctions.toPositionTable(path[i]))
    end

    return steps
end

local function createActionMoveAlongPath(self, path, isDiving, callback)
    local steps = createStepsForActionMoveAlongPath(self, path, isDiving)
    steps[#steps + 1] = cc.CallFunc:create(function()
        getModelMapCursor(self.m_Model:getModelSceneWar()):setMovableByPlayer(true)
        self.m_UnitSprite:setFlippedX(false)
        callback()
    end)

    return cc.Sequence:create(unpack(steps))
end

local function createActionMoveAlongPathAndFocusOnTarget(self, path, isDiving, targetGridIndex, callback)
    local modelWar = self.m_Model:getModelSceneWar()
    local steps         = createStepsForActionMoveAlongPath(self, path, isDiving)
    steps[#steps + 1] = cc.CallFunc:create(function()
        getScriptEventDispatcher(modelWar):dispatchEvent({
            name      = "EvtMapCursorMoved",
            gridIndex = targetGridIndex,
        })
        getModelMapCursor(modelWar):setNormalCursorVisible(false)
            :setTargetCursorVisible(true)
    end)
    steps[#steps + 1] = cc.DelayTime:create(0.5)
    steps[#steps + 1] = cc.CallFunc:create(function()
        getModelMapCursor(modelWar):setMovableByPlayer(true)
            :setNormalCursorVisible(true)
            :setTargetCursorVisible(false)

        self.m_UnitSprite:setFlippedX(false)
        callback()
    end)

    return cc.Sequence:create(unpack(steps))
end

local function getSkillIndicatorFrame(self, unit)
    local playerIndex = unit:getPlayerIndex()
    if (getModelPlayerManager(unit:getModelSceneWar()):getModelPlayer(playerIndex):getModelSkillConfiguration():getActivatingSkillGroupId()) then
        return cc.SpriteFrameCache:getInstance():getSpriteFrame("c02_t99_s07_f0" .. playerIndex .. ".png")
    else
        return nil
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
    if (((unit.isPrimaryWeaponAmmoInShort) and (unit:isPrimaryWeaponAmmoInShort())) or
        ((unit.isFlareAmmoInShort) and (unit:isFlareAmmoInShort())))                then
        return cc.SpriteFrameCache:getInstance():getSpriteFrame("c02_t99_s02_f02.png")
    else
        return nil
    end
end

local function getDiveIndicatorFrame(unit)
    if ((unit.isDiving) and (unit:isDiving())) then
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

local function getLoadIndicatorFrame(self, unit)
    if (not unit.getCurrentLoadCount) then
        return nil
    else
        local modelWar  = unit:getModelSceneWar()
        local loadCount = unit:getCurrentLoadCount()
        if ((not SingletonGetters.isTotalReplay(modelWar)) and (getModelFogMap(modelWar):isFogOfWarCurrently())) then
            if ((not SingletonGetters.getModelPlayerManager(modelWar):isSameTeamIndex(unit:getPlayerIndex(), getPlayerIndexLoggedIn(modelWar))) or (loadCount > 0)) then
                return cc.SpriteFrameCache:getInstance():getSpriteFrame("c02_t99_s06_f0" .. unit:getPlayerIndex() .. ".png")
            else
                return nil
            end
        elseif (loadCount > 0) then
            return cc.SpriteFrameCache:getInstance():getSpriteFrame("c02_t99_s06_f0" .. unit:getPlayerIndex() .. ".png")
        else
            return nil
        end
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
-- The composition elements.
--------------------------------------------------------------------------------
local function initUnitSprite(self)
    local sprite = cc.Sprite:create()
    sprite:ignoreAnchorPointForPosition(true)

    self.m_UnitSprite = sprite
    self:addChild(sprite, UNIT_SPRITE_Z_ORDER)
end

local function initHpIndicator(self)
    local indicator = cc.Sprite:createWithSpriteFrameName("c02_t99_s01_f00.png")
    indicator:ignoreAnchorPointForPosition(true)
        :setPosition(HP_INDICATOR_POSITION_X, HP_INDICATOR_POSITION_Y)
        :setVisible(false)

    self.m_HpIndicator = indicator
    self:addChild(indicator, HP_INDICATOR_Z_ORDER)
end

local function initStateIndicator(self)
    local indicator = cc.Sprite:createWithSpriteFrameName("c02_t99_s02_f01.png")
    indicator:ignoreAnchorPointForPosition(true)
        :setPosition(STATE_INDICATOR_POSITION_X, STATE_INDICATOR_POSITION_Y)
        :setVisible(true)

    self.m_StateIndicator = indicator
    self:addChild(indicator, STATE_INDICATOR_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The functions for updating the composition elements.
--------------------------------------------------------------------------------
local function updateUnitSprite(self, tiledID)
    if (self.m_TiledID ~= tiledID) then
        playSpriteAnimation(self.m_UnitSprite, tiledID, "normal")
    end
end

local function updateUnitState(self, isStateIdle)
    if (self.m_IsStateIdle ~= isStateIdle) then
        if (isStateIdle) then
            self:setColor(COLOR_IDLE)
        else
            self:setColor(COLOR_ACTIONED)
        end
    end
end

local function updateHpIndicator(indicator, hp)
    if ((hp >= 10) or (hp < 0)) then
        indicator:setVisible(false)
    else
        indicator:setVisible(true)
            :setSpriteFrame("c02_t99_s01_f0" .. hp .. ".png")
    end
end

local function updateStateIndicator(self, unit)
    local frames = {}
    frames[#frames + 1] = getSkillIndicatorFrame(   self, unit)
    frames[#frames + 1] = getLevelIndicatorFrame(         unit)
    frames[#frames + 1] = getFuelIndicatorFrame(          unit)
    frames[#frames + 1] = getAmmoIndicatorFrame(          unit)
    frames[#frames + 1] = getDiveIndicatorFrame(          unit)
    frames[#frames + 1] = getCaptureIndicatorFrame(       unit)
    frames[#frames + 1] = getBuildIndicatorFrame(         unit)
    frames[#frames + 1] = getLoadIndicatorFrame(    self, unit)
    frames[#frames + 1] = getMaterialIndicatorFrame(      unit)

    local indicator = self.m_StateIndicator
    indicator:stopAllActions()
    if (#frames == 0) then
        indicator:setVisible(false)
    else
        indicator:setVisible(true)
            :playAnimationForever(display.newAnimation(frames, STATE_INDICATOR_DURATION))
    end
end

local function updateZOrder(self, modelUnit)
    if (modelUnit.getGridIndex) then
        local mapSize = SingletonGetters.getModelTileMap(modelUnit:getModelSceneWar()):getMapSize()
        self:setLocalZOrder(mapSize.height - modelUnit:getGridIndex().y)
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewUnit:ctor()
    self:ignoreAnchorPointForPosition(true)
        :setCascadeColorEnabled(true)
    self.m_IsShowingNormalAnimation = true

    initUnitSprite(    self)
    initHpIndicator(   self)
    initStateIndicator(self)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewUnit:updateWithModelUnit(modelUnit)
    local tiledID     = modelUnit:getTiledId()
    local isStateIdle = modelUnit:isStateIdle()
    updateUnitSprite(    self,               tiledID)
    updateUnitState(     self,               isStateIdle)
    updateHpIndicator(   self.m_HpIndicator, modelUnit:getNormalizedCurrentHP())
    updateStateIndicator(self,               modelUnit)
    updateZOrder(        self,               modelUnit)

    self.m_TiledID     = tiledID
    self.m_IsStateIdle = isStateIdle

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

function ViewUnit:moveAlongPath(path, isDiving, callbackOnFinish)
    self:showMovingAnimation()
        :setPosition(GridIndexFunctions.toPosition(path[1]))
        :runAction(createActionMoveAlongPath(self, path, isDiving, callbackOnFinish))

    return self
end

function ViewUnit:moveAlongPathAndFocusOnTarget(path, isDiving, targetGridIndex, callbackOnFinish)
    self:showMovingAnimation()
        :setPosition(GridIndexFunctions.toPosition(path[1]))
        :runAction(createActionMoveAlongPathAndFocusOnTarget(self, path, isDiving, targetGridIndex, callbackOnFinish))

    return self
end

return ViewUnit
