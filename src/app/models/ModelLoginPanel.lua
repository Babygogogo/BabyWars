
local ModelLoginPanel = class("ModelLoginPanel")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function validateAccountOrPassword(str)
    return (#str >= 6) and (not string.find(str, "[^%w_]"))
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelLoginPanel:ctor(param)
    return self
end

function ModelLoginPanel:setModelMainMenu(model)
    assert(self.m_ModelMainMenu == nil, "ModelLoginPanel:setModelMainMenu() the model has been set.")
    self.m_ModelMainMenu = model

    return self
end

function ModelLoginPanel:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelLoginPanel:setRootScriptEventDispatcher() the dispatcher has been set.")
    self.m_RootScriptEventDispatcher = dispatcher

    return self
end

--------------------------------------------------------------------------------
-- The public functions for doing actions.
--------------------------------------------------------------------------------
function ModelLoginPanel:doActionLogin(action)
    if (action.isSuccessful) then
        self.m_PlayerAccount = action.account
        self:setEnabled(false)
    elseif (self.m_View) then
        self.m_View:showMessage("Invalid account/password.")
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelLoginPanel:setEnabled(enabled)
    if (self.m_View) then
        self.m_View:setEnabled(enabled)
    end

    return self
end

function ModelLoginPanel:onButtonConfirmTouched(account, password)
    if (self.m_View) then
        if ((not validateAccountOrPassword(account)) or (not validateAccountOrPassword(password))) then
            self.m_View:showMessage("Only alphanumeric characters and/or underscores are allowed for account and password.")
        elseif (account == self.m_PlayerAccount) then
            self.m_View:showMessage("You have already logged in as " .. account .. ".")
        else
            self.m_View:disableButtonConfirmForSecs(5)
            self.m_RootScriptEventDispatcher:dispatchEvent({
                name       = "EvtPlayerRequestDoAction",
                actionName = "Login",
                account    = account,
                password   = password
            })
        end
    end

    return self
end

function ModelLoginPanel:onButtonCancelTouched()
    if (self.m_View) then
        self.m_View:setEnabled(false)
    end

    self.m_ModelMainMenu:setMenuEnabled(true)

    return self
end

return ModelLoginPanel
