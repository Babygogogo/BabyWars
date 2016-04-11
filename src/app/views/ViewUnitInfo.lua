
local ViewUnitInfo = class("ViewUnitInfo", cc.Node)

local AnimationLoader = require("app.utilities.AnimationLoader")

local FONT_SIZE          = 22
local FONT_NAME          = "res/fonts/msyhbd.ttc"
local FONT_COLOR         = {r = 255, g = 255, b = 255}
local FONT_OUTLINE_COLOR = {r = 0,   g = 0,   b = 0}
local FONT_OUTLINE_WIDTH = 2

local CONTENT_SIZE_WIDTH, CONTENT_SIZE_HEIGHT = 80, 140
local LEFT_POSITION_X = 10 + CONTENT_SIZE_WIDTH
local LEFT_POSITION_Y = 10
local RIGHT_POSITION_X = display.width - CONTENT_SIZE_WIDTH * 2 - 10
local RIGHT_POSITION_Y = LEFT_POSITION_Y

local GRID_SIZE = require("app.utilities.GameConstantFunctions").getGridSize()
local ICON_SCALE = 0.5
local ICON_POSITION_X = (CONTENT_SIZE_WIDTH - GRID_SIZE.width * ICON_SCALE) / 2
local ICON_POSITION_Y = CONTENT_SIZE_HEIGHT - GRID_SIZE.height * ICON_SCALE - 20

local HP_INFO_POSITION_X = 10
local HP_INFO_POSITION_Y = 60
local FUEL_INFO_POSITION_X = HP_INFO_POSITION_X
local FUEL_INFO_POSITION_Y = HP_INFO_POSITION_Y - 25
local AMMO_INFO_POSITION_X = HP_INFO_POSITION_X
local AMMO_INFO_POSITION_Y = FUEL_INFO_POSITION_Y - 25

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createLabel(posX, posY)
    local label = cc.Label:createWithTTF("", "res/fonts/msyhbd.ttc", FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(posX, posY)

        :setTextColor(FONT_COLOR)
        :enableOutline(FONT_OUTLINE_COLOR, FONT_OUTLINE_WIDTH)

    return label
end

--------------------------------------------------------------------------------
-- The button background.
--------------------------------------------------------------------------------
local function createButton(view)
    local button = ccui.Button:create()
    button:loadTextureNormal("c03_t01_s01_f01.png", ccui.TextureResType.plistType)

        :ignoreAnchorPointForPosition(true)

        :setScale9Enabled(true)
        :setCapInsets({x = 4, y = 5, width = 1, height = 1})
        :setContentSize(CONTENT_SIZE_WIDTH, CONTENT_SIZE_HEIGHT)

        :setZoomScale(-0.05)

        :addTouchEventListener(function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                if (view.m_Model) then
                    view.m_Model:onPlayerTouch()
                end
            end
        end)

    return button
end

local function initWithButton(view, button)
    view.m_Button = button
    view:addChild(button)
end

--------------------------------------------------------------------------------
-- The unit icon.
--------------------------------------------------------------------------------
local function createIcon()
    local icon = cc.Sprite:create()
    icon:setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)
        :setPosition(ICON_POSITION_X, ICON_POSITION_Y)

        :setScale(ICON_SCALE)

    return icon
end

local function initWithIcon(view, icon)
    view.m_Icon = icon
    view:addChild(icon)
end

local function updateIconWithModelUnit(icon, unit)
    icon:stopAllActions()
        :playAnimationForever(AnimationLoader.getUnitAnimationWithTiledId(unit:getTiledID()))
end

--------------------------------------------------------------------------------
-- The HP infomation for the unit.
--------------------------------------------------------------------------------
local function createHPInfoIcon()
    local icon = cc.Sprite:createWithSpriteFrameName("c03_t07_s01_f01.png")
    icon:setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)
        :setPosition(2, 2)

        :setScale(ICON_SCALE)

    return icon
end

local function createHPInfo()
    local icon  = createHPInfoIcon()
    local label = createLabel(28, -5)

    local info = cc.Node:create()
    info:setCascadeOpacityEnabled(true)
        :setPosition(HP_INFO_POSITION_X, HP_INFO_POSITION_Y)

        :addChild(icon)
        :addChild(label)

    info.m_Inco  = icon
    info.m_Label = label

    return info
end

local function initWithHPInfo(view, info)
    view.m_HPInfo = info
    view:addChild(info)
end

local function updateHPInfoWithModelUnit(info, unit)
    local hp = unit:getNormalizedCurrentHP()
    if (hp < 10) then
        info.m_Label:setString("  " .. hp)
    else
        info.m_Label:setString(""   .. hp)
    end
end

--------------------------------------------------------------------------------
-- The fuel infomation for the unit.
--------------------------------------------------------------------------------
local function createFuelInfoIcon()
    local icon = cc.Sprite:createWithSpriteFrameName("c03_t07_s02_f01.png")
    icon:setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)
        :setPosition(2, 0)

        :setScale(ICON_SCALE)

    return icon
end

local function createFuelInfo()
    local icon  = createFuelInfoIcon()
    local label = createLabel(28, -5)

    local info = cc.Node:create()
    info:setCascadeOpacityEnabled(true)
        :setPosition(FUEL_INFO_POSITION_X, FUEL_INFO_POSITION_Y)

        :addChild(icon)
        :addChild(label)

    info.m_Icon  = icon
    info.m_Label = label

    return info
end

local function initWithFuelInfo(view, info)
    view.m_FuelInfo = info
    view:addChild(info)
end

local function updateFuelInfoWithModelUnit(info, unit)
    local fuel = unit:getCurrentFuel()
    if (fuel < 10) then
        info.m_Label:setString("  " .. fuel)
    else
        info.m_Label:setString(""   .. fuel)
    end
end

--------------------------------------------------------------------------------
-- The primary weapon ammo infomation for the unit.
--------------------------------------------------------------------------------
local function createAmmoInfoIcon()
    local icon = cc.Sprite:createWithSpriteFrameName("c03_t07_s03_f01.png")
    icon:setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)
        :setPosition(2, 5)

        :setScale(ICON_SCALE)

    return icon
end

local function createAmmoInfo()
    local icon  = createAmmoInfoIcon()
    local label = createLabel(28, -5)

    local info = cc.Node:create()
    info:setCascadeOpacityEnabled(true)
        :setPosition(AMMO_INFO_POSITION_X, AMMO_INFO_POSITION_Y)

        :addChild(icon)
        :addChild(label)

    info.m_Icon  = icon
    info.m_Label = label

    return info
end

local function initWithAmmoInfo(view, info)
    view.m_AmmoInfo = info
    view:addChild(info)
end

local function updateAmmoInfoWithModelUnit(info, unit)
    if (unit.hasPrimaryWeapon and unit:hasPrimaryWeapon()) then
        local ammo = unit:getPrimaryWeaponCurrentAmmo()
        if (ammo < 10) then
            info.m_Label:setString("  " .. ammo)
        else
            info.m_Label:setString(""   .. ammo)
        end

        info:setVisible(true)
    else
        info:setVisible(false)
    end
end

--------------------------------------------------------------------------------
-- The functions that adjust the position of the view.
--------------------------------------------------------------------------------
local function moveToLeftSide(view)
    view:setPosition(LEFT_POSITION_X, LEFT_POSITION_Y)
end

local function moveToRightSide(view)
    view:setPosition(RIGHT_POSITION_X, RIGHT_POSITION_Y)
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewUnitInfo:ctor(param)
    initWithButton(self, createButton(self))
    initWithIcon(self, createIcon())
    initWithHPInfo(self, createHPInfo())
    initWithFuelInfo(self, createFuelInfo())
    initWithAmmoInfo(self, createAmmoInfo())

    self:ignoreAnchorPointForPosition(true)

        :setVisible(false)

        :setOpacity(220)
        :setCascadeOpacityEnabled(true)

    moveToRightSide(self)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewUnitInfo:adjustPositionOnTouch(touch)
    local touchLocation = touch:getLocation()
    if (touchLocation.y < display.height / 2) then
        if (touchLocation.x <= display.width / 2) then
            moveToRightSide(self)
        else
            moveToLeftSide(self)
        end
    end

    return self
end

function ViewUnitInfo:updateWithModelUnit(model)
    updateIconWithModelUnit(self.m_Icon, model)
    updateHPInfoWithModelUnit(self.m_HPInfo, model)
    updateFuelInfoWithModelUnit(self.m_FuelInfo, model)
    updateAmmoInfoWithModelUnit(self.m_AmmoInfo, model)

    return self
end

return ViewUnitInfo
