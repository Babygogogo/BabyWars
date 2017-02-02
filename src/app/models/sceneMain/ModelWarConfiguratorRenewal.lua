
local ModelWarConfiguratorRenewal = class("ModelWarConfiguratorRenewal")

local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")
local SkillDataAccessors    = require("src.app.utilities.SkillDataAccessors")
local TableFunctions        = require("src.app.utilities.TableFunctions")
local WarFieldManager       = require("src.app.utilities.WarFieldManager")

local getLocalizedText = LocalizationFunctions.getLocalizedText

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
local function createItemsForStateMain(self)
    return {
        self.m_ItemPlayerIndex,
        self.m_ItemFogOfWar,
        self.m_ItemMaxBaseSkillPoints,
        self.m_ItemSkillConfiguration,
        self.m_ItemRankMatch,
        self.m_ItemMaxDiffScore,
    }
end

local function createItemsForStatePlayerIndex(self)
    local warConfiguration = self.m_WarConfigurationOrigin
    local players          = warConfiguration.players
    local items            = {}

    for playerIndex = 1, WarFieldManager.getPlayersCount(warConfiguration.warFieldFileName) do
        if ((not players) or (not players[playerIndex])) then
            local colorText
            if     (playerIndex == 1) then colorText = "Red"
            elseif (playerIndex == 2) then colorText = "Blue"
            elseif (playerIndex == 3) then colorText = "Yellow"
            else                           colorText = "Black"
            end

            items[#items + 1] = {
                name     = string.format("%d (%s)", playerIndex, getLocalizedText(34, colorText)),
                data     = playerIndex,
                callback = function()
                end,
            }
        end
    end

    assert(#items > 1)
    return items
end

--------------------------------------------------------------------------------
-- The state setters.
--------------------------------------------------------------------------------
local function setStateFogOfWar(self)
    self.m_State = "stateFogOfWar"
    self.m_View:setItems(self.m_ItemsForStateFogOfWar)
end

local function setStateMain(self)
    self.m_State = "stateMain"
    self.m_View:setItems(createItemsForStateMain(self))
end

local function setStateMaxBaseSkillPoints(self)
    self.m_State = "stateMaxBaseSkillPoints"
    self.m_View:setItems(self.m_ItemsForStateMaxBaseSkillPoints)
end

local function setStateMaxDiffScore(self)
    self.m_State = "stateMaxDiffScore"
    self.m_View:setItems(self.m_ItemsForStateMaxDiffScore)
end

local function setStatePlayerIndex(self)
    self.m_State = "statePlayerIndex"
    self.m_View:setItems(createItemsForStatePlayerIndex(self))
end

local function setStateRankMatch(self)
    self.m_State = "stateRankMatch"
    self.m_View:setItems(self.m_ItemsForStateRankMatch)
end

local function setStateSkillConfiguration(self)
    self.m_State = "stateSkillConfiguration"
    self.m_View:setItems(self.m_ItemsForStateSkillConfiguration)
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
            name     = getLocalizedText(9, false),
            callback = function()
            end,
        },
        {
            name     = getLocalizedText(9, true),
            callback = function()
            end,
        },
    }
end

local function initItemsForStateMaxBaseSkillPoints(self)
    local items = {{
        name     = getLocalizedText(3, "Disable"),
        data     = nil,
        callback = function()
            --[[
            self:getModelOptionSelectorWithName("Skill"):setCurrentOptionIndex(1)
                :setButtonsEnabled(false)
                :setOptionIndicatorTouchEnabled(false)
            ]]
        end,
    }}
    for points = MIN_POINTS, MAX_POINTS, POINTS_PER_STEP do
        items[#items + 1] = {
            name     = "" .. points,
            data     = points,
            callback = function()
                --[[
                self:getModelOptionSelectorWithName("Skill"):setButtonsEnabled(true)
                    :setOptionIndicatorTouchEnabled(true)
                ]]
            end,
        }
    end

    self.m_ItemsForStateMaxBaseSkillPoints = items
end

local function initItemsForStateMaxDiffScore(self)
    local items = {}
    for i = 50, 200, 50 do
        items[#items + 1] = {
            name     = "" .. i,
            callback = function()
            end,
        }
    end
    items[#items + 1] = {
        name     = getLocalizedText(13, "NoLimit"),
        callback = function()
        end,
    }

    self.m_ItemsForStateMaxDiffScore = items
end

local function initItemsForStateRankMatch(self)
    self.m_ItemsForStateRankMatch = {
        {
            name     = getLocalizedText(34, "No"),
            callback = function()
            end,
        },
        {
            name     = getLocalizedText(34, "Yes"),
            callback = function()
            end,
        },
    }
end

local function initItemsForStateSkillConfiguration(self)
    local items = {{
        name     = getLocalizedText(3, "None"),
        data     = nil,
        callback = function()
        end,
    }}

    local prefix = getLocalizedText(3, "Configuration") .. " "
    for i = 1, SkillDataAccessors.getSkillConfigurationsCount() do
        items[#items + 1] = {
            name     = prefix .. i,
            data     = i,
            callback = function()
                --[[
                WebSocketManager.sendAction({
                    actionCode           = ACTION_CODE_GET_SKILL_CONFIGURATION,
                    skillConfigurationID = i
                })
                ]]
            end,
        }
    end

    for i, presetData in ipairs(SkillDataAccessors.getSkillPresets()) do
        local presetName = presetData.name
        items[#items + 1] = {
            name     = presetName,
            data     = -i,
            callback = function()
                --[[
                local modelSkillConfiguration = Actor.createModel("common.ModelSkillConfiguration", presetData)
                self:setPopUpPanelEnabled(true)
                    :setPopUpPanelText(string.format("%s %s:\n%s",
                        getLocalizedText(3, "Configuration"), presetName,
                        SkillDescriptionFunctions.getBriefDescription(modelSkillConfiguration)
                    ))
                ]]
            end,
        }
    end

    self.m_ItemsForStateSkillConfiguration = items
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelWarConfiguratorRenewal:ctor()
    initItemFogOfWar(          self)
    initItemMaxBaseSkillPoints(self)
    initItemMaxDiffScore(      self)
    initItemPlayerIndex(       self)
    initItemRankMatch(         self)
    initItemSkillConfiguration(self)

    initItemsForStateFogOfWar(          self)
    initItemsForStateMaxBaseSkillPoints(self)
    initItemsForStateMaxDiffScore(      self)
    initItemsForStateRankMatch(         self)
    initItemsForStateSkillConfiguration(self)

    return self
end

function ModelWarConfiguratorRenewal:setCallbackOnButtonBackTouched(callback)
    self.m_OnButtonBackTouched = callback

    return self
end

function ModelWarConfiguratorRenewal:setCallbackOnButtonConfirmTouched(callback)
    self.m_OnButtonConfirmTouched = callback

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelWarConfiguratorRenewal:resetWithWarConfiguration(warConfiguration)
    self.m_WarConfigurationOrigin   = warConfiguration
    self.m_WarConfigurationModified = TableFunctions.deepClone(warConfiguration)
    setStateMain(self)

    return self
end

function ModelWarConfiguratorRenewal:isEnabled()
    return self.m_IsEnabled
end

function ModelWarConfiguratorRenewal:setEnabled(enabled)
    self.m_IsEnabled = enabled

    if (self.m_View) then
        self.m_View:setVisible(enabled)
            :setPopUpPanelEnabled(false)
    end

    return self
end

function ModelWarConfiguratorRenewal:isPopUpPanelEnabled()
    if (self.m_View) then
        return self.m_View:isPopUpPanelEnabled()
    else
        return false
    end
end

function ModelWarConfiguratorRenewal:setPopUpPanelEnabled(enabled)
    if (self.m_View) then
        self.m_View:setPopUpPanelEnabled(enabled)
    end

    return self
end

function ModelWarConfiguratorRenewal:setPopUpPanelText(text)
    if (self.m_View) then
        self.m_View:setPopUpPanelText(text)
    end

    return self
end

function ModelWarConfiguratorRenewal:getPassword()
    if (not self.m_View) then
        return nil
    else
        return self.m_View:getEditBoxPassword():getText()
    end
end

function ModelWarConfiguratorRenewal:setPassword(password)
    if (self.m_View) then
        self.m_View:getEditBoxPassword():setText(password)
    end

    return self
end

function ModelWarConfiguratorRenewal:setPasswordEnabled(enabled)
    if (self.m_View) then
        self.m_View:getEditBoxPassword():setVisible(enabled)
    end

    return self
end

function ModelWarConfiguratorRenewal:getWarFieldFileName()
    return self.m_WarConfigurationModified.warFieldFileName
end

function ModelWarConfiguratorRenewal:setWarId(warID)
    self.m_WarID = warID

    return self
end

function ModelWarConfiguratorRenewal:getWarId()
    return self.m_WarID
end

function ModelWarConfiguratorRenewal:onButtonBackTouched()
    if (self.m_State ~= "stateMain") then
        setStateMain(self)
    elseif (self.m_OnButtonBackTouched) then
        self.m_OnButtonBackTouched()
    end

    return self
end

function ModelWarConfiguratorRenewal:disableButtonConfirmForSecs(secs)
    if (self.m_View) then
        self.m_View:disableButtonConfirmForSecs(secs)
    end

    return self
end

function ModelWarConfiguratorRenewal:onButtonConfirmTouched()
    if (self.m_OnButtonConfirmTouched) then
        self.m_OnButtonConfirmTouched()
    end

    return self
end

return ModelWarConfiguratorRenewal
