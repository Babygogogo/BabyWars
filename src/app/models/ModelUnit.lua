
local ModelUnit = class("ModelUnit")

local UnitTemplates		= require("res.data.GameConstant").Unit
local ComponentManager	= require("global.components.ComponentManager")
local TypeChecker       = require("app.utilities.TypeChecker")

local function createModel(unitData)
    assert(type(unitData) == "table", "Unit--createModel() the param unitData is not a table.")

    local tiledID = unitData.TiledID
    assert(TypeChecker.isTiledID(tiledID), "Unit--createModel() the param unitData hasn't a valid TiledID.")
	
    local gridIndex = unitData.GridIndex
    assert(TypeChecker.isGridIndex(gridIndex), "Unit--createModel() the param unitData hasn't a valid GridIndex.")
    
	-- TODO: load data from unitData and handle errors
	return {tiledID = tiledID, gridIndex = gridIndex}
end

function ModelUnit:ctor(param)
    ComponentManager.bindComponent(self, "GridIndexable")

    if (param) then self:load(param) end

	return self
end

function ModelUnit:load(param)
	local model = createModel(param)
    assert(model, "ModelUnit:load() failed.")
	
    self.m_TiledID = model.tiledID
    self:setGridIndex(model.gridIndex)
    
    if (self.m_View) then self:initView() end
		
	return self
end

function ModelUnit.createInstance(param)
	local unit = ModelUnit.new():load(param)
    assert(unit, "ModelUnit.createInstance() failed.")

	return unit
end

function ModelUnit:initView()
    local view = self.m_View
	assert(view, "ModelUnit:initView() no view is attached to the actor of the model.")

    self:setViewPositionWithGridIndex()
    view:updateWithTiledID(self.m_TiledID)
end


return ModelUnit
