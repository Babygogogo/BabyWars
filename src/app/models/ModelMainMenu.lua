
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
local function getActorNewGameCreator(self)
    if (not self.m_ActorNewGameCreator) then
        local actor = Actor.createWithModelAndViewName("ModelNewGameCreator", nil, "ViewNewGameCreator")
        actor:getModel():setModelMainMenu(self)
            :setEnabled(false)

        self.m_ActorNewGameCreator = actor
        self.m_View:setViewNewGameCreator(actor:getView())
    end

    return self.m_ActorNewGameCreator
end

local function getActorContinueGameSelector(self)
    if (not self.m_ActorContinueGameSelector) then
        local actor = Actor.createWithModelAndViewName("ModelContinueGameSelector", nil, "ViewContinueGameSelector")
        actor:getModel():setModelMainMenu(self)
            :setEnabled(false)
            :setModelConfirmBox(self.m_ModelConfirmBox)
            :setRootScriptEventDispatcher(self.m_RootScriptEventDispatcher)

        self.m_ActorContinueGameSelector = actor
        self.m_View:setViewContinueGameSelector(actor:getView())
    end

    return self.m_ActorContinueGameSelector
end

local function getActorLoginPanel(self)
    if (not self.m_ActorLoginPanel) then
        local actor = Actor.createWithModelAndViewName("ModelLoginPanel", nil, "ViewLoginPanel")
        actor:getModel():setModelMainMenu(self)
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
local function initItemNewGame(self)
    local item = {
        name = "New Game",
        callback = function()
            self:setMenuEnabled(false)
            getActorNewGameCreator(self):getModel():setEnabled(true)
        end,
    }

    self.m_ItemNewGame = item
end

local function initItemContinue(self)
    local item = {
        name     = "Continue",
        callback = function()
            self:setMenuEnabled(false)
            getActorContinueGameSelector(self):getModel():setEnabled(true)
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
    initItemNewGame(     self)
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

    getActorLoginPanel(self)          :getModel():doActionLogin(action)
    getActorContinueGameSelector(self):getModel():doActionLogin(action)

    return self
end

function ModelMainMenu:doActionGetOngoingWarList(action)
    getActorContinueGameSelector(self):getModel():doActionGetOngoingWarList(action)

    return self
end

function ModelMainMenu:doActionGetSceneWarData(action)
    getActorContinueGameSelector(self):getModel():doActionGetSceneWarData(action)

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
            showMenuItems(self, self.m_ItemNewGame, self.m_ItemContinue, self.m_ItemConfigSkills, self.m_ItemLogin)
        else
            showMenuItems(self, self.m_ItemLogin)
        end
    end

    return self
end

return ModelMainMenu
