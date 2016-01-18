
local MainScene = class("MainScene", cc.load("mvc").ViewBase)
local Requirer	= require"app.utilities.Requirer"
local Actor		= Requirer.actor()

local function createBackgroundActor()
	local bgSprite = display.newSprite("mainBG.png")
		:move(display.center)

	Requirer.component("ComponentManager").bindComponent(bgSprite, "DraggableWithinBoundary")
	bgSprite:setDragBoundaryRect({x = 0, y = 0, width = display.width, height = display.height})

	return Actor.new():setView(bgSprite)
end

local function createStartBtnActor()
	local btn = ccui.Button:create()
		:move(display.center)
		:loadTextureNormal("startBtn_N.png", ccui.TextureResType.plistType)

	btn:addTouchEventListener(function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			local warScene, createWarSceneMsg = Requirer.view("WarScene").new():load("WarScene_Test")
			assert(warScene, createWarSceneMsg)
			display.runScene(warScene, "CrossFade", 0.5)
		end
	end)

	return Actor.new():setView(btn)
end

function MainScene:onCreate()
	self.m_BgActor_ = createBackgroundActor()
	self:addChild(self.m_BgActor_:getView())
	
	self.m_StartBtn_ = createStartBtnActor()
	self:addChild(self.m_StartBtn_:getView())
end

return MainScene
