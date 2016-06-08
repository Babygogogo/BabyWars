
local ViewMessageIndicator = class("ViewMessageIndicator", cc.Node)

local LABEL_FONT_NAME     = "res/fonts/msyhbd.ttc"
local LABEL_FONT_SIZE     = 25
local LABEL_FONT_COLOR    = {r = 255, g = 255, b = 255}
local LABEL_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local LABEL_OUTLINE_WIDTH = 2

local LABEL_WIDTH  = display.width   - 50
local LABEL_HEIGHT = display.height  - 20
local LABEL_POS_X  = (display.width  - LABEL_WIDTH)  / 2
local LABEL_POS_Y  = (display.height - LABEL_HEIGHT) / 2

local DEFAULT_DURATION = 3

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function initLabel(self)
    local label = cc.Label:createWithTTF("", LABEL_FONT_NAME, LABEL_FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(LABEL_POS_X, LABEL_POS_Y)
        :setDimensions(LABEL_WIDTH, LABEL_HEIGHT)

        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
        :setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)

        :setTextColor(LABEL_FONT_COLOR)
        :enableOutline(LABEL_OUTLINE_COLOR, LABEL_OUTLINE_WIDTH)

    self.m_Label = label
    self:addChild(label)
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewMessageIndicator:ctor()
    initLabel(self)

    return self
end

--------------------------------------------------------------------------------
-- The pubic functions.
--------------------------------------------------------------------------------
function ViewMessageIndicator:showMessage(msg, duration)
    self.m_Label:setVisible(true)
        :setOpacity(255)
        :setString(msg)

        :stopAllActions()
        :runAction(cc.Sequence:create(
            cc.DelayTime:create(duration or DEFAULT_DURATION),
            cc.FadeOut:create(1),
            cc.CallFunc:create(function()
                if (self.m_PersistentMessage) then
                    self.m_Label:setOpacity(255)
                        :setString(self.m_PersistentMessage)
                else
                    self.m_Label:setVisible(false)
                end
            end)
        ))

    return self
end

function ViewMessageIndicator:showPersistentMessage(msg)
    self.m_PersistentMessage = msg or ""
    self.m_Label:stopAllActions()
        :setOpacity(255)
        :setString(msg)
        :setVisible(true)

    return self
end

function ViewMessageIndicator:hidePersistentMessage()
    self.m_PersistentMessage = nil
    self.m_Label:setVisible(false)

    return self
end

return ViewMessageIndicator
