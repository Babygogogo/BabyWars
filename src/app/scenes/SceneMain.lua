
local SceneMain = class("SceneMain", cc.Scene)

local Actor	= require("global.actors.Actor")

local function createBackgroundActor()
	local bgView = display.newSprite("#c03_t05_s01_f01.png")
		:move(display.center)

	return Actor.new():setView(bgView)
end

local function createWarListActor(mapListData)
    return Actor.createWithModelAndViewName("ModelWarList", mapListData, "ViewWarList", mapListData)
end

function SceneMain:ctor()
    self.m_ActorBg = createBackgroundActor()
    self:addChild(self.m_ActorBg:getView())
	
    self.m_ActorWarList = createWarListActor("WarSceneList")
    self:addChild(self.m_ActorWarList:getView())
    
    return self
end

function SceneMain:load(param)
    return self
end

function SceneMain.createInstance()
    local scene = SceneMain:create():load()
    assert(scene, "SceneMain.createInstance() failed.")
    
    return scene
end

return SceneMain
