
--[[--------------------------------------------------------------------------------
-- ModelTileDetail是战局场景里的tile的详细属性页面。
--
-- 主要职责和使用场景举例：
--   构造和显示tile的详细属性页面。
--
-- 其他：
--  - 本类实际上没太多功能，只是把tile的属性交给ViewTileDetail显示而已。
--]]--------------------------------------------------------------------------------

local ModelTileDetail = class("ModelTileDetail")

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelTileDetail:ctor(param)
    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelTileDetail:updateWithModelTile(modelTile, modelPlayer)
    if (self.m_View) then
        self.m_View:updateWithModelTile(modelTile, modelPlayer)
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
