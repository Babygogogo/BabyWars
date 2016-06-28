
local ViewWarCommandMenu = class("ViewWarCommandMenu", cc.Node)

local BACKGROUND_WIDTH     = 250
local BACKGROUND_HEIGHT    = display.height * 0.8
local BACKGROUND_POS_X     = (display.width - BACKGROUND_WIDTH) / 2
local BACKGROUND_POS_Y     = (display.height - BACKGROUND_HEIGHT) / 2
local BACKGROUND_CAPINSETS = {x = 4, y = 6, width = 1, height = 1}

local LIST_VIEW_WIDTH        = BACKGROUND_WIDTH - 10
local LIST_VIEW_HEIGHT       = BACKGROUND_HEIGHT - 14
local LIST_VIEW_POS_X        = BACKGROUND_POS_X + 10
local LIST_VIEW_POS_Y        = BACKGROUND_POS_Y + 6
local LIST_VIEW_ITEMS_MARGIN = 10

local ITEM_WIDTH         = BACKGROUND_WIDTH - 20
local ITEM_HEIGHT        = 55
local ITEM_CAPINSETS     = {x = 1, y = ITEM_HEIGHT, width = 1, height = 1}
local ITEM_FONT_COLOR    = {r = 255, g = 255, b = 255}
local ITEM_OUTLINE_COLOR = {r = 0,   g = 0,   b = 0}
local ITEM_OUTLINE_WIDTH = 2

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

        :setTitleFontName("res/fonts/msyhbd.ttc")
        :setTitleFontSize(30)
        :setTitleColor(ITEM_FONT_COLOR)
        :setTitleText(item.name)

    view:getTitleRenderer():enableOutline(ITEM_OUTLINE_COLOR, ITEM_OUTLINE_WIDTH)

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
local function initGreyMask(self)
    local greyMask = cc.LayerColor:create({r = 0, g = 0, b = 0, a = 160})
    greyMask:setContentSize(display.width, display.height)
        :ignoreAnchorPointForPosition(true)

    self.m_GreyMask = greyMask
    self:addChild(greyMask)
end

local function initBackground(self)
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", BACKGROUND_CAPINSETS)
    background:ignoreAnchorPointForPosition(true)
        :setPosition(BACKGROUND_POS_X, BACKGROUND_POS_Y)

        :setContentSize(BACKGROUND_WIDTH, BACKGROUND_HEIGHT)

        :setOpacity(180)

    self.m_MenuBackground = background
    self:addChild(background)
end

local function initListView(self)
    local listView = ccui.ListView:create()
    listView:ignoreAnchorPointForPosition(true)
        :setPosition(LIST_VIEW_POS_X, LIST_VIEW_POS_Y)

        :setContentSize(LIST_VIEW_WIDTH, LIST_VIEW_HEIGHT)

        :setItemsMargin(LIST_VIEW_ITEMS_MARGIN)

    self.m_ListView = listView
    self:addChild(listView)
end

local function initTouchListener(self)
    local touchListener = cc.EventListenerTouchOneByOne:create()
    touchListener:setSwallowTouches(true)

    touchListener:registerScriptHandler(function()
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)

    touchListener:registerScriptHandler(function()
        self:setEnabled(false)
    end, cc.Handler.EVENT_TOUCH_ENDED)

    self.m_TouchListener = touchListener
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(self.m_TouchListener, self)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewWarCommandMenu:ctor(param)
    initGreyMask(     self)
    initBackground(   self)
    initListView(     self)
    initTouchListener(self)

    self:ignoreAnchorPointForPosition(true)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewWarCommandMenu:createAndPushBackViewItem(item)
    self.m_ListView:pushBackCustomItem(createViewItem(item))

    return self
end

function ViewWarCommandMenu:removeAllItems()
    self.m_ListView:removeAllItems()

    return self
end

function ViewWarCommandMenu:setItems(items)
    self:removeAllItems()

    for _, item in ipairs(items) do
        self:createAndPushBackViewItem(item)
    end

    return self
end

function ViewWarCommandMenu:setEnabled(enabled)
    self:setVisible(enabled)
    self.m_TouchListener:setEnabled(enabled)

    return self
end

return ViewWarCommandMenu
