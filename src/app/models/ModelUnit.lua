
local ModelUnit = class("ModelUnit")

local Requirer			= require"app.utilities.Requirer"
local UnitTemplates		= Requirer.gameConstant().Unit
local ComponentManager	= Requirer.component("ComponentManager")
local TypeChecker       = Requirer.utility("TypeChecker")

local function createModel(unitData)
	if (type(unitData) ~= "table") then
		return nil, "Unit--createModel() the param unitData is not a table."
	end
	
	-- TODO: load data from unitData and handle errors
	return {spriteFrame = UnitTemplates[unitData.Template].Animation, gridIndex = unitData.GridIndex}
end

function ModelUnit:ctor(param)
    ComponentManager.bindComponent(self, "GridIndexable")

    if (param) then self:load(unitData) end

	return self
end

function ModelUnit:load(param)
	local model = createModel(param)
    assert(model, "ModelUnit:load() failed.")
	
    self:setGridIndex(model.gridIndex)
    self.m_SpriteFrame_ = model.spriteFrame
    
    if (self.m_View_) then self:initView() end
		
	return self
end

function ModelUnit.createInstance(param)
	local unit = ModelUnit.new():load(param)
    assert(unit, "ModelUnit.createInstance() failed.")

	return unit
end

function ModelUnit:initView()
    local view = self.m_View_
	assert(view, "ModelUnit:initView() no view is attached to the actor of the model.")

    self:setViewPositionWithGridIndex()
	view:setSpriteFrame(self.m_SpriteFrame_)
end


return ModelUnit
