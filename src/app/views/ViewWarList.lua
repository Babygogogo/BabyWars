
local ViewWarList = class("ViewWarList", cc.Node)

function ViewWarList:loadBackground()
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", {x = 4, y = 5, width = 1, height = 1})
    background:ignoreAnchorPointForPosition(true)

    self.m_Background = background
    self:addChild(background)

    return self
end

function ViewWarList:loadListView()
    local listView = ccui.ListView:create()
    listView:setPosition(5, 6)
        :setItemsMargin(5)
        :setGravity(ccui.ListViewGravity.centerHorizontal)
        :setCascadeOpacityEnabled(true)
        
    self.m_ListView = listView
    self:addChild(listView)
    
    return self
end

function ViewWarList:ctor(param)
    self:loadBackground()
        :loadListView()
        :setContentSize(250, display.height - 60)
        :setPosition(30, 30)
        :setCascadeOpacityEnabled(true)
        :setOpacity(180)
--[[        
        listView:setDirection(ccui.ScrollViewDir.vertical)
        listView:setBounceEnabled(true)
        listView:addEventListener(listViewEvent)
        listView:addScrollViewEventListener(scrollViewEvent)
]]
	if (param) then self:load(param) end

	return self
end

function ViewWarList:load(param)
    return self
end

function ViewWarList.createInstance(param)
    local view = ViewWarList.new():load(param)
    assert(view, "ViewWarList.createInstance() failed.")

    return view
end

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
