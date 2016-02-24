
local ModelWarField = class("ModelWarField")

local Actor        = require("global.actors.Actor")
local TypeChecker  = require("app.utilities.TypeChecker")
local GameConstant = require("res.data.GameConstant")

local function requireFieldData(param)
	local t = type(param)
	if (t == "table") then
		return param
	elseif (t == "string") then
		return require("data.warField." .. param)
	else
		return nil
	end
end

local function createChildrenActors(param)
	local warFieldData = requireFieldData(param)
	assert(TypeChecker.isWarFieldData(warFieldData))
	
	local tileMapActor = Actor.createWithModelAndViewName("ModelTileMap", warFieldData.TileMap, "ViewTileMap")
	assert(tileMapActor, "ModelWarField--createChildrenActors() failed to create the TileMap actor.")
	local unitMapActor = Actor.createWithModelAndViewName("ModelUnitMap", warFieldData.UnitMap, "ViewUnitMap")
	assert(unitMapActor, "ModelWarField--createChildrenActors() failed to create the UnitMap actor.")
	
	assert(TypeChecker.isSizeEqual(tileMapActor:getModel():getMapSize(), unitMapActor:getModel():getMapSize()))
	
	return {TileMapActor = tileMapActor, UnitMapActor = unitMapActor}
end

function ModelWarField:ctor(param)
	if (param) then self:load(param) end
	
	return self
end

function ModelWarField:load(param)
	local childrenActors = createChildrenActors(param)
	assert(childrenActors, "ModelWarField:load() failed to create actors in field with param.")
		
	self.m_TileMapActor = childrenActors.TileMapActor
	self.m_UnitMapActor = childrenActors.UnitMapActor
	
	if (self.m_View) then self:initView() end

	return self
end

function ModelWarField.createInstance(param)
	local model = ModelWarField.new():load(param)
	assert(model, "ModelWarField.createInstance() failed.")

	return model
end

function ModelWarField:getTouchableChildrenViews()
    local views = {}
    views[#views + 1] = require("app.utilities.GetTouchableViewFromActor")(self.m_UnitMapActor)
    views[#views + 1] = require("app.utilities.GetTouchableViewFromActor")(self.m_TileMapActor)
    
    return views
end

function ModelWarField:initView()
	local view = self.m_View
	assert(TypeChecker.isView(view))

	view:removeAllChildren()
		:addChild(self.m_TileMapActor:getView())
		:addChild(self.m_UnitMapActor:getView())
        
		:setContentSizeWithMapSize(self.m_TileMapActor:getModel():getMapSize())
        
        :setTouchableChildrenViews(self:getTouchableChildrenViews())
        
    return self
end

return ModelWarField
