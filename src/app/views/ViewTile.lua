
local ViewTile = class("ViewTile", function()
	return display.newSprite()
end)

local Requirer         = require"app.utilities.Requirer"
local TileTemplates    = Requirer.gameConstant().TileModelTemplates
local TiledIdMapping   = Requirer.gameConstant().TiledIdMapping
local ComponentManager = Requirer.component("ComponentManager")

local function toTileTemplate(tiledID)
	return TiledIdMapping[tiledID]
end

local function createModel(param)
	if (type(param) ~= "table") then
		return nil, "ViewTile--createModel() the param is not a table."
	end
	
	-- TODO: load data from param and handle errors
	if (param.TiledID ~= nil) then
		local template = toTileTemplate(param.TiledID)
		if (template == nil) then
			return nil, "ViewTile--createModel() failed to map the TiledID to a Tile template."
		end
		
		return {spriteFrame = TileTemplates[template.Template].Animation, gridIndex = param.GridIndex}
	else
		return {spriteFrame = TileTemplates[param.Template].Animation, gridIndex = param.GridIndex}
	end
end

function ViewTile:ctor(param)
	self:load(param)

	return self
end

function ViewTile:load(param)
	local createModelResult, createModelMsg = createModel(param)
	if (createModelResult == nil) then
		return nil, "ViewTile:loadData() failed to load the param:\n" .. createModelMsg
	end
	
	if (createModelResult.gridIndex ~= nil) then
		if (not ComponentManager.hasBound(self, "GridIndexable")) then	
			ComponentManager.bindComponent(self, "GridIndexable")
		end
		self:setGridIndexAndPosition(createModelResult.gridIndex)
	end
	
	self:setSpriteFrame(createModelResult.spriteFrame)
		
	return self
end

function ViewTile.createInstance(param)
	local tile, createTileMsg = ViewTile.new():load(param)
	if (tile == nil) then
		return nil, "ViewTile.createInstance() failed:\n" .. createTileMsg
	else
		return tile
	end
end

return ViewTile
