
local ViewNewWarCreator = class("ViewNewWarCreator", cc.Node)

local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")

local WAR_CONFIGURATOR_Z_ORDER    = 1
local MENU_TITLE_Z_ORDER          = 1
local MENU_LIST_VIEW_Z_ORDER      = 1
local BUTTON_BACK_Z_ORDER         = 1
local BUTTON_NEXT_Z_ORDER         = 1
local WAR_FIELD_PREVIEWER_Z_ORDER = 1
local MENU_BACKGROUND_Z_ORDER     = 0

local MENU_BACKGROUND_WIDTH     = 250
local MENU_BACKGROUND_HEIGHT    = display.height - 60
local MENU_BACKGROUND_POS_X     = 30
local MENU_BACKGROUND_POS_Y     = 30
local MENU_BACKGROUND_CAPINSETS = {x = 4, y = 6, width = 1, height = 1}

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

local BUTTON_NEXT_WIDTH     = display.width - MENU_BACKGROUND_WIDTH - 90
local BUTTON_NEXT_HEIGHT    = 60
local BUTTON_NEXT_POS_X     = display.width - BUTTON_NEXT_WIDTH - 30
local BUTTON_NEXT_POS_Y     = MENU_BACKGROUND_POS_Y
local BUTTON_NEXT_FONT_SIZE = 30

local ITEM_WIDTH              = 230
local ITEM_HEIGHT             = 50
local ITEM_CAPINSETS          = {x = 1, y = ITEM_HEIGHT, width = 1, height = 1}
local ITEM_FONT_NAME          = "res/fonts/msyhbd.ttc"
local ITEM_FONT_SIZE          = 25
local ITEM_FONT_COLOR         = {r = 255, g = 255, b = 255}
local ITEM_FONT_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local ITEM_FONT_OUTLINE_WIDTH = 2

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
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", MENU_BACKGROUND_CAPINSETS)
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
    local title = cc.Label:createWithTTF(LocalizationFunctions.getLocalizedText(2), ITEM_FONT_NAME, MENU_TITLE_FONT_SIZE)
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
        :setTitleText(LocalizationFunctions.getLocalizedText(8, "Back"))

        :addTouchEventListener(function(sender, eventType)
            if ((eventType == ccui.TouchEventType.ended) and (self.m_Model)) then
                self.m_Model:onButtonBackTouched()
            end
        end)

    button:getTitleRenderer():enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    self.m_ButtonBack = button
    self:addChild(button, BUTTON_BACK_Z_ORDER)
end

local function initButtonNext(self)
    local button = ccui.Button:create()
    button:loadTextureNormal("c03_t01_s01_f01.png", ccui.TextureResType.plistType)

        :setScale9Enabled(true)
        :setCapInsets(MENU_BACKGROUND_CAPINSETS)
        :setContentSize(BUTTON_NEXT_WIDTH, BUTTON_NEXT_HEIGHT)

        :setZoomScale(-0.05)
        :setOpacity(180)

        :ignoreAnchorPointForPosition(true)
        :setPosition(BUTTON_NEXT_POS_X, BUTTON_NEXT_POS_Y)

        :setTitleFontName(ITEM_FONT_NAME)
        :setTitleFontSize(BUTTON_NEXT_FONT_SIZE)
        :setTitleColor(ITEM_FONT_COLOR)
        :setTitleText(LocalizationFunctions.getLocalizedText(33))

        :addTouchEventListener(function(sender, eventType)
            if ((eventType == ccui.TouchEventType.ended) and (self.m_Model)) then
                self.m_Model:onButtonNextTouched()
            end
        end)

    button:getTitleRenderer():enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    self.m_ButtonNext = button
    self:addChild(button, BUTTON_NEXT_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewNewWarCreator:ctor(param)
    initMenuBackground(self)
    initMenuListView(  self)
    initMenuTitle(     self)
    initButtonBack(    self)
    initButtonNext(    self)

    return self
end

function ViewNewWarCreator:setViewWarFieldPreviewer(view)
    assert(self.m_ViewWarFieldPreviewer == nil, "ViewNewWarCreator:setViewWarFieldPreviewer() the view has been set.")
    self.m_ViewWarFieldPreviewer = view
    self:addChild(view, WAR_FIELD_PREVIEWER_Z_ORDER)

    return self
end

function ViewNewWarCreator:setViewWarConfigurator(view)
    assert(self.m_ViewWarConfigurator == nil, "ViewNewWarCreator:setViewWarConfigurator() the view has been set.")
    self.m_ViewWarConfigurator = view
    self:addChild(view, WAR_CONFIGURATOR_Z_ORDER)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewNewWarCreator:removeAllItems()
    self.m_MenuListView:removeAllItems()

    return self
end

function ViewNewWarCreator:showListWarField(list)
    for _, listItem in ipairs(list) do
        self.m_MenuListView:pushBackCustomItem(createViewMenuItem(listItem))
    end

    self.m_MenuListView:jumpToTop()

    return self
end

function ViewNewWarCreator:createAndPushBackItem(item)
    self.m_MenuListView:pushBackCustomItem(createViewMenuItem(item))

    return self
end

function ViewNewWarCreator:setButtonNextVisible(visible)
    self.m_ButtonNext:setVisible(visible)

    return self
end

function ViewNewWarCreator:setMenuVisible(visible)
    self.m_MenuBackground:setVisible(visible)
    self.m_ButtonBack:setVisible(visible)
    self.m_MenuListView:setVisible(visible)
        :jumpToTop()
    self.m_MenuTitle:setVisible(visible)

    return self
end

return ViewNewWarCreator
