
--[[--------------------------------------------------------------------------------
-- ModelContinueWarSelector是主场景中的“已参战、未结束的战局”的列表。
--
-- 主要职责和使用场景举例：
--   构造并显示上述战局列表
--
--]]--------------------------------------------------------------------------------

local ModelContinueWarSelector = class("ModelContinueWarSelector")

local ActionCodeFunctions   = require("src.app.utilities.ActionCodeFunctions")
local AuxiliaryFunctions    = require("src.app.utilities.AuxiliaryFunctions")
local WebSocketManager      = require("src.app.utilities.WebSocketManager")
local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")
local SingletonGetters      = require("src.app.utilities.SingletonGetters")
local ModelWeatherManager   = require("src.app.models.sceneWar.ModelWeatherManager")
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

local function resetSelectorPlayerIndex(modelWarConfigurator, warConfiguration)
    local options         = {}
    local loggedInAccount = WebSocketManager.getLoggedInAccountAndPassword()
    for playerIndex, data in pairs(warConfiguration.players) do
        if (data.account == loggedInAccount) then
            local colorText
            if     (playerIndex == 1) then colorText = "Red"
            elseif (playerIndex == 2) then colorText = "Blue"
            elseif (playerIndex == 3) then colorText = "Yellow"
            else                           colorText = "Black"
            end

            options[#options + 1] = {
                data = playerIndex,
                text = string.format("%d (%s)", playerIndex, getLocalizedText(34, colorText)),
            }
        end
    end

    assert(#options == 1)
    modelWarConfigurator:getModelOptionSelectorWithName("PlayerIndex"):setOptions(options)
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

local function resetModelWarConfigurator(model, warID, warConfiguration)
    model:setWarId(warID)
        :setEnabled(true)

    resetSelectorPlayerIndex(   model, warConfiguration)
    resetSelectorFog(           model, warConfiguration)
    resetSelectorWeather(       model, warConfiguration)
    resetSelectorMaxSkillPoints(model, warConfiguration)
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
        self.m_View:setViewWarFieldPreviewer(actor:getView())
    end

    return self.m_ActorWarFieldPreviewer
end

local function initCallbackOnButtonBackTouched(self, modelWarConfigurator)
    modelWarConfigurator:setOnButtonBackTouched(function()
        getActorWarFieldPreviewer(self):getModel():setEnabled(false)
        self:setEnabled(true)

        self.m_View:setMenuVisible(true)
            :setButtonNextVisible(false)
    end)
end

local function initCallbackOnButtonConfirmTouched(self, modelWarConfigurator)
    modelWarConfigurator:setOnButtonConfirmTouched(function()
        SingletonGetters.getModelMessageIndicator(self.m_ModelSceneMain):showMessage(getLocalizedText(8, "TransferingData"))
        modelWarConfigurator:disableButtonConfirmForSecs(5)
        WebSocketManager.sendAction({
            actionCode = ACTION_CODE_RUN_SCENE_WAR,
            warID      = modelWarConfigurator:getWarId(),
        })
    end)
end

local function initSelectorSkill(modelWarConfigurator)
    modelWarConfigurator:getModelOptionSelectorWithName("Skill"):setOptions({{
        data = "Unavailable",
        text = getLocalizedText(3, "Selected"),
    }})
end

local function getActorWarConfigurator(self)
    if (not self.m_ActorWarConfigurator) then
        local actor = Actor.createWithModelAndViewName("sceneMain.ModelWarConfigurator", nil, "sceneMain.ViewWarConfigurator")
        local model = actor:getModel()

        model:setEnabled(false)
            :setPasswordEnabled(false)
            :getModelOptionSelectorWithName("PlayerIndex"):setButtonsEnabled(false)
        initCallbackOnButtonBackTouched(   self, model)
        initCallbackOnButtonConfirmTouched(self, model)
        initSelectorSkill(model)

        self.m_ActorWarConfigurator = actor
        self.m_View:setViewWarConfigurator(actor:getView())
    end

    return self.m_ActorWarConfigurator
end

local function createOngoingWarList(self, warConfigurations)
    local warList               = {}
    local playerAccountLoggedIn = WebSocketManager.getLoggedInAccountAndPassword()

    for warID, warConfiguration in pairs(warConfigurations) do
        local warFieldFileName  = warConfiguration.warFieldFileName
        local playerIndexInTurn = warConfiguration.playerIndexInTurn

        warList[#warList + 1] = {
            warID        = warID,
            warFieldName = getWarFieldName(warFieldFileName),
            isInTurn     = (warConfiguration.players[playerIndexInTurn].account == playerAccountLoggedIn),
            callback     = function()
                getActorWarFieldPreviewer(self):getModel():setWarField(warFieldFileName)
                    :setPlayerNicknames(getPlayerNicknames(warConfiguration, os.time()))
                    :setEnabled(true)
                self.m_View:setButtonNextVisible(true)

                self.m_OnButtonNextTouched = function()
                    getActorWarFieldPreviewer(self):getModel():setEnabled(false)
                    self.m_View:setMenuVisible(false)
                        :setButtonNextVisible(false)

                    resetModelWarConfigurator(getActorWarConfigurator(self):getModel(), warID, warConfiguration)
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
function ModelContinueWarSelector:ctor(param)
    return self
end

--------------------------------------------------------------------------------
-- The callback function on start running.
--------------------------------------------------------------------------------
function ModelContinueWarSelector:onStartRunning(modelSceneMain)
    self.m_ModelSceneMain = modelSceneMain

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelContinueWarSelector:setEnabled(enabled)
    self.m_IsEnabled = enabled

    if (enabled) then
        SingletonGetters.getModelMessageIndicator(self.m_ModelSceneMain):showMessage(getLocalizedText(8, "TransferingData"))
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

function ModelContinueWarSelector:isRetrievingOngoingWarConfigurations()
    return self.m_IsEnabled
end

function ModelContinueWarSelector:updateWithOngoingWarConfigurations(warConfigurations)
    if (self.m_IsEnabled) then
        local warList = createOngoingWarList(self, warConfigurations)
        if (#warList == 0) then
            SingletonGetters.getModelMessageIndicator(self.m_ModelSceneMain):showMessage(getLocalizedText(8, "NoContinuableWar"))
        else
            self.m_View:showWarList(warList)
        end
    end

    return self
end

function ModelContinueWarSelector:isRetrievingOngoingWarData()
    return self.m_IsEnabled
end

function ModelContinueWarSelector:updateWithOngoingWarData(warData)
    local actorSceneWar = Actor.createWithModelAndViewName("sceneWar.ModelSceneWar", warData, "sceneWar.ViewSceneWar")
    ActorManager.setAndRunRootActor(actorSceneWar, "FADE", 1)
end

function ModelContinueWarSelector:onButtonBackTouched()
    self:setEnabled(false)
    SingletonGetters.getModelMainMenu(self.m_ModelSceneMain):setMenuEnabled(true)

    return self
end

function ModelContinueWarSelector:onButtonNextTouched()
    self.m_OnButtonNextTouched()

    return self
end

return ModelContinueWarSelector
