
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
	self:addChild(self:createBackground_())

	-- add HelloWorld label
	cc.Label:createWithSystemFont("Hello World", "Arial", 40)
		:move(display.cx, display.cy + 200)
		:addTo(self)

	self:addChild(self:createStartBtn_())
end

function MainScene:createBackground_()
	local bgSprite = display.newSprite("mainBG.png")
		:move(display.center)

	require"app.components.ComponentManager".bindComponent(bgSprite, "DraggableWithBoundary")

	return bgSprite
end

function MainScene:createStartBtn_()
	return ccui.Button:create()
		:move(display.center)
		:loadTextureNormal("startBtn_N.png", ccui.TextureResType.plistType)
		:onTouch(function()
			print("touched")
			end)
		:setTouchEnabled(false)
end

return MainScene
