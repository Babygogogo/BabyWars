
local ModelLoginPanel = class("ModelLoginPanel")

local LocalizationFunctions  = requireBW("src.app.utilities.LocalizationFunctions")
local SerializationFunctions = requireBW("src.app.utilities.SerializationFunctions")
local SingletonGetters       = requireBW("src.app.utilities.SingletonGetters")
local WebSocketManager       = requireBW("src.app.utilities.WebSocketManager")

local getActionCode                 = requireBW("src.app.utilities.ActionCodeFunctions").getActionCode
local getModelMessageIndicator      = SingletonGetters.getModelMessageIndicator
local getLocalizedText              = LocalizationFunctions.getLocalizedText
local getLoggedInAccountAndPassword = WebSocketManager.getLoggedInAccountAndPassword
local loadAccountAndPassword        = SerializationFunctions.loadAccountAndPassword
local serializeAccountAndPassword   = SerializationFunctions.serializeAccountAndPassword

local ACTION_CODE_LOGIN    = getActionCode("ActionLogin")
local ACTION_CODE_REGISTER = getActionCode("ActionRegister")
local GAME_VERSION         = requireBW("src.app.utilities.GameConstantFunctions").getGameVersion()

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function validateAccountOrPassword(str)--验证str作为账户密码的合法性
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

--------------------------------------------------------------------------------
-- The callback function on start running.
--------------------------------------------------------------------------------
function ModelLoginPanel:onStartRunning(modelSceneMain)
    self.m_ModelSceneMain = modelSceneMain

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelLoginPanel:isEnabled()
    return self.m_IsEnabled
end

function ModelLoginPanel:setEnabled(enabled)
    self.m_IsEnabled = enabled

    local view = self.m_View
    if (view) then
        view:setEnabled(enabled)
        if (enabled) then
            view:setAccountAndPassword(loadAccountAndPassword())
        end
    end

    return self
end

function ModelLoginPanel:onButtonRegisterTouched(account, password)
    if ((not validateAccountOrPassword(account)) or (not validateAccountOrPassword(password))) then
        getModelMessageIndicator(self.m_ModelSceneMain):showMessage(getLocalizedText(19))
    elseif (account == getLoggedInAccountAndPassword()) then
        getModelMessageIndicator(self.m_ModelSceneMain):showMessage(getLocalizedText(21, account))
    else
        if (self.m_View) then
            self.m_View:disableButtonRegisterForSecs(5)
        end

        local modelConfirmBox = SingletonGetters.getModelConfirmBox(self.m_ModelSceneMain)
        modelConfirmBox:setConfirmText(getLocalizedText(24, account, password))
            :setOnConfirmYes(function()
                WebSocketManager.sendAction({
                    actionCode       = ACTION_CODE_REGISTER,
                    clientVersion    = GAME_VERSION,
                    registerAccount  = account,
                    registerPassword = password,
                }, true)
                modelConfirmBox:setEnabled(false)
            end)
            :setEnabled(true)
    end

    return self
end

function ModelLoginPanel:onButtonLoginTouched(account, password)
    if ((not validateAccountOrPassword(account)) or (not validateAccountOrPassword(password))) then
        getModelMessageIndicator(self.m_ModelSceneMain):showMessage(getLocalizedText(19))
    elseif (account == getLoggedInAccountAndPassword()) then
        getModelMessageIndicator(self.m_ModelSceneMain):showMessage(getLocalizedText(21, account))
    else
        if (self.m_View) then
            self.m_View:disableButtonLoginForSecs(5)
        end
        WebSocketManager.sendAction({
            actionCode    = ACTION_CODE_LOGIN,
            clientVersion = GAME_VERSION,
            loginAccount  = account,
            loginPassword = password,
        }, true)
    end

    return self
end

function ModelLoginPanel:onCancel()
    if (self.m_View) then
        self.m_View:setEnabled(false)
    end

    self.m_ModelMainMenu:setMenuEnabled(true)

    return self
end

return ModelLoginPanel
