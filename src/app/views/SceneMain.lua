
local SceneMain = class("SceneMain", cc.load("mvc").ViewBase)

local Requirer	= require"app.utilities.Requirer"
local Actor		= Requirer.actor()

local function createBackgroundActor()
	local bgView = display.newSprite("#c03_t05_s01_f01.png")
		:move(display.center)

	return Actor.new():setView(bgView)
end

local function createStartBtnActor()
	local btn = ccui.Button:create()
		:move(display.center)
		:loadTextureNormal("startBtn_N.png", ccui.TextureResType.plistType)

	btn:addTouchEventListener(function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			local warScene, createWarSceneMsg = Requirer.view("SceneWar").createInstance("WarScene_Test")
			assert(warScene, createWarSceneMsg)
			display.runScene(warScene, "CrossFade", 0.5)
		end
	end)

	return Actor.new():setView(btn)
end

local function createActorWarList(mapListData)
    local view = Requirer.view("ViewWarList").createInstance()
    assert(view, "SceneMain--createActorWarList() failed to create ViewMapList.")
    
    view.m_ListView:addChild(Requirer.view("ViewWarListItem").createInstance())
    view.m_ListView:addChild(Requirer.view("ViewWarListItem").createInstance())
    view.m_ListView:addChild(Requirer.view("ViewWarListItem").createInstance())
    view.m_ListView:addChild(Requirer.view("ViewWarListItem").createInstance())
    view.m_ListView:addChild(Requirer.view("ViewWarListItem").createInstance())
    view.m_ListView:addChild(Requirer.view("ViewWarListItem").createInstance())
    view.m_ListView:addChild(Requirer.view("ViewWarListItem").createInstance())
    view.m_ListView:addChild(Requirer.view("ViewWarListItem").createInstance())
    view.m_ListView:addChild(Requirer.view("ViewWarListItem").createInstance())
    view.m_ListView:addChild(Requirer.view("ViewWarListItem").createInstance())
    view.m_ListView:addChild(Requirer.view("ViewWarListItem").createInstance())
    view.m_ListView:addChild(Requirer.view("ViewWarListItem").createInstance())
    view.m_ListView:addChild(Requirer.view("ViewWarListItem").createInstance())
    view.m_ListView:addChild(Requirer.view("ViewWarListItem").createInstance())
    view.m_ListView:addChild(Requirer.view("ViewWarListItem").createInstance())
    view.m_ListView:addChild(Requirer.view("ViewWarListItem").createInstance())
    view.m_ListView:addChild(Requirer.view("ViewWarListItem").createInstance())
    view.m_ListView:addChild(Requirer.view("ViewWarListItem").createInstance())

    return Actor.new():setView(view)
end

function SceneMain:onCreate()
    self.m_ActorBg = createBackgroundActor()
    self:addChild(self.m_ActorBg:getView())
	
    self.m_ActorWarList = createActorWarList()
    self:addChild(self.m_ActorWarList:getView())

	self.m_StartBtn_ = createStartBtnActor()
	self:addChild(self.m_StartBtn_:getView())
end

return SceneMain
