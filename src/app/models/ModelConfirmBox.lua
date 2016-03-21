
local ModelConfirmBox = class("ModelConfirmBox")

local Actor           = require("global.actors.Actor")
local TypeChecker     = require("app.utilities.TypeChecker")

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelConfirmBox:ctor(param)
    if (param) then
        if (param.confirmText)     then self:setConfirmText(param.confirmText)         end
        if (param.onConfirmYes)    then self:setOnConfirmYes(param.onConfirmYes)       end
        if (param.onConfirmNo)     then self:setOnConfirmNo(param.onConfirmNo)         end
        if (param.onConfirmCancel) then self:setOnConfirmCancel(param.onConfirmCancel) end
    end

    if (self.m_View) then
        self:initView()
    end

	return self
end

function ModelConfirmBox:initView()
    local view = self.m_View
	assert(view, "ModelConfirmBox:initView() no view is attached to the actor of the model.")

    view:setConfirmText(self.m_ConfirmText or "")

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelConfirmBox:setConfirmText(text)
    assert(type(text) == "string", "ModelConfirmBox:setConfirmText() the param text is not a string.")
    self.m_ConfirmText = text

    if (self.m_View) then
        self.m_View:setConfirmText(text)
    end

    return self
end

function ModelConfirmBox:setOnConfirmYes(callback)
    assert(type(callback) == "function", "ModelConfirmBox:setOnConfirmYes() the param callback is not a function.")
    self.m_OnConfirmYes = callback

    return self
end

function ModelConfirmBox:onConfirmYes()
    if (self.m_OnConfirmYes) then
        self.m_OnConfirmYes()
    end

    return self
end

function ModelConfirmBox:setOnConfirmNo(callback)
    assert(type(callback) == "function", "ModelConfirmBox:setOnConfirmNo() the param callback is not a function.")
    self.m_OnConfirmNo = callback

    return self
end

function ModelConfirmBox:onConfirmNo()
    if (self.m_OnConfirmNo) then
        self.m_OnConfirmNo()
    end

    return self
end

function ModelConfirmBox:setOnConfirmCancel(callback)
    assert(type(callback) == "function", "ModelConfirmBox:setOnConfirmCancel() the param callback is not a function.")
    self.m_OnConfirmCancel = callback

    return self
end

function ModelConfirmBox:onConfirmCancel()
    if (self.m_OnConfirmCancel) then
        self.m_OnConfirmCancel()
    end

    return self
end

function ModelConfirmBox:setEnabled(enabled)
    if (self.m_View) then
        self.m_View:setEnabled(enabled)
    end

    return self
end

return ModelConfirmBox
