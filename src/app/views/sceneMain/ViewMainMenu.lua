
local ViewMainMenu = class("ViewMainMenu", cc.Node)

local NEW_GAME_CREATOR_Z_ORDER       = 3
local CONTINUE_GAME_SELECTOR_Z_ORDER = 3
local JOIN_WAR_SELECTOR_Z_ORDER      = 3
local LOGIN_PANEL_Z_ORDER            = 3
local MENU_TITLE_Z_ORDER             = 2
local MENU_LIST_VIEW_Z_ORDER         = 1
local MENU_BACKGROUND_Z_ORDER        = 0

local MENU_BACKGROUND_WIDTH  = 250
local MENU_BACKGROUND_HEIGHT = display.height - 60
local MENU_LIST_VIEW_WIDTH   = MENU_BACKGROUND_WIDTH - 10
local MENU_LIST_VIEW_HEIGHT  = MENU_BACKGROUND_HEIGHT - 14 - 50
local MENU_TITLE_WIDTH       = MENU_BACKGROUND_WIDTH
local MENU_TITLE_HEIGHT      = 40

local MENU_BACKGROUND_POS_X = 30
local MENU_BACKGROUND_POS_Y = 30
local MENU_LIST_VIEW_POS_X  = MENU_BACKGROUND_POS_X + 5
local MENU_LIST_VIEW_POS_Y  = MENU_BACKGROUND_POS_Y + 6
local MENU_TITLE_POS_X      = MENU_BACKGROUND_POS_X
local MENU_TITLE_POS_Y      = MENU_BACKGROUND_POS_Y + MENU_BACKGROUND_HEIGHT - 50

local MENU_TITLE_FONT_COLOR = {r = 96,  g = 224, b = 88}
local MENU_TITLE_FONT_SIZE  = 28

local ITEM_WIDTH              = 230
local ITEM_HEIGHT             = 45
local ITEM_CAPINSETS          = {x = 1, y = ITEM_HEIGHT, width = 1, height = 1}
local ITEM_FONT_NAME          = "res/fonts/msyhbd.ttc"
local ITEM_FONT_SIZE          = 28
local ITEM_FONT_COLOR         = {r = 255, g = 255, b = 255}
local ITEM_FONT_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local ITEM_FONT_OUTLINE_WIDTH = 2

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createViewItem(item)
    local view = ccui.Button:create()
    view:loadTextureNormal("c03_t06_s01_f01.png", ccui.TextureResType.plistType)

        :setScale9Enabled(true)
        :setCapInsets(ITEM_CAPINSETS)
        :setContentSize(ITEM_WIDTH, ITEM_HEIGHT)

        :setZoomScale(-0.05)

        :setTitleFontName(ITEM_FONT_NAME)
        :setTitleFontSize(ITEM_FONT_SIZE)
        :setTitleColor(ITEM_FONT_COLOR)
        :setTitleText(item.name)

    view:getTitleRenderer():enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    view:addTouchEventListener(function(sender, eventType)
        if (eventType == ccui.TouchEventType.ended) then
            item.callback()
        end
    end)

    return view
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initMenuBackground(self)
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", {x = 4, y = 6, width = 1, height = 1})
    background:ignoreAnchorPointForPosition(true)
        :setPosition(MENU_BACKGROUND_POS_X, MENU_BACKGROUND_POS_Y)
        :setContentSize(MENU_BACKGROUND_WIDTH, MENU_BACKGROUND_HEIGHT)
        :setOpacity(180)

    self.m_MenuBackground = background
    self:addChild(background, MENU_BACKGROUND_Z_ORDER)
end

local function initMenuListView(self)
    local listView = ccui.ListView:create()
    listView:ignoreAnchorPointForPosition(true)
        :setPosition(MENU_LIST_VIEW_POS_X, MENU_LIST_VIEW_POS_Y)
        :setContentSize(MENU_LIST_VIEW_WIDTH, MENU_LIST_VIEW_HEIGHT)
        :setItemsMargin(15)
        :setGravity(ccui.ListViewGravity.centerHorizontal)
        :setCascadeOpacityEnabled(true)
        :setOpacity(180)

    self.m_MenuListView = listView
    self:addChild(listView, MENU_LIST_VIEW_Z_ORDER)
end

local function initMenuTitle(self)
    local title = cc.Label:createWithTTF("Main Menu", "res/fonts/msyhbd.ttc", MENU_TITLE_FONT_SIZE)
    title:ignoreAnchorPointForPosition(true)
        :setPosition(MENU_TITLE_POS_X, MENU_TITLE_POS_Y)

        :setDimensions(MENU_TITLE_WIDTH, MENU_TITLE_HEIGHT)
        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
        :setVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)

        :setTextColor(MENU_TITLE_FONT_COLOR)
        :enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

        :setOpacity(180)

    self.m_MenuTitle = title
    self:addChild(title, MENU_TITLE_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewMainMenu:ctor(param)
    initMenuBackground(self)
    initMenuListView(  self)
    initMenuTitle(     self)

    return self
end

function ViewMainMenu:setViewNewWarCreator(view)
    assert(self.m_ViewNewWarCreator == nil, "ViewMainMenu:setViewNewWarCreator() the view has been set.")
    self.m_ViewNewWarCreator = view
    self:addChild(view, NEW_GAME_CREATOR_Z_ORDER)

    return self
end

function ViewMainMenu:setViewContinueWarSelector(view)
    assert(self.m_ViewContinueWarSelector == nil, "ViewMainMenu:setViewContinueWarSelector() the view has been set.")
    self.m_ViewContinueWarSelector = view
    self:addChild(view, CONTINUE_GAME_SELECTOR_Z_ORDER)

    return self
end

function ViewMainMenu:setViewJoinWarSelector(view)
    assert(self.m_ViewJoinWarSelector == nil, "ViewMainMenu:setViewJoinWarSelector() the view has been set.")
    self.m_ViewJoinWarSelector = view
    self:addChild(view, JOIN_WAR_SELECTOR_Z_ORDER)

    return self
end

function ViewMainMenu:setViewLoginPanel(view)
    assert(self.m_ViewLoginPanel == nil, "ViewMainMenu:setViewLoginPanel() the view has been set.")
    self.m_ViewLoginPanel = view
    self:addChild(view, LOGIN_PANEL_Z_ORDER)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewMainMenu:removeAllItems()
    self.m_MenuListView:removeAllItems()

    return self
end

function ViewMainMenu:createAndPushBackItem(item)
    self.m_MenuListView:pushBackCustomItem(createViewItem(item))

    return self
end

function ViewMainMenu:setMenuVisible(visible)
    self.m_MenuBackground:setVisible(visible)
    self.m_MenuListView  :setVisible(visible)
    self.m_MenuTitle     :setVisible(visible)

    return self
end

return ViewMainMenu
