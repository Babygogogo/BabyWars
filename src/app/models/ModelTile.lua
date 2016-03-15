
local ModelTile = class("ModelTile")

local TEMPLATE_MODEL_TILE_IDS = require("res.data.GameConstant").Mapping_TiledIdToTemplateModelIdTileOrUnit
local TEMPLATE_MODEL_TILES    = require("res.data.GameConstant").Mapping_IdToTemplateModelTile

local ComponentManager = require("global.components.ComponentManager")
local TypeChecker      = require("app.utilities.TypeChecker")

local function isOfSameTemplateModelTileID(tiledID1, tiledID2)
    if (not tiledID1) or (not tiledID2) then
        return false
    end

    return TEMPLATE_MODEL_TILE_IDS[tiledID1] == TEMPLATE_MODEL_TILE_IDS[tiledID2]
end

local function toTemplateModelTile(tiledID)
	return TEMPLATE_MODEL_TILES[TEMPLATE_MODEL_TILE_IDS[tiledID]]
end

local function initWithTiledID(model, tiledID)
    local template = toTemplateModelTile(tiledID)
    assert(template, "ModelTile-initWithTiledID() failed to get the model tile template with param tiledID.")

    ComponentManager.unbindAllComponents(model)
    ComponentManager.bindComponent(model, "GridIndexable")

    model.m_Template     = template

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

--[[ These code are commented out because the properties should not be overwritten.
    model.m_DefenseBonus = param.defenseBonus or model.m_DefenseBonus
    model.m_Description  = param.description  or model.m_Description
]]
    if (param.specialProperties) then
        for _, specialProperty in ipairs(param.specialProperties) do
            local component = ComponentManager.getComponent(model, specialProperty.name)
            assert(component, "ModelTile-overwrite() attempting to overwrite a component that the model hasn't bound with.")
            component:load(specialProperty)
        end
    end
end

--------------------------------------------------------------------------------
-- The constructor and public functions.
--------------------------------------------------------------------------------
function ModelTile:ctor(param)
    if (param) then
        self:load(param)
    end

    return self
end

function ModelTile:load(param)
    if (param.tiledID) then
        if (not isOfSameTemplateModelTileID(param.tiledID, self.m_TiledID)) then
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

function ModelTile.createInstance(param)
	local model = ModelTile.new():load(param)
	assert(model, "ModelTile.createInstance() failed.")

	return model
end

function ModelTile:initView()
    local view = self.m_View
	assert(view, "ModelTile:initView() no view is attached to the actor of the model.")

    self:setViewPositionWithGridIndex()
    view:updateWithTiledID(self.m_TiledID)

    return self
end

function ModelTile:getTiledID()
    return self.m_TiledID
end

function ModelTile:getDefenseBonusAmount()
    return self.m_Template.defenseBonus.amount
end

function ModelTile:getNormalizedDefenseBonusAmount()
    return math.floor(self:getDefenseBonusAmount() / 10)
end

function ModelTile:getDefenseBonusTargetCatagory()
    return self.m_Template.defenseBonus.targetCatagory
end

function ModelTile:getMoveCostWithMoveType(moveType)
    return self.m_Template.moveCost.clear[moveType]
end

function ModelTile:getDescription()
    return self.m_Template.description
end

return ModelTile
