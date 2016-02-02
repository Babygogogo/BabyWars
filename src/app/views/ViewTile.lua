
local ViewTile = class("ViewTile", function()
	return display.newSprite()
end)

local Requirer          = require"app.utilities.Requirer"
local ComponentManager  = Requirer.component("ComponentManager")
local TypeChecker       = Requirer.utility("TypeChecker")
local TemplateViewTiles = Requirer.gameConstant().Mapping_TiledIdToTemplateViewTileOrUnit

function ViewTile:ctor(param)
    self:ignoreAnchorPointForPosition(true)
    
	if (param) then self:load(param) end

	return self
end

function ViewTile:load(param)
    local tiledID = param.TiledID
    assert(TypeChecker.isTiledID(tiledID), "ViewTile:load() the param hasn't a valid TiledID.")
    
    self:updateWithTiledID(tiledID)
    
    return self
end

function ViewTile.createInstance(param)
    local view = ViewTile.new():load(param)
    assert(view, "ViewTile.createInstance() failed.")
    
    return view
end

function ViewTile:updateWithTiledID(tiledID)
    assert(TypeChecker.isTiledID(tiledID))
    if (self.m_TiledID_ == tiledID) then return end

    local template = TemplateViewTiles[tiledID]
    assert(template, "ViewTile:updateWithTiledID() failed to get the template with param tiledID.")

    self.m_TiledID_ = tiledID
    self:stopAllActions()
        :playAnimationForever(template.Animation)
    
    return self
end

return ViewTile
