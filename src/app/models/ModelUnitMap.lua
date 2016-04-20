
local ModelUnitMap = class("ModelUnitMap")

local TypeChecker        = require("app.utilities.TypeChecker")
local MapFunctions       = require("app.utilities.MapFunctions")
local ViewUnit           = require("app.views.ViewUnit")
local ModelUnit          = require("app.models.ModelUnit")
local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function requireMapData(param)
    local t = type(param)
    if (t == "string") then
        return require("data.unitMap." .. param)
    elseif (t == "table") then
        return param
    else
        return error("ModelUnitMap-requireMapData() the param is invalid.")
    end
end

local function getTiledUnitLayer(tiledData)
    return tiledData.layers[3]
end

local function iterateAllActorUnits(self, func)
    for x = 1, self.m_UnitActorsMap.size.width do
        for y = 1, self.m_UnitActorsMap.size.height do
            local actorUnit = self.m_UnitActorsMap[x][y]
            if (actorUnit) then
                func(actorUnit)
            end
        end
    end
end

local function setActorUnit(self, actor, gridIndex)
    self.m_UnitActorsMap[gridIndex.x][gridIndex.y] = actor
    if (actor) then
        actor:getModel():setGridIndex(gridIndex, false)
    end
end

local function swapActorUnit(self, gridIndex1, gridIndex2)
    if (GridIndexFunctions.isEqual(gridIndex1, gridIndex2)) then
        return
    end

    local actorUnit1, actorUnit2 = self:getActorUnit(gridIndex1), self:getActorUnit(gridIndex2)
    setActorUnit(self, actorUnit1, gridIndex2)
    setActorUnit(self, actorUnit2, gridIndex1)

    if (self.m_View) then
        self.m_View:swapViewUnit(gridIndex1, gridIndex2)
    end
end

--------------------------------------------------------------------------------
-- The callback functions on EvtPlayerMovedCursor.
--------------------------------------------------------------------------------
local function onEvtPlayerMovedCursor(self, event)
    local unitModel = self:getModelUnit(event.gridIndex)
    if (unitModel) then
        self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtPlayerTouchUnit", modelUnit = unitModel})
    else
        self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtPlayerTouchNoUnit"})
    end
end

--------------------------------------------------------------------------------
-- The callback functions on EvtDestroyModelUnit/EvtDestroyViewUnit.
--------------------------------------------------------------------------------
local function onEvtDestroyModelUnit(self, event)
    local gridIndex = event.gridIndex
    local actorUnit = self:getActorUnit(gridIndex)
    assert(actorUnit, "ModelUnitMap-onEvtDestroyModelUnit() there is no unit on event.gridIndex.")

    setActorUnit(self, nil, gridIndex)
    actorUnit:getModel():unsetRootScriptEventDispatcher()
end

local function onEvtDestroyViewUnit(self, event)
    if (self.m_View) then
        self.m_View:removeViewUnit(event.gridIndex)
    end
end

--------------------------------------------------------------------------------
-- The unit actors map.
--------------------------------------------------------------------------------
local function createUnitActorsMapWithTemplate(mapData)
    assert(type(mapData.template) == "string", "ModelUnitMap-createUnitActorsMapWithTemplate() the param mapData.template is expected to be a file name.")
    local templateTiledLayer = getTiledUnitLayer(requireMapData(mapData.template))
    assert(templateTiledLayer, "ModelUnitMap-createUnitActorsMapWithTemplate() the template of the param mapData is expected to have a tiled layer.")

    local map = MapFunctions.createGridActorsMapWithTiledLayer(templateTiledLayer, "ModelUnit", "ViewUnit")
    assert(map, "ModelUnitMap-createUnitActorsMapWithTemplate() failed to create the template unit actors map.")

    if (mapData.grids) then
        map = MapFunctions.updateGridActorsMapWithGridsData(map, mapData.grids, "ModelUnit", "ViewUnit")
        assert(map, "ModelUnitMap-createUnitActorsMapWithTemplate() failed to update the unit actors map with the param mapData.grids.")
    end

    map.m_TemplateName = mapData.template
    map.m_Name         = mapData.name

    return map
end

local function createUnitActorsMapWithoutTemplate(mapData)
    local tiledLayer = getTiledUnitLayer(mapData)
    local map
    if (not tiledLayer) then
        map = MapFunctions.createGridActorsMapWithMapData(mapData.grids, "ModelUnit", "ViewUnit")
        assert(map, "ModelUnitMap-createUnitActorsMapWithoutTemplate() failed to create the map with the param mapData.grids")
    else
        map = MapFunctions.createGridActorsMapWithTiledLayer(tiledLayer, "ModelUnit", "ViewUnit")
        assert(map, "ModelUnitMap-createUnitActorsMapWithoutTemplate() failed to create the map with the tiled layer within the param.")

        if (mapData.grids) then
            map = MapFunctions.updateGridActorsMapWithGridsData(map, mapData.grids, "ModelUnit", "ViewUnit")
            assert(map, "ModelUnitMap-createUnitActorsMapWithTemplate() failed to update the unit actors map with the param mapData.grids.")
        end
    end

    map.m_Name = mapData.name

    return map
end

local function createUnitActorsMap(param)
    local mapData = requireMapData(param)
    local unitActorsMap =(mapData.template == nil) and
        createUnitActorsMapWithoutTemplate(mapData) or
        createUnitActorsMapWithTemplate(mapData)
    assert(unitActorsMap, "ModelUnitMap--createUnitActorsMap() failed to create the unit actors map.")

    return unitActorsMap, unitActorsMap.size
end

local function initWithUnitActorsMap(self, map, mapSize)
    self.m_UnitActorsMap = map
    self.m_MapSize       = mapSize
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelUnitMap:ctor(param)
    initWithUnitActorsMap(self, createUnitActorsMap(param))

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelUnitMap:initView()
    local view = self.m_View
    assert(view, "ModelUnitMap:initView() there's no view attached to the owner actor of the model.")

    local mapSize = self.m_MapSize
    view:setMapSize(mapSize)
        :removeAllViewUnits()

    local unitActors = self.m_UnitActorsMap
    for y = mapSize.height, 1, -1 do
        for x = mapSize.width, 1, -1 do
            local unitActor = unitActors[x][y]
            if (unitActor) then
                view:addViewUnit(unitActor:getView(), {x = x, y = y})
            end
        end
    end

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node/script events.
--------------------------------------------------------------------------------
function ModelUnitMap:onEnter(rootActor)
    self.m_RootScriptEventDispatcher = rootActor:getModel():getScriptEventDispatcher()
    self.m_RootScriptEventDispatcher:addEventListener("EvtPlayerMovedCursor", self)
        :addEventListener("EvtTurnPhaseBeginning", self)
        :addEventListener("EvtDestroyModelUnit",   self)
        :addEventListener("EvtDestroyViewUnit",    self)

    iterateAllActorUnits(self, function(actor)
        actor:getModel():setRootScriptEventDispatcher(self.m_RootScriptEventDispatcher)
    end)

    return self
end

function ModelUnitMap:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtDestroyViewUnit", self)
        :removeEventListener("EvtDestroyModelUnit",   self)
        :removeEventListener("EvtTurnPhaseBeginning", self)
        :removeEventListener("EvtPlayerMovedCursor",  self)
    self.m_RootScriptEventDispatcher = nil

    iterateAllActorUnits(self, function(actor)
        actor:getModel():unsetRootScriptEventDispatcher()
    end)

    return self
end

function ModelUnitMap:onEvent(event)
    local name = event.name
    if (name == "EvtPlayerMovedCursor") then
        onEvtPlayerMovedCursor(self, event)
    elseif (name == "EvtTurnPhaseBeginning") then
        self.m_PlayerIndex = event.playerIndex
    elseif (name == "EvtDestroyModelUnit") then
        onEvtDestroyModelUnit(self, event)
    elseif (name == "EvtDestroyViewUnit") then
        onEvtDestroyViewUnit(self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelUnitMap:getMapSize()
    return self.m_UnitActorsMap.size
end

function ModelUnitMap:getActorUnit(gridIndex)
    if (not GridIndexFunctions.isWithinMap(gridIndex, self:getMapSize())) then
        return nil
    else
        return self.m_UnitActorsMap[gridIndex.x][gridIndex.y]
    end
end

function ModelUnitMap:getModelUnit(gridIndex)
    local unitActor = self:getActorUnit(gridIndex)
    return unitActor and unitActor:getModel() or nil
end

function ModelUnitMap:doActionWait(action)
    local path = action.path
    local beginningGridIndex, endingGridIndex = path[1], path[#path]

    swapActorUnit(self, beginningGridIndex, endingGridIndex)

    local modelUnit = self:getModelUnit(endingGridIndex)
    modelUnit:doActionWait(action)
    if (not GridIndexFunctions.isEqual(beginningGridIndex, endingGridIndex)) then
        self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtModelUnitMoved", modelUnit = modelUnit})
    end

    return self
end

function ModelUnitMap:doActionAttack(action)
    local path = action.path
    local beginningGridIndex, endingGridIndex = path[1], path[#path]

    swapActorUnit(self, beginningGridIndex, endingGridIndex)
    action.attacker:doActionAttack(action, true)
    if (action.targetType == "unit") then
        action.target:doActionAttack(action, false)
    end

    return self
end

return ModelUnitMap
