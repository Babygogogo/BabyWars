
local ModelMainMenu = class("ModelMainMenu")

local AudioManager          = require("src.app.utilities.AudioManager")
local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")
local SingletonGetters      = require("src.app.utilities.SingletonGetters")
local Actor                 = require("src.global.actors.Actor")

local getLocalizedText = LocalizationFunctions.getLocalizedText

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

        self.m_ActorContinueWarSelector = actor
        self.m_View:setViewContinueWarSelector(actor:getView())
    end

    return self.m_ActorContinueWarSelector
end

local function getActorJoinWarSelector(self)
    if (not self.m_ActorJoinWarSelector) then
        local actor = Actor.createWithModelAndViewName("sceneMain.ModelJoinWarSelector", nil, "sceneMain.ViewJoinWarSelector")
        actor:getModel():setModelMainMenu(self)
            :setEnabled(false)

        self.m_ActorJoinWarSelector = actor
        self.m_View:setViewJoinWarSelector(actor:getView())
    end

    return self.m_ActorJoinWarSelector
end

local function getActorSkillConfigurator(self)
    if (not self.m_ActorSkillConfigurator) then
        local actor = Actor.createWithModelAndViewName("sceneMain.ModelSkillConfigurator", nil, "sceneMain.ViewSkillConfigurator")
        actor:getModel():setModelMainMenu(self)
            :setEnabled(false)

        self.m_ActorSkillConfigurator = actor
        self.m_View:setViewSkillConfigurator(actor:getView())
    end

    return self.m_ActorSkillConfigurator
end

local function getActorReplayManager(self)
    if (not self.m_ActorReplayManager) then
        local actor = Actor.createWithModelAndViewName("sceneMain.ModelReplayManager", nil, "sceneMain.ViewReplayManager")
        actor:getModel():setEnabled(false)

        self.m_ActorReplayManager = actor
        self.m_View:setViewReplayManager(actor:getView())
    end

    return self.m_ActorReplayManager
end

local function getActorLoginPanel(self)
    if (not self.m_ActorLoginPanel) then
        local actor = Actor.createWithModelAndViewName("sceneMain.ModelLoginPanel", nil, "sceneMain.ViewLoginPanel")
        actor:getModel():setModelMainMenu(self)
            :setEnabled(false)

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
        name     = getLocalizedText(1, "NewGame"),
        callback = function()
            self:setMenuEnabled(false)
                :getModelNewWarCreator():setEnabled(true)
        end,
    }

    self.m_ItemNewWar = item
end

local function initItemContinue(self)
    local item = {
        name     = getLocalizedText(1, "Continue"),
        callback = function()
            self:setMenuEnabled(false)
            getActorContinueWarSelector(self):getModel():setEnabled(true)
        end,
    }

    self.m_ItemContinue = item
end

local function initItemJoinWar(self)
    local item = {
        name     = getLocalizedText(1, "JoinWar"),
        callback = function()
            self:setMenuEnabled(false)
                :getModelJoinWarSelector():setEnabled(true)
        end,
    }

    self.m_ItemJoinWar = item
end

local function initItemConfigSkills(self)
    local item = {
        name     = getLocalizedText(1, "ConfigSkills"),
        callback = function()
            self:setMenuEnabled(false)
                :getModelSkillConfigurator():setEnabled(true)
        end,
    }

    self.m_ItemConfigSkills = item
end

local function initItemManageReplay(self)
    local item = {
        name     = getLocalizedText(1, "ManageReplay"),
        callback = function()
            self:setMenuEnabled(false)
                :getModelReplayManager():setEnabled(true)
        end,
    }

    self.m_ItemManageReplay = item
end

local function initItemLogin(self)
    local item = {
        name     = getLocalizedText(1, "Login"),
        callback = function()
            self:setMenuEnabled(false)
                :getModelLoginPanel():setEnabled(true)
        end,
    }

    self.m_ItemLogin = item
end

local function initItemSetMessageIndicator(self)
    local item = {
        name     = getLocalizedText(1, "SetMessageIndicator"),
        callback = function()
            local indicator = SingletonGetters.getModelMessageIndicator()
            indicator:setEnabled(not indicator:isEnabled())
        end,
    }

    self.m_ItemSetMessageIndicator = item
end

local function initItemSetMusic(self)
    local item = {
        name = getLocalizedText(1, "SetMusic"),
        callback = function()
            local isEnabled = not AudioManager.isEnabled()
            AudioManager.setEnabled(isEnabled)
            if (isEnabled) then
                AudioManager.playMainMusic()
            end
        end,
    }

    self.m_ItemSetMusic = item
end

local function initItemHelp(self)
    local item = {
        name     = getLocalizedText(1, "Help"),
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
    initItemNewWar(             self)
    initItemContinue(           self)
    initItemJoinWar(            self)
    initItemConfigSkills(       self)
    initItemManageReplay(       self)
    initItemLogin(              self)
    initItemSetMessageIndicator(self)
    initItemSetMusic(           self)
    initItemHelp(               self)

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

--------------------------------------------------------------------------------
-- The public functions for doing actions.
--------------------------------------------------------------------------------
function ModelMainMenu:doActionNewWar(action)
    self.m_ActorNewWarCreator:getModel():setEnabled(false)
    self:setMenuEnabled(true)

    return self
end

function ModelMainMenu:doActionGetJoinableWarList(action)
    self:getModelJoinWarSelector():doActionGetJoinableWarList(action)
end

function ModelMainMenu:doActionJoinWar(action)
    self:getModelJoinWarSelector():doActionJoinWar(action)
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
                self.m_ItemConfigSkills,
                self.m_ItemManageReplay,
                self.m_ItemLogin,
                self.m_ItemSetMessageIndicator,
                self.m_ItemSetMusic,
                self.m_ItemHelp
            )
        else
            showMenuItems(self,
                self.m_ItemManageReplay,
                self.m_ItemLogin,
                self.m_ItemSetMessageIndicator,
                self.m_ItemSetMusic,
                self.m_ItemHelp
            )
        end
    end

    return self
end

function ModelMainMenu:onButtonExitTouched()
    SingletonGetters.getModelConfirmBox():setConfirmText(getLocalizedText(66, "ExitGame"))
        :setOnConfirmYes(function()
            cc.Director:getInstance():endToLua()
        end)
        :setEnabled(true)
end

function ModelMainMenu:getModelJoinWarSelector()
    return getActorJoinWarSelector(self):getModel()
end

function ModelMainMenu:getModelLoginPanel()
    return getActorLoginPanel(self):getModel()
end

function ModelMainMenu:getModelNewWarCreator()
    return getActorNewWarCreator(self):getModel()
end

function ModelMainMenu:getModelReplayManager()
    return getActorReplayManager(self):getModel()
end

function ModelMainMenu:getModelSkillConfigurator()
    return getActorSkillConfigurator(self):getModel()
end

return ModelMainMenu
