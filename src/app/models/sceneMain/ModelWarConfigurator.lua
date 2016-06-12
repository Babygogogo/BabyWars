
local ModelWarConfigurator = class("ModelWarConfigurator")

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelWarConfigurator:ctor()
    return self
end

function ModelWarConfigurator:initView()
    return self
end

function ModelWarConfigurator:setOnButtonBackTouched(callback)
    self.m_OnButtonBackTouched = callback

    return self
end

function ModelWarConfigurator:setOnButtonConfirmTouched(callback)
    self.m_OnButtonConfirmTouched = callback

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelWarConfigurator:setEnabled(enabled)
    if (self.m_View) then
        self.m_View:setVisible(enabled)
    end

    return self
end

function ModelWarConfigurator:onButtonBackTouched()
    if (self.m_OnButtonBackTouched) then
        self.m_OnButtonBackTouched()
    end

    return self
end

function ModelWarConfigurator:onButtonConfirmTouched()
    if (self.m_OnButtonConfirmTouched) then
        self.m_OnButtonConfirmTouched()
    end

    return self
end

function ModelWarConfigurator:setWarFieldFileName(name)
    self.m_WarFieldFileName = name

    return self
end

function ModelWarConfigurator:getWarFieldFileName()
    return self.m_WarFieldFileName
end

return ModelWarConfigurator
