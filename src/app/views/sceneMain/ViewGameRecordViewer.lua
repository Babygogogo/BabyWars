
local ViewGameRecordViewer = class("ViewGameRecordViewer", cc.Node)

local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")

local MENU_TITLE_Z_ORDER          = 1
local MENU_LIST_VIEW_Z_ORDER      = 1
local BUTTON_BACK_Z_ORDER         = 1
local TEXT_SCROLL_Z_ORDER         = 1
local TEXT_BACKGROUND_Z_ORDER     = 0
local MENU_BACKGROUND_Z_ORDER     = 0

local MENU_BACKGROUND_WIDTH        = 250
local MENU_BACKGROUND_HEIGHT       = display.height - 60
local MENU_BACKGROUND_POS_X        = 30
local MENU_BACKGROUND_POS_Y        = 30
local MENU_BACKGROUND_TEXTURE_NAME = "c03_t01_s01_f01.png"
local MENU_BACKGROUND_CAPINSETS    = {x = 4, y = 6, width = 1, height = 1}

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

local ITEM_WIDTH              = 230
local ITEM_HEIGHT             = 50
local ITEM_CAPINSETS          = {x = 1, y = ITEM_HEIGHT, width = 1, height = 1}
local ITEM_FONT_NAME          = "res/fonts/msyhbd.ttc"
local ITEM_FONT_SIZE          = 25
local ITEM_FONT_COLOR         = {r = 255, g = 255, b = 255}
local ITEM_FONT_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local ITEM_FONT_OUTLINE_WIDTH = 2

local TEXT_BACKGROUND_WIDTH  = display.width - MENU_BACKGROUND_WIDTH - 90
local TEXT_BACKGROUND_HEIGHT = MENU_BACKGROUND_HEIGHT
local TEXT_BACKGROUND_POS_X  = display.width - 30 - TEXT_BACKGROUND_WIDTH
local TEXT_BACKGROUND_POS_Y  = 30

local TEXT_SCROLL_WIDTH  = TEXT_BACKGROUND_WIDTH  - 7
local TEXT_SCROLL_HEIGHT = TEXT_BACKGROUND_HEIGHT - 11
local TEXT_SCROLL_POS_X  = TEXT_BACKGROUND_POS_X + 5
local TEXT_SCROLL_POS_Y  = TEXT_BACKGROUND_POS_Y + 5

local TEXT_WIDTH       = TEXT_SCROLL_WIDTH
local TEXT_HEIGHT      = 1000
local TEXT_FONT_SIZE   = 18
local TEXT_LINE_HEIGHT = TEXT_FONT_SIZE / 5 * 8

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createViewMenuItem(item)
    local label = cc.Label:createWithTTF(item.name, ITEM_FONT_NAME, ITEM_FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)

        :setDimensions(ITEM_WIDTH, ITEM_HEIGHT)
        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
        :setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM)

        :setTextColor(ITEM_FONT_COLOR)
        :enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    local view = ccui.Button:create()
    view:loadTextureNormal("c03_t06_s01_f01.png", ccui.TextureResType.plistType)

        :setScale9Enabled(true)
        :setCapInsets(ITEM_CAPINSETS)
        :setContentSize(ITEM_WIDTH, ITEM_HEIGHT)

        :setZoomScale(-0.05)

        :addTouchEventListener(function(sender, eventType)
            if (eventType == ccui.TouchEventType.ended) then
                item.callback()
            end
        end)
    view:getRendererNormal():addChild(label)

    return view
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initMenuBackground(self)
    local background = cc.Scale9Sprite:createWithSpriteFrameName(MENU_BACKGROUND_TEXTURE_NAME, MENU_BACKGROUND_CAPINSETS)
    background:ignoreAnchorPointForPosition(true)
        :setPosition(MENU_BACKGROUND_POS_X, MENU_BACKGROUND_POS_Y)
        :setContentSize(MENU_BACKGROUND_WIDTH, MENU_BACKGROUND_HEIGHT)
        :setOpacity(180)

    self.m_MenuBackground = background
    self:addChild(background, MENU_BACKGROUND_Z_ORDER)
end

local function initMenuListView(self)
    local listView = ccui.ListView:create()
    listView:setPosition(MENU_LIST_VIEW_POS_X, MENU_LIST_VIEW_POS_Y)
        :setContentSize(MENU_LIST_VIEW_WIDTH, MENU_LIST_VIEW_HEIGHT)
        :setItemsMargin(MENU_LIST_VIEW_ITEMS_MARGIN)
        :setGravity(ccui.ListViewGravity.centerHorizontal)

    self.m_MenuListView = listView
    self:addChild(listView, MENU_LIST_VIEW_Z_ORDER)
end

local function initMenuTitle(self)
    local title = cc.Label:createWithTTF(LocalizationFunctions.getLocalizedText(1, "ViewGameRecord"), ITEM_FONT_NAME, MENU_TITLE_FONT_SIZE)
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

    self.m_ButtonBack = button
    self:addChild(button, BUTTON_BACK_Z_ORDER)
end

local function initTextBackground(self)
    local background = cc.Scale9Sprite:createWithSpriteFrameName(MENU_BACKGROUND_TEXTURE_NAME, MENU_BACKGROUND_CAPINSETS)
    background:ignoreAnchorPointForPosition(true)
        :setPosition(TEXT_BACKGROUND_POS_X, TEXT_BACKGROUND_POS_Y)
        :setContentSize(TEXT_BACKGROUND_WIDTH, TEXT_BACKGROUND_HEIGHT)
        :setOpacity(180)

    self.m_TextBackground = background
    self:addChild(background, TEXT_BACKGROUND_Z_ORDER)
end

local function initTextScrollView(self)
    local scrollView = ccui.ScrollView:create()
    scrollView:setPosition(TEXT_SCROLL_POS_X, TEXT_SCROLL_POS_Y)
        :setContentSize(TEXT_SCROLL_WIDTH, TEXT_SCROLL_HEIGHT)

    self.m_TextScrollView = scrollView
    self:addChild(scrollView, TEXT_SCROLL_Z_ORDER)
end

local function initTextLabel(self)
    local label = cc.Label:createWithTTF("", ITEM_FONT_NAME, TEXT_FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)
        :setDimensions(TEXT_WIDTH, TEXT_HEIGHT)

        :enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    self.m_TextLabel = label
    self.m_TextScrollView:addChild(label)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewGameRecordViewer:ctor(param)
    initMenuBackground(self)
    initMenuListView(  self)
    initMenuTitle(     self)
    initButtonBack(    self)
    initTextBackground(self)
    initTextScrollView(self)
    initTextLabel(     self)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewGameRecordViewer:setItems(items)
    local listView = self.m_MenuListView
    listView:removeAllItems()
    for _, item in ipairs(items or {}) do
        listView:pushBackCustomItem(createViewMenuItem(item))
    end

    return self
end

function ViewGameRecordViewer:setText(text)
    local label = self.m_TextLabel
    label:setString(text)

    local height = math.max(label:getLineHeight() * label:getStringNumLines(), TEXT_SCROLL_HEIGHT)
    label:setDimensions(TEXT_WIDTH, height)
    self.m_TextScrollView:setInnerContainerSize({width = TEXT_WIDTH, height = height})

    return self
end

function ViewGameRecordViewer:setMenuTitleText(text)
    self.m_MenuTitle:setString(text)

    return self
end

return ViewGameRecordViewer
