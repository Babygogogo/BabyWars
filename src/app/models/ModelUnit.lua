
local ModelUnit = class("ModelUnit")

local ComponentManager      = require("global.components.ComponentManager")
local TypeChecker           = require("app.utilities.TypeChecker")
local GameConstantFunctions = require("app.utilities.GameConstantFunctions")

--------------------------------------------------------------------------------
-- The set state functions.
--------------------------------------------------------------------------------
local function setStateIdle(self)
    self.m_State = "idle"

    if (self.m_View) then
        self.m_View:setStateIdle()
    end
end

local function setStateActioned(self)
    self.m_State = "actioned"
end

--------------------------------------------------------------------------------
-- The callback functions on EvtTurnPhaseConsumeUnitFuel.
--------------------------------------------------------------------------------
local function onEvtTurnPhaseConsumeUnitFuel(self, event)
    if (self:getPlayerIndex() == event.playerIndex) and (event.turnIndex > 1) then
        local fuel = math.max(self:getCurrentFuel() - self:getFuelConsumptionPerTurn(), 0)
        self:setCurrentFuel(math.max(self:getCurrentFuel() - self:getFuelConsumptionPerTurn(), 0))
        if (self:getCurrentFuel() == 0) and (self:shouldDestroyOnOutOfFuel()) then
            self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtDestroyUnit", gridIndex = self:getGridIndex()})
        end
    end
end

--------------------------------------------------------------------------------
-- The callback functions on EvtTurnPhaseResetUnitState.
--------------------------------------------------------------------------------
local function onEvtTurnPhaseResetUnitState(self, event)
    if (self:getPlayerIndex() == event.playerIndex) then
        setStateIdle(self)
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
    self.m_State = param.state or self.m_State

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
    view:updateWithTiledID(self.m_TiledID)
end

function ModelUnit:setRootScriptEventDispatcher(dispatcher)
    self:unsetRootScriptEventDispatcher()
    self.m_RootScriptEventDispatcher = dispatcher
    dispatcher:addEventListener("EvtTurnPhaseConsumeUnitFuel", self)
        :addEventListener("EvtTurnPhaseResetUnitState", self)

    return self
end

function ModelUnit:unsetRootScriptEventDispatcher()
    if (self.m_RootScriptEventDispatcher) then
        self.m_RootScriptEventDispatcher:removeEventListener("EvtTurnPhaseResetUnitState", self)
            :removeEventListener("EvtTurnPhaseConsumeUnitFuel", self)

        self.m_RootScriptEventDispatcher = nil
    end

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
function ModelUnit:onEvent(event)
    local name = event.name
    if (name == "EvtTurnPhaseConsumeUnitFuel") then
        onEvtTurnPhaseConsumeUnitFuel(self, event)
    elseif (name == "EvtTurnPhaseResetUnitState") then
        onEvtTurnPhaseResetUnitState(self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelUnit:getTiledID()
    return self.m_TiledID
end

function ModelUnit:getPlayerIndex()
    return GameConstantFunctions.getPlayerIndexWithTiledId(self.m_TiledID)
end

function ModelUnit:getState()
    return self.m_State
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

function ModelUnit:canJoin(rhsUnitModel)
    return (self:getCurrentHP() <= 90) and (self.m_TiledID == rhsUnitModel.m_TiledID)
end

function ModelUnit:canDoAction(playerIndex)
    return (self:getPlayerIndex() == playerIndex) and (self:getState() == "idle")
end

function ModelUnit:doActionWait(action)
    setStateActioned(self)
    self:moveAlongPath(action.path, function()
        if (self.m_View) then
            self.m_View:setStateActioned()
        end
    end)

    return self
end

return ModelUnit
