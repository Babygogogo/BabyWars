
local Tile = class("Tile", function()
	return display.newSprite()
end)

local function createBackground_()
	local bgSprite = display.newSprite("HelloWorld.png")
		:move(display.center)

	return bgSprite
end

function Tile:ctor(params)
	self:load(params)

	return self
end

function Tile:load(params)
	if (params == nil) then return end
	assert(type(params) == "table", string.format("Tile:load() the params is a %s; table expected.", type(params)))

	-- TODO: load data from params
	self:setSpriteFrame("Tile_Forest_01.png")
	require"app.components.ComponentManager".bindComponent(self, "GridIndexable")
	self:setGridIndexAndPosition({rowIndex = 10, colIndex = 10})

	return self
end

return Tile
