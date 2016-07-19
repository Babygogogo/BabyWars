
local ViewGridEffect = class("ViewGridEffect", cc.Node)

local GRID_SIZE          = require("src.app.utilities.GameConstantFunctions").getGridSize()
local GridIndexFunctions = require("src.app.utilities.GridIndexFunctions")

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

return ViewGridEffect
