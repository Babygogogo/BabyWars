
--[[--------------------------------------------------------------------------------
-- ModelConfirmBox用于构造一个操作确认框，给玩家进一步确认。
--
-- 主要职责及使用场景举例：
--   玩家点击“结束回合”等敏感按钮时时，会弹出本确认框让玩家再次确认，以免误操作。
--
-- 其他：
--   - 本类设有Yes和No两个按钮（以及“取消”操作，在玩家点击框外空白地方时激发），默认的点击行为是使得确认框消失，具体行为需要本类的调用者传入。
--
--   - 本类的文字描述也可以由调用者定制。
--]]--------------------------------------------------------------------------------

local ModelConfirmBox = class("ModelConfirmBox")

local Actor           = require("global.actors.Actor")
local TypeChecker     = require("app.utilities.TypeChecker")

local function createDefaultCallbackOnConfirm(self)
    return function()
        self:setEnabled(false)
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelConfirmBox:ctor(param)
    if (param) then
        if (param.confirmText)     then self:setConfirmText(param.confirmText)         end
        if (param.onConfirmYes)    then self:setOnConfirmYes(param.onConfirmYes)       end
        if (param.onConfirmNo)     then self:setOnConfirmNo(param.onConfirmNo)         end
        if (param.onConfirmCancel) then self:setOnConfirmCancel(param.onConfirmCancel) end
    end
    self.m_ConfirmText     = self.m_ConfirmText     or "Are you sure?"
    self.m_OnConfirmYes    = self.m_OnConfirmYes    or createDefaultCallbackOnConfirm(self)
    self.m_OnConfirmNo     = self.m_OnConfirmNo     or createDefaultCallbackOnConfirm(self)
    self.m_OnConfirmCancel = self.m_OnConfirmCancel or createDefaultCallbackOnConfirm(self)

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
