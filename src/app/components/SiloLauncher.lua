
local SiloLauncher = require("src.global.functions.class")("SiloLauncher")

local ComponentManager      = require("src.global.components.ComponentManager")
local GridIndexFunctions    = require("src.app.utilities.GridIndexFunctions")
local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")

local EXPORTED_METHODS = {
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
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function SiloLauncher:onBind(target)
    assert(self.m_Owner == nil, "SiloLauncher:onBind() the component has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Owner = target

    return self
end

function SiloLauncher:onUnbind()
    assert(self.m_Owner ~= nil, "SiloLauncher:onUnbind() the component has not bound a target.")

    ComponentManager.unsetMethods(self.m_Owner, EXPORTED_METHODS)
    self.m_Owner = nil

    return self
end

--------------------------------------------------------------------------------
-- The functions for doing the actions.
--------------------------------------------------------------------------------
function SiloLauncher:doActionLaunchSilo(action, modelUnitMap, modelTile)
    modelTile:updateWithObjectAndBaseId(self:getTileObjectIdAfterLaunch())

    local isWithinMap = GridIndexFunctions.isWithinMap
    local mapSize     = modelUnitMap:getMapSize()
    for _, gridIndex in pairs(GridIndexFunctions.getGridsWithinDistance(action.targetGridIndex, 0, 2)) do
        if (isWithinMap(gridIndex, mapSize)) then
            local modelUnit = modelUnitMap:getModelUnit(gridIndex)
            if (modelUnit) then
                modelUnit:setCurrentHP(math.max(1, modelUnit:getCurrentHP() - 30))
            end
        end
    end

    return self.m_Owner
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
