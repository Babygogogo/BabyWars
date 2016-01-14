
local Unit = class("Unit", function()
	return display.newSprite()
end)
local Requirer			= require"app.utilities.Requirer"
local UnitTemplates		= Requirer.gameConstant().Unit
local ComponentManager	= Requirer.component("ComponentManager")

local function createUnit(unitData)
	if (type(unitData) ~= "table") then
		return nil, "Unit--createUnit() the param unitData is not a table."
	end
	
	-- TODO: load data from unitData and handle errors
	return {spriteFrame = UnitTemplates[unitData.Template].Animation, gridIndex = unitData.GridIndex}
end

function Unit:ctor(unitData)
	self:loadData(unitData)

	return self
end

function Unit:loadData(unitData)
	local createUnitResult, createUnitMsg = createUnit(unitData)
	if (createUnitResult == nil) then
		return nil, "Unit:loadData() failed to load the param unitData:\n" .. createUnitMsg
	end
	
	if (not ComponentManager.hasBinded(self, "GridIndexable")) then	
		ComponentManager.bindComponent(self, "GridIndexable")
	end
	
	self:setSpriteFrame(createUnitResult.spriteFrame)
		:setGridIndexAndPosition(createUnitResult.gridIndex)
		
	return self
end

return Unit
