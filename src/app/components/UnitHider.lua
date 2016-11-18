
local UnitHider = require("src.global.functions.class")("UnitHider")

local isTypeInCategory = require("src.app.utilities.GameConstantFunctions").isTypeInCategory

UnitHider.EXPORTED_METHODS = {
    "canHideUnitType",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function UnitHider:ctor(param)
    self:loadTemplate(param.template)

    return self
end

function UnitHider:loadTemplate(template)
    self.m_Template = template

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function UnitHider:canHideUnitType(unitType)
    return isTypeInCategory(unitType, self.m_Template.targetCategoryType)
end

return UnitHider
