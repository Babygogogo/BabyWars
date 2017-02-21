
local ModelChatManager = requireBW("src.global.functions.class")("ModelChatManager")

local SingletonGetters = requireBW("src.app.utilities.SingletonGetters")

local CHANNEL_ID_PUBLIC = 1

--------------------------------------------------------------------------------
-- The state setters.
--------------------------------------------------------------------------------
local function setStateEnabled(self, channelID)
    self.m_ChannelID = channelID
    if (self.m_View) then
        self.m_View:setVisible(true)
    end
    if (self.m_ScriptEventDispatcher) then
        self.m_ScriptEventDispatcher:dispatchEvent({name = "EvtChatManagerUpdated"})
    end
end

local function setStateDisabled(self)
    self.m_ChannelID = nil
    if (self.m_View) then
        self.m_View:setVisible(false)
    end
    if (self.m_ScriptEventDispatcher) then
        self.m_ScriptEventDispatcher:dispatchEvent({name = "EvtChatManagerUpdated"})
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelChatManager:ctor(chatData)
    return self
end

function ModelChatManager:onStartRunning(modelSceneWar)
    self.m_ModelSceneWar         = modelSceneWar
    self.m_ScriptEventDispatcher = SingletonGetters.getScriptEventDispatcher(modelSceneWar)

    return self
end

--------------------------------------------------------------------------------
-- The functions for serialization.
--------------------------------------------------------------------------------
function ModelChatManager:toSerializableTable()
end

function ModelChatManager:toSerializableTableForPlayerIndex(playerIndex)
end

--------------------------------------------------------------------------------
-- The public functions/accessors.
--------------------------------------------------------------------------------
function ModelChatManager:isEnabled()
    return self.m_ChannelID ~= nil
end

function ModelChatManager:setEnabled(enabled)
    if (enabled) then
        setStateEnabled(self, CHANNEL_ID_PUBLIC)
    else
        setStateDisabled(self)
    end

    return self
end

function ModelChatManager:onButtonBackTouched()
    setStateDisabled(self)

    return self
end

function ModelChatManager:onButtonSendTouched()
end

return ModelChatManager
