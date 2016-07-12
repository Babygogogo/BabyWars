
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

local ModelUnit = class("ModelUnit")

local ComponentManager      = require("global.components.ComponentManager")
local TypeChecker           = require("app.utilities.TypeChecker")
local GameConstantFunctions = require("app.utilities.GameConstantFunctions")
local TableFunctions        = require("app.utilities.TableFunctions")
local LocalizationFunctions = require("app.utilities.LocalizationFunctions")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function setStateIdle(self)
    self.m_State = "idle"
end

local function dispatchEvtDestroyViewUnit(dispatcher, gridIndex)
    dispatcher:dispatchEvent({
        name      = "EvtDestroyViewUnit",
        gridIndex = gridIndex,
    })
end

local function dispatchEvtDestroyViewTile(dispatcher, gridIndex)
    dispatcher:dispatchEvent({
        name      = "EvtDestroyViewTile",
        gridIndex = gridIndex,
    })
end

local function dispatchEvtAttackViewUnit(dispatcher, gridIndex)
    dispatcher:dispatchEvent({
        name      = "EvtAttackViewUnit",
        gridIndex = gridIndex,
    })
end

local function dispatchEvtAttackViewTile(dispatcher, gridIndex)
    dispatcher:dispatchEvent({
        name      = "EvtAttackViewTile",
        gridIndex = gridIndex,
    })
end

--------------------------------------------------------------------------------
-- The callback functions on EvtTurnPhaseResetUnitState.
--------------------------------------------------------------------------------
local function onEvtTurnPhaseResetUnitState(self, event)
    if (self:getPlayerIndex() == event.playerIndex) then
        setStateIdle(self)

        if (self.m_View) then
            self.m_View:updateWithModelUnit(self)
                :showNormalAnimation()
        end
    end
end

--------------------------------------------------------------------------------
-- The functions that loads the data for the model from a TiledID/lua table.
--------------------------------------------------------------------------------
local function initWithTiledID(self, tiledID)
    local template = GameConstantFunctions.getTemplateModelUnitWithTiledId(tiledID)
    assert(template, "ModelUnit-initWithTiledID() failed to get the template self unit with param tiledID.")

    self.m_TiledID = tiledID
    if (template == self.m_Template) then
        return
    end

    self.m_Template = template
    self.m_State    = "idle"

    ComponentManager.unbindAllComponents(self)
    for name, data in pairs(template) do
        if (string.byte(name) > string.byte("z")) or (string.byte(name) < string.byte("a")) then
            ComponentManager.bindComponent(self, name, {template = data, instantialData = data})
        end
    end
end

local function loadInstantialData(self, param)
    self.m_State  = param.state  or self.m_State
    self.m_UnitID = param.unitID or self.m_UnitID

    for name, data in pairs(param) do
        if (string.byte(name) > string.byte("z")) or (string.byte(name) < string.byte("a")) then
            local component = ComponentManager.getComponent(self, name)
            assert(component, "ModelUnit-loadInstantialData() attempting to update a component that the model hasn't bound with.")

            component:loadInstantialData(data)
        end
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelUnit:ctor(param)
    if (param.tiledID) then
        initWithTiledID(self, param.tiledID)
    end

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
        :updateView()
end

function ModelUnit:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelUnit:setRootScriptEventDispatcher() the dispatcher has been set.")
    self.m_RootScriptEventDispatcher = dispatcher
    dispatcher:addEventListener("EvtTurnPhaseResetUnitState", self)
    ComponentManager.callMethodForAllComponents(self, "setRootScriptEventDispatcher", dispatcher)

    return self
end

function ModelUnit:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "ModelUnit:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")
    self.m_RootScriptEventDispatcher:removeEventListener("EvtTurnPhaseResetUnitState", self)
    self.m_RootScriptEventDispatcher = nil
    ComponentManager.callMethodForAllComponents(self, "unsetRootScriptEventDispatcher")

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

    t.tiledID = self:getTiledID()
    t.unitID  = self:getUnitId()
    local state = self:getState()
    if (state ~= "idle") then
        t.state = state
    end

    return t
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
function ModelUnit:onEvent(event)
    local name = event.name
    if (name == "EvtTurnPhaseResetUnitState") then
        onEvtTurnPhaseResetUnitState(self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions for doing actions.
--------------------------------------------------------------------------------
function ModelUnit:doActionMoveModelUnit(action)
    ComponentManager.callMethodForAllComponents(self, "doActionMoveModelUnit", action)

    return self
end

function ModelUnit:doActionLaunchModelUnit(action)
    ComponentManager.callMethodForAllComponents(self, "doActionLaunchModelUnit", action)

    return self
end

function ModelUnit:doActionWait(action)
    self:setStateActioned()

    ComponentManager.callMethodForAllComponents(self, "doActionWait", action)

    if (self.m_View) then
        self.m_View:moveAlongPath(action.path, function()
            self.m_View:updateWithModelUnit(self)
                :showNormalAnimation()
        end)
    end

    return self
end

function ModelUnit:doActionAttack(action, attacker, target)
    if (self == attacker) then
        self:setStateActioned()
    end

    local shouldDestroyAttacker = attacker:getCurrentHP() <= (action.counterDamage or 0)
    local shouldDestroyTarget   = target:getCurrentHP()   <= action.attackDamage
    local eventDispatcher       = self.m_RootScriptEventDispatcher

    ComponentManager.callMethodForAllComponents(self, "doActionAttack", action, attacker, target)

    if ((self.m_View) and (self == attacker)) then
        self.m_View:moveAlongPath(action.path, function()
            self.m_View:updateWithModelUnit(self)
                :showNormalAnimation()

            if (target.updateView) then
                target:updateView()
            end

            if (shouldDestroyAttacker) then
                dispatchEvtDestroyViewUnit(eventDispatcher, attacker:getGridIndex())
            elseif ((action.counterDamage) and (not shouldDestroyTarget)) then
                dispatchEvtAttackViewUnit(eventDispatcher, attacker:getGridIndex())
            end

            if (shouldDestroyTarget) then
                if (target.getUnitType) then
                    dispatchEvtDestroyViewUnit(eventDispatcher, action.targetGridIndex)
                else
                    dispatchEvtDestroyViewTile(eventDispatcher, action.targetGridIndex)
                end
            else
                if (action.getUnitType) then
                    dispatchEvtAttackViewUnit(eventDispatcher, action.targetGridIndex)
                else
                    dispatchEvtAttackViewTile(eventDispatcher, action.targetGridIndex)
                end
            end

            if (action.callbackOnAttackAnimationEnded) then
                action.callbackOnAttackAnimationEnded()
            end
        end)
    end

    return self
end

function ModelUnit:doActionLoadModelUnit(action, focusUnitID, loaderModelUnit)
    if (self:getUnitId() == focusUnitID) then
        self:setStateActioned()
    end

    ComponentManager.callMethodForAllComponents(self, "doActionLoadModelUnit", action, focusUnitID, loaderModelUnit)

    if ((self:getUnitId() == focusUnitID) and (self.m_View)) then
        self.m_View:moveAlongPath(action.path, function()
            self.m_View:updateWithModelUnit(self)
                :showNormalAnimation()
                :setVisible(false)
            loaderModelUnit:updateView()
        end)
    end

    return self
end

function ModelUnit:doActionDropModelUnit(action, droppingActorUnits)
    self:setStateActioned()
    if (not droppingActorUnits) then
        return
    end

    ComponentManager.callMethodForAllComponents(self, "doActionDropModelUnit", action, droppingActorUnits)

    if (self.m_View) then
        local path                  = action.path
        local loaderEndingGridIndex = path[#path]

        self.m_View:moveAlongPath(action.path, function()
            self.m_View:updateWithModelUnit(self)
                :showNormalAnimation()

            for _, dropActorUnit in ipairs(droppingActorUnits) do
                local dropModelUnit = dropActorUnit:getModel()
                local dropViewUnit  = dropActorUnit:getView()
                dropViewUnit:moveAlongPath({loaderEndingGridIndex, dropModelUnit:getGridIndex()}, function()
                    dropViewUnit:updateWithModelUnit(dropModelUnit)
                        :showNormalAnimation()
                end)
            end
        end)
    end

    return self
end

function ModelUnit:doActionCapture(action, capturer, target)
    self:setStateActioned()

    ComponentManager.callMethodForAllComponents(self, "doActionCapture", action, capturer, target)

    if (self.m_View) then
        self.m_View:moveAlongPath(action.path, function()
            self.m_View:updateWithModelUnit(self)
                :showNormalAnimation()
            target:updateView()

            if (action.callbackOnCaptureAnimationEnded) then
                action.callbackOnCaptureAnimationEnded()
            end
        end)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelUnit:updateView()
    if (self.m_View) then
        self.m_View:updateWithModelUnit(self)
    end

    return self
end

function ModelUnit:getTiledID()
    return self.m_TiledID
end

function ModelUnit:getUnitId()
    return self.m_UnitID
end

function ModelUnit:getPlayerIndex()
    return GameConstantFunctions.getPlayerIndexWithTiledId(self.m_TiledID)
end

function ModelUnit:getState()
    return self.m_State
end

function ModelUnit:setStateActioned()
    self.m_State = "actioned"

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

function ModelUnit:getUnitType()
    return GameConstantFunctions.getUnitTypeWithTiledId(self:getTiledID())
end

function ModelUnit:getDescription()
    return LocalizationFunctions.getLocalizedText(114, self:getUnitType())
end

function ModelUnit:getUnitTypeFullName()
    return LocalizationFunctions.getLocalizedText(113, self:getUnitType())
end

function ModelUnit:getVision()
    return self.m_Template.vision
end

function ModelUnit:getProductionCost()
    return self.m_Template.cost
end

function ModelUnit:canJoinModelUnit(rhsUnitModel)
    return ((self:getTiledID() == rhsUnitModel:getTiledID()) and (rhsUnitModel:getCurrentHP() <= 90))
end

function ModelUnit:canDoAction(playerIndex)
    return (self:getPlayerIndex() == playerIndex) and (self:getState() == "idle")
end

return ModelUnit
