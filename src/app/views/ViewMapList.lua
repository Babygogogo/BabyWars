
local ViewMapList = class("ViewMapList", function()
	return ccui.ListView:create()
end)

function ViewMapList:ctor(param)
    self:setBackGroundImage("c03_t01_s01_f01.png", ccui.TextureResType.plistType)
        :setBackGroundImageScale9Enabled(true)
        :setBackGroundImageCapInsets({x = 4, y = 5, width = 1, height = 1})
        :setContentSize(250, display.height - 60)
        :setPosition(30, 30)
        :setOpacity(180)
        :setCascadeOpacityEnabled(true)

--[[        
        listView:setDirection(ccui.ScrollViewDir.vertical)
        listView:setBounceEnabled(true)
        listView:addEventListener(listViewEvent)
        listView:addScrollViewEventListener(scrollViewEvent)
]]
	if (param) then self:load(param) end

	return self
end

function ViewMapList:load(param)
    return self
end

function ViewMapList.createInstance(param)
    local view = ViewMapList.new():load(param)
    assert(view, "ViewMapList.createInstance() failed.")

    return view
end

return ViewMapList
