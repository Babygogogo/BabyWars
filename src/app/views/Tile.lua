
local Tile = class("Tile", function()
	return display.newSprite()
end)
local TileTemplates = require"res.GameConstant"["Tile"]

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

	-- TODO: load data from params
	local template = TileTemplates[params.template]
	self:setSpriteFrame(template.Animation)

	require"app.components.ComponentManager".bindComponent(self, "GridIndexable")
	self:setGridIndexAndPosition(params.gridIndex)

	return self
end

return Tile
