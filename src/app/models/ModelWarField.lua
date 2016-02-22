
local ModelWarField = class("ModelWarField")

local Actor			= require("global.actors.Actor")
local TypeChecker	= require("app.utilities.TypeChecker")
local GameConstant	= require("res.data.GameConstant")

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

local function createTileMapActor(tileMapData)
	local view = require("app.views.ViewTileMap").createInstance(tileMapData)
	assert(view, "ModelWarField--createTileMapActor() failed to create ViewTileMap.")
	
	local model = require("app.models.ModelTileMap").createInstance(tileMapData)
	assert(model, "ModelWarField--createTileMapActor() failed to create ModelTileMap.")

	return Actor.createWithModelAndViewInstance(model, view)
end

local function createUnitMapActor(unitMapData)
	local view = require("app.views.ViewUnitMap").createInstance(unitMapData)
	assert(view, "ModelWarField--createUnitMapActor() failed to create ViewUnitMap.")

	local model = require("app.models.ModelUnitMap").createInstance(unitMapData)
	assert(model, "ModelWarField--createUnitMapActor() failed to create ModelUnitMap.")
	
	return Actor.createWithModelAndViewInstance(model, view)
end

local function createChildrenActors(param)
	local warFieldData = requireFieldData(param)
	assert(TypeChecker.isWarFieldData(warFieldData))
	
	local tileMapActor = createTileMapActor(warFieldData.TileMap)
	assert(tileMapActor, "ModelWarField--createChildrenActors() failed to create the TileMap actor.")
	local unitMapActor = createUnitMapActor(warFieldData.UnitMap)
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

function ModelWarField:initView()
	local view = self.m_View
	assert(TypeChecker.isView(view))

	local mapSize = self.m_TileMapActor:getModel():getMapSize()
	view:removeAllChildren()
		:addChild(self.m_TileMapActor:getView())
		:addChild(self.m_UnitMapActor:getView())
		:setContentSizeWithMapSize(mapSize)
end

return ModelWarField
