
local ComponentManager = {}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function isItemInList(item, list)
    for _, listItem in ipairs(list) do
        if (item == listItem) then
            return true
        end
    end

    return false
end

local function loadComponentClass(componentName)
    assert(type(componentName) == "string", string.format("ComponentManager--loadComponentClass() invalid component name \"%s\"", tostring(componentName)))

    local cls = require("app.components." .. componentName)
    assert(cls, string.format("ComponentManager--loadComponentClass() component \"%s\" load failed", componentName))

--[[
    if DEBUG > 1 then
        printInfo("ComponentManager--loadComponentClass() succeed loading \"%s\" ", componentName)
    end
--]]
    return cls
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ComponentManager.bindComponent(target, componentName, initParam)
    target.components_ = target.components_ or {}
    assert(target.components_[componentName] == nil, string.format("ComponentManager.bindComponent() the target has already bound a %s", componentName))

    local componentClass = loadComponentClass(componentName)
    for _, depend in ipairs(componentClass.DEPENDS or {}) do
        if (target.components_[depend] == nil) then
            Component.bindComponent(target, depend)
        end
    end

    local component = componentClass:create(initParam)
    target.components_[componentName] = component
    component:onBind(target)

    return ComponentManager
end

function ComponentManager.unbindComponent(target, componentName)
    assert(target.components_[componentName] ~= nil, "ComponentManager.unbindComponent() the target has no component named %s.", componentName)

    target.components_[componentName]:onUnbind()
    target.components_[componentName] = nil

    return ComponentManager
end

function ComponentManager.unbindAllComponentsExceptFor(target, ...)
    local components = target.components_
    if (components == nil) then
        return ComponentManager
    end

    local exceptions = {...}
    for name, component in pairs(components) do
        if (not isItemInList(name, exceptions)) then
            ComponentManager.unbindComponent(target, name)
        end
    end

    return ComponentManager
end

function ComponentManager.unbindAllComponents(target)
    local components = target.components_
    if (components == nil) then
        return ComponentManager
    end

    for name, component in pairs(components) do
        ComponentManager.unbindComponent(target, name)
    end

    return ComponentManager
end

function ComponentManager.getComponent(target, componentName)
    if (target.components_ == nil) then
        return nil
    else
        return target.components_[componentName]
    end
end

function ComponentManager.getAllComponents(target)
    return target.components_
end

function ComponentManager.setMethods(target, component, methods)
    for _, name in ipairs(methods) do
        assert(target[name] == nil, "ComponentManager.setMethods() the target already has a field named " .. name)
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
