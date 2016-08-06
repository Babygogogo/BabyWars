
local ModelSkillConfigurator = class("ModelSkillConfigurator")

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelSkillConfigurator:ctor()
    return self
end

function ModelSkillConfigurator:initView()
    return self
end

function ModelSkillConfigurator:setModelMainMenu(model)
    assert(self.m_ModelMainMenu == nil, "ModelSkillConfigurator:setModelMainMenu() the model has been set already.")
    self.m_ModelMainMenu = model

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelSkillConfigurator:setEnabled(enabled)
    if (self.m_View) then
        self.m_View:setEnabled(enabled)
    end

    return self
end

function ModelSkillConfigurator:onButtonBackTouched()
    self:setEnabled(false)
    self.m_ModelMainMenu:setMenuEnabled(true)

    return self
end

return ModelSkillConfigurator
