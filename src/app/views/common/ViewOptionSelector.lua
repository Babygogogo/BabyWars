
local ViewOptionSelector = class("ViewOptionSelector", cc.Node)

local ARROW_LEFT_WIDTH        = 54
local ARROW_LEFT_HEIGHT       = 54
local OPTION_INDICATOR_WIDTH  = 250
local OPTION_INDICATOR_HEIGHT = 60
local TITLE_LABEL_WIDTH       = OPTION_INDICATOR_WIDTH
local TITLE_LABEL_HEIGHT      = 30
local ARROW_RIGHT_WIDTH       = ARROW_LEFT_WIDTH
local ARROW_RIGHT_HEIGHT      = ARROW_LEFT_HEIGHT

local ARROW_LEFT_POS_X       = 0
local ARROW_LEFT_POS_Y       = (OPTION_INDICATOR_HEIGHT - ARROW_LEFT_HEIGHT) / 2
local OPTION_INDICATOR_POS_X = ARROW_LEFT_POS_X + ARROW_LEFT_WIDTH + 8
local OPTION_INDICATOR_POS_Y = 0
local TITLE_LABEL_POS_X      = OPTION_INDICATOR_POS_X
local TITLE_LABEL_POS_Y      = OPTION_INDICATOR_POS_Y + OPTION_INDICATOR_HEIGHT
local ARROW_RIGHT_POS_X      = OPTION_INDICATOR_POS_X + OPTION_INDICATOR_WIDTH + 8
local ARROW_RIGHT_POS_Y      = ARROW_LEFT_POS_Y

local FONT_NAME           = "res/fonts/msyhbd.ttc"
local FONT_COLOR          = {r = 255, g = 255, b = 255}
local FONT_OUTLINE_COLOR  = {r = 0,   g = 0,   b = 0}
local FONT_OUTLINE_WIDTH  = 2
local TITLE_FONT_SIZE     = 20
local INDICATOR_FONT_SIZE = 32

local OPTION_INDICATOR_CAPINSETS = {x = 4, y = 6, width = 1, height = 1}

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initArrowLeft(self)
    local arrowLeft = ccui.Button:create()
    arrowLeft:loadTextureNormal("c03_t02_s05_f01.png", ccui.TextureResType.plistType)
        :setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)
        :setPosition(ARROW_LEFT_POS_X, ARROW_LEFT_POS_Y)

        :setScale(0.75)
        :setZoomScale(-0.05)

        :addTouchEventListener(function(sender, eventType)
            if ((eventType == ccui.TouchEventType.ended) and (self.m_Model)) then
                self.m_Model:onButtonPrevTouched()
            end
        end)

    self.m_ArrowLeft = arrowLeft
    self:addChild(arrowLeft)
end

local function initArrowRight(self)
    local arrowRight = ccui.Button:create()
    arrowRight:loadTextureNormal("c03_t02_s06_f01.png", ccui.TextureResType.plistType)
        :setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)
        :setPosition(ARROW_RIGHT_POS_X, ARROW_RIGHT_POS_Y)

        :setScale(0.75)
        :setZoomScale(-0.05)

        :addTouchEventListener(function(sender, eventType)
            if ((eventType == ccui.TouchEventType.ended) and (self.m_Model)) then
                self.m_Model:onButtonNextTouched()
            end
        end)

    self.m_ArrowRight = arrowRight
    self:addChild(arrowRight)
end

local function initTitleLabel(self)
    local title = cc.Label:createWithTTF("", FONT_NAME, TITLE_FONT_SIZE)
    title:ignoreAnchorPointForPosition(true)
        :setPosition(TITLE_LABEL_POS_X, TITLE_LABEL_POS_Y)

        :setDimensions(TITLE_LABEL_WIDTH, TITLE_LABEL_HEIGHT)
        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
        :setVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)

        :setTextColor(FONT_COLOR)
        :enableOutline(FONT_OUTLINE_COLOR, FONT_OUTLINE_WIDTH)

    self.m_TitleLabel = title
    self:addChild(title)
end

local function initOptionIndicator(self)
    local optionIndicator = ccui.Button:create()
    optionIndicator:loadTextureNormal("c03_t01_s01_f01.png", ccui.TextureResType.plistType)
        :setScale9Enabled(true)
        :setCapInsets(OPTION_INDICATOR_CAPINSETS)
        :setContentSize(OPTION_INDICATOR_WIDTH, OPTION_INDICATOR_HEIGHT)

        :ignoreAnchorPointForPosition(true)
        :setPosition(OPTION_INDICATOR_POS_X, OPTION_INDICATOR_POS_Y)

        :setOpacity(180)
        :setZoomScale(-0.05)

        :setTitleFontName(FONT_NAME)
        :setTitleFontSize(INDICATOR_FONT_SIZE)
        :setTitleColor(FONT_COLOR)

        :setTouchEnabled(false)
        :addTouchEventListener(function(sender, eventType)
            if ((eventType == ccui.TouchEventType.ended) and (self.m_Model)) then
                self.m_Model:onOptionIndicatorTouched()
            end
        end)

    optionIndicator:getTitleRenderer():enableOutline(FONT_OUTLINE_COLOR, FONT_OUTLINE_WIDTH)

    self.m_OptionIndicator = optionIndicator
    self:addChild(optionIndicator)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewOptionSelector:ctor()
    self:setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)

    initArrowLeft(self)
    initArrowRight(self)
    initTitleLabel(self)
    initOptionIndicator(self)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewOptionSelector:setButtonsEnabled(enabled)
    self.m_ArrowLeft:setEnabled(enabled)
    self.m_ArrowRight:setEnabled(enabled)

    return self
end

function ViewOptionSelector:setOptionIndicatorTouchEnabled(enabled)
    self.m_OptionIndicator:setTouchEnabled(enabled)

    return self
end

function ViewOptionSelector:setTitleText(text)
    self.m_TitleLabel:setString(text)

    return self
end

function ViewOptionSelector:setOptionText(text)
    self.m_OptionIndicator:setTitleText("" .. text)

    return self
end

return ViewOptionSelector
