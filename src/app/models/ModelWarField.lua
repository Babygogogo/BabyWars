
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
--     - MapCursor
--     - ActionPlanner
--     - GridExplosion
--]]--------------------------------------------------------------------------------

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
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtPlayerDragField(self, event)
    if (self.m_View) then
        self.m_View:setPositionOnDrag(event.previousPosition, event.currentPosition)
    end
end

local function onEvtPlayerZoomField(self, event)
    if (self.m_View) then
        local scrollEvent = event.scrollEvent
        self.m_View:setZoomWithScroll(cc.Director:getInstance():convertToGL(scrollEvent:getLocation()), scrollEvent:getScrollY())
    end
end

local function onEvtPlayerZoomFieldWithTouches(self, event)
    if (self.m_View) then
        self.m_View:setZoomWithTouches(event.touches)
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
    self.m_ActorMapCursor = actor
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
        :setViewMapCursor(    self.m_ActorMapCursor:getView())
        :setViewGridExplosion(self.m_ActorGridExplosion:getView())

        :setContentSizeWithMapSize(self.m_ActorTileMap:getModel():getMapSize())

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node/script events.
--------------------------------------------------------------------------------
function ModelWarField:onEnter(rootActor)
    local dispatcher = rootActor:getModel():getScriptEventDispatcher()
    self.m_ActorTileMap:onEnter(      rootActor)
    self.m_ActorUnitMap:onEnter(      rootActor)
    self.m_ActorMapCursor    :getModel():setRootScriptEventDispatcher(dispatcher)
    self.m_ActorActionPlanner:getModel():setRootScriptEventDispatcher(dispatcher)
    self.m_ActorGridExplosion:getModel():setRootScriptEventDispatcher(dispatcher)

    self.m_RootScriptEventDispatcher = dispatcher
    self.m_RootScriptEventDispatcher:addEventListener("EvtPlayerDragField", self)
        :addEventListener("EvtPlayerZoomField",            self)
        :addEventListener("EvtPlayerZoomFieldWithTouches", self)

    return self
end

function ModelWarField:onCleanup(rootActor)
    self.m_ActorTileMap:onCleanup(      rootActor)
    self.m_ActorUnitMap:onCleanup(      rootActor)
    self.m_ActorMapCursor    :getModel():unsetRootScriptEventDispatcher()
    self.m_ActorActionPlanner:getModel():unsetRootScriptEventDispatcher()
    self.m_ActorGridExplosion:getModel():unsetRootScriptEventDispatcher()

    self.m_RootScriptEventDispatcher:removeEventListener("EvtPlayerZoomFieldWithTouches",   self)
        :removeEventListener("EvtPlayerZoomField", self)
        :removeEventListener("EvtPlayerDragField", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

function ModelWarField:onEvent(event)
    local eventName = event.name
    if (eventName == "EvtPlayerDragField") then
        onEvtPlayerDragField(self, event)
    elseif (eventName == "EvtPlayerZoomField") then
        onEvtPlayerZoomField(self, event)
    elseif (eventName == "EvtPlayerZoomFieldWithTouches") then
        onEvtPlayerZoomFieldWithTouches(self, event)
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
