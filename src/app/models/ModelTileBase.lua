
local ModelTileBase = class("ModelTileBase")

local ComponentManager      = require("global.components.ComponentManager")
local TypeChecker           = require("app.utilities.TypeChecker")
local GameConstantFunctions = require("app.utilities.GameConstantFunctions")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function initWithTiledID(self, objectID, baseID)
    self.m_ObjectID = objectID or self.m_ObjectID
    self.m_BaseID   = baseID   or self.m_BaseID
    assert(self.m_ObjectID and self.m_BaseID, "ModelTileBase-initWithTiledID() failed to init self.m_ObjectID and/or self.m_BaseID.")
    if (GameConstantFunctions.doesViewTileFillGrid(self.m_ObjectID)) then
        return
    end

    local template = GameConstantFunctions.getTemplateModelTileWithTiledId(self.m_ObjectID, self.m_BaseID)
    assert(template, "ModelTileBase-initWithTiledID() failed to get the template model tile with param objectID and baseID.")

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
    if (not GameConstantFunctions.doesViewTileFillGrid(self.m_ObjectID)) then
        for name, data in pairs(param) do
            if (string.byte(name) > string.byte("z")) or (string.byte(name) < string.byte("a")) then
                local component = ComponentManager.getComponent(self, name)
                assert(component, "ModelUnit-loadInstantialData() attempting to update a component that the model hasn't bound with.")

                component:loadInstantialData(data)
            end
        end
    end
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelTileBase:ctor(param)
    if (param.objectID or param.baseID) then
        initWithTiledID(self, param.objectID, param.baseID)
    end

    loadInstantialData(self, param)

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelTileBase:initView()
    local view = self.m_View
    assert(view, "ModelTileBase:initView() no view is attached to the actor of the model.")

    if (self.setViewPositionWithGridIndex) then
        self:setViewPositionWithGridIndex()
    end
    view:updateWithTiledID(self.m_BaseID) -- Show the view always makes the GL calls lower (even if the view would be overriden by the tile object)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelTileBase:getTiledID()
    return self.m_BaseID
end

function ModelTileBase:getPlayerIndex()
    return GameConstantFunctions.getPlayerIndexWithTiledId(self:getTiledID())
end

function ModelTileBase:getDescription()
    return self.m_Template.description
end

return ModelTileBase
