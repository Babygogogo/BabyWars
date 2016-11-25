
local ViewWarFieldPreviewer = class("ViewWarFieldPreviewer", cc.Node)

local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")

local getLocalizedText = LocalizationFunctions.getLocalizedText

local GRID_SIZE = require("src.app.utilities.GameConstantFunctions").getGridSize()

local AUTHOR_NAME_LABEL_Z_ORDER = 1
local LABEL_NICKNAMES_Z_ORDER   = 1

local BACKGROUND_POS_X  = 30 + 250 + 30 -- These numbers are the width/posX of the menu of the JoinWarSelector.
local BACKGROUND_POS_Y  = 30 + 60 + 30
local BACKGROUND_WIDTH  = display.width  - 30 - BACKGROUND_POS_X
local BACKGROUND_HEIGHT = display.height - 30 - BACKGROUND_POS_Y

local CLIPPING_NODE_POS_X  = BACKGROUND_POS_X + 4
local CLIPPING_NODE_POS_Y  = BACKGROUND_POS_Y + 7
local CLIPPING_NODE_WIDTH  = BACKGROUND_POS_X + BACKGROUND_WIDTH  - 5 - CLIPPING_NODE_POS_X
local CLIPPING_NODE_HEIGHT = BACKGROUND_POS_Y + BACKGROUND_HEIGHT - 6 - CLIPPING_NODE_POS_Y

local AUTHOR_NAME_LABEL_POS_X         = CLIPPING_NODE_POS_X
local AUTHOR_NAME_LABEL_POS_Y         = CLIPPING_NODE_POS_Y
local AUTHOR_NAME_LABEL_WIDTH         = CLIPPING_NODE_WIDTH
local AUTHOR_NAME_LABEL_HEIGHT        = CLIPPING_NODE_HEIGHT
local AUTHOR_NAME_LABEL_FONT_NAME     = "res/fonts/msyhbd.ttc"
local AUTHOR_NAME_LABEL_FONT_SIZE     = 20
local AUTHOR_NAME_LABEL_FONT_COLOR    = {r = 255, g = 255, b = 255}
local AUTHOR_NAME_LABEL_OUTLINE_COLOR = {r = 0,   g = 0,   b = 0}
local AUTHOR_NAME_LABEL_OUTLINE_WIDTH = 2

local LABEL_NICKNAMES_POS_X         = CLIPPING_NODE_POS_X
local LABEL_NICKNAMES_POS_Y         = CLIPPING_NODE_POS_Y
local LABEL_NICKNAMES_WIDTH         = CLIPPING_NODE_WIDTH
local LABEL_NICKNAMES_HEIGHT        = CLIPPING_NODE_HEIGHT
local LABEL_NICKNAMES_FONT_NAME     = AUTHOR_NAME_LABEL_FONT_NAME
local LABEL_NICKNAMES_FONT_SIZE     = 18
local LABEL_NICKNAMES_FONT_COLOR    = AUTHOR_NAME_LABEL_FONT_COLOR
local LABEL_NICKNAMES_OUTLINE_COLOR = AUTHOR_NAME_LABEL_OUTLINE_COLOR
local LABEL_NICKNAMES_OUTLINE_WIDTH = 2

local LABEL_RANDOM_WIDTH         = CLIPPING_NODE_WIDTH
local LABEL_RANDOM_HEIGHT        = CLIPPING_NODE_HEIGHT
local LABEL_RANDOM_FONT_NAME     = AUTHOR_NAME_LABEL_FONT_NAME
local LABEL_RANDOM_FONT_SIZE     = 60
local LABEL_RANDOM_FONT_COLOR    = AUTHOR_NAME_LABEL_FONT_COLOR
local LABEL_RANDOM_OUTLINE_COLOR = AUTHOR_NAME_LABEL_OUTLINE_COLOR
local LABEL_RANDOM_OUTLINE_WIDTH = AUTHOR_NAME_LABEL_OUTLINE_WIDTH

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

local function initLabelAuthorName(self)
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

local function initLabelNicknames(self)
    local label = cc.Label:createWithTTF("", LABEL_NICKNAMES_FONT_NAME, LABEL_NICKNAMES_FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(LABEL_NICKNAMES_POS_X, LABEL_NICKNAMES_POS_Y)

        :enableOutline(LABEL_NICKNAMES_OUTLINE_COLOR, LABEL_NICKNAMES_OUTLINE_WIDTH)

        :setDimensions(LABEL_NICKNAMES_WIDTH, LABEL_NICKNAMES_HEIGHT)
        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
        :setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)

    self.m_LabelNicknames = label
    self:addChild(label, LABEL_NICKNAMES_Z_ORDER)
end

local function initLabelRandom(self)
    local label = cc.Label:createWithTTF("", LABEL_RANDOM_FONT_NAME, LABEL_RANDOM_FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)

        :enableOutline(LABEL_RANDOM_OUTLINE_COLOR, LABEL_RANDOM_OUTLINE_WIDTH)

        :setDimensions(LABEL_RANDOM_WIDTH, LABEL_RANDOM_HEIGHT)
        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
        :setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)

    self.m_LabelRandom = label
    self.m_ClippingNode:addChild(label)
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewWarFieldPreviewer:ctor(param)
    initBackground(     self)
    initClippingNode(   self)
    initLabelAuthorName(self)
    initLabelNicknames( self)
    initLabelRandom(    self)

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
        self.m_ViewTileMap = nil
    end

    self.m_ViewTileMap = view
    self.m_ZoomableNode:setContentAndSize(view, {
        width  = mapSize.width  * GRID_SIZE.width,
        height = mapSize.height * GRID_SIZE.height,
    })

    return self
end

function ViewWarFieldPreviewer:setAuthorName(name)
    self.m_LabelAuthorName:setString(getLocalizedText(48, "Author") .. name)
        :stopAllActions()
        :setOpacity(255)
        :runAction(cc.Sequence:create(
            cc.DelayTime:create(3),
            cc.FadeOut:create(1)
        ))

    return self
end

function ViewWarFieldPreviewer:setPlayerNicknames(names, count)
    local text = getLocalizedText(48, "Players")
    for i = 1, count do
        text = string.format("%s\n%d. %s", text, i, names[i] or getLocalizedText(48, "Empty"))
    end

    self.m_LabelNicknames:setString(text)
        :stopAllActions()
        :setOpacity(255)
        :runAction(cc.Sequence:create(
            cc.DelayTime:create(3),
            cc.FadeOut:create(1)
        ))

    return self
end

function ViewWarFieldPreviewer:setEnabled(enabled, randomPlayersCount)
    if (enabled) then
        if (randomPlayersCount) then
            self.m_LabelRandom:setString("??(" .. randomPlayersCount .. "P)")
                :setVisible(true)
            self.m_ZoomableNode:setEnabled(false)
        else
            self.m_LabelRandom:setVisible(false)
            self.m_ZoomableNode:setEnabled(true)
        end
    end

    self:setVisible(enabled)

    return self
end

return ViewWarFieldPreviewer
