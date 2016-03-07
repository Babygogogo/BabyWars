
local ModelTile = class("ModelTile")

local TileTemplates    = require("res.data.GameConstant").TileModelTemplates
local TiledIdMapping   = require("res.data.GameConstant").TiledIdMapping
local ComponentManager = require("global.components.ComponentManager")
local TypeChecker      = require("app.utilities.TypeChecker")

local function toModelTileTemplate(tiledID)
	return TiledIdMapping[tiledID]
end

local function createModel(tileData)
	assert(type(tileData) == "table", "ModelTile--createModel() the param tileData is not a table, therefore not a valid TileData.")

    local tiledID = tileData.TiledID
    assert(TypeChecker.isTiledID(tiledID), "ModelTile--createModel() the param tileData hasn't a valid TiledID.")

    local gridIndex = tileData.GridIndex
    assert(TypeChecker.isGridIndex(gridIndex), "ModelTile--createModel() the param tileData hasn't a valid GridIndex.")

	-- TODO: load data from param and handle errors
    
    return {tiledID = tiledID, gridIndex = gridIndex}
end

function ModelTile:ctor(param)
    ComponentManager.bindComponent(self, "GridIndexable")

	if (param) then self:load(param) end

	return self
end

function ModelTile:load(param)
    local model = createModel(param)
    assert(model, "ModelTile:load() failed to create the model with param.")
	
    self.m_TiledID = model.tiledID
    self:setGridIndex(model.gridIndex)
    
    if (self.m_View) then self:initView() end
		
	return self
end

function ModelTile.createInstance(param)
	local model = ModelTile.new():load(param)
	assert(model, "ModelTile.createInstance() failed.")
	
	return model
end

function ModelTile:initView()
    local view = self.m_View
	assert(view, "ModelTile:initView() no view is attached to the actor of the model.")
	
    self:setViewPositionWithGridIndex()
    view:updateWithTiledID(self.m_TiledID)
end

function ModelTile:getTiledID()
    return self.m_TiledID
end

return ModelTile
