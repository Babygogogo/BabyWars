
local ModelTile = class("ModelModelTile")

local Requirer         = require"app.utilities.Requirer"
local Actor            = Requirer.actor()
local TileTemplates    = Requirer.gameConstant().TileModelTemplates
local TiledIdMapping   = Requirer.gameConstant().TiledIdMapping
local ComponentManager = Requirer.component("ComponentManager")
local TypeChecker      = Requirer.utility("TypeChecker")

local function toModelTileTemplate(tiledID)
	return TiledIdMapping[tiledID]
end

local function createModel(tileData)
	assert(type(tileData) == "table", "ModelTile--createModel() the param tileData is not a table, therefore not a valid TileData.")
	
	-- TODO: load data from param and handle errors
	if (tileData.TiledID) then
		local template = toModelTileTemplate(tileData.TiledID)
		assert(template, "ModelTile--createModel() failed to map the TiledID to a ModelTile template.")
		
		return {spriteFrame = TileTemplates[template.Template].Animation, gridIndex = tileData.GridIndex}
	else
		return {spriteFrame = TileTemplates[tileData.Template].Animation, gridIndex = tileData.GridIndex}
	end
end

function ModelTile:ctor(param)
    ComponentManager.bindComponent(self, "GridIndexable")

	if (param) then self:load(param) end

	return self
end

function ModelTile:load(param)
    local model = createModel(param)
    assert(model, "ModelTile:load() failed to create the model with param.")
	
    self:setGridIndex(model.gridIndex)
	self.m_SpriteFrame_ = model.spriteFrame
    
    if (self.m_View_) then self:initView() end
		
	return self
end

function ModelTile.createInstance(param)
	local model = ModelTile.new():load(param)
	assert(model, "ModelTile.createInstance() failed.")
	
	return model
end

function ModelTile:initView()
    local view = self.m_View_
	assert(view, "ModelTile:initView() no view is attached to the actor of the model.")
	
    self:setViewPositionWithGridIndex()
	view:setSpriteFrame(self.m_SpriteFrame_)
end

return ModelTile
