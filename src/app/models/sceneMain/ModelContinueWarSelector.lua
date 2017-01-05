
--[[--------------------------------------------------------------------------------
-- ModelContinueWarSelector是主场景中的“已参战、未结束的战局”的列表。
--
-- 主要职责和使用场景举例：
--   构造并显示上述战局列表
--
--]]--------------------------------------------------------------------------------

local ModelContinueWarSelector = class("ModelContinueWarSelector")

local ActionCodeFunctions   = require("src.app.utilities.ActionCodeFunctions")
local WebSocketManager      = require("src.app.utilities.WebSocketManager")
local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")
local SingletonGetters      = require("src.app.utilities.SingletonGetters")
local ModelWeatherManager   = require("src.app.models.sceneWar.ModelWeatherManager")
local Actor                 = require("src.global.actors.Actor")
local ActorManager          = require("src.global.actors.ActorManager")

local getLocalizedText = LocalizationFunctions.getLocalizedText

local ACTION_CODE_GET_ONGOING_WAR_LIST = ActionCodeFunctions.getActionCode("ActionGetOngoingWarList")
local ACTION_CODE_RUN_SCENE_WAR        = ActionCodeFunctions.getActionCode("ActionRunSceneWar")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getWarFieldName(fileName)
    return require("res.data.templateWarField." .. fileName).warFieldName
end

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
    local options         = {}
    local loggedInAccount = WebSocketManager.getLoggedInAccountAndPassword()
    for playerIndex, data in pairs(warConfiguration.players) do
        if (data.account == loggedInAccount) then
            options[#options + 1] = {
                data = playerIndex,
                text = "" .. playerIndex,
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

local function resetModelWarConfigurator(model, sceneWarFileName, warConfiguration)
    model:setSceneWarFileName(sceneWarFileName)
        :setEnabled(true)

    resetSelectorPlayerIndex(   model, warConfiguration)
    resetSelectorFog(           model, warConfiguration)
    resetSelectorWeather(       model, warConfiguration)
    resetSelectorMaxSkillPoints(model, warConfiguration)
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
        getActorWarFieldPreviewer(self):getModel():setEnabled(false)
        self:setEnabled(true)

        if (self.m_View) then
            self.m_View:setMenuVisible(true)
                :setButtonNextVisible(false)
        end
    end)
end

local function initCallbackOnButtonConfirmTouched(self, modelWarConfigurator)
    modelWarConfigurator:setOnButtonConfirmTouched(function()
        SingletonGetters.getModelMessageIndicator():showMessage(getLocalizedText(8, "TransferingData"))
        modelWarConfigurator:disableButtonConfirmForSecs(5)
        WebSocketManager.sendAction({
            actionCode       = ACTION_CODE_RUN_SCENE_WAR,
            sceneWarFileName = modelWarConfigurator:getSceneWarFileName(),
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
        if (self.m_View) then
            self.m_View:setViewWarConfigurator(actor:getView())
        end
    end

    return self.m_ActorWarConfigurator
end

local function createOngoingWarList(self, list)
    local warList = {}
    for _, item in pairs(list) do
        local warConfiguration = item.warConfiguration
        local sceneWarFileName = warConfiguration.sceneWarFileName
        local warFieldFileName = warConfiguration.warFieldFileName
        warList[#warList + 1] = {
            sceneWarFileName = sceneWarFileName,
            warFieldName     = getWarFieldName(warFieldFileName),
            isInTurn         = item.isInTurn,
            callback         = function()
                getActorWarFieldPreviewer(self):getModel():setWarField(warFieldFileName)
                    :setPlayerNicknames(getPlayerNicknames(warConfiguration))
                    :setEnabled(true)
                if (self.m_View) then
                    self.m_View:setButtonNextVisible(true)
                end

                self.m_OnButtonNextTouched = function()
                    getActorWarFieldPreviewer(self):getModel():setEnabled(false)
                    resetModelWarConfigurator(getActorWarConfigurator(self):getModel(), sceneWarFileName, warConfiguration)
                    if (self.m_View) then
                        self.m_View:setMenuVisible(false)
                            :setButtonNextVisible(false)
                    end
                end
            end,
        }
    end

    table.sort(warList, function(item1, item2)
        return item1.sceneWarFileName < item2.sceneWarFileName
    end)

    return warList
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelContinueWarSelector:ctor(param)
    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelContinueWarSelector:initView()
    local view = self.m_View
    assert(view, "ModelContinueWarSelector:initView() no view is attached to the actor of the model.")

    view:removeAllItems()

    return self
end

function ModelContinueWarSelector:setModelMainMenu(model)
    assert(self.m_ModelMainMenu == nil, "ModelContinueWarSelector:setModelMainMenu() the model has been set.")
    self.m_ModelMainMenu = model

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelContinueWarSelector:setEnabled(enabled)
    self.m_IsEnabled = enabled

    if (enabled) then
        SingletonGetters.getModelMessageIndicator():showMessage(getLocalizedText(8, "TransferingData"))
        WebSocketManager.sendAction({actionCode = ACTION_CODE_GET_ONGOING_WAR_LIST})
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

function ModelContinueWarSelector:isRetrievingOngoingWarList()
    return self.m_IsEnabled
end

function ModelContinueWarSelector:updateWithOngoingWarList(list)
    if ((self.m_View) and (self.m_IsEnabled)) then
        local warList = createOngoingWarList(self, list)
        if (#warList == 0) then
            SingletonGetters.getModelMessageIndicator():showMessage(getLocalizedText(8, "NoContinuableWar"))
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
    self.m_ModelMainMenu:setMenuEnabled(true)

    return self
end

function ModelContinueWarSelector:onButtonNextTouched()
    self.m_OnButtonNextTouched()

    return self
end

return ModelContinueWarSelector
