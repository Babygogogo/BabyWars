
local ModelWarConfigurator = class("ModelWarConfigurator")

local Actor                     = require("src.global.actors.Actor")
local ActionCodeFunctions       = require("src.app.utilities.ActionCodeFunctions")
local AuxiliaryFunctions        = require("src.app.utilities.AuxiliaryFunctions")
local LocalizationFunctions     = require("src.app.utilities.LocalizationFunctions")
local SingletonGetters          = require("src.app.utilities.SingletonGetters")
local SkillDataAccessors        = require("src.app.utilities.SkillDataAccessors")
local SkillDescriptionFunctions = require("src.app.utilities.SkillDescriptionFunctions")
local WarFieldManager           = require("src.app.utilities.WarFieldManager")
local WebSocketManager          = require("src.app.utilities.WebSocketManager")

local string           = string
local getLocalizedText = LocalizationFunctions.getLocalizedText

local ACTION_CODE_GET_SKILL_CONFIGURATION     = ActionCodeFunctions.getActionCode("ActionGetSkillConfiguration")
local ACTION_CODE_JOIN_WAR                    = ActionCodeFunctions.getActionCode("ActionJoinWar")
local ACTION_CODE_NEW_WAR                     = ActionCodeFunctions.getActionCode("ActionNewWar")
local ACTION_CODE_RUN_SCENE_WAR               = ActionCodeFunctions.getActionCode("ActionRunSceneWar")
local INTERVALS_UNTIL_BOOT                    = {60 * 15, 3600 * 24, 3600 * 24 * 3, 3600 * 24 * 7} -- 15 minutes, 1 day, 3 days, 7 days
local MIN_POINTS, MAX_POINTS, POINTS_PER_STEP = SkillDataAccessors.getBasePointsMinMaxStep()

local function initSelectorWeather(modelWarConfigurator)
    -- TODO: enable the selector.
    modelWarConfigurator:getModelOptionSelectorWithName("Weather"):setButtonsEnabled(false)
        :setOptions({
            {data = 1, text = getLocalizedText(40, "Clear"),},
        })
end

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function generatePlayerColorText(playerIndex)
    if     (playerIndex == 1) then return string.format("1 (%s)", getLocalizedText(34, "Red"))
    elseif (playerIndex == 2) then return string.format("2 (%s)", getLocalizedText(34, "Blue"))
    elseif (playerIndex == 3) then return string.format("3 (%s)", getLocalizedText(34, "Yellow"))
    elseif (playerIndex == 4) then return string.format("4 (%s)", getLocalizedText(34, "Black"))
    else                           error("ModelWarConfigurator-generatePlayerColorText() invalid playerIndex: " .. (playerIndex or ""))
    end
end

local function generateSkillDescription(self)
    local skillConfigurationID = self.m_SkillConfigurationID
    if ((self.m_Mode == "modeContinue") or (self.m_Mode == "modeExit")) then
        return getLocalizedText(14, "Selected")
    elseif (not skillConfigurationID) then
        return getLocalizedText(14, "None")
    else
        local prefix = (skillConfigurationID > 0)                                                         and
            (string.format("%s %d\n", getLocalizedText(14, "CustomConfiguration"), skillConfigurationID)) or
            (SkillDataAccessors.getSkillPresets()[-skillConfigurationID].name .. "\n")

        if (not self.m_ModelSkillConfiguration) then
            return prefix .. getLocalizedText(14, "RetrievingSkillConfiguration")
        else
            return prefix .. SkillDescriptionFunctions.getBriefDescription(self.m_ModelSkillConfiguration)
        end
    end
end

local function generateOverviewText(self)
    return string.format("%s:\n\n%s: %s\n\n%s: %s\n\n%s: %s\n\n%s: %s\n\n%s: %s\n\n%s: %s\n\n%s: %s\n\n%s: %s",
        getLocalizedText(14, "Overview"),
        getLocalizedText(14, "WarFieldName"),       WarFieldManager.getWarFieldName(self.m_WarConfiguration.warFieldFileName),
        getLocalizedText(14, "PlayerIndex"),        generatePlayerColorText(self.m_PlayerIndex),
        getLocalizedText(14, "FogOfWar"),           getLocalizedText(14, (self.m_IsFogOfWarByDefault) and ("Yes") or ("No")),
        getLocalizedText(14, "RankMatch"),          getLocalizedText(14, (self.m_IsRankMatch)         and ("Yes") or ("No")),
        getLocalizedText(14, "MaxDiffScore"),       (self.m_MaxDiffScore) and ("" .. self.m_MaxDiffScore) or getLocalizedText(14, "NoLimit"),
        getLocalizedText(14, "IntervalUntilBoot"),  AuxiliaryFunctions.formatTimeInterval(self.m_IntervalUntilBoot),
        getLocalizedText(14, "MaxBaseSkillPoints"), (self.m_MaxBaseSkillPoints) and ("" .. self.m_MaxBaseSkillPoints) or (getLocalizedText(14, "DisableSkills")),
        getLocalizedText(14, "SkillConfiguration"), generateSkillDescription(self)
    )
end

local function getPlayerIndexForWarConfiguration(warConfiguration)
    local players = warConfiguration.players
    local account = WebSocketManager.getLoggedInAccountAndPassword()
    for playerIndex = 1, WarFieldManager.getPlayersCount(warConfiguration.warFieldFileName) do
        if (players[playerIndex].account == account) then
            return playerIndex
        end
    end

    error("ModelWarConfigurator-getPlayerIndexForWarConfiguration() failed to find the playerIndex.")
end

local function createItemsForStateMain(self)
    local mode = self.m_Mode
    if (mode == "modeCreate") then
        local items = {
            self.m_ItemPlayerIndex,
            self.m_ItemFogOfWar,
            self.m_ItemRankMatch,
            self.m_ItemMaxDiffScore,
            self.m_ItemIntervalUntilBoot,
            self.m_ItemMaxBaseSkillPoints,
        }
        if (self.m_MaxBaseSkillPoints) then
            items[#items + 1] = self.m_ItemSkillConfiguration
        end

        return items

    elseif (mode == "modeJoin") then
        local items = {}
        if (#self.m_ItemsForStatePlayerIndex > 1) then
            items[#items + 1] = self.m_ItemPlayerIndex
        end
        if (self.m_MaxBaseSkillPoints) then
            items[#items + 1] = self.m_ItemSkillConfiguration
        end
        if (#items == 0) then
            items[#items + 1] = self.m_ItemPlaceHolder
        end

        return items

    elseif (mode == "modeContinue") then
        return {self.m_ItemPlaceHolder}

    elseif (model == "modeExit") then
        return {self.m_ItemPlaceHolder}

    else
        error("ModelWarConfigurator-createItemsForStateMain() the mode of the configurator is invalid: " .. (mode or ""))
    end
end

local setStateMain

local function createItemsForStatePlayerIndex(self)
    local warConfiguration = self.m_WarConfiguration
    local players          = warConfiguration.players
    local items            = {}

    for playerIndex = 1, WarFieldManager.getPlayersCount(warConfiguration.warFieldFileName) do
        if ((not players) or (not players[playerIndex])) then
            items[#items + 1] = {
                playerIndex = playerIndex,
                name        = generatePlayerColorText(playerIndex),
                callback    = function()
                    self.m_PlayerIndex = playerIndex

                    setStateMain(self, true)
                end,
            }
        end
    end

    assert(#items > 0)
    return items
end

--------------------------------------------------------------------------------
-- The functions for sending actions.
--------------------------------------------------------------------------------
local function sendActionExitWar(self)
end

local function sendActionGetSkillConfiguration(skillConfigurationID)
    WebSocketManager.sendAction({
        actionCode           = ACTION_CODE_GET_SKILL_CONFIGURATION,
        skillConfigurationID = skillConfigurationID,
    })
end

local function sendActionJoinWar(self)
    WebSocketManager.sendAction({
        actionCode           = ACTION_CODE_JOIN_WAR,
        playerIndex          = self.m_PlayerIndex,
        skillConfigurationID = self.m_SkillConfigurationID,
        warID                = self.m_WarConfiguration.warID,
        warPassword          = "", -- TODO: self.m_WarPassword,
    })
end

local function sendActionNewWar(self)
    WebSocketManager.sendAction({
        actionCode           = ACTION_CODE_NEW_WAR,
        defaultWeatherCode   = 1, --TODO: add an option for the weather.
        intervalUntilBoot    = self.m_IntervalUntilBoot,
        isFogOfWarByDefault  = self.m_IsFogOfWarByDefault,
        isRankMatch          = self.m_IsRankMatch,
        maxBaseSkillPoints   = self.m_MaxBaseSkillPoints,
        maxDiffScore         = self.m_MaxDiffScore,
        playerIndex          = self.m_PlayerIndex,
        skillConfigurationID = self.m_SkillConfigurationID,
        warPassword          = "", -- TODO: self.m_WarPassword,
        warFieldFileName     = self.m_WarConfiguration.warFieldFileName,
    })
end

local function sendActionRunSceneWar(warID)
    WebSocketManager.sendAction({
        actionCode = ACTION_CODE_RUN_SCENE_WAR,
        warID      = warID,
    })
end

--------------------------------------------------------------------------------
-- The state setters.
--------------------------------------------------------------------------------
local function setStateFogOfWar(self)
    self.m_State = "stateFogOfWar"
    self.m_View:setMenuTitleText(getLocalizedText(34, "FogOfWar"))
        :setItems(self.m_ItemsForStateFogOfWar)
end

local function setStateIntervalUntilBoot(self)
    self.m_State = "stateIntervalUntilBoot"
    self.m_View:setMenuTitleText(getLocalizedText(14, "IntervalUntilBoot"))
        :setItems(self.m_ItemsForStateIntervalUntilBoot)
end

setStateMain = function(self, shouldUpdateOverview)
    self.m_State = "stateMain"
    self.m_View:setMenuTitleText(self.m_MenuTitleTextForMode)
        :setItems(createItemsForStateMain(self))

    if (shouldUpdateOverview) then
        self.m_View:setOverviewText(generateOverviewText(self))
    end
end

local function setStateMaxBaseSkillPoints(self)
    self.m_State = "stateMaxBaseSkillPoints"
    self.m_View:setMenuTitleText(getLocalizedText(34, "BaseSkillPointsShort"))
        :setItems(self.m_ItemsForStateMaxBaseSkillPoints)
end

local function setStateMaxDiffScore(self)
    self.m_State = "stateMaxDiffScore"
    self.m_View:setMenuTitleText(getLocalizedText(34, "MaxDiffScore"))
        :setItems(self.m_ItemsForStateMaxDiffScore)
end

local function setStatePlayerIndex(self)
    self.m_State = "statePlayerIndex"
    self.m_View:setMenuTitleText(getLocalizedText(34, "PlayerIndex"))
        :setItems(self.m_ItemsForStatePlayerIndex)
end

local function setStateRankMatch(self)
    self.m_State = "stateRankMatch"
    self.m_View:setMenuTitleText(getLocalizedText(34, "RankMatch"))
        :setItems(self.m_ItemsForStateRankMatch)
end

local function setStateSkillConfiguration(self)
    self.m_State = "stateSkillConfiguration"
    self.m_View:setMenuTitleText(getLocalizedText(34, "SkillConfiguration"))
        :setItems(self.m_ItemsForStateSkillConfiguration)
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initItemFogOfWar(self)
    self.m_ItemFogOfWar = {
        name     = getLocalizedText(34, "FogOfWar"),
        callback = function()
            setStateFogOfWar(self)
        end,
    }
end

local function initItemIntervalUntilBoot(self)
    self.m_ItemIntervalUntilBoot = {
        name     = getLocalizedText(14, "IntervalUntilBoot"),
        callback = function()
            setStateIntervalUntilBoot(self)
        end,
    }
end

local function initItemMaxBaseSkillPoints(self)
    self.m_ItemMaxBaseSkillPoints = {
        name     = getLocalizedText(34, "BaseSkillPoints"),
        callback = function()
            setStateMaxBaseSkillPoints(self)
        end,
    }
end

local function initItemMaxDiffScore(self)
    self.m_ItemMaxDiffScore = {
        name     = getLocalizedText(34, "MaxDiffScore"),
        callback = function()
            setStateMaxDiffScore(self)
        end,
    }
end

local function initItemPlayerIndex(self)
    self.m_ItemPlayerIndex = {
        name     = getLocalizedText(34, "PlayerIndex"),
        callback = function()
            setStatePlayerIndex(self)
        end,
    }
end

local function initItemPlaceHolder(self)
    self.m_ItemPlaceHolder = {
        name     = "(" .. getLocalizedText(14, "NoAvailableOption") .. ")",
        callback = function()
        end,
    }
end

local function initItemRankMatch(self)
    self.m_ItemRankMatch = {
        name     = getLocalizedText(34, "RankMatch"),
        callback = function()
            setStateRankMatch(self)
        end,
    }
end

local function initItemSkillConfiguration(self)
    self.m_ItemSkillConfiguration = {
        name     = getLocalizedText(34, "SkillConfiguration"),
        callback = function()
            setStateSkillConfiguration(self)
        end,
    }
end

local function initItemsForStateFogOfWar(self)
    self.m_ItemsForStateFogOfWar = {
        {
            name     = getLocalizedText(14, "No"),
            callback = function()
                self.m_IsFogOfWarByDefault = false

                setStateMain(self, true)
            end,
        },
        {
            name     = getLocalizedText(14, "Yes"),
            callback = function()
                self.m_IsFogOfWarByDefault = true

                setStateMain(self, true)
            end,
        },
    }
end

local function initItemsForStateIntervalUntilBoot(self)
    local items = {}
    for _, interval in ipairs(INTERVALS_UNTIL_BOOT) do
        items[#items + 1] = {
            name     = AuxiliaryFunctions.formatTimeInterval(interval),
            callback = function()
                self.m_IntervalUntilBoot = interval

                setStateMain(self, true)
            end
        }
    end

    self.m_ItemsForStateIntervalUntilBoot = items
end

local function initItemsForStateMaxBaseSkillPoints(self)
    local items = {{
        name     = getLocalizedText(14, "DisableSkills"),
        callback = function()
            self.m_MaxBaseSkillPoints   = nil
            self.m_SkillConfigurationID = nil

            setStateMain(self, true)
        end,
    }}
    for points = MIN_POINTS, MAX_POINTS, POINTS_PER_STEP do
        items[#items + 1] = {
            name     = (points == 100) and ("100" .. "(" .. getLocalizedText(3, "Default") .. ")") or ("" .. points),
            callback = function()
                self.m_MaxBaseSkillPoints = points

                setStateMain(self, true)
            end,
        }
    end

    self.m_ItemsForStateMaxBaseSkillPoints = items
end

local function initItemsForStateMaxDiffScore(self)
    local items = {}
    for maxDiffScore = 50, 200, 50 do
        items[#items + 1] = {
            name     = "" .. maxDiffScore,
            callback = function()
                self.m_MaxDiffScore = maxDiffScore

                setStateMain(self, true)
            end,
        }
    end
    items[#items + 1] = {
        name     = getLocalizedText(14, "NoLimit"),
        callback = function()
            self.m_MaxDiffScore = nil

            setStateMain(self, true)
        end,
    }

    self.m_ItemsForStateMaxDiffScore = items
end

local function initItemsForStateRankMatch(self)
    self.m_ItemsForStateRankMatch = {
        {
            name     = getLocalizedText(14, "No"),
            callback = function()
                self.m_IsRankMatch = false

                setStateMain(self, true)
            end,
        },
        {
            name     = getLocalizedText(14, "Yes"),
            callback = function()
                self.m_IsRankMatch = true

                setStateMain(self, true)
            end,
        },
    }
end

local function initItemsForStateSkillConfiguration(self)
    local items = {{
        name     = getLocalizedText(14, "None"),
        callback = function()
            self.m_SkillConfigurationID    = nil
            self.m_ModelSkillConfiguration = nil

            setStateMain(self, true)
        end,
    }}

    local prefix = getLocalizedText(3, "Configuration") .. " "
    for i = 1, SkillDataAccessors.getSkillConfigurationsCount() do
        items[#items + 1] = {
            name     = prefix .. i,
            callback = function()
                self.m_SkillConfigurationID    = i
                self.m_ModelSkillConfiguration = nil
                sendActionGetSkillConfiguration(i)

                setStateMain(self, true)
            end,
        }
    end

    for i, presetData in ipairs(SkillDataAccessors.getSkillPresets()) do
        local presetName = presetData.name
        items[#items + 1] = {
            name     = presetName,
            callback = function()
                self.m_SkillConfigurationID    = -i
                self.m_ModelSkillConfiguration = Actor.createModel("common.ModelSkillConfiguration", presetData)

                setStateMain(self, true)
            end,
        }
    end

    self.m_ItemsForStateSkillConfiguration = items
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelWarConfigurator:ctor()
    initItemFogOfWar(          self)
    initItemIntervalUntilBoot( self)
    initItemMaxBaseSkillPoints(self)
    initItemMaxDiffScore(      self)
    initItemPlayerIndex(       self)
    initItemPlaceHolder(       self)
    initItemRankMatch(         self)
    initItemSkillConfiguration(self)

    initItemsForStateFogOfWar(          self)
    initItemsForStateIntervalUntilBoot( self)
    initItemsForStateMaxBaseSkillPoints(self)
    initItemsForStateMaxDiffScore(      self)
    initItemsForStateRankMatch(         self)
    initItemsForStateSkillConfiguration(self)

    return self
end

function ModelWarConfigurator:setCallbackOnButtonBackTouched(callback)
    self.m_OnButtonBackTouched = callback

    return self
end

function ModelWarConfigurator:setModeCreateWar()
    self.m_Mode                           = "modeCreate"
    self.m_MenuTitleTextForMode           = getLocalizedText(14, "CreateWar")
    self.m_CallbackOnButtonConfirmTouched = function()
        local modelConfirmBox = SingletonGetters.getModelConfirmBox(self.m_ModelSceneMain)
        modelConfirmBox:setConfirmText(getLocalizedText(8, "NewWarConfirmation"))
            :setOnConfirmYes(function()
                local password = "" -- TODO: self.m_WarPassword
                if ((#password ~= 0) and (#password ~= 4)) then
                    SingletonGetters.getModelMessageIndicator(self.m_ModelSceneMain):showMessage(getLocalizedText(14, "InvalidWarPassword"))
                else
                    SingletonGetters.getModelMessageIndicator(self.m_ModelSceneMain):showMessage(getLocalizedText(14, "RetrievingCreateWarResult"))
                    sendActionNewWar(self)
                    self.m_View:disableButtonConfirmForSecs(5)
                end
                modelConfirmBox:setEnabled(false)
            end)
            :setEnabled(true)
    end

    return self
end

function ModelWarConfigurator:setModeJoinWar()
    self.m_Mode                           = "modeJoin"
    self.m_MenuTitleTextForMode           = getLocalizedText(14, "JoinWar")
    self.m_CallbackOnButtonConfirmTouched = function()
        local modelConfirmBox = SingletonGetters.getModelConfirmBox(self.m_ModelSceneMain)
        modelConfirmBox:setConfirmText(getLocalizedText(8, "JoinWarConfirmation"))
            :setOnConfirmYes(function()
                local password = "" -- TODO: self.m_WarPassword
                if ((#password ~= 0) and (#password ~= 4)) then
                    SingletonGetters.getModelMessageIndicator(self.m_ModelSceneMain):showMessage(getLocalizedText(14, "InvalidWarPassword"))
                else
                    SingletonGetters.getModelMessageIndicator(self.m_ModelSceneMain):showMessage(getLocalizedText(14, "RetrievingJoinWarResult"))
                    sendActionJoinWar(self)
                    self.m_View:disableButtonConfirmForSecs(5)
                end
                modelConfirmBox:setEnabled(false)
            end)
            :setEnabled(true)
    end

    return self
end

function ModelWarConfigurator:setModeContinueWar()
    self.m_Mode                           = "modeContinue"
    self.m_MenuTitleTextForMode           = getLocalizedText(14, "ContinueWar")
    self.m_CallbackOnButtonConfirmTouched = function()
        SingletonGetters.getModelMessageIndicator(self.m_ModelSceneMain):showMessage(getLocalizedText(14, "RetrievingWarData"))
        sendActionRunSceneWar(self.m_WarConfiguration.warID)
        self.m_View:disableButtonConfirmForSecs(5)
    end

    return self
end

function ModelWarConfigurator:setModeExitWar()
    self.m_Mode                           = "modeExit"
    self.m_MenuTitleTextForMode           = getLocalizedText(14, "ExitWar")
    self.m_CallbackOnButtonConfirmTouched = function()
        SingletonGetters.getModelMessageIndicator(self.m_ModelSceneMain):showMessage(getLocalizedText(14, "RetrievingExitWarResult"))
        sendActionExitWar(self)
        self.m_View:disableButtonConfirmForSecs(5)
    end

    return self
end

function ModelWarConfigurator:onStartRunning(modelSceneMain)
    self.m_ModelSceneMain = modelSceneMain

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelWarConfigurator:resetWithWarConfiguration(warConfiguration)
    self.m_WarConfiguration = warConfiguration
    local mode = self.m_Mode
    if (mode == "modeCreate") then
        self.m_IntervalUntilBoot        = 3600 * 24 * 3
        self.m_IsFogOfWarByDefault      = false
        self.m_IsRankMatch              = false
        self.m_ItemsForStatePlayerIndex = createItemsForStatePlayerIndex(self)
        self.m_MaxBaseSkillPoints       = 100
        self.m_MaxDiffScore             = 100
        self.m_ModelSkillConfiguration  = nil
        self.m_PlayerIndex              = 1
        self.m_SkillConfigurationID     = 1

        sendActionGetSkillConfiguration(1)
        self.m_View:setButtonConfirmText(getLocalizedText(14, "ConfirmCreateWar"))

    elseif (mode == "modeJoin") then
        self.m_IntervalUntilBoot        = warConfiguration.intervalUntilBoot
        self.m_IsFogOfWarByDefault      = warConfiguration.isFogOfWarByDefault
        self.m_IsRankMatch              = warConfiguration.isRankMatch
        self.m_ItemsForStatePlayerIndex = createItemsForStatePlayerIndex(self)
        self.m_MaxBaseSkillPoints       = warConfiguration.maxBaseSkillPoints
        self.m_MaxDiffScore             = warConfiguration.maxDiffScore
        self.m_ModelSkillConfiguration  = nil
        self.m_PlayerIndex              = self.m_ItemsForStatePlayerIndex[1].playerIndex
        self.m_SkillConfigurationID     = (warConfiguration.maxBaseSkillPoints) and (1) or (nil)

        if (self.m_SkillConfigurationID) then
            sendActionGetSkillConfiguration(1)
        end
        self.m_View:setButtonConfirmText(getLocalizedText(14, "ConfirmJoinWar"))

    elseif (mode == "modeContinue") then
        self.m_IntervalUntilBoot        = warConfiguration.intervalUntilBoot
        self.m_IsFogOfWarByDefault      = warConfiguration.isFogOfWarByDefault
        self.m_IsRankMatch              = warConfiguration.isRankMatch
        self.m_ItemsForStatePlayerIndex = nil
        self.m_MaxBaseSkillPoints       = warConfiguration.maxBaseSkillPoints
        self.m_MaxDiffScore             = warConfiguration.maxDiffScore
        self.m_ModelSkillConfiguration  = nil
        self.m_PlayerIndex              = getPlayerIndexForWarConfiguration(warConfiguration)
        self.m_SkillConfigurationID     = nil

        self.m_View:setButtonConfirmText(getLocalizedText(14, "ConfirmContinueWar"))

    elseif (mode == "modeExit") then
        self.m_IntervalUntilBoot        = warConfiguration.intervalUntilBoot
        self.m_IsFogOfWarByDefault      = warConfiguration.isFogOfWarByDefault
        self.m_IsRankMatch              = warConfiguration.isRankMatch
        self.m_ItemsForStatePlayerIndex = nil
        self.m_MaxBaseSkillPoints       = warConfiguration.maxBaseSkillPoints
        self.m_MaxDiffScore             = warConfiguration.maxDiffScore
        self.m_ModelSkillConfiguration  = nil
        self.m_PlayerIndex              = getPlayerIndexForWarConfiguration(warConfiguration)
        self.m_SkillConfigurationID     = nil

        self.m_View:setButtonConfirmText(getLocalizedText(14, "ConfirmExitWar"))

    else
        error("ModelWarConfigurator:resetWithWarConfiguration() the mode of the configurator is invalid: " .. (mode or ""))
    end

    setStateMain(self, true)

    return self
end

function ModelWarConfigurator:isEnabled()
    return self.m_IsEnabled
end

function ModelWarConfigurator:setEnabled(enabled)
    self.m_IsEnabled = enabled

    if (self.m_View) then
        self.m_View:setVisible(enabled)
    end

    return self
end

function ModelWarConfigurator:isRetrievingSkillConfiguration(skillConfigurationID)
    return (self.m_SkillConfigurationID == skillConfigurationID) and (not self.m_ModelSkillConfiguration)
end

function ModelWarConfigurator:updateWithSkillConfiguration(skillConfiguration, skillConfigurationID)
    if (self:isRetrievingSkillConfiguration(skillConfigurationID)) then
        self.m_ModelSkillConfiguration = Actor.createModel("common.ModelSkillConfiguration", skillConfiguration)
        self.m_View:setOverviewText(generateOverviewText(self))
    end

    return self
end

function ModelWarConfigurator:getPassword()
    --return self.m_View:getEditBoxPassword():getText()
end

function ModelWarConfigurator:setPassword(password)
    if (self.m_View) then
        self.m_View:getEditBoxPassword():setText(password)
    end

    return self
end

function ModelWarConfigurator:setPasswordEnabled(enabled)
    if (self.m_View) then
        self.m_View:getEditBoxPassword():setVisible(enabled)
    end

    return self
end

function ModelWarConfigurator:getWarId()
    return self.m_WarConfiguration.warID
end

function ModelWarConfigurator:onButtonBackTouched()
    if (self.m_State ~= "stateMain") then
        setStateMain(self)
    elseif (self.m_OnButtonBackTouched) then
        self.m_OnButtonBackTouched()
    end

    return self
end

function ModelWarConfigurator:onButtonConfirmTouched()
    if (self.m_CallbackOnButtonConfirmTouched) then
        self.m_CallbackOnButtonConfirmTouched()
    end

    return self
end

return ModelWarConfigurator
