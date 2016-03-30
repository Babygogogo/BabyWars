
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

    if (self.m_View) then
        self.m_View:setStateActioned()
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
-- The fuel data.
--------------------------------------------------------------------------------
local function initWithFuelData(model, data)
    local fuel = {}
    fuel.m_CurrentFuel = data.maxFuel

    model.m_Fuel = fuel
end

local function loadFuelData(model, data)
    assert(type(model.m_Fuel) == "table", "ModelUnit-loadFuelData() the model has no fuel data.")

    if (not data) then
        return
    end

    model.m_Fuel.m_CurrentFuel = data.currentFuel
end

--------------------------------------------------------------------------------
-- The functions that loads the data for the model from a TiledID/lua table.
--------------------------------------------------------------------------------
local function initWithTiledID(model, tiledID)
    local template = toTemplateModelUnit(tiledID)
    assert(template, "ModelUnit-initWithTiledID() failed to get the template model unit with param tiledID.")

    model.m_TiledID = tiledID
    if (template == model.m_Template) then
        return
    end

    model.m_Template = template
    model.m_State    = "idle"
    initWithFuelData(model, template.fuel)

    ComponentManager.unbindAllComponents(model)
        .bindComponent(model, "GridIndexable")
        .bindComponent(model, "AttackTaker")

    if (template.specialProperties) then
        for _, specialProperty in ipairs(template.specialProperties) do
            if (not ComponentManager.getComponent(model, specialProperty.name)) then
                ComponentManager.bindComponent(model, specialProperty.name)
            end
            ComponentManager.getComponent(model, specialProperty.name):load(specialProperty)
        end
    end
end

local function loadInstanceProperties(model, param)
    if (param.gridIndex) then
        model:setGridIndex(param.gridIndex)
    end

    model.m_State = param.state or model.m_State
    loadFuelData(model, param.fuel)

    if (param.specialProperties) then
        for _, specialProperty in ipairs(param.specialProperties) do
            local component = ComponentManager.getComponent(model, specialProperty.name)
            assert(component, "ModelUnit-loadInstanceProperties() attempting to loadInstanceProperties a component that the model hasn't bound with.")
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

    loadInstanceProperties(self, param)

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
    dispatcher:addEventListener("EvtTurnPhaseEnd", self)

    return self
end

function ModelUnit:unsetRootScriptEventDispatcher()
    if (self.m_RootScriptEventDispatcher) then
        self.m_RootScriptEventDispatcher:removeEventListener("EvtTurnPhaseEnd", self)

        self.m_RootScriptEventDispatcher = nil
    end

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
function ModelUnit:onEvent(event)
    if (event.name == "EvtTurnPhaseEnd") then
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

function ModelUnit:getMovementRange()
    return self.m_Template.movementRange
end

function ModelUnit:getMovementType()
    return self.m_Template.movementType
end

function ModelUnit:getVision()
    return self.m_Template.vision
end

function ModelUnit:getCurrentFuel()
    return self.m_Fuel.m_CurrentFuel
end

function ModelUnit:getMaxFuel()
    return self.m_Template.fuel.maxFuel
end

function ModelUnit:getFuelConsumptionPerTurn()
    return self.m_Template.fuel.consumptionPerTurn
end

function ModelUnit:getDescriptionOnOutOfFuel()
    return self.m_Template.fuel.descriptionOnOutOfFuel
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
    local callbackOnMoveFinish = function()
        self:setGridIndex(action.path[#action.path])
        setStateActioned(self)
    end

    if (self.m_View) then
        self.m_View:moveAlongPath(action.path, callbackOnMoveFinish)
    else
        callbackOnMoveFinish()
    end

    return self
end

return ModelUnit
