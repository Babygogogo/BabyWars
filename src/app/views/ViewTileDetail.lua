
local ViewTileDetail = class("ViewTileDetail", cc.Node)

local FONT_SIZE   = 25
local LINE_HEIGHT = FONT_SIZE / 5 * 8

local BACKGROUND_WIDTH  = display.width * 0.7
local BACKGROUND_HEIGHT = display.height * 0.7
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
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", {x = 4, y = 5, width = 1, height = 1})
    background:ignoreAnchorPointForPosition(true)
        :setPosition(BACKGROUND_POSITION_X, BACKGROUND_POSITION_Y)

        :setContentSize(BACKGROUND_WIDTH, BACKGROUND_HEIGHT)

    background.m_TouchSwallower = require("app.utilities.CreateTouchSwallowerForNode")(background)
    background:getEventDispatcher():addEventListenerWithSceneGraphPriority(background.m_TouchSwallower, background)

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
    local line = cc.Scale9Sprite:createWithSpriteFrameName("c03_t06_s01_f01.png", {x = 2, y = 0, width = 1, height = 1})
    line:ignoreAnchorPointForPosition(true)
        :setPosition(DESCRIPTION_POSITION_X + 5, DESCRIPTION_POSITION_Y)
        :setContentSize(DESCRIPTION_WIDTH - 10, DESCRIPTION_HEIGHT)

    return line
end

local function createDescriptionLabel()
    local label = cc.Label:createWithTTF("", "res/fonts/msyhbd.ttc", FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(BACKGROUND_POSITION_X + 5, BACKGROUND_POSITION_Y + 6)

        :setDimensions(BACKGROUND_WIDTH - 10, BACKGROUND_HEIGHT - 14)

        :setTextColor({r = 255, g = 255, b = 255})
        :enableOutline({r = 0, g = 0, b = 0}, 2)

    return label
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
    local line = cc.Scale9Sprite:createWithSpriteFrameName("c03_t06_s01_f01.png", {x = 2, y = 0, width = 1, height = 1})
    line:ignoreAnchorPointForPosition(true)
        :setPosition(DEFENSE_INFO_POSITION_X + 5, DEFENSE_INFO_POSITION_Y)
        :setContentSize(DEFENSE_INFO_WIDTH - 10, DEFENSE_INFO_HEIGHT)

    return line
end

local function createDefenseInfoLabel()
    local label = cc.Label:createWithTTF("", "res/fonts/msyhbd.ttc", FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(DEFENSE_INFO_POSITION_X, DEFENSE_INFO_POSITION_Y)

        :setDimensions(DEFENSE_INFO_WIDTH, DEFENSE_INFO_HEIGHT)

        :setTextColor({r = 255, g = 255, b = 255})
        :enableOutline({r = 0, g = 0, b = 0}, 2)

    return label
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
    local line = cc.Scale9Sprite:createWithSpriteFrameName("c03_t06_s01_f01.png", {x = 2, y = 0, width = 1, height = 1})
    line:ignoreAnchorPointForPosition(true)
        :setPosition(REPAIR_INFO_POSITION_X + 5, REPAIR_INFO_POSITION_Y)
        :setContentSize(REPAIR_INFO_WIDTH - 10, REPAIR_INFO_HEIGHT)

    return line
end

local function createRepairInfoLabel()
    local label = cc.Label:createWithTTF("", "res/fonts/msyhbd.ttc", FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(REPAIR_INFO_POSITION_X, REPAIR_INFO_POSITION_Y)

        :setDimensions(REPAIR_INFO_WIDTH, REPAIR_INFO_HEIGHT)

        :setTextColor({r = 255, g = 255, b = 255})
        :enableOutline({r = 0, g = 0, b = 0}, 2)

    return label
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
        local amount   = tile:getRepairAmount()
        info.m_Label:setString("Repair:  +" .. amount .. "HP (" .. catagory .. ")")
    else
        info.m_Label:setString("Repair: None")
    end
end

--------------------------------------------------------------------------------
-- The capture and income info.
--------------------------------------------------------------------------------
local function createCaptureAndIncomeInfoButtomLine()
    local line = cc.Scale9Sprite:createWithSpriteFrameName("c03_t06_s01_f01.png", {x = 2, y = 0, width = 1, height = 1})
    line:ignoreAnchorPointForPosition(true)
        :setPosition(CAPTURE_INFO_POSITION_X + 5, CAPTURE_INFO_POSITION_Y)
        :setContentSize(CAPTURE_INFO_WIDTH - 10, CAPTURE_INFO_HEIGHT)

    return line
end

local function createCaptureAndIncomeInfoCaptureLabel()
    local label = cc.Label:createWithTTF("", "res/fonts/msyhbd.ttc", FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(CAPTURE_INFO_POSITION_X, CAPTURE_INFO_POSITION_Y)

        :setDimensions(CAPTURE_INFO_WIDTH, CAPTURE_INFO_HEIGHT)

        :setTextColor({r = 255, g = 255, b = 255})
        :enableOutline({r = 0, g = 0, b = 0}, 2)

    return label
end

local function createCaptureAndIncomeInfIncomeLabel()
    local label = cc.Label:createWithTTF("", "res/fonts/msyhbd.ttc", FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(CAPTURE_INFO_POSITION_X + 350, CAPTURE_INFO_POSITION_Y)

        :setDimensions(CAPTURE_INFO_WIDTH, CAPTURE_INFO_HEIGHT)

        :setTextColor({r = 255, g = 255, b = 255})
        :enableOutline({r = 0, g = 0, b = 0}, 2)

    return label
end

local function createCaptureAndIncomeInfo()
    local buttomLine   = createCaptureAndIncomeInfoButtomLine()
    local captureLabel = createCaptureAndIncomeInfoCaptureLabel()
    local incomeLabel  = createCaptureAndIncomeInfIncomeLabel()

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
-- The touch listener.
--------------------------------------------------------------------------------
local function createTouchListener(view)
    local touchListener = cc.EventListenerTouchOneByOne:create()
    touchListener:setSwallowTouches(true)

	touchListener:registerScriptHandler(function()
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)

    touchListener:registerScriptHandler(function()
        view:setEnabled(false)
    end, cc.Handler.EVENT_TOUCH_ENDED)

    return touchListener
end

local function initWithTouchListener(view, touchListener)
    view.m_TouchListener = touchListener
    view:getEventDispatcher():addEventListenerWithSceneGraphPriority(view.m_TouchListener, view)
end

--------------------------------------------------------------------------------
-- The constructor and public methods.
--------------------------------------------------------------------------------
function ViewTileDetail:ctor(param)
    initWithScreenBackground(    self, createScreenBackground())
    initWithDetailBackground(    self, createDetailBackground())
    initWithDescription(         self, createDescription())
    initWithDefenseInfo(         self, createDefenseInfo())
    initWithRepairInfo(          self, createRepairInfo())
    initWithCaptureAndIncomeInfo(self, createCaptureAndIncomeInfo())
    initWithTouchListener(       self, createTouchListener(self))

    self:setCascadeOpacityEnabled(true)
        :setOpacity(180)

    if (param) then
        self:load(param)
    end

    return self
end

function ViewTileDetail:load(param)
    return self
end

function ViewTileDetail.createInstance(param)
    local view = ViewTileDetail:create():load(param)
    assert(view, "ViewTileDetail.createInstance() failed.")

    return view
end

function ViewTileDetail:updateWithModelTile(tile)
    updateDescriptionWithModelTile(self.m_Description, tile)
    updateDefenseInfoWithModelTile(self.m_DefenseInfo, tile)
    updateRepairInfoWithModelTile( self.m_RepairInfo,  tile)
    updateCaptureAndIncomeInfoWithModelTile(self.m_CaptureAndIncomeInfo, tile)

    return self
end

function ViewTileDetail:setEnabled(enabled)
    if (enabled) then
        self:setVisible(true)
        self:getEventDispatcher():resumeEventListenersForTarget(self, true)
    else
        self:setVisible(false)
        self:getEventDispatcher():pauseEventListenersForTarget(self, true)
    end

    return self
end

return ViewTileDetail
