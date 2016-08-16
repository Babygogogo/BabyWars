
local ViewMoneyEnergyInfo = class("ViewMoneyEnergyInfo", cc.Node)

local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")

local getLocalizedText = LocalizationFunctions.getLocalizedText

local LABEL_Z_ORDER      = 1
local BACKGROUND_Z_ORDER = 0

local FONT_SIZE   = 20
local LINE_HEIGHT = FONT_SIZE / 5 * 8

local BACKGROUND_WIDTH     = 210
local BACKGROUND_HEIGHT    = LINE_HEIGHT * 3 + 8
local BACKGROUND_CAPINSETS = {x = 4, y = 6, width = 1, height = 1}

local LABEL_ENERGY_WIDTH  = display.width
local LABEL_ENERGY_HEIGHT = LINE_HEIGHT
local LABEL_ENERGY_POS_X  = 7
local LABEL_ENERGY_POS_Y  = 5

local LABEL_FUND_WIDTH  = display.width
local LABEL_FUND_HEIGHT = LINE_HEIGHT
local LABEL_FUND_POS_X  = LABEL_ENERGY_POS_X
local LABEL_FUND_POS_Y  = LABEL_ENERGY_POS_Y + LABEL_ENERGY_HEIGHT

local LABEL_PLAYER_WIDTH  = display.width
local LABEL_PLAYER_HEIGHT = LINE_HEIGHT
local LABEL_PLAYER_POS_X  = LABEL_ENERGY_POS_X
local LABEL_PLAYER_POS_Y  = LABEL_FUND_POS_Y + LABEL_FUND_HEIGHT

local FONT_NAME          = "res/fonts/msyhbd.ttc"
local FONT_COLOR         = {r = 255, g = 255, b = 255}
local FONT_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local FONT_OUTLINE_WIDTH = 2

local LEFT_POSITION_X  = 10
local LEFT_POSITION_Y  = display.height - BACKGROUND_HEIGHT - 10
local RIGHT_POSITION_X = display.width - BACKGROUND_WIDTH - 10
local RIGHT_POSITION_Y = LEFT_POSITION_Y

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createLabel(posX, posY, width, height)
    local label = cc.Label:createWithTTF("", FONT_NAME, FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(posX, posY)

        :setDimensions(width, height)
        :setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM)

        :setTextColor(FONT_COLOR)
        :enableOutline(FONT_OUTLINE_COLOR, FONT_OUTLINE_WIDTH)

    return label
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
    background:loadTextureNormal("c03_t01_s01_f01.png", ccui.TextureResType.plistType)
        :ignoreAnchorPointForPosition(true)

        :setScale9Enabled(true)
        :setCapInsets(BACKGROUND_CAPINSETS)
        :setContentSize(BACKGROUND_WIDTH, BACKGROUND_HEIGHT)

        :setZoomScale(-0.05)
        :setOpacity(200)

        :addTouchEventListener(function(sender, eventType)
            if ((eventType == ccui.TouchEventType.ended) and (self.m_Model)) then
                self.m_Model:onPlayerTouch()
            end
        end)

    self.m_Background = background
    self:addChild(background, BACKGROUND_Z_ORDER)
end

local function initLabelPlayer(self)
    local label = createLabel(LABEL_PLAYER_POS_X, LABEL_PLAYER_POS_Y, LABEL_PLAYER_WIDTH, LABEL_PLAYER_HEIGHT)

    self.m_LabelPlayer = label
    self.m_Background:getRendererNormal():addChild(label, LABEL_Z_ORDER)
end

local function initLabelFund(self)
    local label = createLabel(LABEL_FUND_POS_X, LABEL_FUND_POS_Y, LABEL_FUND_WIDTH, LABEL_FUND_HEIGHT)

    self.m_LabelFund = label
    self.m_Background:getRendererNormal():addChild(label, LABEL_Z_ORDER)
end

local function initLabelEnergy(self)
    local label = createLabel(LABEL_ENERGY_POS_X, LABEL_ENERGY_POS_Y, LABEL_ENERGY_WIDTH, LABEL_ENERGY_HEIGHT)

    self.m_LabelEnergy = label
    self.m_Background:getRendererNormal():addChild(label, LABEL_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewMoneyEnergyInfo:ctor(param)
    initBackground( self)
    initLabelPlayer(self)
    initLabelFund(  self)
    initLabelEnergy(self)

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

function ViewMoneyEnergyInfo:updateWithModelPlayer(modelPlayer)
    self.m_LabelPlayer:setString(getLocalizedText(62, modelPlayer:getNickname()))
    self.m_LabelFund  :setString(getLocalizedText(63, modelPlayer:getFund()))

    local energy, req1, req2 = modelPlayer:getEnergy()
    self.m_LabelEnergy:setString(getLocalizedText(64, string.format("%.2f/%s/%s",
        energy, "" .. (req1 or "--"), "" .. (req2 or "--"))))

    return self
end

return ViewMoneyEnergyInfo
