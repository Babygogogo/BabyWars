
local ViewWarHUD = class("ViewWarHUD", cc.Node)

local CONFIRM_BOX_Z_ORDER       = 99
local BEGIN_TURN_EFFECT_Z_ORDER = 3
local WAR_COMMAND_MENU_Z_ORDER  = 2
local TILE_DETAIL_Z_ORDER       = 1
local UNIT_DETAIL_Z_ORDER       = 1
local BATTLE_INFO_Z_ORDER       = 0
local ACTION_MENU_Z_ORDER       = 0

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
local BEGIN_TURN_EFFECT_MOVEOUT_DURATION = 0.5

local BEGIN_TURN_EFFECT_FONT_NAME          = "res/fonts/msyhbd.ttc"
local BEGIN_TURN_EFFECT_FONT_COLOR         = {r = 255, g = 255, b = 255}
local BEGIN_TURN_EFFECT_FONT_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local BEGIN_TURN_EFFECT_FONT_OUTLINE_WIDTH = math.ceil(BEGIN_TURN_EFFECT_FONT_SIZE / 15)

--------------------------------------------------------------------------------
-- The begin turn effect.
--------------------------------------------------------------------------------
local function setBeginTurnEffectEnabled(effect, enabled)
    effect:setVisible(enabled)
    effect.m_TouchListener:setEnabled(enabled)
end

local function createBeginTurnEffectMoveInAction(effect)
    local moveAction = cc.EaseSineOut:create(cc.MoveTo:create(BEGIN_TURN_EFFECT_MOVEIN_DURATION, {x = BEGIN_TURN_EFFECT_MIDDLE_X, y = BEGIN_TURN_EFFECT_MIDDLE_Y}))
    local callback = cc.CallFunc:create(function()
            effect.m_IsMoveInFinished = true
        end)

    return cc.Sequence:create(moveAction, callback)
end

local function createBeginTurnEffectMoveOutAction(effect)
    local moveAction = cc.EaseSineIn:create(cc.MoveTo:create(BEGIN_TURN_EFFECT_MOVEOUT_DURATION, {x = BEGIN_TURN_EFFECT_END_X, y = BEGIN_TURN_EFFECT_END_Y}))
    local callback = cc.CallFunc:create(function()
            setBeginTurnEffectEnabled(effect, false)
            effect.m_IsMoveInFinished = false
            effect.m_CallbackOnDisappear()
        end)

    return cc.Sequence:create(moveAction, callback)
end

local function createBeginTurnEffectBackground()
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", {x = 4, y = 5, width = 1, height = 1})
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
            effect.m_IsMoveOutStarted = true
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

local function initWithBeginTurnEffect(view, effect)
    view.m_BeginTurnEffect = effect
    setBeginTurnEffectEnabled(effect, false)
    view:addChild(effect, BEGIN_TURN_EFFECT_Z_ORDER)
end

local function setBeginTurnEffectLabel(effect, turnIndex, playerName)
    effect.m_Label:setString("Turn:     "  .. turnIndex ..
                             "\nPlayer:  " .. playerName ..
                             "\nFight!")
end

--------------------------------------------------------------------------------
-- The touch listener.
--------------------------------------------------------------------------------
local function createTouchListener(self)
    local touchListener = cc.EventListenerTouchOneByOne:create()

    local function onTouchBegan(touch, event)
        self.m_ViewMoneyEnergyInfo:adjustPositionOnTouch(touch)
        self.m_ViewActionMenu:adjustPositionOnTouch(touch)
        self.m_ViewTileInfo:adjustPositionOnTouch(touch)
        self.m_ViewUnitInfo:adjustPositionOnTouch(touch)
        self.m_ViewBattleInfo:adjustPositionOnTouch(touch)

        return true
    end

    local function onTouchMoved(touch, event)
        self.m_ViewMoneyEnergyInfo:adjustPositionOnTouch(touch)
        self.m_ViewActionMenu:adjustPositionOnTouch(touch)
        self.m_ViewTileInfo:adjustPositionOnTouch(touch)
        self.m_ViewUnitInfo:adjustPositionOnTouch(touch)
        self.m_ViewBattleInfo:adjustPositionOnTouch(touch)
    end

    local function onTouchCancelled(touch, event)
    end

    local function onTouchEnded(touch, event)
        self.m_ViewMoneyEnergyInfo:adjustPositionOnTouch(touch)
        self.m_ViewActionMenu:adjustPositionOnTouch(touch)
        self.m_ViewTileInfo:adjustPositionOnTouch(touch)
        self.m_ViewUnitInfo:adjustPositionOnTouch(touch)
        self.m_ViewBattleInfo:adjustPositionOnTouch(touch)
    end

    touchListener:registerScriptHandler(onTouchBegan,     cc.Handler.EVENT_TOUCH_BEGAN)
    touchListener:registerScriptHandler(onTouchMoved,     cc.Handler.EVENT_TOUCH_MOVED)
    touchListener:registerScriptHandler(onTouchCancelled, cc.Handler.EVENT_TOUCH_CANCELLED)
    touchListener:registerScriptHandler(onTouchEnded,     cc.Handler.EVENT_TOUCH_ENDED)

    return touchListener
end

local function initWithTouchListener(self, listener)
    self.m_TouchListener = listener
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewWarHUD:ctor(param)
    initWithBeginTurnEffect(self, createBeginTurnEffect())
    initWithTouchListener(  self, createTouchListener(self))

    return self
end

function ViewWarHUD:setViewConfirmBox(view)
    if (self.m_ViewConfirmBox) then
        if (self.m_ViewConfirmBox == view) then
            return self
        else
            self:removeChild(self.m_ViewConfirmBox)
        end
    end

    self.m_ViewConfirmBox = view
    self:addChild(view, CONFIRM_BOX_Z_ORDER)

    return self
end

function ViewWarHUD:setViewMoneyEnergyInfo(view)
    if (self.m_ViewMoneyEnergyInfo) then
        if (self.m_ViewMoneyEnergyInfo == view) then
            return self
        else
            self:removeChild(self.m_ViewMoneyEnergyInfo)
        end
    end

    self.m_ViewMoneyEnergyInfo = view
    self:addChild(view)

    return self
end

function ViewWarHUD:setViewWarCommandMenu(view)
    if (self.m_ViewWarCommandMenu) then
        if (self.m_ViewWarCommandMenu == view) then
            return self
        else
            self:removeChild(self.m_ViewWarCommandMenu)
        end
    end

    self.m_ViewWarCommandMenu = view
    self:addChild(view, WAR_COMMAND_MENU_Z_ORDER)

    return self
end

function ViewWarHUD:setViewActionMenu(view)
    if (self.m_ViewActionMenu) then
        if (self.m_ViewActionMenu == view) then
            return self
        else
            self:removeChild(self.m_ViewActionMenu)
        end
    end

    self.m_ViewActionMenu = view
    self:addChild(view, ACTION_MENU_Z_ORDER)

    return self
end

function ViewWarHUD:setViewTileInfo(view)
    if (self.m_ViewTileInfo) then
        if (self.m_ViewTileInfo == view) then
            return self
        else
            self:removeChild(self.m_ViewTileInfo)
        end
    end

    self.m_ViewTileInfo = view
    self:addChild(view)

    return self
end

function ViewWarHUD:setViewTileDetail(view)
    if (self.m_ViewTileDetail) then
        if (self.m_ViewTileDetail == view) then
            return self
        else
            self:removeChild(self.m_ViewTileDetail)
        end
    end

    view:setEnabled(false)
    self.m_ViewTileDetail = view
    self:addChild(view, TILE_DETAIL_Z_ORDER)

    return self
end

function ViewWarHUD:setViewUnitInfo(view)
    if (self.m_ViewUnitInfo) then
        if (self.m_ViewUnitInfo == view) then
            return self
        else
            self:removeChild(self.m_ViewUnitInfo)
        end
    end

    self.m_ViewUnitInfo = view
    self:addChild(view)

    return self
end

function ViewWarHUD:setViewUnitDetail(view)
    if (self.m_ViewUnitDetail) then
        if (self.m_ViewUnitDetail == view) then
            return self
        else
            self:removeChild(self.m_ViewUnitDetail)
        end
    end

    view:setEnabled(false)
    self.m_ViewUnitDetail = view
    self:addChild(view, UNIT_DETAIL_Z_ORDER)

    return self
end

function ViewWarHUD:setViewBattleInfo(view)
    if (self.m_ViewBattleInfo) then
        if (self.m_ViewBattleInfo == view) then
            return self
        else
            self:removeChild(self.m_ViewBattleInfo)
        end
    end

    self.m_ViewBattleInfo = view
    self:addChild(view, BATTLE_INFO_Z_ORDER)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewWarHUD:showBeginTurnEffect(turnIndex, playerName, callbackOnDisappear)
    local effect = self.m_BeginTurnEffect
    effect.m_CallbackOnDisappear = callbackOnDisappear
    effect.m_IsMoveOutStarted    = false

    setBeginTurnEffectEnabled(effect, true)
    setBeginTurnEffectLabel(effect, turnIndex, playerName)
    effect:setPosition(BEGIN_TURN_EFFECT_START_X, BEGIN_TURN_EFFECT_START_Y)
        :runAction(createBeginTurnEffectMoveInAction(effect))

    return self
end

return ViewWarHUD
