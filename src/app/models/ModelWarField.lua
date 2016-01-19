
local ModelWarField = class("ModelWarField")

local Requirer		= require"app.utilities.Requirer"
local Actor			= Requirer.actor()
local TypeChecker	= Requirer.utility("TypeChecker")
local UnitMap		= Requirer.view("UnitMap")
local GameConstant	= Requirer.gameConstant()

local function requireFieldData(param)
	local t = type(param)
	if (t == "table") then
		return param
	elseif (t == "string") then
		return Requirer.templateWarField(param)
	else
		return nil
	end
end

local function createTileMapActor(tileMapData)
	local view = Requirer.view("ViewTileMap").createInstance(tileMapData)
	assert(view, "ModelWarField--createTileMapActor() failed to create ViewTileMap.")
	
	local model = Requirer.model("ModelTileMap").createInstance(tileMapData)
	assert(model, "ModelWarField--createTileMapActor() failed to create ModelTileMap.")

	return Actor.createWithModelAndViewInstance(model, view)
end

local function createUnitMapActor(unitMapData)
	local view, createViewMsg = UnitMap.createInstance(unitMapData)
	assert(view, "ModelWarField--createUnitMapActor() failed:\n" .. (createViewMsg or ""))
	
	return Actor.createWithModelAndViewInstance(model, view)
end

local function createChildrenActors(param)
	local warFieldData = requireFieldData(param)
	assert(TypeChecker.isWarFieldData(warFieldData))
	
	local tileMapActor = createTileMapActor(warFieldData.TileMap)
	assert(tileMapActor, "ModelWarField--createChildrenActors() failed to create the TileMap actor.")
	local unitMapActor = createUnitMapActor(warFieldData.UnitMap)
	assert(unitMapActor, "ModelWarField--createChildrenActors() failed to create the UnitMap actor.")
	
	assert(TypeChecker.isSizeEqual(tileMapActor:getModel():getMapSize(), unitMapActor:getView():getMapSize()))
	
	return {TileMapActor = tileMapActor, UnitMapActor = unitMapActor}
end

function ModelWarField:ctor(param)
	if (param) then self:load(param) end
	
	return self
end

function ModelWarField:load(templateName)
	local childrenActors = createChildrenActors(templateName)
	assert(childrenActors, "ModelWarField:load() failed to create actors in field with param.")
		
	self.m_TileMapActor_ = childrenActors.TileMapActor
	self.m_UnitMapActor_ = childrenActors.UnitMapActor
	
	if (self.m_View_) then self:initView() end

	return self
end

function ModelWarField.createInstance(param)
	local model = ModelWarField.new():load(param)
	assert(model, "ModelWarField.createInstance() failed.")

	return model
end

function ModelWarField:initView()
	local view = self.m_View_
	assert(TypeChecker.isView(view))

	local mapSize = self.m_TileMapActor_:getModel():getMapSize()
	view:removeAllChildren()
		:addChild(self.m_TileMapActor_:getView())
		:addChild(self.m_UnitMapActor_:getView())
		:setContentSizeWithMapSize(mapSize)
end

return ModelWarField
