
local ModelWarCommandMenu = class("ModelWarCommandMenu")

local Actor            = require("global.actors.Actor")
local TypeChecker      = require("app.utilities.TypeChecker")

local function createChildrenActors(param)
    local quitWarActor = Actor.createWithModelAndViewName("ModelMenuItemQuitWar", nil, "ViewWarCommandMenuItem")
    assert(quitWarActor, "ModelWarCommandMenu-createChildrenActors() failed to create a QuitWar actor.")
    
    return {quitWarActor = quitWarActor}
end

local function initWithChildrenActors(model, actors)
    model.m_QuitWarActor = actors.quitWarActor
end

function ModelWarCommandMenu:ctor(param)
    initWithChildrenActors(self, createChildrenActors())
    
    if (param) then
        self:load(param)
    end

	return self
end

function ModelWarCommandMenu:load(param)
	return self
end

function ModelWarCommandMenu.createInstance(param)
	local list = ModelWarCommandMenu.new():load(param)
    assert(list, "ModelWarCommandMenu.createInstance() failed.")

	return list
end

function ModelWarCommandMenu:initView()
    local view = self.m_View
	assert(view, "ModelWarCommandMenu:initView() no view is attached to the actor of the model.")
    
    view:removeAllItems()
        :pushBackItem(self.m_QuitWarActor:getView())
    
    return self
end

function ModelWarCommandMenu:setEnabled(enabled)
    if (self.m_View) then
        self.m_View:setEnabled(enabled)
    end
    
    return self
end

return ModelWarCommandMenu
