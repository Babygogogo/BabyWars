
local ViewUnitDetail = class("ViewUnitDetail", cc.Node)

local LocalizationFunctions = requireBW("src.app.utilities.LocalizationFunctions")
local AnimationLoader       = requireBW("src.app.utilities.AnimationLoader")
local DisplayNodeFunctions  = requireBW("src.app.utilities.DisplayNodeFunctions")

local PRIMARY_WEAPON_ICONS_Z_ORDER   = 2
local SECONDARY_WEAPON_ICONS_Z_ORDER = 2
local DEFENSE_ICONS_Z_ORDER          = 2
local DESCRIPTION_LABEL_Z_ORDER      = 1
local MOVEMENT_LABEL_Z_ORDER         = 1
local VISION_LABEL_Z_ORDER           = 1
local FUEL_LABEL_Z_ORDER             = 1
local PRIMARY_WEAPON_LABEL_Z_ORDER   = 1
local SECONDARY_WEAPON_LABEL_Z_ORDER = 1
local DEFENSE_LABEL_Z_ORDER          = 1
local DESCRIPTION_LINE_Z_ORDER       = 0
local MOVEMENT_LINE_Z_ORDER          = 0
local FUEL_LINE_Z_ORDER              = 0
local PRIMARY_WEAPON_LINE_Z_ORDER    = 0
local SECONDARY_WEAPON_LINE_Z_ORDER  = 0
local BACKGROUND_Z_ORDER             = 0
local GREY_MASK_Z_ORDER              = -1

local FONT_SIZE          = 25
local LINE_HEIGHT        = FONT_SIZE / 5 * 8
local FONT_NAME          = "res/fonts/msyhbd.ttc"
local FONT_COLOR         = {r = 255, g = 255, b = 255}
local FONT_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local FONT_OUTLINE_WIDTH = 2

local BACKGROUND_WIDTH  = display.width * 0.86
local BACKGROUND_HEIGHT = math.min(LINE_HEIGHT * 11 + 10, display.height * 0.95)
local BACKGROUND_POS_X  = (display.width  - BACKGROUND_WIDTH) / 2
local BACKGROUND_POS_Y  = (display.height - BACKGROUND_HEIGHT) / 2

local DESCRIPTION_WIDTH  = BACKGROUND_WIDTH - 10
local DESCRIPTION_HEIGHT = LINE_HEIGHT * 2
local DESCRIPTION_POS_X  = BACKGROUND_POS_X + 5
local DESCRIPTION_POS_Y  = BACKGROUND_POS_Y + BACKGROUND_HEIGHT - DESCRIPTION_HEIGHT - 8

local MOVEMENT_INFO_WIDTH  = BACKGROUND_WIDTH - 10
local MOVEMENT_INFO_HEIGHT = LINE_HEIGHT
local MOVEMENT_INFO_POS_X  = BACKGROUND_POS_X + 5
local MOVEMENT_INFO_POS_Y  = DESCRIPTION_POS_Y - MOVEMENT_INFO_HEIGHT

local VISION_INFO_WIDTH  = 300
local VISION_INFO_HEIGHT = LINE_HEIGHT
local VISION_INFO_POS_X  = BACKGROUND_POS_X + BACKGROUND_WIDTH - VISION_INFO_WIDTH
local VISION_INFO_POS_Y  = DESCRIPTION_POS_Y - MOVEMENT_INFO_HEIGHT

local FUEL_INFO_WIDTH  = BACKGROUND_WIDTH - 10
local FUEL_INFO_HEIGHT = LINE_HEIGHT * 2
local FUEL_INFO_POS_X  = BACKGROUND_POS_X + 5
local FUEL_INFO_POS_Y  = MOVEMENT_INFO_POS_Y - FUEL_INFO_HEIGHT

local PRIMARY_WEAPON_INFO_WIDTH  = BACKGROUND_WIDTH - 10
local PRIMARY_WEAPON_INFO_HEIGHT = LINE_HEIGHT * 2
local PRIMARY_WEAPON_INFO_POS_X  = BACKGROUND_POS_X + 5
local PRIMARY_WEAPON_INFO_POS_Y  = FUEL_INFO_POS_Y - PRIMARY_WEAPON_INFO_HEIGHT

local SECONDARY_WEAPON_INFO_WIDTH  = BACKGROUND_WIDTH - 10
local SECONDARY_WEAPON_INFO_HEIGHT = LINE_HEIGHT * 2
local SECONDARY_WEAPON_INFO_POS_X  = BACKGROUND_POS_X + 5
local SECONDARY_WEAPON_INFO_POS_Y  = PRIMARY_WEAPON_INFO_POS_Y - SECONDARY_WEAPON_INFO_HEIGHT

local DEFENSE_INFO_WIDTH  = BACKGROUND_WIDTH - 10
local DEFENSE_INFO_HEIGHT = LINE_HEIGHT * 2
local DEFENSE_INFO_POS_X  = BACKGROUND_POS_X + 5
local DEFENSE_INFO_POS_Y  = SECONDARY_WEAPON_INFO_POS_Y - DEFENSE_INFO_HEIGHT

local ICON_SCALE = FONT_SIZE * 0.016
local GRID_WIDTH = requireBW("src.app.utilities.GameConstantFunctions").getGridSize().width

--------------------------------------------------------------------------------
-- Util functions.
--------------------------------------------------------------------------------
local BUTTOM_LINE_SPRITE_FRAME_NAME = "c03_t06_s01_f01.png"

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

local function createUnitIcons(posX, posY)
    local icons = cc.Node:create()
    icons:ignoreAnchorPointForPosition(true)
        :setPosition(posX, posY)
        :setScale(ICON_SCALE)

    return icons
end

local function resetIconsWithTypeNames(icons, typeNames)
    icons:removeAllChildren()
        :setVisible(true)

    for i, name in ipairs(typeNames) do
        local icon = cc.Sprite:create()
        icon:ignoreAnchorPointForPosition(true)
            :setPosition(GRID_WIDTH * (i - 1), 0)
            :playAnimationForever(AnimationLoader.getUnitAnimation(name))

        icons:addChild(icon)
    end

    icons.m_Width = #typeNames * GRID_WIDTH * ICON_SCALE
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
    local label      = createLabel(DESCRIPTION_POS_X, DESCRIPTION_POS_Y, DESCRIPTION_WIDTH, DESCRIPTION_HEIGHT)
    local bottomLine = createBottomLine(DESCRIPTION_POS_X + 5, DESCRIPTION_POS_Y, DESCRIPTION_WIDTH - 10, DESCRIPTION_HEIGHT)

    self.m_DescriptionLabel = label
    self.m_DescriptionLine  = bottomLine
    self:addChild(label,      DESCRIPTION_LABEL_Z_ORDER)
        :addChild(bottomLine, DESCRIPTION_LINE_Z_ORDER)
end

local function initMovementInfo(self)
    local label      = createLabel(MOVEMENT_INFO_POS_X, MOVEMENT_INFO_POS_Y, MOVEMENT_INFO_WIDTH, MOVEMENT_INFO_HEIGHT)
    local bottomLine = createBottomLine(MOVEMENT_INFO_POS_X + 5, MOVEMENT_INFO_POS_Y, MOVEMENT_INFO_WIDTH - 10, MOVEMENT_INFO_HEIGHT)

    self.m_MovementLabel = label
    self.m_MovementLine  = bottomLine
    self:addChild(label,      MOVEMENT_LABEL_Z_ORDER)
        :addChild(bottomLine, MOVEMENT_LINE_Z_ORDER)
end

local function initVisionInfo(self)
    local label = createLabel(VISION_INFO_POS_X, VISION_INFO_POS_Y, VISION_INFO_WIDTH, VISION_INFO_HEIGHT)

    self.m_VisionLabel = label
    self:addChild(label, VISION_LABEL_Z_ORDER)
end

local function initFuelInfo(self)
    local label = createLabel(FUEL_INFO_POS_X, FUEL_INFO_POS_Y, FUEL_INFO_WIDTH, FUEL_INFO_HEIGHT)
    local bottomLine = createBottomLine(FUEL_INFO_POS_X + 5, FUEL_INFO_POS_Y, FUEL_INFO_WIDTH - 10, FUEL_INFO_HEIGHT)

    self.m_FuelLabel = label
    self.m_FuelLine  = bottomLine
    self:addChild(label,      FUEL_LABEL_Z_ORDER)
        :addChild(bottomLine, FUEL_LINE_Z_ORDER)
end

local function initPrimaryWeaponInfo(self)
    local briefLabel  = createLabel(     PRIMARY_WEAPON_INFO_POS_X,       PRIMARY_WEAPON_INFO_POS_Y,    PRIMARY_WEAPON_INFO_WIDTH,      PRIMARY_WEAPON_INFO_HEIGHT)
    local fatalLabel  = createLabel(     PRIMARY_WEAPON_INFO_POS_X,       PRIMARY_WEAPON_INFO_POS_Y,    PRIMARY_WEAPON_INFO_WIDTH / 2,  PRIMARY_WEAPON_INFO_HEIGHT / 2, LocalizationFunctions.getLocalizedText(96))
    local fatalIcons  = createUnitIcons( PRIMARY_WEAPON_INFO_POS_X + 80,  PRIMARY_WEAPON_INFO_POS_Y + 6)
    local strongLabel = createLabel(     PRIMARY_WEAPON_INFO_POS_X + 300, PRIMARY_WEAPON_INFO_POS_Y,    PRIMARY_WEAPON_INFO_WIDTH / 2,  PRIMARY_WEAPON_INFO_HEIGHT / 2, LocalizationFunctions.getLocalizedText(97))
    local strongIcons = createUnitIcons( PRIMARY_WEAPON_INFO_POS_X,       PRIMARY_WEAPON_INFO_POS_Y + 6)
    local bottomLine  = createBottomLine(PRIMARY_WEAPON_INFO_POS_X + 5,   PRIMARY_WEAPON_INFO_POS_Y,    PRIMARY_WEAPON_INFO_WIDTH - 10, PRIMARY_WEAPON_INFO_HEIGHT)

    self.m_PrimaryWeaponBriefLabel  = briefLabel
    self.m_PrimaryWeaponFatalLabel  = fatalLabel
    self.m_PrimaryWeaponFatalIcons  = fatalIcons
    self.m_PrimaryWeaponStrongLabel = strongLabel
    self.m_PrimaryWeaponStrongIcons = strongIcons
    self.m_PrimaryWeaponLine        = bottomLine
    self:addChild(briefLabel,  PRIMARY_WEAPON_LABEL_Z_ORDER)
        :addChild(fatalLabel,  PRIMARY_WEAPON_LABEL_Z_ORDER)
        :addChild(strongLabel, PRIMARY_WEAPON_LABEL_Z_ORDER)
        :addChild(fatalIcons,  PRIMARY_WEAPON_ICONS_Z_ORDER)
        :addChild(strongIcons, PRIMARY_WEAPON_ICONS_Z_ORDER)
        :addChild(bottomLine,  PRIMARY_WEAPON_LINE_Z_ORDER)
end

local function initSecondaryWeaponInfo(self)
    local briefLabel  = createLabel(     SECONDARY_WEAPON_INFO_POS_X,       SECONDARY_WEAPON_INFO_POS_Y,    SECONDARY_WEAPON_INFO_WIDTH,      SECONDARY_WEAPON_INFO_HEIGHT)
    local fatalLabel  = createLabel(     SECONDARY_WEAPON_INFO_POS_X,       SECONDARY_WEAPON_INFO_POS_Y,    SECONDARY_WEAPON_INFO_WIDTH / 2,  SECONDARY_WEAPON_INFO_HEIGHT / 2, LocalizationFunctions.getLocalizedText(96))
    local fatalIcons  = createUnitIcons( SECONDARY_WEAPON_INFO_POS_X + 80,  SECONDARY_WEAPON_INFO_POS_Y + 6)
    local strongLabel = createLabel(     SECONDARY_WEAPON_INFO_POS_X + 300, SECONDARY_WEAPON_INFO_POS_Y,    SECONDARY_WEAPON_INFO_WIDTH / 2,  SECONDARY_WEAPON_INFO_HEIGHT / 2, LocalizationFunctions.getLocalizedText(97))
    local strongIcons = createUnitIcons( SECONDARY_WEAPON_INFO_POS_X,       SECONDARY_WEAPON_INFO_POS_Y + 6)
    local bottomLine  = createBottomLine(SECONDARY_WEAPON_INFO_POS_X + 5,   SECONDARY_WEAPON_INFO_POS_Y,    SECONDARY_WEAPON_INFO_WIDTH - 10, SECONDARY_WEAPON_INFO_HEIGHT)

    self.m_SecondaryWeaponBriefLabel  = briefLabel
    self.m_SecondaryWeaponFatalLabel  = fatalLabel
    self.m_SecondaryWeaponFatalIcons  = fatalIcons
    self.m_SecondaryWeaponStrongLabel = strongLabel
    self.m_SecondaryWeaponStrongIcons = strongIcons
    self.m_SecondaryWeaponLine        = bottomLine
    self:addChild(briefLabel,  SECONDARY_WEAPON_LABEL_Z_ORDER)
        :addChild(fatalLabel,  SECONDARY_WEAPON_LABEL_Z_ORDER)
        :addChild(strongLabel, SECONDARY_WEAPON_LABEL_Z_ORDER)
        :addChild(fatalIcons,  SECONDARY_WEAPON_ICONS_Z_ORDER)
        :addChild(strongIcons, SECONDARY_WEAPON_ICONS_Z_ORDER)
        :addChild(bottomLine,  SECONDARY_WEAPON_LINE_Z_ORDER)
end

local function initDefenseInfo(self)
    local briefLabel = createLabel(    DEFENSE_INFO_POS_X,       DEFENSE_INFO_POS_Y,    DEFENSE_INFO_WIDTH,     DEFENSE_INFO_HEIGHT,     LocalizationFunctions.getLocalizedText(100))
    local fatalLabel = createLabel(    DEFENSE_INFO_POS_X,       DEFENSE_INFO_POS_Y,    DEFENSE_INFO_WIDTH / 2, DEFENSE_INFO_HEIGHT / 2, LocalizationFunctions.getLocalizedText(101))
    local fatalIcons = createUnitIcons(DEFENSE_INFO_POS_X + 80,  DEFENSE_INFO_POS_Y + 6)
    local weakLabel  = createLabel(    DEFENSE_INFO_POS_X + 300, DEFENSE_INFO_POS_Y,    DEFENSE_INFO_WIDTH / 2, DEFENSE_INFO_HEIGHT / 2, LocalizationFunctions.getLocalizedText(102))
    local weakIcons  = createUnitIcons(DEFENSE_INFO_POS_X,       DEFENSE_INFO_POS_Y + 6)

    self.m_DefenseBriefLabel = briefLabel
    self.m_DefenseFatalLabel = fatalLabel
    self.m_DefenseFatalIcons = fatalIcons
    self.m_DefenseWeakLabel  = weakLabel
    self.m_DefenseWeakIcons  = weakIcons
    self:addChild(briefLabel, DEFENSE_LABEL_Z_ORDER)
        :addChild(fatalLabel, DEFENSE_LABEL_Z_ORDER)
        :addChild(weakLabel,  DEFENSE_LABEL_Z_ORDER)
        :addChild(fatalIcons, DEFENSE_ICONS_Z_ORDER)
        :addChild(weakIcons,  DEFENSE_ICONS_Z_ORDER)
end

local function initWithTouchListener(self)
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
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(self.m_TouchListener, self)
end

--------------------------------------------------------------------------------
-- The private functions for updating the composition elements.
--------------------------------------------------------------------------------
local function updateDescriptionWithModelUnit(self, unit)
    self.m_DescriptionLabel:setString(unit:getDescription())
end

local function updateMovementInfoWithModelUnit(self, unit)
    self.m_MovementLabel:setString(LocalizationFunctions.getLocalizedText(91, unit:getMoveRange(), unit:getMoveTypeFullName()))
end

local function updateVisionInfoWithModelUnit(self, unit)
    self.m_VisionLabel:setString(LocalizationFunctions.getLocalizedText(92, unit:getVisionForPlayerIndex(unit:getPlayerIndex())))
end

local function updateFuelInfoWithModelUnit(self, unit)
    self.m_FuelLabel:setString(LocalizationFunctions.getLocalizedText(93, unit:getCurrentFuel(), unit:getMaxFuel(), unit:getFuelConsumptionPerTurn(), unit:shouldDestroyOnOutOfFuel()))
end

local function updatePrimaryWeaponInfoWithModelUnit(self, unit)
    if (not ((unit.hasPrimaryWeapon) and (unit:hasPrimaryWeapon()))) then
        self.m_PrimaryWeaponBriefLabel :setString(LocalizationFunctions.getLocalizedText(95))
        self.m_PrimaryWeaponFatalLabel :setVisible(false)
        self.m_PrimaryWeaponFatalIcons :setVisible(false)
        self.m_PrimaryWeaponStrongLabel:setVisible(false)
        self.m_PrimaryWeaponStrongIcons:setVisible(false)
    else
        resetIconsWithTypeNames(self.m_PrimaryWeaponFatalIcons,  unit:getPrimaryWeaponFatalList())
        resetIconsWithTypeNames(self.m_PrimaryWeaponStrongIcons, unit:getPrimaryWeaponStrongList())

        self.m_PrimaryWeaponBriefLabel :setString(LocalizationFunctions.getLocalizedText(94, unit:getPrimaryWeaponFullName(), unit:getPrimaryWeaponCurrentAmmo(), unit:getPrimaryWeaponMaxAmmo(), unit:getAttackRangeMinMax()))
        self.m_PrimaryWeaponFatalLabel :setVisible(true)
        self.m_PrimaryWeaponFatalIcons :setVisible(true)
        self.m_PrimaryWeaponStrongLabel:setVisible(true)
            :setPosition(PRIMARY_WEAPON_INFO_POS_X + math.max(85 + self.m_PrimaryWeaponFatalIcons.m_Width, 120), PRIMARY_WEAPON_INFO_POS_Y)
        self.m_PrimaryWeaponStrongIcons:setVisible(true)
            :setPosition(self.m_PrimaryWeaponStrongLabel:getPositionX() + 80, self.m_PrimaryWeaponStrongIcons:getPositionY())
    end
end

local function updateSecondaryWeaponInfoWithModelUnit(self, unit)
    if (not ((unit.hasSecondaryWeapon) and (unit:hasSecondaryWeapon()))) then
        self.m_SecondaryWeaponBriefLabel :setString(LocalizationFunctions.getLocalizedText(99))
        self.m_SecondaryWeaponFatalLabel :setVisible(false)
        self.m_SecondaryWeaponFatalIcons :setVisible(false)
        self.m_SecondaryWeaponStrongLabel:setVisible(false)
        self.m_SecondaryWeaponStrongIcons:setVisible(false)
    else
        resetIconsWithTypeNames(self.m_SecondaryWeaponFatalIcons,  unit:getSecondaryWeaponFatalList())
        resetIconsWithTypeNames(self.m_SecondaryWeaponStrongIcons, unit:getSecondaryWeaponStrongList())

        self.m_SecondaryWeaponBriefLabel :setString(LocalizationFunctions.getLocalizedText(98, unit:getSecondaryWeaponFullName(), unit:getAttackRangeMinMax()))
        self.m_SecondaryWeaponFatalLabel :setVisible(true)
        self.m_SecondaryWeaponFatalIcons :setVisible(true)
        self.m_SecondaryWeaponStrongLabel:setVisible(true)
            :setPosition(SECONDARY_WEAPON_INFO_POS_X + math.max(85 + self.m_SecondaryWeaponFatalIcons.m_Width, 120), SECONDARY_WEAPON_INFO_POS_Y)
        self.m_SecondaryWeaponStrongIcons:setVisible(true)
            :setPosition(self.m_SecondaryWeaponStrongLabel:getPositionX() + 80, self.m_SecondaryWeaponStrongIcons:getPositionY())
    end
end

local function updateDefenseInfoWithModelUnit(self, unit)
    resetIconsWithTypeNames(self.m_DefenseFatalIcons, unit:getDefenseFatalList())
    resetIconsWithTypeNames(self.m_DefenseWeakIcons,  unit:getDefenseWeakList())

    self.m_DefenseWeakLabel:setPositionX(DEFENSE_INFO_POS_X + math.max(85 + self.m_DefenseFatalIcons.m_Width, 120))
    self.m_DefenseWeakIcons:setPositionX(self.m_DefenseWeakLabel:getPositionX() + 80)
end

--------------------------------------------------------------------------------
-- The constructor and public functions.
--------------------------------------------------------------------------------
function ViewUnitDetail:ctor(param)
    initGreyMask(           self)
    initBackground(         self)
    initDescription(        self)
    initMovementInfo(       self)
    initVisionInfo(         self)
    initFuelInfo(           self)
    initPrimaryWeaponInfo(  self)
    initSecondaryWeaponInfo(self)
    initDefenseInfo(        self)
    initWithTouchListener(  self)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewUnitDetail:updateWithModelUnit(modelUnit)
    updateDescriptionWithModelUnit(        self, modelUnit)
    updateMovementInfoWithModelUnit(       self, modelUnit)
    updateVisionInfoWithModelUnit(         self, modelUnit)
    updateFuelInfoWithModelUnit(           self, modelUnit)
    updatePrimaryWeaponInfoWithModelUnit(  self, modelUnit)
    updateSecondaryWeaponInfoWithModelUnit(self, modelUnit)
    updateDefenseInfoWithModelUnit(        self, modelUnit)

    return self
end

function ViewUnitDetail:setEnabled(enabled)
    self:setVisible(enabled)
    self.m_TouchListener:setEnabled(enabled)

    return self
end

return ViewUnitDetail
