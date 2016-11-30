
local ModelReplayManager = class("ModelReplayManager")

local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")
local SingletonGetters      = require("src.app.utilities.SingletonGetters")

local getLocalizedText = LocalizationFunctions.getLocalizedText
local getModelMainMenu = SingletonGetters.getModelMainMenu

--------------------------------------------------------------------------------
-- The functions for managing states.
--------------------------------------------------------------------------------
local function setStateMain(self)
    self.m_State = "stateMain"
    if (self.m_View) then
        self.m_View:setMenuTitle(getLocalizedText(1, "ManageReplay"))
            :setMenuItems(self.m_ItemsForStateMain)
            :setVisible(true)
    end
end

local function setStatePlayback(self)
    self.m_State = "statePlayback"
    if (self.m_View) then
        self.m_View:setMenuTitle(getLocalizedText(10, "Playback"))
    end
end

local function setStateDisabled(self)
    self.m_State = "stateDisabled"
    if (self.m_View) then
        self.m_View:setVisible(false)
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
function ModelReplayManager:setEnabled(enabled)
    if (enabled) then
        setStateMain(self)
    else
        setStateDisabled(self)
    end

    return self
end

function ModelReplayManager:onButtonBackTouched()
    local state = self.m_State
    if (state == "stateMain") then
        setStateDisabled(self)
        getModelMainMenu():setMenuEnabled(true)
    else
        error("ModelSkillConfigurator:onButtonBackTouched() the current state is invalid: " .. state)
    end

    return self
end

return ModelReplayManager
