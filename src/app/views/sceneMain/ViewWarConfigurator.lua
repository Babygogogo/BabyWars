
local ViewWarConfigurator = class("ViewWarConfigurator", cc.Node)

local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")

local EDIT_BOX_PASSWORD_WIDTH  = 250 -- The same as the width of the indicator of ViewOptionSelector
local EDIT_BOX_PASSWORD_HEIGHT = 60  -- The same as the height of the indicator of ViewOptionSelector
local BUTTON_WIDTH             = 300
local BUTTON_HEIGHT            = 80

local SELECTOR_PLAYER_INDEX_POS_X     = 60
local SELECTOR_PLAYER_INDEX_POS_Y     = 60 + (display.height - 60) / 4 * 3
local SELECTOR_FOG_POS_X              = SELECTOR_PLAYER_INDEX_POS_X
local SELECTOR_FOG_POS_Y              = 60 + (display.height - 60) / 4 * 2
local SELECTOR_WEATHER_POS_X          = SELECTOR_PLAYER_INDEX_POS_X
local SELECTOR_WEATHER_POS_Y          = 60 + (display.height - 60) / 4 * 1
local SELECTOR_SKILL_POS_X            = display.width - 60 - (54 + 8 + 250 + 8 + 54)
local SELECTOR_SKILL_POS_Y            = SELECTOR_PLAYER_INDEX_POS_Y
local SELECTOR_MAX_SKILL_POINTS_POS_X = SELECTOR_SKILL_POS_X
local SELECTOR_MAX_SKILL_POINTS_POS_Y = SELECTOR_FOG_POS_Y
local EDIT_BOX_PASSWORD_POS_X         = SELECTOR_SKILL_POS_X + 54 + 8
local EDIT_BOX_PASSWORD_POS_Y         = SELECTOR_WEATHER_POS_Y
local BUTTON_BACK_POS_X               = 120
local BUTTON_BACK_POS_Y               = 45
local BUTTON_CONFIRM_POS_X            = display.width - 120 - BUTTON_WIDTH
local BUTTON_CONFIRM_POS_Y            = BUTTON_BACK_POS_Y

local EDIT_BOX_PASSWORD_CAPINSETS = {x = 1, y = EDIT_BOX_PASSWORD_HEIGHT - 7, width = 1, height = 1}

local FONT_NAME                         = "res/fonts/msyhbd.ttc"
local FONT_COLOR                        = {r = 255, g = 255, b = 255}
local FONT_OUTLINE_COLOR                = {r = 0,   g = 0,   b = 0}
local FONT_OUTLINE_WIDTH                = 2
local BUTTON_FONT_SIZE                  = 35
local EDIT_BOX_PASSWORD_TITLE_FONT_SIZE = 20
local EDIT_BOX_PASSWORD_FONT_SIZE       = 28

local BUTTON_SPRITE_FRAME_NAME    = "c03_t01_s01_f01.png"
local BUTTON_BACKGROUND_CAPINSETS = {x = 4, y = 6, width = 1, height = 1}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createButton(posX, posY, text)
    local button = ccui.Button:create()
    button:loadTextureNormal(BUTTON_SPRITE_FRAME_NAME, ccui.TextureResType.plistType)
        :setScale9Enabled(true)
        :setCapInsets(BUTTON_BACKGROUND_CAPINSETS)
        :setContentSize(BUTTON_WIDTH, BUTTON_HEIGHT)

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
local function initEditBoxPassword(self)
    local titleLabel = cc.Label:createWithTTF(LocalizationFunctions.getLocalizedText(39), FONT_NAME, EDIT_BOX_PASSWORD_TITLE_FONT_SIZE)
    titleLabel:ignoreAnchorPointForPosition(true)
        :enableOutline(FONT_OUTLINE_COLOR, FONT_OUTLINE_WIDTH)

        :setDimensions(EDIT_BOX_PASSWORD_WIDTH, EDIT_BOX_PASSWORD_HEIGHT + 30)
        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
        :setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)

    local background = cc.Scale9Sprite:createWithSpriteFrameName(BUTTON_SPRITE_FRAME_NAME, BUTTON_BACKGROUND_CAPINSETS)
    background:setOpacity(180)

    local editBox = ccui.EditBox:create(cc.size(EDIT_BOX_PASSWORD_WIDTH, EDIT_BOX_PASSWORD_HEIGHT), background, background, background)
    editBox:ignoreAnchorPointForPosition(true)
        :setPosition(EDIT_BOX_PASSWORD_POS_X, EDIT_BOX_PASSWORD_POS_Y)
        :setFontSize(EDIT_BOX_PASSWORD_FONT_SIZE)
        :setFontColor({r = 0, g = 0, b = 0})

        :setPlaceholderFontSize(EDIT_BOX_PASSWORD_FONT_SIZE)
        :setPlaceholderFontColor({r = 0, g = 0, b = 0})
        :setPlaceHolder(LocalizationFunctions.getLocalizedText(47))

        :setMaxLength(4)
        :setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
        :setInputFlag(cc.EDITBOX_INPUT_FLAG_SENSITIVE)

        :addChild(titleLabel)

    self:addChild(editBox)
    self.m_EditBoxPassword = editBox
end

local function initButtonBack(self)
    local button = createButton(BUTTON_BACK_POS_X, BUTTON_BACK_POS_Y, LocalizationFunctions.getLocalizedText(8, "Back"))
    button:addTouchEventListener(function(sender, eventType)
        if ((eventType == ccui.TouchEventType.ended) and (self.m_Model)) then
            self.m_Model:onButtonBackTouched()
        end
    end)

    self.m_ButtonBack = button
    self:addChild(button)
end

local function initButtonConfirm(self)
    local button = createButton(BUTTON_CONFIRM_POS_X, BUTTON_CONFIRM_POS_Y, LocalizationFunctions.getLocalizedText(46))
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

    initEditBoxPassword(self)
    initButtonBack(self)
    initButtonConfirm(self)

    return self
end

function ViewWarConfigurator:setViewSelectorPlayerIndex(view)
    assert(self.m_ViewSelectorPlayerIndex == nil, "ViewWarConfigurator:setViewSelectorPlayerIndex() the view has been set.")

    view:setPosition(SELECTOR_PLAYER_INDEX_POS_X, SELECTOR_PLAYER_INDEX_POS_Y)
    self.m_ViewSelectorPlayerIndex = view
    self:addChild(view)

    return self
end

function ViewWarConfigurator:setViewSelectorFog(view)
    assert(self.m_ViewSelectorFog == nil, "ViewWarConfigurator:setViewSelectorFog() the view has been set.")

    view:setPosition(SELECTOR_FOG_POS_X, SELECTOR_FOG_POS_Y)
    self.m_ViewSelectorFog = view
    self:addChild(view)

    return self
end

function ViewWarConfigurator:setViewSelectorWeather(view)
    assert(self.m_ViewSelectorWeather == nil, "ViewWarConfigurator:setViewSelectorWeather() the view has been set.")

    view:setPosition(SELECTOR_WEATHER_POS_X, SELECTOR_WEATHER_POS_Y)
    self.m_ViewSelectorWeather = view
    self:addChild(view)

    return self
end

function ViewWarConfigurator:setViewSelectorSkill(view)
    assert(self.m_ViewSelectorSkill == nil, "ViewWarConfigurator:setViewSelectorSkill() the view has been set.")

    view:setPosition(SELECTOR_SKILL_POS_X, SELECTOR_SKILL_POS_Y)
    self.m_ViewSelectorSkill = view
    self:addChild(view)

    return self
end

function ViewWarConfigurator:setViewSelectorMaxSkillPoints(view)
    assert(self.m_ViewSelectorMaxSkillPoints == nil, "ViewWarConfigurator:setViewSelectorMaxSkillPoints() the view has been set.")

    view:setPosition(SELECTOR_MAX_SKILL_POINTS_POS_X, SELECTOR_MAX_SKILL_POINTS_POS_Y)
    self.m_ViewSelectorMaxSkillPoints = view
    self:addChild(view)

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
