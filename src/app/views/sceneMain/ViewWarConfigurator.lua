
local ViewWarConfigurator = class("ViewWarConfigurator", cc.Node)

local ARROW_LEFT_WIDTH        = 54
local ARROW_LEFT_HEIGHT       = 54
local OPTION_INDICATOR_WIDTH  = 250
local OPTION_INDICATOR_HEIGHT = 60
local TITLE_LABEL_WIDTH       = OPTION_INDICATOR_WIDTH
local TITLE_LABEL_HEIGHT      = 30
local ARROW_RIGHT_WIDTH       = ARROW_LEFT_WIDTH
local ARROW_RIGHT_HEIGHT      = ARROW_LEFT_HEIGHT
local SELECTOR_WIDTH          = ARROW_LEFT_WIDTH + 8 + OPTION_INDICATOR_WIDTH + 8 + ARROW_RIGHT_WIDTH
local SELECTOR_HEIGHT         = OPTION_INDICATOR_HEIGHT + TITLE_LABEL_HEIGHT
local BUTTON_WIDTH            = 300
local BUTTON_HEIGHT           = 80

local ARROW_LEFT_POS_X       = 0
local ARROW_LEFT_POS_Y       = (OPTION_INDICATOR_HEIGHT - ARROW_LEFT_HEIGHT) / 2
local OPTION_INDICATOR_POS_X = ARROW_LEFT_POS_X + ARROW_LEFT_WIDTH + 8
local OPTION_INDICATOR_POS_Y = 0
local TITLE_LABEL_POS_X      = OPTION_INDICATOR_POS_X
local TITLE_LABEL_POS_Y      = OPTION_INDICATOR_POS_Y + OPTION_INDICATOR_HEIGHT
local ARROW_RIGHT_POS_X      = OPTION_INDICATOR_POS_X + OPTION_INDICATOR_WIDTH + 8
local ARROW_RIGHT_POS_Y      = ARROW_LEFT_POS_Y

local SELECTOR_PLAYER_INDEX_POS_X     = 60
local SELECTOR_PLAYER_INDEX_POS_Y     = 60 + (display.height - 60) / 4 * 3
local SELECTOR_FOG_POS_X              = SELECTOR_PLAYER_INDEX_POS_X
local SELECTOR_FOG_POS_Y              = 60 + (display.height - 60) / 4 * 2
local SELECTOR_WEATHER_POS_X          = SELECTOR_PLAYER_INDEX_POS_X
local SELECTOR_WEATHER_POS_Y          = 60 + (display.height - 60) / 4 * 1
local SELECTOR_SKILL_POS_X            = display.width - 60 - SELECTOR_WIDTH
local SELECTOR_SKILL_POS_Y            = SELECTOR_PLAYER_INDEX_POS_Y
local SELECTOR_MAX_SKILL_POINTS_POS_X = SELECTOR_SKILL_POS_X
local SELECTOR_MAX_SKILL_POINTS_POS_Y = SELECTOR_FOG_POS_Y
local EDIT_BOX_PASSWORD_POS_X         = SELECTOR_SKILL_POS_X
local EDIT_BOX_PASSWORD_POS_Y         = SELECTOR_WEATHER_POS_Y
local BUTTON_BACK_POS_X               = 120
local BUTTON_BACK_POS_Y               = 45
local BUTTON_CONFIRM_POS_X            = display.width - 120 - BUTTON_WIDTH
local BUTTON_CONFIRM_POS_Y            = BUTTON_BACK_POS_Y

local FONT_NAME           = "res/fonts/msyhbd.ttc"
local FONT_COLOR          = {r = 255, g = 255, b = 255}
local FONT_OUTLINE_COLOR  = {r = 0,   g = 0,   b = 0}
local FONT_OUTLINE_WIDTH  = 2
local TITLE_FONT_SIZE     = 20
local INDICATOR_FONT_SIZE = 28
local BUTTON_FONT_SIZE    = 35

local OPTION_INDICATOR_CAPINSETS = {x = 4, y = 6, width = 1, height = 1}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createArrowLeft()
    local arrowLeft  = ccui.Button:create()
    arrowLeft:loadTextureNormal("c03_t02_s05_f01.png", ccui.TextureResType.plistType)
        :setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)
        :setPosition(ARROW_LEFT_POS_X, ARROW_LEFT_POS_Y)

        :setScale(0.75)
        :setZoomScale(-0.05)

        --[[
        :addTouchEventListener(function(sender, eventType)
            if ((eventType == ccui.TouchEventType.ended) and (self.m_Model)) then
                self.m_Model:onButtonNextTouched()
            end
        end)
        --]]

    return arrowLeft
end

local function createArrowRight()
    local arrowRight = ccui.Button:create()
    arrowRight:loadTextureNormal("c03_t02_s06_f01.png", ccui.TextureResType.plistType)
        :setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)
        :setPosition(ARROW_RIGHT_POS_X, ARROW_RIGHT_POS_Y)

        :setScale(0.75)
        :setZoomScale(-0.05)

    return arrowRight
end

local function createTitleLabel(text)
    local title = cc.Label:createWithTTF(text, FONT_NAME, TITLE_FONT_SIZE)
    title:ignoreAnchorPointForPosition(true)
        :setPosition(TITLE_LABEL_POS_X, TITLE_LABEL_POS_Y)

        :setDimensions(TITLE_LABEL_WIDTH, TITLE_LABEL_HEIGHT)
        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
        :setVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)

        :setTextColor(FONT_COLOR)
        :enableOutline(FONT_OUTLINE_COLOR, FONT_OUTLINE_WIDTH)

    return title
end

local function createOptionIndicator(optionText)
    local optionIndicator = ccui.Button:create()
    optionIndicator:loadTextureNormal("c03_t01_s01_f01.png", ccui.TextureResType.plistType)
        :setScale9Enabled(true)
        :setCapInsets(OPTION_INDICATOR_CAPINSETS)
        :setContentSize(OPTION_INDICATOR_WIDTH, OPTION_INDICATOR_HEIGHT)

        :ignoreAnchorPointForPosition(true)
        :setPosition(OPTION_INDICATOR_POS_X, OPTION_INDICATOR_POS_Y)

        :setZoomScale(0)

        :setTitleFontName(FONT_NAME)
        :setTitleFontSize(INDICATOR_FONT_SIZE)
        :setTitleColor(FONT_COLOR)
        :setTitleText(optionText)

    optionIndicator:getTitleRenderer():enableOutline(FONT_OUTLINE_COLOR, FONT_OUTLINE_WIDTH)

    return optionIndicator
end

local function createSelector(posX, posY, titleText, optionText)
    local selector = cc.Node:create()
    selector:setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)
        :setPosition(posX, posY)

        :setOpacity(180)
        :setCascadeOpacityEnabled(true)

    selector.m_ArrowLeft  = createArrowLeft()
    selector:addChild(selector.m_ArrowLeft)

    selector.m_ArrowRight = createArrowRight()
    selector:addChild(selector.m_ArrowRight)

    selector.m_TitleLabel = createTitleLabel(titleText)
    selector:addChild(selector.m_TitleLabel)

    selector.m_OptionIndicator = createOptionIndicator(optionText)
    selector:addChild(selector.m_OptionIndicator)

    selector.setButtonsEnabled = function(self, enabled)
        self.m_ArrowLeft:setEnabled(enabled)
        self.m_ArrowRight:setEnabled(enabled)

        return self
    end

    selector.setOptionText = function(self, text)
        self.m_OptionIndicator:setTitleText(text)

        return self
    end

    return selector
end

local function createButton(posX, posY, text)
    local button = ccui.Button:create()
    button:loadTextureNormal("c03_t01_s01_f01.png", ccui.TextureResType.plistType)
        :setScale9Enabled(true)
        :setCapInsets(OPTION_INDICATOR_CAPINSETS)
        :setContentSize(BUTTON_WIDTH, BUTTON_HEIGHT)

        :setCascadeOpacityEnabled(true)
        :setOpacity(180)

        :ignoreAnchorPointForPosition(true)
        :setPosition(posX, posY)

        :setZoomScale(-0.05)

        :setTitleFontName(FONT_NAME)
        :setTitleFontSize(BUTTON_FONT_SIZE)
        :setTitleColor(FONT_COLOR)
        :setTitleText(text)

    button:getTitleRenderer():enableOutline(FONT_OUTLINE_COLOR, FONT_OUTLINE_WIDTH)

    return button
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initSelectorPlayerIndex(self)
    local selector = createSelector(SELECTOR_PLAYER_INDEX_POS_X, SELECTOR_PLAYER_INDEX_POS_Y, "Player Index", "1")

    self.m_SelectorPlayerIndex = selector
    self:addChild(selector)
end

local function initSelectorFog(self)
    local selector = createSelector(SELECTOR_FOG_POS_X, SELECTOR_FOG_POS_Y, "Fog", "off")
    selector:setButtonsEnabled(false)

    self.m_SelectorFog = selector
    self:addChild(selector)
end

local function initSelectorWeather(self)
    local selector = createSelector(SELECTOR_WEATHER_POS_X, SELECTOR_WEATHER_POS_Y, "Weather", "clear")
    selector:setButtonsEnabled(false)

    self.m_SelectorWeather = selector
    self:addChild(selector)
end

local function initSelectorSkill(self)
    local selector = createSelector(SELECTOR_SKILL_POS_X, SELECTOR_SKILL_POS_Y, "Skill", "Unavailable")
    selector:setButtonsEnabled(false)

    self.m_SelectorSkill = selector
    self:addChild(selector)
end

local function initSelectorMaxSkillPoints(self)
    local selector = createSelector(SELECTOR_MAX_SKILL_POINTS_POS_X, SELECTOR_MAX_SKILL_POINTS_POS_Y, "Max Skill Points", "Unavailable")
    selector:setButtonsEnabled(false)

    self.m_SelectorMaxSkillPoints = selector
    self:addChild(selector)
end

local function initEditBoxPassword(self)
    -- TODO: add code to do the job.
end

local function initButtonBack(self)
    local button = createButton(BUTTON_BACK_POS_X, BUTTON_BACK_POS_Y, "back")
    button:addTouchEventListener(function(sender, eventType)
        if ((eventType == ccui.TouchEventType.ended) and (self.m_Model)) then
            self.m_Model:onButtonBackTouched()
        end
    end)

    self.m_ButtonBack = button
    self:addChild(button)
end

local function initButtonConfirm(self)
    local button = createButton(BUTTON_CONFIRM_POS_X, BUTTON_CONFIRM_POS_Y, "confirm")
    button:addTouchEventListener(function(sender, eventType)
        if ((eventType == ccui.TouchEventType.ended) and (self.m_Model)) then
            self.m_Model:onButtonConfirmTouched()
        end
    end)

    self.m_ButtonConfirm = button
    self:addChild(button)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewWarConfigurator:ctor()
    self:setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)

    initSelectorPlayerIndex(self)
    initSelectorFog(self)
    initSelectorWeather(self)
    initSelectorSkill(self)
    initSelectorMaxSkillPoints(self)
    initEditBoxPassword(self)
    initButtonBack(self)
    initButtonConfirm(self)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewWarConfigurator:getSelectorPlayerIndex()
    return self.m_SelectorPlayerIndex
end

function ViewWarConfigurator:getSelectorFog()
    return self.m_SelectorFog
end

function ViewWarConfigurator:getSelectorWeather()
    return self.m_SelectorWeather
end

function ViewWarConfigurator:getSelectorSkill()
    return self.m_SelectorSkill
end

function ViewWarConfigurator:getSelectorMaxSkillPoints()
    return self.m_SelectorMaxSkillPoints
end

function ViewWarConfigurator:getEditBoxPassword()
    return self.m_EditBoxPassword
end

return ViewWarConfigurator
