
local ModelWarField = class("ModelWarField")

local Actor        = require("global.actors.Actor")
local TypeChecker  = require("app.utilities.TypeChecker")
local GameConstant = require("res.data.GameConstant")

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
local function createCompositionActors(param)
    local warFieldData = requireFieldData(param)
    assert(TypeChecker.isWarFieldData(warFieldData))

    local tileMapActor = Actor.createWithModelAndViewName("ModelTileMap", warFieldData.TileMap, "ViewTileMap")
    assert(tileMapActor, "ModelWarField-createCompositionActors() failed to create the TileMap actor.")

    local unitMapActor = Actor.createWithModelAndViewName("ModelUnitMap", warFieldData.UnitMap, "ViewUnitMap")
    assert(unitMapActor, "ModelWarField-createCompositionActors() failed to create the UnitMap actor.")

    local actionPlannerActor = Actor.createWithModelAndViewName("ModelActionPlanner", nil, "ViewActionPlanner")
    assert(actionPlannerActor, "ModelWarField-createCompositionActors() failed to create the action planner actor.")

    local cursorActor = Actor.createWithModelAndViewName("ModelMapCursor", {mapSize = tileMapActor:getModel():getMapSize()}, "ViewMapCursor")
    assert(cursorActor, "ModelWarField-createCompositionActors() failed to create the cursor actor.")

    assert(TypeChecker.isSizeEqual(tileMapActor:getModel():getMapSize(), unitMapActor:getModel():getMapSize()))

    return {tileMapActor       = tileMapActor,
            unitMapActor       = unitMapActor,
            actionPlannerActor = actionPlannerActor,
            cursorActor        = cursorActor}
end

local function initWithCompositionActors(model, actors)
    model.m_TileMapActor       = actors.tileMapActor
    model.m_UnitMapActor       = actors.unitMapActor
    model.m_CursorActor        = actors.cursorActor

    model.m_ActionPlannerActor = actors.actionPlannerActor
    model.m_ActionPlannerActor:getModel():setTileMapModel(model.m_TileMapActor:getModel())
        :setUnitMapModel(model.m_UnitMapActor:getModel())
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelWarField:ctor(param)
    initWithCompositionActors(self, createCompositionActors(param))

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelWarField:initView()
    local view = self.m_View
    assert(TypeChecker.isView(view))

    view:setTileMapView(  self.m_TileMapActor:getView())
        :setUnitMapView(  self.m_UnitMapActor:getView())
        :setMapCursorView(self.m_CursorActor:getView())

        :setContentSizeWithMapSize(self.m_TileMapActor:getModel():getMapSize())

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node/script events.
--------------------------------------------------------------------------------
function ModelWarField:onEnter(rootActor)
    self.m_TileMapActor:onEnter(      rootActor)
    self.m_UnitMapActor:onEnter(      rootActor)
    self.m_CursorActor:onEnter(       rootActor)
    self.m_ActionPlannerActor:onEnter(rootActor)

    self.m_RootScriptEventDispatcher = rootActor:getModel():getScriptEventDispatcher()
    self.m_RootScriptEventDispatcher:addEventListener("EvtPlayerDragField", self)
        :addEventListener("EvtPlayerZoomField", self)
        :addEventListener("EvtGridSelected",   self)

    return self
end

function ModelWarField:onCleanup(rootActor)
    self.m_TileMapActor:onCleanup(      rootActor)
    self.m_UnitMapActor:onCleanup(      rootActor)
    self.m_CursorActor:onCleanup(       rootActor)
    self.m_ActionPlannerActor:onCleanup(rootActor)

    self.m_RootScriptEventDispatcher:removeEventListener("EvtGridSelected",   self)
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
    elseif (event.name == "EvtGridSelected") then

    end

    return self
end

return ModelWarField
