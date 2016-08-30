
local ViewUnitInfo = class("ViewUnitInfo", cc.Node)

local AnimationLoader       = require("src.app.utilities.AnimationLoader")
local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")
local Actor                 = require("src.global.actors.Actor")

local SUB_VIEW_Z_ORDER = 0

local SUB_VIEW_WIDTH  = 75
local SUB_VIEW_HEIGHT = 130

local LEFT_POS_X  = 10 + SUB_VIEW_WIDTH
local LEFT_POS_Y  = 10
local RIGHT_POS_X = display.width - LEFT_POS_X
local RIGHT_POS_Y = LEFT_POS_Y

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createLabel(posX, posY)
    local label = cc.Label:createWithTTF("", "res/fonts/msyhbd.ttc", FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(posX, posY)
        :setDimensions(INFO_LABEL_WIDTH, INFO_LABEL_HEIGHT)

        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
        :setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM)

        :setTextColor(FONT_COLOR)
        :enableOutline(FONT_OUTLINE_COLOR, FONT_OUTLINE_WIDTH)

    return label
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initSubViewList(self)
    local subView = Actor.createView("sceneWar.ViewUnitInfoSingle")
    subView:setVisible(true)
        :setCallbackOnTouch(function()
            if (self.m_Model) then
                self.m_Model:onPlayerTouch(1)
            end
        end)

    self:addChild(subView, SUB_VIEW_Z_ORDER)
    self.m_SubViewList = {subView}
end

--------------------------------------------------------------------------------
-- The functions that adjust the position of the view.
--------------------------------------------------------------------------------
local function moveToLeftSide(self)
    self.m_IsLeftSide = true

    self:setPosition(LEFT_POS_X, LEFT_POS_Y)
    for i, subView in ipairs(self.m_SubViewList) do
        subView:setPositionX(SUB_VIEW_WIDTH * (i - 1))
    end
end

local function moveToRightSide(self)
    self.m_IsLeftSide = false

    self:setPosition(RIGHT_POS_X, RIGHT_POS_Y)
    for i, subView in ipairs(self.m_SubViewList) do
        subView:setPositionX(-SUB_VIEW_WIDTH * i)
    end
end

local function adjustPosition(self, toLeftSide)
    if (toLeftSide) then
        moveToLeftSide(self)
    else
        moveToRightSide(self)
    end
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewUnitInfo:ctor(param)
    initSubViewList(self)

    self:ignoreAnchorPointForPosition(true)
        :setVisible(false)

    adjustPosition(self, false)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewUnitInfo:adjustPositionOnTouch(touch)
    local touchLocation = touch:getLocation()
    if (touchLocation.y < display.height / 2) then
        local toLeftSide = touchLocation.x > display.width / 2
        if (self.m_IsLeftSide ~= toLeftSide) then
            adjustPosition(self, toLeftSide)
        end
    end

    return self
end

function ViewUnitInfo:updateWithModelUnit(modelUnit, loadedModelUnits)
    local subViewList = self.m_SubViewList
    subViewList[1]:updateWithModelUnit(modelUnit)

    for i = 2, #subViewList do
        subViewList[i]:setVisible(false)
    end

    for i, loadedModelUnit in ipairs(loadedModelUnits or {}) do
        if (not subViewList[i + 1]) then
            local subView = Actor.createView("sceneWar.ViewUnitInfoSingle")
            subView:updateWithPlayerIndex(self.m_PlayerIndex)
                :setCallbackOnTouch(function()
                    if (self.m_Model) then
                        self.m_Model:onPlayerTouch(i + 1)
                    end
                end)

            self:addChild(subView, SUB_VIEW_Z_ORDER)
            subViewList[i + 1] = subView
        end

        subViewList[i + 1]:updateWithModelUnit(loadedModelUnit)
            :setVisible(true)
    end

    adjustPosition(self, self.m_IsLeftSide)

    return self
end

function ViewUnitInfo:updateWithPlayerIndex(playerIndex)
    self.m_PlayerIndex = playerIndex
    for _, subView in ipairs(self.m_SubViewList) do
        subView:updateWithPlayerIndex(playerIndex)
    end

    return self
end

return ViewUnitInfo
