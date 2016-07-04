
local ViewMessageIndicator = class("ViewMessageIndicator", cc.Node)

local LABEL_Z_ORDER = 0

local LABEL_FONT_NAME            = "res/fonts/msyhbd.ttc"
local LABEL_NORMAL_FONT_SIZE     = 20
local LABEL_PERSISTENT_FONT_SIZE = 25
local LABEL_FONT_COLOR           = {r = 255, g = 255, b = 255}
local LABEL_OUTLINE_COLOR        = {r = 0, g = 0, b = 0}
local LABEL_OUTLINE_WIDTH        = 2

local LABEL_WIDTH  = display.width   - 50
local LABEL_HEIGHT = display.height  - 20
local LABEL_POS_X  = (display.width  - LABEL_WIDTH)  / 2
local LABEL_POS_Y  = (display.height - LABEL_HEIGHT) / 2

local CONTAINER_WIDTH  = LABEL_WIDTH
local CONTAINER_HEIGHT = LABEL_HEIGHT
local CONTAINER_POS_X  = (display.width  - CONTAINER_WIDTH)  / 2

local DEFAULT_DURATION = 3

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createLabel(fontSize, text)
    local label = cc.Label:createWithTTF(text or "", LABEL_FONT_NAME, fontSize)
    label:ignoreAnchorPointForPosition(true)
        :setDimensions(LABEL_WIDTH, LABEL_HEIGHT)

        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
        :setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)

        :setTextColor(LABEL_FONT_COLOR)
        :enableOutline(LABEL_OUTLINE_COLOR, LABEL_OUTLINE_WIDTH)

    return label
end

local function getHeight(label)
    return label:getLineHeight() * label:getStringNumLines()
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initPersistentLabel(self)
    local label = createLabel(LABEL_PERSISTENT_FONT_SIZE)
    label:setPosition(LABEL_POS_X, LABEL_POS_Y)

    self.m_PersistentLabel = label
    self:addChild(label, LABEL_Z_ORDER)
end

local function initLabelsList(self)
    local list = {}
    list.m_Container = cc.Node:create()
    list.m_Container:ignoreAnchorPointForPosition(true)
        :setPosition(CONTAINER_POS_X, LABEL_POS_Y)

    list.popFront = function(self)
        local frontLabel = self[1]
        if (frontLabel) then
            local height = getHeight(frontLabel)
            for i = 2, #self do
                self[i]:setPositionY(self[i]:getPositionY() + height)
                self[i - 1] = self[i]
            end
            self[#self] = nil

            frontLabel:removeFromParent()
        end
    end

    list.pushBack = function(self, label)
        local totalHeight = 0
        for i = 1, #self do
            totalHeight = totalHeight + getHeight(self[i])
        end
        label:setPositionY(-totalHeight)
        self.m_Container:addChild(label)
        self[#self + 1] = label
    end

    list.setPositionY = function(self, posY)
        self.m_Container:setPositionY(posY)
    end

    self.m_LabelsList = list
    self:addChild(list.m_Container)
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewMessageIndicator:ctor()
    initPersistentLabel(self)
    initLabelsList(     self)

    return self
end

--------------------------------------------------------------------------------
-- The pubic functions.
--------------------------------------------------------------------------------
function ViewMessageIndicator:showMessage(msg)
    local label = createLabel(LABEL_NORMAL_FONT_SIZE, msg)
    label:runAction(cc.Sequence:create(
            cc.DelayTime:create(DEFAULT_DURATION),
            cc.FadeOut:create(1),
            cc.CallFunc:create(function()
                self.m_LabelsList:popFront()
            end)
        ))
    self.m_LabelsList:pushBack(label)

    return self
end

function ViewMessageIndicator:showPersistentMessage(msg)
    local label = self.m_PersistentLabel
    label:setString(msg)
    self.m_LabelsList:setPositionY(label:getPositionY() - getHeight(label))

    return self
end

function ViewMessageIndicator:hidePersistentMessage()
    self.m_PersistentLabel:setVisible(false)
    self.m_LabelsList:setPositionY(self.m_PersistentLabel:getPositionY())

    return self
end

return ViewMessageIndicator
