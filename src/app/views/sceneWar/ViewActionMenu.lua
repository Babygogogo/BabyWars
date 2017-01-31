
local ViewActionMenu = class("ViewActionMenu", cc.Node)

local AnimationLoader       = require("src.app.utilities.AnimationLoader")
local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")

local MENU_BACKGROUND_WIDTH_FOR_ACTION_ITEM      = 210
local MENU_BACKGROUND_HEIGHT_FOR_ACTION_ITEM     = display.height - 10 - 93 - 130 - 10 -- These are the height of boundary/MoneyEnergyInfo/UnitInfo/boundary.
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

local ITEM_FONT_NAME          = "res/fonts/msyhbd.ttc"
local ITEM_FONT_SIZE_SMALL    = 16
local ITEM_FONT_SIZE_LARGE    = 25
local ITEM_FONT_COLOR         = {r = 255, g = 255, b = 255}
local ITEM_FONT_OUTLINE_COLOR = {r = 0,   g = 0,   b = 0}
local ITEM_FONT_OUTLINE_WIDTH = 2
local ITEM_DISABLED_COLOR     = {r = 180, g = 180, b = 180}

local ITEM_WIDTH_FOR_ACTION  = MENU_BACKGROUND_WIDTH_FOR_ACTION_ITEM - 20
local ITEM_HEIGHT_FOR_ACTION = 60
local ITEM_ACTION_CAPINSETS  = {x = 1, y = ITEM_HEIGHT_FOR_ACTION, width = 1, height = 1}

local ITEM_PRODUCTION_WIDTH     = MENU_BACKGROUND_WIDTH_FOR_PRODUCTION_ITEM - 20
local ITEM_PRODUCTION_HEIGHT    = 60
local ITEM_PRODUCTION_CAPINSETS = {x = 1, y = ITEM_PRODUCTION_HEIGHT, width = 1, height = 1}

local LIST_VIEW_ITEMS_MARGIN         = 20
local LIST_VIEW_POS_X_FOR_ACTION     = 0
local LIST_VIEW_POS_Y_FOR_ACTION     = 6 + ITEM_HEIGHT_FOR_ACTION + LIST_VIEW_ITEMS_MARGIN
local LIST_VIEW_POS_X_FOR_PRODUCTION = 0
local LIST_VIEW_POS_Y_FOR_PRODUCTION = 6

local BUTTON_CONFIRM_FONT_COLOR = {r = 96,  g = 224, b = 88}
local BUTTON_WAIT_POS_X         = (MENU_BACKGROUND_WIDTH_FOR_ACTION_ITEM - ITEM_WIDTH_FOR_ACTION) / 2
local BUTTON_WAIT_POS_Y         = 15

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function setAllButtomConfirmEnabled(self, enabled)
    for _, item in pairs(self.m_ListView:getItems()) do
        item:setButtonConfirmEnabled(enabled)
    end
end

local function createViewAction(itemModel)
    local text     = itemModel.name
    local fontSize = (string.len(text) >= 10) and (ITEM_FONT_SIZE_SMALL) or (ITEM_FONT_SIZE_LARGE)
    local label    = cc.Label:createWithTTF(text, ITEM_FONT_NAME, fontSize)
    label:ignoreAnchorPointForPosition(true)

        :setDimensions(ITEM_WIDTH_FOR_ACTION, ITEM_HEIGHT_FOR_ACTION)
        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
        :setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM)

        :setTextColor(ITEM_FONT_COLOR)
        :enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    local view = ccui.Button:create()
    view:loadTextureNormal("c03_t06_s01_f01.png", ccui.TextureResType.plistType)

        :setScale9Enabled(true)
        :setCapInsets(ITEM_ACTION_CAPINSETS)
        :setContentSize(ITEM_WIDTH_FOR_ACTION, ITEM_HEIGHT_FOR_ACTION)

        :setZoomScale(-0.05)

        :addTouchEventListener(function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                itemModel.callback()
            end
        end)

    local renderer = view:getRendererNormal()
    renderer:addChild(label)
    if (itemModel.icon) then
        renderer:addChild(itemModel.icon)
    end

    if ((itemModel.isAvailable ~= nil) and (not itemModel.isAvailable)) then
        renderer:setCascadeColorEnabled(true)
        view:setCascadeColorEnabled(true)
            :setEnabled(false)
            :setColor(ITEM_DISABLED_COLOR)
    end

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

    if (not modelItem.isAvailable) then
        view:setEnabled(false)
            :setColor(ITEM_DISABLED_COLOR)
    end

    return view
end

local function clearButtonWait(self)
    if (self.m_ButtonWait) then
        self.m_ButtonWait:removeFromParent()
        self.m_ButtonWait = nil
    end
end

local function resetForViewingActions(self, hasItemWait)
    self.m_MenuBackground:setContentSize(MENU_BACKGROUND_WIDTH_FOR_ACTION_ITEM, MENU_BACKGROUND_HEIGHT_FOR_ACTION_ITEM)
    if (hasItemWait) then
        self.m_ListView:setContentSize(MENU_BACKGROUND_WIDTH_FOR_ACTION_ITEM, MENU_BACKGROUND_HEIGHT_FOR_ACTION_ITEM - ITEM_HEIGHT_FOR_ACTION - LIST_VIEW_ITEMS_MARGIN - 10)
            :setPosition(LIST_VIEW_POS_X_FOR_ACTION, LIST_VIEW_POS_Y_FOR_ACTION)
    else
        self.m_ListView:setContentSize(MENU_BACKGROUND_WIDTH_FOR_PRODUCTION_ITEM, MENU_BACKGROUND_HEIGHT_FOR_PRODUCTION_ITEM - 14)
            :setPosition(LIST_VIEW_POS_X_FOR_PRODUCTION, LIST_VIEW_POS_Y_FOR_PRODUCTION)
    end
    clearButtonWait(self)
end

local function resetForViewingProductions(self)
    self.m_MenuBackground:setContentSize(MENU_BACKGROUND_WIDTH_FOR_PRODUCTION_ITEM, MENU_BACKGROUND_HEIGHT_FOR_PRODUCTION_ITEM)
    self.m_ListView      :setContentSize(MENU_BACKGROUND_WIDTH_FOR_PRODUCTION_ITEM, MENU_BACKGROUND_HEIGHT_FOR_PRODUCTION_ITEM - 14)
                         :setPosition(LIST_VIEW_POS_X_FOR_PRODUCTION, LIST_VIEW_POS_Y_FOR_PRODUCTION)
    clearButtonWait(self)
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

local function resetBackground(background, playerIndex)
    background:initWithSpriteFrameName("c03_t01_s0" .. playerIndex .. "_f01.png", MENU_BACKGROUND_CAPINSETS)
    background:ignoreAnchorPointForPosition(true)
        :setOpacity(200)
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initMenuBackground(self)
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", MENU_BACKGROUND_CAPINSETS)
    resetBackground(background, 1)

    self.m_MenuBackground = background
    self:addChild(background)
end

local function initMenuListView(self)
    local listView = ccui.ListView:create()
    listView:ignoreAnchorPointForPosition(true)
        :setPosition(LIST_VIEW_POS_X_FOR_PRODUCTION, LIST_VIEW_POS_Y_FOR_PRODUCTION)

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
function ViewActionMenu:showActionList(list, itemWait)
    resetForViewingActions(self, itemWait)
    adjustPositionOnShowingList(self, true)

    local listView = self.m_ListView
    for _, listItem in ipairs(list) do
        listView:pushBackCustomItem(createViewAction(listItem))
    end
    if (itemWait) then
        local buttonWait = createViewAction(itemWait)
        buttonWait:ignoreAnchorPointForPosition(true)
            :setPosition(BUTTON_WAIT_POS_X, BUTTON_WAIT_POS_Y)

        self.m_ButtonWait = buttonWait
        self:addChild(buttonWait)
    end
end

function ViewActionMenu:showProductionList(list)
    resetForViewingProductions(self)
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

function ViewActionMenu:updateWithPlayerIndex(playerIndex)
    resetBackground(self.m_MenuBackground, playerIndex)

    return self
end

return ViewActionMenu
