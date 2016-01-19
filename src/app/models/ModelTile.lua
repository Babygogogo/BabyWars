
local ModelTile = class("ModelModelTile")
local Requirer			= require"app.utilities.Requirer"
local Actor				= Requirer.actor()
local TileTemplates		= Requirer.gameConstant().Tile
local TiledIdMapping	= Requirer.gameConstant().TiledID_Mapping
local ComponentManager	= Requirer.component("ComponentManager")
local TypeChecker		= Requirer.utility("TypeChecker")

local function toModelTileTemplate(tiledID)
	return ModelTiledIdMapping[tiledID]
end

local function createModelWithTiledID(tiledID)
	local template = toModelTileTemplate(tiledID)
	return {spriteFrame = ModelTileTemplates[template.Template].Animation}
end

local function createModelWithTileData(tileData)
	local Model
end

local function createModel(tileData)
	assert(type(tileData) == "table", "ModelTile--createModel() the param tileData is not a table, therefore not a valid TileData.")
	
	-- TODO: load data from param and handle errors
	if (tileData.TiledID) then
		local template = toModelTileTemplate(tileData.TiledID)
		assert(template, "ModelTile--createModel() failed to map the TiledID to a ModelTile template.")
		
		return {spriteFrame = ModelTileTemplates[template.Template].Animation, gridIndex = tileData.GridIndex}
	else
		return {spriteFrame = ModelTileTemplates[tileData.Template].Animation, gridIndex = tileData.GridIndex}
	end
end

function ModelTile:ctor(param)
	self:load(param)

	return self
end

function ModelTile:load(param)
	local createModelResult, createModelMsg = createModel(param)
	if (createModelResult == nil) then
		return nil, "ModelTile:loadData() failed to load the param:\n" .. createModelMsg
	end
	
	self.m_GridIndex_ = createModelResult.gridIndex
	self.m_SpriteFrame_ = createModelResult.spriteFrame
		
	return self
end

function ModelTile.createInstance(param)
	local tile = ModelTile.new():load(param)
	assert(tile, "ModelTile.createInstance() failed.")
	
	return tile
end

function ModelTile:initView()
	assert(self.m_View_, "ModelTile:initView() no view is attached to the actor of the model.")
	
	view:setPositionWithGridIndex(self.m_GridIndex_)
	view:setSpriteFrame(self.m_SpriteFrame_)
end

function ModelTile:getGridIndex()
	return self.m_GridIndex_
end

function ModelTile:setGridIndex(gridIndex)
	assert(TypeChecker.isGridIndex(gridIndex))
	self.m_GridIndex_ = gridIndex
	
	if (self.m_View_) then
		self.m_View:setPositionWithGridIndex(gridIndex)
	end
end

return ModelTile
