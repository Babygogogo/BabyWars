
local ModelTile = class("ModelTile")

local ComponentManager      = require("global.components.ComponentManager")
local TypeChecker           = require("app.utilities.TypeChecker")
local GameConstantFunctions = require("app.utilities.GameConstantFunctions")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function initWithTiledID(self, objectID, baseID)
    self.m_ObjectID = objectID or self.m_ObjectID
    self.m_BaseID   = baseID   or self.m_BaseID
    assert(self.m_ObjectID and self.m_BaseID, "ModelTile-initWithTiledID() failed to init self.m_ObjectID and/or self.m_BaseID.")

    local template = GameConstantFunctions.getTemplateModelTileWithTiledId(self.m_ObjectID, self.m_BaseID)
    assert(template, "ModelTile-initWithTiledID() failed to get the template model tile with param objectID and baseID.")

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
-- The constructor and initializers.
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
        :updateView()

    return self
end

function ModelTile:setRootScriptEventDispatcher(dispatcher)
    self:unsetRootScriptEventDispatcher()
    self.m_RootScriptEventDispatcher = dispatcher

    for _, component in pairs(ComponentManager.getAllComponents(self)) do
        if (component.setRootScriptEventDispatcher) then
            component:setRootScriptEventDispatcher(dispatcher)
        end
    end

    return self
end

function ModelTile:unsetRootScriptEventDispatcher(dispatcher)
    if (self.m_RootScriptEventDispatcher) then
        self.m_RootScriptEventDispatcher = nil

        for _, component in pairs(ComponentManager.getAllComponents(self)) do
            if (component.unsetRootScriptEventDispatcher) then
                component:unsetRootScriptEventDispatcher()
            end
        end
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelTile:updateView()
    if (self.m_View) then
        self.m_View:setViewObjectWithTiledId(self.m_ObjectID)
            :setViewBaseWithTiledId(self.m_BaseID)
    end

    return self
end

function ModelTile:getTiledID()
    return (self.m_ObjectID > 0) and (self.m_ObjectID) or (self.m_BaseID)
end

function ModelTile:getPlayerIndex()
    return GameConstantFunctions.getPlayerIndexWithTiledId(self:getTiledID())
end

function ModelTile:getDescription()
    return self.m_Template.description
end

function ModelTile:destroyModelTileObject()
    assert(self.m_ObjectID > 0, "ModelTile:destroyModelTileObject() there's no tile object.")

    local gridIndex, dispatcher = self:getGridIndex(), self.m_RootScriptEventDispatcher
    self:unsetRootScriptEventDispatcher()
    initWithTiledID(self, 0, self.m_BaseID)
    loadInstantialData(self, {GridIndexable = {gridIndex = gridIndex}})
    self:setRootScriptEventDispatcher(dispatcher)

    dispatcher:dispatchEvent({name = "EvtModelTileUpdated", modelTile = self})

    return self
end

function ModelTile:destroyViewTileObject()
    if (self.m_View) then
        self.m_View:setViewObjectWithTiledId(0)
    end
end

function ModelTile:updateCapturer(playerIndex)
    assert(self:getPlayerIndex() ~= playerIndex, "ModelTile:updateCapturer() the param playerIndex is the same as the one of self.")
    self.m_ObjectID = GameConstantFunctions.getTiledIdWithTileOrUnitName(GameConstantFunctions.getTileNameWithTiledId(self:getTiledID()), playerIndex)

    return self
end

function ModelTile:doActionAttack(action, isAttacker)
    assert(not isAttacker, "ModelTile:doActionAttack() the param is invalid.")
    for _, component in pairs(ComponentManager.getAllComponents(self)) do
        if (component.doActionAttack) then
            component:doActionAttack(action, isAttacker)
        end
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtModelTileUpdated", modelTile = self})

    return self
end

function ModelTile:doActionCapture(action)
    for _, component in pairs(ComponentManager.getAllComponents(self)) do
        if (component.doActionCapture) then
            component:doActionCapture(action)
        end
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtModelTileUpdated", modelTile = self})

    return self
end

return ModelTile
