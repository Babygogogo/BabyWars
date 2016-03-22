
local ModelTileDetail = class("ModelTileDetail")

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelTileDetail:ctor(param)
    return self
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
