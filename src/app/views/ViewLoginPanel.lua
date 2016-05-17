
local ViewLoginPanel = class("ViewLoginPanel", cc.Node)

local LABEL_TITLE_Z_ORDER       = 1
local LABEL_ACCOUNT_Z_ORDER     = 1
local LABEL_PASSWORD_Z_ORDER    = 1
local BUTTON_CONFIRM_Z_ORDER    = 1
local BUTTON_CANCEL_Z_ORDER     = 1
local EDIT_BOX_ACCOUNT_Z_ORDER  = 1
local EDIT_BOX_PASSWORD_Z_ORDER = 1
local BACKGROUND_Z_ORDER        = 0

local BACKGROUND_CAPINSETS = {x = 4, y = 6, width = 1, height = 1}
local BACKGROUND_WIDTH     = 500
local BACKGROUND_HEIGHT    = 300
local BACKGROUND_POS_X     = (display.width  - BACKGROUND_WIDTH)  / 2
local BACKGROUND_POS_Y     = (display.height - BACKGROUND_HEIGHT) / 1.5

local FONT_NAME          = "res/fonts/msyhbd.ttc"
local FONT_SIZE          = 25
local FONT_COLOR         = {r = 255, g = 255, b = 255}
local FONT_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local FONT_OUTLINE_WIDTH = 2

local LABEL_TITLE_WIDTH  = 300
local LABEL_TITLE_HEIGHT = 60
local LABEL_TITLE_POS_X  = (display.width - LABEL_TITLE_WIDTH) / 2
local LABEL_TITLE_POS_Y  = BACKGROUND_POS_Y + BACKGROUND_HEIGHT - LABEL_TITLE_HEIGHT

local LABEL_ACCOUNT_WIDTH  = 100
local LABEL_ACCOUNT_HEIGHT = 60
local LABEL_ACCOUNT_POS_X  = BACKGROUND_POS_X + 10
local LABEL_ACCOUNT_POS_Y  = LABEL_TITLE_POS_Y - LABEL_ACCOUNT_HEIGHT - 10

local LABEL_PASSWORD_WIDTH  = LABEL_ACCOUNT_WIDTH
local LABEL_PASSWORD_HEIGHT = LABEL_ACCOUNT_HEIGHT
local LABEL_PASSWORD_POS_X  = BACKGROUND_POS_X + 10
local LABEL_PASSWORD_POS_Y  = LABEL_ACCOUNT_POS_Y - LABEL_ACCOUNT_HEIGHT - 10

local BUTTON_WIDTH              = 150
local BUTTON_HEIGHT             = 50
local BUTTON_CONFIRM_POS_X      = BACKGROUND_POS_X + 60
local BUTTON_CONFIRM_POS_Y      = BACKGROUND_POS_Y + 30
local BUTTON_CONFIRM_TEXT_COLOR = {r = 104, g = 248, b = 200}

local BUTTON_CANCEL_POS_X      = BACKGROUND_POS_X + BACKGROUND_WIDTH - BUTTON_WIDTH - 60
local BUTTON_CANCEL_POS_Y      = BUTTON_CONFIRM_POS_Y
local BUTTON_CANCEL_TEXT_COLOR = {r = 240, g = 80, b = 56}

local EDIT_BOX_WIDTH        = 345
local EDIT_BOX_HEIGHT       = LABEL_ACCOUNT_HEIGHT
local EDIT_BOX_TEXTURE_NAME = "c03_t06_s01_f01.png"
local EDIT_BOX_CAPINSETS    = {x = 1, y = EDIT_BOX_HEIGHT - 7, width = 1, height = 1}

local EDIT_BOX_ACCOUNT_POS_X  = LABEL_ACCOUNT_POS_X + LABEL_ACCOUNT_WIDTH + 35
local EDIT_BOX_ACCOUNT_POS_Y  = LABEL_ACCOUNT_POS_Y + 14
local EDIT_BOX_PASSWORD_POS_X = EDIT_BOX_ACCOUNT_POS_X
local EDIT_BOX_PASSWORD_POS_Y = LABEL_PASSWORD_POS_Y + 14

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

local function createButton(posX, posY, text, textColor, callback)
    local button = ccui.Button:create()
    button:loadTextureNormal("c03_t01_s01_f01.png", ccui.TextureResType.plistType)

        :ignoreAnchorPointForPosition(true)
        :setPosition(posX, posY)

        :setScale9Enabled(true)
        :setCapInsets(BACKGROUND_CAPINSETS)
        :setContentSize(BUTTON_WIDTH, BUTTON_HEIGHT)

        :setZoomScale(-0.05)

        :setTitleFontName(FONT_NAME)
        :setTitleFontSize(FONT_SIZE)
        :setTitleColor(textColor)
        :setTitleText(text)

        :setOpacity(200)

        :addTouchEventListener(function(sender, eventType)
            if (eventType == ccui.TouchEventType.ended) then
                callback()
            end
        end)

    button:getTitleRenderer():enableOutline(FONT_OUTLINE_COLOR, FONT_OUTLINE_WIDTH)

    return button
end

local function createEditBox(posX, posY)
    local background = cc.Scale9Sprite:createWithSpriteFrameName(EDIT_BOX_TEXTURE_NAME, EDIT_BOX_CAPINSETS)
    local editBox = ccui.EditBox:create(cc.size(EDIT_BOX_WIDTH, EDIT_BOX_HEIGHT), background, background, background)
    editBox:ignoreAnchorPointForPosition(true)
        :setPosition(posX, posY)
        :setFontSize(FONT_SIZE + 5)
        :setFontColor({r = 0, g = 0, b = 0})
        :setPlaceholderFontSize(FONT_SIZE + 5)

        :setMaxLength(16)
        :setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)

    return editBox
end

--------------------------------------------------------------------------------
-- The composition background.
--------------------------------------------------------------------------------
local function createBackground()
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", BACKGROUND_CAPINSETS)
    background:ignoreAnchorPointForPosition(true)
        :setPosition(BACKGROUND_POS_X, BACKGROUND_POS_Y)
        :setContentSize(BACKGROUND_WIDTH, BACKGROUND_HEIGHT)
        :setOpacity(180)

    return background
end

local function initWithBackground(self, background)
    self.m_Background = background
    self:addChild(background, BACKGROUND_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The composition title label.
--------------------------------------------------------------------------------
local function createLabelTitle()
    local label = createLabel(LABEL_TITLE_POS_X, LABEL_TITLE_POS_Y, LABEL_TITLE_WIDTH, LABEL_TITLE_HEIGHT, "Login")
    label:setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
        :setVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)

    return label
end

local function initWithLabelTitle(self, label)
    self.m_LabelTitle = label
    self:addChild(label, LABEL_TITLE_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The composition account label.
--------------------------------------------------------------------------------
local function createLabelAccount()
    return createLabel(LABEL_ACCOUNT_POS_X, LABEL_ACCOUNT_POS_Y, LABEL_ACCOUNT_WIDTH, LABEL_ACCOUNT_HEIGHT, "Account:")
end

local function initWithLabelAccount(self, label)
    self.m_LabelAccount = label
    self:addChild(label, LABEL_ACCOUNT_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The composition password label.
--------------------------------------------------------------------------------
local function createLabelPassword()
    return createLabel(LABEL_PASSWORD_POS_X, LABEL_PASSWORD_POS_Y, LABEL_PASSWORD_WIDTH, LABEL_PASSWORD_HEIGHT, "Password:")
end

local function initWithLabelPassword(self, label)
    self.m_LabelPassword = label
    self:addChild(label, LABEL_PASSWORD_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The composition confirm button.
--------------------------------------------------------------------------------
local function createButtonConfirm(self)
    return createButton(BUTTON_CONFIRM_POS_X, BUTTON_CONFIRM_POS_Y, "Confirm", BUTTON_CONFIRM_TEXT_COLOR, function()
        if (self.m_Model) then
            self.m_Model:onButtonConfirmTouched()
        end
    end)
end

local function initWithButtonConfirm(self, button)
    self.m_ButtonConfirm = button
    self:addChild(button, BUTTON_CONFIRM_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The composition cancel button.
--------------------------------------------------------------------------------
local function createButtonCancel(self)
    return createButton(BUTTON_CANCEL_POS_X, BUTTON_CANCEL_POS_Y, "Cancel", BUTTON_CANCEL_TEXT_COLOR, function()
        if (self.m_Model) then
            self.m_Model:onButtonCancelTouched()
        end
    end)
end

local function initWithButtonCancel(self, button)
    self.m_ButtonCancel = button
    self:addChild(button, BUTTON_CANCEL_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The composition account edit box.
--------------------------------------------------------------------------------
local function createEditBoxAccount()
    local editBox = createEditBox(EDIT_BOX_ACCOUNT_POS_X, EDIT_BOX_ACCOUNT_POS_Y)
    editBox:setPlaceHolder("input account here")
        :setInputFlag(cc.EDITBOX_INPUT_FLAG_SENSITIVE)

    return editBox
end

local function initWithEditBoxAccount(self, box)
    self.m_EditBoxAccount = box
    self:addChild(box, EDIT_BOX_ACCOUNT_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The composition password edit box.
--------------------------------------------------------------------------------
local function createEditBoxPassword()
    local editBox = createEditBox(EDIT_BOX_PASSWORD_POS_X, EDIT_BOX_PASSWORD_POS_Y)
    editBox:setPlaceHolder("input password here")
        :setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)

    return editBox
end

local function initWithEditBoxPassword(self, box)
    self.m_EditBoxPassword = box
    self:addChild(box, EDIT_BOX_PASSWORD_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewLoginPanel:ctor(param)
    initWithBackground(     self, createBackground())
    initWithLabelTitle(     self, createLabelTitle())
    initWithLabelAccount(   self, createLabelAccount())
    initWithLabelPassword(  self, createLabelPassword())
    initWithButtonConfirm(  self, createButtonConfirm(self))
    initWithButtonCancel(   self, createButtonCancel(self))
    initWithEditBoxAccount( self, createEditBoxAccount())
    initWithEditBoxPassword(self, createEditBoxPassword())

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewLoginPanel:setEnabled(enabled)
    self:setVisible(enabled)

    return self
end

return ViewLoginPanel