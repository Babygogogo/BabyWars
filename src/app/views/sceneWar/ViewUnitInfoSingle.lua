
local ViewUnitInfoSingle = class("ViewUnitInfoSingle", cc.Node)

local AnimationLoader       = require("src.app.utilities.AnimationLoader")
local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")
local Actor                 = require("src.global.actors.Actor")

local UNIT_LABEL_Z_ORDER = 3
local INFO_LABEL_Z_ORDER = 2
local UNIT_ICON_Z_ORDER  = 1
local INFO_ICON_Z_ORDER  = 0
local BACKGROUND_Z_ORDER = 0

local BACKGROUND_WIDTH  = 75
local BACKGROUND_HEIGHT = 130

local GRID_SIZE       = GameConstantFunctions.getGridSize()
local UNIT_ICON_SCALE = 0.5
local UNIT_ICON_POS_X = (BACKGROUND_WIDTH - GRID_SIZE.width * UNIT_ICON_SCALE) / 2
local UNIT_ICON_POS_Y = BACKGROUND_HEIGHT - GRID_SIZE.height * UNIT_ICON_SCALE - 20

local TILE_LABEL_POS_X     = 0
local TILE_LABEL_POS_Y     = BACKGROUND_HEIGHT - 23
local TILE_LABEL_FONT_SIZE = 13
local TILE_LABEL_WIDTH     = BACKGROUND_WIDTH
local TILE_LABEL_HEIGHT    = 30

local HP_INFO_POS_X = 10
local HP_INFO_POS_Y = 54

local FUEL_INFO_POS_X = HP_INFO_POS_X
local FUEL_INFO_POS_Y = HP_INFO_POS_Y - 22

local AMMO_INFO_POS_X = HP_INFO_POS_X
local AMMO_INFO_POS_Y = FUEL_INFO_POS_Y - 22

local INFO_ICON_SCALE    = 0.5
local INFO_LABEL_WIDTH   = BACKGROUND_WIDTH - HP_INFO_POS_X * 2
local INFO_LABEL_HEIGHT  = 30

local FONT_NAME          = "res/fonts/msyhbd.ttc"
local FONT_SIZE          = 20
local FONT_COLOR         = {r = 255, g = 255, b = 255}
local FONT_OUTLINE_COLOR = {r = 0,   g = 0,   b = 0}
local FONT_OUTLINE_WIDTH = 2

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createLabel(posX, posY)
    local label = cc.Label:createWithTTF("", "res/fonts/msyhbd.ttc", FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(posX, posY)
        :setDimensions(INFO_LABEL_WIDTH, INFO_LABEL_HEIGHT)

        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
        :setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM)

        :setTextColor(FONT_COLOR)
        :enableOutline(FONT_OUTLINE_COLOR, FONT_OUTLINE_WIDTH)

    return label
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initBackground(self)
    local background = ccui.Button:create()
    background:loadTextureNormal("c03_t01_s01_f01.png", ccui.TextureResType.plistType)

        :ignoreAnchorPointForPosition(true)

        :setScale9Enabled(true)
        :setCapInsets({x = 4, y = 6, width = 1, height = 1})
        :setContentSize(BACKGROUND_WIDTH, BACKGROUND_HEIGHT)

        :setOpacity(200)
        :setZoomScale(-0.05)

    self.m_Background = background
    self:addChild(background, BACKGROUND_Z_ORDER)
end

local function initUnitIcon(self)
    local icon = Actor.createView("sceneWar.ViewUnit")
    icon:setPosition(UNIT_ICON_POS_X, UNIT_ICON_POS_Y)
        :setScale(UNIT_ICON_SCALE)

    self.m_UnitIcon = icon
    self.m_Background:getRendererNormal():addChild(icon, UNIT_ICON_Z_ORDER)
end

local function initUnitLabel(self)
    local label = cc.Label:createWithTTF("", FONT_NAME, TILE_LABEL_FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(TILE_LABEL_POS_X, TILE_LABEL_POS_Y)
        :setDimensions(TILE_LABEL_WIDTH, TILE_LABEL_HEIGHT)

        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
        :setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM)

        :setTextColor(FONT_COLOR)
        :enableOutline(FONT_OUTLINE_COLOR, 1)

    self.m_UnitLabel = label
    self.m_Background:getRendererNormal():addChild(label, UNIT_LABEL_Z_ORDER)
end

local function initHPInfo(self)
    local icon = cc.Sprite:createWithSpriteFrameName("c03_t07_s01_f01.png")
    icon:setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)
        :setPosition(HP_INFO_POS_X + 2, HP_INFO_POS_Y + 2)

        :setScale(INFO_ICON_SCALE)

    local label = createLabel(HP_INFO_POS_X, HP_INFO_POS_Y - 4)

    self.m_HPIcon  = icon
    self.m_HPLabel = label
    self.m_Background:getRendererNormal():addChild(icon, INFO_ICON_Z_ORDER)
        :addChild(label, INFO_LABEL_Z_ORDER)
end

local function initFuelInfo(self)
    local icon = cc.Sprite:createWithSpriteFrameName("c03_t07_s02_f01.png")
    icon:setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)
        :setPosition(FUEL_INFO_POS_X + 2, FUEL_INFO_POS_Y + 0)

        :setScale(INFO_ICON_SCALE)

    local label = createLabel(FUEL_INFO_POS_X, FUEL_INFO_POS_Y - 4)

    self.m_FuelIcon = icon
    self.m_FuelLabel = label
    self.m_Background:getRendererNormal():addChild(icon, INFO_ICON_Z_ORDER)
        :addChild(label, INFO_LABEL_Z_ORDER)
end

local function initAmmoInfo(self)
    local icon = cc.Sprite:createWithSpriteFrameName("c03_t07_s03_f01.png")
    icon:setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)
        :setPosition(AMMO_INFO_POS_X + 2, AMMO_INFO_POS_Y + 5)

        :setScale(INFO_ICON_SCALE)

    local label = createLabel(AMMO_INFO_POS_X, AMMO_INFO_POS_Y - 4)

    self.m_AmmoIcon = icon
    self.m_AmmoLabel = label
    self.m_Background:getRendererNormal():addChild(icon, INFO_ICON_Z_ORDER)
        :addChild(label, INFO_LABEL_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The private functions for updating the composition elements.
--------------------------------------------------------------------------------
local function updateUnitIconWithModelUnit(self, unit)
    self.m_UnitIcon:updateWithModelUnit(unit)
end

local function updateUnitLabelWithModelUnit(self, unit)
    self.m_UnitLabel:setString(unit:getUnitTypeFullName())
end

local function updateHPInfoWithModelUnit(self, unit)
    self.m_HPLabel:setString(unit:getNormalizedCurrentHP())
end

local function updateFuelInfoWithModelUnit(self, unit)
    self.m_FuelLabel:setString(unit:getCurrentFuel())
end

local function updateAmmoInfoWithModelUnit(self, unit)
    if (not ((unit.hasPrimaryWeapon) and (unit:hasPrimaryWeapon()))) then
        self.m_AmmoIcon:setVisible(false)
        self.m_AmmoLabel:setVisible(false)
    else
        self.m_AmmoIcon:setVisible(true)
        self.m_AmmoLabel:setVisible(true)
            :setString(unit:getPrimaryWeaponCurrentAmmo())
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewUnitInfoSingle:ctor(param)
    initBackground(self)
    initUnitIcon(  self)
    initUnitLabel( self)
    initHPInfo(    self)
    initFuelInfo(  self)
    initAmmoInfo(  self)

    self:ignoreAnchorPointForPosition(true)
        :setVisible(false)

    return self
end

function ViewUnitInfoSingle:setCallbackOnTouch(callback)
    self.m_Background:addTouchEventListener(function(sender, eventType)
        if (eventType == ccui.TouchEventType.ended) then
            callback()
        end
    end)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewUnitInfoSingle:updateWithModelUnit(modelUnit)
    updateUnitIconWithModelUnit( self, modelUnit)
    updateUnitLabelWithModelUnit(self, modelUnit)
    updateHPInfoWithModelUnit(   self, modelUnit)
    updateFuelInfoWithModelUnit( self, modelUnit)
    updateAmmoInfoWithModelUnit( self, modelUnit)

    return self
end

return ViewUnitInfoSingle
