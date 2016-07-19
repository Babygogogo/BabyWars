
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

local ModelUnitMap = require("src.global.functions.class")("ModelUnitMap")

local TypeChecker        = require("src.app.utilities.TypeChecker")
local GridIndexFunctions = require("src.app.utilities.GridIndexFunctions")
local TableFunctions     = require("src.app.utilities.TableFunctions")
local Actor              = require("src.global.actors.Actor")

local TEMPLATE_WAR_FIELD_PATH = "res.data.templateWarField."

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

local function getSupplyTargetModelUnits(self, supplier, supplierGridIndex)
    local targets = {}
    for _, gridIndex in pairs(GridIndexFunctions.getAdjacentGrids(supplierGridIndex, self:getMapSize())) do
        local target = self:getModelUnit(gridIndex)
        if ((target) and (supplier:canSupplyModelUnit(target))) then
            targets[#targets + 1] = target
        end
    end

    return targets
end

local function setActorUnitLoaded(self, gridIndex)
    local focusActorUnit = self:getActorUnit(gridIndex)
    local focusUnitID    = focusActorUnit:getModel():getUnitId()

    self.m_LoadedActorUnits[focusUnitID]           = focusActorUnit
    self.m_UnitActorsMap[gridIndex.x][gridIndex.y] = nil

    if (self.m_View) then
        self.m_View:setViewUnitLoaded(gridIndex, focusUnitID)
    end
end

local function setActorUnitUnloaded(self, unitID, gridIndex)
    self.m_UnitActorsMap[gridIndex.x][gridIndex.y] = self.m_LoadedActorUnits[unitID]
    self.m_LoadedActorUnits[unitID]                = nil

    if (self.m_View) then
        self.m_View:setViewUnitUnloaded(gridIndex, unitID)
    end
end

local function swapActorUnit(self, gridIndex1, gridIndex2)
    if (GridIndexFunctions.isEqual(gridIndex1, gridIndex2)) then
        return
    end

    local tempActorUnit = self.m_UnitActorsMap[gridIndex1.x][gridIndex1.y]
    self.m_UnitActorsMap[gridIndex1.x][gridIndex1.y] = self.m_UnitActorsMap[gridIndex2.x][gridIndex2.y]
    self.m_UnitActorsMap[gridIndex2.x][gridIndex2.y] = tempActorUnit

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
local function dispatchEvtModelUnitMapUpdated(self)
    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtModelUnitMapUpdated"})
end

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
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

    self.m_UnitActorsMap[gridIndex.x][gridIndex.y] = nil
    modelUnit:unsetRootScriptEventDispatcher()

    dispatchEvtModelUnitMapUpdated(self)
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
    dispatcher:addEventListener("EvtDestroyModelUnit",   self)
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
    if     (name == "EvtDestroyModelUnit") then onEvtDestroyModelUnit(self, event)
    elseif (name == "EvtDestroyViewUnit")  then onEvtDestroyViewUnit( self, event)
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

    dispatchEvtModelUnitMapUpdated(self)

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
    focusModelUnit:doActionMoveModelUnit(action, self:getLoadedModelUnitsWithLoader(focusModelUnit))
        :doActionWait(action)

    dispatchEvtModelUnitMapUpdated(self)

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

    attacker:doActionMoveModelUnit(action, self:getLoadedModelUnitsWithLoader(attacker))
        :doActionAttack(action, attacker, target)

    if (target.getUnitType) then
        target:doActionAttack(action, attacker, target)
    end

    dispatchEvtModelUnitMapUpdated(self)

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

    capturer:doActionMoveModelUnit(action, self:getLoadedModelUnitsWithLoader(capturer))
        :doActionCapture(action, capturer, target)

    dispatchEvtModelUnitMapUpdated(self)

    return self
end

function ModelUnitMap:doActionSupplyModelUnit(action)
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
    focusModelUnit:doActionMoveModelUnit(action, self:getLoadedModelUnitsWithLoader(focusModelUnit))
        :doActionSupplyModelUnit(action, getSupplyTargetModelUnits(self, focusModelUnit, endingGridIndex))

    dispatchEvtModelUnitMapUpdated(self)

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
    focusModelUnit:doActionMoveModelUnit(action, self:getLoadedModelUnitsWithLoader(focusModelUnit))
        :doActionLoadModelUnit(action, focusUnitID, loaderModelUnit)
    loaderModelUnit:doActionLoadModelUnit(action, focusUnitID, loaderModelUnit)

    dispatchEvtModelUnitMapUpdated(self)

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

    local dropActorUnits = {}
    for _, dropDestination in ipairs(action.dropDestinations) do
        local unitID    = dropDestination.unitID
        local gridIndex = dropDestination.gridIndex
        local actorUnit = getLoadedActorUnitWithUnitId(self, unitID)
        local modelUnit = actorUnit:getModel()

        dropActorUnits[#dropActorUnits + 1] = actorUnit
        setActorUnitUnloaded(self, unitID, gridIndex)
    end

    focusModelUnit:doActionMoveModelUnit(action, self:getLoadedModelUnitsWithLoader(focusModelUnit))
        :doActionDropModelUnit(action, dropActorUnits)

    dispatchEvtModelUnitMapUpdated(self)

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

    dispatchEvtModelUnitMapUpdated(self)

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

function ModelUnitMap:getLoadedModelUnitsWithLoader(loaderModelUnit)
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

function ModelUnitMap:setPreviewLaunchUnit(modelUnit, gridIndex)
    if (self.m_View) then
        self.m_View:setPreviewLaunchUnit(modelUnit, gridIndex)
    end

    return self
end

function ModelUnitMap:setPreviewLaunchUnitVisible(visible)
    if (self.m_View) then
        self.m_View:setPreviewLaunchUnitVisible(visible)
    end

    return self
end

return ModelUnitMap
