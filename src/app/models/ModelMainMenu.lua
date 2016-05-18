
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

local function initWithActorNewGameCreator(self, actor)
    actor:getModel():setModelMainMenu(self)
        :setEnabled(false)
    self.m_ActorNewGameCreator = actor
end

--------------------------------------------------------------------------------
-- The composition continue game selector actor.
--------------------------------------------------------------------------------
local function createActorContinueGameSelector()
    return Actor.createWithModelAndViewName("ModelContinueGameSelector", nil, "ViewContinueGameSelector")
end

local function initWithActorContinueGameSelector(self, actor)
    actor:getModel():setModelMainMenu(self)
        :setEnabled(false)
        :setModelConfirmBox(self.m_ModelConfirmBox)

    self.m_ActorContinueGameSelector = actor
end

--------------------------------------------------------------------------------
-- The composition login panel actor.
--------------------------------------------------------------------------------
local function createActorLoginPanel()
    return Actor.createWithModelAndViewName("ModelLoginPanel", nil, "ViewLoginPanel")
end

local function initWithActorLoginPanel(self, actor)
    actor:getModel():setModelMainMenu(self)
        :setEnabled(false)
        :setRootScriptEventDispatcher(self.m_RootScriptEventDispatcher)

    self.m_ActorLoginPanel = actor
end

--------------------------------------------------------------------------------
-- The new game item.
--------------------------------------------------------------------------------
local function createItemNewGame(self)
    return {
        name = "New Game",
        callback = function()
            if (self.m_ActorNewGameCreator == nil) then
                initWithActorNewGameCreator(self, createActorNewGameCreator())
                if (self.m_View) then
                    self.m_View:setViewNewGameCreator(self.m_ActorNewGameCreator:getView())
                end
            end

            self:setMenuEnabled(false)
            self.m_ActorNewGameCreator:getModel():setEnabled(true)
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
            if (self.m_ActorContinueGameSelector == nil) then
                initWithActorContinueGameSelector(self, createActorContinueGameSelector())
                if (self.m_View) then
                    self.m_View:setViewWarList(self.m_ActorContinueGameSelector:getView())
                end
            end

            self:setMenuEnabled(false)
            self.m_ActorContinueGameSelector:getModel():setEnabled(true)
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
            if (not self.m_ActorLoginPanel) then
                initWithActorLoginPanel(self, createActorLoginPanel())
                if (self.m_View) then
                    self.m_View:setViewLoginPanel(self.m_ActorLoginPanel:getView())
                end
            end

            self:setMenuEnabled(false)
            self.m_ActorLoginPanel:getModel():setEnabled(true)
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

    self.m_ActorLoginPanel:getModel():doActionLogin(action)
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
