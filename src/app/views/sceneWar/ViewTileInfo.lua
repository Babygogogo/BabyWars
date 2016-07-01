
local ViewTileInfo = class("ViewTileInfo", cc.Node)

local AnimationLoader       = require("app.utilities.AnimationLoader")
local GameConstantFunctions = require("app.utilities.GameConstantFunctions")
local ComponentManager      = require("global.components.ComponentManager")

local GRID_SIZE = GameConstantFunctions.getGridSize()

local BACKGROUND_WIDTH  = 75
local BACKGROUND_HEIGHT = 130

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

local INFO_ICON_SCALE    = 0.4
local INFO_LABEL_WIDTH   = BACKGROUND_WIDTH - DEFENSE_INFO_POS_X * 2
local INFO_LABEL_HEIGHT  = 30

local FONT_NAME          = "res/fonts/msyhbd.ttc"
local FONT_SIZE          = 20
local FONT_COLOR         = {r = 255, g = 255, b = 255}
local FONT_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local FONT_OUTLINE_WIDTH = 2

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createInfoLabel(posX, posY)
    local label = cc.Label:createWithTTF("", FONT_NAME, FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(posX, posY)
        :setDimensions(INFO_LABEL_WIDTH, INFO_LABEL_HEIGHT)

        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
        :setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM)

        :setTextColor(FONT_COLOR)
        :enableOutline(FONT_OUTLINE_COLOR, FONT_OUTLINE_WIDTH)

    return label
end

local function moveToLeftSide(self)
    self:setPosition(LEFT_POS_X, LEFT_POS_Y)
end

local function moveToRightSide(self)
    self:setPosition(RIGHT_POS_X, RIGHT_POS_Y)
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initBackground(self)
    local background = ccui.Button:create()
    background:loadTextureNormal("c03_t01_s01_f01.png", ccui.TextureResType.plistType)

        :setScale9Enabled(true)
        :setCapInsets({x = 4, y = 6, width = 1, height = 1})
        :setContentSize(BACKGROUND_WIDTH, BACKGROUND_HEIGHT)

        :setZoomScale(-0.05)
        :setOpacity(200)
        :ignoreAnchorPointForPosition(true)

        :addTouchEventListener(function(sender, eventType)
            if (eventType == ccui.TouchEventType.ended) then
                if (self.m_Model) then
                    self.m_Model:onPlayerTouch()
                end
            end
        end)

    self.m_Background = background
    self:addChild(background)
end

local function initTileIcon(self)
    local icon = cc.Sprite:create()
    icon:setAnchorPoint(0, 0)
        :ignoreAnchorPointForPosition(true)
        :setPosition(TILE_ICON_POS_X, TILE_ICON_POS_Y)

        :setScale(TILE_ICON_SCALE)

    self.m_TileIcon = icon
    self.m_Background:getRendererNormal():addChild(icon)
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
    self.m_Background:getRendererNormal():addChild(label)
end

local function initDefenseInfo(self)
    local icon = cc.Sprite:createWithSpriteFrameName("c03_t07_s04_f01.png")
    icon:setAnchorPoint(0, 0)
        :setScale(INFO_ICON_SCALE)

        :ignoreAnchorPointForPosition(true)
        :setPosition(DEFENSE_INFO_POS_X, DEFENSE_INFO_POS_Y)

    local label = createInfoLabel(DEFENSE_INFO_POS_X, DEFENSE_INFO_POS_Y - 4)

    self.m_DefenseIcon  = icon
    self.m_DefenseLabel = label
    self.m_Background:getRendererNormal():addChild(icon)
        :addChild(label)
end

local function initCaptureInfo(self)
    local icon = cc.Sprite:createWithSpriteFrameName("c03_t07_s05_f01.png")
    icon:setAnchorPoint(0, 0)
        :setScale(INFO_ICON_SCALE)

        :ignoreAnchorPointForPosition(true)
        :setPosition(CAPTURE_INFO_POS_X, CAPTURE_INFO_POS_Y)

    local label = createInfoLabel(CAPTURE_INFO_POS_X, CAPTURE_INFO_POS_Y - 4)

    self.m_CaptureIcon  = icon
    self.m_CaptureLabel = label
    self.m_Background:getRendererNormal():addChild(icon)
        :addChild(label)
end

local function initHPInfo(self)
    local icon = cc.Sprite:createWithSpriteFrameName("c03_t07_s01_f01.png")
    icon:setAnchorPoint(0, 0)
        :setScale(INFO_ICON_SCALE)

        :ignoreAnchorPointForPosition(true)
        :setPosition(HP_INFO_POS_X + 2, HP_INFO_POS_Y + 2)

    local label = createInfoLabel(HP_INFO_POS_X, HP_INFO_POS_Y - 4)

    self.m_HPIcon  = icon
    self.m_HPLabel = label
    self.m_Background:getRendererNormal():addChild(icon)
        :addChild(label)
end

--------------------------------------------------------------------------------
-- The private functions for updating the composition elements.
--------------------------------------------------------------------------------
local function updateTileIconWithModelTile(self, tile)
    self.m_TileIcon:stopAllActions()
        :playAnimationForever(AnimationLoader.getTileAnimationWithTiledId(tile:getTiledID()))
end

local function updateTileLabelWithModelTile(self, tile)
    self.m_TileLabel:setString(tile:getTileTypeFullName())
end

local function updateDefenseInfoWithModelTile(self, tile)
    self.m_DefenseLabel:setString(tile:getNormalizedDefenseBonusAmount())
end

local function updateCaptureInfoWithModelTile(self, tile)
    local captureTaker = ComponentManager.getComponent(tile, "CaptureTaker")
    if (not captureTaker) then
        self.m_CaptureIcon:setVisible(false)
        self.m_CaptureLabel:setVisible(false)
    else
        self.m_CaptureIcon:setVisible(true)
        self.m_CaptureLabel:setVisible(true)
            :setString(captureTaker:getCurrentCapturePoint())
    end
end

local function updateHPInfoWithModelTile(self, tile)
    if (not tile.getCurrentHP) then
        self.m_HPIcon:setVisible(false)
        self.m_HPLabel:setVisible(false)
    else
        self.m_HPIcon:setVisible(true)
        self.m_HPLabel:setVisible(true)
            :setString(tile:getCurrentHP())
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

return ViewTileInfo
