
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

local ModelUnit = require("src.global.functions.class")("ModelUnit")

local TypeChecker           = require("src.app.utilities.TypeChecker")
local TableFunctions        = require("src.app.utilities.TableFunctions")
local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")
local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")
local GridIndexFunctions    = require("src.app.utilities.GridIndexFunctions")
local ComponentManager      = require("src.global.components.ComponentManager")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function dispatchEvtDestroyModelUnit(dispatcher, gridIndex)
    dispatcher:dispatchEvent({
        name      = "EvtDestroyModelUnit",
        gridIndex = gridIndex,
    })
end

local function dispatchEvtDestroyModelTile(dispatcher, gridIndex)
    dispatcher:dispatchEvent({
        name      = "EvtDestroyModelTile",
        gridIndex = gridIndex,
    })
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
        self:setStateIdle()

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
    assert(template, "ModelUnit-initWithTiledID() failed to get the template model unit with param tiledID." .. tiledID)

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

function ModelUnit:setModelPlayerManager(model)
    assert(self.m_ModelPlayerManager == nil, "ModelUnit:setModelPlayerManager() the model has been set already.")
    self.m_ModelPlayerManager = model
    ComponentManager.callMethodForAllComponents(self, "setModelPlayerManager", model)

    return self
end

function ModelUnit:setModelWeatherManager(model)
    assert(self.m_ModelWeatherManager == nil, "ModelUnit:setModelWeatherManager() the model has been set already.")
    self.m_ModelWeatherManager = model
    ComponentManager.callMethodForAllComponents(self, "setModelWeatherManager", model)

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
    local state = self:getState()
    if (state ~= "idle") then
        t.state = state
    end

    return t
end

--------------------------------------------------------------------------------
-- The callback functions on start running/script events.
--------------------------------------------------------------------------------
function ModelUnit:onStartRunning(sceneWarFileName)
    ComponentManager.callMethodForAllComponents(self, "onStartRunning", sceneWarFileName)

    return self
end

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
function ModelUnit:doActionMoveModelUnit(action, loadedModelUnits)
    ComponentManager.callMethodForAllComponents(self, "doActionMoveModelUnit", action, loadedModelUnits)

    return self
end

function ModelUnit:doActionDestroyModelUnit(action)
    ComponentManager.callMethodForAllComponents(self, "doActionDestroyModelUnit", action)

    return self
end

function ModelUnit:doActionPromoteModelUnit(action)
    ComponentManager.callMethodForAllComponents(self, "doActionPromoteModelUnit", action)

    return self
end

function ModelUnit:doActionLaunchModelUnit(action)
    ComponentManager.callMethodForAllComponents(self, "doActionLaunchModelUnit", action)

    if (self.m_View) then
        self.m_View:updateWithModelUnit(self)
            :showNormalAnimation()
    end

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

function ModelUnit:doActionAttack(action, attackTarget, callbackOnAttackAnimationEnded)
    self:setStateActioned()
    ComponentManager.callMethodForAllComponents(self, "doActionAttack", action, attackTarget)

    local shouldDestroySelf   = self:getCurrentHP() <= 0
    local shouldDestroyTarget = attackTarget:getCurrentHP() <= 0
    local selfGridIndex       = self:getGridIndex()
    local targetGridIndex     = action.targetGridIndex
    local isTargetUnit        = attackTarget.getUnitType
    local dispatcher          = self.m_RootScriptEventDispatcher

    if (shouldDestroySelf) then
        attackTarget:doActionPromoteModelUnit()
        dispatchEvtDestroyModelUnit(dispatcher, selfGridIndex)
    end

    if (shouldDestroyTarget) then
        if (isTargetUnit) then
            self:doActionPromoteModelUnit()
            dispatchEvtDestroyModelUnit(dispatcher, targetGridIndex)
        else
            dispatchEvtDestroyModelTile(dispatcher, targetGridIndex)
        end
    end

    if (self.m_View) then
        self.m_View:moveAlongPath(action.path, function()
            self.m_View:updateWithModelUnit(self)
                :showNormalAnimation()
            attackTarget:updateView()

            if (shouldDestroySelf) then
                dispatchEvtDestroyViewUnit(dispatcher, selfGridIndex)
                self.m_View:removeFromParent()
            elseif ((action.counterDamage) and (not shouldDestroyTarget)) then
                dispatchEvtAttackViewUnit(dispatcher, selfGridIndex)
            end

            if (shouldDestroyTarget) then
                if (isTargetUnit) then
                    dispatchEvtDestroyViewUnit(dispatcher, targetGridIndex)
                    attackTarget.m_View:removeFromParent()
                else
                    dispatchEvtDestroyViewTile(dispatcher, targetGridIndex)
                end
            else
                if (isTargetUnit) then
                    dispatchEvtAttackViewUnit(dispatcher, targetGridIndex)
                else
                    dispatchEvtAttackViewTile(dispatcher, targetGridIndex)
                end
            end

            if (callbackOnAttackAnimationEnded) then
                callbackOnAttackAnimationEnded()
            end
        end)
    end

    return self
end

function ModelUnit:doActionJoinModelUnit(action, target)
    local joinIncome = self:getJoinIncome(target)
    if (joinIncome ~= 0) then
        local playerIndex = self:getPlayerIndex()
        local modelPlayer = self.m_ModelPlayerManager:getModelPlayer(playerIndex)
        modelPlayer:setFund(modelPlayer:getFund() + joinIncome)
        self.m_RootScriptEventDispatcher:dispatchEvent({
            name        = "EvtModelPlayerUpdated",
            modelPlayer = modelPlayer,
            playerIndex = playerIndex,
        })
    end

    target:setStateActioned()
    ComponentManager.callMethodForAllComponents(self, "doActionJoinModelUnit", action, target)
    self:unsetRootScriptEventDispatcher()

    if (self.m_View) then
        self.m_View:moveAlongPath(action.path, function()
            self.m_View:removeFromParent()
            target:updateView()
        end)
    end

    return self
end

function ModelUnit:doActionCaptureModelTile(action, target, callbackOnCaptureAnimationEnded)
    self:setStateActioned()
    ComponentManager.callMethodForAllComponents(self, "doActionCaptureModelTile", action, target)

    if (self.m_View) then
        self.m_View:moveAlongPath(action.path, function()
            self.m_View:updateWithModelUnit(self)
                :showNormalAnimation()
            target:updateView()

            if (callbackOnCaptureAnimationEnded) then
                callbackOnCaptureAnimationEnded()
            end
        end)
    end

    return self
end

function ModelUnit:doActionLaunchSilo(action, modelUnitMap, silo)
    self:setStateActioned()
    ComponentManager.callMethodForAllComponents(self, "doActionLaunchSilo", action, modelUnitMap, silo)

    if (self.m_View) then
        self.m_View:moveAlongPath(action.path, function()
            self.m_View:updateWithModelUnit(self)
                :showNormalAnimation()
            silo:updateView()

            local dispatcher  = self.m_RootScriptEventDispatcher
            local mapSize     = modelUnitMap:getMapSize()
            local isWithinMap = GridIndexFunctions.isWithinMap
            for _, gridIndex in pairs(GridIndexFunctions.getGridsWithinDistance(action.targetGridIndex, 0, 2)) do
                if (isWithinMap(gridIndex, mapSize)) then
                    local modelUnit = modelUnitMap:getModelUnit(gridIndex)
                    if (modelUnit) then
                        modelUnit:updateView()
                    end

                    dispatcher:dispatchEvent({
                        name      = "EvtSiloAttackGrid",
                        gridIndex = gridIndex,
                    })
                end
            end
        end)
    end

    return self
end

function ModelUnit:doActionBuildModelTile(action, target)
    self:setStateActioned()
    ComponentManager.callMethodForAllComponents(self, "doActionBuildModelTile", action, target)

    if (self.m_View) then
        self.m_View:moveAlongPath(action.path, function()
            self.m_View:updateWithModelUnit(self)
                :showNormalAnimation()
            target:updateView()
        end)
    end

    return self
end

function ModelUnit:doActionProduceModelUnitOnUnit(action, producedUnitID)
    self:setStateActioned()
    ComponentManager.callMethodForAllComponents(self, "doActionProduceModelUnitOnUnit", action, producedUnitID)

    if (self.m_View) then
        self.m_View:moveAlongPath(action.path, function()
            self.m_View:updateWithModelUnit(self)
                :showNormalAnimation()
        end)
    end

    return self
end

function ModelUnit:doActionSupplyModelUnit(action, targetModelUnits)
    self:setStateActioned()
    ComponentManager.callMethodForAllComponents(self, "doActionSupplyModelUnit", action, targetModelUnits)

    if (self.m_View) then
        self.m_View:moveAlongPath(action.path, function()
            self.m_View:updateWithModelUnit(self)
                :showNormalAnimation()

            local eventDispatcher = self.m_RootScriptEventDispatcher
            for _, target in pairs(targetModelUnits) do
                target:updateView()
                eventDispatcher:dispatchEvent({
                    name      = "EvtSupplyViewUnit",
                    gridIndex = target:getGridIndex(),
                })
            end
        end)
    end

    return self
end

function ModelUnit:doActionLoadModelUnit(action, loader)
    self:setStateActioned()
    -- Attention! We should be invoking the doActionLoadModelUnit methods for the loader rather than self.
    ComponentManager.callMethodForAllComponents(loader, "doActionLoadModelUnit", action, self:getUnitId())

    if (self.m_View) then
        self.m_View:moveAlongPath(action.path, function()
            self.m_View:updateWithModelUnit(self)
                :showNormalAnimation()
                :setVisible(false)
            loader:updateView()
        end)
    end

    return self
end

function ModelUnit:doActionDropModelUnit(action, dropActorUnits)
    self:setStateActioned()
    for _, dropActorUnit in ipairs(dropActorUnits) do
        dropActorUnit:getModel():setStateActioned()
    end
    ComponentManager.callMethodForAllComponents(self, "doActionDropModelUnit", action)

    if (self.m_View) then
        local path                  = action.path
        local loaderEndingGridIndex = path[#path]

        self.m_View:moveAlongPath(path, function()
            self.m_View:updateWithModelUnit(self)
                :showNormalAnimation()

            for _, dropActorUnit in ipairs(dropActorUnits) do
                local dropModelUnit = dropActorUnit:getModel()
                local dropViewUnit  = dropActorUnit:getView()
                dropViewUnit:moveAlongPath({
                        loaderEndingGridIndex,
                        dropModelUnit:getGridIndex(),
                    },
                    function()
                        dropViewUnit:updateWithModelUnit(dropModelUnit)
                            :showNormalAnimation()
                    end
                )
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

function ModelUnit:setActivatingSkillGroupId(skillGroupId)
    if (self.m_View) then
        self.m_View:setActivatingSkillGroupId(skillGroupId)
    end

    return self
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

function ModelUnit:getState()
    return self.m_State
end

function ModelUnit:setStateIdle()
    self.m_State = "idle"

    return self
end

function ModelUnit:setStateActioned()
    self.m_State = "actioned"

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

function ModelUnit:getVision()
    return self.m_Template.vision
end

function ModelUnit:canDoAction(playerIndex)
    return (self:getPlayerIndex() == playerIndex) and (self:getState() == "idle")
end

return ModelUnit
