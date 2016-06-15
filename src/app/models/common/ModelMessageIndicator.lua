
local ModelMessageIndicator = class("ModelMessageIndicator")

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelMessageIndicator:ctor()
    return self
end

--------------------------------------------------------------------------------
-- The pulic functions.
--------------------------------------------------------------------------------
function ModelMessageIndicator:showMessage(msg, duration)
    if (self.m_View) then
        self.m_View:showMessage(msg, duration)
    end

    return self
end

function ModelMessageIndicator:showPersistentMessage(msg)
    if (self.m_View) then
        self.m_View:showPersistentMessage(msg)
    end

    return self
end

function ModelMessageIndicator:hidePersistentMessage()
    if (self.m_View) then
        self.m_View:hidePersistentMessage()
    end

    return self
end

return ModelMessageIndicator
