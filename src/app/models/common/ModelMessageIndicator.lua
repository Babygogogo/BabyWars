
local ModelMessageIndicator = class("ModelMessageIndicator")

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelMessageIndicator:ctor()
    self.m_IsEnabled = true

    return self
end

--------------------------------------------------------------------------------
-- The pulic functions.
--------------------------------------------------------------------------------
function ModelMessageIndicator:isEnabled()
    return self.m_IsEnabled
end

function ModelMessageIndicator:setEnabled(enabled)
    self.m_IsEnabled = enabled
    if (self.m_View) then
        self.m_View:setVisible(enabled)
    end

    return self
end

function ModelMessageIndicator:showMessage(msg, duration)
    if ((self:isEnabled()) and (self.m_View)) then
        self.m_View:showMessage(msg, duration)
    end

    return self
end

function ModelMessageIndicator:showPersistentMessage(msg)
    if ((self:isEnabled()) and (self.m_View)) then
        self.m_View:showPersistentMessage(msg)
    end

    return self
end

function ModelMessageIndicator:hidePersistentMessage(msg)
    if (self.m_View) then
        self.m_View:hidePersistentMessage(msg)
    end

    return self
end

return ModelMessageIndicator
