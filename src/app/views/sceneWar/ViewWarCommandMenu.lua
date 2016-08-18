
local ViewWarCommandMenu = class("ViewWarCommandMenu", cc.Node)

local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")

local getLocalizedText = LocalizationFunctions.getLocalizedText

local MENU_TITLE_Z_ORDER          = 1
local MENU_LIST_VIEW_Z_ORDER      = 1
local BUTTON_BACK_Z_ORDER         = 1
local OVERVIEW_SCROLLVIEW_Z_ORDER = 1
local OVERVIEW_BACKGROUND_Z_ORDER = 0
local MENU_BACKGROUND_Z_ORDER     = 0

local BACKGROUND_NAME      = "c03_t01_s01_f01.png"
local BACKGROUND_OPACITY   = 180
local BACKGROUND_CAPINSETS = {x = 4, y = 6, width = 1, height = 1}

local MENU_BACKGROUND_WIDTH     = 250
local MENU_BACKGROUND_HEIGHT    = display.height - 60
local MENU_BACKGROUND_POS_X     = 30
local MENU_BACKGROUND_POS_Y     = 30

local MENU_TITLE_WIDTH      = MENU_BACKGROUND_WIDTH
local MENU_TITLE_HEIGHT     = 60
local MENU_TITLE_POS_X      = MENU_BACKGROUND_POS_X
local MENU_TITLE_POS_Y      = MENU_BACKGROUND_POS_Y + MENU_BACKGROUND_HEIGHT - MENU_TITLE_HEIGHT
local MENU_TITLE_FONT_COLOR = {r = 96,  g = 224, b = 88}
local MENU_TITLE_FONT_SIZE  = 35

local BUTTON_BACK_WIDTH  = MENU_BACKGROUND_WIDTH
local BUTTON_BACK_HEIGHT = 50
local BUTTON_BACK_POS_X  = MENU_BACKGROUND_POS_X
local BUTTON_BACK_POS_Y  = MENU_BACKGROUND_POS_Y

local MENU_LIST_VIEW_WIDTH        = MENU_BACKGROUND_WIDTH
local MENU_LIST_VIEW_HEIGHT       = MENU_TITLE_POS_Y - BUTTON_BACK_POS_Y - BUTTON_BACK_HEIGHT
local MENU_LIST_VIEW_POS_X        = MENU_BACKGROUND_POS_X
local MENU_LIST_VIEW_POS_Y        = BUTTON_BACK_POS_Y + BUTTON_BACK_HEIGHT
local MENU_LIST_VIEW_ITEMS_MARGIN = 10

local OVERVIEW_BACKGROUND_WIDTH  = display.width - MENU_BACKGROUND_WIDTH - 90
local OVERVIEW_BACKGROUND_HEIGHT = MENU_BACKGROUND_HEIGHT
local OVERVIEW_BACKGROUND_POS_X  = display.width - 30 - OVERVIEW_BACKGROUND_WIDTH
local OVERVIEW_BACKGROUND_POS_Y  = 30

local OVERVIEW_SCROLLVIEW_WIDTH  = OVERVIEW_BACKGROUND_WIDTH  - 7
local OVERVIEW_SCROLLVIEW_HEIGHT = OVERVIEW_BACKGROUND_HEIGHT - 11
local OVERVIEW_SCROLLVIEW_POS_X  = OVERVIEW_BACKGROUND_POS_X + 5
local OVERVIEW_SCROLLVIEW_POS_Y  = OVERVIEW_BACKGROUND_POS_Y + 5

local OVERVIEW_FONT_SIZE = 18

local ITEM_WIDTH              = MENU_BACKGROUND_WIDTH - 20
local ITEM_HEIGHT             = 50
local ITEM_CAPINSETS          = {x = 1, y = ITEM_HEIGHT, width = 1, height = 1}
local ITEM_FONT_NAME          = "res/fonts/msyhbd.ttc"
local ITEM_FONT_SIZE          = 25
local ITEM_FONT_COLOR         = {r = 255, g = 255, b = 255}
local ITEM_FONT_OUTLINE_COLOR = {r = 0,   g = 0,   b = 0}
local ITEM_FONT_OUTLINE_WIDTH = 2

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
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
    local background = cc.Scale9Sprite:createWithSpriteFrameName(BACKGROUND_NAME, BACKGROUND_CAPINSETS)
    background:ignoreAnchorPointForPosition(true)
        :setPosition(MENU_BACKGROUND_POS_X, MENU_BACKGROUND_POS_Y)

        :setContentSize(MENU_BACKGROUND_WIDTH, MENU_BACKGROUND_HEIGHT)

        :setOpacity(BACKGROUND_OPACITY)

    self.m_MenuBackground = background
    self:addChild(background, MENU_BACKGROUND_Z_ORDER)
end

local function initMenuTitle(self)
    local title = cc.Label:createWithTTF(getLocalizedText(65, "WarMenu"), ITEM_FONT_NAME, MENU_TITLE_FONT_SIZE)
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
        :setTitleColor({r = 240, g = 80, b = 56})
        :setTitleText(LocalizationFunctions.getLocalizedText(1, "Close"))

        :addTouchEventListener(function(sender, eventType)
            if ((eventType == ccui.TouchEventType.ended) and (self.m_Model)) then
                self.m_Model:onButtonBackTouched()
            end
        end)

    button:getTitleRenderer():enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    self.m_ButtonBack = button
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

local function initTouchListener(self)
    local touchListener = cc.EventListenerTouchOneByOne:create()
    touchListener:setSwallowTouches(true)

    touchListener:registerScriptHandler(function()
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)

    self.m_TouchListener = touchListener
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(self.m_TouchListener, self)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewWarCommandMenu:ctor(param)
    initMenuBackground(self)
    initMenuTitle(     self)
    initButtonBack(    self)
    initMenuListView(  self)
    initOverview(      self)
    initTouchListener( self)

    self:ignoreAnchorPointForPosition(true)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewWarCommandMenu:createAndPushBackViewItem(item)
    self.m_MenuListView:pushBackCustomItem(createViewItem(item))

    return self
end

function ViewWarCommandMenu:removeAllItems()
    self.m_MenuListView:removeAllItems()

    return self
end

function ViewWarCommandMenu:setItems(items)
    self:removeAllItems()

    for _, item in ipairs(items) do
        self:createAndPushBackViewItem(item)
    end

    return self
end

function ViewWarCommandMenu:setOverviewString(text)
    local label = self.m_OverviewLabel
    label:setString(text)

    local height = math.max(label:getLineHeight() * label:getStringNumLines(), OVERVIEW_SCROLLVIEW_HEIGHT)
    label:setDimensions(OVERVIEW_SCROLLVIEW_WIDTH, height)
    self.m_OverviewScrollView:setInnerContainerSize({width = OVERVIEW_SCROLLVIEW_WIDTH, height = height})
        :jumpToTop()

    return self
end

function ViewWarCommandMenu:setEnabled(enabled)
    self:setVisible(enabled)
    self.m_TouchListener:setEnabled(enabled)

    return self
end

return ViewWarCommandMenu
