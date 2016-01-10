
local MyApp = class("MyApp", cc.load("mvc").AppBase)

function MyApp:onCreate()
	display.loadSpriteFrames("fruit.plist", "fruit.png")
    math.randomseed(os.time())
end

return MyApp
