
local ModelSceneMain = class("ModelSceneMain")

local Actor	= require("global.actors.Actor")

local function createBackgroundActor()
    local view = display.newSprite("#c03_t05_s01_f01.png")
    view:move(display.center)

    return Actor.new():setView(view)
end

local function createWarListActor(mapListData)
    return Actor.createWithModelAndViewName("ModelWarList", mapListData, "ViewWarList", mapListData)
end

function ModelSceneMain:ctor(param)
    if (param) then
        self:load(param)
    end
    
    return self
end

function ModelSceneMain:load(param)
    self.m_BackgroundActor = createBackgroundActor()
    self.m_WarListActor = createWarListActor("WarSceneList")
    
    if (self.m_View) then
        self:initView()
    end
    
    return self
end

function ModelSceneMain.createInstance(param)
    local model = ModelSceneMain:create():load(param)
    assert(model, "ModelSceneMain.createInstance() failed.")
    
    return model
end

function ModelSceneMain:initView()
    local view = self.m_View
    assert(view, "ModelSceneMain:initView() no view is attached to the owner actor of the model.")
    
    view:removeAllChildren()
        :addChild(self.m_BackgroundActor:getView())
        :addChild(self.m_WarListActor:getView())
        
    return self
end

return ModelSceneMain
