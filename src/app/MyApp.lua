
--[[--------------------------------------------------------------------------------
-- MyApp是扩展引擎自带的mvc架构的程序入口。
-- 由于目前已弃用引擎自带的mvc架构，因此本文件也已废弃。
--]]--------------------------------------------------------------------------------

local MyApp = class("MyApp", cc.load("mvc").AppBase)

function MyApp:onCreate()
    display.loadSpriteFrames("BabyWarsTextureTile.plist", "BabyWarsTextureTile.png")
    display.loadSpriteFrames("BabyWarsTextureUnit.plist", "BabyWarsTextureUnit.png")
    display.loadSpriteFrames("BabyWarsTextureUI.plist",   "BabyWarsTextureUI.png")

    require("app.utilities.AnimationLoader").load()

    math.randomseed(os.time())
end

return MyApp
