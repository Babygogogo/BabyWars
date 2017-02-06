
local ModelNewWarCreator = class("ModelNewWarCreator")

local SingletonGetters          = require("src.app.utilities.SingletonGetters")
local WarFieldManager           = require("src.app.utilities.WarFieldManager")
local Actor                     = require("src.global.actors.Actor")

local ipairs = ipairs

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

local function getActorWarConfigurator(self)
    if (not self.m_ActorWarConfigurator) then
        local model = Actor.createModel("sceneMain.ModelWarConfigurator")
        local view  = Actor.createView( "sceneMain.ViewWarConfigurator")

        model:setModeCreateWar()
            :setEnabled(false)
            :setCallbackOnButtonBackTouched(function()
                model:setEnabled(false)
                getActorWarFieldPreviewer(self):getModel():setEnabled(false)

                self.m_View:setMenuVisible(true)
                    :setButtonNextVisible(false)
            end)

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
                self.m_WarFieldFileName = warFieldFileName
                getActorWarFieldPreviewer(self):getModel():setWarField(warFieldFileName)
                    :setEnabled(true)

                self.m_View:setButtonNextVisible(true)
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
    getActorWarConfigurator(self):getModel():onStartRunning(modelSceneMain)

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
    return getActorWarConfigurator(self):getModel():isRetrievingSkillConfiguration(skillConfigurationID)
end

function ModelNewWarCreator:updateWithSkillConfiguration(skillConfiguration, skillConfigurationID)
    getActorWarConfigurator(self):getModel():updateWithSkillConfiguration(skillConfiguration, skillConfigurationID)

    return self
end

function ModelNewWarCreator:onButtonBackTouched()
    self:setEnabled(false)
    SingletonGetters.getModelMainMenu(self.m_ModelSceneMain):setMenuEnabled(true)

    return self
end

function ModelNewWarCreator:onButtonNextTouched()
    getActorWarFieldPreviewer(self):getModel():setEnabled(false)
    getActorWarConfigurator(self):getModel():resetWithWarConfiguration({warFieldFileName = self.m_WarFieldFileName})
        :setEnabled(true)

    self.m_View:setMenuVisible(false)
        :setButtonNextVisible(false)

    return self
end

return ModelNewWarCreator
