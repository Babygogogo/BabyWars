
local ModelUnitInfo = class("ModelUnitInfo")

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

return ModelUnitInfo
