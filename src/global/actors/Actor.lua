
local Actor = class("Actor")

local ComponentManager = require("global.components.ComponentManager")

function Actor.createModel(name, param)
    if (not name) then
        return nil
    else
        local model, createModelMsg = require("app.models." .. name).createInstance(param)
        if (not model) then
            error("Actor--createModel() failed: " .. createModelMsg)
        else
            return model
        end
    end
end

function Actor.createView(name, param)
    if (not name) then
        return nil
    else
        local view, createViewMsg = require("app.views." .. name).createInstance(param)
        if (not view) then
            error("Actor--createView() failed: ".. createViewMsg)
        else
            return view
        end
    end
end

function Actor.createWithModelAndViewInstance(modelInstance, viewInstance)
	local actor = Actor.new()
	if (modelInstance) then actor:setModel(modelInstance) end
	if (viewInstance)  then actor:setView( viewInstance)  end

	return actor
end

function Actor.createWithModelAndViewName(modelName, modelParam, viewName, viewParam)
    local model = Actor.createModel(modelName, modelParam)
    local view  = Actor.createView( viewName,  viewParam)

	return Actor.createWithModelAndViewInstance(model, view)
end

--[[
function Actor:destroy()
    self:destroyView()
        :destroyModel()
--        :unbindAllComponents()

    return self
end
--]]

function Actor:onEnter(rootActor)
    if (self.m_Model and self.m_Model.onEnter) then
        self.m_Model:onEnter(rootActor)
    end
    if (self.m_View and self.m_View.onEnter) then
        self.m_View:onEnter(rootActor)
    end

    return self
end

function Actor:onCleanup(rootActor)
    if (self.m_Model and self.m_Model.onCleanup) then
        self.m_Model:onCleanup(rootActor)
    end
    if (self.m_View and self.m_View.onCleanup) then
        self.m_View:onCleanup(rootActor)
    end

    return self
end

function Actor:setView(view)
	assert(iskindof(view, "cc.Node"), "Actor:setView() the param view is not a kind of cc.Node.")
	assert(view.m_Actor == nil, "Actor:setView() the param view already has an owner actor.")
	assert(self.m_View == nil, "Actor:setView() the actor already has a view.")

	local model = self.m_Model
	view.m_Model = model
	if (model) then
		model.m_View = view
		if (model.initView) then model:initView() end
	end

	self.m_View = view
	view.m_Actor = self

	return self
end

function Actor:getView()
	return self.m_View
end

function Actor:removeView()
	local view = self.m_View
	if (view) then
		local model = self.m_Model
		if (model) then model.m_View = nil end

		view.m_Model, view.m_Actor = nil, nil
		self.m_View = nil
	end

	return self
end

--[[
function Actor:destroyView()
    local view = self:getView()
    if (view) then
        self:removeView()
        if (view.onCleanup) then
            view:onCleanup()
        end
    end

    return self
end
--]]

function Actor:setModel(model)
	assert(type(model) == "table", "Actor:setModel() the param model is not a table.")
	assert(model.m_Actor == nil, "Actor:setModel() the param model already has an owner actor.")
	assert(self.m_Model == nil, "Actor:setModel() the actor already has a model.")

	local view = self.m_View
	model.m_View = view
	if (view) then
		view.m_Model = model
		if (model.initView) then model:initView() end
	end

	self.m_Model = model
	model.m_Actor = self

	return self
end

function Actor:getModel()
	return self.m_Model
end

function Actor:removeModel()
	local model = self.m_Model
	if (model) then
		local view = self.m_View
		if (view) then view.m_Model = nil end

		model.m_View, model.m_Actor = nil, nil
		self.m_Model = nil
	end

	return self
end

--[[
function Actor:destroyModel()
    local model = self:getModel()
    if (model) then
        self:removeModel()
        if (model.onCleanup) then
            model:onCleanup()
        end
    end

    return self
end
--]]

--[[
function Actor:bindComponent(...)
	ComponentManager.bindComponent(self, ...)

	return self
end

function Actor:unbindComponent(...)
	ComponentManager.unbindComponent(self, ...)

	return self
end

function Actor:unbindAllComponents()
	ComponentManager.unbindAllComponents(self)

	return self
end

function Actor:hasBound(componentName)
	return ComponentManager.hasBinded(self, componentName)
end

function Actor:getComponent(componentName)
	return ComponentManager.getComponent(self, componentName)
end
--]]

return Actor
