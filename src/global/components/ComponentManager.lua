
local ComponentManager = {}

local registeredComponentClasses = {}

local function loadComponentClass_(componentName)
	assert(type(componentName) == "string", string.format("ComponentManager--loadComponentClass_() invalid component name \"%s\"", tostring(componentName)))

	local cls = require("app.components." .. componentName)
	assert(cls, string.format("ComponentManager--loadComponentClass_() component \"%s\" load failed", componentName))

	if DEBUG > 1 then
		printInfo("ComponentManager--loadComponentClass_() succeed loading \"%s\" ", componentName)
	end

	return cls
end

local function loadComponentClasses_(componentNames)
	local loadedComponents = {}
	for _, name in ipairs(componentNames) do
		registeredComponentClasses[name] = registeredComponentClasses[name] or loadComponentClass_(name)
		assert(registeredComponentClasses[name], string.format("ComponentManager--loadComponentClasses_() failed to load %s", name))

		loadedComponents[#loadedComponents + 1] = registeredComponentClasses[name]
	end

	return loadedComponents
end

local function validateTargetType_(target)
	local t = type(target)
	if t == "table" or t == "userdata" then
		return true
	else
		error(string.format("ComponentManager--validataTargetType() invalid type %s, table or userdata expected", t))
	end
end

function ComponentManager.bindComponent(target, ...)
	if not validateTargetType_(target) then return ComponentManager end

	target.components_ = target.components_ or {}

	local names = {...}
	for i, componentClass in ipairs(loadComponentClasses_(names)) do
		local name = names[i]
		assert(target.components_[name] == nil, string.format("ComponentManager:bindComponent() the target already has bind a %s", name))

		for __, depend in ipairs(componentClass.depends or {}) do
			if target.components_[depend] == nil then
				Component.bindComponent(target, depend)
			end
		end

		local component = componentClass:create()
		target.components_[name] = component
		component:bind(target)
	end

	return ComponentManager
end

function ComponentManager.unbindComponent(target, ...)
	if not target.components_ then return ComponentManager end

	for _, name in ipairs({...}) do
		assert(type(name) == "string" and name ~= "", string.format("ComponentManager.unbindComponent() invalid component name \"%s\"", tostring(name)))

		local component = target.components_[name]
		assert(component, string.format("ComponentManager.unbindComponent() component \"%s\" not found in target", tostring(name)))

		component:unbind(target)
		target.components_[name] = nil
	end

	return ComponentManager
end

function ComponentManager.unbindAllComponents(target)
	for name, component in pairs(target.components_) do
		component:unbind(target)
		target.components_[name] = nil
	end
end

function ComponentManager.getComponent(target, componentName)
	if (target.components_ == nil) then
		return nil
	else
		return target.components_[componentName]
	end
end

function ComponentManager.hasBound(target, componentName)
	if (target.components_ == nil) then
		return false
	end
	
	return target.components_[componentName] ~= nil
end

function ComponentManager.setMethods(target, component, methods)
	for _, name in ipairs(methods) do
		assert(target[name] == nil, "ComponentManager.setMethods() the target already has a field " .. name)
		target[name] = function(__, ...)
			return component[name](component, ...)
		end
	end

	return ComponentManager
end

function ComponentManager.unsetMethods(target, methods)
	for _, name in ipairs(methods) do
		target[name] = nil
	end

	return ComponentManager
end

return ComponentManager
