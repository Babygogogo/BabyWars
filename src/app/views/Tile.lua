
local Tile = class("Tile", function()
	return display.newSprite()
end)
local Requirer			= require"app.utilities.Requirer"
local TileTemplates		= Requirer.gameConstant().Tile
local ComponentManager	= Requirer.component("ComponentManager")

local function createTile(tileData)
	if (type(tileData) ~= "table") then
		return nil, "Tile--createTile() the param tileData is not a table."
	end
	
	-- TODO: load data from tileData and handle errors
	return {spriteFrame = TileTemplates[tileData.Template].Animation, gridIndex = tileData.GridIndex}
end

function Tile:ctor(tileData)
	self:loadData(tileData)

	return self
end

function Tile:loadData(tileData)
	local createTileResult, createTileMsg = createTile(tileData)
	if (createTileResult == nil) then
		return nil, "Tile:loadData() failed to load the param tileData:\n" .. createTileMsg
	end
	
	if (not ComponentManager.hasBinded(self, "GridIndexable")) then	
		ComponentManager.bindComponent(self, "GridIndexable")
	end
	
	self:setSpriteFrame(createTileResult.spriteFrame)
		:setGridIndexAndPosition(createTileResult.gridIndex)
		
	return self
end

return Tile
