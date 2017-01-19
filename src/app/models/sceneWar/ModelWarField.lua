
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

local IS_SERVER               = require("src.app.utilities.GameConstantFunctions").isServer()
local TEMPLATE_WAR_FIELD_PATH = "res.data.templateWarField."

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
local function initActorFogMap(self, fogMapData, isTotalReplay)
    if (not self.m_ActorFogMap) then
        local modelFogMap  = Actor.createModel("sceneWar.ModelFogMap", fogMapData, self.m_WarFieldFileName, isTotalReplay)
        self.m_ActorFogMap = ((IS_SERVER) or (not isTotalReplay))                                        and
            (Actor.createWithModelAndViewInstance(modelFogMap))                                          or
            (Actor.createWithModelAndViewInstance(modelFogMap, Actor.createView("sceneWar.ViewFogMap")))
    else
        self.m_ActorFogMap:getModel():ctor(fogMapData, self.m_WarFieldFileName, isTotalReplay)
    end
end

local function initActorTileMap(self, tileMapData)
    if (not self.m_ActorTileMap) then
        local modelTileMap  = Actor.createModel("sceneWar.ModelTileMap", tileMapData, self.m_WarFieldFileName)
        self.m_ActorTileMap = (IS_SERVER)                                                                  and
            (Actor.createWithModelAndViewInstance(modelTileMap))                                           or
            (Actor.createWithModelAndViewInstance(modelTileMap, Actor.createView("sceneWar.ViewTileMap")))
    else
        self.m_ActorTileMap:getModel():ctor(tileMapData, self.m_WarFieldFileName)
    end
end

local function initActorUnitMap(self, unitMapData)
    if (not self.m_ActorUnitMap) then
        local modelUnitMap  = Actor.createModel("sceneWar.ModelUnitMap", unitMapData, self.m_WarFieldFileName)
        self.m_ActorUnitMap = (IS_SERVER)                                                                  and
            (Actor.createWithModelAndViewInstance(modelUnitMap))                                           or
            (Actor.createWithModelAndViewInstance(modelUnitMap, Actor.createView("sceneWar.ViewUnitMap")))
    else
        self.m_ActorUnitMap:getModel():ctor(unitMapData, self.m_WarFieldFileName)
    end
end

local function initActorActionPlanner(self)
    if (not self.m_ActorActionPlanner) then
        self.m_ActorActionPlanner = Actor.createWithModelAndViewName("sceneWar.ModelActionPlanner", nil, "sceneWar.ViewActionPlanner")
    end
end

local function initActorMapCursor(self, param)
    if (not self.m_ActorMapCursor) then
        self.m_ActorMapCursor = Actor.createWithModelAndViewName("sceneWar.ModelMapCursor", param, "sceneWar.ViewMapCursor")
    end
end

local function initActorGridEffect(self)
    if (not self.m_ActorGridEffect) then
        self.m_ActorGridEffect = Actor.createWithModelAndViewName("sceneWar.ModelGridEffect", nil, "sceneWar.ViewGridEffect")
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelWarField:ctor(warFieldData, isTotalReplay)
    self.m_WarFieldFileName = warFieldData.warFieldFileName
    initActorFogMap( self, warFieldData.fogMap,  isTotalReplay)
    initActorTileMap(self, warFieldData.tileMap)
    initActorUnitMap(self, warFieldData.unitMap)

    if (not IS_SERVER) then
        initActorActionPlanner(self)
        initActorMapCursor(    self, {mapSize = self:getModelTileMap():getMapSize()})
        initActorGridEffect(   self)
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

    local viewFogMap = self.m_ActorFogMap:getView()
    if (viewFogMap) then
        self.m_View:setViewFogMap(viewFogMap)
    end

    return self
end

--------------------------------------------------------------------------------
-- The functions for serialization.
--------------------------------------------------------------------------------
function ModelWarField:toSerializableTable()
    return {
        warFieldFileName = self.m_WarFieldFileName,
        fogMap           = self:getModelFogMap() :toSerializableTable(),
        tileMap          = self:getModelTileMap():toSerializableTable(),
        unitMap          = self:getModelUnitMap():toSerializableTable(),
    }
end

function ModelWarField:toSerializableTableForPlayerIndex(playerIndex)
    return {
        warFieldFileName = self.m_WarFieldFileName,
        fogMap           = self:getModelFogMap() :toSerializableTableForPlayerIndex(playerIndex),
        tileMap          = self:getModelTileMap():toSerializableTableForPlayerIndex(playerIndex),
        unitMap          = self:getModelUnitMap():toSerializableTableForPlayerIndex(playerIndex),
    }
end

function ModelWarField:toSerializableReplayData()
    return {warFieldFileName = self.m_WarFieldFileName}
end

--------------------------------------------------------------------------------
-- The callback functions on start running/script events.
--------------------------------------------------------------------------------
function ModelWarField:onStartRunning(modelSceneWar)
    self:getModelTileMap():onStartRunning(modelSceneWar)
    self:getModelUnitMap():onStartRunning(modelSceneWar)
    self:getModelFogMap() :onStartRunning(modelSceneWar)

    if (not IS_SERVER) then
        self.m_ActorActionPlanner:getModel():onStartRunning(modelSceneWar)
        self.m_ActorGridEffect   :getModel():onStartRunning(modelSceneWar)
        self.m_ActorMapCursor    :getModel():onStartRunning(modelSceneWar)

        self:getModelTileMap():updateOnModelFogMapStartedRunning()
    end

    SingletonGetters.getScriptEventDispatcher(modelSceneWar)
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
-- The public functions.
--------------------------------------------------------------------------------
function ModelWarField:getWarFieldDisplayName()
    return require(TEMPLATE_WAR_FIELD_PATH .. self.m_WarFieldFileName).warFieldName
end

function ModelWarField:getWarFieldAuthorName()
    return require(TEMPLATE_WAR_FIELD_PATH .. self.m_WarFieldFileName).authorName
end

function ModelWarField:getModelActionPlanner()
    return self.m_ActorActionPlanner:getModel()
end

function ModelWarField:getModelFogMap()
    return self.m_ActorFogMap:getModel()
end

function ModelWarField:getModelUnitMap()
    return self.m_ActorUnitMap:getModel()
end

function ModelWarField:getModelTileMap()
    return self.m_ActorTileMap:getModel()
end

function ModelWarField:getModelMapCursor()
    return self.m_ActorMapCursor:getModel()
end

function ModelWarField:getModelGridEffect()
    return self.m_ActorGridEffect:getModel()
end

return ModelWarField
