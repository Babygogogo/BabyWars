
local ViewActionMenu = class("ViewActionMenu", cc.Node)

local AnimationLoader       = require("app.utilities.AnimationLoader")
local LocalizationFunctions = require("app.utilities.LocalizationFunctions")

local MENU_BACKGROUND_WIDTH_FOR_ACTION_ITEM      = 150
local MENU_BACKGROUND_HEIGHT_FOR_ACTION_ITEM     = display.height - 10 - 104 - 130 - 10 -- These are the height of boundary/MoneyEnergyInfo/UnitInfo/boundary.
local MENU_BACKGROUND_WIDTH_FOR_PRODUCTION_ITEM  = 210
local MENU_BACKGROUND_HEIGHT_FOR_PRODUCTION_ITEM = MENU_BACKGROUND_HEIGHT_FOR_ACTION_ITEM
local MENU_BACKGROUND_CAPINSETS                  = {x = 4, y = 6, width = 1, height = 1}

local LEFT_POS_X_FOR_ACTION_ITEM     = 10
local LEFT_POS_Y_FOR_ACTION_ITEM     = 10 + 130
local LEFT_POS_X_FOR_PRODUCTION_ITEM = LEFT_POS_X_FOR_ACTION_ITEM
local LEFT_POS_Y_FOR_PRODUCTION_ITEM = LEFT_POS_Y_FOR_ACTION_ITEM

local RIGHT_POS_X_FOR_ACTION_ITEM     = display.width - MENU_BACKGROUND_WIDTH_FOR_ACTION_ITEM - 10
local RIGHT_POS_Y_FOR_ACTION_ITEM     = LEFT_POS_Y_FOR_ACTION_ITEM
local RIGHT_POS_X_FOR_PRODUCTION_ITEM = display.width - MENU_BACKGROUND_WIDTH_FOR_PRODUCTION_ITEM - 10
local RIGHT_POS_Y_FOR_PRODUCTION_ITEM = RIGHT_POS_Y_FOR_ACTION_ITEM

local LIST_VIEW_POS_X        = 0
local LIST_VIEW_POS_Y        = 6
local LIST_VIEW_ITEMS_MARGIN = 10

local ITEM_FONT_NAME          = "res/fonts/msyhbd.ttc"
local ITEM_FONT_SIZE          = 25
local ITEM_FONT_COLOR         = {r = 255, g = 255, b = 255}
local ITEM_FONT_OUTLINE_COLOR = {r = 0,   g = 0,   b = 0}
local ITEM_FONT_OUTLINE_WIDTH = 2
local ITEM_DISABLED_COLOR     = {r = 180, g = 180, b = 180}

local ITEM_ACTION_WIDTH     = MENU_BACKGROUND_WIDTH_FOR_ACTION_ITEM - 20
local ITEM_ACTION_HEIGHT    = 50
local ITEM_ACTION_CAPINSETS = {x = 1, y = ITEM_ACTION_HEIGHT, width = 1, height = 1}

local ITEM_PRODUCTION_WIDTH     = MENU_BACKGROUND_WIDTH_FOR_PRODUCTION_ITEM - 20
local ITEM_PRODUCTION_HEIGHT    = 60
local ITEM_PRODUCTION_CAPINSETS = {x = 1, y = ITEM_PRODUCTION_HEIGHT, width = 1, height = 1}

local BUTTON_CONFIRM_FONT_COLOR = {r = 96,  g = 224, b = 88}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function setAllButtomConfirmEnabled(self, enabled)
    for _, item in pairs(self.m_ListView:getItems()) do
        item:setButtonConfirmEnabled(enabled)
    end
end

local function createViewAction(itemModel)
    local label = cc.Label:createWithTTF(itemModel.name, ITEM_FONT_NAME, ITEM_FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)

        :setDimensions(ITEM_ACTION_WIDTH, ITEM_ACTION_HEIGHT)
        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
        :setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM)

        :setTextColor(ITEM_FONT_COLOR)
        :enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    local view = ccui.Button:create()
    view:loadTextureNormal("c03_t06_s01_f01.png", ccui.TextureResType.plistType)

        :setScale9Enabled(true)
        :setCapInsets(ITEM_ACTION_CAPINSETS)
        :setContentSize(ITEM_ACTION_WIDTH, ITEM_ACTION_HEIGHT)

        :setZoomScale(-0.05)

        :addTouchEventListener(function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                itemModel.callback()
            end
        end)
    view:getRendererNormal():addChild(label)

    return view
end

local function createProductionIcon(tiledID)
    local icon = cc.Sprite:create()
    icon:setScale(0.5)
        :ignoreAnchorPointForPosition(true)
        :setPosition(-18, -13)
        :playAnimationForever(AnimationLoader.getUnitAnimationWithTiledId(tiledID))

    return icon
end

local function createProductionLabel(name, cost)
    local label = cc.Label:createWithTTF(name .. "\n" .. cost, ITEM_FONT_NAME, 20)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(38, 0)

        :setDimensions(ITEM_PRODUCTION_WIDTH - 38, ITEM_PRODUCTION_HEIGHT)
        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
        :setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM)

        :enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    return label
end

local function createProductionConfirmButton(callback)
    local button = ccui.Button:create()
    button:setScale9Enabled(true)
        :setContentSize(60, ITEM_PRODUCTION_HEIGHT)

        :ignoreAnchorPointForPosition(true)
        :setPosition(ITEM_PRODUCTION_WIDTH - 60, 0)

        :setVisible(false)

        :setZoomScale(-0.05)

        :setTitleFontName(ITEM_FONT_NAME)
        :setTitleFontSize(25)
        :setTitleColor(BUTTON_CONFIRM_FONT_COLOR)
        :setTitleText(LocalizationFunctions.getLocalizedText(79))

        :addTouchEventListener(function(sender, eventType)
            if (eventType == ccui.TouchEventType.ended) then
                callback()
            end
        end)

    button:getTitleRenderer():enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    return button
end

local function createViewProduction(self, modelItem)
    local view = ccui.Button:create()
    view:loadTextureNormal("c03_t06_s01_f01.png", ccui.TextureResType.plistType)

        :setScale9Enabled(true)
        :setCapInsets(ITEM_PRODUCTION_CAPINSETS)
        :setContentSize(ITEM_PRODUCTION_WIDTH, ITEM_PRODUCTION_HEIGHT)

        :setCascadeColorEnabled(true)
        :setZoomScale(-0.05)

        :addTouchEventListener(function(sender, eventType)
            if (eventType == ccui.TouchEventType.ended) then
                setAllButtomConfirmEnabled(self, false)
                view:setButtonConfirmEnabled(true)
            end
        end)

    view:getRendererNormal():addChild(createProductionIcon(modelItem.tiledID))
        :addChild(createProductionLabel(modelItem.modelUnit:getUnitTypeFullName(), modelItem.cost))

        :setCascadeColorEnabled(true)

    view.m_ButtonConfirm = createProductionConfirmButton(modelItem.callback)
    view:addChild(view.m_ButtonConfirm)

    view.setButtonConfirmEnabled = function(self, enabled)
        self.m_ButtonConfirm:setVisible(enabled)
    end

    if (not modelItem.isAvaliable) then
        view:setEnabled(false)
            :setColor(ITEM_DISABLED_COLOR)
    end

    return view
end

local function setContentSize(self, width, height)
    self.m_MenuBackground:setContentSize(width, height)
    self.m_ListView:setContentSize(width, height - 14)
end

local function moveToLeftSide(self)
    if (self.m_IsShowingActionList) then
        self:setPosition(LEFT_POS_X_FOR_ACTION_ITEM, LEFT_POS_Y_FOR_ACTION_ITEM)
    else
        self:setPosition(LEFT_POS_X_FOR_PRODUCTION_ITEM, LEFT_POS_Y_FOR_PRODUCTION_ITEM)
    end

    self.m_IsInLeftSide = true
end

local function moveToRightSide(self)
    if (self.m_IsShowingActionList) then
        self:setPosition(RIGHT_POS_X_FOR_ACTION_ITEM, RIGHT_POS_Y_FOR_ACTION_ITEM)
    else
        self:setPosition(RIGHT_POS_X_FOR_PRODUCTION_ITEM, RIGHT_POS_Y_FOR_PRODUCTION_ITEM)
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
-- The composition elements.
--------------------------------------------------------------------------------
local function initMenuBackground(self)
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", MENU_BACKGROUND_CAPINSETS)
    background:ignoreAnchorPointForPosition(true)
        :setContentSize(MENU_BACKGROUND_WIDTH_FOR_ACTION_ITEM, MENU_BACKGROUND_HEIGHT_FOR_ACTION_ITEM)

        :setOpacity(200)

    self.m_MenuBackground = background
    self:addChild(background)
end

local function initMenuListView(self)
    local listView = ccui.ListView:create()
    listView:ignoreAnchorPointForPosition(true)
        :setPosition(LIST_VIEW_POS_X, LIST_VIEW_POS_Y)

        :setItemsMargin(LIST_VIEW_ITEMS_MARGIN)
        :setGravity(ccui.ListViewGravity.centerHorizontal)

    self.m_ListView = listView
    self:addChild(listView)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewActionMenu:ctor(param)
    initMenuBackground(self)
    initMenuListView(  self)

    self:ignoreAnchorPointForPosition(true)
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
        self.m_ListView:pushBackCustomItem(createViewProduction(self, listItem))
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
