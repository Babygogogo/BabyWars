
local ViewWarCommandMenu = class("ViewWarCommandMenu", cc.Node)

local MENU_BACKGROUND_WIDTH  = 250
local MENU_BACKGROUND_HEIGHT = display.height * 0.8
local MENU_BACKGROUND_POSITION_X = (display.width - MENU_BACKGROUND_WIDTH) / 2
local MENU_BACKGROUND_POSITION_Y = (display.height - MENU_BACKGROUND_HEIGHT) / 2

local LIST_WIDTH  = MENU_BACKGROUND_WIDTH - 10
local LIST_HEIGHT = MENU_BACKGROUND_HEIGHT - 14
local LIST_POSITION_X = MENU_BACKGROUND_POSITION_X + 5
local LIST_POSITION_Y = MENU_BACKGROUND_POSITION_Y + 6

local ITEM_WIDTH              = MENU_BACKGROUND_WIDTH - 20
local ITEM_HEIGHT             = 45
local ITEM_CAPINSETS          = {x = 1, y = ITEM_HEIGHT, width = 1, height = 1}
local ITEM_FONT_COLOR         = {r = 255, g = 255, b = 255}
local ITEM_FONT_OUTLINE_COLOR = {r = 0,   g = 0,   b = 0}
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

        :setTitleFontName("res/fonts/msyhbd.ttc")
        :setTitleFontSize(28)
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
-- The screen background (the transparent grey mask).
--------------------------------------------------------------------------------
local function createScreenBackground()
    local background = cc.LayerColor:create({r = 0, g = 0, b = 0, a = 160})
    background:setContentSize(display.width, display.height)
        :ignoreAnchorPointForPosition(true)

    return background
end

local function initWithScreenBackground(self, background)
    self.m_ScreenBackground = background
    self:addChild(background)
end

--------------------------------------------------------------------------------
-- The menu background.
--------------------------------------------------------------------------------
local function createMenuBackground()
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", {x = 4, y = 6, width = 1, height = 1})
    background:ignoreAnchorPointForPosition(true)
        :setPosition(MENU_BACKGROUND_POSITION_X, MENU_BACKGROUND_POSITION_Y)

        :setContentSize(MENU_BACKGROUND_WIDTH, MENU_BACKGROUND_HEIGHT)

    return background
end

local function initWithMenuBackground(self, background)
    self.m_MenuBackground = background
    self:addChild(background)
end

--------------------------------------------------------------------------------
-- The list view.
--------------------------------------------------------------------------------
local function createListView()
    local listView = ccui.ListView:create()
    listView:ignoreAnchorPointForPosition(true)
        :setPosition(LIST_POSITION_X, LIST_POSITION_Y)

        :setContentSize(LIST_WIDTH, LIST_HEIGHT)

        :setItemsMargin(20)
        :setGravity(ccui.ListViewGravity.centerHorizontal)
        :setCascadeOpacityEnabled(true)

    return listView
end

local function initWithListView(self, listView)
    self.m_ListView = listView
    self:addChild(listView)
end

--------------------------------------------------------------------------------
-- The touch listener.
--------------------------------------------------------------------------------
local function createTouchListener(self)
    local touchListener = cc.EventListenerTouchOneByOne:create()
    touchListener:setSwallowTouches(true)

    touchListener:registerScriptHandler(function()
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)

    touchListener:registerScriptHandler(function()
        self:setEnabled(false)
    end, cc.Handler.EVENT_TOUCH_ENDED)

    return touchListener
end

local function initWithTouchListener(self, touchListener)
    self.m_TouchListener = touchListener
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(self.m_TouchListener, self)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewWarCommandMenu:ctor(param)
    initWithScreenBackground(self, createScreenBackground())
    initWithMenuBackground(  self, createMenuBackground())
    initWithListView(        self, createListView())
    initWithTouchListener(   self, createTouchListener(self))

    self:ignoreAnchorPointForPosition(true)

        :setCascadeOpacityEnabled(true)
        :setOpacity(200)

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

function ViewWarCommandMenu:setEnabled(enabled)
    self:setVisible(enabled)
    self.m_TouchListener:setEnabled(enabled)

    return self
end

return ViewWarCommandMenu
