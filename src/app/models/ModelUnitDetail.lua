
local ModelUnitDetail = class("ModelUnitDetail")

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelUnitDetail:ctor(param)
    return self
end

function ModelUnitDetail:updateWithModelUnit(unit)
    if (self.m_View) then
        self.m_View:updateWithModelUnit(unit)
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
