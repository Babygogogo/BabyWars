
local ModelWarConfigurator = class("ModelWarConfigurator")

local Actor                     = requireBW("src.global.actors.Actor")
local ActionCodeFunctions       = requireBW("src.app.utilities.ActionCodeFunctions")
local AuxiliaryFunctions        = requireBW("src.app.utilities.AuxiliaryFunctions")
local LocalizationFunctions     = requireBW("src.app.utilities.LocalizationFunctions")
local SingletonGetters          = requireBW("src.app.utilities.SingletonGetters")
local SkillDataAccessors        = requireBW("src.app.utilities.SkillDataAccessors")
local SkillDescriptionFunctions = requireBW("src.app.utilities.SkillDescriptionFunctions")
local WarFieldManager           = requireBW("src.app.utilities.WarFieldManager")
local WebSocketManager          = requireBW("src.app.utilities.WebSocketManager")

local string           = string
local getLocalizedText = LocalizationFunctions.getLocalizedText

local ACTION_CODE_EXIT_WAR                    = ActionCodeFunctions.getActionCode("ActionExitWar")
local ACTION_CODE_GET_SKILL_CONFIGURATION     = ActionCodeFunctions.getActionCode("ActionGetSkillConfiguration")
local ACTION_CODE_JOIN_WAR                    = ActionCodeFunctions.getActionCode("ActionJoinWar")
local ACTION_CODE_NEW_WAR                     = ActionCodeFunctions.getActionCode("ActionNewWar")
local ACTION_CODE_RUN_SCENE_WAR               = ActionCodeFunctions.getActionCode("ActionRunSceneWar")
local ENERGY_GAIN_MODIFIERS                   = {0, 50, 100, 150, 200, 300, 500}
local INTERVALS_UNTIL_BOOT                    = {60 * 15, 3600 * 24, 3600 * 24 * 3, 3600 * 24 * 7} -- 15 minutes, 1 day, 3 days, 7 days
local INCOME_MODIFIERS                        = {0, 50, 100, 150, 200, 300, 500}
local MIN_POINTS, MAX_POINTS, POINTS_PER_STEP = SkillDataAccessors.getBasePointsMinMaxStep()
local STARTING_FUNDS                          = {0, 5000, 10000, 20000, 30000, 40000, 50000, 100000, 150000, 200000, 300000, 400000, 500000}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getPlayerIndexForWarConfiguration(warConfiguration)
    local account = WebSocketManager.getLoggedInAccountAndPassword()
    for playerIndex, player in pairs(warConfiguration.players) do
        if (player.account == account) then
            return playerIndex
        end
    end

    error("ModelWarConfigurator-getPlayerIndexForWarConfiguration() failed to find the playerIndex.")
end

--------------------------------------------------------------------------------
-- The overview text generators.
--------------------------------------------------------------------------------
local function generateTextForStartingFund(startingFund)
    if (startingFund == 0) then
        return nil
    else
        return string.format("%s:         %d", getLocalizedText(14, "StartingFund"), startingFund)
    end
end

local function generateTextForIncomeModifier(incomeModifier)
    if (incomeModifier == 100) then
        return nil
    else
        return string.format("%s:         %d%%", getLocalizedText(14, "IncomeModifier"), incomeModifier)
    end
end

local function generateTextForEnergyGainModifier(energyGainModifier)
    if (energyGainModifier == 100) then
        return nil
    else
        return string.format("%s:         %d%%", getLocalizedText(14, "EnergyGainModifier"), energyGainModifier)
    end
end

local function generateTextForAdvancedSettings(self)
    local textList = {getLocalizedText(14, "Advanced Settings") .. ":"}
    textList[#textList + 1] = generateTextForStartingFund(      self.m_StartingFund)
    textList[#textList + 1] = generateTextForIncomeModifier(    self.m_IncomeModifier)
    textList[#textList + 1] = generateTextForEnergyGainModifier(self.m_EnergyGainModifier)

    if (#textList == 1) then
        textList[#textList + 1] = getLocalizedText(14, "None")
    end
    return table.concat(textList, "\n")
end

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
    return string.format("%s:\n\n%s:%s%s\n%s:%s%s\n%s:%s%s\n\n%s:%s%s\n%s:%s%s\n\n%s:%s%s\n----------\n%s:%s%s\n%s:%s%s\n----------\n%s",
        getLocalizedText(14, "Overview"),
        getLocalizedText(14, "WarFieldName"),       "         ",      WarFieldManager.getWarFieldName(self.m_WarConfiguration.warFieldFileName),
        getLocalizedText(14, "PlayerIndex"),        "         ",      generatePlayerColorText(self.m_PlayerIndex),
        getLocalizedText(14, "FogOfWar"),           "         ",      getLocalizedText(14, (self.m_IsFogOfWarByDefault) and ("Yes") or ("No")),
        getLocalizedText(14, "RankMatch"),          "             ",  getLocalizedText(14, (self.m_IsRankMatch)         and ("Yes") or ("No")),
        getLocalizedText(14, "MaxDiffScore"),       "         ",      (self.m_MaxDiffScore) and ("" .. self.m_MaxDiffScore) or getLocalizedText(14, "NoLimit"),
        getLocalizedText(14, "IntervalUntilBoot"),  "         ",      AuxiliaryFunctions.formatTimeInterval(self.m_IntervalUntilBoot),
        getLocalizedText(14, "MaxBaseSkillPoints"), "   ",            (self.m_MaxBaseSkillPoints) and ("" .. self.m_MaxBaseSkillPoints) or (getLocalizedText(14, "DisableSkills")),
        getLocalizedText(14, "SkillConfiguration"), "              ", generateSkillDescription(self),
        generateTextForAdvancedSettings(self)
    )
end

--------------------------------------------------------------------------------
-- The dynamic item generators.
--------------------------------------------------------------------------------
local function createItemsForStateMain(self)
    local mode = self.m_Mode
    if (mode == "modeCreate") then
        local items = {
            self.m_ItemPlayerIndex,
            self.m_ItemFogOfWar,
            self.m_ItemIntervalUntilBoot,
        }
        if (self.m_MaxBaseSkillPoints) then
            items[#items + 1] = self.m_ItemSkillConfiguration
        end
        items[#items + 1] = self.m_ItemAdvancedSettings

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

    elseif (mode == "modeExit") then
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

                    setStateMain(self)
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
local function sendActionExitWar(warID)
    WebSocketManager.sendAction({
        actionCode = ACTION_CODE_EXIT_WAR,
        warID      = warID,
    })
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
        energyGainModifier   = self.m_EnergyGainModifier,
        incomeModifier       = self.m_IncomeModifier,
        intervalUntilBoot    = self.m_IntervalUntilBoot,
        isFogOfWarByDefault  = self.m_IsFogOfWarByDefault,
        isRankMatch          = self.m_IsRankMatch,
        maxBaseSkillPoints   = self.m_MaxBaseSkillPoints,
        maxDiffScore         = self.m_MaxDiffScore,
        playerIndex          = self.m_PlayerIndex,
        skillConfigurationID = self.m_SkillConfigurationID,
        startingFund         = self.m_StartingFund,
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
local function setStateAdvancedSettings(self)
    self.m_State = "stateAdvancedSettings"
    self.m_View:setMenuTitleText(getLocalizedText(14, "Advanced Settings"))
        :setItems(self.m_ItemsForStateAdvancedSettings)
        :setOverviewText(generateOverviewText(self))
end

local function setStateEnergyGainModifier(self)
    self.m_State = "stateEnergyGainModifier"
    self.m_View:setMenuTitleText(getLocalizedText(14, "Energy Gain Modifier"))
        :setItems(self.m_ItemsForStateEnergyGainModifier)
        :setOverviewText(getLocalizedText(35, "HelpForEnergyGainModifier"))
end

local function setStateFogOfWar(self)
    self.m_State = "stateFogOfWar"
    self.m_View:setMenuTitleText(getLocalizedText(34, "FogOfWar"))
        :setItems(self.m_ItemsForStateFogOfWar)
        :setOverviewText(getLocalizedText(35, "HelpForFogOfWar"))
end

local function setStateIncomeModifier(self)
    self.m_State = "stateIncomeModifier"
    self.m_View:setMenuTitleText(getLocalizedText(14, "Income Modifier"))
        :setItems(self.m_ItemsForStateIncomeModifier)
        :setOverviewText(getLocalizedText(35, "HelpForIncomeModifier"))
end

local function setStateIntervalUntilBoot(self)
    self.m_State = "stateIntervalUntilBoot"
    self.m_View:setMenuTitleText(getLocalizedText(14, "IntervalUntilBoot"))
        :setItems(self.m_ItemsForStateIntervalUntilBoot)
        :setOverviewText(getLocalizedText(35, "HelpForIntervalUntilBoot"))
end

setStateMain = function(self)
    self.m_State = "stateMain"
    self.m_View:setMenuTitleText(self.m_MenuTitleTextForMode)
        :setItems(createItemsForStateMain(self))
        :setOverviewText(generateOverviewText(self))
end

local function setStateMaxBaseSkillPoints(self)
    self.m_State = "stateMaxBaseSkillPoints"
    self.m_View:setMenuTitleText(getLocalizedText(34, "BaseSkillPointsShort"))
        :setItems(self.m_ItemsForStateMaxBaseSkillPoints)
        :setOverviewText(getLocalizedText(35, "HelpForMaxBaseSkillPoints"))
end

local function setStateMaxDiffScore(self)
    self.m_State = "stateMaxDiffScore"
    self.m_View:setMenuTitleText(getLocalizedText(34, "MaxDiffScore"))
        :setItems(self.m_ItemsForStateMaxDiffScore)
        :setOverviewText(getLocalizedText(35, "HelpForMaxDiffScore"))
end

local function setStatePlayerIndex(self)
    self.m_State = "statePlayerIndex"
    self.m_View:setMenuTitleText(getLocalizedText(34, "PlayerIndex"))
        :setItems(self.m_ItemsForStatePlayerIndex)
        :setOverviewText(getLocalizedText(35, "HelpForPlayerIndex"))
end

local function setStateRankMatch(self)
    self.m_State = "stateRankMatch"
    self.m_View:setMenuTitleText(getLocalizedText(34, "RankMatch"))
        :setItems(self.m_ItemsForStateRankMatch)
        :setOverviewText(getLocalizedText(35, "HelpForRankMatch"))
end

local function setStateSkillConfiguration(self)
    self.m_State = "stateSkillConfiguration"
    self.m_View:setMenuTitleText(getLocalizedText(34, "SkillConfiguration"))
        :setItems(self.m_ItemsForStateSkillConfiguration)
        :setOverviewText(getLocalizedText(35, "HelpForSkillConfiguration"))
end

local function setStateStartingFund(self)
    self.m_State = "stateStartingFund"
    self.m_View:setMenuTitleText(getLocalizedText(14, "Starting Fund"))
        :setItems(self.m_ItemsForStateStartingFund)
        :setOverviewText(getLocalizedText(35, "HelpForStartingFund"))
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initItemAdvancedSettings(self)
    self.m_ItemAdvancedSettings = {
        name     = getLocalizedText(14, "Advanced Settings"),
        callback = function()
            setStateAdvancedSettings(self)
        end,
    }
end

local function initItemEnergyGainModifier(self)
    self.m_ItemEnergyGainModifier = {
        name     = getLocalizedText(14, "Energy Gain Modifier"),
        callback = function()
            setStateEnergyGainModifier(self)
        end,
    }
end

local function initItemFogOfWar(self)
    self.m_ItemFogOfWar = {
        name     = getLocalizedText(34, "FogOfWar"),
        callback = function()
            setStateFogOfWar(self)
        end,
    }
end

local function initItemIncomeModifier(self)
    self.m_ItemIncomeModifier = {
        name     = getLocalizedText(14, "Income Modifier"),
        callback = function()
            setStateIncomeModifier(self)
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

local function initItemStartingFund(self)
    self.m_ItemStartingFund = {
        name     = getLocalizedText(14, "Starting Fund"),
        callback = function()
            setStateStartingFund(self)
        end,
    }
end

local function initItemsForStateAdvancedSettings(self)
    self.m_ItemsForStateAdvancedSettings = {
        self.m_ItemMaxBaseSkillPoints,
        self.m_ItemRankMatch,
        self.m_ItemMaxDiffScore,
        self.m_ItemStartingFund,
        self.m_ItemIncomeModifier,
        self.m_ItemEnergyGainModifier,
    }
end

local function initItemsForStateEnergyGainModifier(self)
    local items = {}
    for _, modifier in ipairs(ENERGY_GAIN_MODIFIERS) do
        items[#items + 1] = {
            name     = (modifier ~= 100) and (string.format("%d%%", modifier)) or (string.format("%d%%(%s)", modifier, getLocalizedText(14, "Default"))),
            callback = function()
                self.m_EnergyGainModifier = modifier
                setStateMain(self)
            end,
        }
    end

    self.m_ItemsForStateEnergyGainModifier = items
end

local function initItemsForStateFogOfWar(self)
    self.m_ItemsForStateFogOfWar = {
        {
            name     = getLocalizedText(14, "No"),
            callback = function()
                self.m_IsFogOfWarByDefault = false

                setStateMain(self)
            end,
        },
        {
            name     = getLocalizedText(14, "Yes"),
            callback = function()
                self.m_IsFogOfWarByDefault = true

                setStateMain(self)
            end,
        },
    }
end

local function initItemsForStateIncomeModifier(self)
    local items = {}
    for _, modifier in ipairs(INCOME_MODIFIERS) do
        items[#items + 1] = {
            name     = (modifier == 100) and (string.format("%d%%(%s)", modifier, getLocalizedText(14, "Default"))) or ("" .. modifier .. "%"),
            callback = function()
                self.m_IncomeModifier = modifier
                setStateMain(self)
            end,
        }
    end

    self.m_ItemsForStateIncomeModifier = items
end

local function initItemsForStateIntervalUntilBoot(self)
    local items = {}
    for _, interval in ipairs(INTERVALS_UNTIL_BOOT) do
        items[#items + 1] = {
            name     = AuxiliaryFunctions.formatTimeInterval(interval),
            callback = function()
                self.m_IntervalUntilBoot = interval

                setStateMain(self)
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

            setStateMain(self)
        end,
    }}
    for points = MIN_POINTS, MAX_POINTS, POINTS_PER_STEP do
        items[#items + 1] = {
            name     = (points == 100) and ("100" .. "(" .. getLocalizedText(3, "Default") .. ")") or ("" .. points),
            callback = function()
                self.m_MaxBaseSkillPoints = points

                setStateMain(self)
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

                setStateMain(self)
            end,
        }
    end
    items[#items + 1] = {
        name     = getLocalizedText(14, "NoLimit"),
        callback = function()
            self.m_MaxDiffScore = nil

            setStateMain(self)
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

                setStateMain(self)
            end,
        },
        {
            name     = getLocalizedText(14, "Yes"),
            callback = function()
                self.m_IsRankMatch = true

                setStateMain(self)
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

            setStateMain(self)
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

                setStateMain(self)
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

                setStateMain(self)
            end,
        }
    end

    self.m_ItemsForStateSkillConfiguration = items
end

local function initItemsForStateStartingFund(self)
    local items = {}
    for _, fund in ipairs(STARTING_FUNDS) do
        items[#items + 1] = {
            name     = (fund ~= 0) and ("" .. fund) or (string.format("%d(%s)", fund, getLocalizedText(14, "Default"))),
            callback = function()
                self.m_StartingFund = fund
                setStateMain(self)
            end
        }
    end

    self.m_ItemsForStateStartingFund = items
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelWarConfigurator:ctor()
    initItemAdvancedSettings(  self)
    initItemEnergyGainModifier(self)
    initItemFogOfWar(          self)
    initItemIncomeModifier(    self)
    initItemIntervalUntilBoot( self)
    initItemMaxBaseSkillPoints(self)
    initItemMaxDiffScore(      self)
    initItemPlayerIndex(       self)
    initItemPlaceHolder(       self)
    initItemRankMatch(         self)
    initItemSkillConfiguration(self)
    initItemStartingFund(      self)

    initItemsForStateAdvancedSettings(  self)
    initItemsForStateEnergyGainModifier(self)
    initItemsForStateFogOfWar(          self)
    initItemsForStateIncomeModifier(    self)
    initItemsForStateIntervalUntilBoot( self)
    initItemsForStateMaxBaseSkillPoints(self)
    initItemsForStateMaxDiffScore(      self)
    initItemsForStateRankMatch(         self)
    initItemsForStateSkillConfiguration(self)
    initItemsForStateStartingFund(      self)

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
        local modelConfirmBox = SingletonGetters.getModelConfirmBox(self.m_ModelSceneMain)
        modelConfirmBox:setConfirmText(getLocalizedText(8, "ExitWarConfirmation"))
            :setOnConfirmYes(function()
                SingletonGetters.getModelMessageIndicator(self.m_ModelSceneMain):showMessage(getLocalizedText(14, "RetrievingExitWarResult"))
                sendActionExitWar(self.m_WarConfiguration.warID)
                self.m_View:disableButtonConfirmForSecs(5)
                modelConfirmBox:setEnabled(false)
            end)
            :setEnabled(true)
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
        self.m_EnergyGainModifier       = 100
        self.m_IncomeModifier           = 100
        self.m_IntervalUntilBoot        = 3600 * 24 * 3
        self.m_IsFogOfWarByDefault      = false
        self.m_IsRankMatch              = false
        self.m_ItemsForStatePlayerIndex = createItemsForStatePlayerIndex(self)
        self.m_MaxBaseSkillPoints       = 100
        self.m_MaxDiffScore             = 100
        self.m_ModelSkillConfiguration  = nil
        self.m_PlayerIndex              = 1
        self.m_SkillConfigurationID     = 1
        self.m_StartingFund             = 0

        sendActionGetSkillConfiguration(1)
        self.m_View:setButtonConfirmText(getLocalizedText(14, "ConfirmCreateWar"))

    elseif (mode == "modeJoin") then
        self.m_EnergyGainModifier       = warConfiguration.energyGainModifier
        self.m_IncomeModifier           = warConfiguration.incomeModifier
        self.m_IntervalUntilBoot        = warConfiguration.intervalUntilBoot
        self.m_IsFogOfWarByDefault      = warConfiguration.isFogOfWarByDefault
        self.m_IsRankMatch              = warConfiguration.isRankMatch
        self.m_ItemsForStatePlayerIndex = createItemsForStatePlayerIndex(self)
        self.m_MaxBaseSkillPoints       = warConfiguration.maxBaseSkillPoints
        self.m_MaxDiffScore             = warConfiguration.maxDiffScore
        self.m_ModelSkillConfiguration  = nil
        self.m_PlayerIndex              = self.m_ItemsForStatePlayerIndex[1].playerIndex
        self.m_SkillConfigurationID     = (warConfiguration.maxBaseSkillPoints) and (1) or (nil)
        self.m_StartingFund             = warConfiguration.startingFund

        if (self.m_SkillConfigurationID) then
            sendActionGetSkillConfiguration(1)
        end
        self.m_View:setButtonConfirmText(getLocalizedText(14, "ConfirmJoinWar"))

    elseif (mode == "modeContinue") then
        self.m_EnergyGainModifier       = warConfiguration.energyGainModifier
        self.m_IncomeModifier           = warConfiguration.incomeModifier
        self.m_IntervalUntilBoot        = warConfiguration.intervalUntilBoot
        self.m_IsFogOfWarByDefault      = warConfiguration.isFogOfWarByDefault
        self.m_IsRankMatch              = warConfiguration.isRankMatch
        self.m_ItemsForStatePlayerIndex = nil
        self.m_MaxBaseSkillPoints       = warConfiguration.maxBaseSkillPoints
        self.m_MaxDiffScore             = warConfiguration.maxDiffScore
        self.m_ModelSkillConfiguration  = nil
        self.m_PlayerIndex              = getPlayerIndexForWarConfiguration(warConfiguration)
        self.m_SkillConfigurationID     = nil
        self.m_StartingFund             = warConfiguration.startingFund

        self.m_View:setButtonConfirmText(getLocalizedText(14, "ConfirmContinueWar"))

    elseif (mode == "modeExit") then
        self.m_EnergyGainModifier       = warConfiguration.energyGainModifier
        self.m_IncomeModifier           = warConfiguration.incomeModifier
        self.m_IntervalUntilBoot        = warConfiguration.intervalUntilBoot
        self.m_IsFogOfWarByDefault      = warConfiguration.isFogOfWarByDefault
        self.m_IsRankMatch              = warConfiguration.isRankMatch
        self.m_ItemsForStatePlayerIndex = nil
        self.m_MaxBaseSkillPoints       = warConfiguration.maxBaseSkillPoints
        self.m_MaxDiffScore             = warConfiguration.maxDiffScore
        self.m_ModelSkillConfiguration  = nil
        self.m_PlayerIndex              = getPlayerIndexForWarConfiguration(warConfiguration)
        self.m_SkillConfigurationID     = nil
        self.m_StartingFund             = warConfiguration.startingFund

        self.m_View:setButtonConfirmText(getLocalizedText(14, "ConfirmExitWar"))

    else
        error("ModelWarConfigurator:resetWithWarConfiguration() the mode of the configurator is invalid: " .. (mode or ""))
    end

    setStateMain(self)

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
    local state = self.m_State
    if     (state == "stateAdvancedSettings")   then setStateMain(            self)
    elseif (state == "stateEnergyGainModifier") then setStateAdvancedSettings(self)
    elseif (state == "stateFogOfWar")           then setStateMain(            self)
    elseif (state == "stateIncomeModifier")     then setStateAdvancedSettings(self)
    elseif (state == "stateIntervalUntilBoot")  then setStateMain(            self)
    elseif (state == "stateMaxBaseSkillPoints") then setStateAdvancedSettings(self)
    elseif (state == "stateMaxDiffScore")       then setStateAdvancedSettings(self)
    elseif (state == "statePlayerIndex")        then setStateMain(            self)
    elseif (state == "stateRankMatch")          then setStateAdvancedSettings(self)
    elseif (state == "stateSkillConfiguration") then setStateMain(            self)
    elseif (state == "stateStartingFund")       then setStateAdvancedSettings(self)
    elseif (self.m_OnButtonBackTouched)         then self.m_OnButtonBackTouched()
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
