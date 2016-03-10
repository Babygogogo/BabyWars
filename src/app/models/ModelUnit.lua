
local ModelUnit = class("ModelUnit")

local ComponentManager	= require("global.components.ComponentManager")
local TypeChecker       = require("app.utilities.TypeChecker")

local TEMPLATE_MODEL_UNIT_IDS = require("res.data.GameConstant").Mapping_TiledIdToTemplateModelIdTileOrUnit
local TEMPLATE_MODEL_UNITS    = require("res.data.GameConstant").Mapping_IdToTemplateModelUnit

local function isOfSameTemplateModelUnitID(tiledID1, tiledID2)
    if (not tiledID1) or (not tiledID2) then
        return false
    end

    return TEMPLATE_MODEL_UNIT_IDS[tiledID1] == TEMPLATE_MODEL_UNIT_IDS[tiledID2]
end

local function toTemplateModelUnit(tiledID)
    return TEMPLATE_MODEL_UNITS[TEMPLATE_MODEL_UNIT_IDS[tiledID]]
end

--------------------------------------------------------------------------------
-- Things about fuel data.
--------------------------------------------------------------------------------
local function initWithFuelData(model, data)
    local fuelData = {}

    fuelData.m_MaxFuel                = data.maxFuel
    fuelData.m_CurrentFuel            = data.maxFuel
    fuelData.m_ConsumptionPerTurn     = data.consumptionPerTurn
    fuelData.m_DescriptionOnOutOfFuel = data.descriptionOnOutOfFuel
    fuelData.m_DestroyOnOutOfFuel     = data.destroyOnOutOfFuel

    model.m_FuelData = fuelData
end

local function overwriteWithFuelData(model, data)
    assert(type(model.m_FuelData) == "table", "ModelUnit-overwriteWithFuelData() the model has no fuel data.")

    if (not data) then
        return
    end

    model.m_FuelData.m_CurrentFuel = data.currentFuel
end

local function initWithTiledID(model, tiledID)
    local template = toTemplateModelUnit(tiledID)
    assert(template, "ModelUnit-initWithTiledID() failed to get the template model unit with param tiledID.")

    ComponentManager.unbindAllComponents(model)
    ComponentManager.bindComponent(model, "GridIndexable", "HPOwner")

    model.m_MovementRange = template.movementRange
    model.m_MovementType  = template.movementType
    model.m_Vision        = template.vision

    initWithFuelData(model, template.fuel)

    model.m_Description = template.description

    if (template.specialProperties) then
        for _, specialProperty in ipairs(template.specialProperties) do
            if (not ComponentManager.getComponent(model, specialProperty.name)) then
                ComponentManager.bindComponent(model, specialProperty.name)
            end
            ComponentManager.getComponent(model, specialProperty.name):load(specialProperty)
        end
    end
end

local function overwrite(model, param)
    if (param.gridIndex) then
        model:setGridIndex(param.gridIndex)
    end

    overwriteWithFuelData(model, param.fuel)

--[[ These codes are commented out because the properties should not be overwrited.
    model.m_Description = param.description or model.m_Description
]]
    if (param.specialProperties) then
        for _, specialProperty in ipairs(param.specialProperties) do
            local component = ComponentManager.getComponent(model, specialProperty.name)
            assert(component, "ModelUnit-overwrite() attempting to overwrite a component that the model hasn't bound with.")
            component:load(specialProperty)
        end
    end
end

function ModelUnit:ctor(param)
    ComponentManager.bindComponent(self, "GridIndexable")

    if (param) then
        self:load(param)
    end

	return self
end

function ModelUnit:load(param)
    if (param.tiledID) then
        if (not isOfSameTemplateModelUnitID(param.tiledID, self.m_TiledID)) then
            initWithTiledID(self, param.tiledID)
        end

        self.m_TiledID = param.tiledID
    end

    overwrite(self, param)

    if (self.m_View) then
        self:initView()
    end

	return self
end

function ModelUnit.createInstance(param)
	local unit = ModelUnit.new():load(param)
    assert(unit, "ModelUnit.createInstance() failed.")

	return unit
end

function ModelUnit:initView()
    local view = self.m_View
	assert(view, "ModelUnit:initView() no view is attached to the actor of the model.")

    self:setViewPositionWithGridIndex()
    view:updateWithTiledID(self.m_TiledID)
end

function ModelUnit:getTiledID()
    return self.m_TiledID
end

function ModelUnit:getDescription()
    return self.m_Description
end

function ModelUnit:getMovementRange()
    return self.m_MovementRange
end

function ModelUnit:getMovementType()
    return self.m_MovementType
end

function ModelUnit:getVision()
    return self.m_Vision
end

function ModelUnit:getCurrentFuel()
    return self.m_FuelData.m_CurrentFuel
end

function ModelUnit:getMaxFuel()
    return self.m_FuelData.m_MaxFuel
end

function ModelUnit:getFuelConsumptionPerTurn()
    return self.m_FuelData.m_ConsumptionPerTurn
end

function ModelUnit:getDescriptionOnOutOfFuel()
    return self.m_FuelData.m_DescriptionOnOutOfFuel
end

return ModelUnit
