
local CModelWarField = requireBW("src.global.functions.class")("CModelWarField")

local SingletonGetters = requireBW("src.app.utilities.SingletonGetters")
local Actor            = requireBW("src.global.actors.Actor")

local CC_DIRECTOR             = cc.Director:getInstance()
local IS_SERVER               = requireBW("src.app.utilities.GameConstantFunctions").isServer()
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
        self.m_View:setZoomWithScroll(CC_DIRECTOR:convertToGL(scrollEvent:getLocation()), scrollEvent:getScrollY())
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
local function initActorFogMap(self, fogMapData)
    self.m_ActorFogMap = Actor.createWithModelAndViewInstance(Actor.createModel("sceneWar.ModelFogMap", fogMapData, self.m_WarFieldFileName))
end

local function initActorTileMap(self, tileMapData)
    self.m_ActorTileMap = Actor.createWithModelAndViewInstance(
        Actor.createModel("sceneCampaign.CModelTileMap", tileMapData, self.m_WarFieldFileName),
        Actor.createView("sceneWar.ViewTileMap")
    )
end

local function initActorUnitMap(self, unitMapData)
    self.m_ActorUnitMap = Actor.createWithModelAndViewInstance(
        Actor.createModel("sceneWar.ModelUnitMap", unitMapData, self.m_WarFieldFileName),
        Actor.createView("sceneWar.ViewUnitMap")
    )
end

local function initActorActionPlanner(self)
    self.m_ActorActionPlanner = Actor.createWithModelAndViewName("sceneCampaign.CModelActionPlanner", nil, "sceneWar.ViewActionPlanner")
end

local function initActorMapCursor(self, param)
    self.m_ActorMapCursor = Actor.createWithModelAndViewName("sceneWar.ModelMapCursor", param, "sceneWar.ViewMapCursor")
end

local function initActorGridEffect(self)
    self.m_ActorGridEffect = Actor.createWithModelAndViewName("sceneWar.ModelGridEffect", nil, "sceneWar.ViewGridEffect")
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function CModelWarField:ctor(warFieldData)
    self.m_WarFieldFileName = warFieldData.warFieldFileName
    initActorFogMap(       self, warFieldData.fogMap)
    initActorTileMap(      self, warFieldData.tileMap)
    initActorUnitMap(      self, warFieldData.unitMap)
    initActorActionPlanner(self)
    initActorMapCursor(    self, {mapSize = self:getModelTileMap():getMapSize()})
    initActorGridEffect(   self)

    return self
end

function CModelWarField:initView()
    assert(self.m_View, "CModelWarField:initView() no view is attached to the owner actor of the model.")
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
function CModelWarField:toSerializableTable()
    return {
        warFieldFileName = self.m_WarFieldFileName,
        fogMap           = self:getModelFogMap() :toSerializableTable(),
        tileMap          = self:getModelTileMap():toSerializableTable(),
        unitMap          = self:getModelUnitMap():toSerializableTable(),
    }
end

--------------------------------------------------------------------------------
-- The callback functions on start running/script events.
--------------------------------------------------------------------------------
function CModelWarField:onStartRunning(modelSceneWar)
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

function CModelWarField:onEvent(event)
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
function CModelWarField:getWarFieldDisplayName()
    return requireBW(TEMPLATE_WAR_FIELD_PATH .. self.m_WarFieldFileName).warFieldName
end

function CModelWarField:getWarFieldAuthorName()
    return requireBW(TEMPLATE_WAR_FIELD_PATH .. self.m_WarFieldFileName).authorName
end

function CModelWarField:getModelActionPlanner()
    return self.m_ActorActionPlanner:getModel()
end

function CModelWarField:getModelFogMap()
    return self.m_ActorFogMap:getModel()
end

function CModelWarField:getModelUnitMap()
    return self.m_ActorUnitMap:getModel()
end

function CModelWarField:getModelTileMap()
    return self.m_ActorTileMap:getModel()
end

function CModelWarField:getModelMapCursor()
    return self.m_ActorMapCursor:getModel()
end

function CModelWarField:getModelGridEffect()
    return self.m_ActorGridEffect:getModel()
end

return CModelWarField
