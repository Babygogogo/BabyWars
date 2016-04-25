
local ModelUnit = class("ModelUnit")

local ComponentManager      = require("global.components.ComponentManager")
local TypeChecker           = require("app.utilities.TypeChecker")
local GameConstantFunctions = require("app.utilities.GameConstantFunctions")

--------------------------------------------------------------------------------
-- The set state functions.
--------------------------------------------------------------------------------
local function setStateIdle(self)
    self.m_State = "idle"
end

--------------------------------------------------------------------------------
-- The callback functions on EvtTurnPhaseResetUnitState.
--------------------------------------------------------------------------------
local function onEvtTurnPhaseResetUnitState(self, event)
    if (self:getPlayerIndex() == event.playerIndex) then
        setStateIdle(self)
        self:updateView()
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
    self:unsetRootScriptEventDispatcher()
    self.m_RootScriptEventDispatcher = dispatcher
    dispatcher:addEventListener("EvtTurnPhaseResetUnitState", self)

    for _, component in pairs(ComponentManager.getAllComponents(self)) do
        if (component.setRootScriptEventDispatcher) then
            component:setRootScriptEventDispatcher(dispatcher)
        end
    end

    return self
end

function ModelUnit:unsetRootScriptEventDispatcher()
    if (self.m_RootScriptEventDispatcher) then
        self.m_RootScriptEventDispatcher:removeEventListener("EvtTurnPhaseResetUnitState", self)

        self.m_RootScriptEventDispatcher = nil

        for _, component in pairs(ComponentManager.getAllComponents(self)) do
            if (component.unsetRootScriptEventDispatcher) then
                component:unsetRootScriptEventDispatcher()
            end
        end
    end

    return self
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

function ModelUnit:isInStealthMode()
    return false
end

function ModelUnit:getDescription()
    return self.m_Template.description
end

function ModelUnit:getVision()
    return self.m_Template.vision
end

function ModelUnit:getProductionCost()
    return self.m_Template.cost
end

function ModelUnit:canJoin(rhsUnitModel)
    return (self:getCurrentHP() <= 90) and (self.m_TiledID == rhsUnitModel.m_TiledID)
end

function ModelUnit:canDoAction(playerIndex)
    return (self:getPlayerIndex() == playerIndex) and (self:getState() == "idle")
end

function ModelUnit:doActionWait(action)
    self:setStateActioned()

    for _, component in pairs(ComponentManager.getAllComponents(self)) do
        if (component.doActionWait) then
            component:doActionWait(action)
        end
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtModelUnitUpdated", modelUnit = self})

    if (self.m_View) then
        self.m_View:moveAlongPath(action.path, function()
            self:updateView()
        end)
    end

    return self
end

function ModelUnit:doActionAttack(action, isAttacker)
    if (isAttacker) then
        self:setStateActioned()
    end

    local rootScriptEventDispatcher = self.m_RootScriptEventDispatcher
    local shouldDestroyAttacker = self:getCurrentHP() <= (action.counterDamage or 0)
    local shouldDestroyTarget   = action.target:getCurrentHP() <= action.attackDamage

    for _, component in pairs(ComponentManager.getAllComponents(self)) do
        if (component.doActionAttack) then
            component:doActionAttack(action, isAttacker)
        end
    end

    rootScriptEventDispatcher:dispatchEvent({name = "EvtModelUnitUpdated", modelUnit = self})

    if ((self.m_View) and (isAttacker)) then
        self.m_View:moveAlongPath(action.path, function()
            self:updateView()
            if (action.target.updateView) then
                action.target:updateView()
            end

            if (shouldDestroyAttacker) then
                rootScriptEventDispatcher:dispatchEvent({name = "EvtDestroyViewUnit", gridIndex = self:getGridIndex()})
            end
            if (shouldDestroyTarget) then
                if (action.targetType == "unit") then
                    rootScriptEventDispatcher:dispatchEvent({name = "EvtDestroyViewUnit", gridIndex = action.targetGridIndex})
                else
                    rootScriptEventDispatcher:dispatchEvent({name = "EvtDestroyViewTile", gridIndex = action.targetGridIndex})
                end
            end
        end)
    end

    return self
end

function ModelUnit:doActionCapture(action)
    self:setStateActioned()

    for _, component in pairs(ComponentManager.getAllComponents(self)) do
        if (component.doActionCapture) then
            component:doActionCapture(action)
        end
    end

    if (self.m_View) then
        self.m_View:moveAlongPath(action.path, function()
            self:updateView()
            action.nextTarget:updateView()
        end)
    end

    return self
end

return ModelUnit
