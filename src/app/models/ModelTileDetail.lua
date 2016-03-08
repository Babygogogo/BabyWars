
local ModelTileDetail = class("ModelTileDetail")

function ModelTileDetail:ctor(param)
    if (param) then
        self:laod(param)
    end

    return self
end

function ModelTileDetail:load(param)
    return self
end

function ModelTileDetail.createInstance(param)
    local model = ModelTileDetail:create():load(param)
    assert(model, "ModelTileDetail.createInstance() failed.")

    return model
end

function ModelTileDetail:updateWithModelTile(tile)
    if (self.m_View) then
        self.m_View:updateWithModelTile(tile)
    end

    return self
end

function ModelTileDetail:setEnabled(enabled)
    if (self.m_View) then
        self.m_View:setEnabled(enabled)
    end

    return self
end

return ModelTileDetail
