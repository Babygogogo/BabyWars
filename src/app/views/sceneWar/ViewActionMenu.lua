
local ViewActionMenu = class("ViewActionMenu", cc.Node)

local AnimationLoader = require("app.utilities.AnimationLoader")

local MENU_BACKGROUND_WIDTH_FOR_ACTION_ITEM      = 180
local MENU_BACKGROUND_HEIGHT_FOR_ACTION_ITEM     = display.height - 10 - 88 - 140 - 10 -- These are the height of boundary/MoneyEnergyInfo/UnitInfo/boundary.
local MENU_BACKGROUND_WIDTH_FOR_PRODUCTION_ITEM  = 240
local MENU_BACKGROUND_HEIGHT_FOR_PRODUCTION_ITEM = MENU_BACKGROUND_HEIGHT_FOR_ACTION_ITEM

local LEFT_POSITION_X_FOR_ACTION_ITEM     = 10
local LEFT_POSITION_Y_FOR_ACTION_ITEM     = 10 + 140
local LEFT_POSITION_X_FOR_PRODUCTION_ITEM = LEFT_POSITION_X_FOR_ACTION_ITEM
local LEFT_POSITION_Y_FOR_PRODUCTION_ITEM = LEFT_POSITION_Y_FOR_ACTION_ITEM

local RIGHT_POSITION_X_FOR_ACTION_ITEM     = display.width - MENU_BACKGROUND_WIDTH_FOR_ACTION_ITEM - 10
local RIGHT_POSITION_Y_FOR_ACTION_ITEM     = LEFT_POSITION_Y_FOR_ACTION_ITEM
local RIGHT_POSITION_X_FOR_PRODUCTION_ITEM = display.width - MENU_BACKGROUND_WIDTH_FOR_PRODUCTION_ITEM - 10
local RIGHT_POSITION_Y_FOR_PRODUCTION_ITEM = RIGHT_POSITION_Y_FOR_ACTION_ITEM

local LIST_POSITION_X = 5
local LIST_POSITION_Y = 6

local TITLE_FONT_SIZE                   = 25
local TITLE_COLOR                       = {r = 255, g = 255, b = 255}
local TITLE_OUTLINE_COLOR               = {r = 0,   g = 0,   b = 0}
local TITLE_OUTLINE_WIDTH               = 2
local TITLE_FONT_NAME                   = "res/fonts/msyhbd.ttc"
local BUTTON_WIDTH_FOR_ACTION_ITEM      = MENU_BACKGROUND_WIDTH_FOR_ACTION_ITEM - 15
local BUTTON_HEIGHT_FOR_ACTION_ITEM     = TITLE_FONT_SIZE / 5 * 8
local BUTTON_WIDTH_FOR_PRODUCTION_ITEM  = MENU_BACKGROUND_WIDTH_FOR_PRODUCTION_ITEM - 15
local BUTTON_HEIGHT_FOR_PRODUCTION_ITEM = BUTTON_HEIGHT_FOR_ACTION_ITEM
local BUTTON_DISABLED_COLOR             = {r = 180, g = 180, b = 180}
local BUTTON_CAPINSETS                  = {x = 1, y = BUTTON_HEIGHT_FOR_ACTION_ITEM, width = 1, height = 1}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createViewAction(itemModel)
    local view = ccui.Button:create()
    view:loadTextureNormal("c03_t06_s01_f01.png", ccui.TextureResType.plistType)

        :setScale9Enabled(true)
        :setCapInsets(BUTTON_CAPINSETS)
        :setContentSize(BUTTON_WIDTH_FOR_ACTION_ITEM, BUTTON_HEIGHT_FOR_ACTION_ITEM)

        :setZoomScale(-0.05)

        :setTitleFontName(TITLE_FONT_NAME)
        :setTitleFontSize(TITLE_FONT_SIZE)
        :setTitleColor(TITLE_COLOR)
        :setTitleText(itemModel.name)

    view:getTitleRenderer():enableOutline(TITLE_OUTLINE_COLOR, TITLE_OUTLINE_WIDTH)

    view:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            itemModel.callback()
        end
    end)

    return view
end

local function createViewProduction(itemModel)
    local view = ccui.Button:create()
    view:loadTextureNormal("c03_t06_s01_f01.png", ccui.TextureResType.plistType)

        :setScale9Enabled(true)
        :setCapInsets(BUTTON_CAPINSETS)
        :setContentSize(BUTTON_WIDTH_FOR_PRODUCTION_ITEM, BUTTON_HEIGHT_FOR_PRODUCTION_ITEM)

        :setZoomScale(-0.05)

        :setTitleFontName(TITLE_FONT_NAME)
        :setTitleFontSize(20)
        :setTitleColor(TITLE_COLOR)
        :setTitleText("     " .. itemModel.fullName .. "   " .. itemModel.cost)
        :setTitleAlignment(cc.TEXT_ALIGNMENT_LEFT)

    view:getTitleRenderer():setDimensions(BUTTON_WIDTH_FOR_PRODUCTION_ITEM, BUTTON_HEIGHT_FOR_PRODUCTION_ITEM)
        :enableOutline(TITLE_OUTLINE_COLOR, TITLE_OUTLINE_WIDTH)

    local icon = cc.Sprite:create()
    icon:setScale(0.4)
        :ignoreAnchorPointForPosition(true)
        :setPosition(-22, -13)
        :playAnimationForever(AnimationLoader.getUnitAnimationWithTiledId(itemModel.tiledID))
    view:addChild(icon)

    if (not itemModel.isAvaliable) then
        view:setEnabled(false)
            :setColor(BUTTON_DISABLED_COLOR)
    end

    view:addTouchEventListener(function(sender, eventType)
        if (eventType == ccui.TouchEventType.ended) then
            itemModel.callback()
        end
    end)

    return view
end

local function setContentSize(self, width, height)
    self.m_MenuBackground:setContentSize(width, height)
    self.m_ListView:setContentSize(width - 10, height - 14)
end

local function moveToLeftSide(self)
    if (self.m_IsShowingActionList) then
        self:setPosition(LEFT_POSITION_X_FOR_ACTION_ITEM, LEFT_POSITION_Y_FOR_ACTION_ITEM)
    else
        self:setPosition(LEFT_POSITION_X_FOR_PRODUCTION_ITEM, LEFT_POSITION_Y_FOR_PRODUCTION_ITEM)
    end

    self.m_IsInLeftSide = true
end

local function moveToRightSide(self)
    if (self.m_IsShowingActionList) then
        self:setPosition(RIGHT_POSITION_X_FOR_ACTION_ITEM, RIGHT_POSITION_Y_FOR_ACTION_ITEM)
    else
        self:setPosition(RIGHT_POSITION_X_FOR_PRODUCTION_ITEM, RIGHT_POSITION_Y_FOR_PRODUCTION_ITEM)
    end

    self.m_IsInLeftSide = false
end

local function adjustPositionOnShowingList(self, isShowingActionList)
    self.m_IsShowingActionList = isShowingActionList

    if (self.m_IsInLeftSide) then
        moveToLeftSide(self)
    else
        moveToRightSide(self)
    end
end

--------------------------------------------------------------------------------
-- The menu background.
--------------------------------------------------------------------------------
local function createMenuBackground()
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", {x = 4, y = 6, width = 1, height = 1})
    background:ignoreAnchorPointForPosition(true)
        :setContentSize(MENU_BACKGROUND_WIDTH_FOR_ACTION_ITEM, MENU_BACKGROUND_HEIGHT_FOR_ACTION_ITEM)

        :setOpacity(200)

    return background
end

local function initWithMenuBackground(view, background)
    view.m_MenuBackground = background
    view:addChild(background)
end

--------------------------------------------------------------------------------
-- The list view.
--------------------------------------------------------------------------------
local function createListView()
    local listView = ccui.ListView:create()
    listView:ignoreAnchorPointForPosition(true)
        :setPosition(LIST_POSITION_X, LIST_POSITION_Y)

        :setItemsMargin(20)
        :setGravity(ccui.ListViewGravity.centerHorizontal)
        :setCascadeOpacityEnabled(true)

    return listView
end

local function initWithListView(view, listView)
    view.m_ListView = listView
    view:addChild(listView)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewActionMenu:ctor(param)
    initWithMenuBackground(  self, createMenuBackground())
    initWithListView(        self, createListView())

    self:ignoreAnchorPointForPosition(true)
        :setOpacity(200)
        :setVisible(false)

    adjustPositionOnShowingList(self, true)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewActionMenu:showActionList(list)
    setContentSize(self, MENU_BACKGROUND_WIDTH_FOR_ACTION_ITEM, MENU_BACKGROUND_HEIGHT_FOR_ACTION_ITEM)
    adjustPositionOnShowingList(self, true)

    for _, listItem in ipairs(list) do
        self.m_ListView:pushBackCustomItem(createViewAction(listItem))
    end
end

function ViewActionMenu:showProductionList(list)
    setContentSize(self, MENU_BACKGROUND_WIDTH_FOR_PRODUCTION_ITEM, MENU_BACKGROUND_HEIGHT_FOR_PRODUCTION_ITEM)
    adjustPositionOnShowingList(self, false)

    for _, listItem in ipairs(list) do
        self.m_ListView:pushBackCustomItem(createViewProduction(listItem))
    end

    return self
end

function ViewActionMenu:removeAllItems()
    self.m_ListView:removeAllItems()

    return self
end

function ViewActionMenu:setEnabled(enabled)
    self:setVisible(enabled)

    return self
end

function ViewActionMenu:adjustPositionOnTouch(touch)
    local location = touch:getLocation()
    if (location.x > display.width / 2) then
        moveToLeftSide(self)
    else
        moveToRightSide(self)
    end

    return self
end

return ViewActionMenu
