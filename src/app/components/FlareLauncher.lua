
local FlareLauncher = require("src.global.functions.class")("FlareLauncher")

FlareLauncher.EXPORTED_METHODS = {
    "getFlareAreaRadius",
    "getMaxFlareRange",
    "getMaxFlareAmmo",
    "getCurrentFlareAmmo",
    "setCurrentFlareAmmo",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function FlareLauncher:ctor(param)
    self:loadTemplate(param.template)
        :loadInstantialData(param.instantialData)

    return self
end

function FlareLauncher:loadTemplate(template)
    self.m_Template = template

    return self
end

function FlareLauncher:loadInstantialData(data)
    self.m_CurrentAmmo = data.currentAmmo

    return self
end

--------------------------------------------------------------------------------
-- The functions for serialization.
--------------------------------------------------------------------------------
function FlareLauncher:toSerializableTable()
    local currentAmmo = self:getCurrentFlareAmmo()
    if (currentAmmo == self:getMaxFlareAmmo()) then
        return nil
    else
        return {currentAmmo = currentAmmo}
    end
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function FlareLauncher:getFlareAreaRadius()
    return self.m_Template.areaRadius
end

function FlareLauncher:getMaxFlareRange()
    return self.m_Template.maxRange
end

function FlareLauncher:getMaxFlareAmmo()
    return self.m_Template.maxAmmo
end

function FlareLauncher:getCurrentFlareAmmo()
    return self.m_CurrentAmmo
end

function FlareLauncher:setCurrentFlareAmmo(ammo)
    self.m_CurrentAmmo = ammo

    return self.m_Owner
end

return FlareLauncher
