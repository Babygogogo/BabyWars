
local ViewTileInfo = class("ViewTileInfo", cc.Node)

local AnimationLoader  = require("app.utilities.AnimationLoader")
local ComponentManager = require("global.components.ComponentManager")

local CONTENT_SIZE_WIDTH, CONTENT_SIZE_HEIGHT = 80, 140
local LEFT_POSITION_X = 10
local LEFT_POSITION_Y = 10
local RIGHT_POSITION_X = display.width - CONTENT_SIZE_WIDTH - 10
local RIGHT_POSITION_Y = LEFT_POSITION_Y

local GRID_SIZE = require("app.utilities.GameConstantFunctions").getGridSize()
local ICON_SCALE      = 0.5
local ICON_POSITION_X = (CONTENT_SIZE_WIDTH - GRID_SIZE.width * ICON_SCALE) / 2
local ICON_POSITION_Y = CONTENT_SIZE_HEIGHT - GRID_SIZE.height * 2 * ICON_SCALE

local DEFENSE_INFO_POSITION_X = 10
local DEFENSE_INFO_POSITION_Y = 40
local CAPTURE_INFO_POSITION_X = DEFENSE_INFO_POSITION_X
local CAPTURE_INFO_POSITION_Y = 10
local HP_INFO_POSITION_X      = DEFENSE_INFO_POSITION_X
local HP_INFO_POSITION_Y      = 10

--------------------------------------------------------------------------------
-- Util functions.
--------------------------------------------------------------------------------
local function createLabel(posX, posY)
    local label = cc.Label:createWithTTF("0", "res/fonts/msyhbd.ttc", 22)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(posX, posY)

        :setTextColor({r = 255, g = 255, b = 255})
        :enableOutline({r = 0, g = 0, b = 0}, 2)

    return label
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
-- The button.
--------------------------------------------------------------------------------
local function createButton(view)
    local button = ccui.Button:create()
    button:loadTextureNormal("c03_t01_s01_f01.png", ccui.TextureResType.plistType)

        :ignoreAnchorPointForPosition(true)

        :setScale9Enabled(true)
        :setCapInsets({x = 4, y = 6, width = 1, height = 1})
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
-- The tile icon.
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

local function updateIconWithModelTile(icon, tile)
    icon:stopAllActions()
        :playAnimationForever(AnimationLoader.getTileAnimationWithTiledId(tile:getTiledID()))
end

--------------------------------------------------------------------------------
-- The defense bonus info.
--------------------------------------------------------------------------------
local function createDefenseInfoIcon()
    local icon = cc.Sprite:createWithSpriteFrameName("c03_t07_s04_f01.png")
    icon:setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)

        :setScale(ICON_SCALE)

    return icon
end

local function createDefenseInfo()
    local icon  = createDefenseInfoIcon()
    local label = createLabel(30, -5)

    local info = cc.Node:create()
    info:setCascadeOpacityEnabled(true)
        :setPosition(DEFENSE_INFO_POSITION_X, DEFENSE_INFO_POSITION_Y)

        :addChild(icon)
        :addChild(label)

    info.m_Icon  = icon
    info.m_Label = label

    return info
end

local function initWithDefenseInfo(view, info)
    view.m_DefenseInfo = info
    view:addChild(info)
end

local function updateDefenseInfoLabel(label, defenseBonus)
    if (defenseBonus < 10) then
        label:setString("  " .. defenseBonus)
    else
        label:setString(""   .. defenseBonus)
    end
end

local function updateDefenseInfoWithModelTile(info, tile)
    updateDefenseInfoLabel(info.m_Label, tile:getNormalizedDefenseBonusAmount())
end

--------------------------------------------------------------------------------
-- The capture info.
--------------------------------------------------------------------------------
local function createCaptureInfoIcon()
    local icon = cc.Sprite:createWithSpriteFrameName("c03_t07_s05_f01.png")
    icon:setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)

        :setScale(ICON_SCALE)

    return icon
end

local function createCaptureInfo()
    local icon  = createCaptureInfoIcon()
    local label = createLabel(30, -4)

    local info = cc.Node:create()
    info:setCascadeOpacityEnabled(true)
        :setPosition(CAPTURE_INFO_POSITION_X, CAPTURE_INFO_POSITION_Y)

        :addChild(icon)
        :addChild(label)

    info.m_Icon  = icon
    info.m_Label = label

    return info
end

local function initWithCaptureInfo(view, info)
    view.m_CaptureInfo = info
    view:addChild(info)
end

local function updateCaptureInfoLabel(label, capturePoint)
    if (capturePoint < 10) then
        label:setString("  " .. capturePoint)
    else
        label:setString(""  .. capturePoint)
    end
end

local function updateCaptureInfoWithModelTile(info, tile)
    local captureTaker = ComponentManager.getComponent(tile, "CaptureTaker")
    if (captureTaker) then
        updateCaptureInfoLabel(info.m_Label, captureTaker:getCurrentCapturePoint())
        info:setVisible(true)
    else
        info:setVisible(false)
    end
end

--------------------------------------------------------------------------------
-- The HP infomation.
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
    local label = createLabel(31, -4)

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

local function updateHPInfoWithModelTile(info, tile)
    if (not tile.getCurrentHP) then
        info:setVisible(false)
    else
        local hp = tile:getCurrentHP()
        if (hp < 10) then
            info.m_Label:setString("  " .. hp)
        else
            info.m_Label:setString(""   .. hp)
        end

        info:setVisible(true)
    end
end

--------------------------------------------------------------------------------
-- The contructor.
--------------------------------------------------------------------------------
function ViewTileInfo:ctor(param)
    initWithButton(     self, createButton(self))
    initWithIcon(       self, createIcon())
    initWithDefenseInfo(self, createDefenseInfo())
    initWithCaptureInfo(self, createCaptureInfo())
    initWithHPInfo(     self, createHPInfo())

    self:ignoreAnchorPointForPosition(true)

        :setOpacity(220)
        :setCascadeOpacityEnabled(true)

    moveToRightSide(self)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewTileInfo:adjustPositionOnTouch(touch)
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

function ViewTileInfo:updateWithModelTile(model)
    updateIconWithModelTile(       self.m_Icon,        model)
    updateCaptureInfoWithModelTile(self.m_CaptureInfo, model)
    updateDefenseInfoWithModelTile(self.m_DefenseInfo, model)
    updateHPInfoWithModelTile(     self.m_HPInfo,      model)

    return self
end

return ViewTileInfo
