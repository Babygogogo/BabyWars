
local ViewMoneyEnergyInfo = class("ViewMoneyEnergyInfo", cc.Node)

local FONT_SIZE   = 25
local LINE_HEIGHT = FONT_SIZE / 5 * 8

local BACKGROUND_WIDTH  = FONT_SIZE / 5 * 36
local BACKGROUND_HEIGHT = LINE_HEIGHT * 2 + 8

local FUND_INFO_WIDTH      = BACKGROUND_WIDTH - 10
local FUND_INFO_HEIGHT     = LINE_HEIGHT
local FUND_INFO_POSITION_X = 7
local FUND_INFO_POSITION_Y = BACKGROUND_HEIGHT - FUND_INFO_HEIGHT - 5

local ENERGY_INFO_WIDTH      = BACKGROUND_WIDTH - 10
local ENERGY_INFO_HEIGHT     = LINE_HEIGHT
local ENERGY_INFO_POSITION_X = 7
local ENERGY_INFO_POSITION_Y = FUND_INFO_POSITION_Y - ENERGY_INFO_HEIGHT

local FONT_NAME          = "res/fonts/msyhbd.ttc"
local FONT_COLOR         = {r = 255, g = 255, b = 255}
local FONT_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local FONT_OUTLINE_WIDTH = 2

local LEFT_POSITION_X  = 10
local LEFT_POSITION_Y  = display.height - BACKGROUND_HEIGHT - 10
local RIGHT_POSITION_X = display.width - BACKGROUND_WIDTH - 10
local RIGHT_POSITION_Y = LEFT_POSITION_Y

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createLabel(posX, posY, width, height, text)
    local label = cc.Label:createWithTTF(text or "", FONT_NAME, FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(posX, posY)
        :setDimensions(width, height)

        :setTextColor(FONT_COLOR)
        :enableOutline(FONT_OUTLINE_COLOR, FONT_OUTLINE_WIDTH)

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
-- The button background.
--------------------------------------------------------------------------------
local function createBackground(view)
    local background = ccui.Button:create()
    background:loadTextureNormal("c03_t01_s01_f01.png", ccui.TextureResType.plistType)

        :ignoreAnchorPointForPosition(true)

        :setScale9Enabled(true)
        :setCapInsets({x = 4, y = 5, width = 1, height = 1})
        :setContentSize(BACKGROUND_WIDTH, BACKGROUND_HEIGHT)

        :setZoomScale(-0.05)
        :setOpacity(200)

        :addTouchEventListener(function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                if (view.m_Model) then
                    view.m_Model:onPlayerTouch()
                end
            end
        end)

    return background
end

local function initWithBackground(view, background)
    view.m_Background = background
    view:addChild(background)
end

--------------------------------------------------------------------------------
-- The fund label.
--------------------------------------------------------------------------------
local function createFundLabel()
    return createLabel(FUND_INFO_POSITION_X, FUND_INFO_POSITION_Y,
                       FUND_INFO_WIDTH, FUND_INFO_HEIGHT,
                       "F:")
end

local function initWithFundLabel(view, label)
    view.m_FundLabel = label
    view:addChild(label)
end

--------------------------------------------------------------------------------
-- The energy label.
--------------------------------------------------------------------------------
local function createEnergyLabel()
    return createLabel(ENERGY_INFO_POSITION_X, ENERGY_INFO_POSITION_Y,
                       ENERGY_INFO_WIDTH, ENERGY_INFO_HEIGHT,
                       "EN:")
end

local function initWithEnergyLabel(view, label)
    view.m_EnergyLabel = label
    view:addChild(label)
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewMoneyEnergyInfo:ctor(param)
    initWithBackground( self, createBackground(self))
    initWithFundLabel(  self, createFundLabel())
    initWithEnergyLabel(self, createEnergyLabel())

    self:ignoreAnchorPointForPosition(true)
    moveToRightSide(self)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewMoneyEnergyInfo:adjustPositionOnTouch(touch)
    local touchLocation = touch:getLocation()
    if (touchLocation.y > display.height / 2) then
        if (touchLocation.x <= display.width / 2) then
            moveToRightSide(self)
        else
            moveToLeftSide(self)
        end
    end

    return self
end

function ViewMoneyEnergyInfo:setFund(fund)
    self.m_FundLabel:setString("F:     " .. fund)

    return self
end

function ViewMoneyEnergyInfo:setEnergy(current, coPower, superPower)
    self.m_EnergyLabel:setString("EN:  " .. current .. "/" .. coPower .. "/" .. superPower)

    return self
end

return ViewMoneyEnergyInfo
