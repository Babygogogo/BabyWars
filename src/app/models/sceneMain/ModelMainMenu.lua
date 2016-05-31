
local ModelMainMenu = class("ModelMainMenu")

local Actor = require("global.actors.Actor")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function showMenuItems(self, ...)
    local view = self.m_View
    assert(view, "ModelMainMenu-showMenuItems() no view is attached to the owner actor of the model.")

    view:removeAllItems()
    for _, item in ipairs({...}) do
        view:createAndPushBackItem(item)
    end
end

--------------------------------------------------------------------------------
-- The composition actors.
--------------------------------------------------------------------------------
local function getActorNewWarCreator(self)
    if (not self.m_ActorNewWarCreator) then
        local actor = Actor.createWithModelAndViewName("ModelNewWarCreator", nil, "ViewNewWarCreator")
        actor:getModel():setModelMainMenu(self)
            :setEnabled(false)
            :setRootScriptEventDispatcher(self.m_RootScriptEventDispatcher)

        self.m_ActorNewWarCreator = actor
        self.m_View:setViewNewWarCreator(actor:getView())
    end

    return self.m_ActorNewWarCreator
end

local function getActorContinueWarSelector(self)
    if (not self.m_ActorContinueWarSelector) then
        local actor = Actor.createWithModelAndViewName("ModelContinueWarSelector", nil, "ViewContinueWarSelector")
        actor:getModel():setModelMainMenu(self)
            :setEnabled(false)
            :setModelConfirmBox(self.m_ModelConfirmBox)
            :setRootScriptEventDispatcher(self.m_RootScriptEventDispatcher)

        self.m_ActorContinueWarSelector = actor
        self.m_View:setViewContinueWarSelector(actor:getView())
    end

    return self.m_ActorContinueWarSelector
end

local function getActorLoginPanel(self)
    if (not self.m_ActorLoginPanel) then
        local actor = Actor.createWithModelAndViewName("sceneMain.ModelLoginPanel", nil, "sceneMain.ViewLoginPanel")
        actor:getModel():setModelMainMenu(self)
            :setModelMessageIndicator(self.m_ModelMessageIndicator)
            :setModelConfirmBox(self.m_ModelConfirmBox)
            :setEnabled(false)
            :setRootScriptEventDispatcher(self.m_RootScriptEventDispatcher)

        self.m_ActorLoginPanel = actor
        self.m_View:setViewLoginPanel(actor:getView())
    end

    return self.m_ActorLoginPanel
end

--------------------------------------------------------------------------------
-- The composition menu items.
--------------------------------------------------------------------------------
local function initItemNewWar(self)
    local item = {
        name = "New Game",
        callback = function()
            self:setMenuEnabled(false)
            getActorNewWarCreator(self):getModel():setEnabled(true)
        end,
    }

    self.m_ItemNewWar = item
end

local function initItemContinue(self)
    local item = {
        name     = "Continue",
        callback = function()
            self:setMenuEnabled(false)
            getActorContinueWarSelector(self):getModel():setEnabled(true)
        end,
    }

    self.m_ItemContinue = item
end

local function initItemConfigSkills(self)
    local item = {
        name = "Config Skills",
        callback = function()
            self.m_ModelMessageIndicator:showMessage("Sorry, the Config Skills feature is not implemented.")
        end,
    }

    self.m_ItemConfigSkills = item
end

local function initItemLogin(self)
    local item = {
        name = "Login",
        callback = function()
            self:setMenuEnabled(false)
            getActorLoginPanel(self):getModel():setEnabled(true)
        end,
    }

    self.m_ItemLogin = item
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelMainMenu:ctor(param)
    initItemNewWar(     self)
    initItemContinue(    self)
    initItemConfigSkills(self)
    initItemLogin(       self)

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelMainMenu:initView()
    local view = self.m_View
    assert(view, "ModelMainMenu:initView() no view is attached to the actor of the model.")

    self:updateWithIsPlayerLoggedIn(false)

    return self
end

function ModelMainMenu:setModelConfirmBox(model)
    assert(self.m_ModelConfirmBox == nil, "ModelMainMenu:setModelConfirmBox() the model has been set.")
    self.m_ModelConfirmBox = model

    return self
end

function ModelMainMenu:setModelMessageIndicator(model)
    assert(self.m_ModelMessageIndicator == nil, "ModelMainMenu:setModelMessageIndicator() the model has been set.")
    self.m_ModelMessageIndicator = model

    return self
end

function ModelMainMenu:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelMainMenu:setRootScriptEventDispatcher() the dispatcher has been set.")
    self.m_RootScriptEventDispatcher = dispatcher

    return self
end

--------------------------------------------------------------------------------
-- The public functions for doing actions.
--------------------------------------------------------------------------------
function ModelMainMenu:doActionLogin(action)
    self:updateWithIsPlayerLoggedIn(true)
        :setMenuEnabled(true)

    getActorLoginPanel(self)         :getModel():doActionLogin(action)
    getActorContinueWarSelector(self):getModel():doActionLogin(action)

    return self
end

function ModelMainMenu:doActionNewWar(action)
    self.m_ActorNewWarCreator:getModel():setEnabled(false)
    self:setMenuEnabled(true)

    return self
end

function ModelMainMenu:doActionGetOngoingWarList(action)
    getActorContinueWarSelector(self):getModel():doActionGetOngoingWarList(action)

    return self
end

function ModelMainMenu:doActionGetSceneWarData(action)
    getActorContinueWarSelector(self):getModel():doActionGetSceneWarData(action)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelMainMenu:setEnabled(enabled)
    if (self.m_View) then
        self.m_View:setVisible(enabled)
    end

    return self
end

function ModelMainMenu:setMenuEnabled(enabled)
    if (self.m_View) then
        self.m_View:setMenuVisible(enabled)
    end

    return self
end

function ModelMainMenu:updateWithIsPlayerLoggedIn(isLogged)
    if (self.m_View) then
        if (isLogged) then
            showMenuItems(self, self.m_ItemNewWar, self.m_ItemContinue, self.m_ItemConfigSkills, self.m_ItemLogin)
        else
            showMenuItems(self, self.m_ItemLogin)
        end
    end

    return self
end

return ModelMainMenu
