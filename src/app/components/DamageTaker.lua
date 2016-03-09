
local DamageTaker = class("DamageTaker")

local TypeChecker        = require("app.utilities.TypeChecker")
local ComponentManager   = require("global.components.ComponentManager")

local EXPORTED_METHODS = {
}

function DamageTaker:ctor(param)
    if (param) then
        self:load(param)
    end

    return self
end

function DamageTaker:load(param)
    return self
end

function DamageTaker:bind(target)
	ComponentManager.setMethods(target, self, EXPORTED_METHODS)

	self.m_Target = target
end

function DamageTaker:unbind(target)
    assert(self.m_Target == target , "DamageTaker:unbind() the component is not bind to the parameter target")
    assert(self.m_Target, "DamageTaker:unbind() the component is not bind to any target.")

    ComponentManager.unsetMethods(self.m_Target, EXPORTED_METHODS)
    self.m_Target = nil
end

return DamageTaker
