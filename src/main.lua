
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
    
    math.randomseed(os.time())
        
    display.runScene(require("app.scenes.SceneMain"):create())
--]]
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
