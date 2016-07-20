
--[[--------------------------------------------------------------------------------
-- Buildable是ModelTile可用的组件。只有绑定了本组件，才能被可实施占领的对象（即绑定了CaptureDoer的ModelUnit）实施占领。
-- 主要职责：
--   维护有关占领的各种数值（目前只要维护当前占领点数），并提供必要接口给外界访问
-- 使用场景举例：
--   宿主初始化时，根据自身属性来绑定和初始化本组件（比如city需要绑定，plain不需要。具体需要与否，由GameConstant决定）
--   占领点数降为0后，若满足占领即失败的条件（如HQ），则派发相应事件（未完成）。
--]]--------------------------------------------------------------------------------

local Buildable = require("src.global.functions.class")("Buildable")

local ComponentManager      = require("src.global.components.ComponentManager")
local GridIndexFunctions    = require("src.app.utilities.GridIndexFunctions")

local EXPORTED_METHODS = {
    "getCurrentBuildPoint",
    "getMaxBuildPoint",
}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function isBuilderDestroyed(selfGridIndex, builder)
    return ((GridIndexFunctions.isEqual(selfGridIndex, builder:getGridIndex())) and
        (builder:getCurrentHP() <= 0))
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function Buildable:ctor(param)
    self:loadTemplate(param.template)
        :loadInstantialData(param.instantialData)

    return self
end

function Buildable:loadTemplate(template)
    assert(template.maxBuildPoint, "Buildable:loadTemplate() the param template.maxBuildPoint is invalid.")
    self.m_Template = template

    return self
end

function Buildable:loadInstantialData(data)
    assert(data.currentBuildPoint, "Buildable:loadInstantialData() the param data.currentBuildPoint is invalid.")
    self.m_CurrentBuildPoint = data.currentBuildPoint

    return self
end

--------------------------------------------------------------------------------
-- The function for serialization.
--------------------------------------------------------------------------------
function Buildable:toSerializableTable()
    local currentBuildPoint = self:getCurrentBuildPoint()
    if (currentBuildPoint == self:getMaxBuildPoint()) then
        return nil
    else
        return {
            currentBuildPoint = currentBuildPoint,
        }
    end
end

--------------------------------------------------------------------------------
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function Buildable:onBind(target)
    assert(self.m_Owner == nil, "Buildable:onBind() the component has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Owner = target

    return self
end

function Buildable:onUnbind()
    assert(self.m_Owner ~= nil, "Buildable:onUnbind() the component has not bound a target.")

    ComponentManager.unsetMethods(self.m_Owner, EXPORTED_METHODS)
    self.m_Owner = nil

    return self
end

--------------------------------------------------------------------------------
-- The functions for doing the actions.
--------------------------------------------------------------------------------
function Buildable:doActionSurrender(action)
    self.m_CurrentBuildPoint = self:getMaxBuildPoint()

    return self
end

function Buildable:doActionMoveModelUnit(action)
    if ((not action.launchUnitID)                                                   and
        (#action.path > 1)                                                          and
        (GridIndexFunctions.isEqual(action.path[1], self.m_Owner:getGridIndex()))) then
        self.m_CurrentBuildPoint = self:getMaxBuildPoint()
    end

    return self
end

function Buildable:doActionBuildModelTile(action, builder, target)
    self.m_CurrentBuildPoint = math.max(self.m_CurrentBuildPoint - builder:getBuildAmount(), 0)
    if (self.m_CurrentBuildPoint <= 0) then
        local modelTile = self.m_Owner
        local _, baseID = modelTile:getObjectAndBaseId()
        modelTile:updateWithObjectAndBaseId(builder:getBuildTiledId(), baseID)
    end

    return self
end

function Buildable:doActionAttack(action, attacker, target)
    local gridIndex = self.m_Owner:getGridIndex()
    if ((isBuilderDestroyed(gridIndex, attacker))                           or
        ((target.getUnitType) and (isBuilderDestroyed(gridIndex, target)))) then
        self.m_CurrentBuildPoint = self:getMaxBuildPoint()
    end

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function Buildable:getCurrentBuildPoint()
    return self.m_CurrentBuildPoint
end

function Buildable:getMaxBuildPoint()
    return self.m_Template.maxBuildPoint
end

return Buildable
