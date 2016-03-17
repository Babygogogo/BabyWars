
local ViewWarCommandMenuItem = class("ViewWarCommandMenuItem", ccui.Button)

local function initAppearance(view)
    view:loadTextureNormal("c03_t06_s01_f01.png", ccui.TextureResType.plistType)

        :setScale9Enabled(true)
        :setCapInsets({x = 2, y = 0, width = 1, height = 1})
        :setContentSize(230, 45)

        :setZoomScale(-0.05)

        :setTitleFontName("res/fonts/msyhbd.ttc")
        :setTitleFontSize(28)
        :setTitleColor({r = 255, g = 255, b = 255})

    view:getTitleRenderer():enableOutline({r = 0, g = 0, b = 0}, 2)
end

local function initTouchListener(view)
    view:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            if (view.m_Model) then
                view.m_Model:onPlayerTouch()
            end
        end
    end)
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewWarCommandMenuItem:ctor(param)
    initAppearance(self)
    initTouchListener(self)

	return self
end

return ViewWarCommandMenuItem
