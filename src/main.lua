
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

--------------------------------------------------------------------------------
-- The global variables.
--------------------------------------------------------------------------------
requireBW = require

__G__TRACKBACK__ = function(msg)
    local msg = debug.traceback(msg, 3)
    print(msg)

    local scene = display.getRunningScene()
    if (scene ~= nil) then
        scene:addChild(requireBW("app.views.common.ViewErrorIndicator"):create(msg), 999)
    end

    return msg
end

--------------------------------------------------------------------------------
-- The app initializers.
--------------------------------------------------------------------------------
local fileUtils = cc.FileUtils:getInstance()
fileUtils:setPopupNotify(false)
fileUtils:addSearchPath("src/")
fileUtils:addSearchPath("res/")

require "config"
require "cocos.init"

local function main()
    display.loadSpriteFrames("BabyWarsTextureTile.plist",    "BabyWarsTextureTile.pvr.ccz")
    display.loadSpriteFrames("BabyWarsTextureUnit.plist",    "BabyWarsTextureUnit.pvr.ccz")
    display.loadSpriteFrames("BabyWarsTextureUI.plist",      "BabyWarsTextureUI.pvr.ccz")
    display.loadSpriteFrames("BabyWarsTextureGallery.plist", "BabyWarsTextureGallery.pvr.ccz")

    requireBW("src.app.utilities.AnimationLoader")       .load()
    requireBW("src.app.utilities.GameConstantFunctions") .init()
    requireBW("src.app.utilities.LocalizationFunctions") .init()
    requireBW("src.app.utilities.SerializationFunctions").init()
    requireBW("src.app.utilities.WarFieldManager")       .init()

    math.randomseed(os.time())

    --cc.Director:getInstance():setDisplayStats(true)

    local actorSceneMain = requireBW("src.global.actors.Actor").createWithModelAndViewName("sceneMain.ModelSceneMain", nil, "sceneMain.ViewSceneMain")
    requireBW("src.app.utilities.WebSocketManager").init()
    requireBW("src.global.actors.ActorManager").setAndRunRootActor(actorSceneMain)
    actorSceneMain:getModel():getModelMessageIndicator():showMessage(requireBW("src.app.utilities.LocalizationFunctions").getLocalizedText(30, "StartConnecting"))
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
