
local ModelConfirmBox = class("ModelConfirmBox")

local Actor           = require("global.actors.Actor")
local TypeChecker     = require("app.utilities.TypeChecker")

function ModelConfirmBox:ctor(param)
    if (param) then self:load(param) end

	return self
end

function ModelConfirmBox:load(param)
    assert(type(param) == "table", "ModelConfirmBox:load() the param is not a table.")

    self.m_ConfirmText = param.confirmText
    self.m_OnConfirmYes = param.onConfirmYes
    self.m_OnConfirmNo = param.onConfirmNo
    self.m_OnConfirmCancel = param.onConfirmCancel
    
    if (self.m_View) then self:initView() end
		
	return self
end

function ModelConfirmBox.createInstance(param)
	local list = ModelConfirmBox.new():load(param)
    assert(list, "ModelConfirmBox.createInstance() failed.")

	return list
end

function ModelConfirmBox:initView()
    local view = self.m_View
	assert(view, "ModelConfirmBox:initView() no view is attached to the actor of the model.")

    view:setConfirmText(self.m_ConfirmText)
    
    return self
end

function ModelConfirmBox:onConfirmYes()
    if (self.m_OnConfirmYes) then self.m_OnConfirmYes() end
    if (self.m_View) then self.m_View:removeFromParent() end
    
--    print("ModelConfirmBox:onConfirmYes")
    return self
end

function ModelConfirmBox:onConfirmNo()
    if (self.m_OnConfirmNo) then self.m_OnConfirmNo() end
    if (self.m_View) then self.m_View:removeFromParent() end
    
--    print("ModelConfirmBox:onConfirmNo")
    return self
end

function ModelConfirmBox:onConfirmCancel()
    if (self.m_OnConfirmCancel) then self.m_OnConfirmCancel() end
    if (self.m_View) then self.m_View:removeFromParent() end
    
--    print("ModelConfirmBox:onConfirmCancel")
    return self
end

return ModelConfirmBox
