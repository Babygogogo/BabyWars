
local ViewActionMenu = class("ViewActionMenu", cc.Node)

local MENU_BACKGROUND_WIDTH  = 180
local MENU_BACKGROUND_HEIGHT = display.height - 10 - 88 - 140 - 10 -- These are the height of boundary/MoneyEnergyInfo/UnitInfo/boundary.

local LEFT_POSITION_X  = 10
local LEFT_POSITION_Y  = 10 + 140
local RIGHT_POSITION_X = display.width - MENU_BACKGROUND_WIDTH - 10
local RIGHT_POSITION_Y = LEFT_POSITION_Y

local LIST_WIDTH  = MENU_BACKGROUND_WIDTH - 10
local LIST_HEIGHT = MENU_BACKGROUND_HEIGHT - 14
local LIST_POSITION_X = 5
local LIST_POSITION_Y = 6

local FONT_SIZE     = 25
local BUTTON_WIDTH  = MENU_BACKGROUND_WIDTH - 15
local BUTTON_HEIGHT = FONT_SIZE / 5 * 8

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createItemView(itemModel)
    local view = ccui.Button:create()
    view:loadTextureNormal("c03_t06_s01_f01.png", ccui.TextureResType.plistType)

        :setScale9Enabled(true)
        :setCapInsets({x = 2, y = 0, width = 1, height = 1})
        :setContentSize(BUTTON_WIDTH, BUTTON_HEIGHT)

        :setZoomScale(-0.05)

        :setTitleFontName("res/fonts/msyhbd.ttc")
        :setTitleFontSize(25)
        :setTitleColor({r = 255, g = 255, b = 255})
        :setTitleText(itemModel.name)

    view:getTitleRenderer():enableOutline({r = 0, g = 0, b = 0}, 2)

    view:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            itemModel.callback()
        end
    end)

    return view
end

local function moveToLeftSide(self)
    self:setPosition(LEFT_POSITION_X, LEFT_POSITION_Y)
end

local function moveToRightSide(self)
    self:setPosition(RIGHT_POSITION_X, RIGHT_POSITION_Y)
end

--------------------------------------------------------------------------------
-- The menu background.
--------------------------------------------------------------------------------
local function createMenuBackground()
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", {x = 4, y = 5, width = 1, height = 1})
    background:ignoreAnchorPointForPosition(true)
        :setContentSize(MENU_BACKGROUND_WIDTH, MENU_BACKGROUND_HEIGHT)

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
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewActionMenu:ctor(param)
    initWithMenuBackground(  self, createMenuBackground())
    initWithListView(        self, createListView())
--    initWithTouchListener(   self, createTouchListener(self))

    self:ignoreAnchorPointForPosition(true)
        :setPosition(RIGHT_POSITION_X, RIGHT_POSITION_Y)

        :setOpacity(200)
        :setVisible(false)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewActionMenu:createAndPushBackItemView(itemModel)
    self.m_ListView:pushBackCustomItem(createItemView(itemModel))

    return self
end

function ViewActionMenu:pushBackItemView(itemView)
    self.m_ListView:pushBackCustomItem(itemView)

    return self
end

function ViewActionMenu:removeAllItems()
    self.m_ListView:removeAllItems()

    return self
end

function ViewActionMenu:setEnabled(enabled)
    if (enabled) then
        self:setVisible(true)
--        self.m_TouchListener:setEnabled(true)
    else
        self:setVisible(false)
--        self.m_TouchListener:setEnabled(false)
    end

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
