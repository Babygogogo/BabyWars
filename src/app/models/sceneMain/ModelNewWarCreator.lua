
local ModelNewWarCreator = class("ModelNewWarCreator")

local WarFieldList              = require("res.data.templateWarField.WarFieldList")
local LocalizationFunctions     = require("src.app.utilities.LocalizationFunctions")
local GameConstantFunctions     = require("src.app.utilities.GameConstantFunctions")
local SingletonGetters          = require("src.app.utilities.SingletonGetters")
local SkillDescriptionFunctions = require("src.app.utilities.SkillDescriptionFunctions")
local WebSocketManager          = require("src.app.utilities.WebSocketManager")
local Actor                     = require("src.global.actors.Actor")

local getLocalizedText = LocalizationFunctions.getLocalizedText

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getWarFieldName(fileName)
    return require("res.data.templateWarField." .. fileName).warFieldName
end

local function resetSelectorPlayerIndex(modelWarConfigurator, playersCount)
    local options = {}
    for i = 1, playersCount do
        options[#options + 1] = {
            data = i,
            text = "" .. i,
        }
    end

    modelWarConfigurator:getModelOptionSelectorWithName("PlayerIndex"):setButtonsEnabled(true)
        :setOptions(options)
end

local function resetModelWarConfigurator(model, warFieldFileName)
    model:setWarFieldFileName(warFieldFileName)
        :setEnabled(true)

    local warField = require("res.data.templateWarField." .. warFieldFileName)
    resetSelectorPlayerIndex(model, warField.playersCount)
    model:getModelOptionSelectorWithName("MaxSkillPoints"):setCurrentOptionIndex(6)
    model:getModelOptionSelectorWithName("Skill")         :setCurrentOptionIndex(2)
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
        local password = modelWarConfigurator:getPassword()
        if ((#password ~= 0) and (#password ~= 4)) then
            SingletonGetters.getModelMessageIndicator():showMessage(getLocalizedText(61))
        else
            WebSocketManager.sendAction({
                actionName           = "NewWar",
                warPassword          = password,
                warFieldFileName     = modelWarConfigurator:getWarFieldFileName(),
                playerIndex          = modelWarConfigurator:getModelOptionSelectorWithName("PlayerIndex")   :getCurrentOption(),
                skillConfigurationID = modelWarConfigurator:getModelOptionSelectorWithName("Skill")         :getCurrentOption(),
                maxSkillPoints       = modelWarConfigurator:getModelOptionSelectorWithName("MaxSkillPoints"):getCurrentOption(),
            })
        end
    end)
end

local function initSelectorSkill(self, modelWarConfigurator)
    local options = {{
        data = 0,
        text = getLocalizedText(3, "Disable"),
    }}
    local prefix  = getLocalizedText(3, "Configuration") .. " "
    for i = 1, GameConstantFunctions.getSkillConfigurationsCount() do
        options[#options + 1] = {
            text = prefix .. i,
            data = i,
            callbackOnOptionIndicatorTouched = function()
                modelWarConfigurator:setPopUpPanelText(getLocalizedText(3, "GettingConfiguration"))
                    :setPopUpPanelEnabled(true)
                WebSocketManager.sendAction({
                    actionName      = "GetSkillConfiguration",
                    configurationID = i,
                })
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
    local minPoints, maxPoints, pointsPerStep = GameConstantFunctions.getSkillPointsMinMaxStep()
    for points = minPoints, maxPoints, pointsPerStep do
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
        :setCurrentOptionIndex(5)
        :setButtonsEnabled(true)
end

local function initSelectorFog(modelWarConfigurator)
    -- TODO: enable the selector.
    modelWarConfigurator:getModelOptionSelectorWithName("Fog"):setButtonsEnabled(false)
        :setOptions({
            {data = false, text = getLocalizedText(29),},
        })
end

local function initSelectorWeather(modelWarConfigurator)
    -- TODO: enable the selector.
    modelWarConfigurator:getModelOptionSelectorWithName("Weather"):setButtonsEnabled(false)
        :setOptions({
            {data = "Clear", text = getLocalizedText(40, "Clear"),},
        })
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
-- The public functions for doing actions.
--------------------------------------------------------------------------------
function ModelNewWarCreator:doActionGetSkillConfiguration(action)
    local modelWarConfigurator = getActorWarConfigurator(self):getModel()
    if (modelWarConfigurator:isPopUpPanelEnabled()) then
        local modelSkillConfiguration = Actor.createModel("common.ModelSkillConfiguration", action.configuration)
        modelWarConfigurator:setPopUpPanelText(string.format("%s %d:\n%s",
            getLocalizedText(3, "Configuration"), action.configurationID,
            SkillDescriptionFunctions.getDescription(modelSkillConfiguration)
        ))
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelNewWarCreator:setEnabled(enabled)
    getActorWarFieldPreviewer(self):getModel():setEnabled(false)
    getActorWarConfigurator(self):getModel():setEnabled(false)

    if (self.m_View) then
        self.m_View:setVisible(enabled)
            :setButtonNextVisible(false)
            :setMenuVisible(true)
    end

    return self
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
