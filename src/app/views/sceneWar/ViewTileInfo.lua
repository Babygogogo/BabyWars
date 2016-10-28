
local ViewTileInfo = class("ViewTileInfo", cc.Node)

local AnimationLoader       = require("src.app.utilities.AnimationLoader")
local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")

local TILE_LABEL_Z_ORDER = 3
local INFO_LABEL_Z_ORDER = 2
local TILE_ICON_Z_ORDER  = 1
local INFO_ICON_Z_ORDER  = 0
local BACKGROUND_Z_ORDER = 0

local GRID_SIZE = GameConstantFunctions.getGridSize()

local BACKGROUND_WIDTH     = 75
local BACKGROUND_HEIGHT    = 130
local BACKGROUND_CAPINSETS = {x = 4, y = 6, width = 1, height = 1}

local LEFT_POS_X  = 10
local LEFT_POS_Y  = 10
local RIGHT_POS_X = display.width - BACKGROUND_WIDTH - 10
local RIGHT_POS_Y = LEFT_POS_Y

local TILE_ICON_SCALE = 0.5
local TILE_ICON_POS_X = (BACKGROUND_WIDTH - GRID_SIZE.width * TILE_ICON_SCALE) / 2
local TILE_ICON_POS_Y = BACKGROUND_HEIGHT - GRID_SIZE.height * 2 * TILE_ICON_SCALE

local TILE_LABEL_POS_X     = 0
local TILE_LABEL_POS_Y     = BACKGROUND_HEIGHT - 23
local TILE_LABEL_FONT_SIZE = 13
local TILE_LABEL_WIDTH     = BACKGROUND_WIDTH
local TILE_LABEL_HEIGHT    = 30

local DEFENSE_INFO_POS_X = 10
local DEFENSE_INFO_POS_Y = 35

local CAPTURE_INFO_POS_X = DEFENSE_INFO_POS_X
local CAPTURE_INFO_POS_Y = 10

local HP_INFO_POS_X = DEFENSE_INFO_POS_X
local HP_INFO_POS_Y = 10

local INFO_LABEL_WIDTH   = BACKGROUND_WIDTH - DEFENSE_INFO_POS_X * 2
local INFO_LABEL_HEIGHT  = 30

local FONT_NAME          = "res/fonts/msyhbd.ttc"
local FONT_SIZE          = 20
local FONT_COLOR         = {r = 255, g = 255, b = 255}
local FONT_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local FONT_OUTLINE_WIDTH = 2

local DIGIT_WIDTH = 16

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getReversedDigitsForInt(int)
    local digits = {}
    while (int > 0) do
        digits[#digits + 1] = int % 10
        int = math.floor(int / 10)
    end
    if (#digits == 0) then
        digits[1] = 0
    end

    return digits
end

local function createDigitSprite(digit, reversedIndex)
    local sprite = cc.Sprite:createWithSpriteFrameName("c02_t99_s10_f0" .. digit .. ".png")
    sprite:ignoreAnchorPointForPosition(true)
        :setPositionX(INFO_LABEL_WIDTH - reversedIndex * DIGIT_WIDTH)

    return sprite
end

local function createInfoLabel(posX, posY)
    local label = cc.Node:create()
    label:ignoreAnchorPointForPosition(true)
        :setPosition(posX, posY)
        :setContentSize(INFO_LABEL_WIDTH, INFO_LABEL_HEIGHT)

    label.setInt = function(self, int)
        local digits = getReversedDigitsForInt(int)

        self:removeAllChildren()
        for i = 1, #digits do
            self:addChild(createDigitSprite(digits[i], i))
        end
    end

    return label
end

local function moveToLeftSide(self)
    self:setPosition(LEFT_POS_X, LEFT_POS_Y)
end

local function moveToRightSide(self)
    self:setPosition(RIGHT_POS_X, RIGHT_POS_Y)
end

local function resetBackground(background, playerIndex)
    background:loadTextureNormal("c02_t99_s09_f0" .. playerIndex .. ".png", ccui.TextureResType.plistType)
        :ignoreAnchorPointForPosition(true)

        :setScale9Enabled(true)
        :setCapInsets(BACKGROUND_CAPINSETS)
        :setContentSize(BACKGROUND_WIDTH, BACKGROUND_HEIGHT)

        :setZoomScale(-0.05)
        :setOpacity(200)
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initBackground(self)
    local background = ccui.Button:create()
    background:addTouchEventListener(function(sender, eventType)
            if (eventType == ccui.TouchEventType.ended) then
                if (self.m_Model) then
                    self.m_Model:onPlayerTouch()
                end
            end
        end)
    resetBackground(background, 1)

    self.m_Background = background
    self:addChild(background, BACKGROUND_Z_ORDER)
end

local function initTileIcon(self)
    local icon = cc.Sprite:create()
    icon:setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)
        :setPosition(TILE_ICON_POS_X, TILE_ICON_POS_Y)

        :setScale(TILE_ICON_SCALE)

    self.m_TileIcon = icon
    self.m_Background:getRendererNormal():addChild(icon, TILE_ICON_Z_ORDER)
end

local function initTileLabel(self)
    local label = cc.Label:createWithTTF("", FONT_NAME, TILE_LABEL_FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(TILE_LABEL_POS_X, TILE_LABEL_POS_Y)
        :setDimensions(TILE_LABEL_WIDTH, TILE_LABEL_HEIGHT)

        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
        :setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM)

        :setTextColor(FONT_COLOR)
        :enableOutline(FONT_OUTLINE_COLOR, 1)

    self.m_TileLabel = label
    self.m_Background:getRendererNormal():addChild(label, TILE_LABEL_Z_ORDER)
end

local function initDefenseInfo(self)
    local icon = cc.Sprite:createWithSpriteFrameName("c02_t99_s11_f04.png")
    icon:setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)
        :setPosition(DEFENSE_INFO_POS_X, DEFENSE_INFO_POS_Y)

    local label = createInfoLabel(DEFENSE_INFO_POS_X, DEFENSE_INFO_POS_Y)

    self.m_DefenseIcon  = icon
    self.m_DefenseLabel = label
    self.m_Background:getRendererNormal():addChild(icon, INFO_ICON_Z_ORDER)
        :addChild(label, INFO_LABEL_Z_ORDER)
end

local function initCaptureInfo(self)
    local icon = cc.Sprite:createWithSpriteFrameName("c02_t99_s11_f05.png")
    icon:setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)
        :setPosition(CAPTURE_INFO_POS_X, CAPTURE_INFO_POS_Y)

    local label = createInfoLabel(CAPTURE_INFO_POS_X, CAPTURE_INFO_POS_Y)

    self.m_CaptureIcon  = icon
    self.m_CaptureLabel = label
    self.m_Background:getRendererNormal():addChild(icon, INFO_ICON_Z_ORDER)
        :addChild(label, INFO_LABEL_Z_ORDER)
end

local function initHPInfo(self)
    local icon = cc.Sprite:createWithSpriteFrameName("c02_t99_s11_f01.png")
    icon:setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)
        :setPosition(HP_INFO_POS_X, HP_INFO_POS_Y)

    local label = createInfoLabel(HP_INFO_POS_X, HP_INFO_POS_Y)

    self.m_HPIcon  = icon
    self.m_HPLabel = label
    self.m_Background:getRendererNormal():addChild(icon, INFO_ICON_Z_ORDER)
        :addChild(label, INFO_LABEL_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The private functions for updating the composition elements.
--------------------------------------------------------------------------------
local function updateTileIconWithModelTile(self, tile)
    self.m_TileIcon:stopAllActions()
        :playAnimationForever(AnimationLoader.getTileAnimationWithTiledId(tile:getTiledId()))
end

local function updateTileLabelWithModelTile(self, tile)
    self.m_TileLabel:setString(tile:getTileTypeFullName())
end

local function updateDefenseInfoWithModelTile(self, tile)
    self.m_DefenseLabel:setInt(tile:getNormalizedDefenseBonusAmount())
end

local function updateCaptureInfoWithModelTile(self, tile)
    if (tile.getCurrentCapturePoint) then
        self.m_CaptureIcon:setVisible(true)
        self.m_CaptureLabel:setVisible(true)
            :setInt(tile:getCurrentCapturePoint())
    elseif (tile.getCurrentBuildPoint) then
        local buildPoint = tile:getCurrentBuildPoint()
        if (buildPoint < tile:getMaxBuildPoint()) then
            self.m_CaptureIcon:setVisible(true)
            self.m_CaptureLabel:setVisible(true)
                :setInt(buildPoint)
        else
            self.m_CaptureIcon:setVisible(false)
            self.m_CaptureLabel:setVisible(false)
        end
    else
        self.m_CaptureIcon:setVisible(false)
        self.m_CaptureLabel:setVisible(false)
    end
end

local function updateHPInfoWithModelTile(self, tile)
    if (not tile.getCurrentHP) then
        self.m_HPIcon:setVisible(false)
        self.m_HPLabel:setVisible(false)
    else
        self.m_HPIcon:setVisible(true)
        self.m_HPLabel:setVisible(true)
            :setInt(tile:getCurrentHP())
    end
end

--------------------------------------------------------------------------------
-- The contructor.
--------------------------------------------------------------------------------
function ViewTileInfo:ctor(param)
    initBackground( self)
    initTileIcon(   self)
    initTileLabel(  self)
    initDefenseInfo(self)
    initCaptureInfo(self)
    initHPInfo(     self)

    self:ignoreAnchorPointForPosition(true)

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

function ViewTileInfo:updateWithModelTile(modelTile)
    updateTileIconWithModelTile(   self, modelTile)
    updateTileLabelWithModelTile(  self, modelTile)
    updateDefenseInfoWithModelTile(self, modelTile)
    updateCaptureInfoWithModelTile(self, modelTile)
    updateHPInfoWithModelTile(     self, modelTile)

    return self
end

function ViewTileInfo:updateWithPlayerIndex(playerIndex)
    resetBackground(self.m_Background, playerIndex)

    return self
end

return ViewTileInfo
