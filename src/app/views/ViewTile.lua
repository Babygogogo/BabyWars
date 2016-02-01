
local ViewTile = class("ViewTile", function()
	return display.newSprite()
end)

local Requirer         = require"app.utilities.Requirer"
local TileTemplates    = Requirer.gameConstant().TileModelTemplates
local TiledIdMapping   = Requirer.gameConstant().TiledIdMapping
local ComponentManager = Requirer.component("ComponentManager")
local TypeChecker      = Requirer.utility("TypeChecker")
local GridSize         = Requirer.gameConstant().GridSize

function ViewTile:ctor(param)
	if (param) then self:load(param) end

	return self
end

function ViewTile:load(param)
    return self
end

function ViewTile.createInstance(param)
    local view = ViewTile.new():load(param)
    assert(view, "ViewTile.createInstance() failed.")
    
    return view
end

return ViewTile
