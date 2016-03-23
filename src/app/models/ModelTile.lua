
local ModelTile = class("ModelTile")

local TEMPLATE_MODEL_TILE_IDS = require("res.data.GameConstant").Mapping_TiledIdToTemplateModelIdTileOrUnit
local TEMPLATE_MODEL_TILES    = require("res.data.GameConstant").Mapping_IdToTemplateModelTile

local ComponentManager = require("global.components.ComponentManager")
local TypeChecker      = require("app.utilities.TypeChecker")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function isOfSameTemplateModelTileID(tiledID1, tiledID2)
    if (not tiledID1) or (not tiledID2) then
        return false
    end

    return TEMPLATE_MODEL_TILE_IDS[tiledID1].n == TEMPLATE_MODEL_TILE_IDS[tiledID2].n
end

local function toTemplateModelTile(tiledID)
    return TEMPLATE_MODEL_TILES[TEMPLATE_MODEL_TILE_IDS[tiledID].n]
end

local function toPlayerIndex(tiledID)
    return TEMPLATE_MODEL_TILE_IDS[tiledID].p
end

local function initWithTiledID(model, tiledID)
    local template = toTemplateModelTile(tiledID)
    assert(template, "ModelTile-initWithTiledID() failed to get the template model tile with param tiledID.")

    model.m_TiledID = tiledID
    if (model.m_Template == template) then
        return
    end

    model.m_Template = template

    ComponentManager.unbindAllComponents(model)
    ComponentManager.bindComponent(model, "GridIndexable")

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

    if (param.specialProperties) then
        for _, specialProperty in ipairs(param.specialProperties) do
            local component = ComponentManager.getComponent(model, specialProperty.name)
            assert(component, "ModelTile-loadInstanceProperties() attempting to overwrite a component that the model hasn't bound with.")
            component:load(specialProperty)
        end
    end
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelTile:ctor(param)
    if (param.tiledID) then
        initWithTiledID(self, param.tiledID)
    end

    loadInstanceProperties(self, param)

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelTile:initView()
    local view = self.m_View
    assert(view, "ModelTile:initView() no view is attached to the actor of the model.")

    self:setViewPositionWithGridIndex()
    view:updateWithTiledID(self.m_TiledID)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelTile:getTiledID()
    return self.m_TiledID
end

function ModelTile:getPlayerIndex()
    return toPlayerIndex(self.m_TiledID)
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

function ModelTile:getMoveCost(moveType, weather)
    return self.m_Template.moveCost[weather][moveType]
end

function ModelTile:getDescription()
    return self.m_Template.description
end

return ModelTile
