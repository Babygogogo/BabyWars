
local ViewWarList = class("ViewWarList", cc.Node)

local function createBackground()
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", {x = 4, y = 5, width = 1, height = 1})
    background:ignoreAnchorPointForPosition(true)

    return background
end

local function initWithBackground(view, background)
    view.m_Background = background
    view:addChild(background)
end

local function createListView()
    local listView = ccui.ListView:create()
    listView:setPosition(5, 6)
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
-- The constructor.
--------------------------------------------------------------------------------
function ViewWarList:ctor(param)
    initWithBackground(self, createBackground())
    initWithListView(self, createListView())

    self:setContentSize(250, display.height - 60)
        :setPosition(30, 30)
        :setCascadeOpacityEnabled(true)
        :setOpacity(180)
--[[
        listView:setDirection(ccui.ScrollViewDir.vertical)
        listView:setBounceEnabled(true)
        listView:addEventListener(listViewEvent)
        listView:addScrollViewEventListener(scrollViewEvent)
]]

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

function ViewWarList:pushBackItem(item)
    self.m_ListView:pushBackCustomItem(item)

    return self
end

function ViewWarList:removeAllItems()
    self.m_ListView:removeAllItems()

    return self
end

return ViewWarList
