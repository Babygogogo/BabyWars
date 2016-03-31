
local ModelUnitMap = class("ModelUnitMap")

local TypeChecker        = require("app.utilities.TypeChecker")
local MapFunctions       = require("app.utilities.MapFunctions")
local ViewUnit           = require("app.views.ViewUnit")
local ModelUnit          = require("app.models.ModelUnit")
local GridSize           = require("res.data.GameConstant").GridSize
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
    return tiledData.layers[2]
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

    return unitActorsMap
end

local function initWithUnitActorsMap(model, map)
    model.m_UnitActorsMap = map
end

--------------------------------------------------------------------------------
-- The constructor.
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
    assert(TypeChecker.isView(view))

    view:removeAllChildren()

    local unitActors = self.m_UnitActorsMap
    local mapSize = unitActors.size
    for y = mapSize.height, 1, -1 do
        for x = mapSize.width, 1, -1 do
            local unitActor = unitActors[x][y]
            if (unitActor) then
                view:addChild(unitActor:getView())
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

    iterateAllActorUnits(self, function(actor)
        actor:getModel():setRootScriptEventDispatcher(self.m_RootScriptEventDispatcher)
    end)

    return self
end

function ModelUnitMap:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtTurnPhaseBeginning", self)
        :removeEventListener("EvtPlayerMovedCursor", self)
    self.m_RootScriptEventDispatcher = nil

    iterateAllActorUnits(self, function(actor)
        actor:getModel():unsetRootScriptEventDispatcher()
    end)

    return self
end

function ModelUnitMap:onEvent(event)
    if (event.name == "EvtPlayerMovedCursor") then
        local unitModel = self:getModelUnit(event.gridIndex)
        if (unitModel) then
            self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtPlayerTouchUnit", unitModel = unitModel})
        else
            self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtPlayerTouchNoUnit"})
        end
    elseif (event.name == "EvtTurnPhaseBeginning") then
        self.m_PlayerIndex = event.playerIndex
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
    local path               = action.path
    -- HACK: sometimes the path is modified mysteriously after calling actorFocusUnit:getModel():doActionWait(action)
    -- and the value of path[1] will become the same as path[#path].
    -- so I clone them for later use.
    local beginningGridIndex = GridIndexFunctions.clone(path[1])
    local endingGridIndex    = GridIndexFunctions.clone(path[path.length])
    local actorFocusUnit     = self:getActorUnit(beginningGridIndex)

    self.m_UnitActorsMap[beginningGridIndex.x][beginningGridIndex.y] = nil
    self.m_UnitActorsMap[endingGridIndex.x   ][endingGridIndex.y   ] = actorFocusUnit

    actorFocusUnit:getModel():doActionWait(action)

    return self
end

return ModelUnitMap
