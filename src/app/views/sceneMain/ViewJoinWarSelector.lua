
local ViewJoinWarSelector = class("ViewJoinWarSelector", cc.Node)

local WAR_CONFIGURATOR_Z_ORDER    = 1
local WAR_FIELD_PREVIEWER_Z_ORDER = 1
local MENU_TITLE_Z_ORDER          = 1
local MENU_LIST_VIEW_Z_ORDER      = 1
local BUTTON_FIND_Z_ORDER         = 1
local EDIT_BOX_WAR_NAME_Z_ORDER   = 1
local BUTTON_BACK_Z_ORDER         = 1
local BUTTON_NEXT_Z_ORDER         = 1
local MENU_BACKGROUND_Z_ORDER     = 0

local MENU_BACKGROUND_WIDTH       = 250
local MENU_BACKGROUND_HEIGHT      = display.height - 60
local MENU_TITLE_WIDTH            = MENU_BACKGROUND_WIDTH
local MENU_TITLE_HEIGHT           = 40
local BUTTON_BACK_WIDTH           = 230
local BUTTON_BACK_HEIGHT          = 45
local BUTTON_FIND_WIDTH           = 110
local BUTTON_FIND_HEIGHT          = BUTTON_BACK_HEIGHT
local EDIT_BOX_WAR_NAME_WIDTH     = 110
local EDIT_BOX_WAR_NAME_HEIGHT    = BUTTON_FIND_HEIGHT
local MENU_LIST_VIEW_WIDTH        = MENU_BACKGROUND_WIDTH - 10
local MENU_LIST_VIEW_HEIGHT       = MENU_BACKGROUND_HEIGHT - 14 - MENU_TITLE_HEIGHT - 5 - BUTTON_BACK_HEIGHT - BUTTON_FIND_HEIGHT
local BUTTON_NEXT_WIDTH           = display.width - MENU_BACKGROUND_WIDTH - 90
local BUTTON_NEXT_HEIGHT          = 60

local MENU_BACKGROUND_POS_X   = 30
local MENU_BACKGROUND_POS_Y   = 30
local MENU_TITLE_POS_X        = MENU_BACKGROUND_POS_X
local MENU_TITLE_POS_Y        = MENU_BACKGROUND_POS_Y + MENU_BACKGROUND_HEIGHT - 50
local BUTTON_BACK_POS_X       = MENU_BACKGROUND_POS_X + 10
local BUTTON_BACK_POS_Y       = MENU_BACKGROUND_POS_Y + 6
local BUTTON_FIND_POS_X       = BUTTON_BACK_POS_X
local BUTTON_FIND_POS_Y       = BUTTON_BACK_POS_Y + BUTTON_BACK_HEIGHT
local EDIT_BOX_WAR_NAME_POS_X = BUTTON_FIND_POS_X + BUTTON_FIND_WIDTH
local EDIT_BOX_WAR_NAME_POS_Y = BUTTON_FIND_POS_Y
local MENU_LIST_VIEW_POS_X    = BUTTON_BACK_POS_X
local MENU_LIST_VIEW_POS_Y    = BUTTON_FIND_POS_Y + BUTTON_FIND_HEIGHT
local BUTTON_NEXT_POS_X       = display.width - BUTTON_NEXT_WIDTH - 30
local BUTTON_NEXT_POS_Y       = MENU_BACKGROUND_POS_Y

local MENU_BACKGROUND_CAPINSETS = {x = 4, y = 6, width = 1, height = 1}
local MENU_TITLE_FONT_COLOR     = {r = 96,  g = 224, b = 88}
local MENU_TITLE_FONT_SIZE      = 28

local MENU_LIST_VIEW_ITEMS_MARGIN = 15
local ITEM_WIDTH                  = 230
local ITEM_HEIGHT                 = 55
local ITEM_CAPINSETS              = {x = 1, y = ITEM_HEIGHT, width = 1, height = 1}
local ITEM_FONT_NAME              = "res/fonts/msyhbd.ttc"
local ITEM_FONT_SIZE              = 28
local ITEM_FONT_COLOR             = {r = 255, g = 255, b = 255}
local ITEM_FONT_OUTLINE_COLOR     = {r = 0, g = 0, b = 0}
local ITEM_FONT_OUTLINE_WIDTH     = 2

local WAR_NAME_INDICATOR_FONT_SIZE     = 15
local WAR_NAME_INDICATOR_FONT_COLOR    = {r = 240, g = 80, b = 56}
local WAR_NAME_INDICATOR_OUTLINE_WIDTH = 1

local EDIT_BOX_TEXTURE_NAME = "c03_t06_s01_f01.png"
local EDIT_BOX_CAPINSETS    = {x = 1, y = EDIT_BOX_WAR_NAME_HEIGHT - 7, width = 1, height = 1}
local EDIT_BOX_FONT_SIZE    = 28

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
        :setTitleText(item.warFieldName)

    local titleRenderer = view:getTitleRenderer()
    titleRenderer:enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)
        :setPosition(titleRenderer:getPositionX(), titleRenderer:getPositionY() - 8)

    view:addTouchEventListener(function(sender, eventType)
        if (eventType == ccui.TouchEventType.ended) then
            item.callback()
        end
    end)

    view:getRendererNormal():addChild(createSceneWarFileNameIndicator(item.sceneWarFileName))

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

    self.m_MenuListView = listView
    self:addChild(listView)
end

local function initMenuTitle(self)
    local title = cc.Label:createWithTTF("Join..", "res/fonts/msyhbd.ttc", MENU_TITLE_FONT_SIZE)
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

local function initButtonFind(self)
    local button = ccui.Button:create()
    button:ignoreAnchorPointForPosition(true)
        :setPosition(BUTTON_FIND_POS_X, BUTTON_FIND_POS_Y)

        :setScale9Enabled(true)
        :setContentSize(BUTTON_FIND_WIDTH, BUTTON_FIND_HEIGHT)

        :setZoomScale(-0.05)

        :setTitleFontName(ITEM_FONT_NAME)
        :setTitleFontSize(ITEM_FONT_SIZE)
        :setTitleColor(MENU_TITLE_FONT_COLOR)
        :setTitleText("find:")

        :addTouchEventListener(function(sender, eventType)
            if ((eventType == ccui.TouchEventType.ended) and (self.m_Model)) then
                self.m_Model:onButtonFindTouched(self.m_EditBoxWarName:getText())
            end
        end)

    button:getTitleRenderer():enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    self.m_ButtonFind = button
    self:addChild(button, BUTTON_FIND_Z_ORDER)
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

local function initEditBoxWarName(self)
    local background = cc.Scale9Sprite:createWithSpriteFrameName(EDIT_BOX_TEXTURE_NAME, EDIT_BOX_CAPINSETS)
    local editBox = ccui.EditBox:create(cc.size(EDIT_BOX_WAR_NAME_WIDTH, EDIT_BOX_WAR_NAME_HEIGHT), background, background, background)
    editBox:ignoreAnchorPointForPosition(true)
        :setPosition(EDIT_BOX_WAR_NAME_POS_X, EDIT_BOX_WAR_NAME_POS_Y)
        :setFontSize(EDIT_BOX_FONT_SIZE)
        :setFontColor({r = 0, g = 0, b = 0})

        :setPlaceholderFontSize(EDIT_BOX_FONT_SIZE)
        :setPlaceHolder("War ID")

        :setMaxLength(4)
        :setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
        :setInputFlag(cc.EDITBOX_INPUT_FLAG_SENSITIVE)

    self.m_EditBoxWarName = editBox
    self:addChild(editBox, EDIT_BOX_WAR_NAME_Z_ORDER)
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
function ViewJoinWarSelector:ctor(param)
    initMenuBackground(self)
    initMenuListView(  self)
    initMenuTitle(     self)
    initButtonFind(    self)
    initEditBoxWarName(self)
    initButtonBack(    self)
    initButtonNext(    self)

    return self
end

function ViewJoinWarSelector:setViewWarFieldPreviewer(view)
    assert(self.m_ViewWarFieldPreviewer == nil, "ViewJoinWarSelector:setViewWarFieldPreviewer() the view has been set.")
    self.m_ViewWarFieldPreviewer = view
    self:addChild(view, WAR_FIELD_PREVIEWER_Z_ORDER)

    return self
end

function ViewJoinWarSelector:setViewWarConfigurator(view)
    assert(self.m_ViewWarConfigurator == nil, "ViewJoinWarSelector:setViewWarConfigurator() the view has been set.")
    self.m_ViewWarConfigurator = view
    self:addChild(view, WAR_CONFIGURATOR_Z_ORDER)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewJoinWarSelector:removeAllItems()
    self.m_MenuListView:removeAllItems()

    return self
end

function ViewJoinWarSelector:showWarList(list)
    for _, listItem in ipairs(list) do
        self.m_MenuListView:pushBackCustomItem(createViewMenuItem(listItem))
    end

    self.m_MenuListView:jumpToTop()
    return self
end

function ViewJoinWarSelector:createAndPushBackItem(item)
    self.m_MenuListView:pushBackCustomItem(createViewMenuItem(item))

    return self
end

function ViewJoinWarSelector:setMenuVisible(visible)
    self.m_MenuBackground:setVisible(visible)
    self.m_ButtonBack:setVisible(visible)
    self.m_MenuListView:setVisible(visible)
        :jumpToTop()
    self.m_MenuTitle:setVisible(visible)
    self.m_ButtonFind:setVisible(visible)
    self.m_EditBoxWarName:setVisible(visible)
        :setText("")

    return self
end

function ViewJoinWarSelector:setButtonNextVisible(visible)
    self.m_ButtonNext:setVisible(visible)

    return self
end

return ViewJoinWarSelector
