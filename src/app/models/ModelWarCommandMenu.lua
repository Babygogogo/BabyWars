
local ModelWarCommandMenu = class("ModelWarCommandMenu")

local Actor            = require("global.actors.Actor")
local TypeChecker      = require("app.utilities.TypeChecker")

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

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelWarCommandMenu:ctor(param)
    initWithQuitWarActor(self, createQuitWarActor())

	return self
end

function ModelWarCommandMenu:initView()
    local view = self.m_View
	assert(view, "ModelWarCommandMenu:initView() no view is attached to the actor of the model.")

    view:removeAllItems()
        :pushBackItem(self.m_QuitWarActor:getView())

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
