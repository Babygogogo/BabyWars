
local ViewContinueWarSelector = class("ViewContinueWarSelector", cc.Node)

local WAR_CONFIGURATOR_Z_ORDER    = 1
local MENU_TITLE_Z_ORDER          = 1
local MENU_LIST_VIEW_Z_ORDER      = 1
local BUTTON_BACK_Z_ORDER         = 1
local WAR_FIELD_PREVIEWER_Z_ORDER = 1
local BUTTON_NEXT_Z_ORDER         = 1
local MENU_BACKGROUND_Z_ORDER     = 0

local MENU_BACKGROUND_WIDTH       = 250
local MENU_BACKGROUND_HEIGHT      = display.height - 60
local MENU_LIST_VIEW_WIDTH        = MENU_BACKGROUND_WIDTH - 10
local MENU_LIST_VIEW_HEIGHT       = MENU_BACKGROUND_HEIGHT - 14 - 50 - 30
local MENU_LIST_VIEW_ITEMS_MARGIN = 15
local MENU_TITLE_WIDTH            = MENU_BACKGROUND_WIDTH
local MENU_TITLE_HEIGHT           = 40
local BUTTON_NEXT_WIDTH           = display.width - MENU_BACKGROUND_WIDTH - 90
local BUTTON_NEXT_HEIGHT          = 60

local MENU_BACKGROUND_POS_X = 30
local MENU_BACKGROUND_POS_Y = 30
local MENU_LIST_VIEW_POS_X  = MENU_BACKGROUND_POS_X + 5
local MENU_LIST_VIEW_POS_Y  = MENU_BACKGROUND_POS_Y + 6 + 30
local MENU_TITLE_POS_X      = MENU_BACKGROUND_POS_X
local MENU_TITLE_POS_Y      = MENU_BACKGROUND_POS_Y + MENU_BACKGROUND_HEIGHT - 50
local BUTTON_BACK_POS_X     = MENU_LIST_VIEW_POS_X
local BUTTON_BACK_POS_Y     = MENU_BACKGROUND_POS_Y + 6
local BUTTON_NEXT_POS_X     = display.width - BUTTON_NEXT_WIDTH - 30
local BUTTON_NEXT_POS_Y     = MENU_BACKGROUND_POS_Y

local MENU_BACKGROUND_CAPINSETS = {x = 4, y = 6, width = 1, height = 1}
local MENU_TITLE_FONT_COLOR     = {r = 96,  g = 224, b = 88}
local MENU_TITLE_FONT_SIZE      = 28

local ITEM_WIDTH              = 230
local ITEM_HEIGHT             = 55
local ITEM_CAPINSETS          = {x = 1, y = ITEM_HEIGHT, width = 1, height = 1}
local ITEM_FONT_NAME          = "res/fonts/msyhbd.ttc"
local ITEM_FONT_SIZE          = 28
local ITEM_FONT_COLOR         = {r = 255, g = 255, b = 255}
local ITEM_FONT_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local ITEM_FONT_OUTLINE_WIDTH = 2

local WAR_NAME_INDICATOR_FONT_SIZE     = 15
local WAR_NAME_INDICATOR_FONT_COLOR    = {r = 240, g = 80, b = 56}
local WAR_NAME_INDICATOR_OUTLINE_WIDTH = 1

local IN_TURN_INDICATOR_FONT_SIZE     = 15
local IN_TURN_INDICATOR_FONT_COLOR    = {r = 96,  g = 224, b = 88}
local IN_TURN_INDICATOR_OUTLINE_WIDTH = 1

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createSceneWarFileNameIndicator(sceneWarFileName)
    local indicator = cc.Label:createWithTTF(string.sub(sceneWarFileName, 13), ITEM_FONT_NAME, WAR_NAME_INDICATOR_FONT_SIZE)
    indicator:ignoreAnchorPointForPosition(true)

        :setDimensions(ITEM_WIDTH, ITEM_HEIGHT)
        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
        :setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)

        :setTextColor(WAR_NAME_INDICATOR_FONT_COLOR)
        :enableOutline(ITEM_FONT_OUTLINE_COLOR, WAR_NAME_INDICATOR_OUTLINE_WIDTH)

    return indicator
end

local function createIsInTurnIndicator()
    local indicator = cc.Label:createWithTTF("In turn", ITEM_FONT_NAME, IN_TURN_INDICATOR_FONT_SIZE)
    indicator:ignoreAnchorPointForPosition(true)

        :setDimensions(ITEM_WIDTH, ITEM_HEIGHT)
        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
        :setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)

        :setTextColor(IN_TURN_INDICATOR_FONT_COLOR)
        :enableOutline(ITEM_FONT_OUTLINE_COLOR, IN_TURN_INDICATOR_OUTLINE_WIDTH)

        :setOpacity(180)

    return indicator
end

local function createViewMenuItem(item)
    local view = ccui.Button:create()
    view:loadTextureNormal("c03_t06_s01_f01.png", ccui.TextureResType.plistType)

        :setScale9Enabled(true)
        :setCapInsets(ITEM_CAPINSETS)
        :setContentSize(ITEM_WIDTH, ITEM_HEIGHT)

        :setZoomScale(-0.05)

        :setTitleFontName(ITEM_FONT_NAME)
        :setTitleFontSize(ITEM_FONT_SIZE)
        :setTitleColor(ITEM_FONT_COLOR)
        :setTitleText(item.warFieldFileName)

    local titleRenderer = view:getTitleRenderer()
    titleRenderer:enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)
        :setPosition(titleRenderer:getPositionX(), titleRenderer:getPositionY() - 8)

    view:addTouchEventListener(function(sender, eventType)
        if (eventType == ccui.TouchEventType.ended) then
            item.callback()
        end
    end)

    local backgroundRenderer = view:getRendererNormal()
    backgroundRenderer:addChild(createSceneWarFileNameIndicator(item.sceneWarFileName))
    if (item.isInTurn) then
        backgroundRenderer:addChild(createIsInTurnIndicator())
    end

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
    listView:ignoreAnchorPointForPosition(true)
        :setPosition(MENU_LIST_VIEW_POS_X, MENU_LIST_VIEW_POS_Y)
        :setContentSize(MENU_LIST_VIEW_WIDTH, MENU_LIST_VIEW_HEIGHT)

        :setItemsMargin(MENU_LIST_VIEW_ITEMS_MARGIN)
        :setGravity(ccui.ListViewGravity.centerHorizontal)

        :setOpacity(180)
        :setCascadeOpacityEnabled(true)

    self.m_MenuListView = listView
    self:addChild(listView)
end

local function initMenuTitle(self)
    local title = cc.Label:createWithTTF("Continue..", ITEM_FONT_NAME, MENU_TITLE_FONT_SIZE)
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

local function initButtonBack(self)
    local button = ccui.Button:create()
    button:ignoreAnchorPointForPosition(true)
        :setPosition(BUTTON_BACK_POS_X, BUTTON_BACK_POS_Y)

        :setScale9Enabled(true)
        :setContentSize(ITEM_WIDTH, ITEM_HEIGHT)

        :setZoomScale(-0.05)

        :setTitleFontName(ITEM_FONT_NAME)
        :setTitleFontSize(ITEM_FONT_SIZE)
        :setTitleColor({r = 240, g = 80, b = 56})
        :setTitleText("back")

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
        :setTitleFontSize(ITEM_FONT_SIZE)
        :setTitleColor(ITEM_FONT_COLOR)
        :setTitleText("Next...")

        :setVisible(false)

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
function ViewContinueWarSelector:ctor(param)
    initMenuBackground(self)
    initMenuListView(  self)
    initMenuTitle(     self)
    initButtonBack(    self)
    initButtonNext(    self)

    return self
end

function ViewContinueWarSelector:setViewWarFieldPreviewer(view)
    assert(self.m_ViewWarFieldPreviewer == nil, "ViewContinueWarSelector:setViewWarFieldPreviewer() the view has been set.")
    self.m_ViewWarFieldPreviewer = view
    self:addChild(view, WAR_FIELD_PREVIEWER_Z_ORDER)

    return self
end

function ViewContinueWarSelector:setViewWarConfigurator(view)
    assert(self.m_ViewWarConfigurator == nil, "ViewContinueWarSelector:setViewWarConfigurator() the view has been set.")
    self.m_ViewWarConfigurator = view
    self:addChild(view, WAR_CONFIGURATOR_Z_ORDER)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewContinueWarSelector:removeAllItems()
    self.m_MenuListView:removeAllItems()

    return self
end

function ViewContinueWarSelector:showWarList(list)
    for _, listItem in ipairs(list) do
        self.m_MenuListView:pushBackCustomItem(createViewMenuItem(listItem))
    end

    return self
end

function ViewContinueWarSelector:createAndPushBackItem(item)
    self.m_MenuListView:pushBackCustomItem(createViewMenuItem(item))

    return self
end

function ViewContinueWarSelector:setButtonNextVisible(visible)
    self.m_ButtonNext:setVisible(visible)

    return self
end

function ViewContinueWarSelector:setMenuVisible(visible)
    self.m_MenuBackground:setVisible(visible)
    self.m_ButtonBack:setVisible(visible)
    self.m_MenuListView:setVisible(visible)
    self.m_MenuTitle:setVisible(visible)

    return self
end

return ViewContinueWarSelector
