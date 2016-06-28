
local ViewBattleInfo = class("ViewBattleInfo", cc.Node)

local LocalizationFunctions = require("app.utilities.LocalizationFunctions")

local BACKGROUND_WIDTH, BACKGROUND_HEIGHT = 160, 70
local LEFT_POSITION_X = 10
local LEFT_POSITION_Y = 10 + 140 -- This is the height of ViewTileInfo/ViewUnitInfo
local RIGHT_POSITION_X = display.width - BACKGROUND_WIDTH - 10
local RIGHT_POSITION_Y = LEFT_POSITION_Y

--------------------------------------------------------------------------------
-- The functions that adjust the position of the view.
--------------------------------------------------------------------------------
local function moveToLeftSide(self)
    self:setPosition(LEFT_POSITION_X, LEFT_POSITION_Y)
end

local function moveToRightSide(self)
    self:setPosition(RIGHT_POSITION_X, RIGHT_POSITION_Y)
end

--------------------------------------------------------------------------------
-- The background.
--------------------------------------------------------------------------------
local function createBackground()
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", {x = 4, y = 6, width = 1, height = 1})
    background:ignoreAnchorPointForPosition(true)
        :setContentSize(BACKGROUND_WIDTH, BACKGROUND_HEIGHT)

    return background
end

local function initWithBackground(self, background)
    self.m_Background = background
    self:addChild(background)
end

--------------------------------------------------------------------------------
-- The label.
--------------------------------------------------------------------------------
local function createLabel()
    local label = cc.Label:createWithTTF("", "res/fonts/msyhbd.ttc", 20)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(6, 3)
        :setDimensions(BACKGROUND_WIDTH - 6, BACKGROUND_HEIGHT - 6)

        :setTextColor({r = 255, g = 255, b = 255})
        :enableOutline({r = 0, g = 0, b = 0}, 2)

    return label
end

local function initWithLabel(self, label)
    self.m_Label = label
    self:addChild(label)
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewBattleInfo:ctor(param)
    initWithBackground(self, createBackground())
    initWithLabel(     self, createLabel())

    self:ignoreAnchorPointForPosition(true)
        :setOpacity(220)
        :setCascadeOpacityEnabled(true)

    moveToRightSide(self)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewBattleInfo:adjustPositionOnTouch(touch)
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

function ViewBattleInfo:updateWithAttackAndCounterDamage(attack, counter)
    self.m_Label:setString(LocalizationFunctions.getLocalizedText(90, attack, counter))

    return self
end

return ViewBattleInfo
