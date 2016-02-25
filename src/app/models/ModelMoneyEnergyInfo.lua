
local ModelMoneyEnergyInfo = class("ModelMoneyEnergyInfo")

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

return ModelMoneyEnergyInfo
