
local ModelLoginPanel = class("ModelLoginPanel")

local LocalizationFunctions  = require("src.app.utilities.LocalizationFunctions")
local SerializationFunctions = require("src.app.utilities.SerializationFunctions")
local SingletonGetters       = require("src.app.utilities.SingletonGetters")
local WebSocketManager       = require("src.app.utilities.WebSocketManager")

local getActionCode                 = require("src.app.utilities.ActionCodeFunctions").getActionCode
local getModelMessageIndicator      = SingletonGetters.getModelMessageIndicator
local getLocalizedText              = LocalizationFunctions.getLocalizedText
local getLoggedInAccountAndPassword = WebSocketManager.getLoggedInAccountAndPassword
local loadAccountAndPassword        = SerializationFunctions.loadAccountAndPassword
local sendAction                    = WebSocketManager.sendAction
local serializeAccountAndPassword   = SerializationFunctions.serializeAccountAndPassword

local ACTION_CODE_LOGIN    = getActionCode("Login")
local ACTION_CODE_REGISTER = getActionCode("Register")
local GAME_VERSION         = require("src.app.utilities.GameConstantFunctions").getGameVersion()

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
        getModelMessageIndicator():showMessage(getLocalizedText(19))
    elseif (account == getLoggedInAccountAndPassword()) then
        getModelMessageIndicator():showMessage(getLocalizedText(21, account))
    else
        if (self.m_View) then
            self.m_View:disableButtonRegisterForSecs(5)
        end

        local modelConfirmBox = SingletonGetters.getModelConfirmBox()
        modelConfirmBox:setConfirmText(getLocalizedText(24, account, password))
            :setOnConfirmYes(function()
                sendAction({
                    actionCode       = ACTION_CODE_REGISTER,
                    clientVersion    = GAME_VERSION,
                    registerAccount  = account,
                    registerPassword = password,
                })
                modelConfirmBox:setEnabled(false)
            end)
            :setEnabled(true)
    end

    return self
end

function ModelLoginPanel:onButtonLoginTouched(account, password)
    if ((not validateAccountOrPassword(account)) or (not validateAccountOrPassword(password))) then
        getModelMessageIndicator():showMessage(getLocalizedText(19))
    elseif (account == getLoggedInAccountAndPassword()) then
        getModelMessageIndicator():showMessage(getLocalizedText(21, account))
    else
        if (self.m_View) then
            self.m_View:disableButtonLoginForSecs(5)
        end
        sendAction({
            actionCode    = ACTION_CODE_LOGIN,
            clientVersion = GAME_VERSION,
            loginAccount  = account,
            loginPassword = password,
        })
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
