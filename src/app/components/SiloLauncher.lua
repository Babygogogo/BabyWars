
local SiloLauncher = requireBW("src.global.functions.class")("SiloLauncher")

local ComponentManager      = requireBW("src.global.components.ComponentManager")
local GridIndexFunctions    = requireBW("src.app.utilities.GridIndexFunctions")
local GameConstantFunctions = requireBW("src.app.utilities.GameConstantFunctions")

SiloLauncher.EXPORTED_METHODS = {
    "canLaunchSiloOnTileType",
    "getTileObjectIdAfterLaunch",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function SiloLauncher:ctor(param)
    self:loadTemplate(param.template)
        :loadInstantialData(param.instantialData)

    return self
end

function SiloLauncher:loadTemplate(template)
    self.m_Template = template
    return self
end

function SiloLauncher:loadInstantialData(data)
    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function SiloLauncher:canLaunchSiloOnTileType(tileType)
    return self.m_Template.targetType == tileType
end

function SiloLauncher:getTileObjectIdAfterLaunch()
    return GameConstantFunctions.getTiledIdWithTileOrUnitName(self.m_Template.launchedType)
end

return SiloLauncher
