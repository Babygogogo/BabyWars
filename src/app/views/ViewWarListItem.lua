
local ViewWarListItem = class("ViewWarListItem", ccui.Button)

function ViewWarListItem:ctor(param)
    self:loadTextureNormal("c03_t06_s01_f01.png", ccui.TextureResType.plistType)
        :setScale9Enabled(true)
        :setCapInsets({x = 2, y = 0, width = 1, height = 1})
        :setContentSize(230, 45)
        :setZoomScale(-0.05)
        :setTitleFontSize(30)
        :setTitleColor({r = 0, g = 0, b = 0})
        :addTouchEventListener(function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                if (self.m_Model) then self.m_Model:onPlayerRequestEnterWar() end
            end
        end)

	if (param) then self:load(param) end

	return self
end

function ViewWarListItem:load(param)
    return self
end

function ViewWarListItem.createInstance(param)
    local view = ViewWarListItem.new():load(param)
    assert(view, "ViewWarListItem.createInstance() failed.")

    return view
end

return ViewWarListItem
