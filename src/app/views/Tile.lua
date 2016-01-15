
local Tile = class("Tile", function()
	return display.newSprite()
end)
local Requirer			= require"app.utilities.Requirer"
local TileTemplates		= Requirer.gameConstant().Tile
local ComponentManager	= Requirer.component("ComponentManager")

local function createModel(tileData)
	if (type(tileData) ~= "table") then
		return nil, "Tile--createModel() the param tileData is not a table."
	end
	
	-- TODO: load data from tileData and handle errors
	return {spriteFrame = TileTemplates[tileData.Template].Animation, gridIndex = tileData.GridIndex}
end

function Tile:ctor(tileData)
	self:load(tileData)

	return self
end

function Tile:load(tileData)
	local createModelResult, createModelMsg = createModel(tileData)
	if (createModelResult == nil) then
		return nil, "Tile:loadData() failed to load the param tileData:\n" .. createModelMsg
	end
	
	if (createModelResult.gridIndex ~= nil) then
		if (not ComponentManager.hasBinded(self, "GridIndexable")) then	
			ComponentManager.bindComponent(self, "GridIndexable")
		end
		self:setGridIndexAndPosition(createModelResult.gridIndex)
	end
	
	self:setSpriteFrame(createModelResult.spriteFrame)
		
	return self
end

function Tile.createInstance(tileData)
	local tile, createTileMsg = Tile.new():load(tileData)
	if (tile == nil) then
		return nil, "Tile.createInstance() failed:\n" .. createTileMsg
	else
		return tile
	end
end

return Tile
