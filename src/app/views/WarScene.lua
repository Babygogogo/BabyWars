
local WarScene = class("WarScene", function()
	return display.newScene()
end)
local Requirer = require"app.utilities.Requirer"

function WarScene:ctor()
--[[
	-- add HelloWorld label
	cc.Label:createWithSystemFont("Hello World", "Arial", 40)
		:move(display.cx, display.cy + 200)
		:addTo(self)

	-- TODO: These are only for testing the TileMap class. Should be removed.
	local tileMap = Requirer.view("TileMap").new("TileMap_Test")
	tileMap:addTo(self)
	Requirer.component("ComponentManager").bindComponent(tileMap, "DraggableWithinBoundary")
	tileMap:setDragBoundaryRect({x = 0, y = 0, width = display.width - 200, height = display.height})
--]]

---[[
	local warField = Requirer.view("WarField").new()
	local loadWarFieldResult, loadWarFieldMsg = warField:load("WarField_Test")
	if (loadWarFieldResult == nil) then
		print(loadWarFieldMsg)
	end

	self:addChild(warField)
--]]
end

return WarScene
