
local MainScene = class("MainScene", cc.load("mvc").ViewBase)
local Requirer = require"app.utilities.Requirer"

local function createBackground_()
	local bgSprite = display.newSprite("mainBG.png")
		:move(display.center)

	Requirer.component("ComponentManager").bindComponent(bgSprite, "DraggableWithinBoundary")
	bgSprite:setDragBoundaryRect({x = 0, y = 0, width = display.width, height = display.height})

	return bgSprite
end

local function createStartBtn_()
	local btn = ccui.Button:create()
		:move(display.center)
		:loadTextureNormal("startBtn_N.png", ccui.TextureResType.plistType)

	btn:addTouchEventListener(function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			display.runScene(Requirer.view("WarScene").new("WarScene_Test"), "CrossFade", 0.5)
		end
	end)

	return btn
end

function MainScene:onCreate()
	self:addChild(createBackground_())
	self:addChild(createStartBtn_())
end

return MainScene
