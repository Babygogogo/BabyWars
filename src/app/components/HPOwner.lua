
local HPOwner = class("HPOwner")

local TypeChecker        = require("app.utilities.TypeChecker")
local ComponentManager   = require("global.components.ComponentManager")

local DEFAULT_MAX_HP = 100

local EXPORTED_METHODS = {
    "getCurrentHP",
    "getNormalizedCurrentHP",
}

function HPOwner:ctor(param)
    self.m_MaxHP     = DEFAULT_MAX_HP
    self.m_CurrentHP = self.m_MaxHP

    if (param) then
        self:load(param)
    end

    return self
end

function HPOwner:load(param)
    self.m_MaxHP     = param.maxHP     or self.m_MaxHP
    self.m_CurrentHP = param.currentHP or self.m_CurrentHP

    return self
end

function HPOwner:bind(target)
	ComponentManager.setMethods(target, self, EXPORTED_METHODS)

	self.m_Target = target
end

function HPOwner:unbind(target)
    assert(self.m_Target == target , "HPOwner:unbind() the component is not bind to the param target.")
    assert(self.m_Target, "HPOwner:unbind() the component is not bind to any target.")

    ComponentManager.unsetMethods(self.m_Target, EXPORTED_METHODS)
    self.m_Target = nil
end

function HPOwner:getCurrentHP()
    return self.m_CurrentHP
end

function HPOwner:getNormalizedCurrentHP()
    return math.ceil(self.m_CurrentHP / 10)
end

return HPOwner
