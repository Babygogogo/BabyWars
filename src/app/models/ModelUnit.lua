
local ModelUnit = class("ModelUnit")

local ComponentManager	= require("global.components.ComponentManager")
local TypeChecker       = require("app.utilities.TypeChecker")

local TEMPLATE_MODEL_UNIT_IDS = require("res.data.GameConstant").Mapping_TiledIdToTemplateModelIdTileOrUnit
local TEMPLATE_MODEL_UNITS    = require("res.data.GameConstant").Mapping_IdToTemplateModelUnit

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function isOfSameTemplateModelUnitID(tiledID1, tiledID2)
    if (not tiledID1) or (not tiledID2) then
        return false
    end

    return TEMPLATE_MODEL_UNIT_IDS[tiledID1].n == TEMPLATE_MODEL_UNIT_IDS[tiledID2].n
end

local function toTemplateModelUnit(tiledID)
    return TEMPLATE_MODEL_UNITS[TEMPLATE_MODEL_UNIT_IDS[tiledID].n]
end

local function toPlayerIndex(tiledID)
    return TEMPLATE_MODEL_UNIT_IDS[tiledID].p
end


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
-- The callback functions on EvtTurnPhaseStandby.
--------------------------------------------------------------------------------
local function onEvtTurnPhaseStandby(self, event)
    if (self:getPlayerIndex() == event.playerIndex) and (event.turnIndex > 1) then
        local fuel = self:getCurrentFuel() - self:getFuelConsumptionPerTurn()
        self:setCurrentFuel(fuel)
        -- TODO: destroy the unit if needed.
    end
end

--------------------------------------------------------------------------------
-- The callback functions on EvtTurnPhaseEnd.
--------------------------------------------------------------------------------
local function onEvtTurnPhaseEnd(self, event)
    if (self:getPlayerIndex() == event.playerIndex) then
        setStateIdle(self)
    end
end

--------------------------------------------------------------------------------
-- The functions that loads the data for the model from a TiledID/lua table.
--------------------------------------------------------------------------------
local function initWithTiledID(self, tiledID)
    local template = toTemplateModelUnit(tiledID)
    assert(template, "ModelUnit-initWithTiledID() failed to get the template self unit with param tiledID.")

    self.m_TiledID = tiledID
    if (template == self.m_Template) then
        return
    end

    self.m_Template = template
    self.m_State    = "idle"

    ComponentManager.unbindAllComponents(self)
        .bindComponent(self, "GridIndexable")
        .bindComponent(self, "FuelOwner", {template = template.fuel, instantialData = template.fuel})
        .bindComponent(self, "MoveDoer",  {template = template.movement})
        .bindComponent(self, "AttackTaker")

    if (template.specialProperties) then
        for _, specialProperty in ipairs(template.specialProperties) do
            if (not ComponentManager.getComponent(self, specialProperty.name)) then
                ComponentManager.bindComponent(self, specialProperty.name)
            end
            ComponentManager.getComponent(self, specialProperty.name):load(specialProperty)
        end
    end
end

local function loadInstantialData(self, param)
    if (param.gridIndex) then
        self:setGridIndex(param.gridIndex)
    end

    self.m_State = param.state or self.m_State
    if (param.fuel) then
        ComponentManager.getComponent("FuelOwner"):loadInstantialData(param.fuel)
    end

    if (param.specialProperties) then
        for _, specialProperty in ipairs(param.specialProperties) do
            local component = ComponentManager.getComponent(self, specialProperty.name)
            assert(component, "ModelUnit-loadInstantialData() attempting to load a component that the model hasn't bound with.")
            component:load(specialProperty)
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
    dispatcher:addEventListener("EvtTurnPhaseStandby", self)
        :addEventListener("EvtTurnPhaseEnd", self)

    return self
end

function ModelUnit:unsetRootScriptEventDispatcher()
    if (self.m_RootScriptEventDispatcher) then
        self.m_RootScriptEventDispatcher:removeEventListener("EvtTurnPhaseEnd", self)
            :removeEventListener("EvtTurnPhaseStandby", self)

        self.m_RootScriptEventDispatcher = nil
    end

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
function ModelUnit:onEvent(event)
    local name = event.name
    if (name == "EvtTurnPhaseStandby") then
        onEvtTurnPhaseStandby(self, event)
    elseif (name == "EvtTurnPhaseEnd") then
        onEvtTurnPhaseEnd(self, event)
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
    return toPlayerIndex(self.m_TiledID)
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

function ModelUnit:getDefenseFatalList()
    return self.m_Template.defense.fatal
end

function ModelUnit:getDefenseWeakList()
    return self.m_Template.defense.weak
end

function ModelUnit:canJoin(rhsUnitModel)
    return (self:getCurrentHP() <= 90) and (self.m_TiledID == rhsUnitModel.m_TiledID)
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
