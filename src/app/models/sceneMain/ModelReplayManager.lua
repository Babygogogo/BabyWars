
local ModelReplayManager = class("ModelReplayManager")

local Actor                 = require("src.global.actors.Actor")
local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")
local SingletonGetters      = require("src.app.utilities.SingletonGetters")
local WebSocketManager      = require("src.app.utilities.WebSocketManager")

local getLocalizedText         = LocalizationFunctions.getLocalizedText
local getModelConfirmBox       = SingletonGetters.getModelConfirmBox
local getModelMainMenu         = SingletonGetters.getModelMainMenu
local getModelMessageIndicator = SingletonGetters.getModelMessageIndicator
local sendAction               = WebSocketManager.sendAction

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
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
                    -- TODO: add code to do the job.
                    print(sceneWarFileName)
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
    if (self.m_View) then
        self.m_View:setMenuTitle(getLocalizedText(10, "Playback"))
            :setButtonConfirmVisible(false)
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

local function setStateDisabled(self)
    self.m_State = "stateDisabled"
    if (self.m_View) then
        self.m_View:setVisible(false)
        getActorWarFieldPreviewer(self):getModel():setEnabled(false)
    end
end

--------------------------------------------------------------------------------
-- The composition items.
--------------------------------------------------------------------------------
local function initItemPlayback(self)
    local item = {
        name     = getLocalizedText(10, "Playback"),
        callback = function()
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

function ModelReplayManager:onButtonBackTouched()
    local state = self.m_State
    if (state == "stateMain") then
        setStateDisabled(self)
        getModelMainMenu():setMenuEnabled(true)
    elseif (state == "stateDownload") then
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
