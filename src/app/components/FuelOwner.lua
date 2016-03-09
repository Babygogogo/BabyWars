
local FuelOwner = class("FuelOwner")

local TypeChecker        = require("app.utilities.TypeChecker")
local ComponentManager   = require("global.components.ComponentManager")

local DEFAULT_MAX_FUEL             = 99
local DEFAULT_CONSUMPTION_PER_TURN = 0

local EXPORTED_METHODS = {
    "getCurrentFuel",
}

function FuelOwner:ctor(param)
    self.m_MaxFuel            = DEFAULT_MAX_FUEL
    self.m_CurrentFuel        = self.m_MaxFuel
    self.m_ConsumptionPerTurn = DEFAULT_CONSUMPTION_PER_TURN

    if (param) then
        self:load(param)
    end

    return self
end

function FuelOwner:load(param)
    self.m_MaxFuel            = param.maxFuel            or self.m_MaxFuel
    self.m_CurrentFuel        = param.currentFuel        or self.m_CurrentFuel
    self.m_ConsumptionPerTurn = param.consumptionPerTurn or self.m_ConsumptionPerTurn

    return self
end

function FuelOwner:bind(target)
	ComponentManager.setMethods(target, self, EXPORTED_METHODS)

	self.m_Target = target
end

function FuelOwner:unbind(target)
    assert(self.m_Target == target , "FuelOwner:unbind() the component is not bind to the param target.")
    assert(self.m_Target, "FuelOwner:unbind() the component is not bind to any target.")

    ComponentManager.unsetMethods(self.m_Target, EXPORTED_METHODS)
    self.m_Target = nil
end

function FuelOwner:getCurrentFuel()
    return self.m_CurrentFuel
end

return FuelOwner
