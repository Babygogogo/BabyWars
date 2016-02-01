
local ViewUnit = class("ViewUnit", function()
	return display.newSprite()
end)

local Requirer         = require"app.utilities.Requirer"
local UnitTemplates	   = Requirer.gameConstant().Unit
local ComponentManager = Requirer.component("ComponentManager")
local GridSize         = Requirer.gameConstant().GridSize
local TypeChecker      = Requirer.utility("TypeChecker")

function ViewUnit:ctor(param)
    if (param) then self:load(param) end

	return self
end

function ViewUnit:load(unitData)
	return self
end

function ViewUnit.createInstance(param)
	local view = ViewUnit.new():load(param)
    assert(view, "ViewUnit.createInstance() failed.")

	return view
end

function ViewUnit:setPositionWithGridIndex(gridIndex)
    assert(TypeChecker.isGridIndex(gridIndex))
    self:move((gridIndex.x - 0.5) * GridSize.width, (gridIndex.y - 0.5) * GridSize.height)

    return self
end

return ViewUnit
