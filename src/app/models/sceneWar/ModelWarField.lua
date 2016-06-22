
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
local GridIndexFunctions = require("app.utilities.GridIndexFunctions")
local TableFunctions     = require("app.utilities.TableFunctions")

local IS_SERVER = false

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
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

    actor:getModel():setModelTileMap(self:getModelTileMap())
        :setModelUnitMap(self:getModelUnitMap())
    self.m_ActorActionPlanner = actor
end

local function initActorMapCursor(self, param)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelMapCursor", param, "sceneWar.ViewMapCursor")

    self.m_ActorMapCursor = actor
end

local function initActorGridExplosion(self)
    local actor = Actor.createWithModelAndViewName("sceneWar.ModelGridExplosion", nil, "sceneWar.ViewGridExplosion")

    self.m_ActorGridExplosion = actor
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelWarField:ctor(param)
    local warFieldData = requireFieldData(param)
    assert(TypeChecker.isWarFieldData(warFieldData))

    initActorTileMap(self, warFieldData.tileMap)
    initActorUnitMap(self, warFieldData.unitMap)
    if (not IS_SERVER) then
        initActorActionPlanner(self)
        initActorMapCursor(    self, {mapSize = self:getModelTileMap():getMapSize()})
        initActorGridExplosion(self)
    end

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

function ModelWarField:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelWarField:setRootScriptEventDispatcher() the dispatcher has been set.")

    self.m_ActorTileMap:getModel():setRootScriptEventDispatcher(dispatcher)
    self.m_ActorUnitMap:getModel():setRootScriptEventDispatcher(dispatcher)
    if (not IS_SERVER) then
        self.m_ActorMapCursor    :getModel():setRootScriptEventDispatcher(dispatcher)
        self.m_ActorActionPlanner:getModel():setRootScriptEventDispatcher(dispatcher)
        self.m_ActorGridExplosion:getModel():setRootScriptEventDispatcher(dispatcher)
    end

    self.m_RootScriptEventDispatcher = dispatcher
    dispatcher:addEventListener("EvtDragField",      self)
        :addEventListener("EvtZoomFieldWithScroll",  self)
        :addEventListener("EvtZoomFieldWithTouches", self)

    return self
end

function ModelWarField:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "ModelWarField:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")

    self.m_ActorTileMap:getModel():unsetRootScriptEventDispatcher()
    self.m_ActorUnitMap:getModel():unsetRootScriptEventDispatcher()
    if (not IS_SERVER) then
        self.m_ActorMapCursor    :getModel():unsetRootScriptEventDispatcher()
        self.m_ActorActionPlanner:getModel():unsetRootScriptEventDispatcher()
        self.m_ActorGridExplosion:getModel():unsetRootScriptEventDispatcher()
    end

    self.m_RootScriptEventDispatcher:removeEventListener("EvtZoomFieldWithTouches", self)
        :removeEventListener("EvtZoomFieldWithScroll", self)
        :removeEventListener("EvtDragField",           self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

--------------------------------------------------------------------------------
-- The functions for serialization.
--------------------------------------------------------------------------------
function ModelWarField:toStringList(spaces)
    spaces = spaces or ""
    local subSpaces = spaces .. "    "
    local strList = {spaces .. "warField = {\n"}

    local appendList = TableFunctions.appendList
    appendList(strList, self:getModelTileMap():toStringList(subSpaces), ",\n")
    appendList(strList, self:getModelUnitMap():toStringList(subSpaces), "\n" .. spaces .. "}")

    return strList
end

function ModelWarField:toSerializableTable()
    return {
        tileMap = self:getModelTileMap():toSerializableTable(),
        unitMap = self:getModelUnitMap():toSerializableTable(),
    }
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
function ModelWarField:onEvent(event)
    local eventName = event.name
    if (eventName == "EvtDragField") then
        onEvtDragField(self, event)
    elseif (eventName == "EvtZoomFieldWithScroll") then
        onEvtZoomFieldWithScroll(self, event)
    elseif (eventName == "EvtZoomFieldWithTouches") then
        onEvtZoomFieldWithTouches(self, event)
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

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelWarField:getModelUnitMap()
    return self.m_ActorUnitMap:getModel()
end

function ModelWarField:getModelTileMap()
    return self.m_ActorTileMap:getModel()
end

function ModelWarField:getModelActionPlanner()
    return self.m_ActorActionPlanner:getModel()
end

return ModelWarField
