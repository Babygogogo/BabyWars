
local ModelUnitMap = class("ModelUnitMap")

local TypeChecker        = require("app.utilities.TypeChecker")
local MapFunctions       = require("app.utilities.MapFunctions")
local ViewUnit           = require("app.views.ViewUnit")
local ModelUnit          = require("app.models.ModelUnit")
local GridSize           = require("res.data.GameConstant").GridSize
local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

local function requireMapData(param)
	local t = type(param)
	if (t == "string") then
		return require("data.unitMap." .. param)
	elseif (t == "table") then
		return param
	else
		return nil
	end
end

local function getTiledUnitLayer(tiledData)
	return tiledData.layers[2]
end

local function createModel(param)
	local mapData = requireMapData(param)
	if (mapData == nil) then
		return nil, "ModelUnitMap--createModel() failed to require MapData from param."
	end

	local baseMap, mapSize
	if (mapData.Template ~= nil) then
		local createTemplateMapResult, createTemplateMapMsg = createModel(mapData.Template)
		if (createTemplateMapResult == nil) then
			return nil, string.format("ModelUnitMap--createModel() failed to create the template map [%s]:\n%s", mapData.Template, createTemplateMapMsg)
		end

		baseMap, mapSize = createTemplateMapResult.map, createTemplateMapResult.mapSize
	else
		local loadSizeMsg
		mapSize, loadSizeMsg = MapFunctions.loadMapSize(mapData)
		if (mapSize == nil) then
			return nil, "ModelUnitMap--createModel() failed to load MapSize from param:\n" .. loadSizeMsg
		end

		baseMap = MapFunctions.createEmptyMap(mapSize)
	end

	local map, loadUnitsIntoMapMsg = MapFunctions.loadGridsIntoMap(Unit, mapData.Units, baseMap, mapSize)
	if (map == nil) then
		return nil, "ModelUnitMap--createModel() failed to load units:\n" .. loadUnitsIntoMapMsg
	end

	return {map = map, mapSize = mapSize}
end

local function createChildrenActors(param)
	local mapData = requireMapData(param)
	assert(TypeChecker.isMapData(mapData))

	local unitActorsMap = TypeChecker.isTiledData(mapData)
		and MapFunctions.createGridActorsMapWithTiledLayer(getTiledUnitLayer(mapData), ModelUnit, ViewUnit)
		or  MapFunctions.createGridActorsMapWithMapData(   mapData,                    ModelUnit, ViewUnit)
	assert(unitActorsMap, "ModelUnitMap--createChildrenActors() failed to create the unit actors map.")

	return {UnitActorsMap = unitActorsMap}
end

function ModelUnitMap:ctor(param)
	if (param) then self:load(param) end

	return self
end

function ModelUnitMap:load(param)
	local childrenActors = createChildrenActors(param)
	assert(childrenActors, "ModelUnitMap:load() failed to create children actors.")

	self.m_UnitActorsMap = childrenActors.UnitActorsMap

	if (self.m_View) then
        self:initView()
    end

	return self
end

function ModelUnitMap.createInstance(param)
	local model = ModelUnitMap.new():load(param)
	assert(model, "ModelUnitMap.createInstance() failed.")

	return model
end

function ModelUnitMap:onEnter(rootActor)
    self.m_RootScriptEventDispatcher = rootActor:getModel():getScriptEventDispatcher()
    self.m_RootScriptEventDispatcher:addEventListener("EvtCursorPositionChanged", self)

    return self
end

function ModelUnitMap:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtCursorPositionChanged", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

function ModelUnitMap:onEvent(event)
    if (event.name == "EvtCursorPositionChanged") then
        local unitActor = self:getUnitActor(event.gridIndex)
        if (unitActor) then
            self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtPlayerTouchUnit", unitModel = unitActor:getModel()})
        else
            self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtPlayerTouchNoUnit"})
        end
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
            if (unitActor) then view:addChild(unitActor:getView()) end
        end
	end

	return self
end

function ModelUnitMap:getMapSize()
	return self.m_UnitActorsMap.size
end

function ModelUnitMap:getUnitActor(gridIndex)
    if (not GridIndexFunctions.isWithinMap(gridIndex, self:getMapSize())) then
        return nil
    else
        return self.m_UnitActorsMap[gridIndex.x][gridIndex.y]
    end
end

function ModelUnitMap:handleAndSwallowTouchOnGrid(gridIndex)
--[[
    local unitActor = self:getUnitActor(gridIndex)
    if (unitActor) then
        local event = {name = "EvtPlayerTouchUnit", unitModel = unitActor:getModel()}
        self.m_RootScriptEventDispatcher:dispatchEvent(event)
    else
        local event = {name = "EvtPlayerTouchNoUnit"}
        self.m_RootScriptEventDispatcher:dispatchEvent(event)
    end
--]]
    return false
end

return ModelUnitMap
