
local Unit = class("Unit", function()
	return display.newSprite()
end)
local Requirer			= require"app.utilities.Requirer"
local UnitTemplates		= Requirer.gameConstant().Unit
local ComponentManager	= Requirer.component("ComponentManager")

local function createModel(unitData)
	if (type(unitData) ~= "table") then
		return nil, "Unit--createModel() the param unitData is not a table."
	end
	
	-- TODO: load data from unitData and handle errors
	return {spriteFrame = UnitTemplates[unitData.Template].Animation, gridIndex = unitData.GridIndex}
end

function Unit:ctor(unitData)
	self:load(unitData)

	return self
end

function Unit:load(unitData)
	local createModelResult, createModelMsg = createModel(unitData)
	if (createModelResult == nil) then
		return nil, "Unit:loadData() failed to load the param unitData:\n" .. createModelMsg
	end
	
	if (createModelResult.gridIndex ~= nil) then
		if (not ComponentManager.hasBound(self, "GridIndexable")) then	
			ComponentManager.bindComponent(self, "GridIndexable")
		end
		self:setGridIndexAndPosition(createModelResult.gridIndex)
	end	
	
	self:setSpriteFrame(createModelResult.spriteFrame)
		
	return self
end

function Unit.createInstance(unitData)
	local unit, createUnitMsg = Unit.new():load(unitData)
	if (unit == nil) then
		return nil, "Unit.createInstance() failed:\n" .. createUnitMsg
	else
		return unit
	end
end

return Unit
