
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

local function createCompositionActors(param)
	local mapData = requireMapData(param)
	assert(TypeChecker.isMapData(mapData))

	local unitActorsMap = TypeChecker.isTiledData(mapData)
		and MapFunctions.createGridActorsMapWithTiledLayer(getTiledUnitLayer(mapData), "ModelUnit", "ViewUnit")
		or  MapFunctions.createGridActorsMapWithMapData(   mapData,                    "ModelUnit", "ViewUnit")
	assert(unitActorsMap, "ModelUnitMap--createCompositionActors() failed to create the unit actors map.")

	return {UnitActorsMap = unitActorsMap}
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelUnitMap:ctor(param)
    if (param) then
        self:load(param)
    end

    return self
end

function ModelUnitMap:load(param)
	local childrenActors = createCompositionActors(param)
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

--------------------------------------------------------------------------------
-- The callback functions on node/script events.
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
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

return ModelUnitMap
