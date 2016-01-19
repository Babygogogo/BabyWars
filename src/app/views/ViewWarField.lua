
local ViewWarField = class("ViewWarField", function()
	return display.newNode()
end)
local Requirer		= require"app.utilities.Requirer"
local TypeChecker	= Requirer.utility("TypeChecker")
local GameConstant	= Requirer.gameConstant()

function ViewWarField:ctor(param)
	if (param) then self:load(param) end
	
	return self
end

function ViewWarField:load(param)
	return self
end

function ViewWarField.createInstance(param)
	local view = ViewWarField.new():load(param)
	assert(view, "ViewWarField.createInstance() failed.")

	return view
end

function ViewWarField:setContentSizeWithMapSize(mapSize)
	assert(TypeChecker.isMapSize(mapSize))

	local gridSize = GameConstant.GridSize
	self:setContentSize(mapSize.width * gridSize.width, mapSize.height * gridSize.height)
	
	return self
end

return ViewWarField
