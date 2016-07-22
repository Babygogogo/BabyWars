
local MaterialOwner = require("src.global.functions.class")("MaterialOwner")

local ComponentManager   = require("src.global.components.ComponentManager")

local EXPORTED_METHODS = {
    "getCurrentMaterial",
    "getMaxMaterial",
    "isMaterialInShort",

    "setCurrentMaterial",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function MaterialOwner:ctor(param)
    self:loadTemplate(param.template)
        :loadInstantialData(param.instantialData)

    return self
end

function MaterialOwner:loadTemplate(template)
    self.m_Template = template

    return self
end

function MaterialOwner:loadInstantialData(data)
    self.m_CurrentMaterial = data.current

    return self
end

--------------------------------------------------------------------------------
-- The function for serialization.
--------------------------------------------------------------------------------
function MaterialOwner:toSerializableTable()
    local currentMaterial = self:getCurrentMaterial()
    if (currentMaterial == self:getMaxMaterial()) then
        return nil
    else
        return {
            current = currentMaterial,
        }
    end
end

--------------------------------------------------------------------------------
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function MaterialOwner:onBind(target)
    assert(self.m_Owner == nil, "MaterialOwner:onBind() the component has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Owner = target

    return self
end

function MaterialOwner:onUnbind()
    assert(self.m_Owner ~= nil, "MaterialOwner:onUnbind() the component has not bound to a target.")

    ComponentManager.unsetMethods(self.m_Owner, EXPORTED_METHODS)
    self.m_Owner = nil

    return self
end

--------------------------------------------------------------------------------
-- The functions for doing actions.
--------------------------------------------------------------------------------
function MaterialOwner:doActionJoinModelUnit(action, modelPlayerManager, target)
    target:setCurrentMaterial(math.min(
        target:getMaxMaterial(),
        self:getCurrentMaterial() + target:getCurrentMaterial()
    ))

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function MaterialOwner:getCurrentMaterial()
    return self.m_CurrentMaterial
end

function MaterialOwner:getMaxMaterial()
    return self.m_Template.max
end

function MaterialOwner:isMaterialInShort()
    return (self:getCurrentMaterial() / self:getMaxMaterial()) <= 0.4
end

function MaterialOwner:setCurrentMaterial(material)
    self.m_CurrentMaterial = material

    return self.m_Owner
end

return MaterialOwner
