
local ViewWarFieldPreviewer = class("ViewWarFieldPreviewer", cc.Node)

local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")

local GRID_SIZE = require("src.app.utilities.GameConstantFunctions").getGridSize()

local BACKGROUND_POS_X  = 30 + 250 + 30 -- These numbers are the width/posX of the menu of the JoinWarSelector.
local BACKGROUND_POS_Y  = 30 + 60 + 30
local BACKGROUND_WIDTH  = display.width  - 30 - BACKGROUND_POS_X
local BACKGROUND_HEIGHT = display.height - 30 - BACKGROUND_POS_Y

local CLIPPING_NODE_POS_X  = BACKGROUND_POS_X + 4
local CLIPPING_NODE_POS_Y  = BACKGROUND_POS_Y + 7
local CLIPPING_NODE_WIDTH  = BACKGROUND_POS_X + BACKGROUND_WIDTH  - 5 - CLIPPING_NODE_POS_X
local CLIPPING_NODE_HEIGHT = BACKGROUND_POS_Y + BACKGROUND_HEIGHT - 6 - CLIPPING_NODE_POS_Y

local AUTHOR_NAME_LABEL_Z_ORDER       = 1
local AUTHOR_NAME_LABEL_POS_X         = CLIPPING_NODE_POS_X
local AUTHOR_NAME_LABEL_POS_Y         = CLIPPING_NODE_POS_Y
local AUTHOR_NAME_LABEL_WIDTH         = CLIPPING_NODE_WIDTH
local AUTHOR_NAME_LABEL_HEIGHT        = CLIPPING_NODE_HEIGHT
local AUTHOR_NAME_LABEL_FONT_NAME     = "res/fonts/msyhbd.ttc"
local AUTHOR_NAME_LABEL_FONT_SIZE     = 20
local AUTHOR_NAME_LABEL_FONT_COLOR    = {r = 255, g = 255, b = 255}
local AUTHOR_NAME_LABEL_OUTLINE_COLOR = {r = 0,   g = 0,   b = 0}
local AUTHOR_NAME_LABEL_OUTLINE_WIDTH = 2

local CLIPPING_RECT = {
    x      = 0,
    y      = 0,
    width  = CLIPPING_NODE_WIDTH,
    height = CLIPPING_NODE_HEIGHT,
}
local BOUNDARY_RECT = {
    lowerLeftX  = CLIPPING_RECT.x,
    lowerLeftY  = CLIPPING_RECT.y,
    upperRightX = CLIPPING_RECT.x + CLIPPING_RECT.width,
    upperRightY = CLIPPING_RECT.y + CLIPPING_RECT.height,
    width       = CLIPPING_RECT.width,
    height      = CLIPPING_RECT.height,
}

local CLIPPING_NODE_Z_ORDER = 1
local BACKGROUND_Z_ORDER    = 0

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initBackground(self)
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", {x = 4, y = 6, width = 1, height = 1})
    background:ignoreAnchorPointForPosition(true)
        :setPosition(BACKGROUND_POS_X, BACKGROUND_POS_Y)
        :setContentSize(BACKGROUND_WIDTH, BACKGROUND_HEIGHT)
        :setOpacity(180)

    self.m_Background = background
    self:addChild(background, BACKGROUND_Z_ORDER)
end

local function initClippingNode(self)
    local clippingNode = cc.ClippingRectangleNode:create(CLIPPING_RECT)
    clippingNode:setPosition(CLIPPING_NODE_POS_X, CLIPPING_NODE_POS_Y)
    local zoomableNode = require("src.app.views.common.ViewZoomableNode"):create(BOUNDARY_RECT)

    self.m_ClippingNode = clippingNode
    self.m_ZoomableNode = zoomableNode
    clippingNode:addChild(zoomableNode)
    self:addChild(clippingNode, CLIPPING_NODE_Z_ORDER)
end

local function initAuthorNameLabel(self)
    local label = cc.Label:createWithTTF("", AUTHOR_NAME_LABEL_FONT_NAME, AUTHOR_NAME_LABEL_FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(AUTHOR_NAME_LABEL_POS_X, AUTHOR_NAME_LABEL_POS_Y)

        :enableOutline(AUTHOR_NAME_LABEL_OUTLINE_COLOR, AUTHOR_NAME_LABEL_OUTLINE_WIDTH)

        :setDimensions(AUTHOR_NAME_LABEL_WIDTH, AUTHOR_NAME_LABEL_HEIGHT)
        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
        :setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)

    self.m_LabelAuthorName = label
    self:addChild(label, AUTHOR_NAME_LABEL_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewWarFieldPreviewer:ctor(param)
    initBackground(     self)
    initClippingNode(   self)
    initAuthorNameLabel(self)

    self:ignoreAnchorPointForPosition(true)
        :setAnchorPoint(0, 0)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewWarFieldPreviewer:setViewTileMap(view, mapSize)
    if (self.m_ViewTileMap) then
        self.m_ZoomableNode:removeChild(self.m_ViewTileMap)
    end

    self.m_ViewTileMap = view
    self.m_ZoomableNode:setContentAndSize(view, {
        width  = mapSize.width  * GRID_SIZE.width,
        height = mapSize.height * GRID_SIZE.height,
    })

    return self
end

function ViewWarFieldPreviewer:setAuthorName(name)
    self.m_LabelAuthorName:setString(LocalizationFunctions.getLocalizedText(48) .. name)
        :stopAllActions()
        :setOpacity(255)
        :runAction(cc.Sequence:create(
            cc.DelayTime:create(3),
            cc.FadeOut:create(1)
        ))

    return self
end

function ViewWarFieldPreviewer:setEnabled(enabled)
    self:setVisible(enabled)
    self.m_ZoomableNode:setEnabled(enabled)

    return self
end

return ViewWarFieldPreviewer
