
local ViewTileInfo = class("ViewTileInfo", cc.Node)

local AnimationLoader  = require("app.utilities.AnimationLoader")
local ComponentManager = require("global.components.ComponentManager")

local CONTENT_SIZE_WIDTH, CONTENT_SIZE_HEIGHT = 80, 150
local LEFT_POSITION_X = 10
local LEFT_POSITION_Y = 10
local RIGHT_POSITION_X = display.width - CONTENT_SIZE_WIDTH - 10
local RIGHT_POSITION_Y = LEFT_POSITION_Y

local GRID_SIZE = require("res.data.GameConstant").GridSize
local ICON_SCALE      = 0.5
local ICON_POSITION_X = (CONTENT_SIZE_WIDTH - GRID_SIZE.width * ICON_SCALE) / 2
local ICON_POSITION_Y = CONTENT_SIZE_HEIGHT - GRID_SIZE.height * 2 * ICON_SCALE

local DEFENSE_INFO_POSITION_X = 10
local DEFENSE_INFO_POSITION_Y = 40
local CAPTURE_INFO_POSITION_X = DEFENSE_INFO_POSITION_X
local CAPTURE_INFO_POSITION_Y = 10

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

        :playAnimationForever(require("app.utilities.AnimationLoader").getAnimationWithTiledID(1))

    return icon
end

local function initWithIcon(view, icon)
    view.m_Icon = icon
    view:addChild(icon)
end

local function updateIconWithModelTile(icon, tile)
    icon:stopAllActions()
        :playAnimationForever(AnimationLoader.getAnimationWithTiledID(tile:getTiledID()))
end

local function createLabel()
    local label = cc.Label:createWithTTF("0", "res/fonts/msyhbd.ttc", 22)
    label:ignoreAnchorPointForPosition(true)

        :setTextColor({r = 255, g = 255, b = 255})
        :enableOutline({r = 0, g = 0, b = 0}, 2)

    return label
end

local function createDefenseInfo()
    local icon = cc.Sprite:createWithSpriteFrameName("c03_t07_s04_f01.png")
    icon:setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)

        :setScale(ICON_SCALE)

    local label = createLabel()
    label:setPosition(30, -5)

    local info = cc.Node:create()
    info:setCascadeOpacityEnabled(true)
        :setPosition(DEFENSE_INFO_POSITION_X, DEFENSE_INFO_POSITION_Y)

        :addChild(icon)
        :addChild(label)

    info.m_Label = label

    info.setDefenseBonus = function(self, bonus)
        if (bonus < 10) then
            self.m_Label:setString("  " .. bonus)
        else
            self.m_Label:setString(""  .. bonus)
        end
    end

    return info
end

local function initWithDefenseInfo(view, info)
    view.m_DefenseInfo = info
    view:addChild(info)
end

local function updateDefenseInfoWithModelTile(info, tile)
    info:setDefenseBonus(tile:getNormalizedDefenseBonusAmount())
end

local function createCaptureInfo()
    local icon = cc.Sprite:createWithSpriteFrameName("c03_t07_s05_f01.png")
    icon:setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)

        :setScale(ICON_SCALE)

    local label = createLabel()
    label:setPosition(30, -4)

    local info = cc.Node:create()
    info:setCascadeOpacityEnabled(true)
        :setPosition(CAPTURE_INFO_POSITION_X, CAPTURE_INFO_POSITION_Y)

        :addChild(icon)
        :addChild(label)

    info.m_Label = label

    info.setCapturePoint = function(self, point)
        if (point < 10) then
            self.m_Label:setString("  " .. point)
        else
            self.m_Label:setString(""  .. point)
        end
    end

    return info
end

local function initWithCaptureInfo(view, info)
    view.m_CaptureInfo = info
    view:addChild(info)
end

local function updateCaptureInfoWithModelTile(info, tile)
    local captureTaker = ComponentManager.getComponent(tile, "CaptureTaker")
    if (captureTaker) then
        info:setCapturePoint(captureTaker:getCapturePoint())
        info:setVisible(true)
    else
        info:setVisible(false)
    end
end

function ViewTileInfo:ctor(param)
    initWithButton(self, createButton(self))
    initWithIcon(self, createIcon())
    initWithDefenseInfo(self, createDefenseInfo())
    initWithCaptureInfo(self, createCaptureInfo())

    self:ignoreAnchorPointForPosition(true)
        :moveToRightSide()

        :setOpacity(220)
        :setCascadeOpacityEnabled(true)

    if (param) then
        self:load(param)
    end

    return self
end

function ViewTileInfo:load(param)
    return self
end

function ViewTileInfo.createInstance(param)
    local view = ViewTileInfo.new():load(param)
    assert(view, "ViewTileInfo.createInstance() failed.")

    return view
end

function ViewTileInfo:handleAndSwallowTouch(touch, touchType, event)
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
            local touchLocation = touch:getLocation()
            if (touchLocation.y <= display.height / 2) then
                if (touchLocation.x <= display.width / 2) then
                    self:moveToRightSide()
                else
                    self:moveToLeftSide()
                end
            end
        end

        return false
    end
end

function ViewTileInfo:moveToLeftSide()
    self:move(LEFT_POSITION_X, LEFT_POSITION_Y)

    return self
end

function ViewTileInfo:moveToRightSide()
    self:move(RIGHT_POSITION_X, RIGHT_POSITION_Y)

    return self
end

function ViewTileInfo:updateWithModelTile(model)
    updateIconWithModelTile(self.m_Icon, model)
    updateCaptureInfoWithModelTile(self.m_CaptureInfo, model)
    updateDefenseInfoWithModelTile(self.m_DefenseInfo, model)

    return self
end

return ViewTileInfo
