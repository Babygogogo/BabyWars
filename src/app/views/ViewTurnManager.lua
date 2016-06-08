
local ViewTurnManager = class("ViewTurnManager", cc.Node)

local BEGIN_TURN_EFFECT_Z_ORDER = 1

local BEGIN_TURN_EFFECT_FONT_SIZE   = 40
local BEGIN_TURN_EFFECT_LINE_HEIGHT = BEGIN_TURN_EFFECT_FONT_SIZE / 5 * 8

local BEGIN_TURN_EFFECT_WIDTH    = 400
local BEGIN_TURN_EFFECT_HEIGHT   = BEGIN_TURN_EFFECT_LINE_HEIGHT * 3 + 5

local BEGIN_TURN_EFFECT_START_X  = display.width
local BEGIN_TURN_EFFECT_START_Y  = (display.height - BEGIN_TURN_EFFECT_HEIGHT) / 2
local BEGIN_TURN_EFFECT_MIDDLE_X = (display.width - BEGIN_TURN_EFFECT_WIDTH) / 2
local BEGIN_TURN_EFFECT_MIDDLE_Y = BEGIN_TURN_EFFECT_START_Y
local BEGIN_TURN_EFFECT_END_X    = - BEGIN_TURN_EFFECT_WIDTH
local BEGIN_TURN_EFFECT_END_Y    = BEGIN_TURN_EFFECT_START_Y

local BEGIN_TURN_EFFECT_MOVEIN_DURATION  = 0.5
local BEGIN_TURN_EFFECT_STAY_DURATION    = 3
local BEGIN_TURN_EFFECT_MOVEOUT_DURATION = 0.5

local BEGIN_TURN_EFFECT_FONT_NAME          = "res/fonts/msyhbd.ttc"
local BEGIN_TURN_EFFECT_FONT_COLOR         = {r = 255, g = 255, b = 255}
local BEGIN_TURN_EFFECT_FONT_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local BEGIN_TURN_EFFECT_FONT_OUTLINE_WIDTH = math.ceil(BEGIN_TURN_EFFECT_FONT_SIZE / 15)

--------------------------------------------------------------------------------
-- The composition begin turn effect.
--------------------------------------------------------------------------------
local function setBeginTurnEffectEnabled(effect, enabled)
    effect:setVisible(enabled)
    effect.m_TouchListener:setEnabled(enabled)
end

local function createBeginTurnEffectMoveOutAction(effect)
    local callbackBeforeMoveOut = cc.CallFunc:create(function()
        effect.m_IsMoveOutStarted = true
    end)
    local moveOut = cc.EaseSineIn:create(cc.MoveTo:create(BEGIN_TURN_EFFECT_MOVEOUT_DURATION, {x = BEGIN_TURN_EFFECT_END_X, y = BEGIN_TURN_EFFECT_END_Y}))
    local callbackAfterMoveOut = cc.CallFunc:create(function()
        setBeginTurnEffectEnabled(effect, false)
        effect.m_CallbackOnDisappear()
    end)

    return cc.Sequence:create(callbackBeforeMoveOut, moveOut, callbackAfterMoveOut)
end

local function createBeginTurnEffectMoveInAction(effect)
    local moveIn = cc.EaseSineOut:create(cc.MoveTo:create(BEGIN_TURN_EFFECT_MOVEIN_DURATION, {x = BEGIN_TURN_EFFECT_MIDDLE_X, y = BEGIN_TURN_EFFECT_MIDDLE_Y}))
    local callbackAfterMoveIn = cc.CallFunc:create(function()
        effect.m_IsMoveInFinished = true
    end)
    local delay = cc.DelayTime:create(BEGIN_TURN_EFFECT_STAY_DURATION)
    local callbackAfterDelay = cc.CallFunc:create(function()
        if (not effect.m_IsMoveOutStarted) then
            effect:runAction(createBeginTurnEffectMoveOutAction(effect))
        end
    end)

    return cc.Sequence:create(moveIn, callbackAfterMoveIn, delay, callbackAfterDelay)
end

local function createBeginTurnEffectBackground()
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", {x = 4, y = 6, width = 1, height = 1})
    background:ignoreAnchorPointForPosition(true)
        :setContentSize(BEGIN_TURN_EFFECT_WIDTH, BEGIN_TURN_EFFECT_HEIGHT)

    return background
end

local function createBeginTurnEffectLabel()
    local label = cc.Label:createWithTTF("", BEGIN_TURN_EFFECT_FONT_NAME, BEGIN_TURN_EFFECT_FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(5, 5)
        :setDimensions(BEGIN_TURN_EFFECT_WIDTH - 10, BEGIN_TURN_EFFECT_HEIGHT - 10)

        :setTextColor(BEGIN_TURN_EFFECT_FONT_COLOR)
        :enableOutline(BEGIN_TURN_EFFECT_FONT_OUTLINE_COLOR, BEGIN_TURN_EFFECT_FONT_OUTLINE_WIDTH)

    return label
end

local function createBeginTurnEffectTouchListener(effect)
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(function()
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)

    listener:registerScriptHandler(function(touch, event)
        if ((effect.m_IsMoveInFinished) and (not effect.m_IsMoveOutStarted)) then
            effect:runAction(createBeginTurnEffectMoveOutAction(effect))
        end
    end, cc.Handler.EVENT_TOUCH_ENDED)

    return listener
end

local function createBeginTurnEffect()
    local effect = cc.Node:create()
    effect:ignoreAnchorPointForPosition(true)
        :setPosition(BEGIN_TURN_EFFECT_START_X, BEGIN_TURN_EFFECT_START_Y)

    local background    = createBeginTurnEffectBackground()
    local label         = createBeginTurnEffectLabel()
    local touchListener = createBeginTurnEffectTouchListener(effect)

    effect:setOpacity(200)
        :setCascadeOpacityEnabled(true)

        :addChild(background)
        :addChild(label)
        :getEventDispatcher():addEventListenerWithSceneGraphPriority(touchListener, effect)

    effect.m_Background    = background
    effect.m_Label         = label
    effect.m_TouchListener = touchListener

    return effect
end

local function initBeginTurnEffect(self)
    local effect = createBeginTurnEffect()

    self.m_BeginTurnEffect = effect
    setBeginTurnEffectEnabled(effect, false)
    self:addChild(effect, BEGIN_TURN_EFFECT_Z_ORDER)
end

local function setBeginTurnEffectLabel(effect, turnIndex, playerName)
    effect.m_Label:setString("Turn:     "  .. turnIndex ..
                             "\nPlayer:  " .. playerName ..
                             "\nFight!")
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewTurnManager:ctor()
    initBeginTurnEffect(self)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewTurnManager:showBeginTurnEffect(turnIndex, playerName, callbackOnDisappear)
    local effect = self.m_BeginTurnEffect
    effect.m_CallbackOnDisappear = callbackOnDisappear
    effect.m_IsMoveInFinished    = false
    effect.m_IsMoveOutStarted    = false

    setBeginTurnEffectEnabled(effect, true)
    setBeginTurnEffectLabel(effect, turnIndex, playerName)
    effect:setPosition(BEGIN_TURN_EFFECT_START_X, BEGIN_TURN_EFFECT_START_Y)
        :runAction(createBeginTurnEffectMoveInAction(effect))

    return self
end

return ViewTurnManager
