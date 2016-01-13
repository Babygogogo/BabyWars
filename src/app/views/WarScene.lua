
local WarScene = class("WarScene", function()
	return display.newScene()
end)

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
	local tileMap = require"app.views.TileMap".new(require"res.Templates.TileMap.TileMap_Test")
	tileMap:addTo(self)
	require"app.components.ComponentManager".bindComponent(tileMap, "DraggableWithinBoundary")
	tileMap:setDragBoundaryRect({x = 0, y = 0, width = display.width - 200, height = display.height})
end

return WarScene
