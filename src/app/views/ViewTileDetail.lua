
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

local function createDefenseInfoDefenseLabel()
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
    local defenseLabel = createDefenseInfoDefenseLabel()

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
local function createDefenseInfoRepairLabel()
    local label = cc.Label:createWithTTF("", "res/fonts/msyhbd.ttc", FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(DEFENSE_INFO_POSITION_X + 300, DEFENSE_INFO_POSITION_Y)

        :setDimensions(DEFENSE_INFO_WIDTH, DEFENSE_INFO_HEIGHT)

        :setTextColor({r = 255, g = 255, b = 255})
        :enableOutline({r = 0, g = 0, b = 0}, 2)

    return label
end

local function updateDefenseInfoRepairLabel(label, tile)
    if (tile.getRepairTargetCatagory) then
        local catagory = tile:getRepairTargetCatagory()
        local amount   = tile:getRepairAmount()
        label:setString("Repair: " .. catagory .. "(+" .. amount .. ")")
            :setVisible(true)
    else
        label:setVisible(false)
    end
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
    initWithScreenBackground( self, createScreenBackground())
    initWithDetailBackground( self, createDetailBackground())
    initWithDescription(      self, createDescription())
    initWithDefenseInfo(      self, createDefenseInfo())
    initWithTouchListener(    self, createTouchListener(self))

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
