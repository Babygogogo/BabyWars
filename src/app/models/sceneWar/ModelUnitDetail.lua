
--[[--------------------------------------------------------------------------------
-- ModelUnitDetail是战局场景里的unit的详细属性页面。
--
-- 主要职责和使用场景举例：
--   构造和显示unit的详细属性页面。
--
-- 其他：
--  - 本类实际上没太多功能，只是把unit的属性交给ViewUnitDetail显示而已。
--]]--------------------------------------------------------------------------------

local ModelUnitDetail = class("ModelUnitDetail")

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelUnitDetail:ctor(param)
    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelUnitDetail:updateWithModelUnit(unit, modelPlayer, modelWeather)
    if (self.m_View) then
        self.m_View:updateWithModelUnit(unit, modelPlayer, modelWeather)
    end

    return self
end

function ModelUnitDetail:setEnabled(enabled)
    if (self.m_View) then
        self.m_View:setEnabled(enabled)
    end

    return self
end

return ModelUnitDetail
