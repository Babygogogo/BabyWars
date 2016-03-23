
local ModelTileDetail = class("ModelTileDetail")

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelTileDetail:ctor(param)
    return self
end

function ModelTileDetail:updateWithModelTile(tile, weather)
    if (self.m_View) then
        self.m_View:updateWithModelTile(tile, weather)
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
