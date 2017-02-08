
local ViewTileDetail = class("ViewTileDetail", cc.Node)

local LocalizationFunctions = requireBW("src.app.utilities.LocalizationFunctions")
local DisplayNodeFunctions  = requireBW("src.app.utilities.DisplayNodeFunctions")

local LABEL_Z_ORDER       = 1
local BOTTOM_LINE_Z_ORDER = 0
local BACKGROUND_Z_ORDER  = 0
local GREY_MASK_Z_ORDER   = -1

local FONT_SIZE          = 25
local LINE_HEIGHT        = FONT_SIZE / 5 * 8
local FONT_NAME          = "res/fonts/msyhbd.ttc"
local FONT_COLOR         = {r = 255, g = 255, b = 255}
local FONT_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local FONT_OUTLINE_WIDTH = 2

local BACKGROUND_WIDTH  = display.width * 0.8
local BACKGROUND_HEIGHT = math.min(LINE_HEIGHT * 8 + 10, display.height * 0.9)
local BACKGROUND_POS_X  = (display.width  - BACKGROUND_WIDTH) / 2
local BACKGROUND_POS_Y  = (display.height - BACKGROUND_HEIGHT) / 2

local DESCRIPTION_WIDTH  = BACKGROUND_WIDTH - 10
local DESCRIPTION_HEIGHT = LINE_HEIGHT * 2
local DESCRIPTION_POS_X  = BACKGROUND_POS_X + 5
local DESCRIPTION_POS_Y  = BACKGROUND_POS_Y + BACKGROUND_HEIGHT - DESCRIPTION_HEIGHT - 8

local DEFENSE_INFO_WIDTH  = BACKGROUND_WIDTH - 10
local DEFENSE_INFO_HEIGHT = LINE_HEIGHT
local DEFENSE_INFO_POS_X  = BACKGROUND_POS_X + 5
local DEFENSE_INFO_POS_Y  = DESCRIPTION_POS_Y - DEFENSE_INFO_HEIGHT

local REPAIR_INFO_WIDTH  = BACKGROUND_WIDTH - 10
local REPAIR_INFO_HEIGHT = LINE_HEIGHT
local REPAIR_INFO_POS_X  = BACKGROUND_POS_X + 5
local REPAIR_INFO_POS_Y  = DEFENSE_INFO_POS_Y - REPAIR_INFO_HEIGHT

local CAPTURE_INFO_WIDTH  = BACKGROUND_WIDTH - 10
local CAPTURE_INFO_HEIGHT = LINE_HEIGHT
local CAPTURE_INFO_POS_X  = BACKGROUND_POS_X + 5
local CAPTURE_INFO_POS_Y  = REPAIR_INFO_POS_Y - CAPTURE_INFO_HEIGHT

local MOVE_COST_INFO_WIDTH  = BACKGROUND_WIDTH - 10
local MOVE_COST_INFO_HEIGHT = LINE_HEIGHT * 4
local MOVE_COST_INFO_POS_X  = BACKGROUND_POS_X + 5
local MOVE_COST_INFO_POS_Y  = CAPTURE_INFO_POS_Y - MOVE_COST_INFO_HEIGHT

local BUTTOM_LINE_SPRITE_FRAME_NAME = "c03_t06_s01_f01.png"

--------------------------------------------------------------------------------
-- Util functions.
--------------------------------------------------------------------------------
local function createBottomLine(posX, poxY, width, height)
    local line = cc.Sprite:createWithSpriteFrameName(BUTTOM_LINE_SPRITE_FRAME_NAME)
    line:ignoreAnchorPointForPosition(true)
        :setPosition(posX, poxY)
        :setAnchorPoint(0, 0)
        :setScaleX(width / line:getContentSize().width)

    return line
end

local function createLabel(posX, posY, width, height, text)
    local label = cc.Label:createWithTTF(text or "", FONT_NAME, FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(posX, posY)
        :setDimensions(width, height)

        :setTextColor(FONT_COLOR)
        :enableOutline(FONT_OUTLINE_COLOR, FONT_OUTLINE_WIDTH)

    return label
end

local function createMoveCostInfoDetailLabels()
    local originX, originY = MOVE_COST_INFO_POS_X, MOVE_COST_INFO_POS_Y
    local width,   height =  MOVE_COST_INFO_WIDTH / 4,  LINE_HEIGHT
    return {
        Infantry  = createLabel(originX,             originY + height * 2, width, height),
        Mech      = createLabel(originX + width,     originY + height * 2, width, height),
        TireA     = createLabel(originX + width * 2, originY + height * 2, width, height),
        TireB     = createLabel(originX + width * 3, originY + height * 2, width, height),
        Tank      = createLabel(originX,             originY + height,     width, height),
        Air       = createLabel(originX + width * 1, originY + height,     width, height),
        Ship      = createLabel(originX + width * 2, originY + height,     width, height),
        Transport = createLabel(originX + width * 3, originY + height,     width, height),
    }
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initGreyMask(self)
    local mask = cc.LayerColor:create({r = 0, g = 0, b = 0, a = 140})
    mask:setContentSize(display.width, display.height)
        :ignoreAnchorPointForPosition(true)

    self.m_GreyMask = mask
    self:addChild(mask, GREY_MASK_Z_ORDER)
end

local function initBackground(self)
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", {x = 4, y = 6, width = 1, height = 1})
    background:ignoreAnchorPointForPosition(true)
        :setPosition(BACKGROUND_POS_X, BACKGROUND_POS_Y)

        :setContentSize(BACKGROUND_WIDTH, BACKGROUND_HEIGHT)
        :setOpacity(180)

    self.m_Background = background
    self:addChild(background, BACKGROUND_Z_ORDER)
end

local function initDescription(self)
    local label      = createLabel(     BACKGROUND_POS_X + 5,  BACKGROUND_POS_Y + 6, BACKGROUND_WIDTH - 10,  BACKGROUND_HEIGHT - 14)
    local bottomLine = createBottomLine(DESCRIPTION_POS_X + 5, DESCRIPTION_POS_Y,    DESCRIPTION_WIDTH - 10, DESCRIPTION_HEIGHT)

    self.m_DescriptionLabel = label
    self.m_DescriptionLine  = bottomLine
    self:addChild(label,      LABEL_Z_ORDER)
        :addChild(bottomLine, BOTTOM_LINE_Z_ORDER)
end

local function initDefenseInfo(self)
    local label      = createLabel(     DEFENSE_INFO_POS_X,     DEFENSE_INFO_POS_Y, DEFENSE_INFO_WIDTH,      DEFENSE_INFO_HEIGHT)
    local bottomLine = createBottomLine(DEFENSE_INFO_POS_X + 5, DEFENSE_INFO_POS_Y, DEFENSE_INFO_WIDTH - 10, DEFENSE_INFO_HEIGHT)

    self.m_DefenseLabel = label
    self.m_DefenseLine  = bottomLine
    self:addChild(label,      LABEL_Z_ORDER)
        :addChild(bottomLine, BOTTOM_LINE_Z_ORDER)
end

local function initRepairInfo(self)
    local label      = createLabel(     REPAIR_INFO_POS_X,     REPAIR_INFO_POS_Y, REPAIR_INFO_WIDTH,      REPAIR_INFO_HEIGHT)
    local bottomLine = createBottomLine(REPAIR_INFO_POS_X + 5, REPAIR_INFO_POS_Y, REPAIR_INFO_WIDTH - 10, REPAIR_INFO_HEIGHT)

    self.m_RepairLabel = label
    self.m_RepairLine  = bottomLine
    self:addChild(label,      LABEL_Z_ORDER)
        :addChild(bottomLine, BOTTOM_LINE_Z_ORDER)
end

local function initCaptureInfo(self)
    local label      = createLabel(     CAPTURE_INFO_POS_X,     CAPTURE_INFO_POS_Y, CAPTURE_INFO_WIDTH,      CAPTURE_INFO_HEIGHT)
    local bottomLine = createBottomLine(CAPTURE_INFO_POS_X + 5, CAPTURE_INFO_POS_Y, CAPTURE_INFO_WIDTH - 10, CAPTURE_INFO_HEIGHT)

    self.m_CaptureLabel = label
    self.m_CaptureLine  = bottomLine
    self:addChild(label,      LABEL_Z_ORDER)
        :addChild(bottomLine, BOTTOM_LINE_Z_ORDER)
end

local function initIncomeInfo(self)
    local label = createLabel(CAPTURE_INFO_POS_X + 350, CAPTURE_INFO_POS_Y, CAPTURE_INFO_WIDTH, CAPTURE_INFO_HEIGHT)

    self.m_IncomeLabel = label
    self:addChild(label, LABEL_Z_ORDER)
end

local function initMoveCostInfo(self)
    local moveCostLabel = createLabel(MOVE_COST_INFO_POS_X, MOVE_COST_INFO_POS_Y + LINE_HEIGHT * 3, MOVE_COST_INFO_WIDTH, LINE_HEIGHT, LocalizationFunctions.getLocalizedText(112))
    local detailLabels  = createMoveCostInfoDetailLabels()

    self.m_MoveCostLabel   = moveCostLabel
    self.m_MoveCostDetails = detailLabels
    self:addChild(moveCostLabel, LABEL_Z_ORDER)
    for _, label in pairs(detailLabels) do
        self:addChild(label, LABEL_Z_ORDER)
    end
end

local function initTouchListener(self)
    local touchListener = cc.EventListenerTouchOneByOne:create()
    touchListener:setSwallowTouches(true)
    local isTouchWithinBackground

    touchListener:registerScriptHandler(function(touch, event)
        isTouchWithinBackground = DisplayNodeFunctions.isTouchWithinNode(touch, self.m_Background)
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)

    touchListener:registerScriptHandler(function(touch, event)
        if (not isTouchWithinBackground) then
            self:setEnabled(false)
        end
    end, cc.Handler.EVENT_TOUCH_ENDED)

    self.m_TouchListener = touchListener
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(touchListener, self)
end

--------------------------------------------------------------------------------
-- The private functions for updating the composition elements.
--------------------------------------------------------------------------------
local function updateDescriptionWithModelTile(self, tile)
    self.m_DescriptionLabel:setString(tile:getDescription())
end

local function updateDefenseInfoWithModelTile(self, tile)
    self.m_DefenseLabel:setString(LocalizationFunctions.getLocalizedText(103, tile:getDefenseBonusAmount(), tile:getDefenseBonusTargetCategoryFullName()))
end

local function updateRepairInfoWithModelTile(self, tile)
    if (not tile.getRepairTargetCategoryFullName) then
        self.m_RepairLabel:setString(LocalizationFunctions.getLocalizedText(105))
    else
        self.m_RepairLabel:setString(LocalizationFunctions.getLocalizedText(104, tile:getNormalizedRepairAmount(), tile:getRepairTargetCategoryFullName()))
    end
end

local function updateCaptureInfoWithModelTile(self, tile)
    if (not tile.getCurrentCapturePoint) then
        self.m_CaptureLabel:setString(LocalizationFunctions.getLocalizedText(107))
    else
        self.m_CaptureLabel:setString(LocalizationFunctions.getLocalizedText(106, tile:getCurrentCapturePoint(), tile:getMaxCapturePoint()))
    end
end

local function updateIncomeInfoWithModelTile(self, tile)
    if (tile.getIncomeAmount) then
        self.m_IncomeLabel:setString(LocalizationFunctions.getLocalizedText(108, tile:getIncomeAmount()))
    else
        self.m_IncomeLabel:setString(LocalizationFunctions.getLocalizedText(109))
    end
end

local function updateMoveCostInfoWithModelTile(self, tile, modelPlayer)
    for key, label in pairs(self.m_MoveCostDetails) do
        label:setString(LocalizationFunctions.getLocalizedText(111, key, tile:getMoveCostWithMoveType(key, modelPlayer)))
    end
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewTileDetail:ctor(param)
    initGreyMask(     self)
    initBackground(   self)
    initDescription(  self)
    initDefenseInfo(  self)
    initRepairInfo(   self)
    initCaptureInfo(  self)
    initIncomeInfo(   self)
    initMoveCostInfo( self)
    initTouchListener(self)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewTileDetail:updateWithModelTile(modelTile)
    updateDescriptionWithModelTile( self, modelTile)
    updateDefenseInfoWithModelTile( self, modelTile)
    updateRepairInfoWithModelTile(  self, modelTile)
    updateCaptureInfoWithModelTile( self, modelTile)
    updateIncomeInfoWithModelTile(  self, modelTile)
    updateMoveCostInfoWithModelTile(self, modelTile)

    return self
end

function ViewTileDetail:setEnabled(enabled)
    self:setVisible(enabled)
    self.m_TouchListener:setEnabled(enabled)

    return self
end

return ViewTileDetail
