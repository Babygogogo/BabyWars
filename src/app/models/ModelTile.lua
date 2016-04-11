
local ModelTile = class("ModelTile")

local ComponentManager      = require("global.components.ComponentManager")
local TypeChecker           = require("app.utilities.TypeChecker")
local GameConstantFunctions = require("app.utilities.GameConstantFunctions")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function initWithTiledID(self, objectID, baseID)
    objectID = objectID or self.m_ObjectID
    baseID   = baseID   or self.m_BaseID
    local template = GameConstantFunctions.getTemplateModelTileWithTiledId(objectID, baseID)
    assert(template, "ModelTile-initWithTiledID() failed to get the template model tile with param objectID and baseID.")

    self.m_ObjectID, self.m_BaseID = objectID, baseID
    if (self.m_Template == template) then
        return
    end
    self.m_Template = template

    ComponentManager.unbindAllComponents(self)
    for name, data in pairs(template) do
        if (string.byte(name) > string.byte("z")) or (string.byte(name) < string.byte("a")) then
            ComponentManager.bindComponent(self, name, {template = data, instantialData = data})
        end
    end

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
    for name, data in pairs(param) do
        if (string.byte(name) > string.byte("z")) or (string.byte(name) < string.byte("a")) then
            local component = ComponentManager.getComponent(self, name)
            assert(component, "ModelUnit-loadInstantialData() attempting to update a component that the model hasn't bound with.")

            component:loadInstantialData(data)
        end
    end

    if (param.specialProperties) then
        for _, specialProperty in ipairs(param.specialProperties) do
            local component = ComponentManager.getComponent(self, specialProperty.name)
            assert(component, "ModelTile-loadInstantialData() attempting to overwrite a component that the model hasn't bound with.")
            component:load(specialProperty)
        end
    end
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelTile:ctor(param)
    if (param.objectID or param.baseID) then
        initWithTiledID(self, param.objectID, param.baseID)
    end

    loadInstantialData(self, param)

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelTile:initView()
    local view = self.m_View
    assert(view, "ModelTile:initView() no view is attached to the actor of the model.")

    self:setViewPositionWithGridIndex()
    view:updateWithTiledID(self.m_ObjectID, self.m_BaseID)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelTile:getTiledID()
    return (self.m_ObjectID and self.m_ObjectID > 0) and (self.m_ObjectID) or (self.m_BaseID)
end

function ModelTile:getObjectID()
    return self.m_ObjectID
end

function ModelTile:getBaseID()
    return self.m_BaseID
end

function ModelTile:getPlayerIndex()
    return GameConstantFunctions.getPlayerIndexWithTiledId(self:getTiledID())
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
    return self.m_Template.moveCost[moveType]
end

function ModelTile:getDescription()
    return self.m_Template.description
end

return ModelTile
