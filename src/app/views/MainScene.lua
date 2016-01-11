
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

local function createBackground_()
	local bgSprite = display.newSprite("mainBG.png")
		:move(display.center)

	require"app.components.ComponentManager".bindComponent(bgSprite, "DraggableWithinBoundary")

	return bgSprite
end

local function createStartBtn_()
	local btn = ccui.Button:create()
		:move(display.center)
		:loadTextureNormal("startBtn_N.png", ccui.TextureResType.plistType)

	btn:addTouchEventListener(function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			display.runScene(require"app.views.WarScene".new(), "CrossFade", 0.5)
		end
	end)

	return btn
end

function MainScene:onCreate()
	self:addChild(createBackground_())
	self:addChild(createStartBtn_())
end

return MainScene
