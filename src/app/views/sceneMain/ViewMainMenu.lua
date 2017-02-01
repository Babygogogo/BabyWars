
local ViewMainMenu = class("ViewMainMenu", cc.Node)

local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")

local NEW_GAME_CREATOR_Z_ORDER       = 3
local CONTINUE_GAME_SELECTOR_Z_ORDER = 3
local JOIN_WAR_SELECTOR_Z_ORDER      = 3
local SKILL_CONFIGURATOR_Z_ORDER     = 3
local REPLAY_MANAGER_Z_ORDER         = 3
local LOGIN_PANEL_Z_ORDER            = 3
local GAME_HELPER_Z_ORDER            = 3
local GAME_RECORD_VIEWER_Z_ORDER     = 3
local MENU_TITLE_Z_ORDER             = 2
local MENU_LIST_VIEW_Z_ORDER         = 1
local BUTTON_EXIT_Z_ORDER            = 1
local MENU_BACKGROUND_Z_ORDER        = 0

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

local BUTTON_EXIT_WIDTH  = MENU_BACKGROUND_WIDTH
local BUTTON_EXIT_HEIGHT = 50
local BUTTON_EXIT_POS_X  = MENU_BACKGROUND_POS_X
local BUTTON_EXIT_POS_Y  = MENU_BACKGROUND_POS_Y

local MENU_LIST_VIEW_WIDTH        = MENU_BACKGROUND_WIDTH
local MENU_LIST_VIEW_HEIGHT       = MENU_TITLE_POS_Y - BUTTON_EXIT_POS_Y - BUTTON_EXIT_HEIGHT
local MENU_LIST_VIEW_POS_X        = MENU_BACKGROUND_POS_X
local MENU_LIST_VIEW_POS_Y        = BUTTON_EXIT_POS_Y + BUTTON_EXIT_HEIGHT
local MENU_LIST_VIEW_ITEMS_MARGIN = 10

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
        :setItemsMargin(MENU_LIST_VIEW_ITEMS_MARGIN)
        :setGravity(ccui.ListViewGravity.centerHorizontal)

    self.m_MenuListView = listView
    self:addChild(listView, MENU_LIST_VIEW_Z_ORDER)
end

local function initMenuTitle(self)
    local title = cc.Label:createWithTTF(LocalizationFunctions.getLocalizedText(1, "MainMenu"), ITEM_FONT_NAME, MENU_TITLE_FONT_SIZE)
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

local function initButtonExit(self)
    local button = ccui.Button:create()
    button:ignoreAnchorPointForPosition(true)
        :setPosition(BUTTON_EXIT_POS_X, BUTTON_EXIT_POS_Y)

        :setScale9Enabled(true)
        :setContentSize(BUTTON_EXIT_WIDTH, BUTTON_EXIT_HEIGHT)

        :setZoomScale(-0.05)

        :setTitleFontName(ITEM_FONT_NAME)
        :setTitleFontSize(ITEM_FONT_SIZE)
        :setTitleColor({r = 240, g = 80, b = 56})
        :setTitleText(LocalizationFunctions.getLocalizedText(1, "Exit"))

        :addTouchEventListener(function(sender, eventType)
            if ((eventType == ccui.TouchEventType.ended) and (self.m_Model)) then
                self.m_Model:onButtonExitTouched()
            end
        end)

    button:getTitleRenderer():enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    self.m_ButtonExit = button
    self:addChild(button, BUTTON_EXIT_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewMainMenu:ctor(param)
    initMenuBackground(self)
    initMenuListView(  self)
    initMenuTitle(     self)
    initButtonExit(    self)

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

function ViewMainMenu:setViewSkillConfigurator(view)
    assert(self.m_ViewSkillConfigurator == nil, "ViewMainMenu:setViewSkillConfigurator() the view has been set already.")
    self.m_ViewSkillConfigurator = view
    self:addChild(view, SKILL_CONFIGURATOR_Z_ORDER)

    return self
end

function ViewMainMenu:setViewReplayManager(view)
    assert(self.m_ViewReplayManager == nil, "ViewMainMenu:setViewReplayManager() the view has been set already.")
    self.m_ViewReplayManager = view
    self:addChild(view, REPLAY_MANAGER_Z_ORDER)

    return self
end

function ViewMainMenu:setViewLoginPanel(view)
    assert(self.m_ViewLoginPanel == nil, "ViewMainMenu:setViewLoginPanel() the view has been set.")
    self.m_ViewLoginPanel = view
    self:addChild(view, LOGIN_PANEL_Z_ORDER)

    return self
end

function ViewMainMenu:setViewGameHelper(view)
    assert(self.m_ViewGameHelper == nil, "ViewMainMenu:setViewGameHelper() the view has been set.")
    self.m_ViewGameHelper = view
    self:addChild(view, GAME_HELPER_Z_ORDER)

    return self
end

function ViewMainMenu:setViewGameRecordViewer(view)
    assert(self.m_ViewGameRecordViewer == nil, "ViewMainMenu:setViewGameRecordViewer() the view has been set already.")
    self.m_ViewGameRecordViewer = view
    self:addChild(view, GAME_RECORD_VIEWER_Z_ORDER)

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

function ViewMainMenu:setItems(items)
    local listView = self.m_MenuListView
    listView:removeAllItems()

    for _, item in ipairs(items) do
        listView:pushBackCustomItem(createViewItem(item))
    end

    return self
end

function ViewMainMenu:setMenuVisible(visible)
    self.m_MenuBackground:setVisible(visible)
    self.m_MenuListView  :setVisible(visible)
    self.m_MenuTitle     :setVisible(visible)
    self.m_ButtonExit    :setVisible(visible)

    return self
end

function ViewMainMenu:setMenuTitleText(text)
    self.m_MenuTitle:setString(text)

    return self
end

function ViewMainMenu:setButtonExitText(text)
    self.m_ButtonExit:setTitleText(text)

    return self
end

return ViewMainMenu
