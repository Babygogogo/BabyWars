
local Unit = class("Unit", function()
	return display.newSprite()
end)
local Requirer			= require"app.utilities.Requirer"
local UnitTemplates		= Requirer.gameConstant().Unit
local ComponentManager	= Requirer.component("ComponentManager")

local function createUnit(tileData)
	if (type(tileData) ~= "table") then
		return nil, "Unit--createUnit() the param tileData is not a table."
	end
	
	-- TODO: load data from tileData and handle errors
	return {spriteFrame = UnitTemplates[tileData.Template].Animation, gridIndex = tileData.GridIndex}
end

function Unit:ctor(tileData)
	self:loadData(tileData)

	return self
end

function Unit:loadData(tileData)
	local createUnitResult, createUnitMsg = createUnit(tileData)
	if (createUnitResult == nil) then
		return nil, "Unit:loadData() failed to load the param tileData:\n" .. createUnitMsg
	end
	
	if (not ComponentManager.hasBinded(self, "GridIndexable")) then	
		ComponentManager.bindComponent(self, "GridIndexable")
	end
	
	self:setSpriteFrame(createUnitResult.spriteFrame)
		:setGridIndexAndPosition(createUnitResult.gridIndex)
		
	return self
end

return Unit
