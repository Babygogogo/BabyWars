
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
-- The composition new game creator actor.
--------------------------------------------------------------------------------
local function createActorNewGameCreator()
    return Actor.createWithModelAndViewName("ModelNewGameCreator", nil, "ViewNewGameCreator")
end

local function lazyInitWithActorNewGameCreator(self, actor)
    assert(self.m_View, "ModelMainMenu-lazyInitWithActorNewGameCreator() no view is attached to the owner actor of the model.")
    self.m_View:setViewNewGameCreator(actor:getView())

    actor:getModel():setModelMainMenu(self)
        :setEnabled(false)
    self.m_ActorNewGameCreator = actor
end

local function getActorNewGameCreator(self)
    if (not self.m_ActorNewGameCreator) then
        lazyInitWithActorNewGameCreator(self, createActorNewGameCreator())
    end

    return self.m_ActorNewGameCreator
end

--------------------------------------------------------------------------------
-- The composition continue game selector actor.
--------------------------------------------------------------------------------
local function createActorContinueGameSelector()
    return Actor.createWithModelAndViewName("ModelContinueGameSelector", nil, "ViewContinueGameSelector")
end

local function lazyInitWithActorContinueGameSelector(self, actor)
    assert(self.m_View, "ModelMainMenu-lazyInitWithActorContinueGameSelector() no view is attached to the owner actor of the model.")
    self.m_View:setViewContinueGameSelector(actor:getView())

    actor:getModel():setModelMainMenu(self)
        :setEnabled(false)
        :setModelConfirmBox(self.m_ModelConfirmBox)

    self.m_ActorContinueGameSelector = actor
end

local function getActorContinueGameSelector(self)
    if (not self.m_ActorContinueGameSelector) then
        lazyInitWithActorContinueGameSelector(self, createActorContinueGameSelector())
    end

    return self.m_ActorContinueGameSelector
end

--------------------------------------------------------------------------------
-- The composition login panel actor.
--------------------------------------------------------------------------------
local function createActorLoginPanel()
    return Actor.createWithModelAndViewName("ModelLoginPanel", nil, "ViewLoginPanel")
end

local function lazyInitWithActorLoginPanel(self, actor)
    assert(self.m_View, "ModelMainMenu-lazyInitWithActorLoginPanel() no view is attached to the owner actor of the model.")
    self.m_View:setViewLoginPanel(actor:getView())

    actor:getModel():setModelMainMenu(self)
        :setEnabled(false)
        :setRootScriptEventDispatcher(self.m_RootScriptEventDispatcher)

    self.m_ActorLoginPanel = actor
end

local function getActorLoginPanel(self)
    if (not self.m_ActorLoginPanel) then
        lazyInitWithActorLoginPanel(self, createActorLoginPanel())
    end

    return self.m_ActorLoginPanel
end

--------------------------------------------------------------------------------
-- The new game item.
--------------------------------------------------------------------------------
local function createItemNewGame(self)
    return {
        name = "New Game",
        callback = function()
            self:setMenuEnabled(false)
            getActorNewGameCreator(self):getModel():setEnabled(true)
        end,
    }
end

local function initWithItemNewGame(self, item)
    self.m_ItemNewGame = item
end

--------------------------------------------------------------------------------
-- The continue item.
--------------------------------------------------------------------------------
local function createItemContinue(self)
    return {
        name     = "Continue",
        callback = function()
            self:setMenuEnabled(false)
            getActorContinueGameSelector(self):getModel():setEnabled(true)
        end,
    }
end

local function initWithItemContinue(self, item)
    self.m_ItemContinue = item
end

--------------------------------------------------------------------------------
-- The config skills item.
--------------------------------------------------------------------------------
local function createItemConfigSkills(self)
    return {
        name = "Config Skills",
        callback = function()
            print("Config Skills is not implemented.")
        end,
    }
end

local function initWithItemConfigSkills(self, item)
    self.m_ItemConfigSkills = item
end

--------------------------------------------------------------------------------
-- The login item.
--------------------------------------------------------------------------------
local function createItemLogin(self)
    return {
        name = "Login",
        callback = function()
            self:setMenuEnabled(false)
            getActorLoginPanel(self):getModel():setEnabled(true)
        end,
    }
end

local function initWithItemLogin(self, item)
    self.m_ItemLogin = item
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelMainMenu:ctor(param)
    initWithItemNewGame(     self, createItemNewGame(self))
    initWithItemContinue(    self, createItemContinue(self))
    initWithItemConfigSkills(self, createItemConfigSkills(self))
    initWithItemLogin(       self, createItemLogin(self))

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelMainMenu:initView()
    local view = self.m_View
    assert(view, "ModelMainMenu:initView() no view is attached to the actor of the model.")

    view:removeAllItems()
        :createAndPushBackItem(self.m_ItemLogin)

    return self
end

function ModelMainMenu:setModelConfirmBox(model)
    assert(self.m_ModelConfirmBox == nil, "ModelMainMenu:setModelConfirmBox() the model has been set.")
    self.m_ModelConfirmBox = model

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
    if (action.isSuccessful) then
        showMenuItems(self, self.m_ItemNewGame, self.m_ItemContinue, self.m_ItemConfigSkills, self.m_ItemLogin)
        self:setMenuEnabled(true)
    end

    getActorLoginPanel(self)          :getModel():doActionLogin(action)
    getActorContinueGameSelector(self):getModel():doActionLogin(action)

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

return ModelMainMenu
