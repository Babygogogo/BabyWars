
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

	-- TODO: This is only for testing the Tile class. Should be removed.
	require"app.views.Tile".new({})
		:addTo(self)
end

return WarScene
