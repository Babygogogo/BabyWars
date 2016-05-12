
local ModelMainMenu = class("ModelMainMenu")

local Actor = require("global.actors.Actor")

--------------------------------------------------------------------------------
-- The new game item.
--------------------------------------------------------------------------------
local function createItemNewGame(self)
    return {
        name = "New Game",
        callback = function()
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
            self:setMenuEnabled(false)
            self.m_ActorWarList:getModel():setEnabled(true)
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
-- The composition war list actor.
--------------------------------------------------------------------------------
local function createActorWarList(mapListData)
    return Actor.createWithModelAndViewName("ModelWarList", mapListData, "ViewWarList", mapListData)
end

local function initWithActorWarList(self, actor)
    actor:getModel():setModelMainMenu(self)
        :setEnabled(false)
    self.m_ActorWarList = actor
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelMainMenu:ctor(param)
    initWithItemNewGame(        self, createItemNewGame(self))
    initWithItemContinue(       self, createItemContinue(self))
    initWithItemConfigSkills(   self, createItemConfigSkills(self))
    initWithActorNewGameCreator(self, createActorNewGameCreator())
    initWithActorWarList(       self, createActorWarList("WarSceneList"))

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelMainMenu:initView()
    local view = self.m_View
    assert(view, "ModelMainMenu:initView() no view is attached to the actor of the model.")

    view:setViewNewGameCreator(self.m_ActorNewGameCreator:getView())
        :setViewWarList(       self.m_ActorWarList:getView())

        :removeAllItems()
        :createAndPushBackItem(self.m_ItemNewGame)
        :createAndPushBackItem(self.m_ItemContinue)
        :createAndPushBackItem(self.m_ItemConfigSkills)

    return self
end

function ModelMainMenu:setModelConfirmBox(model)
    assert(self.m_ModelConfirmBox == nil, "ModelMainMenu:setModelConfirmBox() the model has been set.")
    self.m_ModelConfirmBox = model
    self.m_ActorWarList:getModel():setModelConfirmBox(model)

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
