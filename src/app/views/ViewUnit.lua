
local ViewUnit = class("ViewUnit", cc.Sprite)

local TypeChecker       = require("app.utilities.TypeChecker")
local TemplateViewUnits = require("res.data.GameConstant").Mapping_TiledIdToTemplateViewTileOrUnit
local GridSize          = require("res.data.GameConstant").GridSize
local AnimationLoader   = require("app.utilities.AnimationLoader")

function ViewUnit:ctor(param)
    self:ignoreAnchorPointForPosition(true)

    if (param) then self:load(param) end

	return self
end

function ViewUnit:load(param)
    local tiledID = param.TiledID
    assert(TypeChecker.isTiledID(tiledID), "ViewUnit:load() the param hasn't a valid TiledID.")

    self:updateWithTiledID(tiledID)

	return self
end

function ViewUnit.createInstance(param)
	local view = ViewUnit.new():load(param)
    assert(view, "ViewUnit.createInstance() failed.")

	return view
end

function ViewUnit:updateWithTiledID(tiledID)
    assert(TypeChecker.isTiledID(tiledID))
    if (self.m_TiledID_ == tiledID) then return end

    local template = TemplateViewUnits[tiledID]
    assert(template, "ViewUnit:updateWithTiledID() failed to get the template with param tiledID.")

    self.m_TiledID_ = tiledID
    self:stopAllActions()
--        :playAnimationForever(template.Animation)
        :playAnimationForever(AnimationLoader.getAnimationWithTiledID(tiledID))
    
    return self
end

return ViewUnit
