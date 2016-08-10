
--[[--------------------------------------------------------------------------------
-- ModelContinueWarSelector是主场景中的“已参战、未结束的战局”的列表。
--
-- 主要职责和使用场景举例：
--   构造并显示上述战局列表
--
-- 其他：
--   目前ModelContinueWarSelector里的列表项是直接从本地获取的（res/data/warScene/WarSceneList.lua）。在联机功能下，该列表应该从服务器获取。
--]]--------------------------------------------------------------------------------

local ModelContinueWarSelector = class("ModelContinueWarSelector")

local Actor                 = require("src.global.actors.Actor")
local ActorManager          = require("src.global.actors.ActorManager")
local WebSocketManager      = require("src.app.utilities.WebSocketManager")
local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getWarFieldName(fileName)
    return require("res.data.templateWarField." .. fileName).warFieldName
end

local function configModelWarConfigurator(model, sceneWarFileName, configuration)
    model:setSceneWarFileName(sceneWarFileName)
        :setEnabled(true)

    local availablePlayerIndexes = {}
    local loggedInAccount = WebSocketManager.getLoggedInAccountAndPassword()
    for playerIndex, player in pairs(configuration.players) do
        if (player.account == loggedInAccount) then
            availablePlayerIndexes[1] = {data = playerIndex, text = "" .. playerIndex,}
            break
        end
    end
    model:getModelOptionSelectorWithName("PlayerIndex"):setButtonsEnabled(false)
        :setOptions(availablePlayerIndexes)

    model:getModelOptionSelectorWithName("Fog"):setButtonsEnabled(false)
        :setOptions({configuration.fog})

    model:getModelOptionSelectorWithName("Weather"):setButtonsEnabled(false)
        :setOptions({configuration.weather})

    model:getModelOptionSelectorWithName("Skill"):setButtonsEnabled(false)
        :setOptions({
            {data = "Unavailable", text = LocalizationFunctions.getLocalizedText(45),}
        })

    model:getModelOptionSelectorWithName("MaxSkillPoints"):setButtonsEnabled(false)
        :setOptions({configuration.maxSkillPoints})
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
        local actor = Actor.createWithModelAndViewName("sceneMain.ModelWarConfigurator", nil, "sceneMain.ViewWarConfigurator")
        actor:getModel():setEnabled(false)
            :setPasswordEnabled(false)

            :setOnButtonBackTouched(function()
                getActorWarFieldPreviewer(self):getModel():setEnabled(false)
                getActorWarConfigurator(self):getModel():setEnabled(false)
                if (self.m_View) then
                    self.m_View:setMenuVisible(true)
                        :setButtonNextVisible(false)
                end
            end)

            :setOnButtonConfirmTouched(function()
                local modelWarConfigurator = getActorWarConfigurator(self):getModel()
                self.m_RootScriptEventDispatcher:dispatchEvent({
                    name       = "EvtPlayerRequestDoAction",
                    actionName = "GetSceneWarData",
                    fileName   = modelWarConfigurator:getSceneWarFileName(),
                })
            end)

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
                    :setEnabled(true)
                if (self.m_View) then
                    self.m_View:setButtonNextVisible(true)
                end

                self.m_OnButtonNextTouched = function()
                    getActorWarFieldPreviewer(self):getModel():setEnabled(false)
                    configModelWarConfigurator(getActorWarConfigurator(self):getModel(), sceneWarFileName, configuration)
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
