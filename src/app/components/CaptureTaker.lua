
local CaptureTaker = class("CaptureTaker")

local MAX_CAPTURE_POINT = 20

local TypeChecker        = require("app.utilities.TypeChecker")
local ComponentManager   = require("global.components.ComponentManager")
local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

local EXPORTED_METHODS = {
	"getCapturePoint",
	"setCapturePoint",
    "getCapturerID",
    "setCapturerID",
}

function CaptureTaker:ctor(param)
    self.m_CapturePoint = MAX_CAPTURE_POINT
    self.m_CapturerID = 0

    if (param) then
        self:load(param)
    end

    return self
end

function CaptureTaker:bind(target)
	ComponentManager.setMethods(target, self, EXPORTED_METHODS)

	self.m_Target = target
end

function CaptureTaker:unbind(target)
    assert(self.m_Target == target , "CaptureTaker:unbind() the component is not bind to the parameter target")
    assert(self.m_Target, "CaptureTaker:unbind() the component is not bind to any target.")

    ComponentManager.unsetMethods(self.m_Target, EXPORTED_METHODS)
    self.m_Target = nil
end

function CaptureTaker:load(param)
    self.m_CapturePoint = param.capturePoint or self.m_CapturePoint
    self.m_CapturerID   = param.capturerID   or self.m_CapturerID

    return self
end

function CaptureTaker:getCapturePoint()
    return self.m_CapturePoint
end

function CaptureTaker:setCapturePoint(point)
    self.m_CapturePoint = point
    
    return self
end

function CaptureTaker:getCapturerID()
    return self.m_CapturerID
end

function CaptureTaker:setCapturerID(id)
    self.m_CapturerID = id
    
    return self
end

return CaptureTaker
