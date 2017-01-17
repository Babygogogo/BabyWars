
local ModelJoinWarSelector = class("ModelJoinWarSelector")

local ActionCodeFunctions       = require("src.app.utilities.ActionCodeFunctions")
local AuxiliaryFunctions        = require("src.app.utilities.AuxiliaryFunctions")
local GameConstantFunctions     = require("src.app.utilities.GameConstantFunctions")
local LocalizationFunctions     = require("src.app.utilities.LocalizationFunctions")
local SingletonGetters          = require("src.app.utilities.SingletonGetters")
local SkillDataAccessors        = require("src.app.utilities.SkillDataAccessors")
local SkillDescriptionFunctions = require("src.app.utilities.SkillDescriptionFunctions")
local WebSocketManager          = require("src.app.utilities.WebSocketManager")
local ModelWeatherManager       = require("src.app.models.sceneWar.ModelWeatherManager")
local Actor                     = require("src.global.actors.Actor")

local getLocalizedText = LocalizationFunctions.getLocalizedText

local ACTION_CODE_GET_SKILL_CONFIGURATION         = ActionCodeFunctions.getActionCode("ActionGetSkillConfiguration")
local ACTION_CODE_GET_JOINABLE_WAR_CONFIGURATIONS = ActionCodeFunctions.getActionCode("ActionGetJoinableWarConfigurations")
local ACTION_CODE_JOIN_WAR                        = ActionCodeFunctions.getActionCode("ActionJoinWar")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getPlayerNicknames(warConfiguration)
    local playersCount = require("res.data.templateWarField." .. warConfiguration.warFieldFileName).playersCount
    local names = {}
    local players = warConfiguration.players

    for i = 1, playersCount do
        if (players[i]) then
            names[i] = players[i].account
        end
    end

    return names, playersCount
end

local function resetSelectorPlayerIndex(modelWarConfigurator, warConfiguration)
    local availablePlayerIndexes = {}
    local warField = require("res.data.templateWarField." .. warConfiguration.warFieldFileName)
    for i = 1, warField.playersCount do
        if (not warConfiguration.players[i]) then
            local colorText
            if     (i == 1) then colorText = "Red"
            elseif (i == 2) then colorText = "Blue"
            elseif (i == 3) then colorText = "Yellow"
            else                 colorText = "Black"
            end

            availablePlayerIndexes[#availablePlayerIndexes + 1] = {
                data = i,
                text = string.format("%d (%s)", i, getLocalizedText(34, colorText)),
            }
        end
    end

    modelWarConfigurator:getModelOptionSelectorWithName("PlayerIndex"):setButtonsEnabled(#availablePlayerIndexes > 1)
        :setOptions(availablePlayerIndexes)
end

local function resetSelectorFog(modelWarConfigurator, warConfiguration)
    local isFogOfWarByDefault = warConfiguration.isFogOfWarByDefault
    local options = {{
        data = isFogOfWarByDefault,
        text = getLocalizedText(9, isFogOfWarByDefault),
    }}

    modelWarConfigurator:getModelOptionSelectorWithName("Fog"):setOptions(options)
end

local function resetSelectorWeather(modelWarConfigurator, warConfiguration)
    local weatherCode = warConfiguration.defaultWeatherCode
    local options = {{
        data = weatherCode,
        text = getLocalizedText(40, ModelWeatherManager.getWeatherName(weatherCode)),
    }}

    modelWarConfigurator:getModelOptionSelectorWithName("Weather"):setOptions(options)
end

local function resetSelectorMaxSkillPoints(modelWarConfigurator, warConfiguration)
    local maxBaseSkillPoints = warConfiguration.maxBaseSkillPoints
    local options = {{
        data = maxBaseSkillPoints,
        text = (maxBaseSkillPoints)              and
            ("" .. maxBaseSkillPoints)           or
            (getLocalizedText(3, "Disable")),
    }}

    modelWarConfigurator:getModelOptionSelectorWithName("MaxSkillPoints"):setOptions(options)
end

local function resetSelectorSkill(self, modelWarConfigurator, warConfiguration)
    local options = {{
        data = nil,
        text = getLocalizedText(3, "None"),
    }}
    if (not warConfiguration.maxBaseSkillPoints) then
        modelWarConfigurator:getModelOptionSelectorWithName("Skill"):setOptions(options)
            :setButtonsEnabled(false)
            :setOptionIndicatorTouchEnabled(false)
    else
        local prefix = getLocalizedText(3, "Configuration") .. " "
        for i = 1, SkillDataAccessors.getSkillConfigurationsCount() do
            options[#options + 1] = {
                data = i,
                text = prefix .. i,
                callbackOnOptionIndicatorTouched = function()
                    modelWarConfigurator:setPopUpPanelText(getLocalizedText(3, "GettingConfiguration"))
                        :setPopUpPanelEnabled(true)
                    WebSocketManager.sendAction({
                            actionCode           = ACTION_CODE_GET_SKILL_CONFIGURATION,
                            skillConfigurationID = i,
                        })
                end,
            }
        end
        for i, presetData in pairs(SkillDataAccessors.getSkillPresets()) do
            options[#options + 1] = {
                text = presetData.name,
                data = -i,
                callbackOnOptionIndicatorTouched = function()
                    local modelSkillConfiguration = Actor.createModel("common.ModelSkillConfiguration", presetData)
                    modelWarConfigurator:setPopUpPanelEnabled(true)
                        :setPopUpPanelText(string.format("%s %s:\n%s",
                            getLocalizedText(3, "Configuration"), i,
                            SkillDescriptionFunctions.getBriefDescription(modelSkillConfiguration)
                        ))
                end,
            }
        end

        modelWarConfigurator:getModelOptionSelectorWithName("Skill"):setOptions(options)
            :setCurrentOptionIndex(2)
            :setButtonsEnabled(true)
            :setOptionIndicatorTouchEnabled(true)
    end
end

local function resetSelectorRankMatch(modelWarConfigurator, warConfiguration)
    modelWarConfigurator:getModelOptionSelectorWithName("RankMatch"):setButtonsEnabled(false)
        :setOptions({{
            data = nil,
            text = getLocalizedText(34, (warConfiguration.isRankMatch) and ("Yes") or ("No")),
        }})
end

local function resetSelectorMaxDiffScore(modelWarConfigurator, warConfiguration)
    modelWarConfigurator:getModelOptionSelectorWithName("MaxDiffScore"):setButtonsEnabled(false)
        :setOptions({{
            data = nil,
            text = (warConfiguration.maxDiffScore) and ("" .. warConfiguration.maxDiffScore) or (getLocalizedText(13, "NoLimit")),
        }})
end

local getActorWarConfigurator
local function resetModelWarConfigurator(self, warID, warConfiguration)
    local model = getActorWarConfigurator(self):getModel()
    model:setWarId(warID)
        :setEnabled(true)

    resetSelectorPlayerIndex(   model, warConfiguration)
    resetSelectorFog(           model, warConfiguration)
    resetSelectorWeather(       model, warConfiguration)
    resetSelectorMaxSkillPoints(model, warConfiguration)
    resetSelectorSkill(self,    model, warConfiguration)
    resetSelectorRankMatch(     model, warConfiguration)
    resetSelectorMaxDiffScore(  model, warConfiguration)
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
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

local function initCallbackOnButtonBackTouched(self, modelWarConfigurator)
    modelWarConfigurator:setOnButtonBackTouched(function()
        modelWarConfigurator:setEnabled(false)
        getActorWarFieldPreviewer(self):getModel():setEnabled(false)

        if (self.m_View) then
            self.m_View:setMenuVisible(true)
                :setButtonNextVisible(false)
        end
    end)
end

local function initCallbackOnButtonConfirmTouched(self, modelWarConfigurator)
    modelWarConfigurator:setOnButtonConfirmTouched(function()
        local modelConfirmBox = SingletonGetters.getModelConfirmBox(self.m_ModelSceneMain)
        modelConfirmBox:setConfirmText(getLocalizedText(8, "JoinWarConfirmation"))
            :setOnConfirmYes(function()
                local password = modelWarConfigurator:getPassword()
                if ((#password ~= 0) and (#password ~= 4)) then
                    SingletonGetters.getModelMessageIndicator(self.m_ModelSceneMain):showMessage(getLocalizedText(61))
                else
                    SingletonGetters.getModelMessageIndicator(self.m_ModelSceneMain):showMessage(getLocalizedText(8, "TransferingData"))
                    modelWarConfigurator:disableButtonConfirmForSecs(5)
                    WebSocketManager.sendAction({
                        actionCode           = ACTION_CODE_JOIN_WAR,
                        warID                = modelWarConfigurator:getWarId(),
                        playerIndex          = modelWarConfigurator:getModelOptionSelectorWithName("PlayerIndex"):getCurrentOption(),
                        skillConfigurationID = modelWarConfigurator:getModelOptionSelectorWithName("Skill")      :getCurrentOption(),
                        warPassword          = password,
                    })
                end
                modelConfirmBox:setEnabled(false)
            end)
            :setEnabled(true)
    end)
end

getActorWarConfigurator = function(self)
    if (not self.m_ActorWarConfigurator) then
        local model = Actor.createModel("sceneMain.ModelWarConfigurator")
        local view  = Actor.createView( "sceneMain.ViewWarConfigurator")

        model:setEnabled(false)
        initCallbackOnButtonBackTouched(   self, model)
        initCallbackOnButtonConfirmTouched(self, model)

        self.m_ActorWarConfigurator = Actor.createWithModelAndViewInstance(model, view)
        if (self.m_View) then
            self.m_View:setViewWarConfigurator(view)
        end
    end

    return self.m_ActorWarConfigurator
end

local function createJoinableWarList(self, list)
    local warList = {}
    for warID, warConfiguration in pairs(list or {}) do
        local warFieldFileName = warConfiguration.warFieldFileName
        warList[#warList + 1]  = {
            warFieldName = require("res.data.templateWarField." .. warFieldFileName).warFieldName,
            warID        = warID,

            callback     = function()
                getActorWarFieldPreviewer(self):getModel():setWarField(warFieldFileName)
                    :setPlayerNicknames(getPlayerNicknames(warConfiguration))
                    :setEnabled(true)
                if (self.m_View) then
                    self.m_View:setButtonNextVisible(true)
                end

                self.m_OnButtonNextTouched = function()
                    getActorWarFieldPreviewer(self):getModel():setEnabled(false)
                    resetModelWarConfigurator(self, warID, warConfiguration)
                    if (self.m_View) then
                        self.m_View:setMenuVisible(false)
                            :setButtonNextVisible(false)
                    end
                end
            end,
        }
    end

    table.sort(warList, function(item1, item2)
        return item1.warID < item2.warID
    end)

    return warList
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelJoinWarSelector:ctor(param)
    return self
end

--------------------------------------------------------------------------------
-- The callback function on start running.
--------------------------------------------------------------------------------
function ModelJoinWarSelector:onStartRunning(modelSceneMain)
    self.m_ModelSceneMain = modelSceneMain

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelJoinWarSelector:setEnabled(enabled)
    self.m_IsEnabled = enabled

    if (enabled) then
        WebSocketManager.sendAction({actionCode = ACTION_CODE_GET_JOINABLE_WAR_CONFIGURATIONS})
    end

    if (self.m_View) then
        self.m_View:setVisible(enabled)
            :setMenuVisible(true)
            :removeAllItems()
            :setButtonNextVisible(false)
    end

    getActorWarFieldPreviewer(self):getModel():setEnabled(false)
    getActorWarConfigurator(self):getModel():setEnabled(false)

    return self
end

function ModelJoinWarSelector:isRetrievingSkillConfiguration(skillConfigurationID)
    local modelWarConfigurator = getActorWarConfigurator(self):getModel()
    return (modelWarConfigurator:isPopUpPanelEnabled())                                                           and
        (modelWarConfigurator:getModelOptionSelectorWithName("Skill"):getCurrentOption() == skillConfigurationID)
end

function ModelJoinWarSelector:updateWithSkillConfiguration(skillConfiguration, skillConfigurationID)
    getActorWarConfigurator(self):getModel():setPopUpPanelText(string.format("%s %d:\n%s",
        getLocalizedText(3, "Configuration"),
        skillConfigurationID,
        SkillDescriptionFunctions.getFullDescription(Actor.createModel("common.ModelSkillConfiguration", skillConfiguration))
    ))
end

function ModelJoinWarSelector:isRetrievingJoinableWarConfigurations()
    return (self.m_IsEnabled) and (not getActorWarConfigurator(self):getModel():isEnabled())
end

function ModelJoinWarSelector:updateWithJoinableWarConfigurations(warConfigurations)
    local warList = createJoinableWarList(self, warConfigurations)
    if (#warList == 0) then
        SingletonGetters.getModelMessageIndicator(self.m_ModelSceneMain):showMessage(getLocalizedText(60))
    elseif (self.m_View) then
        self.m_View:showWarList(warList)
    end

    return self
end

function ModelJoinWarSelector:isRetrievingJoinWarResult(warID)
    local modelWarConfigurator = getActorWarConfigurator(self):getModel()
    return (modelWarConfigurator:isEnabled()) and (modelWarConfigurator:getWarId() == warID)
end

function ModelJoinWarSelector:onButtonFindTouched(editBoxText)
    if (#editBoxText ~= 6) then
        SingletonGetters.getModelMessageIndicator(self.m_ModelSceneMain):showMessage(getLocalizedText(59))
    else
        getActorWarFieldPreviewer(self):getModel():setEnabled(false)
        if (self.m_View) then
            self.m_View:removeAllItems()
                :setButtonNextVisible(false)
        end

        WebSocketManager.sendAction({
            actionCode = ACTION_CODE_GET_JOINABLE_WAR_CONFIGURATIONS,
            warID      = AuxiliaryFunctions.getWarIdWithWarName(editBoxText:lower()),
        })
    end

    return self
end

function ModelJoinWarSelector:onButtonBackTouched()
    self:setEnabled(false)
    SingletonGetters.getModelMainMenu(self.m_ModelSceneMain):setMenuEnabled(true)

    return self
end

function ModelJoinWarSelector:onButtonNextTouched()
    self.m_OnButtonNextTouched()

    return self
end

return ModelJoinWarSelector
