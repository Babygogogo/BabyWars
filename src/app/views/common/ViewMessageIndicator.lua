
local ViewMessageIndicator = class("ViewMessageIndicator", cc.Node)

local LABEL_FONT_NAME            = "res/fonts/msyhbd.ttc"
local LABEL_NORMAL_FONT_SIZE     = 18
local LABEL_PERSISTENT_FONT_SIZE = 22
local LABEL_FONT_COLOR           = {r = 255, g = 255, b = 255}
local LABEL_OUTLINE_COLOR        = {r = 0, g = 0, b = 0}
local LABEL_OUTLINE_WIDTH        = 2

local LABEL_WIDTH  = display.width   - 50
local LABEL_HEIGHT = display.height  - 10
local LABEL_POS_X  = (display.width  - LABEL_WIDTH)  / 2
local LABEL_POS_Y  = (display.height - LABEL_HEIGHT) / 2

local CONTAINER_WIDTH  = LABEL_WIDTH
local CONTAINER_HEIGHT = LABEL_HEIGHT
local CONTAINER_POS_X  = (display.width  - CONTAINER_WIDTH)  / 2
local CONTAINER_POS_Y  = CONTAINER_HEIGHT + (display.height - CONTAINER_HEIGHT) / 2

local DEFAULT_DURATION = 3

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createLabel(fontSize, text)
    local label = cc.Label:createWithTTF(text or "", LABEL_FONT_NAME, fontSize)
    label:ignoreAnchorPointForPosition(true)
        :setDimensions(LABEL_WIDTH, LABEL_HEIGHT)

        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
        :setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM)

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
local function initPersistentLabels(self)
    local labels = {}
    labels.m_Container = cc.Node:create()
    labels.m_Container:ignoreAnchorPointForPosition(true)
        :setPosition(CONTAINER_POS_X, CONTAINER_POS_Y)

    labels.removeMessage = function(self, msg)
        for i, label in ipairs(self) do
            if (label:getString() == msg) then
                local height = getHeight(label)
                for j = i + 1, #self do
                    self[j]:setPositionY(self[j]:getPositionY() + height)
                    self[j - 1] = self[j]
                end

                self[#self] = nil
                label:removeFromParent()

                return height
            end
        end
    end

    labels.addMessage = function(self, msg)
        local totalHeight = 0
        for i = 1, #self do
            totalHeight = totalHeight + getHeight(self[i])
            if (self[i]:getString() == msg) then
                return
            end
        end

        local label  = createLabel(LABEL_PERSISTENT_FONT_SIZE, msg)
        local height = getHeight(label)
        label:setPositionY(- totalHeight - height)
        self.m_Container:addChild(label)
        self[#self + 1] = label

        return height
    end

    self.m_PersistentLabels = labels
    self:addChild(labels.m_Container)
end

local function initNormalLabels(self)
    local list = {}
    list.m_Container = cc.Node:create()
    list.m_Container:ignoreAnchorPointForPosition(true)
        :setPosition(CONTAINER_POS_X, CONTAINER_POS_Y)

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
        local totalHeight = getHeight(label)
        for i = 1, #self do
            totalHeight = totalHeight + getHeight(self[i])
        end
        label:setPositionY(-totalHeight)
        self.m_Container:addChild(label)
        self[#self + 1] = label
    end

    self.m_NormalLabels = list
    self:addChild(list.m_Container)
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewMessageIndicator:ctor()
    initPersistentLabels(self)
    initNormalLabels(    self)

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
                self.m_NormalLabels:popFront()
            end)
        ))
    self.m_NormalLabels:pushBack(label)

    return self
end

function ViewMessageIndicator:showPersistentMessage(msg)
    local height = self.m_PersistentLabels:addMessage(msg)
    if (height) then
        local normalContainer = self.m_NormalLabels.m_Container
        normalContainer:setPositionY(normalContainer:getPositionY() - height)
    end

    return self
end

function ViewMessageIndicator:hidePersistentMessage(msg)
    local height = self.m_PersistentLabels:removeMessage(msg)
    if (height) then
        local normalContainer = self.m_NormalLabels.m_Container
        normalContainer:setPositionY(normalContainer:getPositionY() + height)
    end

    return self
end

return ViewMessageIndicator
