
local ModelTileObject = class("ModelTileObject")

local ComponentManager      = require("global.components.ComponentManager")
local TypeChecker           = require("app.utilities.TypeChecker")
local GameConstantFunctions = require("app.utilities.GameConstantFunctions")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function initWithTiledID(self, objectID, baseID)
    self.m_ObjectID = objectID or self.m_ObjectID
    self.m_BaseID   = baseID   or self.m_BaseID
    assert(self.m_ObjectID > 0 and self.m_BaseID, "ModelTileObject-initWithTiledID() failed to init self.m_ObjectID and/or self.m_BaseID.")

    local template = GameConstantFunctions.getTemplateModelTileWithTiledId(self.m_ObjectID, self.m_BaseID)
    assert(template, "ModelTileObject-initWithTiledID() failed to get the template model tile with param objectID and baseID.")

    if (self.m_Template ~= template) then
        self.m_Template = template

        ComponentManager.unbindAllComponents(self)
        for name, data in pairs(template) do
            if (string.byte(name) > string.byte("z")) or (string.byte(name) < string.byte("a")) then
                ComponentManager.bindComponent(self, name, {template = data, instantialData = data})
            end
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
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelTileObject:ctor(param)
    if (param.objectID or param.baseID) then
        initWithTiledID(self, param.objectID, param.baseID)
    end

    loadInstantialData(self, param)

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelTileObject:initView()
    local view = self.m_View
    assert(view, "ModelTileObject:initView() no view is attached to the actor of the model.")

    self:setViewPositionWithGridIndex()
    view:updateWithTiledID(self.m_ObjectID)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelTileObject:getTiledID()
    return self.m_ObjectID
end

function ModelTileObject:getPlayerIndex()
    return GameConstantFunctions.getPlayerIndexWithTiledId(self:getTiledID())
end

function ModelTileObject:getDescription()
    return self.m_Template.description
end

return ModelTileObject
