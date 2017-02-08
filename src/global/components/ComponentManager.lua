
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
--     ComponentExample = { EXPORTED_METHODS = "someMethod", ...}
--     ComponentManager.bindComponent(target, ComponentExample)
--     这三句代码执行后，target就会自动具有一个名为someMethod的域（另外还有component_域，里面存放了一个ComponentExample的实例）。
--     之后，其他代码就可以直接调用target.someMethod，就好像target本来就具有这个域。
--
--   - ModelTile和ModelUnit都是component的重度使用者。可以通过更改GameConstant下的设定，改变它们所绑定的component，这也将直接影响它们的行为。
--
--   - 允许在任意时刻绑定/解绑component，但为了不增加理解难度，一般只在初始化时进行绑定或解绑。
--]]--------------------------------------------------------------------------------

local ComponentManager = {}

local COMPONENT_PATH = "src.app.components."

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function loadComponentClass(componentName)
    local cls = requireBW(COMPONENT_PATH .. componentName)
    assert(cls, string.format("ComponentManager--loadComponentClass() component \"%s\" load failed", componentName))

    return cls
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ComponentManager.bindComponent(owner, componentName, initParam)
    owner.components_ = owner.components_ or {}
    assert(not ComponentManager.getComponent(owner, componentName), string.format("ComponentManager.bindComponent() the owner has already bound a %s", componentName))

    local componentClass = loadComponentClass(componentName)
    for _, depend in ipairs(componentClass.DEPENDS or {}) do
        if (not ComponentManager.getComponent(owner, depend)) then
            ComponentManager.bindComponent(owner, depend)
        end
    end

    local component = componentClass:create(initParam)
    component.m_Owner = owner
    ComponentManager.setMethods(owner, component, componentClass.EXPORTED_METHODS)
    owner.components_[componentName] = component

    if (component.onBind) then
        component:onBind()
    end

    return ComponentManager
end

function ComponentManager.unbindComponent(owner, componentName)
    local component = ComponentManager.getComponent(owner, componentName)
    assert(component ~= nil, "ComponentManager.unbindComponent() the owner has no component named %s.", componentName)

    if (component.onUnbind) then
        component:onUnbind()
    end

    owner.components_[componentName] = nil
    ComponentManager.unsetMethods(owner, loadComponentClass(componentName).EXPORTED_METHODS)
    component.m_Owner = nil

    return ComponentManager
end

function ComponentManager.unbindAllComponents(owner)
    local components = owner.components_
    if (components == nil) then
        return ComponentManager
    end

    for name, component in pairs(components) do
        ComponentManager.unbindComponent(owner, name)
    end

    return ComponentManager
end

function ComponentManager.getComponent(owner, componentName)
    if (owner.components_ == nil) then
        return nil
    else
        return owner.components_[componentName]
    end
end

function ComponentManager.getAllComponents(owner)
    return owner.components_
end

function ComponentManager.callMethodForAllComponents(owner, methodName, ...)
    for _, component in pairs(ComponentManager.getAllComponents(owner)) do
        if (component[methodName]) then
            component[methodName](component, ...)
        end
    end

    return ComponentManager
end

function ComponentManager.setMethods(owner, component, methodNames)
    for _, name in ipairs(methodNames) do
        assert(owner[name] == nil,
            "ComponentManager.setMethods() the owner already has a field named " .. name)
        assert(type(component[name]) == "function",
            "ComponentManager.setMethods() the field named " .. name .. " of the component is not a function.")

        owner[name] = function(__, ...)
            return component[name](component, ...)
        end
    end

    return ComponentManager
end

function ComponentManager.unsetMethods(owner, methodNames)
    for _, name in ipairs(methodNames) do
        owner[name] = nil
    end

    return ComponentManager
end

return ComponentManager
