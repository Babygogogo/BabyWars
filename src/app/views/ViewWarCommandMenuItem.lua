
local ViewWarCommandMenuItem = class("ViewWarCommandMenuItem", ccui.Button)

function ViewWarCommandMenuItem:ctor(param)
    self:loadTextureNormal("c03_t06_s01_f01.png", ccui.TextureResType.plistType)
    
        :setScale9Enabled(true)
        :setCapInsets({x = 2, y = 0, width = 1, height = 1})
        :setContentSize(230, 45)
        
        :setZoomScale(-0.05)
        
        :setTitleFontName("res/fonts/msyhbd.ttc")
        :setTitleFontSize(28)
        :setTitleColor({r = 255, g = 255, b = 255})
        
        :addTouchEventListener(function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                if (self.m_Model) then self.m_Model:onPlayerTouch() end
            end
        end)
        
    self:getTitleRenderer():enableOutline({r = 0, g = 0, b = 0}, 2)

	if (param) then
        self:load(param)
    end

	return self
end

function ViewWarCommandMenuItem:load(param)
    return self
end

function ViewWarCommandMenuItem.createInstance(param)
    local view = ViewWarCommandMenuItem.new():load(param)
    assert(view, "ViewWarCommandMenuItem.createInstance() failed.")

    return view
end

return ViewWarCommandMenuItem
