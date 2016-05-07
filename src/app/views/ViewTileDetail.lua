
local ViewTileDetail = class("ViewTileDetail", cc.Node)

local FONT_SIZE   = 25
local LINE_HEIGHT = FONT_SIZE / 5 * 8

local BACKGROUND_WIDTH  = display.width * 0.8
local BACKGROUND_HEIGHT = math.min(LINE_HEIGHT * 8 + 10, display.height * 0.9)
local BACKGROUND_POSITION_X = (display.width  - BACKGROUND_WIDTH) / 2
local BACKGROUND_POSITION_Y = (display.height - BACKGROUND_HEIGHT) / 2

local DESCRIPTION_WIDTH      = BACKGROUND_WIDTH - 10
local DESCRIPTION_HEIGHT     = LINE_HEIGHT * 2
local DESCRIPTION_POSITION_X = BACKGROUND_POSITION_X + 5
local DESCRIPTION_POSITION_Y = BACKGROUND_POSITION_Y + BACKGROUND_HEIGHT - DESCRIPTION_HEIGHT - 8

local DEFENSE_INFO_WIDTH      = BACKGROUND_WIDTH - 10
local DEFENSE_INFO_HEIGHT     = LINE_HEIGHT
local DEFENSE_INFO_POSITION_X = BACKGROUND_POSITION_X + 5
local DEFENSE_INFO_POSITION_Y = DESCRIPTION_POSITION_Y - DEFENSE_INFO_HEIGHT

local REPAIR_INFO_WIDTH      = BACKGROUND_WIDTH - 10
local REPAIR_INFO_HEIGHT     = LINE_HEIGHT
local REPAIR_INFO_POSITION_X = BACKGROUND_POSITION_X + 5
local REPAIR_INFO_POSITION_Y = DEFENSE_INFO_POSITION_Y - REPAIR_INFO_HEIGHT

local CAPTURE_INFO_WIDTH      = BACKGROUND_WIDTH - 10
local CAPTURE_INFO_HEIGHT     = LINE_HEIGHT
local CAPTURE_INFO_POSITION_X = BACKGROUND_POSITION_X + 5
local CAPTURE_INFO_POSITION_Y = REPAIR_INFO_POSITION_Y - CAPTURE_INFO_HEIGHT

local MOVE_COST_INFO_WIDTH      = BACKGROUND_WIDTH - 10
local MOVE_COST_INFO_HEIGHT     = LINE_HEIGHT * 4
local MOVE_COST_INFO_POSITION_X = BACKGROUND_POSITION_X + 5
local MOVE_COST_INFO_POSITION_Y = CAPTURE_INFO_POSITION_Y - MOVE_COST_INFO_HEIGHT

--------------------------------------------------------------------------------
-- Util functions.
--------------------------------------------------------------------------------
local BUTTOM_LINE_SPRITE_FRAME_NAME = "c03_t06_s01_f01.png"

local function createButtomLine(posX, poxY, width, height)
    local line = cc.Sprite:createWithSpriteFrameName(BUTTOM_LINE_SPRITE_FRAME_NAME)
    line:ignoreAnchorPointForPosition(true)
        :setPosition(posX, poxY)
        :setAnchorPoint(0, 0)
        :setScaleX(width / line:getContentSize().width)

    return line
end

local FONT_NAME          = "res/fonts/msyhbd.ttc"
local FONT_COLOR         = {r = 255, g = 255, b = 255}
local FONT_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local FONT_OUTLINE_WIDTH = 2

local function createLabel(posX, posY, width, height, text)
    local label = cc.Label:createWithTTF(text or "", FONT_NAME, FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(posX, posY)
        :setDimensions(width, height)

        :setTextColor(FONT_COLOR)
        :enableOutline(FONT_OUTLINE_COLOR, FONT_OUTLINE_WIDTH)

    return label
end

--------------------------------------------------------------------------------
-- The screen background (the grey transparent mask).
--------------------------------------------------------------------------------
local function createScreenBackground()
    local background = cc.LayerColor:create({r = 0, g = 0, b = 0, a = 160})
    background:setContentSize(display.width, display.height)
        :ignoreAnchorPointForPosition(true)

    return background
end

local function initWithScreenBackground(view, background)
    view.m_ScreenBackground = background
    view:addChild(background)
end

--------------------------------------------------------------------------------
-- The detail panel background.
--------------------------------------------------------------------------------
local function createDetailBackground()
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", {x = 4, y = 6, width = 1, height = 1})
    background:ignoreAnchorPointForPosition(true)
        :setPosition(BACKGROUND_POSITION_X, BACKGROUND_POSITION_Y)

        :setContentSize(BACKGROUND_WIDTH, BACKGROUND_HEIGHT)

    return background
end

local function initWithDetailBackground(view, background)
    view.m_DetailBackground = background
    view:addChild(background)
end

--------------------------------------------------------------------------------
-- The description.
--------------------------------------------------------------------------------
local function createDescriptionButtomLine()
    return createButtomLine(DESCRIPTION_POSITION_X + 5, DESCRIPTION_POSITION_Y,
                            DESCRIPTION_WIDTH - 10, DESCRIPTION_HEIGHT)
end

local function createDescriptionLabel()
    return createLabel(BACKGROUND_POSITION_X + 5, BACKGROUND_POSITION_Y + 6,
                    BACKGROUND_WIDTH - 10, BACKGROUND_HEIGHT - 14)
end

local function createDescription()
    local buttomLine = createDescriptionButtomLine()
    local label      = createDescriptionLabel()

    local description = cc.Node:create()
    description:ignoreAnchorPointForPosition(true)
        :addChild(buttomLine)
        :addChild(label)

    description.m_ButtomLine = buttomLine
    description.m_Label      = label

    return description
end

local function initWithDescription(view, description)
    view.m_Description = description
    view:addChild(description)
end

local function updateDescriptionWithModelTile(description, tile)
    description.m_Label:setString(tile:getDescription())
end

--------------------------------------------------------------------------------
-- The defense bonus info.
--------------------------------------------------------------------------------
local function createDefenseInfoButtomLine()
    return createButtomLine(DEFENSE_INFO_POSITION_X + 5, DEFENSE_INFO_POSITION_Y,
                            DEFENSE_INFO_WIDTH - 10, DEFENSE_INFO_HEIGHT)
end

local function createDefenseInfoLabel()
    return createLabel(DEFENSE_INFO_POSITION_X, DEFENSE_INFO_POSITION_Y,
                    DEFENSE_INFO_WIDTH, DEFENSE_INFO_HEIGHT)
end

local function createDefenseInfo()
    local buttomLine   = createDefenseInfoButtomLine()
    local defenseLabel = createDefenseInfoLabel()

    local info = cc.Node:create()
    info:ignoreAnchorPointForPosition(true)
        :addChild(buttomLine)
        :addChild(defenseLabel)

    info.m_ButtomLine   = buttomLine
    info.m_Label = defenseLabel

    return info
end

local function initWithDefenseInfo(view, info)
    view.m_DefenseInfo = info
    view:addChild(info)
end

local function updateDefenseInfoWithModelTile(info, tile)
    info.m_Label:setString("DefenseBonus:  " .. tile:getDefenseBonusAmount() .. "% (" .. tile:getDefenseBonusTargetCatagory() .. ")")
end

--------------------------------------------------------------------------------
-- The repair info.
--------------------------------------------------------------------------------
local function createRepairInfoButtomLine()
    return createButtomLine(REPAIR_INFO_POSITION_X + 5, REPAIR_INFO_POSITION_Y,
                            REPAIR_INFO_WIDTH - 10, REPAIR_INFO_HEIGHT)
end

local function createRepairInfoLabel()
    return createLabel(REPAIR_INFO_POSITION_X, REPAIR_INFO_POSITION_Y,
                    REPAIR_INFO_WIDTH, REPAIR_INFO_HEIGHT)
end

local function createRepairInfo()
    local buttomLine  = createRepairInfoButtomLine()
    local repairLabel = createRepairInfoLabel()

    local info = cc.Node:create()
    info:ignoreAnchorPointForPosition(true)
        :addChild(buttomLine)
        :addChild(repairLabel)

    info.m_ButtomLine = buttomLine
    info.m_Label      = repairLabel

    return info
end

local function initWithRepairInfo(view, info)
    view.m_RepairInfo = info
    view:addChild(info)
end

local function updateRepairInfoWithModelTile(info, tile)
    if (tile.getRepairTargetCatagory) then
        local catagory = tile:getRepairTargetCatagory()
        local amount   = tile:getNormalizedRepairAmount()
        info.m_Label:setString("Repair:  +" .. amount .. "HP (" .. catagory .. ")")
    else
        info.m_Label:setString("Repair: None")
    end
end

--------------------------------------------------------------------------------
-- The capture and income info.
--------------------------------------------------------------------------------
local function createCaptureAndIncomeInfoButtomLine()
    return createButtomLine(CAPTURE_INFO_POSITION_X + 5, CAPTURE_INFO_POSITION_Y,
                            CAPTURE_INFO_WIDTH - 10, CAPTURE_INFO_HEIGHT)
end

local function createCaptureAndIncomeInfoCaptureLabel()
    return createLabel(CAPTURE_INFO_POSITION_X, CAPTURE_INFO_POSITION_Y,
                    CAPTURE_INFO_WIDTH, CAPTURE_INFO_HEIGHT)
end

local function createCaptureAndIncomeInfoIncomeLabel()
    return createLabel(CAPTURE_INFO_POSITION_X + 350, CAPTURE_INFO_POSITION_Y,
                    CAPTURE_INFO_WIDTH, CAPTURE_INFO_HEIGHT)
end

local function createCaptureAndIncomeInfo()
    local buttomLine   = createCaptureAndIncomeInfoButtomLine()
    local captureLabel = createCaptureAndIncomeInfoCaptureLabel()
    local incomeLabel  = createCaptureAndIncomeInfoIncomeLabel()

    local info = cc.Node:create()
    info:ignoreAnchorPointForPosition(true)
        :addChild(buttomLine)
        :addChild(captureLabel)
        :addChild(incomeLabel)

    info.m_ButtomLine   = buttomLine
    info.m_CaptureLabel = captureLabel
    info.m_IncomeLabel  = incomeLabel

    return info
end

local function initWithCaptureAndIncomeInfo(view, info)
    view.m_CaptureAndIncomeInfo = info
    view:addChild(info)
end

local function updateCaptureAndIncomeInfoCaptureLabel(label, tile)
    if (tile.getCurrentCapturePoint) then
        local currentPoint = tile:getCurrentCapturePoint()
        local maxPoint     = tile:getMaxCapturePoint()
        label:setString("CapturePoint:  " .. currentPoint .. " / " .. maxPoint)
    else
        label:setString("CapturePoint: None")
    end
end

local function updateCaptureAndIncomeInfoIncomeLabel(label, tile)
    if (tile.getIncomeAmount) then
        label:setString("Income:  " .. tile:getIncomeAmount())
    else
        label:setString("Income: None")
    end
end

local function updateCaptureAndIncomeInfoWithModelTile(info, tile)
    updateCaptureAndIncomeInfoCaptureLabel(info.m_CaptureLabel, tile)
    updateCaptureAndIncomeInfoIncomeLabel( info.m_IncomeLabel,  tile)
end

--------------------------------------------------------------------------------
-- The move cost info.
--------------------------------------------------------------------------------
local function createMoveCostInfoMoveCostLabel()
    return createLabel(MOVE_COST_INFO_POSITION_X, MOVE_COST_INFO_POSITION_Y + LINE_HEIGHT * 3,
                    MOVE_COST_INFO_WIDTH, LINE_HEIGHT,
                    "Move Cost:")
end

local function createMoveCostInfoDetailLabels()
    local originX, originY = MOVE_COST_INFO_POSITION_X, MOVE_COST_INFO_POSITION_Y
    local width,   height =  MOVE_COST_INFO_WIDTH / 4,  LINE_HEIGHT
    return {
        infantry  = createLabel(originX,             originY + height * 2, width, height),
        mech      = createLabel(originX + width,     originY + height * 2, width, height),
        tireA     = createLabel(originX + width * 2, originY + height * 2, width, height),
        tireB     = createLabel(originX + width * 3, originY + height * 2, width, height),
        tank      = createLabel(originX,             originY + height,     width, height),
        air       = createLabel(originX + width * 1, originY + height,     width, height),
        ship      = createLabel(originX + width * 2, originY + height,     width, height),
        transport = createLabel(originX + width * 3, originY + height,     width, height),
    }
end

local function createMoveCostInfo()
    local moveCostLabel = createMoveCostInfoMoveCostLabel()
    local detailLabels = createMoveCostInfoDetailLabels()

    local info = cc.Node:create()
    info:ignoreAnchorPointForPosition(true)
        :addChild(moveCostLabel)

    for _, label in pairs(detailLabels) do
        info:addChild(label)
    end

    info.m_MoveCostLabel = captureLabel
    info.m_DetailLabels  = detailLabels

    return info
end

local function initWithMoveCostInfo(view, info)
    view.m_MoveCostInfo = info
    view:addChild(info)
end

local function updateMoveCostInfoDetailLabels(labels, tile, modelPlayer)
    for key, label in pairs(labels) do
        label:setString(key .. ": " .. (tile:getMoveCost(key, modelPlayer) or "-"))
    end
end

local function updateMoveCostInfoWithModelTile(info, modelTile, modelPlayer)
    updateMoveCostInfoDetailLabels(info.m_DetailLabels, modelTile, modelPlayer)
end

--------------------------------------------------------------------------------
-- The touch listener.
--------------------------------------------------------------------------------
local function createTouchListener(view)
    local touchListener = cc.EventListenerTouchOneByOne:create()
    touchListener:setSwallowTouches(true)
    local isTouchWithinBackground

    touchListener:registerScriptHandler(function(touch, event)
        isTouchWithinBackground = require("app.utilities.DisplayNodeFunctions").isTouchWithinNode(touch, view.m_DetailBackground)
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)

    touchListener:registerScriptHandler(function(touch, event)
        if (not isTouchWithinBackground) then
            view:setEnabled(false)
        end
    end, cc.Handler.EVENT_TOUCH_ENDED)

    return touchListener
end

local function initWithTouchListener(view, touchListener)
    view.m_TouchListener = touchListener
    view:getEventDispatcher():addEventListenerWithSceneGraphPriority(view.m_TouchListener, view)
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewTileDetail:ctor(param)
    initWithScreenBackground(    self, createScreenBackground())
    initWithDetailBackground(    self, createDetailBackground())
    initWithDescription(         self, createDescription())
    initWithDefenseInfo(         self, createDefenseInfo())
    initWithRepairInfo(          self, createRepairInfo())
    initWithCaptureAndIncomeInfo(self, createCaptureAndIncomeInfo())
    initWithMoveCostInfo(        self, createMoveCostInfo())
    initWithTouchListener(       self, createTouchListener(self))

    self:setCascadeOpacityEnabled(true)
        :setOpacity(180)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewTileDetail:updateWithModelTile(modelTile, modelPlayer)
    updateDescriptionWithModelTile(         self.m_Description,          modelTile)
    updateDefenseInfoWithModelTile(         self.m_DefenseInfo,          modelTile)
    updateRepairInfoWithModelTile(          self.m_RepairInfo,           modelTile)
    updateCaptureAndIncomeInfoWithModelTile(self.m_CaptureAndIncomeInfo, modelTile)
    updateMoveCostInfoWithModelTile(        self.m_MoveCostInfo,         modelTile, modelPlayer)

    return self
end

function ViewTileDetail:setEnabled(enabled)
    self:setVisible(enabled)
    self.m_TouchListener:setEnabled(enabled)

    return self
end

return ViewTileDetail
