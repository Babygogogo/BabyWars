
local ModelNewWarCreator = class("ModelNewWarCreator")

local WarFieldList              = require("res.data.templateWarField.WarFieldList")
local ActionCodeFunctions       = require("src.app.utilities.ActionCodeFunctions")
local LocalizationFunctions     = require("src.app.utilities.LocalizationFunctions")
local SingletonGetters          = require("src.app.utilities.SingletonGetters")
local SkillDataAccessors        = require("src.app.utilities.SkillDataAccessors")
local SkillDescriptionFunctions = require("src.app.utilities.SkillDescriptionFunctions")
local WebSocketManager          = require("src.app.utilities.WebSocketManager")
local Actor                     = require("src.global.actors.Actor")

local getLocalizedText = LocalizationFunctions.getLocalizedText

local ACTION_CODE_GET_SKILL_CONFIGURATION     = ActionCodeFunctions.getActionCode("ActionGetSkillConfiguration")
local ACTION_CODE_NEW_WAR                     = ActionCodeFunctions.getActionCode("ActionNewWar")
local MIN_POINTS, MAX_POINTS, POINTS_PER_STEP = SkillDataAccessors.getBasePointsMinMaxStep()

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getWarFieldName(fileName)
    return require("res.data.templateWarField." .. fileName).warFieldName
end

local function resetSelectorPlayerIndex(modelWarConfigurator, playersCount)
    local options = {}
    for i = 1, playersCount do
        local colorText
        if     (i == 1) then colorText = "Red"
        elseif (i == 2) then colorText = "Blue"
        elseif (i == 3) then colorText = "Yellow"
        else                 colorText = "Black"
        end

        options[#options + 1] = {
            data = i,
            text = string.format("%d (%s)", i, getLocalizedText(34, colorText)),
        }
    end

    modelWarConfigurator:getModelOptionSelectorWithName("PlayerIndex"):setButtonsEnabled(true)
        :setOptions(options)
end

local function resetSelectorMaxSkillPoints(modelWarConfigurator)
    modelWarConfigurator:getModelOptionSelectorWithName("MaxSkillPoints"):setCurrentOptionIndex((100 - MIN_POINTS) / POINTS_PER_STEP + 2)
end

local function resetModelWarConfigurator(model, warFieldFileName)
    model:setWarFieldFileName(warFieldFileName)
        :setEnabled(true)

    local warField = require("res.data.templateWarField." .. warFieldFileName)
    resetSelectorPlayerIndex(   model, warField.playersCount)
    resetSelectorMaxSkillPoints(model)
    model:getModelOptionSelectorWithName("Skill"):setCurrentOptionIndex(2)
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
        local modelConfirmBox = SingletonGetters.getModelConfirmBox()
        modelConfirmBox:setConfirmText(getLocalizedText(8, "NewWarConfirmation"))
            :setOnConfirmYes(function()
                local password = modelWarConfigurator:getPassword()
                if ((#password ~= 0) and (#password ~= 4)) then
                    SingletonGetters.getModelMessageIndicator():showMessage(getLocalizedText(61))
                else
                    SingletonGetters.getModelMessageIndicator():showMessage(getLocalizedText(8, "TransferingData"))
                    modelWarConfigurator:disableButtonConfirmForSecs(5)
                    WebSocketManager.sendAction({
                        actionCode               = ACTION_CODE_NEW_WAR,
                        defaultIntervalUntilBoot = 3600 * 24 * 3,
                        warPassword              = password,
                        warFieldFileName         = modelWarConfigurator:getWarFieldFileName(),
                        playerIndex              = modelWarConfigurator:getModelOptionSelectorWithName("PlayerIndex")   :getCurrentOption(),
                        skillConfigurationID     = modelWarConfigurator:getModelOptionSelectorWithName("Skill")         :getCurrentOption(),
                        maxBaseSkillPoints       = modelWarConfigurator:getModelOptionSelectorWithName("MaxSkillPoints"):getCurrentOption(),
                        isFogOfWarByDefault      = modelWarConfigurator:getModelOptionSelectorWithName("Fog")           :getCurrentOption(),
                        defaultWeatherCode       = modelWarConfigurator:getModelOptionSelectorWithName("Weather")       :getCurrentOption(),
                        isRankMatch              = modelWarConfigurator:getModelOptionSelectorWithName("RankMatch")     :getCurrentOption(),
                        maxDiffScore             = modelWarConfigurator:getModelOptionSelectorWithName("MaxDiffScore")  :getCurrentOption(),
                    })
                end
                modelConfirmBox:setEnabled(false)
            end)
            :setEnabled(true)
    end)
end

local function initSelectorSkill(self, modelWarConfigurator)
    local options = {{
        data = nil,
        text = getLocalizedText(3, "None"),
    }}
    local prefix  = getLocalizedText(3, "Configuration") .. " "
    for i = 1, SkillDataAccessors.getSkillConfigurationsCount() do
        options[#options + 1] = {
            text = prefix .. i,
            data = i,
            callbackOnOptionIndicatorTouched = function()
                modelWarConfigurator:setPopUpPanelText(getLocalizedText(3, "GettingConfiguration"))
                    :setPopUpPanelEnabled(true)
                WebSocketManager.sendAction({
                        actionCode           = ACTION_CODE_GET_SKILL_CONFIGURATION,
                        skillConfigurationID = i
                    })
            end,
        }
    end
    for i, presetData in ipairs(SkillDataAccessors.getSkillPresets()) do
        local presetName = presetData.name
        options[#options + 1] = {
            text = presetName,
            data = -i,
            callbackOnOptionIndicatorTouched = function()
                local modelSkillConfiguration = Actor.createModel("common.ModelSkillConfiguration", presetData)
                modelWarConfigurator:setPopUpPanelEnabled(true)
                    :setPopUpPanelText(string.format("%s %s:\n%s",
                        getLocalizedText(3, "Configuration"), presetName,
                        SkillDescriptionFunctions.getBriefDescription(modelSkillConfiguration)
                    ))
            end,
        }
    end

    modelWarConfigurator:getModelOptionSelectorWithName("Skill"):setOptions(options)
        :setButtonsEnabled(true)
        :setOptionIndicatorTouchEnabled(true)
end

local function initSelectorMaxSkillPoints(modelWarConfigurator)
    local options = {{
        data = nil,
        text = getLocalizedText(3, "Disable"),
        callbackOnSwitched = function()
            modelWarConfigurator:getModelOptionSelectorWithName("Skill"):setCurrentOptionIndex(1)
                :setButtonsEnabled(false)
                :setOptionIndicatorTouchEnabled(false)
        end,
    }}
    for points = MIN_POINTS, MAX_POINTS, POINTS_PER_STEP do
        options[#options + 1] = {
            data = points,
            text = "" .. points,
            callbackOnSwitched = function()
                modelWarConfigurator:getModelOptionSelectorWithName("Skill"):setButtonsEnabled(true)
                    :setOptionIndicatorTouchEnabled(true)
            end,
        }
    end

    modelWarConfigurator:getModelOptionSelectorWithName("MaxSkillPoints"):setOptions(options)
        :setButtonsEnabled(true)
end

local function initSelectorFog(modelWarConfigurator)
    modelWarConfigurator:getModelOptionSelectorWithName("Fog"):setOptions({
            {data = false, text = getLocalizedText(9, false),},
            {data = true,  text = getLocalizedText(9, true),},
        })
        :setButtonsEnabled(true)
end

local function initSelectorWeather(modelWarConfigurator)
    -- TODO: enable the selector.
    modelWarConfigurator:getModelOptionSelectorWithName("Weather"):setButtonsEnabled(false)
        :setOptions({
            {data = 1, text = getLocalizedText(40, "Clear"),},
        })
end

local function initSelectorRankMatch(modelWarConfigurator)
    modelWarConfigurator:getModelOptionSelectorWithName("RankMatch"):setOptions({
            {data = false, text = getLocalizedText(34, "No"), },
            {data = true,  text = getLocalizedText(34, "Yes"),},
        })
        :setButtonsEnabled(true)
end

local function initSelectorMaxDiffScore(modelWarConfigurator)
    modelWarConfigurator:getModelOptionSelectorWithName("MaxDiffScore"):setOptions({
            {data = 50,  text = "50",                           },
            {data = 100, text = "100",                          },
            {data = 150, text = "150",                          },
            {data = 200, text = "200",                          },
            {data = nil, text = getLocalizedText(13, "NoLimit"),},
        })
        :setButtonsEnabled(true)
        :setCurrentOptionIndex(2)
end

local function getActorWarConfigurator(self)
    if (not self.m_ActorWarConfigurator) then
        local model = Actor.createModel("sceneMain.ModelWarConfigurator")
        local view  = Actor.createView("sceneMain.ViewWarConfigurator")

        model:setEnabled(false)
        initCallbackOnButtonConfirmTouched(self, model)
        initCallbackOnButtonBackTouched(   self, model)
        initSelectorSkill(self,    model)
        initSelectorMaxSkillPoints(model)
        initSelectorFog(           model)
        initSelectorWeather(       model)
        initSelectorRankMatch(     model)
        initSelectorMaxDiffScore(  model)

        self.m_ActorWarConfigurator = Actor.createWithModelAndViewInstance(model, view)
        if (self.m_View) then
            self.m_View:setViewWarConfigurator(view)
        end
    end

    return self.m_ActorWarConfigurator
end

local function initWarFieldList(self, list)
    local list = {}
    for _, warFieldFileName in ipairs(WarFieldList) do
        list[#list + 1] = {
            name     = getWarFieldName(warFieldFileName),
            callback = function()
                getActorWarFieldPreviewer(self):getModel():setWarField(warFieldFileName)
                    :setEnabled(true)
                if (self.m_View) then
                    self.m_View:setButtonNextVisible(true)
                end

                self.m_OnButtonNextTouched = function()
                    getActorWarFieldPreviewer(self):getModel():setEnabled(false)
                    resetModelWarConfigurator(getActorWarConfigurator(self):getModel(), warFieldFileName)
                    if (self.m_View) then
                        self.m_View:setMenuVisible(false)
                            :setButtonNextVisible(false)
                    end
                end
            end,
        }
    end

    self.m_ItemListWarField = list
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelNewWarCreator:ctor(param)
    initWarFieldList(self)

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelNewWarCreator:initView()
    local view = self.m_View
    assert(view, "ModelNewWarCreator:initView() no view is attached to the actor of the model.")

    view:removeAllItems()
        :showListWarField(self.m_ItemListWarField)

    return self
end

function ModelNewWarCreator:setModelMainMenu(model)
    assert(self.m_ModelMainMenu == nil, "ModelNewWarCreator:setModelMainMenu() the model has been set.")
    self.m_ModelMainMenu = model

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelNewWarCreator:isEnabled()
    return self.m_IsEnabled
end

function ModelNewWarCreator:setEnabled(enabled)
    self.m_IsEnabled = enabled
    getActorWarFieldPreviewer(self):getModel():setEnabled(false)
    getActorWarConfigurator(self):getModel():setEnabled(false)

    if (self.m_View) then
        self.m_View:setVisible(enabled)
            :setButtonNextVisible(false)
            :setMenuVisible(true)
    end

    return self
end

function ModelNewWarCreator:isRetrievingSkillConfiguration(skillConfigurationID)
    local modelWarConfigurator = getActorWarConfigurator(self):getModel()
    return (modelWarConfigurator:isPopUpPanelEnabled())                                                           and
        (modelWarConfigurator:getModelOptionSelectorWithName("Skill"):getCurrentOption() == skillConfigurationID)
end

function ModelNewWarCreator:updateWithSkillConfiguration(skillConfiguration, skillConfigurationID)
    getActorWarConfigurator(self):getModel():setPopUpPanelText(string.format("%s %d:\n%s",
        getLocalizedText(3, "Configuration"),
        skillConfigurationID,
        SkillDescriptionFunctions.getFullDescription(Actor.createModel("common.ModelSkillConfiguration", skillConfiguration))
    ))
end

function ModelNewWarCreator:onButtonBackTouched()
    self:setEnabled(false)
    self.m_ModelMainMenu:setMenuEnabled(true)

    return self
end

function ModelNewWarCreator:onButtonNextTouched()
    self.m_OnButtonNextTouched()

    return self
end

return ModelNewWarCreator
