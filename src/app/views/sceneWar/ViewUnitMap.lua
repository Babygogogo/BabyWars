
local ViewUnitMap = class("ViewUnitMap", cc.Node)

local GridIndexFunctions     = require("src.app.utilities.GridIndexFunctions")
local SerializationFunctions = require("src.app.utilities.SerializationFunctions")
local GameConstantFunctions  = require("src.app.utilities.GameConstantFunctions")
local Actor                  = require("src.global.actors.Actor")

local isTypeInCategory = GameConstantFunctions.isTypeInCategory
local toErrorMessage   = SerializationFunctions.toErrorMessage

local CATEGORY_AIR_UNITS    = "AirUnits"
local CATEGORY_GROUND_UNITS = "GroundUnits"
local CATEGORY_NAVAL_UNITS  = "NavalUnits"

local LAUNCH_UNIT_Z_ORDER = 3
local AIR_UNIT_Z_ORDER    = 2
local GROUND_UNIT_Z_ORDER = 1
local NAVAL_UNIT_Z_ORDER  = 0

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getUnitCategoryType(modelUnit)
    local unitType = modelUnit:getUnitType()
    if     (isTypeInCategory(unitType, CATEGORY_AIR_UNITS))    then return CATEGORY_AIR_UNITS
    elseif (isTypeInCategory(unitType, CATEGORY_GROUND_UNITS)) then return CATEGORY_GROUND_UNITS
    elseif (isTypeInCategory(unitType, CATEGORY_NAVAL_UNITS))  then return CATEGORY_NAVAL_UNITS
    else   error("ViewUnitMap-getUnitCategoryType() no category matched unitType: " .. toErrorMessage(unitType))
    end
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initLayerAir(self)
    local layer = cc.Node:create()

    self.m_Layers[CATEGORY_AIR_UNITS] = layer
    self:addChild(layer, AIR_UNIT_Z_ORDER)
end

local function initLayerGround(self)
    local layer = cc.Node:create()

    self.m_Layers[CATEGORY_GROUND_UNITS] = layer
    self:addChild(layer, GROUND_UNIT_Z_ORDER)
end

local function initLayerNaval(self)
    local layer = cc.Node:create()

    self.m_Layers[CATEGORY_NAVAL_UNITS] = layer
    self:addChild(layer, NAVAL_UNIT_Z_ORDER)
end

local function initPreviewLaunchUnit(self)
    local view = Actor.createView("sceneWar.ViewUnit")
    view:setVisible(false)

    self.m_PreviewLaunchUnit = view
    self:addChild(view, LAUNCH_UNIT_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewUnitMap:ctor(param)
    self.m_LoadedViewUnit = {}
    self.m_Layers = {}
    initLayerAir(         self)
    initLayerGround(      self)
    initLayerNaval(       self)
    initPreviewLaunchUnit(self)

    return self
end

function ViewUnitMap:setMapSize(size)
    assert(self.m_MapHeight == nil, "ViewUnitMap:setMapSize() the size has been set already.")
    self.m_MapHeight = size.height

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewUnitMap:addViewUnit(viewUnit, modelUnit)
    local gridIndex = modelUnit:getGridIndex()
    local category  = getUnitCategoryType(modelUnit)
    self.m_Layers[category]:addChild(viewUnit, self.m_MapHeight - gridIndex.y)

    local unitID = modelUnit:getUnitId()
    if (self.m_Model:getLoadedModelUnitWithUnitId(unitID)) then
        viewUnit:setVisible(false)
    end

    return self
end

function ViewUnitMap:adjustViewUnitZOrder(viewUnit, gridIndex)
    viewUnit:setLocalZOrder(self.m_MapHeight - gridIndex.y)

    return self
end

function ViewUnitMap:setPreviewLaunchUnit(modelUnit, gridIndex)
    self.m_PreviewLaunchUnit:updateWithModelUnit(modelUnit)
        :showMovingAnimation()
        :setPosition(GridIndexFunctions.toPosition(gridIndex))

    return self
end

function ViewUnitMap:setPreviewLaunchUnitVisible(visible)
    self.m_PreviewLaunchUnit:setVisible(visible)

    return self
end

return ViewUnitMap
