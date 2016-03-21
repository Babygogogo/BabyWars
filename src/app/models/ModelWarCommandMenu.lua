
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
-- The quit war menu item actor.
--------------------------------------------------------------------------------
local function createQuitWarActor()
    local quitWarActor = Actor.createWithModelAndViewName("ModelMenuItemQuitWar", nil, "ViewWarCommandMenuItem")
    assert(quitWarActor, "ModelWarCommandMenu-createChildrenActors() failed to create a QuitWar actor.")

    return quitWarActor
end

local function initWithQuitWarActor(model, actor)
    model.m_QuitWarActor = actor
end

local function onQuitWarItemConfirmYes()
    local mainSceneActor = Actor.createWithModelAndViewName("ModelSceneMain", nil, "ViewSceneMain")
    assert(mainSceneActor, "ModelMenuItemQuitWar-onConfirmYes() failed to create a main scene actor.")
    require("global.actors.ActorManager").setAndRunRootActor(mainSceneActor, "FADE", 1)
end

local function createQuitWarItem(model)
    local item = {}

    item.onPlayerTouch = function(self)
        local confirmBoxModel = model.m_ConfirmBoxActor:getModel()
        confirmBoxModel:setConfirmText("You are quitting the war (you may reenter it later).\nAre you sure?")
            :setOnConfirmYes(onQuitWarItemConfirmYes)
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
-- The constructor.
--------------------------------------------------------------------------------
function ModelWarCommandMenu:ctor(param)
    initWithQuitWarActor(self, createQuitWarActor())
--[[
    initWithConfirmBoxActor(self, createConfirmBoxActor())

    initWithQuitWarItem(self, createQuitWarItem(self))

    if (self.m_View) then
        self:initView()
    end
]]
    return self
end

function ModelWarCommandMenu:initView()
    local view = self.m_View
    assert(view, "ModelWarCommandMenu:initView() no view is attached to the actor of the model.")

    view:removeAllItems()
        :pushBackItemView(self.m_QuitWarActor:getView())
--[[
    view:setConfirmBoxView(self.m_ConfirmBoxActor:getView())

        :removeAllItems()
        :pushBackItemView(view:createItemView(self.m_QuitWarItem))
]]
    return self
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
