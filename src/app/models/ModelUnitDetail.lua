
local ModelUnitDetail = class("ModelUnitDetail")

function ModelUnitDetail:ctor(param)
    if (param) then
        self:laod(param)
    end
    
    return self
end

function ModelUnitDetail:load(param)
    return self
end

function ModelUnitDetail.createInstance(param)
    local model = ModelUnitDetail:create():load(param)
    assert(model, "ModelUnitDetail.createInstance() failed.")
    
    return model
end

function ModelUnitDetail:setEnabled(enabled)
    if (self.m_View) then
        self.m_View:setEnabled(enabled)
    end
    
    return self
end

return ModelUnitDetail
