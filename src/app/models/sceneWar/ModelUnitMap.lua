
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
local GridIndexFunctions = require("app.utilities.GridIndexFunctions")
local TableFunctions     = require("app.utilities.TableFunctions")
local Actor              = require("global.actors.Actor")

local TEMPLATE_WAR_FIELD_PATH          = "data.templateWarField."
local GRID_INDEX_FOR_LOADED_MODEL_UNIT = {x = 0, y = 0}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function requireMapData(param)
    local t = type(param)
    if (t == "string") then
        return require(TEMPLATE_WAR_FIELD_PATH .. param)
    elseif (t == "table") then
        return param
    else
        return error("ModelUnitMap-requireMapData() the param is invalid.")
    end
end

local function getTiledUnitLayer(tiledData)
    return tiledData.layers[3]
end

local function getLoadedActorUnitWithUnitId(self, unitID)
    return self.m_LoadedActorUnits[unitID]
end

local function getLoadedModelUnits(self, loaderModelUnit)
    if (not loaderModelUnit.getLoadUnitIdList) then
        return nil
    else
        local list = {}
        for _, unitID in ipairs(loaderModelUnit:getLoadUnitIdList()) do
            list[#list + 1] = self:getLoadedModelUnitWithUnitId(unitID)
        end

        return list
    end
end

local function setActorUnit(self, actor, gridIndex)
    self.m_UnitActorsMap[gridIndex.x][gridIndex.y] = actor
    if (actor) then
        actor:getModel():setGridIndex(gridIndex, false)
    end
end

local function setActorUnitLoaded(self, gridIndex)
    local focusActorUnit = self:getActorUnit(gridIndex)
    local focusModelUnit = focusActorUnit:getModel()
    local focusUnitID    = focusModelUnit:getUnitId()

    self.m_LoadedActorUnits[focusUnitID] = focusActorUnit
    focusModelUnit:setGridIndex(GRID_INDEX_FOR_LOADED_MODEL_UNIT, false)
    setActorUnit(self, nil, gridIndex)

    if (self.m_View) then
        self.m_View:setViewUnitLoaded(gridIndex, focusUnitID)
    end
end

local function setActorUnitUnloaded(self, unitID, gridIndex)
    local actorUnit = getLoadedActorUnitWithUnitId(self, unitID)
    self.m_LoadedActorUnits[unitID] = nil
    setActorUnit(self, actorUnit, gridIndex)

    if (self.m_View) then
        self.m_View:setViewUnitUnloaded(gridIndex, unitID)
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

    return Actor.createWithModelAndViewName("sceneWar.ModelUnit", actorData, "sceneWar.ViewUnit", actorData)
end

--------------------------------------------------------------------------------
-- The private functions for dispatching events.
--------------------------------------------------------------------------------
local function dispatchEvtModelUnitUpdated(self, modelUnit, previousGridIndex)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name              = "EvtModelUnitUpdated",
        modelUnit         = modelUnit,
        loadedModelUnits  = getLoadedModelUnits(self, modelUnit),
        previousGridIndex = previousGridIndex,
    })
end

local function dispatchEvtPreviewModelUnit(self, modelUnit)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name             = "EvtPreviewModelUnit",
        modelUnit        = modelUnit,
        loadedModelUnits = getLoadedModelUnits(self, modelUnit)
    })
end

local function dispatchEvtPreviewNoModelUnit(self, gridIndex)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name      = "EvtPreviewNoModelUnit",
        gridIndex = gridIndex,
    })
end

--------------------------------------------------------------------------------
-- The private functions for serialization.
--------------------------------------------------------------------------------
local function serializeMapSizeToStringList(mapSize, spaces)
    return {string.format("%smapSize = {width = %d, height = %d}", spaces, mapSize.width, mapSize.height)}
end

local function serializeAvailableUnitIdToStringList(self, spaces)
    return {string.format("%savailableUnitId = %d", spaces, self.m_AvailableUnitID)}
end

local function serializeModelUnitsOnMapToStringList(self, spaces)
    spaces = spaces or ""
    local subSpaces = spaces .. "    "
    local strList = {spaces .. "grids = {\n"}
    local appendList = TableFunctions.appendList

    self:forEachModelUnitOnMap(function(modelUnit)
        appendList(strList, modelUnit:toStringList(subSpaces), ",\n")
    end)
    strList[#strList + 1] = spaces .. "}"

    return strList
end

local function serializeLoadedModelUnitsToStringList(self, spaces)
    -- TODO: add code to do the job.
    return {spaces .. "loaded = {}"}
end

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtMapCursorMoved(self, event)
    local gridIndex        = event.gridIndex
    self.m_CursorGridIndex = GridIndexFunctions.clone(gridIndex)

    local modelUnit = self:getModelUnit(gridIndex)
    if (modelUnit) then
        dispatchEvtPreviewModelUnit(self, modelUnit)
    else
        dispatchEvtPreviewNoModelUnit(self, gridIndex)
    end
end

local function onEvtDestroyModelUnit(self, event)
    local gridIndex = event.gridIndex
    local modelUnit = self:getModelUnit(gridIndex)
    assert(modelUnit, "ModelUnitMap-onEvtDestroyModelUnit() there is no unit on event.gridIndex.")

    if (modelUnit.getLoadUnitIdList) then
        for _, unitID in pairs(modelUnit:getLoadUnitIdList()) do
            self.m_LoadedActorUnits[unitID]:getModel():unsetRootScriptEventDispatcher()
            self.m_LoadedActorUnits[unitID] = nil
        end
    end

    setActorUnit(self, nil, gridIndex)
    modelUnit:unsetRootScriptEventDispatcher()
end

local function onEvtDestroyViewUnit(self, event)
    if (self.m_View) then
        self.m_View:removeViewUnit(event.gridIndex)
    end
end

local function onEvtTurnPhaseMain(self, event)
    local modelUnit = self:getModelUnit(self.m_CursorGridIndex)
    if (modelUnit) then
        dispatchEvtModelUnitUpdated(self, modelUnit)
    else
        dispatchEvtPreviewNoModelUnit(self, self.m_CursorGridIndex)
    end
end

--------------------------------------------------------------------------------
-- The unit actors map.
--------------------------------------------------------------------------------
local function createUnitActorsMapWithTiledLayer(layer)
    local width, height = layer.width, layer.height
    local map    = createEmptyMap(width)
    local availableUnitId = 1

    for x = 1, width do
        for y = 1, height do
            local tiledID = layer.data[x + (height - y) * width]
            if (tiledID > 0) then
                map[x][y] = createActorUnit(tiledID, availableUnitId, {x = x, y = y})
                availableUnitId = availableUnitId + 1
            end
        end
    end

    return map, {width = width, height = height}, availableUnitId
end

local function createUnitActorsMapWithGridsData(gridsData, mapSize)
    local map = createEmptyMap(mapSize.width)

    for _, gridData in ipairs(gridsData) do
        local gridIndex = gridData.GridIndexable.gridIndex
        assert(GridIndexFunctions.isWithinMap(gridIndex, mapSize), "ModelUnitMap-createUnitActorsMapWithGridsData() the gridIndex is invalid.")

        map[gridIndex.x][gridIndex.y] = Actor.createWithModelAndViewName("sceneWar.ModelUnit", gridData, "sceneWar.ViewUnit", gridData)
    end

    return map
end

local function createUnitActorsMapWithTemplate(mapData)
    -- If the map is created with template, then the mapData.grids is ignored.
    local templateMapData = requireMapData(mapData.template)
    local map, mapSize, availableUnitId = createUnitActorsMapWithTiledLayer(getTiledUnitLayer(templateMapData))

    return map, mapSize, availableUnitId, {}
end

local function createUnitActorsMapWithoutTemplate(mapData)
    -- If the map is created without template, then we build the map with mapData.grids only.
    local map = createUnitActorsMapWithGridsData(mapData.grids, mapData.mapSize)
    local loadedActorUnits = {}
    for unitID, unitData in pairs(mapData.loaded or {}) do
        loadedActorUnits[unitID] = Actor.createWithModelAndViewName("sceneWar.ModelUnit", unitData, "sceneWar.ViewUnit", unitData)
    end

    return map, mapData.mapSize, mapData.availableUnitId, loadedActorUnits
end

local function createUnitActorsMap(param)
    local mapData = requireMapData(param)
    if (mapData.template) then
        return createUnitActorsMapWithTemplate(mapData)
    else
        return createUnitActorsMapWithoutTemplate(mapData)
    end
end

local function initWithUnitActorsMap(self, map, mapSize, unitID, loadedActorUnits)
    self.m_UnitActorsMap    = map
    self.m_MapSize          = mapSize
    self.m_AvailableUnitID  = unitID
    self.m_LoadedActorUnits = loadedActorUnits
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelUnitMap:ctor(param)
    self.m_CursorGridIndex = {x = 1, y = 1}
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

    for unitID, actorUnit in pairs(self.m_LoadedActorUnits) do
        view:addLoadedViewUnit(unitID, actorUnit:getView())
    end

    return self
end

function ModelUnitMap:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelUnitMap:setRootScriptEventDispatcher() the dispatcher has been set.")

    self.m_RootScriptEventDispatcher = dispatcher
    dispatcher:addEventListener("EvtMapCursorMoved", self)
        :addEventListener("EvtGridSelected",       self)
        :addEventListener("EvtDestroyModelUnit",   self)
        :addEventListener("EvtDestroyViewUnit",    self)
        :addEventListener("EvtTurnPhaseMain",      self)

    local setEventDispatcher = function(modelUnit)
        modelUnit:setRootScriptEventDispatcher(dispatcher)
    end
    self:forEachModelUnitOnMap(setEventDispatcher)
        :forEachModelUnitLoaded(setEventDispatcher)

    return self
end

function ModelUnitMap:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "ModelUnitMap:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")

    self.m_RootScriptEventDispatcher:removeEventListener("EvtTurnPhaseMain", self)
        :removeEventListener("EvtDestroyViewUnit",  self)
        :removeEventListener("EvtDestroyModelUnit", self)
        :removeEventListener("EvtGridSelected",     self)
        :removeEventListener("EvtMapCursorMoved",   self)
    self.m_RootScriptEventDispatcher = nil

    local unsetEventDispatcher = function(modelUnit)
        modelUnit:unsetRootScriptEventDispatcher()
    end
    self:forEachModelUnitOnMap(unsetEventDispatcher)
        :forEachModelUnitLoaded(unsetEventDispatcher)

    return self
end

--------------------------------------------------------------------------------
-- The function for serialization.
--------------------------------------------------------------------------------
function ModelUnitMap:toStringList(spaces)
    spaces = spaces or ""
    local subSpaces = spaces .. "    "
    local strList = {spaces .. "unitMap = {\n"}
    local appendList = TableFunctions.appendList

    appendList(strList, serializeMapSizeToStringList(self:getMapSize(), subSpaces), ",\n")
    appendList(strList, serializeAvailableUnitIdToStringList(self, subSpaces),      ",\n")
    appendList(strList, serializeModelUnitsOnMapToStringList(self, subSpaces),      ",\n")
    appendList(strList, serializeLoadedModelUnitsToStringList(self, subSpaces),     "\n" .. spaces .. "}")

    return strList
end

function ModelUnitMap:toSerializableTable()
    local grids = {}
    self:forEachModelUnitOnMap(function(modelUnit)
        grids[#grids + 1] = modelUnit:toSerializableTable()
    end)

    local loaded = {}
    for unitID, actorUnit in pairs(self.m_LoadedActorUnits) do
        loaded[unitID] = actorUnit:getModel():toSerializableTable()
    end

    return {
        mapSize        = {
            width  = self.m_MapSize.width,
            height = self.m_MapSize.height,
        },
        availableUnitId = self.m_AvailableUnitID,
        grids           = grids,
        loaded          = loaded,
    }
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
function ModelUnitMap:onEvent(event)
    local name = event.name
    if ((name == "EvtMapCursorMoved") or
        (name == "EvtGridSelected")) then
        onEvtMapCursorMoved(self, event)
    elseif (name == "EvtDestroyModelUnit") then
        onEvtDestroyModelUnit(self, event)
    elseif (name == "EvtDestroyViewUnit") then
        onEvtDestroyViewUnit(self, event)
    elseif (name == "EvtTurnPhaseMain") then
        onEvtTurnPhaseMain(self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions for doing actions.
--------------------------------------------------------------------------------
function ModelUnitMap:doActionSurrender(action)
    local eventDispatcher = self.m_RootScriptEventDispatcher
    for _, gridIndex in ipairs(action.lostUnitGridIndexes) do
        eventDispatcher:dispatchEvent({
            name      = "EvtDestroyModelUnit",
            gridIndex = gridIndex,
        })
        eventDispatcher:dispatchEvent({
            name      = "EvtDestroyViewUnit",
            gridIndex = gridIndex,
        })
    end

    return self
end


function ModelUnitMap:doActionWait(action)
    local launchUnitID = action.launchUnitID
    local path         = action.path
    local beginningGridIndex, endingGridIndex = path[1], path[#path]

    if (launchUnitID) then
        self:getModelUnit(beginningGridIndex):doActionLaunchModelUnit(action)
        setActorUnitUnloaded(self, launchUnitID, endingGridIndex)
    else
        swapActorUnit(self, beginningGridIndex, endingGridIndex)
    end

    local focusModelUnit = self:getModelUnit(endingGridIndex)
    focusModelUnit:doActionMoveModelUnit(action)
        :doActionWait(action)
    dispatchEvtModelUnitUpdated(self, focusModelUnit, beginningGridIndex)

    return self
end

function ModelUnitMap:doActionAttack(action, attacker, target)
    local launchUnitID = action.launchUnitID
    local path         = action.path
    local beginningGridIndex, endingGridIndex = path[1], path[#path]

    if (launchUnitID) then
        self:getModelUnit(beginningGridIndex):doActionLaunchModelUnit(action)
        setActorUnitUnloaded(self, launchUnitID, endingGridIndex)
    else
        swapActorUnit(self, beginningGridIndex, endingGridIndex)
    end

    attacker:doActionMoveModelUnit(action)
        :doActionAttack(action, attacker, target)
    dispatchEvtModelUnitUpdated(self, attacker, beginningGridIndex)

    if (target.getUnitType) then
        target:doActionAttack(action, attacker, target)
        dispatchEvtModelUnitUpdated(self, target)
    end

    return self
end

function ModelUnitMap:doActionCapture(action, capturer, target)
    local launchUnitID = action.launchUnitID
    local path         = action.path
    local beginningGridIndex, endingGridIndex = path[1], path[#path]

    if (launchUnitID) then
        self:getModelUnit(beginningGridIndex):doActionLaunchModelUnit(action)
        setActorUnitUnloaded(self, launchUnitID, endingGridIndex)
    else
        swapActorUnit(self, beginningGridIndex, endingGridIndex)
    end

    capturer:doActionMoveModelUnit(action)
        :doActionCapture(action, capturer, target)
    dispatchEvtModelUnitUpdated(self, capturer, beginningGridIndex)

    return self
end

function ModelUnitMap:doActionLoadModelUnit(action)
    local launchUnitID = action.launchUnitID
    local path         = action.path
    local beginningGridIndex, endingGridIndex = path[1], path[#path]
    local focusModelUnit

    if (launchUnitID) then
        focusModelUnit = self:getLoadedModelUnitWithUnitId(launchUnitID)
        self:getModelUnit(beginningGridIndex):doActionLaunchModelUnit(action)
    else
        focusModelUnit = self:getModelUnit(beginningGridIndex)
        setActorUnitLoaded(self, beginningGridIndex)
    end

    local focusUnitID     = focusModelUnit:getUnitId()
    local loaderModelUnit = self:getModelUnit(endingGridIndex)
    focusModelUnit:doActionMoveModelUnit(action)
        :doActionLoadModelUnit(action, focusUnitID, loaderModelUnit)
    loaderModelUnit:doActionLoadModelUnit(action, focusUnitID, loaderModelUnit)

    dispatchEvtModelUnitUpdated(self, focusModelUnit, beginningGridIndex)
    dispatchEvtModelUnitUpdated(self, loaderModelUnit)

    return self
end

function ModelUnitMap:doActionDropModelUnit(action)
    local launchUnitID = action.launchUnitID
    local path         = action.path
    local beginningGridIndex, endingGridIndex = path[1], path[#path]
    local focusModelUnit

    if (launchUnitID) then
        focusModelUnit = self:getLoadedModelUnitWithUnitId(launchUnitID)
        self:getModelUnit(beginningGridIndex):doActionLaunchModelUnit(action)
        setActorUnitUnloaded(self, launchUnitID, endingGridIndex)
    else
        focusModelUnit = self:getModelUnit(beginningGridIndex)
        swapActorUnit(self, beginningGridIndex, endingGridIndex)
    end

    local droppingActorUnits = {}
    for _, dropDestination in ipairs(action.dropDestinations) do
        local unitID    = dropDestination.unitID
        local gridIndex = dropDestination.gridIndex
        local actorUnit = getLoadedActorUnitWithUnitId(self, unitID)
        local modelUnit = actorUnit:getModel()

        droppingActorUnits[#droppingActorUnits + 1] = actorUnit
        setActorUnitUnloaded(self, unitID, gridIndex)
        modelUnit:doActionDropModelUnit(action)
        dispatchEvtModelUnitUpdated(self, modelUnit, gridIndex)
    end

    focusModelUnit:doActionMoveModelUnit(action)
        :doActionDropModelUnit(action, droppingActorUnits)
    dispatchEvtModelUnitUpdated(self, focusModelUnit, beginningGridIndex)

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

    self.m_RootScriptEventDispatcher:dispatchEvent({
        name      = "EvtModelUnitProduced",
        modelUnit = actorUnit:getModel()
    })

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

function ModelUnitMap:getLoadedModelUnitWithUnitId(unitID)
    local actorUnit = getLoadedActorUnitWithUnitId(self, unitID)
    return (actorUnit) and (actorUnit:getModel()) or (nil)
end

function ModelUnitMap:forEachModelUnitOnMap(func)
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

function ModelUnitMap:forEachModelUnitLoaded(func)
    for _, actorUnit in pairs(self.m_LoadedActorUnits) do
        func(actorUnit:getModel())
    end

    return self
end

return ModelUnitMap
