
--[[--------------------------------------------------------------------------------
-- ModelContinueWarSelector是主场景中的“已参战、未结束的战局”的列表。
--
-- 主要职责和使用场景举例：
--   构造并显示上述战局列表
--
--]]--------------------------------------------------------------------------------

local ModelContinueWarSelector = class("ModelContinueWarSelector")

local WebSocketManager      = require("src.app.utilities.WebSocketManager")
local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")
local Actor                 = require("src.global.actors.Actor")
local ActorManager          = require("src.global.actors.ActorManager")

local getLocalizedText = LocalizationFunctions.getLocalizedText

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
        text = (maxSkillPoints) and ("" .. maxSkillPoints) or (getLocalizedText(3, "Disable")),
    }}

    modelWarConfigurator:getModelOptionSelectorWithName("MaxSkillPoints"):setOptions(options)
end

local function resetModelWarConfigurator(model, sceneWarFileName, configuration)
    model:setSceneWarFileName(sceneWarFileName)
        :setEnabled(true)

    resetSelectorPlayerIndex(   model, configuration)
    resetSelectorFog(           model, configuration)
    resetSelectorWeather(       model, configuration)
    resetSelectorMaxSkillPoints(model, configuration)
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
        self.m_RootScriptEventDispatcher:dispatchEvent({
            name       = "EvtPlayerRequestDoAction",
            actionName = "GetSceneWarData",
            fileName   = modelWarConfigurator:getSceneWarFileName(),
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
    assert(type(list) == "table", "ModelContinueWarSelector-createOngoingWarList() failed to require list data from the server.")

    local warList = {}
    for sceneWarFileName, item in pairs(list) do
        local configuration    = item.configuration
        local warFieldFileName = configuration.warFieldFileName
        warList[#warList + 1] = {
            sceneWarFileName = sceneWarFileName,
            warFieldName     = getWarFieldName(warFieldFileName),
            isInTurn         = item.isInTurn,
            callback         = function()
                getActorWarFieldPreviewer(self):getModel():setWarField(warFieldFileName)
                    :setPlayerNicknames(getPlayerNicknames(configuration))
                    :setEnabled(true)
                if (self.m_View) then
                    self.m_View:setButtonNextVisible(true)
                end

                self.m_OnButtonNextTouched = function()
                    getActorWarFieldPreviewer(self):getModel():setEnabled(false)
                    resetModelWarConfigurator(getActorWarConfigurator(self):getModel(), sceneWarFileName, configuration)
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

function ModelContinueWarSelector:setModelConfirmBox(model)
    assert(self.m_ModelConfirmBox == nil, "ModelContinueWarSelector:setModelConfirmBox() the model has been set already.")
    self.m_ModelConfirmBox = model

    return self
end

function ModelContinueWarSelector:setModelMainMenu(model)
    assert(self.m_ModelMainMenu == nil, "ModelContinueWarSelector:setModelMainMenu() the model has been set.")
    self.m_ModelMainMenu = model

    return self
end

function ModelContinueWarSelector:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelContinueWarSelector:setRootScriptEventDispatcher() the dispatcher has been set.")
    self.m_RootScriptEventDispatcher = dispatcher

    return self
end

--------------------------------------------------------------------------------
-- The public functions for doing actions.
--------------------------------------------------------------------------------
function ModelContinueWarSelector:doActionGetOngoingWarList(action)
    self.m_WarList = createOngoingWarList(self, action.list)
    if ((self.m_View) and (self.m_IsEnabled)) then
        self.m_View:showWarList(self.m_WarList)
    end

    return self
end

function ModelContinueWarSelector:doActionGetSceneWarData(action)
    if (self.m_IsEnabled) then
        local actorSceneWar = Actor.createWithModelAndViewName("sceneWar.ModelSceneWar", action.data, "sceneWar.ViewSceneWar")
        WebSocketManager.setOwner(actorSceneWar:getModel())
        ActorManager.setAndRunRootActor(actorSceneWar, "FADE", 1)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelContinueWarSelector:setEnabled(enabled)
    self.m_IsEnabled = enabled

    if (enabled) then
        self.m_RootScriptEventDispatcher:dispatchEvent({
            name       = "EvtPlayerRequestDoAction",
            actionName = "GetOngoingWarList",
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
