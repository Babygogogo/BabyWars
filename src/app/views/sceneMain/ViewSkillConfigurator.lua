
local ViewSkillConfigurator = class("ViewSkillConfigurator", cc.Node)

local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")

local MENU_TITLE_Z_ORDER      = 1
local BUTTON_BACK_Z_ORDER     = 1
local MENU_LIST_VIEW_Z_ORDER  = 1
local MENU_BACKGROUND_Z_ORDER = 0

local BACKGROUND_NAME      = "c03_t01_s01_f01.png"
local BACKGROUND_CAPINSETS = {x = 4, y = 6, width = 1, height = 1}
local BACKGROUND_OPACITY   = 180

local MENU_BACKGROUND_WIDTH  = 250
local MENU_BACKGROUND_HEIGHT = display.height - 60
local MENU_BACKGROUND_POS_X  = 30
local MENU_BACKGROUND_POS_Y  = 30

local MENU_TITLE_WIDTH      = MENU_BACKGROUND_WIDTH
local MENU_TITLE_HEIGHT     = 60
local MENU_TITLE_POS_X      = MENU_BACKGROUND_POS_X
local MENU_TITLE_POS_Y      = MENU_BACKGROUND_POS_Y + MENU_BACKGROUND_HEIGHT - MENU_TITLE_HEIGHT
local MENU_TITLE_FONT_COLOR = {r = 96,  g = 224, b = 88}
local MENU_TITLE_FONT_SIZE  = 35

local BUTTON_BACK_WIDTH      = MENU_BACKGROUND_WIDTH
local BUTTON_BACK_HEIGHT     = 50
local BUTTON_BACK_POS_X      = MENU_BACKGROUND_POS_X
local BUTTON_BACK_POS_Y      = MENU_BACKGROUND_POS_Y
local BUTTON_BACK_FONT_COLOR = {r = 240, g = 80, b = 56}

local MENU_LIST_VIEW_WIDTH        = MENU_BACKGROUND_WIDTH
local MENU_LIST_VIEW_HEIGHT       = MENU_TITLE_POS_Y - BUTTON_BACK_POS_Y - BUTTON_BACK_HEIGHT
local MENU_LIST_VIEW_POS_X        = MENU_BACKGROUND_POS_X
local MENU_LIST_VIEW_POS_Y        = BUTTON_BACK_POS_Y + BUTTON_BACK_HEIGHT
local MENU_LIST_VIEW_ITEMS_MARGIN = 10

local ITEM_FONT_NAME          = "res/fonts/msyhbd.ttc"
local ITEM_FONT_SIZE          = 25
local ITEM_FONT_COLOR         = {r = 255, g = 255, b = 255}
local ITEM_FONT_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local ITEM_FONT_OUTLINE_WIDTH = 2

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initMenuBackground(self)
    local background = cc.Scale9Sprite:createWithSpriteFrameName(BACKGROUND_NAME, BACKGROUND_CAPINSETS)
    background:ignoreAnchorPointForPosition(true)
        :setPosition(MENU_BACKGROUND_POS_X, MENU_BACKGROUND_POS_Y)
        :setContentSize(MENU_BACKGROUND_WIDTH, MENU_BACKGROUND_HEIGHT)
        :setOpacity(BACKGROUND_OPACITY)

    self.m_MenuBackground = background
    self:addChild(background, MENU_BACKGROUND_Z_ORDER)
end

local function initMenuTitle(self)
    local title = cc.Label:createWithTTF(LocalizationFunctions.getLocalizedText(1, "ConfigSkills"), ITEM_FONT_NAME, MENU_TITLE_FONT_SIZE)
    title:ignoreAnchorPointForPosition(true)
        :setPosition(MENU_TITLE_POS_X, MENU_TITLE_POS_Y)

        :setDimensions(MENU_TITLE_WIDTH, MENU_TITLE_HEIGHT)
        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
        :setVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)

        :setTextColor(MENU_TITLE_FONT_COLOR)
        :enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    self.m_MenuTitle = title
    self:addChild(title, MENU_TITLE_Z_ORDER)
end

local function initButtonBack(self)
    local button = ccui.Button:create()
    button:ignoreAnchorPointForPosition(true)
        :setPosition(BUTTON_BACK_POS_X, BUTTON_BACK_POS_Y)

        :setScale9Enabled(true)
        :setContentSize(BUTTON_BACK_WIDTH, BUTTON_BACK_HEIGHT)

        :setZoomScale(-0.05)

        :setTitleFontName(ITEM_FONT_NAME)
        :setTitleFontSize(ITEM_FONT_SIZE)
        :setTitleColor(BUTTON_BACK_FONT_COLOR)
        :setTitleText(LocalizationFunctions.getLocalizedText(1, "Back"))

        :addTouchEventListener(function(sender, eventType)
            if ((eventType == ccui.TouchEventType.ended) and (self.m_Model)) then
                self.m_Model:onButtonBackTouched()
            end
        end)

    button:getTitleRenderer():enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    self.m_ButtonExit = button
    self:addChild(button, BUTTON_BACK_Z_ORDER)
end

local function initMenuListView(self)
    local listView = ccui.ListView:create()
    listView:ignoreAnchorPointForPosition(true)
        :setPosition(MENU_LIST_VIEW_POS_X, MENU_LIST_VIEW_POS_Y)
        :setContentSize(MENU_LIST_VIEW_WIDTH, MENU_LIST_VIEW_HEIGHT)
        :setItemsMargin(MENU_LIST_VIEW_ITEMS_MARGIN)
        :setGravity(ccui.ListViewGravity.centerHorizontal)

    self.m_MenuListView = listView
    self:addChild(listView, MENU_LIST_VIEW_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewSkillConfigurator:ctor()
    initMenuBackground(self)
    initMenuTitle(     self)
    initButtonBack(    self)
    initMenuListView(  self)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewSkillConfigurator:setEnabled(enabled)
    self:setVisible(enabled)

    return self
end

return ViewSkillConfigurator
