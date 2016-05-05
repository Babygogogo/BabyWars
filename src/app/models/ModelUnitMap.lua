
--[[--------------------------------------------------------------------------------
-- ModelUnitMap是战场上的ModelUnit组成的矩阵，类似于ModelTileMap与ModelTile的关系。
--
-- 主要职责和使用场景举例：
--   构造unit矩阵，维护相关数值，提供接口给外界访问
--
-- 其他：
--   - ModelUnitMap的数据文件
--     与ModelTileMap不同，对于ModelUnitMap而言，数据文件中的“模板”的用处相对较小。
--     这是因为所有种类的ModelUnit都具有“非模板”的属性，所以即使使用了模板，数据文件也还是要配上大量的instantialData才能描述整个ModelUnitMap。
--     但模板也并非完全无用。考虑某些地图一开始就已经为对战各方配置了满状态的unit，那么这时候，模板就可以派上用场了。
--
--     综上，ModelUnitMap在构造还是会读入模板数据，但保存为数据文件时时就不保留模板数据了，而只保存instantialData。
--
--   - ModelUnitMap中，其他的许多概念都和ModelTileMap很相似，直接参照ModelTileMap即可。
--]]--------------------------------------------------------------------------------

local ModelUnitMap = class("ModelUnitMap")

local TypeChecker        = require("app.utilities.TypeChecker")
local MapFunctions       = require("app.utilities.MapFunctions")
local ViewUnit           = require("app.views.ViewUnit")
local ModelUnit          = require("app.models.ModelUnit")
local GridIndexFunctions = require("app.utilities.GridIndexFunctions")
local Actor              = require("global.actors.Actor")

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

local function createEmptyMap(width)
    local map = {}
    for x = 1, width do
        map[x] = {}
    end

    return map
end

local function createActorUnit(tiledID, unitID, gridIndex)
    local actorData = {
        tiledID       = tiledID,
        unitID        = unitID,
        GridIndexable = {gridIndex = gridIndex},
    }

    return Actor.createWithModelAndViewName("ModelUnit", actorData, "ViewUnit", actorData)
end

--------------------------------------------------------------------------------
-- The callback functions on EvtPlayerMovedCursor/EvtPlayerSelectedGrid.
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
local function createUnitActorsMapWithTiledLayer(layer)
    local width, height = layer.width, layer.height
    local map    = createEmptyMap(width)
    local unitID = 0

    for x = 1, width do
        for y = 1, height do
            local tiledID = layer.data[x + (height - y) * width]
            unitID = unitID + 1
            if (tiledID > 0) then
                map[x][y] = createActorUnit(tiledID, unitID, {x = x, y = y})
            end
        end
    end

    return map, {width = width, height = height}, unitID
end

local function updateUnitActorsMapWithGridsData(map, mapSize, gridsData)
    local unitID = 0
    for _, gridData in ipairs(gridsData) do
        unitID = math.max(gridData.unitID or unitID, unitID)
        local gridIndex = gridData.GridIndexable.gridIndex
        assert(GridIndexFunctions.isWithinMap(gridIndex, mapSize), "ModelTileMap-updateUnitActorsMapWithGridsData() the data of overwriting grid is invalid.")
        map[gridIndex.x][gridIndex.y]:getModel():ctor(gridData)
    end

    return unitID
end

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
    --[[
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
    --]]
    local map, mapSize, unitID = createUnitActorsMapWithTiledLayer(getTiledUnitLayer(mapData))
    unitID = math.max(updateUnitActorsMapWithGridsData(map, mapSize, mapData.grids or {}), unitID) + 1

    return map, mapSize, unitID
end

local function createUnitActorsMap(param)
    local mapData = requireMapData(param)
    if (mapData.template == nil) then
        return createUnitActorsMapWithoutTemplate(mapData)
    else
        return createUnitActorsMapWithTemplate(mapData)
    end
end

local function initWithUnitActorsMap(self, map, mapSize, unitID)
    self.m_UnitActorsMap   = map
    self.m_MapSize         = mapSize
    self.m_AvailableUnitID = unitID
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
        :addEventListener("EvtPlayerSelectedGrid", self)
        :addEventListener("EvtTurnPhaseBeginning", self)
        :addEventListener("EvtDestroyModelUnit",   self)
        :addEventListener("EvtDestroyViewUnit",    self)

    self:forEachModelUnit(function(modelUnit)
        modelUnit:setRootScriptEventDispatcher(self.m_RootScriptEventDispatcher)
    end)

    return self
end

function ModelUnitMap:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtDestroyViewUnit", self)
        :removeEventListener("EvtDestroyModelUnit",   self)
        :removeEventListener("EvtTurnPhaseBeginning", self)
        :removeEventListener("EvtPlayerSelectedGrid", self)
        :removeEventListener("EvtPlayerMovedCursor",  self)
    self.m_RootScriptEventDispatcher = nil

    self:forEachModelUnit(function(modelUnit)
        modelUnit:unsetRootScriptEventDispatcher()
    end)

    return self
end

function ModelUnitMap:onEvent(event)
    local name = event.name
    if ((name == "EvtPlayerMovedCursor") or
        (name == "EvtPlayerSelectedGrid")) then
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
    return self.m_MapSize
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

function ModelUnitMap:forEachModelUnit(func)
    local mapSize = self:getMapSize()
    for x = 1, mapSize.width do
        for y = 1, mapSize.height do
            local actorUnit = self.m_UnitActorsMap[x][y]
            if (actorUnit) then
                func(actorUnit:getModel())
            end
        end
    end

    return self
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
    swapActorUnit(self, path[1], path[#path])

    action.attacker:doActionAttack(action, true)
    if (action.targetType == "unit") then
        action.target:doActionAttack(action, false)
    end

    return self
end

function ModelUnitMap:doActionCapture(action)
    local path = action.path
    local beginningGridIndex, endingGridIndex = path[1], path[#path]
    swapActorUnit(self, beginningGridIndex, endingGridIndex)

    local modelUnit = self:getModelUnit(endingGridIndex)
    modelUnit:doActionCapture(action)
    if (not GridIndexFunctions.isEqual(beginningGridIndex, endingGridIndex)) then
        self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtModelUnitMoved", modelUnit = modelUnit})
    end

    return self
end

function ModelUnitMap:doActionProduceOnTile(action)
    local gridIndex = action.gridIndex
    local actorUnit = createActorUnit(action.tiledID, self.m_AvailableUnitID, gridIndex)
    actorUnit:getModel():setRootScriptEventDispatcher(self.m_RootScriptEventDispatcher)
        :setStateActioned()
        :updateView()

    self.m_AvailableUnitID = self.m_AvailableUnitID + 1
    self.m_UnitActorsMap[gridIndex.x][gridIndex.y] = actorUnit
    if (self.m_View) then
        self.m_View:addViewUnit(actorUnit:getView(), gridIndex)
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtModelUnitProduced", modelUnit = actorUnit:getModel()})

    return self
end

return ModelUnitMap
