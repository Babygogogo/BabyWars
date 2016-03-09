
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

local function initWithTiledID(model, tiledID)
    local template = toTemplateModelUnit(tiledID)
    assert(template, "ModelUnit-initWithTiledID() failed to get the template model unit with param tiledID.")

    ComponentManager.unbindAllComponents(model)
    ComponentManager.bindComponent(model, "GridIndexable", "HPOwner")

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

return ModelUnit
