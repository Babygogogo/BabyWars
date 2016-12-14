
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

local fileUtils = cc.FileUtils:getInstance()
fileUtils:setPopupNotify(false)
fileUtils:addSearchPath("src/")
fileUtils:addSearchPath("res/")

require "config"
require "cocos.init"

local function main()
    display.loadSpriteFrames("BabyWarsTextureTile.plist",    "BabyWarsTextureTile.png")
    display.loadSpriteFrames("BabyWarsTextureUnit.plist",    "BabyWarsTextureUnit.png")
    display.loadSpriteFrames("BabyWarsTextureUI.plist",      "BabyWarsTextureUI.png")
    display.loadSpriteFrames("BabyWarsTextureGallery.plist", "BabyWarsTextureGallery.png")

    require("src.app.utilities.AnimationLoader")       .load()
    require("src.app.utilities.GameConstantFunctions") .init()

    math.randomseed(os.time())

    --cc.Director:getInstance():setDisplayStats(true)

    local actorSceneMain = require("src.global.actors.Actor").createWithModelAndViewName("sceneMain.ModelSceneMain", nil, "sceneMain.ViewSceneMain")
    require("src.app.utilities.WebSocketManager").init()
    require("src.global.actors.ActorManager").setAndRunRootActor(actorSceneMain)
    actorSceneMain:getModel():getModelMessageIndicator():showMessage(require("src.app.utilities.LocalizationFunctions").getLocalizedText(30, "StartConnecting"))
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
