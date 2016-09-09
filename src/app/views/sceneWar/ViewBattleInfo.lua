
local ViewBattleInfo = class("ViewBattleInfo", cc.Node)

local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")

local LABEL_Z_ORDER      = 1
local BACKGROUND_Z_ORDER = 0

local BACKGROUND_WIDTH     = 150
local BACKGROUND_HEIGHT    = 70
local BACKGROUND_CAPINSETS = {x = 4, y = 6, width = 1, height = 1}

local LEFT_POS_X = 10
local LEFT_POS_Y = 10 + 130 -- This is the height of ViewTileInfo/ViewUnitInfo
local RIGHT_POS_X = display.width - BACKGROUND_WIDTH - 10
local RIGHT_POS_Y = LEFT_POS_Y

--------------------------------------------------------------------------------
-- The functions that adjust the position of the view.
--------------------------------------------------------------------------------
local function moveToLeftSide(self)
    self:setPosition(LEFT_POS_X, LEFT_POS_Y)
end

local function moveToRightSide(self)
    self:setPosition(RIGHT_POS_X, RIGHT_POS_Y)
end

local function resetBackground(background, playerIndex)
    background:initWithSpriteFrameName("c03_t01_s0" .. playerIndex .. "_f01.png", BACKGROUND_CAPINSETS)
    background:ignoreAnchorPointForPosition(true)
        :setContentSize(BACKGROUND_WIDTH, BACKGROUND_HEIGHT)
        :setOpacity(200)
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initBackground(self)
    local background = cc.Scale9Sprite:create()

    self.m_Background = background
    self:addChild(background, BACKGROUND_Z_ORDER)
end

local function initLabel(self)
    local label = cc.Label:createWithTTF("", "res/fonts/msyhbd.ttc", 20)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(6, 3)
        :setDimensions(BACKGROUND_WIDTH - 6, BACKGROUND_HEIGHT - 6)

        :setTextColor({r = 255, g = 255, b = 255})
        :enableOutline({r = 0, g = 0, b = 0}, 2)

    self.m_Label = label
    self:addChild(label, LABEL_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewBattleInfo:ctor(param)
    initBackground(self)
    initLabel(     self)

    self:ignoreAnchorPointForPosition(true)
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

function ViewBattleInfo:updateWithPlayerIndex(playerIndex)
    resetBackground(self.m_Background, playerIndex)
end

return ViewBattleInfo
