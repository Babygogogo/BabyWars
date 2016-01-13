
local WarScene = class("WarScene", function()
	return display.newScene()
end)
local Requirer = require"app.utilities.Requirer"

local function createBackground_()
	local bgSprite = display.newSprite("HelloWorld.png")
		:move(display.center)

	return bgSprite
end

function WarScene:ctor()
	self:addChild(createBackground_())

	-- add HelloWorld label
	cc.Label:createWithSystemFont("Hello World", "Arial", 40)
		:move(display.cx, display.cy + 200)
		:addTo(self)

	-- TODO: These are only for testing the TileMap class. Should be removed.
	local tileMap = Requirer.view("TileMap").new("TileMap_Test")
	tileMap:addTo(self)
	Requirer.component("ComponentManager").bindComponent(tileMap, "DraggableWithinBoundary")
	tileMap:setDragBoundaryRect({x = 0, y = 0, width = display.width - 200, height = display.height})
end

return WarScene
