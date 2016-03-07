
local ViewUnitInfo = class("ViewUnitInfo", cc.Node)

local AnimationLoader = require("app.utilities.AnimationLoader")

local CONTENT_SIZE_WIDTH, CONTENT_SIZE_HEIGHT = 80, 150
local LEFT_POSITION_X = 10 + CONTENT_SIZE_WIDTH
local LEFT_POSITION_Y = 10
local RIGHT_POSITION_X = display.width - CONTENT_SIZE_WIDTH * 2 - 10
local RIGHT_POSITION_Y = LEFT_POSITION_Y

local GRID_SIZE = require("res.data.GameConstant").GridSize
local ICON_SCALE = 0.5
local ICON_POSITION_X = (CONTENT_SIZE_WIDTH - GRID_SIZE.width * ICON_SCALE) / 2
local ICON_POSITION_Y = CONTENT_SIZE_HEIGHT - GRID_SIZE.height * ICON_SCALE - 25

local HP_INFO_POSITION_X = 10
local HP_INFO_POSITION_Y = 60
local FUEL_INFO_POSITION_X = HP_INFO_POSITION_X
local FUEL_INFO_POSITION_Y = HP_INFO_POSITION_Y - 25
local AMMO_INFO_POSITION_X = HP_INFO_POSITION_X
local AMMO_INFO_POSITION_Y = FUEL_INFO_POSITION_Y - 25

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

local function createIcon()
    local icon = cc.Sprite:create()
    icon:setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)
        :setPosition(ICON_POSITION_X, ICON_POSITION_Y)

        :setScale(ICON_SCALE)

        :playAnimationForever(AnimationLoader.getAnimationWithTiledID(117))

    return icon
end

local function initWithIcon(view, icon)
    view.m_Icon = icon
    view:addChild(icon)
end

local function createLabel()
    local label = cc.Label:createWithTTF("99", "res/fonts/msyhbd.ttc", 22)
    label:ignoreAnchorPointForPosition(true)

        :setTextColor({r = 255, g = 255, b = 255})
        :enableOutline({r = 0, g = 0, b = 0}, 2)

    return label
end

local function createHPInfo()
    local icon = cc.Sprite:createWithSpriteFrameName("c03_t07_s01_f01.png")
    icon:setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)
        :setPosition(2, 2)

        :setScale(ICON_SCALE)

    local label = createLabel()
    label:setPosition(28, -5)

    local info = cc.Node:create()
    info:setCascadeOpacityEnabled(true)
        :setPosition(HP_INFO_POSITION_X, HP_INFO_POSITION_Y)

        :addChild(icon)
        :addChild(label)

    info.m_Label = label

    return info
end

local function initWithHPInfo(view, info)
    view.m_HPInfo = info
    view:addChild(info)
end

local function createFuelInfo()
    local icon = cc.Sprite:createWithSpriteFrameName("c03_t07_s02_f01.png")
    icon:setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)
        :setPosition(2, 0)

        :setScale(ICON_SCALE)

    local label = createLabel()
    label:setPosition(28, -5)

    local info = cc.Node:create()
    info:setCascadeOpacityEnabled(true)
        :setPosition(FUEL_INFO_POSITION_X, FUEL_INFO_POSITION_Y)

        :addChild(icon)
        :addChild(label)

    info.m_Label = label

    return info
end

local function initWithFuelInfo(view, info)
    view.m_FuelInfo = info
    view:addChild(info)
end

local function createAmmoInfo()
    local icon = cc.Sprite:createWithSpriteFrameName("c03_t07_s03_f01.png")
    icon:setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)
        :setPosition(2, 5)

        :setScale(ICON_SCALE)

    local label = createLabel()
    label:setPosition(28, -5)

    local info = cc.Node:create()
    info:setCascadeOpacityEnabled(true)
        :setPosition(AMMO_INFO_POSITION_X, AMMO_INFO_POSITION_Y)

        :addChild(icon)
        :addChild(label)

    info.m_Label = label

    return info
end

local function initWithAmmoInfo(view, info)
    view.m_AmmoInfo = info
    view:addChild(info)
end

local function moveToLeftSide(view)
    view:setPosition(LEFT_POSITION_X, LEFT_POSITION_Y)
end

local function moveToRightSide(view)
    view:setPosition(RIGHT_POSITION_X, RIGHT_POSITION_Y)
end

local function adjustPositionOnTouch(view, touch)
    local touchLocation = touch:getLocation()
    if (touchLocation.y <= display.height / 2) then
        if (touchLocation.x <= display.width / 2) then
            moveToRightSide(view)
        else
            moveToLeftSide(view)
        end
    end
end

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

    if (param) then
        self:load(param)
    end

    return self
end

function ViewUnitInfo:load(param)
    return self
end

function ViewUnitInfo.createInstance(param)
    local view = ViewUnitInfo.new():load(param)
    assert(view, "ViewUnitInfo.createInstance() failed.")

    return view
end

function ViewUnitInfo:handleAndSwallowTouch(touch, touchType, event)
    if (touchType == cc.Handler.EVENT_TOUCH_BEGAN) then
        self.m_IsTouchMoved = false
        return false
    elseif (touchType == cc.Handler.EVENT_TOUCH_MOVED) then
        self.m_IsTouchMoved = true
        return false
    elseif (touchType == cc.Handler.EVENT_TOUCH_CANCELLED) then
        return false
    elseif (touchType == cc.Handler.EVENT_TOUCH_ENDED) then
        if (not self.m_IsTouchMoved) then
            adjustPositionOnTouch(self, touch)
        end

        return false
    end
end

function ViewUnitInfo:updateWithModelUnit(model)
    local tiledID = model:getTiledID()
    self.m_Icon:stopAllActions()
        :playAnimationForever(AnimationLoader.getAnimationWithTiledID(model:getTiledID()))

    return self
end

return ViewUnitInfo
