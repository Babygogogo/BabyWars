
local ModelJoinWarSelector = class("ModelJoinWarSelector")

local ActionCodeFunctions       = requireBW("src.app.utilities.ActionCodeFunctions")
local AuxiliaryFunctions        = requireBW("src.app.utilities.AuxiliaryFunctions")
local LocalizationFunctions     = requireBW("src.app.utilities.LocalizationFunctions")
local SingletonGetters          = requireBW("src.app.utilities.SingletonGetters")
local WebSocketManager          = requireBW("src.app.utilities.WebSocketManager")
local Actor                     = requireBW("src.global.actors.Actor")

local getLocalizedText = LocalizationFunctions.getLocalizedText

local ACTION_CODE_GET_JOINABLE_WAR_CONFIGURATIONS = ActionCodeFunctions.getActionCode("ActionGetJoinableWarConfigurations")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getPlayerNicknames(warConfiguration)
    local playersCount = requireBW("res.data.templateWarField." .. warConfiguration.warFieldFileName).playersCount
    local names = {}
    local players = warConfiguration.players

    for i = 1, playersCount do
        if (players[i]) then
            names[i] = players[i].account
        end
    end

    return names, playersCount
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

local function getActorWarConfigurator(self)
    if (not self.m_ActorWarConfigurator) then
        local model = Actor.createModel("sceneMain.ModelWarConfigurator")
        local view  = Actor.createView( "sceneMain.ViewWarConfigurator")

        model:setModeJoinWar()
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

local function createJoinableWarList(self, list)
    local warList = {}
    for warID, warConfiguration in pairs(list or {}) do
        local warFieldFileName = warConfiguration.warFieldFileName
        warList[#warList + 1]  = {
            warFieldName = requireBW("res.data.templateWarField." .. warFieldFileName).warFieldName,
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
                    getActorWarConfigurator(self):getModel():resetWithWarConfiguration(warConfiguration)
                        :setEnabled(true)
                    self.m_View:setMenuVisible(false)
                        :setButtonNextVisible(false)
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
    getActorWarConfigurator(self):getModel():onStartRunning(modelSceneMain)

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
    return getActorWarConfigurator(self):getModel():isRetrievingSkillConfiguration(skillConfigurationID)
end

function ModelJoinWarSelector:updateWithSkillConfiguration(skillConfiguration, skillConfigurationID)
    getActorWarConfigurator(self):getModel():updateWithSkillConfiguration(skillConfiguration, skillConfigurationID)

    return self
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
