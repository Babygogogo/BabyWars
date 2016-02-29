
local ModelMoneyEnergyInfo = class("ModelMoneyEnergyInfo")

local Actor = require("global.actors.Actor")

local function createWarCommandMenuActor()
    return Actor.createWithModelAndViewName("ModelWarCommandMenu", nil, "ViewWarCommandMenu")
end

function ModelMoneyEnergyInfo:ctor(param)
    if (param) then
        self:load(param)
    end
    
    return self
end

function ModelMoneyEnergyInfo:load(param)
    return self
end

function ModelMoneyEnergyInfo.createInstance(param)
    local model = ModelMoneyEnergyInfo.new():load(param)
    assert(model, "ModelMoneyEnergyInfo.createInstance() failed.")
    
    return model
end

function ModelMoneyEnergyInfo:onPlayerTouch()
    if (self.m_WarCommandMenuActor) then
        self.m_WarCommandMenuActor:getModel():setEnabled(true)
    else
        self.m_WarCommandMenuActor = createWarCommandMenuActor()
        self.m_View:getScene():addChild(self.m_WarCommandMenuActor:getView())
    end
    
    return self    
end

return ModelMoneyEnergyInfo
