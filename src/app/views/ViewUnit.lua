
local ViewUnit = class("ViewUnit", cc.Node)

local COLOR_IDLE             = {r = 255, g = 255, b = 255}
local COLOR_ACTIONED         = {r = 170, g = 170, b = 170}
local MOVE_DURATION_PER_GRID = 0.1

local TypeChecker           = require("app.utilities.TypeChecker")
local AnimationLoader       = require("app.utilities.AnimationLoader")
local GridIndexFunctions    = require("app.utilities.GridIndexFunctions")
local GameConstantFunctions = require("app.utilities.GameConstantFunctions")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createActionMoveAlongPath(path, callback)
    local steps = {}
    for i = 2, #path do
        steps[#steps + 1] = cc.MoveTo:create(MOVE_DURATION_PER_GRID, GridIndexFunctions.toPositionTable(path[i]))
    end

    steps[#steps + 1] = cc.CallFunc:create(callback)
    return cc.Sequence:create(unpack(steps))
end

--------------------------------------------------------------------------------
-- The unit sprite.
--------------------------------------------------------------------------------
local function createUnitSprite()
    local sprite = cc.Sprite:create()
    sprite:ignoreAnchorPointForPosition(true)

    return sprite
end

local function initWithUnitSprite(self, sprite)
    self.m_UnitSprite = sprite
    self:addChild(sprite)
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ViewUnit:ctor(param)
    self:ignoreAnchorPointForPosition(true)

    initWithUnitSprite(self, createUnitSprite())

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewUnit:updateWithTiledID(tiledID)
    assert(TypeChecker.isTiledID(tiledID))
    if (self.m_TiledID == tiledID) then
        return
    end
    self.m_TiledID = tiledID

    local unitName    = GameConstantFunctions.getUnitNameWithTiledId(tiledID)
    local playerIndex = GameConstantFunctions.getPlayerIndexWithTiledId(tiledID)
    self.m_UnitSprite:stopAllActions()
        :playAnimationForever(AnimationLoader.getUnitAnimation(unitName, playerIndex, "normal"))

    return self
end

function ViewUnit:setStateIdle()
    self.m_UnitSprite:setColor(COLOR_IDLE)

    return self
end

function ViewUnit:setStateActioned()
    self.m_UnitSprite:setColor(COLOR_ACTIONED)

    return self
end

function ViewUnit:moveAlongPath(path, callbackOnFinish)
    self:runAction(createActionMoveAlongPath(path, callbackOnFinish))

    return self
end

return ViewUnit
