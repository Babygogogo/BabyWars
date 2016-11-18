
local ViewMoneyEnergyInfo = class("ViewMoneyEnergyInfo", cc.Node)

local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")
local SingletonGetters      = require("src.app.utilities.SingletonGetters")

local getLocalizedText       = LocalizationFunctions.getLocalizedText
local getModelFogMap         = SingletonGetters.getModelFogMap
local getPlayerIndexLoggedIn = SingletonGetters.getPlayerIndexLoggedIn

local LABEL_Z_ORDER      = 1
local BACKGROUND_Z_ORDER = 0

local FONT_SIZE          = 18
local FONT_NAME          = "res/fonts/msyhbd.ttc"
local FONT_COLOR         = {r = 255, g = 255, b = 255}
local FONT_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local FONT_OUTLINE_WIDTH = 2

local BACKGROUND_WIDTH     = 210
local BACKGROUND_HEIGHT    = 93
local BACKGROUND_CAPINSETS = {x = 4, y = 6, width = 1, height = 1}

local LABEL_MAX_WIDTH  = BACKGROUND_WIDTH - 10
local LABEL_MAX_HEIGHT = BACKGROUND_HEIGHT - 8
local LABEL_POS_X      = 5
local LABEL_POS_Y      = 5

local LEFT_POSITION_X  = 10
local LEFT_POSITION_Y  = display.height - BACKGROUND_HEIGHT - 10
local RIGHT_POSITION_X = display.width - BACKGROUND_WIDTH - 10
local RIGHT_POSITION_Y = LEFT_POSITION_Y

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function resetBackground(background, playerIndex)
    background:loadTextureNormal("c03_t01_s0" .. playerIndex .. "_f01.png", ccui.TextureResType.plistType)
        :ignoreAnchorPointForPosition(true)

        :setScale9Enabled(true)
        :setCapInsets(BACKGROUND_CAPINSETS)
        :setContentSize(BACKGROUND_WIDTH, BACKGROUND_HEIGHT)

        :setZoomScale(-0.05)
        :setOpacity(200)
end

--------------------------------------------------------------------------------
-- The functions that adjust the position of the view.
--------------------------------------------------------------------------------
local function moveToLeftSide(self)
    self:setPosition(LEFT_POSITION_X, LEFT_POSITION_Y)
end

local function moveToRightSide(self)
    self:setPosition(RIGHT_POSITION_X, RIGHT_POSITION_Y)
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initBackground(self)
    local background = ccui.Button:create()
    background:addTouchEventListener(function(sender, eventType)
            if ((eventType == ccui.TouchEventType.ended) and (self.m_Model)) then
                self.m_Model:onPlayerTouch()
            end
        end)
    resetBackground(background, 1)

    self.m_Background = background
    self:addChild(background, BACKGROUND_Z_ORDER)
end

local function initLabel(self)
    local label = cc.Label:createWithTTF("", FONT_NAME, FONT_SIZE)
    label:setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)
        :setPosition(LABEL_POS_X, LABEL_POS_Y)

        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
        :setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM)

        :setTextColor(FONT_COLOR)
        :enableOutline(FONT_OUTLINE_COLOR, FONT_OUTLINE_WIDTH)

    self.m_Label = label
    self.m_Background:getRendererNormal():addChild(label, LABEL_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewMoneyEnergyInfo:ctor(param)
    initBackground(self)
    initLabel(     self)

    self:ignoreAnchorPointForPosition(true)
    moveToRightSide(self)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewMoneyEnergyInfo:adjustPositionOnTouch(touch)
    local touchLocation = touch:getLocation()
    if (touchLocation.y > display.height / 2) then
        if (touchLocation.x <= display.width / 2) then
            moveToRightSide(self)
        else
            moveToLeftSide(self)
        end
    end

    return self
end

function ViewMoneyEnergyInfo:updateWithModelPlayer(modelPlayer, playerIndex)
    local label              = self.m_Label
    local energy, req1, req2 = modelPlayer:getEnergy()
    label:setString(string.format("%s\n%s\n%s",
        getLocalizedText(62, modelPlayer:getNickname()),
        getLocalizedText(63, (getModelFogMap():isFogOfWarCurrently() and (playerIndex ~= getPlayerIndexLoggedIn())) and ("--") or (modelPlayer:getFund())),
        getLocalizedText(64, string.format("%.2f/%s/%s", energy, "" .. (req1 or "--"), "" .. (req2 or "--")))
    ))
    label:setScaleX(math.min(1, LABEL_MAX_WIDTH / label:getContentSize().width))

    return self
end

function ViewMoneyEnergyInfo:updateWithPlayerIndex(playerIndex)
    resetBackground(self.m_Background, playerIndex)

    return self
end

return ViewMoneyEnergyInfo
