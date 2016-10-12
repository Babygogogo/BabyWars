
local Diver = require("src.global.functions.class")("Diver")

Diver.EXPORTED_METHODS = {
    "isDiving",
    "canDive",
    "getAdditionalFuelConsumptionForDive",

    "setDiving",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function Diver:ctor(param)
    self:loadTemplate(      param.template)
        :loadInstantialData(param.instantialData)

    return self
end

function Diver:loadTemplate(template)
    self.m_Template = template

    return self
end

function Diver:loadInstantialData(data)
    self.m_IsDiving = data.isDiving

    return self
end

--------------------------------------------------------------------------------
-- The function for serialization.
--------------------------------------------------------------------------------
function Diver:toSerializableTable()
    if (self:isDiving()) then
        return nil
    else
        return {isDiving = false}
    end
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function Diver:isDiving()
    return self.m_IsDiving
end

function Diver:canDive()
    return not self:isDiving()
end

function Diver:getAdditionalFuelConsumptionForDive()
    return self.m_Template.additionalFuelConsumption
end

function Diver:setDiving(diving)
    self.m_IsDiving = diving

    return self.m_Owner
end

return Diver
