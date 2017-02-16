
local CModelTile = requireBW("src.global.functions.class")("CModelTile")

local GameConstantFunctions = requireBW("src.app.utilities.GameConstantFunctions")
local LocalizationFunctions = requireBW("src.app.utilities.LocalizationFunctions")
local SingletonGetters      = requireBW("src.app.utilities.SingletonGetters")
local VisibilityFunctions   = requireBW("src.app.utilities.VisibilityFunctions")
local ComponentManager      = requireBW("src.global.components.ComponentManager")

local string                       = string
local getTiledIdWithTileOrUnitName = GameConstantFunctions.getTiledIdWithTileOrUnitName
local isTileVisibleToPlayerIndex   = VisibilityFunctions.isTileVisibleToPlayerIndex

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function initWithTiledID(self, objectID, baseID)
    self.m_InitialObjectID = self.m_InitialObjectID or objectID
    self.m_InitialBaseID   = self.m_InitialBaseID   or baseID

    self.m_ObjectID = objectID or self.m_ObjectID
    self.m_BaseID   = baseID   or self.m_BaseID
    assert(self.m_ObjectID and self.m_BaseID, "CModelTile-initWithTiledID() failed to init self.m_ObjectID and/or self.m_BaseID.")

    local template = GameConstantFunctions.getTemplateModelTileWithObjectAndBaseId(self.m_ObjectID, self.m_BaseID)
    assert(template, "CModelTile-initWithTiledID() failed to get the template model tile with param objectID and baseID.")

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
            if (component.loadInstantialData) then
                component:loadInstantialData(data)
            end
        end
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function CModelTile:ctor(param)
    self.m_PositionIndex = param.positionIndex
    if ((param.objectID) or (param.baseID)) then
        initWithTiledID(self, param.objectID, param.baseID)
    end
    loadInstantialData(self, param)

    if (self.m_View) then
        self:initView()
    end

    return self
end

function CModelTile:initView()
    local view = self.m_View
    assert(view, "CModelTile:initView() no view is attached to the actor of the model.")

    self:setViewPositionWithGridIndex()
        :updateView()

    return self
end

function CModelTile:initHasFogOnClient(hasFog)
    assert(type(hasFog) == "boolean",               "CModelTile:initHasFogOnClient() invalid param hasFog.")
    assert(self.m_IsFogEnabledOnClient == nil,      "CModelTile:initHasFogOnClient() self.m_IsFogEnabledOnClient has been initialized already.")

    self.m_IsFogEnabledOnClient = hasFog
    return self
end

--------------------------------------------------------------------------------
-- The function for serialization.
--------------------------------------------------------------------------------
function CModelTile:toSerializableTable()
    local t               = {}
    local componentsCount = 0
    for name, component in pairs(ComponentManager.getAllComponents(self)) do
        if ((name ~= "GridIndexable") and (component.toSerializableTable)) then
            local componentTable = component:toSerializableTable()
            if (componentTable) then
                t[name]         = componentTable
                componentsCount = componentsCount + 1
            end
        end
    end

    local objectID, baseID = self:getObjectAndBaseId()
    if ((baseID == self.m_InitialBaseID) and (objectID == self.m_InitialObjectID) and (componentsCount == 0)) then
        return nil
    else
        t.positionIndex = self.m_PositionIndex
        t.baseID        = (baseID   ~= self.m_InitialBaseID)   and (baseID)   or (nil)
        t.objectID      = (objectID ~= self.m_InitialObjectID) and (objectID) or (nil)

        return t
    end
end

--------------------------------------------------------------------------------
-- The public callback function on start running.
--------------------------------------------------------------------------------
function CModelTile:onStartRunning(modelSceneCampaign)
    self.m_ModelSceneCampaign = modelSceneCampaign
    ComponentManager.callMethodForAllComponents(self, "onStartRunning", modelSceneCampaign)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function CModelTile:updateView()
    if (self.m_View) then
        self.m_View:setViewObjectWithTiledId(self.m_ObjectID)
            :setViewBaseWithTiledId(self.m_BaseID)
            :setFogEnabled(self.m_IsFogEnabledOnClient)
    end

    return self
end

function CModelTile:getPositionIndex()
    return self.m_PositionIndex
end

function CModelTile:getTiledId()
    return (self.m_ObjectID > 0) and (self.m_ObjectID) or (self.m_BaseID)
end

function CModelTile:getObjectAndBaseId()
    return self.m_ObjectID, self.m_BaseID
end

function CModelTile:getPlayerIndex()
    return GameConstantFunctions.getPlayerIndexWithTiledId(self:getTiledId())
end

function CModelTile:getTileType()
    return GameConstantFunctions.getTileTypeWithObjectAndBaseId(self:getObjectAndBaseId())
end

function CModelTile:getTileTypeFullName()
    return LocalizationFunctions.getLocalizedText(116, self:getTileType())
end

function CModelTile:getDescription()
    return LocalizationFunctions.getLocalizedText(117, self:getTileType())
end

function CModelTile:updateWithObjectAndBaseId(objectID, baseID)
    local gridIndex          = self:getGridIndex()
    baseID                   = baseID or self.m_BaseID

    initWithTiledID(self, objectID, baseID)
    loadInstantialData(self, {GridIndexable = {x = gridIndex.x, y = gridIndex.y}})
    self:onStartRunning(self.m_ModelSceneCampaign)

    return self
end

function CModelTile:destroyModelTileObject()
    assert(self.m_ObjectID > 0, "CModelTile:destroyModelTileObject() there's no tile object.")
    self:updateWithObjectAndBaseId(0, self.m_BaseID)

    return self
end

function CModelTile:destroyViewTileObject()
    if (self.m_View) then
        self.m_View:setViewObjectWithTiledId(0)
    end
end

function CModelTile:updateWithPlayerIndex(playerIndex)
    assert(self:getPlayerIndex() ~= playerIndex, "CModelTile:updateWithPlayerIndex() the param playerIndex is the same as the one of self.")

    local tileName = self:getTileType()
    if (tileName ~= "Headquarters") then
        self.m_ObjectID = getTiledIdWithTileOrUnitName(tileName, playerIndex)
    else
        local gridIndex           = self:getGridIndex()
        local currentCapturePoint = self:getCurrentCapturePoint()

        initWithTiledID(self, getTiledIdWithTileOrUnitName("City", playerIndex), self.m_BaseID)
        loadInstantialData(self, {
            GridIndexable = {x = gridIndex.x, y = gridIndex.y},
            Capturable    = {currentCapturePoint = currentCapturePoint},
        })
        self:onStartRunning(self.m_ModelSceneCampaign)
    end

    return self
end

function CModelTile:isFogEnabledOnClient()
    assert(type(self.m_IsFogEnabledOnClient) == "boolean", "CModelTile:isFogEnabledOnClient() self.m_IsFogEnabledOnClient has not been initialized yet.")

    return self.m_IsFogEnabledOnClient
end

function CModelTile:updateAsFogDisabled(data)
    if (self:isFogEnabledOnClient()) then
        self.m_IsFogEnabledOnClient = false

        if (not data) then
            self.m_ObjectID = self.m_InitialObjectID
            self.m_BaseID   = self.m_InitialBaseID
        else
            local objectID = data.objectID or self.m_InitialObjectID
            local baseID   = data.baseID   or self.m_InitialBaseID
            if ((objectID == self.m_ObjectID) and (baseID == self.m_BaseID)) then
                loadInstantialData(self, data)
            else
                initWithTiledID(self, objectID, baseID)
                loadInstantialData(self, data)
                self:onStartRunning(self.m_ModelSceneCampaign)
            end
        end
    end

    return self
end

function CModelTile:updateAsFogEnabled()
    if (not self:isFogEnabledOnClient()) then
        self.m_IsFogEnabledOnClient = true

        if (self.getCurrentCapturePoint) then
            local tileType = self:getTileType()
            if (tileType ~= "Headquarters") then
                self.m_ObjectID = getTiledIdWithTileOrUnitName(tileType, 0)
            end
        end

        ComponentManager.callMethodForAllComponents(self, "updateAsFogEnabled")
    end

    return self
end

return CModelTile
