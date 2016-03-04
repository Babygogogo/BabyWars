
local ModelTileInfo = class("ModelTileInfo")

local function createDetailActor()
    return require("global.actors.Actor").createWithModelAndViewName("ModelTileDetail", nil, "ViewTileDetail")
end

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

function ModelTileInfo:onPlayerTouch()
    if (self.m_DetailActor) then
        self.m_DetailActor:getModel():setEnabled(true)
    else
        self.m_DetailActor = createDetailActor()
        self.m_View:getScene():addChild(self.m_DetailActor:getView())
    end
    
    return self
end

return ModelTileInfo
