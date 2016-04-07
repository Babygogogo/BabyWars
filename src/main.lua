
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
