
--[[--------------------------------------------------------------------------------
-- ModelUnit是战场上的一个作战单位。
--
-- 主要职责和使用场景举例：
--   构造作战单位，维护相关数值，提供接口给外界访问
--
-- 其他：
--   - ModelUnit中的许多概念都和ModelTile很相似，包括tiledID、instantialData、构造过程等，因此可以参照ModelTile的注释，这里不赘述。
--     有点不同的是，ModelUnit只需一个tiledID即可构造，而ModelTile可能需要1-2个。
--]]--------------------------------------------------------------------------------

local ModelUnit = requireBW("src.global.functions.class")("ModelUnit")

local Destroyers            = requireBW("src.app.utilities.Destroyers")
local GameConstantFunctions = requireBW("src.app.utilities.GameConstantFunctions")
local GridIndexFunctions    = requireBW("src.app.utilities.GridIndexFunctions")
local LocalizationFunctions = requireBW("src.app.utilities.LocalizationFunctions")
local SingletonGetters      = requireBW("src.app.utilities.SingletonGetters")
local ComponentManager      = requireBW("src.global.components.ComponentManager")

local UNIT_STATE_CODE = {
    Idle     = 1,
    Actioned = 2,
}

--------------------------------------------------------------------------------
-- The functions that loads the data for the model from a TiledID/lua table.
--------------------------------------------------------------------------------
local function initWithTiledID(self, tiledID)
    self.m_TiledID = tiledID

    local template = GameConstantFunctions.getTemplateModelUnitWithTiledId(tiledID)
    assert(template, "ModelUnit-initWithTiledID() failed to get the template model unit with param tiledID." .. tiledID)

    if (template ~= self.m_Template) then
        self.m_Template  = template
        self.m_StateCode = UNIT_STATE_CODE.Idle

        ComponentManager.unbindAllComponents(self)
        for name, data in pairs(template) do
            if (string.byte(name) > string.byte("z")) or (string.byte(name) < string.byte("a")) then
                ComponentManager.bindComponent(self, name, {template = data, instantialData = data})
            end
        end
    end
end

local function loadInstantialData(self, param)
    self.m_StateCode = param.stateCode or self.m_StateCode
    self.m_UnitID    = param.unitID    or self.m_UnitID

    for name, data in pairs(param) do
        if (string.byte(name) > string.byte("z")) or (string.byte(name) < string.byte("a")) then
            ComponentManager.getComponent(self, name):loadInstantialData(data)
        end
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelUnit:ctor(param)
    initWithTiledID(   self, param.tiledID)
    loadInstantialData(self, param)

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelUnit:initView()
    local view = self.m_View
    assert(view, "ModelUnit:initView() no view is attached to the actor of the model.")

    self:setViewPositionWithGridIndex()

    return self
end

--------------------------------------------------------------------------------
-- The function for serialization.
--------------------------------------------------------------------------------
function ModelUnit:toSerializableTable()
    local t = {}
    for name, component in pairs(ComponentManager.getAllComponents(self)) do
        if (component.toSerializableTable) then
            t[name] = component:toSerializableTable()
        end
    end

    t.tiledID = self:getTiledId()
    t.unitID  = self:getUnitId()
    local stateCode = self.m_StateCode
    if (stateCode ~= UNIT_STATE_CODE.Idle) then
        t.stateCode = stateCode
    end

    return t
end

--------------------------------------------------------------------------------
-- The callback functions on start running/script events.
--------------------------------------------------------------------------------
function ModelUnit:onStartRunning(modelSceneWar)
    assert(modelSceneWar.isModelSceneWar, "ModelUnit:onStartRunning() invalid modelSceneWar.")
    self.m_ModelSceneWar = modelSceneWar
    self.m_TeamIndex     = SingletonGetters.getModelPlayerManager(modelSceneWar):getModelPlayer(self:getPlayerIndex()):getTeamIndex()

    ComponentManager.callMethodForAllComponents(self, "onStartRunning", modelSceneWar)
    self:updateView()

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelUnit:moveViewAlongPath(path, isDiving, callbackAfterMove)
    if (self.m_View) then
        self.m_View:moveAlongPath(path, isDiving, callbackAfterMove)
    elseif (callbackAfterMove) then
        callbackAfterMove()
    end

    return self
end

function ModelUnit:moveViewAlongPathAndFocusOnTarget(path, isDiving, targetGridIndex, callbackAfterMove)
    if (self.m_View) then
        self.m_View:moveAlongPathAndFocusOnTarget(path, isDiving, targetGridIndex, callbackAfterMove)
    elseif (callbackAfterMove) then
        callbackAfterMove()
    end

    return self
end

function ModelUnit:setViewVisible(visible)
    if (self.m_View) then
        self.m_View:setVisible(visible)
    end

    return self
end

function ModelUnit:updateView()
    if (self.m_View) then
        self.m_View:updateWithModelUnit(self)
    end

    return self
end

function ModelUnit:removeViewFromParent()
    if (self.m_View) then
        self.m_View:removeFromParent()
        self.m_View = nil
    end

    return self
end

function ModelUnit:showNormalAnimation()
    if (self.m_View) then
        self.m_View:showNormalAnimation()
    end

    return self
end

function ModelUnit:showMovingAnimation()
    if (self.m_View) then
        self.m_View:showMovingAnimation()
    end

    return self
end

function ModelUnit:getModelSceneWar()
    assert(self.m_ModelSceneWar, "ModelUnit:getModelSceneWar() onStartRunning() hasn't been called yet.")
    return self.m_ModelSceneWar
end

function ModelUnit:getTiledId()
    return self.m_TiledID
end

function ModelUnit:getUnitId()
    return self.m_UnitID
end

function ModelUnit:getPlayerIndex()
    return GameConstantFunctions.getPlayerIndexWithTiledId(self.m_TiledID)
end

function ModelUnit:getTeamIndex()
    assert(self.m_TeamIndex, "ModelUnit:getTeamIndex() the index hasn't been initialized yet.")
    return self.m_TeamIndex
end

function ModelUnit:isStateIdle()
    return self.m_StateCode == UNIT_STATE_CODE.Idle
end

function ModelUnit:setStateIdle()
    self.m_StateCode = UNIT_STATE_CODE.Idle

    return self
end

function ModelUnit:setStateActioned()
    self.m_StateCode = UNIT_STATE_CODE.Actioned

    return self
end

function ModelUnit:getUnitType()
    return GameConstantFunctions.getUnitTypeWithTiledId(self:getTiledId())
end

function ModelUnit:getDescription()
    return LocalizationFunctions.getLocalizedText(114, self:getUnitType())
end

function ModelUnit:getUnitTypeFullName()
    return LocalizationFunctions.getLocalizedText(113, self:getUnitType())
end

return ModelUnit
