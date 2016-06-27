
local ModelMainMenu = class("ModelMainMenu")

local Actor                 = require("global.actors.Actor")
local LocalizationFunctions = require("app.utilities.LocalizationFunctions")

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
        local actor = Actor.createWithModelAndViewName("sceneMain.ModelNewWarCreator", nil, "sceneMain.ViewNewWarCreator")
        actor:getModel():setModelMainMenu(self)
            :setEnabled(false)
            :setModelMessageIndicator(self.m_ModelMessageIndicator)
            :setRootScriptEventDispatcher(self.m_RootScriptEventDispatcher)

        self.m_ActorNewWarCreator = actor
        self.m_View:setViewNewWarCreator(actor:getView())
    end

    return self.m_ActorNewWarCreator
end

local function getActorContinueWarSelector(self)
    if (not self.m_ActorContinueWarSelector) then
        local actor = Actor.createWithModelAndViewName("sceneMain.ModelContinueWarSelector", nil, "sceneMain.ViewContinueWarSelector")
        actor:getModel():setModelMainMenu(self)
            :setEnabled(false)
            :setModelConfirmBox(self.m_ModelConfirmBox)
            :setRootScriptEventDispatcher(self.m_RootScriptEventDispatcher)

        self.m_ActorContinueWarSelector = actor
        self.m_View:setViewContinueWarSelector(actor:getView())
    end

    return self.m_ActorContinueWarSelector
end

local function getActorJoinWarSelector(self)
    if (not self.m_ActorJoinWarSelector) then
        local actor = Actor.createWithModelAndViewName("sceneMain.ModelJoinWarSelector", nil, "sceneMain.ViewJoinWarSelector")
        actor:getModel():setModelMainMenu(self)
            :setModelConfirmBox(self.m_ModelConfirmBox)
            :setModelMessageIndicator(self.m_ModelMessageIndicator)
            :setEnabled(false)
            :setRootScriptEventDispatcher(self.m_RootScriptEventDispatcher)

        self.m_ActorJoinWarSelector = actor
        self.m_View:setViewJoinWarSelector(actor:getView())
    end

    return self.m_ActorJoinWarSelector
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

local function getActorGameHelper(self)
    if (not self.m_ActorGameHelper) then
        local actor = Actor.createWithModelAndViewName("sceneMain.ModelGameHelper", nil, "sceneMain.ViewGameHelper")
        actor:getModel():setModelMainMenu(self)

        self.m_ActorGameHelper = actor
        self.m_View:setViewGameHelper(actor:getView())
    end

    return self.m_ActorGameHelper
end

--------------------------------------------------------------------------------
-- The composition menu items.
--------------------------------------------------------------------------------
local function initItemNewWar(self)
    local item = {
        name = LocalizationFunctions.getLocalizedText(2),
        callback = function()
            self:setMenuEnabled(false)
            getActorNewWarCreator(self):getModel():setEnabled(true)
        end,
    }

    self.m_ItemNewWar = item
end

local function initItemContinue(self)
    local item = {
        name     = LocalizationFunctions.getLocalizedText(3),
        callback = function()
            self:setMenuEnabled(false)
            getActorContinueWarSelector(self):getModel():setEnabled(true)
        end,
    }

    self.m_ItemContinue = item
end

local function initItemJoinWar(self)
    local item = {
        name     = LocalizationFunctions.getLocalizedText(4),
        callback = function()
            self:setMenuEnabled(false)
            getActorJoinWarSelector(self):getModel():setEnabled(true)
        end,
    }

    self.m_ItemJoinWar = item
end

local function initItemConfigSkills(self)
    local item = {
        name     = LocalizationFunctions.getLocalizedText(5),
        callback = function()
            self.m_ModelMessageIndicator:showMessage("Sorry, the Config Skills feature is not implemented.")
        end,
    }

    self.m_ItemConfigSkills = item
end

local function initItemLogin(self)
    local item = {
        name     = LocalizationFunctions.getLocalizedText(6),
        callback = function()
            self:setMenuEnabled(false)
            getActorLoginPanel(self):getModel():setEnabled(true)
        end,
    }

    self.m_ItemLogin = item
end

local function initItemHelp(self)
    local item = {
        name     = LocalizationFunctions.getLocalizedText(7),
        callback = function()
            self:setMenuEnabled(false)
            getActorGameHelper(self):getModel():setEnabled(true)
        end,
    }

    self.m_ItemHelp = item
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelMainMenu:ctor(param)
    initItemNewWar(      self)
    initItemContinue(    self)
    initItemJoinWar(     self)
    -- initItemConfigSkills(self)
    initItemLogin(       self)
    initItemHelp(        self)

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

    getActorLoginPanel(self):getModel():doActionLogin(action)

    return self
end

function ModelMainMenu:doActionRegister(action)
    self:updateWithIsPlayerLoggedIn(true)
        :setMenuEnabled(true)

    getActorLoginPanel(self):getModel():doActionRegister(action)

    return self
end

function ModelMainMenu:doActionNewWar(action)
    self.m_ActorNewWarCreator:getModel():setEnabled(false)
    self:setMenuEnabled(true)

    return self
end

function ModelMainMenu:doActionGetJoinableWarList(action)
    getActorJoinWarSelector(self):getModel():doActionGetJoinableWarList(action)
end

function ModelMainMenu:doActionJoinWar(action)
    getActorJoinWarSelector(self):getModel():doActionJoinWar(action)
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
            showMenuItems(self,
                self.m_ItemNewWar,
                self.m_ItemContinue,
                self.m_ItemJoinWar,
                -- self.m_ItemConfigSkills,
                self.m_ItemLogin,
                self.m_ItemHelp
            )
        else
            showMenuItems(self,
                self.m_ItemLogin,
                self.m_ItemHelp
            )
        end
    end

    return self
end

return ModelMainMenu
