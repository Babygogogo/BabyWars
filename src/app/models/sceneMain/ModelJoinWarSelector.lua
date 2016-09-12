
local ModelJoinWarSelector = class("ModelJoinWarSelector")

local GameConstantFunctions     = require("src.app.utilities.GameConstantFunctions")
local LocalizationFunctions     = require("src.app.utilities.LocalizationFunctions")
local SkillDescriptionFunctions = require("src.app.utilities.SkillDescriptionFunctions")
local WebSocketManager          = require("src.app.utilities.WebSocketManager")
local Actor                     = require("src.global.actors.Actor")
local ActorManager              = require("src.global.actors.ActorManager")

local getLocalizedText = LocalizationFunctions.getLocalizedText

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
            availablePlayerIndexes[#availablePlayerIndexes + 1] = {
                data = i,
                text = "" .. i
            }
        end
    end

    modelWarConfigurator:getModelOptionSelectorWithName("PlayerIndex"):setButtonsEnabled(#availablePlayerIndexes > 1)
        :setOptions(availablePlayerIndexes)
end

local function resetSelectorFog(modelWarConfigurator, warConfiguration)
    local hasFog = warConfiguration.fog
    local options = {{
        data = hasFog,
        text = getLocalizedText(hasFog and 28 or 29),
    }}

    modelWarConfigurator:getModelOptionSelectorWithName("Fog"):setOptions(options)
end

local function resetSelectorWeather(modelWarConfigurator, warConfiguration)
    local weather = warConfiguration.weather
    local options = {{
        data = weather,
        text = getLocalizedText(40, weather),
    }}

    modelWarConfigurator:getModelOptionSelectorWithName("Weather"):setOptions(options)
end

local function resetSelectorMaxSkillPoints(modelWarConfigurator, warConfiguration)
    local maxSkillPoints = warConfiguration.maxSkillPoints
    local options = {{
        data = maxSkillPoints,
        text = (maxSkillPoints)              and
            ("" .. maxSkillPoints)           or
            (getLocalizedText(3, "Disable")),
    }}

    modelWarConfigurator:getModelOptionSelectorWithName("MaxSkillPoints"):setOptions(options)
end

local function resetSelectorSkill(self, modelWarConfigurator, warConfiguration)
    local options = {{
        data = 0,
        text = getLocalizedText(3, "Disable"),
    }}
    if (not warConfiguration.maxSkillPoints) then
        modelWarConfigurator:getModelOptionSelectorWithName("Skill"):setOptions(options)
            :setButtonsEnabled(false)
            :setOptionIndicatorTouchEnabled(false)
    else
        local prefix  = getLocalizedText(3, "Configuration") .. " "
        for i = 1, GameConstantFunctions.getSkillConfigurationsCount() do
            options[#options + 1] = {
                data = i,
                text = prefix .. i,
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
            :setCurrentOptionIndex(2)
            :setButtonsEnabled(true)
            :setOptionIndicatorTouchEnabled(true)
    end
end

local getActorWarConfigurator
local function resetModelWarConfigurator(self, sceneWarFileName, configuration)
    local model = getActorWarConfigurator(self):getModel()
    model:setSceneWarFileName(sceneWarFileName)
        :setEnabled(true)

    resetSelectorPlayerIndex(   model, configuration)
    resetSelectorFog(           model, configuration)
    resetSelectorWeather(       model, configuration)
    resetSelectorMaxSkillPoints(model, configuration)
    resetSelectorSkill(self,    model, configuration)
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
            ActorManager.getRootModelMessageIndicator():showMessage(getLocalizedText(61))
        else
            WebSocketManager.sendAction({
                actionName           = "JoinWar",
                sceneWarFileName     = modelWarConfigurator:getSceneWarFileName(),
                playerIndex          = modelWarConfigurator:getModelOptionSelectorWithName("PlayerIndex"):getCurrentOption(),
                skillConfigurationID = modelWarConfigurator:getModelOptionSelectorWithName("Skill")      :getCurrentOption(),
                warPassword          = password,
            })
        end
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
    for sceneWarFileName, configuration in pairs(list) do
        local warFieldFileName = configuration.warFieldFileName
        warList[#warList + 1] = {
            warFieldName     = require("res.data.templateWarField." .. warFieldFileName).warFieldName,
            sceneWarFileName = sceneWarFileName,

            callback         = function()
                getActorWarFieldPreviewer(self):getModel():setWarField(warFieldFileName)
                    :setPlayerNicknames(getPlayerNicknames(configuration))
                    :setEnabled(true)
                if (self.m_View) then
                    self.m_View:setButtonNextVisible(true)
                end

                self.m_OnButtonNextTouched = function()
                    getActorWarFieldPreviewer(self):getModel():setEnabled(false)
                    resetModelWarConfigurator(self, sceneWarFileName, configuration)
                    if (self.m_View) then
                        self.m_View:setMenuVisible(false)
                            :setButtonNextVisible(false)
                    end
                end
            end,
        }
    end

    return warList
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelJoinWarSelector:ctor(param)
    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelJoinWarSelector:initView()
    local view = self.m_View
    assert(view, "ModelJoinWarSelector:initView() no view is attached to the actor of the model.")

    view:removeAllItems()

    return self
end

function ModelJoinWarSelector:setModelMainMenu(model)
    assert(self.m_ModelMainMenu == nil, "ModelJoinWarSelector:setModelMainMenu() the model has been set.")
    self.m_ModelMainMenu = model

    return self
end

--------------------------------------------------------------------------------
-- The public functions for doing actions.
--------------------------------------------------------------------------------
function ModelJoinWarSelector:doActionGetJoinableWarList(action)
    if ((self.m_View) and (self.m_IsEnabled)) then
        local warList = createJoinableWarList(self, action.list)
        if (#warList == 0) then
            ActorManager.getRootModelMessageIndicator():showMessage(getLocalizedText(60))
        else
            self.m_View:showWarList(warList)
        end
    end

    return self
end

function ModelJoinWarSelector:doActionJoinWar(action)
    self:setEnabled(false)
    self.m_ModelMainMenu:setMenuEnabled(true)
    ActorManager.getRootModelMessageIndicator():showMessage(action.message)

    return self
end

function ModelJoinWarSelector:doActionGetSkillConfiguration(action)
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
function ModelJoinWarSelector:setEnabled(enabled)
    self.m_IsEnabled = enabled

    if (enabled) then
        WebSocketManager.sendAction({
            actionName = "GetJoinableWarList",
        })
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

function ModelJoinWarSelector:onButtonFindTouched(editBoxText)
    if (#editBoxText ~= 4) then
        ActorManager.getRootModelMessageIndicator():showMessage(getLocalizedText(59))
    else
        getActorWarFieldPreviewer(self):getModel():setEnabled(false)
        if (self.m_View) then
            self.m_View:removeAllItems()
                :setButtonNextVisible(false)
        end

        WebSocketManager.sendAction({
            actionName        = "GetJoinableWarList",
            sceneWarShortName = editBoxText:lower(),
        })
    end

    return self
end

function ModelJoinWarSelector:onButtonBackTouched()
    self:setEnabled(false)
    self.m_ModelMainMenu:setMenuEnabled(true)

    return self
end

function ModelJoinWarSelector:onButtonNextTouched()
    self.m_OnButtonNextTouched()

    return self
end

return ModelJoinWarSelector
