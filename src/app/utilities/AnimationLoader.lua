
local AnimationLoader = {}

local GAME_CONSTANT = require("res.data.GameConstant")

local function toAnimationName(tiledID)
    return "tiledID" .. tiledID
end

local function loadTiledAnimation(tiledID, pattern, frameCount, frameDuration)
    local animation = display.newAnimation(display.newFrames(pattern, 1, frameCount), frameDuration)
    display.setAnimationCache(toAnimationName(tiledID), animation)
end

local function loadTiledAnimations()
    local views = GAME_CONSTANT.Mapping_TiledIdToTemplateViewTileOrUnit
    for tiledID, view in ipairs(views) do
        local animations = view.animations
        local animation = animations.normal

        loadTiledAnimation(tiledID, animation.pattern, animation.framesCount, animation.durationPerFrame)
    end
end

local function loadGridAnimations()
    local reachableGridAnimation = display.newAnimation(display.newFrames("c03_t03_s01_f%02d.png", 1, 15), 0.07)
    display.setAnimationCache("ReachableGrid", reachableGridAnimation)

    local attackableGridAnimation = display.newAnimation(display.newFrames("c03_t03_s02_f%02d.png", 1, 15), 0.07)
    display.setAnimationCache("AttackableGrid", attackableGridAnimation)
end

function AnimationLoader.load()
    loadTiledAnimations()
    loadGridAnimations()
end

function AnimationLoader.getAnimationWithTiledID(tiledID)
    return display.getAnimationCache(toAnimationName(tiledID))
end

function AnimationLoader.getAnimationWithTypeName(name)
    local mapping = GAME_CONSTANT.Mapping_TiledIdToTemplateModelIdTileOrUnit
    for id, templateID in ipairs(mapping) do
        if (templateID.n == name) then
            return AnimationLoader.getAnimationWithTiledID(id)
        end
    end

    error("AnimationLoader.getAnimationWithTypeName() failed to find an animation with param name.")
end

return AnimationLoader
