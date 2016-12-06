
local ViewReplayController = class("ViewReplayController", cc.Node)

local BUTTON_WIDTH      = 75
local BUTTON_HEIGHT     = 75
local BUTTON_OPACITY    = 200
local BUTTON_ZOOM_SCALE = -0.05
local BUTTON_CAPINSETS  = {x = 4, y = 6, width = 1, height = 1}

local DISPLAY_WIDTH            = display.width
local DISPLAY_HEIGHT           = display.height
local TILE_INFO_HEIGHT         = 130
local MONEY_ENERGY_INFO_HEIGHT = 93
local REPLAY_CONTROLLER_HEIGHT = DISPLAY_HEIGHT - TILE_INFO_HEIGHT - MONEY_ENERGY_INFO_HEIGHT - 20
local BUTTON_INTERVAL_HEIGHT   = (REPLAY_CONTROLLER_HEIGHT - BUTTON_HEIGHT * 3) / 4

local BUTTON_PLAY_LEFT_POS_X           = 10
local BUTTON_PLAY_LEFT_POS_Y           = 10 + TILE_INFO_HEIGHT + BUTTON_INTERVAL_HEIGHT
local BUTTON_PLAY_RIGHT_POS_X          = DISPLAY_WIDTH - 10 - BUTTON_WIDTH
local BUTTON_PLAY_RIGHT_POS_Y          = BUTTON_PLAY_LEFT_POS_Y
local BUTTON_PAUSE_LEFT_POS_X          = BUTTON_PLAY_LEFT_POS_X
local BUTTON_PAUSE_LEFT_POS_Y          = BUTTON_PLAY_LEFT_POS_Y
local BUTTON_PAUSE_RIGHT_POS_X         = BUTTON_PLAY_RIGHT_POS_X
local BUTTON_PAUSE_RIGHT_POS_Y         = BUTTON_PLAY_RIGHT_POS_Y
local BUTTON_NEXT_TURN_LEFT_POS_X      = BUTTON_PLAY_LEFT_POS_X
local BUTTON_NEXT_TURN_LEFT_POS_Y      = BUTTON_PLAY_LEFT_POS_Y + BUTTON_HEIGHT + BUTTON_INTERVAL_HEIGHT
local BUTTON_NEXT_TURN_RIGHT_POS_X     = BUTTON_PLAY_RIGHT_POS_X
local BUTTON_NEXT_TURN_RIGHT_POS_Y     = BUTTON_NEXT_TURN_LEFT_POS_Y
local BUTTON_PREVIOUS_TURN_LEFT_POS_X  = BUTTON_NEXT_TURN_LEFT_POS_X
local BUTTON_PREVIOUS_TURN_LEFT_POS_Y  = BUTTON_NEXT_TURN_LEFT_POS_Y + BUTTON_HEIGHT + BUTTON_INTERVAL_HEIGHT
local BUTTON_PREVIOUS_TURN_RIGHT_POS_X = BUTTON_NEXT_TURN_RIGHT_POS_X
local BUTTON_PREVIOUS_TURN_RIGHT_POS_Y = BUTTON_PREVIOUS_TURN_LEFT_POS_Y

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function moveToLeftSide(self)
    self.m_ButtonNextTurn    :setPosition(BUTTON_NEXT_TURN_LEFT_POS_X,     BUTTON_NEXT_TURN_LEFT_POS_Y)
    self.m_ButtonPreviousTurn:setPosition(BUTTON_PREVIOUS_TURN_LEFT_POS_X, BUTTON_PREVIOUS_TURN_LEFT_POS_Y)
    self.m_ButtonPlay        :setPosition(BUTTON_PLAY_LEFT_POS_X,          BUTTON_PLAY_LEFT_POS_Y)
    self.m_ButtonPause       :setPosition(BUTTON_PAUSE_LEFT_POS_X,         BUTTON_PAUSE_LEFT_POS_Y)
end

local function moveToRightSide(self)
    self.m_ButtonNextTurn    :setPosition(BUTTON_NEXT_TURN_RIGHT_POS_X,     BUTTON_NEXT_TURN_RIGHT_POS_Y)
    self.m_ButtonPreviousTurn:setPosition(BUTTON_PREVIOUS_TURN_RIGHT_POS_X, BUTTON_PREVIOUS_TURN_RIGHT_POS_Y)
    self.m_ButtonPlay        :setPosition(BUTTON_PLAY_RIGHT_POS_X,          BUTTON_PLAY_RIGHT_POS_Y)
    self.m_ButtonPause       :setPosition(BUTTON_PAUSE_RIGHT_POS_X,         BUTTON_PAUSE_RIGHT_POS_Y)
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function createButton(posX, posY, spriteFrameName)
    local button = ccui.Button:create()
    button:loadTextureNormal("c03_t01_s01_f01.png", ccui.TextureResType.plistType)
        :ignoreAnchorPointForPosition(true)
        :setPosition(posX, posY)

        :setScale9Enabled(true)
        :setCapInsets(BUTTON_CAPINSETS)
        :setContentSize(BUTTON_WIDTH, BUTTON_HEIGHT)

        :setZoomScale(BUTTON_ZOOM_SCALE)
        :setOpacity(BUTTON_OPACITY)
        :setCascadeOpacityEnabled(true)
        :setCascadeColorEnabled(true)

    button:getRendererNormal():setCascadeOpacityEnabled(true)
        :setCascadeColorEnabled(true)

    local sprite = cc.Sprite:createWithSpriteFrameName(spriteFrameName)
    sprite:setScale(0.75)
        :ignoreAnchorPointForPosition(true)
        :setPosition(1, 1)

    button:getRendererNormal():addChild(sprite)

    return button
end

local function initButtonPreviousTurn(self)
    local button = createButton(BUTTON_PREVIOUS_TURN_RIGHT_POS_X, BUTTON_PREVIOUS_TURN_RIGHT_POS_Y, "c03_t02_s04_f01.png")
    button:addTouchEventListener(function(sender, eventType)
        if ((eventType == ccui.TouchEventType.ended) and (self.m_Model)) then
            self.m_Model:onButtonPreviousTurnTouched()
        end
    end)

    self.m_ButtonPreviousTurn = button
    self:addChild(button)
end

local function initButtonNextTurn(self)
    local button = createButton(BUTTON_NEXT_TURN_RIGHT_POS_X, BUTTON_NEXT_TURN_RIGHT_POS_Y, "c03_t02_s03_f01.png")
    button:addTouchEventListener(function(sender, eventType)
        if ((eventType == ccui.TouchEventType.ended) and (self.m_Model)) then
            self.m_Model:onButtonNextTurnTouched()
        end
    end)

    self.m_ButtonNextTurn = button
    self:addChild(button)
end

local function initButtonPlay(self)
    local button = createButton(BUTTON_PLAY_RIGHT_POS_X, BUTTON_PLAY_RIGHT_POS_Y, "c03_t02_s01_f01.png")
    button:addTouchEventListener(function(sender, eventType)
        if ((eventType == ccui.TouchEventType.ended) and (self.m_Model)) then
            self.m_Model:onButtonPlayTouched()
        end
    end)

    self.m_ButtonPlay = button
    self:addChild(button)
end

local function initButtonPause(self)
    local button = createButton(BUTTON_PAUSE_RIGHT_POS_X, BUTTON_PAUSE_RIGHT_POS_Y, "c03_t02_s02_f01.png")
    button:setVisible(false)
        :addTouchEventListener(function(sender, eventType)
            if ((eventType == ccui.TouchEventType.ended) and (self.m_Model)) then
                self.m_Model:onButtonPauseTouched()
            end
        end)

    self.m_ButtonPause = button
    self:addChild(button)
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewReplayController:ctor(param)
    initButtonPreviousTurn(self)
    initButtonNextTurn(    self)
    initButtonPlay(        self)
    initButtonPause(       self)

    self:ignoreAnchorPointForPosition(true)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewReplayController:adjustPositionOnTouch(touch)
    if (touch:getLocation().x < DISPLAY_WIDTH / 2) then
        moveToRightSide(self)
    else
        moveToLeftSide(self)
    end

    return self
end

function ViewReplayController:setButtonPreviousTurnEnabled(enabled)
    self.m_ButtonPreviousTurn:setEnabled(enabled)

    return self
end

function ViewReplayController:setButtonNextTurnEnabled(enabled)
    self.m_ButtonPreviousTurn:setEnabled(enabled)

    return self
end

function ViewReplayController:setButtonPlayEnabled(enabled)
    self.m_ButtonPlay:setEnabled(enabled)

    return self
end

function ViewReplayController:setButtonPauseEnabled(enabled)
    self.m_ButtonPause:setEnabled(enabled)

    return self
end

function ViewReplayController:setButtonPlayVisible(visible)
    self.m_ButtonPlay:setVisible(visible)

    return self
end

function ViewReplayController:setButtonPauseVisible(visible)
    self.m_ButtonPause:setVisible(visible)

    return self
end

return ViewReplayController
