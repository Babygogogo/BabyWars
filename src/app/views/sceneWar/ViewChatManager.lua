
local ViewChatManager = class("ViewChatManager", cc.Node)

local LocalizationFunctions = requireBW("src.app.utilities.LocalizationFunctions")

local getLocalizedText = LocalizationFunctions.getLocalizedText

local ADDRESS_BAR_Z_ORDER         = 1
local MENU_TITLE_Z_ORDER          = 1
local BUTTON_CLOSE_Z_ORDER         = 1
local BUTTON_SEND_Z_ORDER         = 1
local MENU_LIST_VIEW_Z_ORDER      = 1
local OVERVIEW_SCROLLVIEW_Z_ORDER = 1
local MENU_BACKGROUND_Z_ORDER     = 0
local OVERVIEW_BACKGROUND_Z_ORDER = 0

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

local BUTTON_CLOSE_WIDTH      = MENU_BACKGROUND_WIDTH
local BUTTON_CLOSE_HEIGHT     = 50
local BUTTON_CLOSE_POS_X      = MENU_BACKGROUND_POS_X
local BUTTON_CLOSE_POS_Y      = MENU_BACKGROUND_POS_Y
local BUTTON_CLOSE_FONT_COLOR = {r = 240, g = 80, b = 56}

local BUTTON_SEND_WIDTH      = BUTTON_CLOSE_WIDTH
local BUTTON_SEND_HEIGHT     = BUTTON_CLOSE_HEIGHT
local BUTTON_SEND_POS_X      = BUTTON_CLOSE_POS_X
local BUTTON_SEND_POS_Y      = BUTTON_CLOSE_POS_Y + BUTTON_CLOSE_HEIGHT
local BUTTON_SEND_FONT_COLOR = MENU_TITLE_FONT_COLOR

local MENU_LIST_VIEW_WIDTH        = MENU_BACKGROUND_WIDTH
local MENU_LIST_VIEW_HEIGHT       = MENU_TITLE_POS_Y - BUTTON_CLOSE_POS_Y - BUTTON_CLOSE_HEIGHT - BUTTON_SEND_HEIGHT
local MENU_LIST_VIEW_POS_X        = MENU_BACKGROUND_POS_X
local MENU_LIST_VIEW_POS_Y        = BUTTON_CLOSE_POS_Y + BUTTON_CLOSE_HEIGHT + BUTTON_SEND_HEIGHT
local MENU_LIST_VIEW_ITEMS_MARGIN = 10

local OVERVIEW_BACKGROUND_WIDTH  = display.width - MENU_BACKGROUND_WIDTH - 90
local OVERVIEW_BACKGROUND_HEIGHT = MENU_BACKGROUND_HEIGHT - 90
local OVERVIEW_BACKGROUND_POS_X  = display.width - 30 - OVERVIEW_BACKGROUND_WIDTH
local OVERVIEW_BACKGROUND_POS_Y  = 30 + 90

local OVERVIEW_SCROLLVIEW_WIDTH  = OVERVIEW_BACKGROUND_WIDTH  - 7
local OVERVIEW_SCROLLVIEW_HEIGHT = OVERVIEW_BACKGROUND_HEIGHT - 11
local OVERVIEW_SCROLLVIEW_POS_X  = OVERVIEW_BACKGROUND_POS_X + 5
local OVERVIEW_SCROLLVIEW_POS_Y  = OVERVIEW_BACKGROUND_POS_Y + 5

local OVERVIEW_FONT_SIZE = 18

local ADDRESS_BAR_WIDTH     = display.width - MENU_BACKGROUND_WIDTH - 90
local ADDRESS_BAR_HEIGHT    = 60
local ADDRESS_BAR_POS_X     = display.width - ADDRESS_BAR_WIDTH - 30
local ADDRESS_BAR_POS_Y     = MENU_BACKGROUND_POS_Y
local ADDRESS_BAR_FONT_SIZE = 18

local ITEM_WIDTH              = 230
local ITEM_HEIGHT             = 50
local ITEM_CAPINSETS          = {x = 1, y = ITEM_HEIGHT, width = 1, height = 1}
local ITEM_FONT_NAME          = "res/fonts/msyhbd.ttc"
local ITEM_FONT_SIZE          = 25
local ITEM_FONT_COLOR         = {r = 255, g = 255, b = 255}
local ITEM_FONT_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local ITEM_FONT_OUTLINE_WIDTH = 2

local BUTTON_COLOR_ENABLED  = {r = 255, g = 255, b = 255}
local BUTTON_COLOR_DISABLED = {r = 160, g = 160, b = 160}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function setButtonEnabled(button, enabled)
    button:setEnabled(enabled)
    if (enabled) then
        button:setColor(BUTTON_COLOR_ENABLED)
    else
        button:setColor(BUTTON_COLOR_DISABLED)
    end
end

local function createViewItem(item)
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
        :setCascadeColorEnabled(true)

        :addTouchEventListener(function(sender, eventType)
            if (eventType == ccui.TouchEventType.ended) then
                item.callback()
            end
        end)
    view:getRendererNormal():setCascadeColorEnabled(true)
        :addChild(label)

    if (item.available == false) then
        setButtonEnabled(view, false)
    end

    return view
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initAddressBar(self)
    local background = cc.Scale9Sprite:createWithSpriteFrameName(BACKGROUND_NAME, BACKGROUND_CAPINSETS)
    background:ignoreAnchorPointForPosition(true)
        :setPosition(ADDRESS_BAR_POS_X, ADDRESS_BAR_POS_Y)
        :setContentSize(ADDRESS_BAR_WIDTH, ADDRESS_BAR_HEIGHT)
        :setOpacity(BACKGROUND_OPACITY)

    local label = cc.Label:createWithTTF("", ITEM_FONT_NAME, ADDRESS_BAR_FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(5, 0)
        :setDimensions(ADDRESS_BAR_WIDTH - 7, ADDRESS_BAR_HEIGHT)
        :enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)
        :setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
    background:addChild(label)

    self.m_AddressBarBackground = background
    self.m_AddressBarLabel      = label
    self:addChild(background, ADDRESS_BAR_Z_ORDER)
end

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
    local title = cc.Label:createWithTTF(getLocalizedText(65, "Channel Public"), ITEM_FONT_NAME, MENU_TITLE_FONT_SIZE)
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
        :setPosition(BUTTON_CLOSE_POS_X, BUTTON_CLOSE_POS_Y)

        :setScale9Enabled(true)
        :setContentSize(BUTTON_CLOSE_WIDTH, BUTTON_CLOSE_HEIGHT)

        :setZoomScale(-0.05)

        :setTitleFontName(ITEM_FONT_NAME)
        :setTitleFontSize(ITEM_FONT_SIZE)
        :setTitleColor(BUTTON_CLOSE_FONT_COLOR)
        :setTitleText(getLocalizedText(1, "Back"))

        :addTouchEventListener(function(sender, eventType)
            if ((eventType == ccui.TouchEventType.ended) and (self.m_Model)) then
                self.m_Model:onButtonBackTouched()
            end
        end)

    button:getTitleRenderer():enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    self.m_ButtonExit = button
    self:addChild(button, BUTTON_CLOSE_Z_ORDER)
end

local function initButtonSend(self)
    local button = ccui.Button:create()
    button:ignoreAnchorPointForPosition(true)
        :setPosition(BUTTON_SEND_POS_X, BUTTON_SEND_POS_Y)

        :setScale9Enabled(true)
        :setContentSize(BUTTON_SEND_WIDTH, BUTTON_SEND_HEIGHT)

        :setZoomScale(-0.05)

        :setTitleFontName(ITEM_FONT_NAME)
        :setTitleFontSize(ITEM_FONT_SIZE)
        :setTitleColor(BUTTON_SEND_FONT_COLOR)
        :setTitleText(getLocalizedText(65, "Send"))

        :setCascadeColorEnabled(true)

        :addTouchEventListener(function(sender, eventType)
            if ((eventType == ccui.TouchEventType.ended) and (self.m_Model)) then
                self.m_Model:onButtonSendTouched()
            end
        end)

    button:getTitleRenderer():enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    self.m_ButtonSend = button
    self:addChild(button, BUTTON_SEND_Z_ORDER)
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

local function initOverview(self)
    local background = cc.Scale9Sprite:createWithSpriteFrameName(BACKGROUND_NAME, BACKGROUND_CAPINSETS)
    background:ignoreAnchorPointForPosition(true)
        :setPosition(OVERVIEW_BACKGROUND_POS_X, OVERVIEW_BACKGROUND_POS_Y)
        :setContentSize(OVERVIEW_BACKGROUND_WIDTH, OVERVIEW_BACKGROUND_HEIGHT)
        :setOpacity(BACKGROUND_OPACITY)

    local scrollView = ccui.ScrollView:create()
    scrollView:setContentSize(OVERVIEW_SCROLLVIEW_WIDTH, OVERVIEW_SCROLLVIEW_HEIGHT)
        :ignoreAnchorPointForPosition(true)
        :setPosition(OVERVIEW_SCROLLVIEW_POS_X, OVERVIEW_SCROLLVIEW_POS_Y)

    local label = cc.Label:createWithTTF("", ITEM_FONT_NAME, OVERVIEW_FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)
        :setDimensions(OVERVIEW_SCROLLVIEW_WIDTH, OVERVIEW_SCROLLVIEW_HEIGHT)
        :enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)
    scrollView:addChild(label)

    self.m_OverviewBackground = background
    self.m_OverviewScrollView = scrollView
    self.m_OverviewLabel      = label
    self:addChild(background, OVERVIEW_BACKGROUND_Z_ORDER)
        :addChild(scrollView, OVERVIEW_SCROLLVIEW_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewChatManager:ctor()
    initAddressBar(    self)
    initMenuBackground(self)
    initMenuTitle(     self)
    initButtonBack(    self)
    initButtonSend(    self)
    initMenuListView(  self)
    initOverview(      self)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewChatManager:setEnabled(enabled)
    self:setVisible(enabled)

    return self
end

function ViewChatManager:setItemEnabled(itemIndex, enabled)
    setButtonEnabled(self.m_MenuListView:getItem(itemIndex - 1), enabled)

    return self
end

function ViewChatManager:setMenuTitle(text)
    self.m_MenuTitle:setString(text)

    return self
end

function ViewChatManager:setMenuItems(items)
    assert(#items > 0, "ViewChatManager:setMenuItems() the items are empty.")
    local listView = self.m_MenuListView
    listView:removeAllChildren()

    for _, item in ipairs(items) do
        listView:pushBackCustomItem(createViewItem(item))
    end

    return self
end

function ViewChatManager:setAddressBarVisible(visible)
    self.m_AddressBarBackground:setVisible(visible)

    return self
end

function ViewChatManager:setOverviewVisible(visible)
    self.m_OverviewBackground:setVisible(visible)
    self.m_OverviewScrollView:setVisible(visible)

    return self
end

function ViewChatManager:disableButtonSendForSecs(secs)
    local button = self.m_ButtonSend
    setButtonEnabled(button, false)

    button:stopAllActions()
        :runAction(cc.Sequence:create(
            cc.DelayTime:create(secs or 3),
            cc.CallFunc:create(function()
                setButtonEnabled(button, true)
            end)
        ))

    return self
end

function ViewChatManager:setButtonSendEnabled(enabled)
    local button = self.m_ButtonSend
    button:stopAllActions()
    setButtonEnabled(button, enabled)

    return self
end

function ViewChatManager:setAddressBarText(text)
    self.m_AddressBarLabel:setString(text)

    return self
end

function ViewChatManager:setOverviewText(text)
    local label = self.m_OverviewLabel
    label:setString(text)

    local height = math.max(label:getLineHeight() * label:getStringNumLines(), OVERVIEW_SCROLLVIEW_HEIGHT)
    label:setDimensions(OVERVIEW_SCROLLVIEW_WIDTH, height)
    self.m_OverviewScrollView:setInnerContainerSize({width = OVERVIEW_SCROLLVIEW_WIDTH, height = height})

    return self
end

return ViewChatManager
