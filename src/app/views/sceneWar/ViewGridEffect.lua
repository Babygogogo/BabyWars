
local ViewGridEffect = class("ViewGridEffect", cc.Node)

local GRID_SIZE          = require("src.app.utilities.GameConstantFunctions").getGridSize()
local GridIndexFunctions = require("src.app.utilities.GridIndexFunctions")

local SKILL_ACTIVATION_Z_ORDER = 3
local DAMAGE_Z_ORDER           = 2
local EXPLOSION_Z_ORDER        = 1
local SUPPLY_Z_ORDER           = 0

local SKILL_ACTIVATION_OFFSET_X = - (336 - GRID_SIZE.width)  / 2
local SKILL_ACTIVATION_OFFSET_Y = - (336 - GRID_SIZE.height) / 2
local SUPPLY_OFFSET_X           = GRID_SIZE.width  * 0.3
local SUPPLY_OFFSET_Y           = GRID_SIZE.height * 0.7

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createAnimationExplosion(gridIndex, callbackOnFinish)
    local animation = cc.Sprite:create()
    local x, y = GridIndexFunctions.toPosition(gridIndex)
    animation:ignoreAnchorPointForPosition(true)
        :setPosition(x - GRID_SIZE.width, y)
        :playAnimationOnce(display.getAnimationCache("GridExplosion"), {removeSelf = true, onComplete = callbackOnFinish})

    return animation
end

local function createAnimationDamage(gridIndex, callbackOnFinish)
    local animation = cc.Sprite:create()
    local x, y = GridIndexFunctions.toPosition(gridIndex)
    animation:ignoreAnchorPointForPosition(true)
        :setPosition(x - GRID_SIZE.width, y - GRID_SIZE.height)
        :playAnimationOnce(display.getAnimationCache("GridDamage"), {removeSelf = true, onComplete = callbackOnFinish})

    return animation
end

local function createAnimationSupplyOrRepair(gridIndex, isSupply)
    local animation = cc.Sprite:createWithSpriteFrameName(isSupply and "c03_t08_s03_f01.png" or "c03_t08_s04_f01.png")
    local x, y = GridIndexFunctions.toPosition(gridIndex)
    animation:setAnchorPoint(1, 0)
        :setPosition(x + SUPPLY_OFFSET_X, y + SUPPLY_OFFSET_Y)
        :setScale(2)

    local action = cc.Sequence:create(
        cc.ScaleTo:create(0.1, 1),
        cc.DelayTime:create(0.6),
        cc.CallFunc:create(function() animation:removeFromParent() end)
    )
    animation:runAction(action)

    return animation
end

local function createAnimationSiloAttack(gridIndex)
    local sprite = cc.Sprite:create()
    local x, y   = GridIndexFunctions.toPosition(gridIndex)
    sprite:ignoreAnchorPointForPosition(true)
        :setPosition(x - GRID_SIZE.width, y - GRID_SIZE.height)
        :playAnimationOnce(display.getAnimationCache("GridDamage"), {
            onComplete = function()
                sprite:setPosition(x - GRID_SIZE.width, y)
                    :playAnimationOnce(display.getAnimationCache("GridExplosion"), {removeSelf = true})
            end,
        })

    return sprite
end

local function createAnimationSkillActivation(gridIndex)
    local sprite = cc.Sprite:create()
    local x, y   = GridIndexFunctions.toPosition(gridIndex)
    sprite:ignoreAnchorPointForPosition(true)
        :setPosition(x + SKILL_ACTIVATION_OFFSET_X, y + SKILL_ACTIVATION_OFFSET_Y)
        :playAnimationOnce(display.getAnimationCache("SkillActivation"), {removeSelf = true})

    return sprite
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewGridEffect:ctor(param)
    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewGridEffect:showAnimationExplosion(gridIndex, callbackOnFinish)
    self:addChild(createAnimationExplosion(gridIndex), EXPLOSION_Z_ORDER)

    return self
end

function ViewGridEffect:showAnimationDamage(gridIndex, callbackOnFinish)
    self:addChild(createAnimationDamage(gridIndex), DAMAGE_Z_ORDER)

    return self
end

function ViewGridEffect:showAnimationSupply(gridIndex)
    self:addChild(createAnimationSupplyOrRepair(gridIndex, true), SUPPLY_Z_ORDER)

    return self
end

function ViewGridEffect:showAnimationRepair(gridIndex)
    self:addChild(createAnimationSupplyOrRepair(gridIndex, false), SUPPLY_Z_ORDER)

    return self
end

function ViewGridEffect:showAnimationSiloAttack(gridIndex)
    self:addChild(createAnimationSiloAttack(gridIndex), EXPLOSION_Z_ORDER)

    return self
end

function ViewGridEffect:showAnimationSkillActivation(gridIndex)
    self:addChild(createAnimationSkillActivation(gridIndex), SKILL_ACTIVATION_Z_ORDER)

    return self
end

return ViewGridEffect
