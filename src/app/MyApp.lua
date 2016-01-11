
local MyApp = class("MyApp", cc.load("mvc").AppBase)

function MyApp:onCreate()
	display.loadSpriteFrames("fruit.plist", "fruit.png")
	display.loadSpriteFrames("BabyWarsTexture.plist", "BabyWarsTexture.png")
    math.randomseed(os.time())
end

return MyApp
