
local UnitLoader = class("UnitLoader")

local GameConstantFunctions = require("app.utilities.GameConstantFunctions")
local ComponentManager      = require("global.components.ComponentManager")

local EXPORTED_METHODS = {
    "getMaxLoadCount",
    "getCurrentLoadCount",
    "getLoadUnitIdList",
    "hasLoadUnitId",
    "canLoadModelUnit",
    "canDropModelUnit",
    "canLaunchModelUnit",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function UnitLoader:ctor(param)
    self:loadTemplate(param.template)
        :loadInstantialData(param.instantialData)

    self.m_LoadedUnitIds = self.m_LoadedUnitIds or {}

    return self
end

function UnitLoader:loadTemplate(template)
    self.m_Template = template

    return self
end

function UnitLoader:loadInstantialData(data)
    self.m_LoadedUnitIds = data.loaded

    return self
end

--------------------------------------------------------------------------------
-- The function for serialization.
--------------------------------------------------------------------------------
function UnitLoader:toSerializableTable()
    if (#self.m_LoadedUnitIds == 0) then
        return nil
    else
        return {
            loaded = self.m_LoadedUnitIds,
        }
    end
end

--------------------------------------------------------------------------------
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function UnitLoader:onBind(target)
    assert(self.m_Owner == nil, "UnitLoader:onBind() the component has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Owner = target

    return self
end

function UnitLoader:onUnbind()
    assert(self.m_Owner ~= nil, "UnitLoader:onUnbind() the component has not bound to a target.")

    ComponentManager.unsetMethods(self.m_Owner, EXPORTED_METHODS)
    self.m_Owner = nil

    return self
end

--------------------------------------------------------------------------------
-- The public functions for doing actions.
--------------------------------------------------------------------------------
function UnitLoader:doActionLoadModelUnit(action, unitID)
    self.m_LoadedUnitIds[#self.m_LoadedUnitIds + 1] = unitID

    return self.m_Owner
end

function UnitLoader:doActionDropModelUnit(action)
    local remainingUnitIds = {}
    for _, unitID in ipairs(self:getLoadUnitIdList()) do
        local isUnitIdRemaining = true
        for _, dropDestination in pairs(action.dropDestinations) do
            if (unitID == dropDestination.unitID) then
                isUnitIdRemaining = false
                break
            end
        end

        if (isUnitIdRemaining) then
            remainingUnitIds[#remainingUnitIds + 1] = unitID
        end
    end

    self.m_LoadedUnitIds = remainingUnitIds

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function UnitLoader:getMaxLoadCount()
    -- TODO: take the co skills into account.
    return self.m_Template.maxLoadCount
end

function UnitLoader:getCurrentLoadCount()
    return #self.m_LoadedUnitIds
end

function UnitLoader:getLoadUnitIdList()
    return self.m_LoadedUnitIds
end

function UnitLoader:hasLoadUnitId(unitID)
    for i, loadedUnitID in ipairs(self:getLoadUnitIdList()) do
        if (loadedUnitID == unitID) then
            return true, i
        end
    end

    return false
end

function UnitLoader:canLoadModelUnit(modelUnit)
    return ((self:getCurrentLoadCount() < self:getMaxLoadCount()) and
        (self.m_Owner:getPlayerIndex() == modelUnit:getPlayerIndex()) and
        (GameConstantFunctions.isTypeInCategory(modelUnit:getUnitType(), self.m_Template.targetCategoryType)))
end

function UnitLoader:canDropModelUnit()
    return self.m_Template.canDrop
end

function UnitLoader:canLaunchModelUnit()
    return self.m_Template.canLaunch
end

return UnitLoader
