
local ModelUnitInfo = class("ModelUnitInfo")

local function createDetailActor()
    return require("global.actors.Actor").createWithModelAndViewName("ModelUnitDetail", nil, "ViewUnitDetail")
end

function ModelUnitInfo:ctor(param)
    if (param) then
        self:load(param)
    end
    
    return self
end

function ModelUnitInfo:load(param)
    return self
end

function ModelUnitInfo.createInstance(param)
    local model = ModelUnitInfo.new():load(param)
    assert(model, "ModelUnitInfo.createInstance() failed.")
    
    return model
end

function ModelUnitInfo:onPlayerTouch()
    if (self.m_DetailActor) then
        self.m_DetailActor:getModel():setEnabled(true)
    else
        self.m_DetailActor = createDetailActor()
        self.m_View:getScene():addChild(self.m_DetailActor:getView())
    end
    
    return self
end

return ModelUnitInfo
