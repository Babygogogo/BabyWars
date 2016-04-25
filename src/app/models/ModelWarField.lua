
local ModelWarField = class("ModelWarField")

local Actor              = require("global.actors.Actor")
local TypeChecker        = require("app.utilities.TypeChecker")
local GameConstant       = require("res.data.GameConstant")
local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

local function requireFieldData(param)
    local t = type(param)
    if (t == "table") then
        return param
    elseif (t == "string") then
        return require("data.warField." .. param)
    else
        return nil
    end
end

--------------------------------------------------------------------------------
-- The comsition actors.
--------------------------------------------------------------------------------
local function createActorTileMap(tileMapData)
    return Actor.createWithModelAndViewName("ModelTileMap", tileMapData, "ViewTileMap")
end

local function initWithActorTileMap(self, actor)
    self.m_ActorTileMap = actor
end

local function createActorUnitMap(unitMapData)
    return Actor.createWithModelAndViewName("ModelUnitMap", unitMapData, "ViewUnitMap")
end

local function initWithActorUnitMap(self, actor)
    self.m_ActorUnitMap = actor
end

local function createActorActionPlanner()
    return Actor.createWithModelAndViewName("ModelActionPlanner", nil, "ViewActionPlanner")
end

local function initWithActorActionPlanner(self, actor)
    self.m_ActorActionPlanner = actor
    actor:getModel():setModelTileMap(self:getModelTileMap())
        :setModelUnitMap(self:getModelUnitMap())
end

local function createActorCursor(param)
    return Actor.createWithModelAndViewName("ModelMapCursor", param, "ViewMapCursor")
end

local function initWithActorCursor(self, actor)
    self.m_ActorCursor = actor
end

local function createActorGridExplosion()
    return Actor.createWithModelAndViewName("ModelGridExplosion", nil, "ViewGridExplosion")
end

local function initWithActorGridExplosion(self, actor)
    self.m_ActorGridExplosion = actor
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelWarField:ctor(param)
    local warFieldData = requireFieldData(param)
    assert(TypeChecker.isWarFieldData(warFieldData))

    initWithActorTileMap(      self, createActorTileMap(warFieldData.TileMap))
    initWithActorUnitMap(      self, createActorUnitMap(warFieldData.UnitMap))
    initWithActorActionPlanner(self, createActorActionPlanner())
    initWithActorCursor(       self, createActorCursor({mapSize = self:getModelTileMap():getMapSize()}))
    initWithActorGridExplosion(self, createActorGridExplosion())

    assert(TypeChecker.isSizeEqual(self:getModelTileMap():getMapSize(), self:getModelUnitMap():getMapSize()))

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelWarField:initView()
    local view = self.m_View
    assert(TypeChecker.isView(view))

    view:setViewTileMap(      self.m_ActorTileMap:getView())
        :setViewUnitMap(      self.m_ActorUnitMap:getView())
        :setViewActionPlanner(self.m_ActorActionPlanner:getView())
        :setViewMapCursor(    self.m_ActorCursor:getView())
        :setViewGridExplosion(self.m_ActorGridExplosion:getView())

        :setContentSizeWithMapSize(self.m_ActorTileMap:getModel():getMapSize())

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node/script events.
--------------------------------------------------------------------------------
function ModelWarField:onEnter(rootActor)
    self.m_ActorTileMap:onEnter(      rootActor)
    self.m_ActorUnitMap:onEnter(      rootActor)
    self.m_ActorCursor:onEnter(       rootActor)
    self.m_ActorActionPlanner:onEnter(rootActor)
    self.m_ActorGridExplosion:onEnter(rootActor)

    self.m_RootScriptEventDispatcher = rootActor:getModel():getScriptEventDispatcher()
    self.m_RootScriptEventDispatcher:addEventListener("EvtPlayerDragField", self)
        :addEventListener("EvtPlayerZoomField", self)
        :addEventListener("EvtPlayerSelectedGrid",   self)

    return self
end

function ModelWarField:onCleanup(rootActor)
    self.m_ActorTileMap:onCleanup(      rootActor)
    self.m_ActorUnitMap:onCleanup(      rootActor)
    self.m_ActorCursor:onCleanup(       rootActor)
    self.m_ActorActionPlanner:onCleanup(rootActor)
    self.m_ActorGridExplosion:onCleanup(rootActor)

    self.m_RootScriptEventDispatcher:removeEventListener("EvtPlayerSelectedGrid",   self)
        :removeEventListener("EvtPlayerZoomField", self)
        :removeEventListener("EvtPlayerDragField", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

function ModelWarField:onEvent(event)
    if (event.name == "EvtPlayerDragField") and (self.m_View) then
        self.m_View:setPositionOnDrag(event.previousPosition, event.currentPosition)
    elseif (event.name == "EvtPlayerZoomField") and (self.m_View) then
        local scrollEvent = event.scrollEvent
        self.m_View:setZoomWithScroll(cc.Director:getInstance():convertToGL(scrollEvent:getLocation()), scrollEvent:getScrollY())
    elseif (event.name == "EvtPlayerSelectedGrid") then

    end

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

function ModelWarField:doActionWait(action)
    self:getModelUnitMap():doActionWait(action)
    self:getModelTileMap():doActionWait(action)

    return self
end

function ModelWarField:doActionAttack(action)
    local modelUnitMap = self:getModelUnitMap()
    local modelTileMap = self:getModelTileMap()
    action.attacker = modelUnitMap:getModelUnit(action.path[1])

    local targetGridIndex = action.targetGridIndex
    local targetUnit = modelUnitMap:getModelUnit(targetGridIndex)
    if (targetUnit) then
        action.target, action.targetType = targetUnit,                                 "unit"
    else
        action.target, action.targetType = modelTileMap:getModelTile(targetGridIndex), "tile"
    end

    modelUnitMap:doActionAttack(action)
    modelTileMap:doActionAttack(action)

    return self
end

function ModelWarField:doActionCapture(action)
    local modelUnitMap = self:getModelUnitMap()
    local modelTileMap = self:getModelTileMap()

    local beginningGridIndex, endingGridIndex = action.path[1], action.path[#action.path]
    if (not GridIndexFunctions.isEqual(beginningGridIndex, endingGridIndex)) then
        local prevTarget = modelTileMap:getModelTile(beginningGridIndex)
        if (prevTarget.getCurrentCapturePoint) then
            action.prevTarget = prevTarget
        end
    end
    action.nextTarget = modelTileMap:getModelTile(endingGridIndex)
    action.capturer   = modelUnitMap:getModelUnit(beginningGridIndex)

    modelUnitMap:doActionCapture(action)
    modelTileMap:doActionCapture(action)

    return self
end

function ModelWarField:doActionProduceOnTile(action)
    self:getModelUnitMap():doActionProduceOnTile(action)

    return self
end

return ModelWarField
