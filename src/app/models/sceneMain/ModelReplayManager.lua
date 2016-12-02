
local ModelReplayManager = class("ModelReplayManager")

local Actor                  = require("src.global.actors.Actor")
local LocalizationFunctions  = require("src.app.utilities.LocalizationFunctions")
local SingletonGetters       = require("src.app.utilities.SingletonGetters")
local SerializationFunctions = require("src.app.utilities.SerializationFunctions")
local WebSocketManager       = require("src.app.utilities.WebSocketManager")

local appendToFile             = SerializationFunctions.appendToFile
local getLocalizedText         = LocalizationFunctions.getLocalizedText
local getModelConfirmBox       = SingletonGetters.getModelConfirmBox
local getModelMainMenu         = SingletonGetters.getModelMainMenu
local getModelMessageIndicator = SingletonGetters.getModelMessageIndicator
local sendAction               = WebSocketManager.sendAction

local REPLAY_DIRECTORY_PATH = cc.FileUtils:getInstance():getWritablePath() .. "writablePath/replay/"
local REPLAY_LIST_PATH      = REPLAY_DIRECTORY_PATH .. "ReplayList.lua"

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function hasReplayData(self, sceneWarFileName)
    return self.m_ReplayList[sceneWarFileName]
end

local function deleteReplayData(self, sceneWarFileName)
    if (self.m_ReplayList[sceneWarFileName]) then
        os.remove(REPLAY_DIRECTORY_PATH .. sceneWarFileName .. ".lua")

        self.m_ReplayList[sceneWarFileName] = nil
        local fileForList = io.open(REPLAY_LIST_PATH, "w")
        fileForList:write("return ")
        appendToFile(self.m_ReplayList, "", fileForList)
        fileForList:close()
    end
end

local function generateReplayConfiguration(warData)
    local players = {}
    for playerIndex, player in pairs(warData.players) do
        players[playerIndex] = {
            account  = player.account,
            nickname = player.nickname,
        }
    end

    return {
        warFieldFileName    = warData.warField.tileMap.template,
        maxSkillPoints      = warData.maxSkillPoints,
        isFogOfWarByDefault = warData.isFogOfWarByDefault,
        players             = players,

        -- TODO: add code to generate the real configuration of the weather/fog.
        weather          = "Clear",
    }
end

local function getPlayerNicknames(warConfiguration)
    local playersCount = require("res.data.templateWarField." .. warConfiguration.warFieldFileName).playersCount
    local names        = {}
    local players      = warConfiguration.players

    for i = 1, playersCount do
        if (players[i]) then
            names[i] = players[i].account
        end
    end

    return names, playersCount
end

local function getActorWarFieldPreviewer(self)
    if (not self.m_ActorWarFieldPreviewer) then
        local actor = Actor.createWithModelAndViewName("sceneMain.ModelWarFieldPreviewer", nil, "sceneMain.ViewWarFieldPreviewer")

        self.m_ActorWarFieldPreviewer = actor
        if (self.m_View) then
            self.m_View:setViewWarFieldPreviewer(actor:getView())
        end
    end

    return self.m_ActorWarFieldPreviewer
end

local setStateDelete
local function createMenuItemsForDelete(self)
    local items = {}
    for sceneWarFileName, configuration in pairs(self.m_ReplayList) do
        local warFieldFileName = configuration.warFieldFileName
        items[#items + 1] = {
            name             = require("res.data.templateWarField." .. warFieldFileName).warFieldName,
            sceneWarFileName = sceneWarFileName,

            callback         = function()
                getActorWarFieldPreviewer(self):getModel():setWarField(warFieldFileName)
                    :setPlayerNicknames(getPlayerNicknames(configuration))
                    :setEnabled(true)
                if (self.m_View) then
                    self.m_View:setButtonConfirmVisible(true)
                end

                self.m_OnButtonConfirmTouched = function()
                    local modelConfirmBox = getModelConfirmBox()
                    modelConfirmBox:setEnabled(true)
                        :setConfirmText(getLocalizedText(10, "DeleteConfirmation"))
                        :setOnConfirmYes(function()
                            deleteReplayData(self, sceneWarFileName)
                            setStateDelete(self)
                            modelConfirmBox:setEnabled(false)
                        end)
                end
            end,
        }
    end

    table.sort(items, function(item1, item2)
        return item1.sceneWarFileName < item2.sceneWarFileName
    end)

    return items
end

local function createMenuItemsForDownload(self, list)
    local items = {}
    for sceneWarFileName, configuration in pairs(list) do
        local warFieldFileName = configuration.warFieldFileName
        items[#items + 1] = {
            name             = require("res.data.templateWarField." .. warFieldFileName).warFieldName,
            sceneWarFileName = sceneWarFileName,

            callback         = function()
                getActorWarFieldPreviewer(self):getModel():setWarField(warFieldFileName)
                    :setPlayerNicknames(getPlayerNicknames(configuration))
                    :setEnabled(true)
                if (self.m_View) then
                    self.m_View:setButtonConfirmVisible(true)
                end

                self.m_OnButtonConfirmTouched = function()
                    if (hasReplayData(self, sceneWarFileName)) then
                        getModelMessageIndicator():showMessage(getLocalizedText(10, "ReplayDataExists"))
                    else
                        sendAction({
                            actionName       = "DownloadReplayData",
                            sceneWarFileName = sceneWarFileName,
                        })
                        if (self.m_View) then
                            self.m_View:disableButtonConfirmForSecs(10)
                        end

                        getModelMessageIndicator():showMessage(getLocalizedText(10, "DownloadStarted"))
                    end
                end
            end,
        }
    end

    table.sort(items, function(item1, item2)
        return item1.sceneWarFileName < item2.sceneWarFileName
    end)

    return items
end

local function createMenuItemsForPlayback(self)
    local items = {}
    for sceneWarFileName, configuration in pairs(self.m_ReplayList) do
        local warFieldFileName = configuration.warFieldFileName
        items[#items + 1] = {
            name             = require("res.data.templateWarField." .. warFieldFileName).warFieldName,
            sceneWarFileName = sceneWarFileName,

            callback         = function()
                getActorWarFieldPreviewer(self):getModel():setWarField(warFieldFileName)
                    :setPlayerNicknames(getPlayerNicknames(configuration))
                    :setEnabled(true)
                if (self.m_View) then
                    self.m_View:setButtonConfirmVisible(true)
                end

                self.m_OnButtonConfirmTouched = function()
                    getModelMessageIndicator():showMessage("播放功能尚未完成开发，请谅解。")
                end
            end,
        }
    end

    table.sort(items, function(item1, item2)
        return item1.sceneWarFileName < item2.sceneWarFileName
    end)

    return items
end

--------------------------------------------------------------------------------
-- The functions for managing states.
--------------------------------------------------------------------------------
setStateDelete = function(self)
    self.m_State = "stateDelete"
    local view = self.m_View
    if (view) then
        view:setMenuTitle(getLocalizedText(10, "DeleteReplay"))
            :setButtonConfirmText(getLocalizedText(10, "DeleteReplay"))
            :setButtonConfirmVisible(false)
            :enableButtonConfirm()
        getActorWarFieldPreviewer(self):getModel():setEnabled(false)

        local items = createMenuItemsForDelete(self)
        if (#items == 0) then
            view:removeAllMenuItems()
            getModelMessageIndicator():showMessage(getLocalizedText(10, "NoReplayData"))
        else
            view:setMenuItems(items)
        end
    end
end

local function setStateDisabled(self)
    self.m_State = "stateDisabled"
    if (self.m_View) then
        self.m_View:setVisible(false)
        getActorWarFieldPreviewer(self):getModel():setEnabled(false)
    end
end

local function setStateDownload(self)
    self.m_State = "stateDownload"
    if (self.m_View) then
        self.m_View:setMenuTitle(getLocalizedText(10, "DownloadReplay"))
            :setButtonConfirmVisible(false)
            :removeAllMenuItems()
        getActorWarFieldPreviewer(self):getModel():setEnabled(false)
    end
end

local function setStateMain(self)
    self.m_State = "stateMain"
    if (self.m_View) then
        self.m_View:setMenuTitle(getLocalizedText(1, "ManageReplay"))
            :setMenuItems(self.m_ItemsForStateMain)
            :setButtonConfirmVisible(false)
            :setVisible(true)
        getActorWarFieldPreviewer(self):getModel():setEnabled(false)
    end
end

local function setStatePlayback(self)
    self.m_State = "statePlayback"
    local view = self.m_View
    if (view) then
        view:setMenuTitle(getLocalizedText(10, "Playback"))
            :setButtonConfirmText(getLocalizedText(10, "Playback"))
            :setButtonConfirmVisible(false)
            :enableButtonConfirm()
        getActorWarFieldPreviewer(self):getModel():setEnabled(false)

        local items = createMenuItemsForPlayback(self)
        if (#items == 0) then
            view:removeAllMenuItems()
            getModelMessageIndicator():showMessage(getLocalizedText(10, "NoReplayData"))
        else
            view:setMenuItems(items)
        end
    end
end

--------------------------------------------------------------------------------
-- The composition items.
--------------------------------------------------------------------------------
local function initReplayList(self)
    local file = io.open(REPLAY_LIST_PATH, "r")
    if (file) then
        file:close()
        self.m_ReplayList = dofile(REPLAY_LIST_PATH)
    else
        cc.FileUtils:getInstance():createDirectory(REPLAY_DIRECTORY_PATH)
        file = io.open(REPLAY_LIST_PATH, "w")
        file:write("return {}")
        file:close()
        self.m_ReplayList = {}
    end
end

local function initItemPlayback(self)
    local item = {
        name     = getLocalizedText(10, "Playback"),
        callback = function()
            setStatePlayback(self)
        end,
    }

    self.m_ItemPlayback = item
end

local function initItemDownload(self)
    local item = {
        name     = getLocalizedText(10, "Download"),
        callback = function()
            setStateDownload(self)
            sendAction({
                actionName = "GetReplayList",
                pageIndex  = 1,
            })
        end,
    }

    self.m_ItemDownload = item
end

local function initItemDelete(self)
    local item = {
        name     = getLocalizedText(10, "Delete"),
        callback = function()
            setStateDelete(self)
        end,
    }

    self.m_ItemDelete = item
end

local function initItemsForStateMain(self)
    self.m_ItemsForStateMain = {
        self.m_ItemPlayback,
        self.m_ItemDownload,
        self.m_ItemDelete,
    }
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelReplayManager:ctor()
    self.m_State = "stateDisabled"

    initReplayList(       self)
    initItemPlayback(     self)
    initItemDownload(     self)
    initItemDelete(       self)
    initItemsForStateMain(self)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelReplayManager:getState()
    return self.m_State
end

function ModelReplayManager:setEnabled(enabled)
    if (enabled) then
        setStateMain(self)
    else
        setStateDisabled(self)
    end

    return self
end

function ModelReplayManager:setDownloadList(list)
    local items = createMenuItemsForDownload(self, list)
    if (#items == 0) then
        getModelMessageIndicator():showMessage(getLocalizedText(10, "NoDownloadableReplay"))
    elseif (self.m_View) then
        self.m_View:setMenuItems(items)
            :setButtonConfirmText(getLocalizedText(10, "DownloadReplay"))
    end

    return self
end

function ModelReplayManager:serializeReplayData(sceneWarFileName, data)
    if (hasReplayData(self, sceneWarFileName)) then
        return
    end

    local fileNameForData = REPLAY_DIRECTORY_PATH .. sceneWarFileName .. ".lua"
    local fileForData = io.open(fileNameForData, "w")
    fileForData:write(data)
    fileForData:close()

    local fileForList = io.open(REPLAY_LIST_PATH, "w")
    fileForList:write("return ")
    self.m_ReplayList[sceneWarFileName] = generateReplayConfiguration(dofile(fileNameForData))
    appendToFile(self.m_ReplayList, "", fileForList)
    fileForList:close()
end

function ModelReplayManager:onButtonBackTouched()
    local state = self.m_State
    if (state == "stateMain") then
        setStateDisabled(self)
        getModelMainMenu():setMenuEnabled(true)
    elseif (state == "stateDownload") then
        setStateMain(self)
    elseif (state == "stateDelete") then
        setStateMain(self)
    elseif (state == "statePlayback") then
        setStateMain(self)
    else
        error("ModelSkillConfigurator:onButtonBackTouched() the current state is invalid: " .. state)
    end

    return self
end

function ModelReplayManager:onButtonConfirmTouched()
    self.m_OnButtonConfirmTouched()

    return self
end

return ModelReplayManager
