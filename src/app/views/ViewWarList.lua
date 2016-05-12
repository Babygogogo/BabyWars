
local ViewWarList = class("ViewWarList", cc.Node)

local ITEM_WIDTH              = 230
local ITEM_HEIGHT             = 45
local ITEM_CAPINSETS          = {x = 1, y = ITEM_HEIGHT, width = 1, height = 1}
local ITEM_FONT_NAME          = "res/fonts/msyhbd.ttc"
local ITEM_FONT_SIZE          = 28
local ITEM_FONT_COLOR         = {r = 255, g = 255, b = 255}
local ITEM_FONT_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local ITEM_FONT_OUTLINE_WIDTH = 2

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createViewWarItem(item)
    local view = ccui.Button:create()
    view:loadTextureNormal("c03_t06_s01_f01.png", ccui.TextureResType.plistType)

        :setScale9Enabled(true)
        :setCapInsets(ITEM_CAPINSETS)
        :setContentSize(ITEM_WIDTH, ITEM_HEIGHT)

        :setZoomScale(-0.05)

        :setTitleFontName(ITEM_FONT_NAME)
        :setTitleFontSize(ITEM_FONT_SIZE)
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
-- The composition background.
--------------------------------------------------------------------------------
local function createBackground()
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", {x = 4, y = 6, width = 1, height = 1})
    background:ignoreAnchorPointForPosition(true)

    return background
end

local function initWithBackground(self, background)
    self.m_Background = background
    self:addChild(background)
end

--------------------------------------------------------------------------------
-- The composition list view.
--------------------------------------------------------------------------------
local function createListView()
    local listView = ccui.ListView:create()
    listView:setPosition(5, 6)
        :setItemsMargin(5)
        :setGravity(ccui.ListViewGravity.centerHorizontal)
        :setCascadeOpacityEnabled(true)

    return listView
end

local function initWithListView(self, listView)
    self.m_ListView = listView
    self:addChild(listView)
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewWarList:ctor(param)
    initWithBackground(self, createBackground())
    initWithListView(self, createListView())

    self:setContentSize(250, display.height - 60)
        :setPosition(30, 30)
        :setCascadeOpacityEnabled(true)
        :setOpacity(180)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewWarList:setContentSize(width, height)
    self.m_Background:setContentSize(width, height)
    self.m_ListView:setContentSize(width - 10, height - 14) -- 10/14 are the height/width of the edging of background

    return self
end

function ViewWarList:removeAllItems()
    self.m_ListView:removeAllItems()

    return self
end

function ViewWarList:showWarList(list)
    for _, listItem in ipairs(list) do
        self.m_ListView:pushBackCustomItem(createViewWarItem(listItem))
    end

    return self
end

function ViewWarList:createAndPushBackItem(item)
    self.m_ListView:pushBackCustomItem(createViewWarItem(item))

    return self
end

return ViewWarList
