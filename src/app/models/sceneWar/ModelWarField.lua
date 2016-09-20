
--[[--------------------------------------------------------------------------------
-- ModelWarField是战局场景中除了UI元素以外的其他元素的集合。
--
-- 主要职责和使用场景举例：
--   ModelWarField自身功能不多，更多的是扮演了各个子actor的容器的角色。
--
-- 其他：
--   - ModelWarField目前包括以下子actor：
--     - TileMap
--     - UnitMap
--     - MapCursor（server不含）
--     - ActionPlanner（server不含）
--     - GridEffect（server不含）
--]]--------------------------------------------------------------------------------

local ModelWarField = require("src.global.functions.class")("ModelWarField")

local SingletonGetters = require("src.app.utilities.SingletonGetters")
local Actor            = require("src.global.actors.Actor")

local IS_SERVER = require("src.app.utilities.GameConstantFunctions").isServer()

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtDragField(self, event)
    if (self.m_View) then
        self.m_View:setPositionOnDrag(event.previousPosition, event.currentPosition)
    end
end

local function onEvtZoomFieldWithScroll(self, event)
    if (self.m_View) then
        local scrollEvent = event.scrollEvent
        self.m_View:setZoomWithScroll(cc.Director:getInstance():convertToGL(scrollEvent:getLocation()), scrollEvent:getScrollY())
    end
end

local function onEvtZoomFieldWithTouches(self, event)
    if (self.m_View) then
        self.m_View:setZoomWithTouches(event.touches)
    end
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initActorTileMap(self, tileMapData)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelTileMap", tileMapData, "sceneWar.ViewTileMap")

    self.m_ActorTileMap = actor
end

local function initActorUnitMap(self, unitMapData)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelUnitMap", unitMapData, "sceneWar.ViewUnitMap")

    self.m_ActorUnitMap = actor
end

local function initActorActionPlanner(self)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelActionPlanner", nil, "sceneWar.ViewActionPlanner")

    self.m_ActorActionPlanner = actor
end

local function initActorMapCursor(self, param)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelMapCursor", param, "sceneWar.ViewMapCursor")

    self.m_ActorMapCursor = actor
end

local function initActorGridEffect(self)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelGridEffect", nil, "sceneWar.ViewGridEffect")

    self.m_ActorGridEffect = actor
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelWarField:ctor(warFieldData)
    initActorTileMap(self, warFieldData.tileMap)
    initActorUnitMap(self, warFieldData.unitMap)

    local tileMapSize = self:getModelTileMap():getMapSize()
    local unitMapSize = self:getModelUnitMap():getMapSize()
    assert((tileMapSize.width == unitMapSize.width) and (tileMapSize.height == unitMapSize.height))

    if (not IS_SERVER) then
        initActorActionPlanner(self)
        initActorMapCursor(    self, {mapSize = self:getModelTileMap():getMapSize()})
        initActorGridEffect(   self)
    end

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelWarField:initView()
    assert(self.m_View, "ModelWarField:initView() no view is attached to the owner actor of the model.")
    self.m_View:setViewTileMap(self.m_ActorTileMap      :getView())
        :setViewUnitMap(       self.m_ActorUnitMap      :getView())
        :setViewActionPlanner( self.m_ActorActionPlanner:getView())
        :setViewMapCursor(     self.m_ActorMapCursor    :getView())
        :setViewGridEffect(    self.m_ActorGridEffect   :getView())

        :setContentSizeWithMapSize(self:getModelTileMap():getMapSize())

    return self
end

--------------------------------------------------------------------------------
-- The functions for serialization.
--------------------------------------------------------------------------------
function ModelWarField:toSerializableTable()
    return {
        tileMap = self:getModelTileMap():toSerializableTable(),
        unitMap = self:getModelUnitMap():toSerializableTable(),
    }
end

--------------------------------------------------------------------------------
-- The callback functions on start running/script events.
--------------------------------------------------------------------------------
function ModelWarField:onStartRunning(sceneWarFileName)
    self:getModelTileMap():onStartRunning(sceneWarFileName)
    self:getModelUnitMap():onStartRunning(sceneWarFileName)
    if (not IS_SERVER) then
        self.m_ActorActionPlanner:getModel():onStartRunning(sceneWarFileName)
        self.m_ActorGridEffect   :getModel():onStartRunning(sceneWarFileName)
        self.m_ActorMapCursor    :getModel():onStartRunning(sceneWarFileName)
    end

    SingletonGetters.getScriptEventDispatcher(sceneWarFileName)
        :addEventListener("EvtDragField",            self)
        :addEventListener("EvtZoomFieldWithScroll",  self)
        :addEventListener("EvtZoomFieldWithTouches", self)

    return self
end

function ModelWarField:onEvent(event)
    local eventName = event.name
    if     (eventName == "EvtDragField")            then onEvtDragField(           self, event)
    elseif (eventName == "EvtZoomFieldWithScroll")  then onEvtZoomFieldWithScroll( self, event)
    elseif (eventName == "EvtZoomFieldWithTouches") then onEvtZoomFieldWithTouches(self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions for doing actions.
--------------------------------------------------------------------------------
function ModelWarField:doActionSurrender(action)
    local modelUnitMap        = self:getModelUnitMap()
    local lostPlayerIndex     = action.lostPlayerIndex
    local lostUnitGridIndexes = {}

    modelUnitMap:forEachModelUnitOnMap(function(modelUnit)
        if (modelUnit:getPlayerIndex() == lostPlayerIndex) then
            lostUnitGridIndexes[#lostUnitGridIndexes + 1] = modelUnit:getGridIndex()
        end
    end)
    action.lostUnitGridIndexes = lostUnitGridIndexes

    self:getModelUnitMap():doActionSurrender(action)
    self:getModelTileMap():doActionSurrender(action)

    return self
end

function ModelWarField:doActionAttack(action, callbackOnAttackAnimationEnded)
    local modelUnitMap    = self:getModelUnitMap()
    local modelTileMap    = self:getModelTileMap()
    local targetGridIndex = action.targetGridIndex
    local attackTarget    = modelUnitMap:getModelUnit(targetGridIndex) or modelTileMap:getModelTile(targetGridIndex)

    modelUnitMap:doActionAttack(action, attackTarget, callbackOnAttackAnimationEnded)
    modelTileMap:doActionAttack(action, attackTarget)

    return self
end

function ModelWarField:doActionCaptureModelTile(action, callbackOnCaptureAnimationEnded)
    local modelUnitMap = self:getModelUnitMap()
    local modelTileMap = self:getModelTileMap()
    local path         = action.path
    local target       = modelTileMap:getModelTile(path[#path])

    modelUnitMap:doActionCaptureModelTile(action, target, callbackOnCaptureAnimationEnded)
    modelTileMap:doActionCaptureModelTile(action, target)

    return self
end

function ModelWarField:doActionProduceModelUnitOnUnit(action)
    self:getModelUnitMap():doActionProduceModelUnitOnUnit(action)
    self:getModelTileMap():doActionProduceModelUnitOnUnit(action)

    return self
end

function ModelWarField:doActionSupplyModelUnit(action)
    self:getModelUnitMap():doActionSupplyModelUnit(action)
    self:getModelTileMap():doActionSupplyModelUnit(action)

    return self
end

function ModelWarField:doActionLoadModelUnit(action)
    self:getModelUnitMap():doActionLoadModelUnit(action)
    self:getModelTileMap():doActionLoadModelUnit(action)

    return self
end

function ModelWarField:doActionDropModelUnit(action)
    self:getModelUnitMap():doActionDropModelUnit(action)
    self:getModelTileMap():doActionDropModelUnit(action)

    return self
end

function ModelWarField:doActionProduceOnTile(action)
    self:getModelUnitMap():doActionProduceOnTile(action)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelWarField:getModelUnitMap()
    return self.m_ActorUnitMap:getModel()
end

function ModelWarField:getModelTileMap()
    return self.m_ActorTileMap:getModel()
end

function ModelWarField:clearPlayerForce(playerIndex)
    self:doActionSurrender({
        lostPlayerIndex = playerIndex,
    })

    return self
end

return ModelWarField
