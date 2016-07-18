
--[[--------------------------------------------------------------------------------
-- AnimationLoader是和动画相关的函数集合。
-- 主要职责：
--   根据GameConstant，读入帧动画到引擎的AnimationCache
--   提供获取动画的接口
-- 使用场景举例：
--   游戏开始运行时，载入在游戏中会用到的动画（unit/tile/爆炸等）
--   unit/tile从本函数集合获取其应当播放的动画
-- 其他：
--   可以考虑把GameConstant中有关动画的数据全部移动到这里，因为动画数据不影响游戏逻辑
--]]--------------------------------------------------------------------------------

local AnimationLoader = {}

local GAME_CONSTANT = require("res.data.GameConstant")

local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getUnitAnimationName(unitName, playerIndex, state)
    return unitName .. playerIndex .. state
end

local function getTileAnimationName(tileName, shapeIndex)
    return tileName .. shapeIndex
end

local function loadTileAnimations()
    for tileName, data in pairs(GAME_CONSTANT.tileAnimations) do
        for shapeIndex = 1, data.shapesCount do
            local pattern = string.format("c01_t%02d_s%02d_%s.png", data.typeIndex, shapeIndex, "f%02d")
            local animation = display.newAnimation(display.newFrames(pattern, 1, data.framesCount), data.durationPerFrame)
            display.setAnimationCache(getTileAnimationName(tileName, shapeIndex), animation)
        end
    end
end

local function loadUnitAnimations()
    for unitName, animationsForPlayers in pairs(GAME_CONSTANT.unitAnimations) do
        for playerIndex, animations in ipairs(animationsForPlayers) do
            local normal          = animations.normal
            local normalAnimation = display.newAnimation(display.newFrames(normal.pattern, 1, normal.framesCount), normal.durationPerFrame)
            display.setAnimationCache(getUnitAnimationName(unitName, playerIndex, "normal"), normalAnimation)

            local moving          = animations.moving
            local movingAnimation = display.newAnimation(display.newFrames(moving.pattern, 1, moving.framesCount), moving.durationPerFrame)
            display.setAnimationCache(getUnitAnimationName(unitName, playerIndex, "moving"), movingAnimation)
        end
    end
end

local function loadGridAnimations()
    local reachableGridAnimation = display.newAnimation(display.newFrames("c03_t03_s01_f%02d.png", 1, 15), 0.07)
    display.setAnimationCache("ReachableGrid", reachableGridAnimation)

    local attackableGridAnimation = display.newAnimation(display.newFrames("c03_t03_s02_f%02d.png", 1, 15), 0.07)
    display.setAnimationCache("AttackableGrid", attackableGridAnimation)

    local explosionAnimation = display.newAnimation(display.newFrames("c03_t08_s01_f%02d.png", 1, 9), 0.06)
    display.setAnimationCache("GridExplosion", explosionAnimation)

    local damageAnimation = display.newAnimation(display.newFrames("c03_t08_s02_f%02d.png", 1, 8), 0.04)
    display.setAnimationCache("GridDamage", damageAnimation)

    local targetCursorAnimation = display.newAnimation(display.newFrames("c03_t07_s08_f%02d.png", 1, 4), 0.08)
    display.setAnimationCache("TargetCursor", targetCursorAnimation)
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function AnimationLoader.load()
    loadTileAnimations()
    loadUnitAnimations()
    loadGridAnimations()
end

function AnimationLoader.getUnitAnimation(unitName, playerIndex, animationState)
    return display.getAnimationCache(getUnitAnimationName(unitName, playerIndex or 1, animationState or "normal"))
end

function AnimationLoader.getUnitAnimationWithTiledId(tiledID)
    return AnimationLoader.getUnitAnimation(GameConstantFunctions.getUnitTypeWithTiledId(tiledID), GameConstantFunctions.getPlayerIndexWithTiledId(tiledID), "normal")
end

function AnimationLoader.getTileAnimation(tileName, shapeIndex)
    return display.getAnimationCache(getTileAnimationName(tileName, shapeIndex or 1))
end

function AnimationLoader.getTileAnimationWithTiledId(tiledID)
    return AnimationLoader.getTileAnimation(GameConstantFunctions.getTileTypeWithTiledId(tiledID), GameConstantFunctions.getShapeIndexWithTiledId(tiledID))
end

return AnimationLoader
