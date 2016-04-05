
local CaptureTaker = class("CaptureTaker")

local TypeChecker        = require("app.utilities.TypeChecker")
local ComponentManager   = require("global.components.ComponentManager")

local EXPORTED_METHODS = {
    "getCurrentCapturePoint",
    "setCurrentCapturePoint",
    "getMaxCapturePoint",
    "getCapturerID",
    "setCapturerID",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function CaptureTaker:ctor(param)
    self.m_CapturerID = 0

    if (param) then
        self:load(param)
    end

    return self
end

function CaptureTaker:load(param)
    self.m_MaxCapturePoint     = param.maxCapturePoint or self.m_MaxCapturePoint
    self.m_CurrentCapturePoint = param.capturePoint    or self.m_MaxCapturePoint
    self.m_CapturerID          = param.capturerID      or self.m_CapturerID

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function CaptureTaker:onBind(target)
    assert(self.m_Target == nil, "CaptureTaker:onBind() the component has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Target = target

    return self
end

function CaptureTaker:onUnbind()
    assert(self.m_Target ~= nil, "CaptureTaker:onUnbind() the component has not bound a target.")

    ComponentManager.unsetMethods(self.m_Target, EXPORTED_METHODS)
    self.m_Target = nil

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function CaptureTaker:getCurrentCapturePoint()
    return self.m_CurrentCapturePoint
end

function CaptureTaker:setCurrentCapturePoint(point)
    self.m_CurrentCapturePoint = point

    return self
end

function CaptureTaker:getMaxCapturePoint()
    return self.m_MaxCapturePoint
end

function CaptureTaker:getCapturerID()
    return self.m_CapturerID
end

function CaptureTaker:setCapturerID(id)
    self.m_CapturerID = id

    return self
end

return CaptureTaker
