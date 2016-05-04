
--[[--------------------------------------------------------------------------------
-- main.lua是lua程序的入口，在程序运行时被引擎自动调用。
--
-- 主要职责：
--   读取游戏资源文件
--   运行主场景
--
-- 使用场景举例：
--   只在程序运行时被引擎调用，不应该自行调用本文件。
--
-- 其他：
--   - 这个文件用到了游戏引擎的功能，因此服务器上的程序需要另写一个入口函数。
--]]--------------------------------------------------------------------------------

cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

require "config"
require "cocos.init"

local function main()
--    require("app.MyApp"):create():run("SceneMain")
---[[
    display.loadSpriteFrames("BabyWarsTextureTile.plist", "BabyWarsTextureTile.png")
    display.loadSpriteFrames("BabyWarsTextureUnit.plist", "BabyWarsTextureUnit.png")
    display.loadSpriteFrames("BabyWarsTextureUI.plist",   "BabyWarsTextureUI.png")

    require("app.utilities.AnimationLoader").load()
    require("app.utilities.GameConstantFunctions").init()

    math.randomseed(os.time())

    cc.Director:getInstance():setDisplayStats(true)

    local mainSceneActor = require("global.actors.Actor").createWithModelAndViewName("ModelSceneMain", nil, "ViewSceneMain")
    assert(mainSceneActor, "main() failed to create a main scene actor.")
    require("global.actors.ActorManager").setAndRunRootActor(mainSceneActor)
--]]
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
