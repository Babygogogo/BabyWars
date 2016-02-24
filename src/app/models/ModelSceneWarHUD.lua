
local ModelSceneWarHUD = class("ModelSceneWarHUD")

local Actor = require("global.actors.Actor")

local function createChildrenActors(param)
    local moneyEnergyInfoActor = Actor.createWithModelAndViewName(nil, nil, "ViewMoneyEnergyInfo")
    assert(moneyEnergyInfoActor, "ModelSceneWarHUD--createChildrenActors() failed to create a MoneyEnergyInfo actor.")
    
    return {moneyEnergyInfoActor = moneyEnergyInfoActor}
end

function ModelSceneWarHUD:ctor(param)
    if (param) then
        self:load(param)
    end
    
    return self
end

function ModelSceneWarHUD:load(param)
    local childrenActors = createChildrenActors(param)

    self.m_MoneyEnergyInfoActor = childrenActors.moneyEnergyInfoActor
    assert(self.m_MoneyEnergyInfoActor, "ModelSceneWarHUD:load() failed to retrive a MoneyEnergyInfo actor.")
    
    return self
end

function ModelSceneWarHUD.createInstance(param)
    local model = ModelSceneWarHUD.new():load(param)
    assert(model, "ModelSceneWarHUD.createInstance() failed.")
    
    return model
end

function ModelSceneWarHUD:getTouchableChildrenViews()
    local views = {}
    local getTouchableViewFromActor = require("app.utilities.GetTouchableViewFromActor")
    
    views[#views + 1] = getTouchableViewFromActor(self.m_MoneyEnergyInfoActor)
    
    return views
end

function ModelSceneWarHUD:initView()
    local view = self.m_View
    assert(view, "ModelSceneWarHUD:initView() no view is attached to the actor of the model.")

    view:removeAllChildren()
        :addChild(self.m_MoneyEnergyInfoActor:getView())
        
        :setTouchableChildrenViews(self:getTouchableChildrenViews())

    return self
end

return ModelSceneWarHUD
