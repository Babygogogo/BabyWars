
local ModelChatManager = requireBW("src.global.functions.class")("ModelChatManager")

local ActionCodeFunctions   = requireBW("src.app.utilities.ActionCodeFunctions")
local LocalizationFunctions = requireBW("src.app.utilities.LocalizationFunctions")
local SingletonGetters      = requireBW("src.app.utilities.SingletonGetters")

local IS_SERVER           = requireBW("src.app.utilities.GameConstantFunctions").isServer()
local WebSocketManager    = (not IS_SERVER) and (requireBW("src.app.utilities.WebSocketManager")) or (nil)

local getLocalizedText    = LocalizationFunctions.getLocalizedText
local math, string, table = math, string, table

local MESSAGE_CAPACITY_PER_CHANNEL = 20
local ACTION_CODE_CHAT             = ActionCodeFunctions.getActionCode("ActionChat")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getPrivateChannelsCount(playersCount)
    return playersCount * (playersCount - 1) / 2
end

local function getChatTargetAccount(self, channelID)
    local map          = self.m_ChannelIdMap
    local playersCount = self.m_PlayersCount
    for index1 = 1, playersCount - 1 do
        for index2 = index1 + 1, playersCount do
            if (map[index1][index2] == channelID) then
                local index = (index1 == self.m_PlayerIndexLoggedIn) and (index2) or (index1)
                return self.m_ModelPlayerManager:getModelPlayer(index):getAccount()
            end
        end
    end

    error("ModelChatManager-getChatTargetAccount() failed to find the account with channelID: " .. (channelID or ""))
end

local function generateChannelText(self, channelID)
    local textList = {}
    if (not channelID) then
        textList[#textList + 1] = getLocalizedText(65, "Channel Public") .. "\n"
    else
        textList[#textList + 1] = string.format("%s %s\n", getLocalizedText(65, "Channel Private"), getChatTargetAccount(self, channelID))
    end

    local channel  = (channelID) and (self.m_PrivateChannels[channelID]) or (self.m_PublicChannel)
    local messages = channel.messages
    if ((not messages) or (#messages == 0)) then
        textList[#textList + 1] = getLocalizedText(65, "NoHistoricalChat")
    else
        local modelPlayerManager = self.m_ModelPlayerManager
        for _, message in ipairs(messages) do
            textList[#textList + 1] = string.format("[%s]: %s", modelPlayerManager:getModelPlayer(message.senderPlayerIndex):getAccount(), message.text)
        end
    end

    return table.concat(textList, "\n")
end

--------------------------------------------------------------------------------
-- The state setters.
--------------------------------------------------------------------------------
local function setStatePrivateChannel(self, channelID)
    self.m_State            = "statePrivateChannel"
    self.m_PrivateChannelID = channelID

    if (self.m_View) then
        self.m_View:setVisible(true)
            :setOverviewText(generateChannelText(self, channelID))
    end
    if (self.m_ScriptEventDispatcher) then
        self.m_ScriptEventDispatcher:dispatchEvent({name = "EvtChatManagerUpdated"})
    end
end

local function setStatePublicChannel(self)
    self.m_State            = "statePublicChannel"
    self.m_PrivateChannelID = nil

    if (self.m_View) then
        self.m_View:setVisible(true)
            :setOverviewText(generateChannelText(self, nil))
    end
    if (self.m_ScriptEventDispatcher) then
        self.m_ScriptEventDispatcher:dispatchEvent({name = "EvtChatManagerUpdated"})
    end
end

local function setStateDisabled(self)
    self.m_State            = "stateDisabled"
    self.m_PrivateChannelID = nil

    if (self.m_View) then
        self.m_View:setVisible(false)
    end
    if (self.m_ScriptEventDispatcher) then
        self.m_ScriptEventDispatcher:dispatchEvent({name = "EvtChatManagerUpdated"})
    end
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initItemPublicChannel(self)
    self.m_ItemPublicChannel = {
        name     = getLocalizedText(65, "Channel Public"),
        callback = function()
            setStatePublicChannel(self)
        end,
    }
end

local function initChannelIdMap(self, playersCount)
    local map = {}
    for playerIndex = 1, playersCount do
        map[playerIndex] = {}
    end

    local channelID = 1
    for p1 = 1, playersCount - 1 do
        for p2 = p1 + 1, playersCount do
            map[p1][p2], map[p2][p1] = channelID, channelID
            channelID = channelID + 1
        end
    end

    self.m_ChannelIdMap = map
end

local function generateItemsChannel(self)
    local items        = {self.m_ItemPublicChannel}
    local playersCount = self.m_PlayersCount

    if (playersCount > 2) then
        local playerIndexLoggedIn = self.m_PlayerIndexLoggedIn
        local modelPlayerManager  = self.m_ModelPlayerManager

        for playerIndex = 1, playersCount do
            if (playerIndex ~= playerIndexLoggedIn) then
                local modelPlayer = modelPlayerManager:getModelPlayer(playerIndex)
                items[#items + 1] = {
                    name     = modelPlayer:getAccount(),
                    callback = function()
                        setStatePrivateChannel(self, self.m_ChannelIdMap[playerIndexLoggedIn][playerIndex])
                        self.m_View:setButtonSendEnabled(modelPlayer:isAlive())
                    end,
                }
            end
        end
    end

    return items
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelChatManager:ctor(chatData)
    chatData               = chatData or {}
    self.m_PublicChannel   = chatData.publicChannel   or {}
    self.m_PrivateChannels = chatData.privateChannels or {}
    self.m_State           = "stateDisabled"

    initItemPublicChannel(self)

    return self
end

function ModelChatManager:onStartRunning(modelSceneWar)
    self.m_ModelSceneWar         = modelSceneWar
    self.m_ModelPlayerManager    = SingletonGetters.getModelPlayerManager(   modelSceneWar)
    self.m_ScriptEventDispatcher = SingletonGetters.getScriptEventDispatcher(modelSceneWar)
    self.m_WarID                 = SingletonGetters.getWarId(                modelSceneWar)

    local playersCount = self.m_ModelPlayerManager:getPlayersCount()
    for channelID = 1, getPrivateChannelsCount(playersCount) do
        self.m_PrivateChannels[channelID] = self.m_PrivateChannels[channelID] or {}
    end
    self.m_PlayersCount = playersCount
    initChannelIdMap(self, playersCount)

    if ((not IS_SERVER) and (not SingletonGetters.isTotalReplay(modelSceneWar))) then
        self.m_ModelMessageIndicator = SingletonGetters.getModelMessageIndicator(modelSceneWar)
        self.m_PlayerIndexLoggedIn   = self.m_ModelPlayerManager:getPlayerIndexLoggedIn()
    end

    return self
end

--------------------------------------------------------------------------------
-- The functions for serialization.
--------------------------------------------------------------------------------
function ModelChatManager:toSerializableTable()
    return {
        publicChannel   = self.m_PublicChannel,
        privateChannels = self.m_PrivateChannels,
    }
end

function ModelChatManager:toSerializableTableForPlayerIndex(playerIndex)
    local privateChannels = self.m_PrivateChannels
    local map             = self.m_ChannelIdMap
    local t               = {}

    for index = 1, self.m_PlayersCount do
        if (index ~= playerIndex) then
            local channelID = map[playerIndex][index]
            t[channelID] = privateChannels[channelID]
        end
    end
    for channelID = 1, #privateChannels do
        t[channelID] = t[channelID] or {}
    end

    return {
        publicChannel   = self.m_PublicChannel,
        privateChannels = t,
    }
end

--------------------------------------------------------------------------------
-- The public functions/accessors.
--------------------------------------------------------------------------------
function ModelChatManager:isEnabled()
    return self.m_State ~= "stateDisabled"
end

function ModelChatManager:setEnabled(enabled)
    if (enabled) then
        setStatePublicChannel(self)
        self.m_View:setMenuItems(generateItemsChannel(self))
    else
        setStateDisabled(self)
    end

    return self
end

function ModelChatManager:getChannelIdWithPlayerIndices(playerIndex1, playerIndex2)
    return self.m_ChannelIdMap[playerIndex1][playerIndex2]
end

function ModelChatManager:updateWithChatMessage(channelID, senderPlayerIndex, chatText)
    local channel = (channelID) and (self.m_PrivateChannels[channelID]) or (self.m_PublicChannel)
    channel.messages = channel.messages or {}
    local messages = channel.messages
    messages[#messages + 1] = {
        text              = chatText,
        senderPlayerIndex = senderPlayerIndex,
    }
    if (#messages > MESSAGE_CAPACITY_PER_CHANNEL) then
        table.remove(messages, 1)
    end

    if (not IS_SERVER) then
        if ((not self:isEnabled()) or (self.m_PrivateChannelID ~= channelID)) then
            self.m_ModelMessageIndicator:showMessage(string.format("%s[%s]: %s",
                getLocalizedText(65, "Player"),
                self.m_ModelPlayerManager:getModelPlayer(senderPlayerIndex):getAccount(),
                chatText
            ))
        else
            self.m_View:setOverviewText(generateChannelText(self, channelID))
        end
    end

    return self
end

function ModelChatManager:onButtonBackTouched()
    setStateDisabled(self)

    return self
end

function ModelChatManager:onButtonSendTouched(chatText)
    if (string.len(chatText) > 0) then
        self.m_View:setInputBarText("")

        WebSocketManager.sendAction({
            actionCode = ACTION_CODE_CHAT,
            warID      = self.m_WarID,
            channelID  = self.m_PrivateChannelID,
            chatText   = chatText,
        })
    end

    return self
end

return ModelChatManager
