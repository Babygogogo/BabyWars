
local ViewWarCommandMenu = class("ViewWarCommandMenu", cc.Node)

local MENU_BACKGROUND_WIDTH  = 250
local MENU_BACKGROUND_HEIGHT = display.height * 0.8
local MENU_BACKGROUND_POSITION_X = (display.width - MENU_BACKGROUND_WIDTH) / 2
local MENU_BACKGROUND_POSITION_Y = (display.height - MENU_BACKGROUND_HEIGHT) / 2

local LIST_WIDTH  = MENU_BACKGROUND_WIDTH - 10
local LIST_HEIGHT = MENU_BACKGROUND_HEIGHT - 14
local LIST_POSITION_X = MENU_BACKGROUND_POSITION_X + 5
local LIST_POSITION_Y = MENU_BACKGROUND_POSITION_Y + 6

local CONFIRM_BOX_Z_ORDER = 99

--------------------------------------------------------------------------------
-- The screen background (the transparent grey mask).
--------------------------------------------------------------------------------
local function createScreenBackground()
    local background = cc.LayerColor:create({r = 0, g = 0, b = 0, a = 160})
    background:setContentSize(display.width, display.height)
        :ignoreAnchorPointForPosition(true)

    return background
end

local function initWithScreenBackground(view, background)
    view.m_ScreenBackground = background
    view:addChild(background)
end

--------------------------------------------------------------------------------
-- The menu background.
--------------------------------------------------------------------------------
local function createMenuBackground()
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", {x = 4, y = 5, width = 1, height = 1})
    background:ignoreAnchorPointForPosition(true)
        :setPosition(MENU_BACKGROUND_POSITION_X, MENU_BACKGROUND_POSITION_Y)

        :setContentSize(MENU_BACKGROUND_WIDTH, MENU_BACKGROUND_HEIGHT)

    background.m_TouchSwallower = require("app.utilities.CreateTouchSwallowerForNode")(background)
    background:getEventDispatcher():addEventListenerWithSceneGraphPriority(background.m_TouchSwallower, background)

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

        :setContentSize(LIST_WIDTH, LIST_HEIGHT)

        :setItemsMargin(5)
        :setGravity(ccui.ListViewGravity.centerHorizontal)
        :setCascadeOpacityEnabled(true)

    return listView
end

local function initWithListView(view, listView)
    view.m_ListView = listView
    view:addChild(listView)
end

--------------------------------------------------------------------------------
-- The touch listener.
--------------------------------------------------------------------------------
local function createTouchListener(view)
    local touchListener = cc.EventListenerTouchOneByOne:create()
    touchListener:setSwallowTouches(true)

    touchListener:registerScriptHandler(function()
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)

    touchListener:registerScriptHandler(function()
        view:setEnabled(false)
    end, cc.Handler.EVENT_TOUCH_ENDED)

    return touchListener
end

local function initWithTouchListener(view, touchListener)
    view.m_TouchListener = touchListener
    view:getEventDispatcher():addEventListenerWithSceneGraphPriority(view.m_TouchListener, view)
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewWarCommandMenu:ctor(param)
    initWithScreenBackground(self, createScreenBackground())
    initWithMenuBackground(self, createMenuBackground())
    initWithListView(self, createListView())
    initWithTouchListener(self, createTouchListener(self))

    self:ignoreAnchorPointForPosition(true)

        :setCascadeOpacityEnabled(true)
        :setOpacity(200)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewWarCommandMenu:createItemView(item)
    local view = ccui.Button:create()
    view:loadTextureNormal("c03_t06_s01_f01.png", ccui.TextureResType.plistType)

        :setScale9Enabled(true)
        :setCapInsets({x = 2, y = 0, width = 1, height = 1})
        :setContentSize(230, 45)

        :setZoomScale(-0.05)

        :setTitleFontName("res/fonts/msyhbd.ttc")
        :setTitleFontSize(28)
        :setTitleColor({r = 255, g = 255, b = 255})
        :setTitleText(item:getTitleText())

    view:getTitleRenderer():enableOutline({r = 0, g = 0, b = 0}, 2)

    view:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            item:onPlayerTouch()
        end
    end)

    return view
end

function ViewWarCommandMenu:pushBackItemView(item)
    self.m_ListView:pushBackCustomItem(item)

    return self
end

function ViewWarCommandMenu:removeAllItems()
    self.m_ListView:removeAllItems()

    return self
end

function ViewWarCommandMenu:setEnabled(enabled)
    if (enabled) then
        self:setVisible(true)
        self:getEventDispatcher():resumeEventListenersForTarget(self)
    else
        self:setVisible(false)
        self:getEventDispatcher():pauseEventListenersForTarget(self)
    end

    return self
end

function ViewWarCommandMenu:setConfirmBoxView(view)
    if (self.m_ConfirmBoxView) then
        if (self.m_ConfirmBoxView == view) then
            return self
        else
            self:removeChild(self.m_ConfirmBoxView)
        end
    end

    self.m_ConfirmBoxView = view
    self:addChild(view, CONFIRM_BOX_Z_ORDER)
    view:setEnabled(false)

    return self
end

return ViewWarCommandMenu
