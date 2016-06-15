
local ModelJoinWarSelector = class("ModelJoinWarSelector")

local Actor            = require("global.actors.Actor")
local ActorManager     = require("global.actors.ActorManager")
local WebSocketManager = require("app.utilities.WebSocketManager")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function configModelWarConfigurator(model, sceneWarFileName, configuration)
    model:setSceneWarFileName(sceneWarFileName)
        :setEnabled(true)

    local availablePlayerIndexes = {}
    local warField = require("res.data.templateWarField." .. configuration.warFieldFileName)
    for i = 1, warField.playersCount do
        if (not configuration.players[i]) then
            availablePlayerIndexes[#availablePlayerIndexes + 1] = i
        end
    end
    model:getModelOptionSelectorWithName("PlayerIndex"):setButtonsEnabled(true)
        :setOptions(availablePlayerIndexes)

    model:getModelOptionSelectorWithName("Fog"):setButtonsEnabled(false)
        :setOptions({configuration.fog})

    model:getModelOptionSelectorWithName("Weather"):setButtonsEnabled(false)
        :setOptions({configuration.weather})

    model:getModelOptionSelectorWithName("Skill"):setButtonsEnabled(false)
        :setOptions({"Unavailable"})

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
                local password             = modelWarConfigurator:getPassword()
                if ((#password ~= 0) and (#password ~= 4)) then
                    self.m_ModelMessageIndicator:showMessage("The password is invalid. Please try again.")
                else
                    self.m_RootScriptEventDispatcher:dispatchEvent({
                        name             = "EvtPlayerRequestDoAction",
                        actionName       = "JoinWar",
                        sceneWarFileName = modelWarConfigurator:getSceneWarFileName(),
                        playerIndex      = modelWarConfigurator:getModelOptionSelectorWithName("PlayerIndex"):getCurrentOption(),
                        skillIndex       = 1,
                        warPassword      = password,
                    })
                end
            end)

        self.m_ActorWarConfigurator = actor
        if (self.m_View) then
            self.m_View:setViewWarConfigurator(actor:getView())
        end
    end

    return self.m_ActorWarConfigurator
end

local function createJoinableWarList(self, list)
    assert(type(list) == "table", "ModelJoinWarSelector-createJoinableWarList() failed to require list data from the server.")

    local warList = {}
    for sceneWarFileName, configuration in pairs(list) do
        local warFieldFileName = configuration.warFieldFileName
        warList[#warList + 1] = {
            warFieldName     = require("res.data.templateWarField." .. warFieldFileName).warFieldName,
            sceneWarFileName = sceneWarFileName,

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

function ModelJoinWarSelector:setModelConfirmBox(model)
    assert(self.m_ModelConfirmBox == nil, "ModelJoinWarSelector:setModelConfirmBox() the model has been set already.")
    self.m_ModelConfirmBox = model

    return self
end

function ModelJoinWarSelector:setModelMainMenu(model)
    assert(self.m_ModelMainMenu == nil, "ModelJoinWarSelector:setModelMainMenu() the model has been set.")
    self.m_ModelMainMenu = model

    return self
end

function ModelJoinWarSelector:setModelMessageIndicator(model)
    assert(self.m_ModelMessageIndicator == nil, "ModelJoinWarSelector:setModelMessageIndicator() the model has been set.")
    self.m_ModelMessageIndicator = model

    return self
end

function ModelJoinWarSelector:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelJoinWarSelector:setRootScriptEventDispatcher() the dispatcher has been set.")
    self.m_RootScriptEventDispatcher = dispatcher

    return self
end

--------------------------------------------------------------------------------
-- The public functions for doing actions.
--------------------------------------------------------------------------------
function ModelJoinWarSelector:doActionGetJoinableWarList(action)
    self.m_WarList = createJoinableWarList(self, action.list)
    if (self.m_IsEnabled) then
        if (#self.m_WarList == 0) then
            self.m_ModelMessageIndicator:showMessage("Sorry, but no war is currently joinable. Please wait for or create a new war.")
        elseif (self.m_View) then
            self.m_View:showWarList(self.m_WarList)
        end
    end

    return self
end

function ModelJoinWarSelector:doActionJoinWar(action)
    self:setEnabled(false)
    self.m_ModelMainMenu:setMenuEnabled(true)
    self.m_ModelMessageIndicator:showMessage(action.message)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelJoinWarSelector:setEnabled(enabled)
    self.m_IsEnabled = enabled

    if (enabled) then
        self.m_RootScriptEventDispatcher:dispatchEvent({
            name       = "EvtPlayerRequestDoAction",
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
        self.m_ModelMessageIndicator:showMessage("The War ID is invalid. Please try again.")
    else
        getActorWarFieldPreviewer(self):getModel():setEnabled(false)
        if (self.m_View) then
            self.m_View:removeAllItems()
                :setButtonNextVisible(false)
        end

        self.m_RootScriptEventDispatcher:dispatchEvent({
            name              = "EvtPlayerRequestDoAction",
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
