
local ViewGridExplosion = class("ViewGridExplosion", cc.Node)

local GRID_SIZE          = require("app.utilities.GameConstantFunctions").getGridSize()
local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createSingleExplosion(gridIndex, callbackOnFinish)
    local explosion = cc.Sprite:create()
    local x, y = GridIndexFunctions.toPosition(gridIndex)
    explosion:ignoreAnchorPointForPosition(true)
        :setPosition(x - GRID_SIZE.width, y)
        :playAnimationOnce(display.getAnimationCache("GridExplosion"), {removeSelf = true, onComplete = callbackOnFinish})

    return explosion
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
function ViewGridExplosion:showExplosion(gridIndex, callbackOnFinish)
    self:addChild(createSingleExplosion(gridIndex))

    return self
end

return ViewGridExplosion
