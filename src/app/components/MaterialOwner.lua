
local MaterialOwner = requireBW("src.global.functions.class")("MaterialOwner")

local ComponentManager   = requireBW("src.global.components.ComponentManager")

MaterialOwner.EXPORTED_METHODS = {
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
