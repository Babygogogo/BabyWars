
local ModelWarField = class("ModelWarField")

local Requirer		= require"app.utilities.Requirer"
local Actor			= Requirer.actor()
local TypeChecker	= Requirer.utility("TypeChecker")
local TileMap		= Requirer.view("TileMap")
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
	local actor = Actor.new()
	
	local view, createViewMsg = TileMap.createInstance(tileMapData)
	assert(view, "ModelWarField--createTileMapActor() failed:\n" .. (createViewMsg or ""))

	actor:setView(view)
	return actor
end

local function createUnitMapActor(unitMapData)
	local actor = Actor.new()
	
	local view, createViewMsg = UnitMap.createInstance(unitMapData)
	assert(view, "ModelWarField--createUnitMapActor() failed:\n" .. (createViewMsg or ""))
	
	actor:setView(view)
	return actor
end

local function createActorsInField(param)
	local warFieldData = requireFieldData(param)
	assert(TypeChecker.isWarFieldData(warFieldData))
	
	local tileMapActor = createTileMapActor(warFieldData.TileMap)
	assert(tileMapActor, "ModelWarField--createActorsInField() failed to create the TileMap actor.")
	local unitMapActor = createUnitMapActor(warFieldData.UnitMap)
	assert(unitMapActor, "ModelWarField--createActorsInField() failed to create the UnitMap actor.")
	assert(TypeChecker.isSizeEqual(tileMapActor:getView():getMapSize(), unitMapActor:getView():getMapSize()))
	
	return {TileMapActor = tileMapActor, UnitMapActor = unitMapData}
end

function ModelWarField:ctor(param)
	if (param) then self:load(param) end
	
	return self
end

function ModelWarField:load(templateName)
	local actorsInField = createActorsInField(templateName)
		
	self.m_TileMapActor_ = actorsInField.TileMapActor
	self.m_UnitMapActor_ = actorsInField.UnitMapActor
	
	if (self.m_View_) then self:initView() end

	return self
end

function ModelWarField.createInstance(param)
	local warField, createFieldMsg = ModelWarField.new():load(param)
	if (warField == nil) then
		return nil, "ModelWarField.createInstance() failed:\n" .. createFieldMsg
	else
		return warField
	end
end

function ModelWarField:initView()
	local view = self.m_View_
	assert(TypeChecker.isView(view))

	local mapSize = self.m_TileMapActor_:getView():getMapSize() -- TODO: replace with ...getModel():...
	view:removeAllChildren()
		:addChild(self.m_TileMapActor_:getView())
		:addChild(self.m_UnitMapActor_:getView())
		:setContentSize(mapSize.width * GameConstant.GridSize.width,
						mapSize.height * GameConstant.GridSize.height)
	
end

return ModelWarField
