
local ModelNewWarCreator = class("ModelNewWarCreator")

local ActionCodeFunctions       = require("src.app.utilities.ActionCodeFunctions")
local LocalizationFunctions     = require("src.app.utilities.LocalizationFunctions")
local SingletonGetters          = require("src.app.utilities.SingletonGetters")
local SkillDataAccessors        = require("src.app.utilities.SkillDataAccessors")
local SkillDescriptionFunctions = require("src.app.utilities.SkillDescriptionFunctions")
local WarFieldManager           = require("src.app.utilities.WarFieldManager")
local WebSocketManager          = require("src.app.utilities.WebSocketManager")
local Actor                     = require("src.global.actors.Actor")

local getLocalizedText = LocalizationFunctions.getLocalizedText
local ipairs           = ipairs

local ACTION_CODE_GET_SKILL_CONFIGURATION     = ActionCodeFunctions.getActionCode("ActionGetSkillConfiguration")
local ACTION_CODE_NEW_WAR                     = ActionCodeFunctions.getActionCode("ActionNewWar")
local MIN_POINTS, MAX_POINTS, POINTS_PER_STEP = SkillDataAccessors.getBasePointsMinMaxStep()

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
    modelWarConfigurator:setCallbackOnButtonBackTouched(function()
        modelWarConfigurator:setEnabled(false)
        getActorWarFieldPreviewer(self):getModel():setEnabled(false)

        if (self.m_View) then
            self.m_View:setMenuVisible(true)
                :setButtonNextVisible(false)
        end
    end)
end

local function initCallbackOnButtonConfirmTouched(self, modelWarConfigurator)
    modelWarConfigurator:setCallbackOnButtonConfirmTouched(function()
        local modelConfirmBox = SingletonGetters.getModelConfirmBox(self.m_ModelSceneMain)
        modelConfirmBox:setConfirmText(getLocalizedText(8, "NewWarConfirmation"))
            :setOnConfirmYes(function()
                local password = modelWarConfigurator:getPassword()
                if ((#password ~= 0) and (#password ~= 4)) then
                    SingletonGetters.getModelMessageIndicator(self.m_ModelSceneMain):showMessage(getLocalizedText(61))
                else
                    SingletonGetters.getModelMessageIndicator(self.m_ModelSceneMain):showMessage(getLocalizedText(8, "TransferingData"))
                    modelWarConfigurator:disableButtonConfirmForSecs(5)
                    WebSocketManager.sendAction({
                        actionCode           = ACTION_CODE_NEW_WAR,
                        intervalUntilBoot    = 3600 * 24 * 3, -- TODO: add a selector for this.
                        warPassword          = password,
                        warFieldFileName     = modelWarConfigurator:getWarFieldFileName(),
                        playerIndex          = modelWarConfigurator:getModelOptionSelectorWithName("PlayerIndex")   :getCurrentOption(),
                        skillConfigurationID = modelWarConfigurator:getModelOptionSelectorWithName("Skill")         :getCurrentOption(),
                        maxBaseSkillPoints   = modelWarConfigurator:getModelOptionSelectorWithName("MaxSkillPoints"):getCurrentOption(),
                        isFogOfWarByDefault  = modelWarConfigurator:getModelOptionSelectorWithName("Fog")           :getCurrentOption(),
                        defaultWeatherCode   = modelWarConfigurator:getModelOptionSelectorWithName("Weather")       :getCurrentOption(),
                        isRankMatch          = modelWarConfigurator:getModelOptionSelectorWithName("RankMatch")     :getCurrentOption(),
                        maxDiffScore         = modelWarConfigurator:getModelOptionSelectorWithName("MaxDiffScore")  :getCurrentOption(),
                    })
                end
                modelConfirmBox:setEnabled(false)
            end)
            :setEnabled(true)
    end)
end

local function getActorWarConfigurator(self)
    if (not self.m_ActorWarConfigurator) then
        local model = Actor.createModel("sceneMain.ModelWarConfiguratorRenewal")
        local view  = Actor.createView( "sceneMain.ViewWarConfiguratorRenewal")

        model:setModeAsCreatingWar()
            :setEnabled(false)
        initCallbackOnButtonConfirmTouched(self, model)
        initCallbackOnButtonBackTouched(   self, model)

        self.m_ActorWarConfigurator = Actor.createWithModelAndViewInstance(model, view)
        self.m_View:setViewWarConfigurator(view)
    end

    return self.m_ActorWarConfigurator
end

local function initWarFieldList(self, list)
    local list = {}
    for _, warFieldFileName in ipairs(WarFieldManager.getWarFieldFileNameList()) do
        list[#list + 1] = {
            name     = WarFieldManager.getWarFieldName(warFieldFileName),
            callback = function()
                getActorWarFieldPreviewer(self):getModel():setWarField(warFieldFileName)
                    :setEnabled(true)
                self.m_View:setButtonNextVisible(true)

                self.m_OnButtonNextTouched = function()
                    getActorWarFieldPreviewer(self):getModel():setEnabled(false)
                    getActorWarConfigurator(self):getModel():resetWithWarConfiguration({warFieldFileName = warFieldFileName})
                        :setEnabled(true)

                    self.m_View:setMenuVisible(false)
                        :setButtonNextVisible(false)
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

    return self
end

function ModelNewWarCreator:initView()
    local view = self.m_View
    assert(view, "ModelNewWarCreator:initView() no view is attached to the actor of the model.")

    view:removeAllItems()
        :showListWarField(self.m_ItemListWarField)

    return self
end

--------------------------------------------------------------------------------
-- The callback function on start running.
--------------------------------------------------------------------------------
function ModelNewWarCreator:onStartRunning(modelSceneMain)
    self.m_ModelSceneMain = modelSceneMain

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
    SingletonGetters.getModelMainMenu(self.m_ModelSceneMain):setMenuEnabled(true)

    return self
end

function ModelNewWarCreator:onButtonNextTouched()
    self.m_OnButtonNextTouched()

    return self
end

return ModelNewWarCreator
