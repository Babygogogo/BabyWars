
--[[--------------------------------------------------------------------------------
-- ComponentManager用于把component绑定到宿主上，以及提供相关的访问接口。
--
-- 主要职责：
--   绑定/解绑component
--   提供接口给外界访问component
--
-- 使用场景举例：
--   ModelTile和ModelUnit在初始化时，都会使用ComponentManager绑定相应的component。
--
-- 其他：
--   - 绑定component时，会占用宿主的component_域。因此宿主不应自行使用这个域。
--
--   - 绑定component时，不仅会把component的实例加入到component_域中，还会把component指定的方法直接绑定到宿主上。举例：
--     target = {}
--     ComponentExample = { EXPORT_METHOD = "someMethod", ...}
--     ComponentManager.bindComponent(target, ComponentExample)
--     这三句代码执行后，target就会自动具有一个名为someMethod的域（另外还有component_域，里面存放了一个ComponentExample的实例）。
--     之后，其他代码就可以直接调用target.someMethod，就好像target本来就具有这个域。
--
--   - ModelTile和ModelUnit都是component的重度使用者。可以通过更改GameConstant下的设定，改变它们所绑定的component，这也将直接影响它们的行为。
--
--   - 允许在任意时刻绑定/解绑component，但为了不增加理解难度，一般只在初始化时进行绑定或解绑。
--]]--------------------------------------------------------------------------------

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
