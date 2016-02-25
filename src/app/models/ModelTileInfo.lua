
local ModelTileInfo = class("ModelTileInfo")

function ModelTileInfo:ctor(param)
    if (param) then
        self:load(param)
    end
    
    return self
end

function ModelTileInfo:load(param)
    return self
end

function ModelTileInfo.createInstance(param)
    local model = ModelTileInfo.new():load(param)
    assert(model, "ModelTileInfo.createInstance() failed.")
    
    return model
end

return ModelTileInfo
