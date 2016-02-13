
local SceneMain = class("SceneMain", cc.load("mvc").ViewBase)

local Requirer	= require"app.utilities.Requirer"
local Actor		= Requirer.actor()

local function createBackgroundActor()
	local bgView = display.newSprite("#c03_t05_s01_f01.png")
		:move(display.center)

	return Actor.new():setView(bgView)
end

local function createActorWarList(mapListData)
    local model = Requirer.model("ModelWarList").createInstance(mapListData)
    assert(model, "SceneMain--createActorWarList() failed to create ModelWarList.")

    local view = Requirer.view("ViewWarList").createInstance(mapListData)
    assert(view, "SceneMain--createActorWarList() failed to create ViewWarList.")

    return Actor.createWithModelAndViewInstance(model, view)
end

function SceneMain:onCreate()
    self.m_ActorBg = createBackgroundActor()
    self:addChild(self.m_ActorBg:getView())
	
    self.m_ActorWarList = createActorWarList("WarSceneList")
    self:addChild(self.m_ActorWarList:getView())
end

return SceneMain
