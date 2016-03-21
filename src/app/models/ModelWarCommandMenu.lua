
local ModelWarCommandMenu = class("ModelWarCommandMenu")

local Actor            = require("global.actors.Actor")
local TypeChecker      = require("app.utilities.TypeChecker")

--------------------------------------------------------------------------------
-- The confirm box actor.
--------------------------------------------------------------------------------
local function createConfirmBoxActor()
    local boxModel = require("app.models.ModelConfirmBox"):create()
    boxModel:setOnConfirmNo(function()
            boxModel:setEnabled(false)
        end)

        :setOnConfirmCancel(function()
            boxModel:setEnabled(false)
        end)

    return Actor.createWithModelAndViewInstance(boxModel, require("app.views.ViewConfirmBox"):create())
end

local function initWithConfirmBoxActor(model, actor)
    model.m_ConfirmBoxActor = actor
    actor:getModel():setEnabled(false)
end

--------------------------------------------------------------------------------
-- The quit war menu item.
--------------------------------------------------------------------------------
local function createQuitWarItem(model)
    local item = {}

    item.onPlayerTouch = function(self)
        local confirmBoxModel = model.m_ConfirmBoxActor:getModel()
        confirmBoxModel:setConfirmText("You are quitting the war (you may reenter it later).\nAre you sure?")

            :setOnConfirmYes(function()
                local mainSceneActor = Actor.createWithModelAndViewName("ModelSceneMain", nil, "ViewSceneMain")
                assert(mainSceneActor, "ModelWarCommandMenu-onQuitWarItemConfirmYes() failed to create a main scene actor.")
                require("global.actors.ActorManager").setAndRunRootActor(mainSceneActor, "FADE", 1)
            end)

            :setEnabled(true)
    end

    item.getTitleText = function(self)
        return "Quit"
    end

    return item
end

local function initWithQuitWarItem(model, item)
    model.m_QuitWarItem = item
end

--------------------------------------------------------------------------------
-- The end turn menu item.
--------------------------------------------------------------------------------
local function createEndTurnItem(model)
    local item = {}

    item.onPlayerTouch = function(self)
        local confirmBoxModel = model.m_ConfirmBoxActor:getModel()
        confirmBoxModel:setConfirmText("You are ending your turn, with some units unactioned.\nAre you sure?")

            :setOnConfirmYes(function()
                confirmBoxModel:setEnabled(false)
                model:setEnabled(false)
                model.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtPlayerRequestEndTurn"})
            end)

            :setEnabled(true)
    end

    item.getTitleText = function(self)
        return "End Turn"
    end

    return item
end

local function initWithEndTurnItem(model, item)
    model.m_EndTurnItem = item
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelWarCommandMenu:ctor(param)
    initWithConfirmBoxActor(self, createConfirmBoxActor())

    initWithQuitWarItem(self, createQuitWarItem(self))
    initWithEndTurnItem(self, createEndTurnItem(self))

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelWarCommandMenu:initView()
    local view = self.m_View
    assert(view, "ModelWarCommandMenu:initView() no view is attached to the actor of the model.")

    view:setConfirmBoxView(self.m_ConfirmBoxActor:getView())

        :removeAllItems()
        :createAndPushBackItemView(self.m_QuitWarItem)
        :createAndPushBackItemView(self.m_EndTurnItem)

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node/script events.
--------------------------------------------------------------------------------
function ModelWarCommandMenu:onEnter(rootActor)
    self.m_RootScriptEventDispatcher = rootActor:getModel():getScriptEventDispatcher()
end

function ModelWarCommandMenu:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher = nil
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelWarCommandMenu:setEnabled(enabled)
    if (self.m_View) then
        self.m_View:setEnabled(enabled)
    end

    return self
end

return ModelWarCommandMenu
