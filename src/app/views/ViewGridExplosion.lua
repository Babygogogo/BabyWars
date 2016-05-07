
local ViewGridExplosion = class("ViewGridExplosion", cc.Node)

local GRID_SIZE          = require("app.utilities.GameConstantFunctions").getGridSize()
local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

local DAMAGE_Z_ORDER    = 1
local EXPLOSION_Z_ORDER = 0

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createAnimationExplosion(gridIndex, callbackOnFinish)
    local explosion = cc.Sprite:create()
    local x, y = GridIndexFunctions.toPosition(gridIndex)
    explosion:ignoreAnchorPointForPosition(true)
        :setPosition(x - GRID_SIZE.width, y)
        :playAnimationOnce(display.getAnimationCache("GridExplosion"), {removeSelf = true, onComplete = callbackOnFinish})

    return explosion
end

local function createAnimationDamage(gridIndex, callbackOnFinish)
    local damage = cc.Sprite:create()
    local x, y = GridIndexFunctions.toPosition(gridIndex)
    damage:ignoreAnchorPointForPosition(true)
        :setPosition(x - GRID_SIZE.width, y - GRID_SIZE.height)
        :playAnimationOnce(display.getAnimationCache("GridDamage"), {removeSelf = true, onComplete = callbackOnFinish})

    return damage
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewGridExplosion:ctor(param)
    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewGridExplosion:showAnimationExplosion(gridIndex, callbackOnFinish)
    self:addChild(createAnimationExplosion(gridIndex), EXPLOSION_Z_ORDER)

    return self
end

function ViewGridExplosion:showAnimationDamage(gridIndex, callbackOnFinish)
    self:addChild(createAnimationDamage(gridIndex), DAMAGE_Z_ORDER)

    return self
end

return ViewGridExplosion
