
local ModelExitWarSelector = class("ModelExitWarSelector")

local ActionCodeFunctions   = require("src.app.utilities.ActionCodeFunctions")
local AuxiliaryFunctions    = require("src.app.utilities.AuxiliaryFunctions")
local WebSocketManager      = require("src.app.utilities.WebSocketManager")
local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")
local SingletonGetters      = require("src.app.utilities.SingletonGetters")
local WarFieldManager       = require("src.app.utilities.WarFieldManager")
local Actor                 = require("src.global.actors.Actor")
local ActorManager          = require("src.global.actors.ActorManager")

local os, string       = os, string
local getLocalizedText = LocalizationFunctions.getLocalizedText

local ACTION_CODE_GET_ONGOING_WAR_CONFIGURATIONS = ActionCodeFunctions.getActionCode("ActionGetOngoingWarConfigurations")
local ACTION_CODE_RUN_SCENE_WAR                  = ActionCodeFunctions.getActionCode("ActionRunSceneWar")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getWarFieldName(fileName)
    return require("res.data.templateWarField." .. fileName).warFieldName
end

local function getPlayerNicknames(warConfiguration, currentTime)
    local playersCount = require("res.data.templateWarField." .. warConfiguration.warFieldFileName).playersCount
    local players      = warConfiguration.players
    local names        = {}

    for i = 1, playersCount do
        if (players[i]) then
            names[i] = players[i].account
            if (i == warConfiguration.playerIndexInTurn) then
                names[i] = names[i] .. string.format("(%s: %s)", getLocalizedText(34, "BootCountdown"),
                    AuxiliaryFunctions.formatTimeInterval(warConfiguration.intervalUntilBoot - currentTime + warConfiguration.enterTurnTime))
            end
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
        self.m_View:setViewWarFieldPreviewer(actor:getView())
    end

    return self.m_ActorWarFieldPreviewer
end

local function getActorWarConfigurator(self)
    if (not self.m_ActorWarConfigurator) then
        local model = Actor.createModel("sceneMain.ModelWarConfigurator")
        local view  = Actor.createView( "sceneMain.ViewWarConfigurator")

        model:setModeExitWar()
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

local function createWaitingWarList(self, warConfigurations)
    local warList               = {}
    local playerAccountLoggedIn = WebSocketManager.getLoggedInAccountAndPassword()

    for warID, warConfiguration in pairs(warConfigurations) do
        local warFieldFileName  = warConfiguration.warFieldFileName
        local playerIndexInTurn = warConfiguration.playerIndexInTurn

        warList[#warList + 1] = {
            warID        = warID,
            warFieldName = WarFieldManager.getWarFieldName(warFieldFileName),
            isInTurn     = (warConfiguration.players[playerIndexInTurn].account == playerAccountLoggedIn),
            callback     = function()
                getActorWarFieldPreviewer(self):getModel():setWarField(warFieldFileName)
                    :setPlayerNicknames(getPlayerNicknames(warConfiguration, os.time()))
                    :setEnabled(true)
                self.m_View:setButtonNextVisible(true)

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
function ModelExitWarSelector:ctor(param)
    return self
end

--------------------------------------------------------------------------------
-- The callback function on start running.
--------------------------------------------------------------------------------
function ModelExitWarSelector:onStartRunning(modelSceneMain)
    self.m_ModelSceneMain = modelSceneMain
    getActorWarConfigurator(self):getModel():onStartRunning(modelSceneMain)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelExitWarSelector:setEnabled(enabled)
    self.m_IsEnabled = enabled

    if (enabled) then
        SingletonGetters.getModelMessageIndicator(self.m_ModelSceneMain):showMessage(getLocalizedText(14, "RetrievingExitableWar"))
        WebSocketManager.sendAction({actionCode = ACTION_CODE_GET_ONGOING_WAR_CONFIGURATIONS})
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

function ModelExitWarSelector:isRetrievingOngoingWarConfigurations()
    return self.m_IsEnabled
end

function ModelExitWarSelector:updateWithOngoingWarConfigurations(warConfigurations)
    if (self.m_IsEnabled) then
        local warList = createWaitingWarList(self, warConfigurations)
        if (#warList == 0) then
            SingletonGetters.getModelMessageIndicator(self.m_ModelSceneMain):showMessage(getLocalizedText(8, "NoWaitingWar"))
        else
            self.m_View:showWarList(warList)
        end
    end

    return self
end

function ModelExitWarSelector:isRetrievingOngoingWarData()
    return self.m_IsEnabled
end

function ModelExitWarSelector:updateWithOngoingWarData(warData)
    local actorSceneWar = Actor.createWithModelAndViewName("sceneWar.ModelSceneWar", warData, "sceneWar.ViewSceneWar")
    ActorManager.setAndRunRootActor(actorSceneWar, "FADE", 1)
end

function ModelExitWarSelector:onButtonBackTouched()
    self:setEnabled(false)
    SingletonGetters.getModelMainMenu(self.m_ModelSceneMain):setMenuEnabled(true)

    return self
end

function ModelExitWarSelector:onButtonNextTouched()
    self.m_OnButtonNextTouched()

    return self
end

return ModelExitWarSelector
