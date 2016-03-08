
local AnimationLoader = {}

local function toAnimationName(tiledID)
    return "tiledID" .. tiledID
end

local function loadTiledAnimation(tiledID, pattern, frameCount, frameDuration)
    local animation = display.newAnimation(display.newFrames(pattern, 1, frameCount), frameDuration)
    display.setAnimationCache(toAnimationName(tiledID), animation)

    return tiledID
end

function AnimationLoader.load()
    local tiledID = 0
    -- TiledID 0 + 1
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t01_s01_f%02d.png", 2, 0.5)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t01_s02_f%02d.png", 2, 0.5)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t01_s03_f%02d.png", 2, 0.5)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t01_s04_f%02d.png", 2, 0.5)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t02_s01_f%02d.png", 2, 0.5)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t02_s02_f%02d.png", 2, 0.5)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t02_s03_f%02d.png", 2, 0.5)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t02_s04_f%02d.png", 2, 0.5)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t02_s05_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t03_s01_f%02d.png", 4, 0.25)

    -- TiledID 10 + 1
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t03_s02_f%02d.png", 4, 0.25)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t03_s03_f%02d.png", 4, 0.25)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t03_s04_f%02d.png", 4, 0.25)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t03_s05_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t04_s01_f%02d.png", 2, 0.5)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t04_s02_f%02d.png", 2, 0.5)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t04_s03_f%02d.png", 2, 0.5)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t04_s04_f%02d.png", 2, 0.5)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t04_s05_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t05_s01_f%02d.png", 2, 0.5)

    -- TiledID 20 + 1
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t05_s02_f%02d.png", 2, 0.5)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t05_s03_f%02d.png", 2, 0.5)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t05_s04_f%02d.png", 2, 0.5)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t05_s05_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t06_s01_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t06_s02_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t06_s03_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t06_s04_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t07_s01_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t07_s02_f%02d.png", 1, 99999)

    -- TiledID 30 + 1
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t07_s03_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t07_s04_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t07_s05_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t07_s06_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t07_s07_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t07_s08_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t07_s09_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t07_s10_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t07_s11_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t08_s01_f%02d.png", 1, 99999)

    -- TiledID 40 + 1
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t09_s01_f%02d.png", 8, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t09_s02_f%02d.png", 8, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t09_s03_f%02d.png", 8, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t09_s04_f%02d.png", 8, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t09_s05_f%02d.png", 8, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t09_s06_f%02d.png", 8, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t09_s07_f%02d.png", 8, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t09_s08_f%02d.png", 8, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t09_s09_f%02d.png", 8, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t09_s10_f%02d.png", 8, 0.2)

    -- TiledID 50 + 1
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s01_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s02_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s03_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s04_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s05_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s06_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s07_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s08_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s09_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s10_f%02d.png", 6, 0.2)

    -- TiledID 60 + 1
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s11_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s12_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s13_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s14_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s15_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s16_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s17_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s18_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s19_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s20_f%02d.png", 6, 0.2)

    -- TiledID 70 + 1
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s21_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s22_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s23_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s24_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s25_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s26_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s27_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s28_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t10_s29_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t11_s01_f%02d.png", 6, 0.2)

    -- TiledID 80 + 1
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t12_s01_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t12_s02_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t12_s03_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t12_s04_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t12_s05_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t12_s06_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t12_s07_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t12_s08_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t12_s09_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t12_s10_f%02d.png", 6, 0.2)

    -- TiledID 90 + 1
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t12_s11_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t12_s12_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t12_s13_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t12_s14_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t12_s15_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t12_s16_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t12_s17_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t12_s18_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t12_s19_f%02d.png", 6, 0.2)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t12_s20_f%02d.png", 6, 0.2)

    -- TiledID 100 + 1
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t13_s01_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t13_s02_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t14_s01_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t14_s02_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t15_s01_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t15_s02_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t15_s03_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t15_s04_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t15_s05_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t15_s06_f%02d.png", 1, 99999)

    -- TiledID 110 + 1; Units start from "c02..."
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t15_s07_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t15_s08_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t15_s09_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t15_s10_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t16_s01_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c01_t16_s02_f%02d.png", 1, 99999)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t01_s01_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t01_s02_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t01_s03_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t01_s04_f%02d.png", 4, 0.3)

    -- TiledID 120 + 1
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t02_s01_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t02_s02_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t02_s03_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t02_s04_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t03_s01_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t03_s02_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t03_s03_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t03_s04_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t04_s01_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t04_s02_f%02d.png", 4, 0.3)

    -- TiledID 130 + 1
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t04_s03_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t04_s04_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t05_s01_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t05_s02_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t05_s03_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t05_s04_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t06_s01_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t06_s02_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t06_s03_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t06_s04_f%02d.png", 4, 0.3)

    -- TiledID 140 + 1
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t07_s01_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t07_s02_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t07_s03_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t07_s04_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t08_s01_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t08_s02_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t08_s03_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t08_s04_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t09_s01_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t09_s02_f%02d.png", 4, 0.3)

    -- TiledID 150 + 1
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t09_s03_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t09_s04_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t10_s01_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t10_s02_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t10_s03_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t10_s04_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t11_s01_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t11_s02_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t11_s03_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t11_s04_f%02d.png", 4, 0.3)

    -- TiledID 160 + 1
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t12_s01_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t12_s02_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t12_s03_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t12_s04_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t13_s01_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t13_s02_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t13_s03_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t13_s04_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t14_s01_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t14_s02_f%02d.png", 4, 0.3)

    -- TiledID 170 + 1
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t14_s03_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t14_s04_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t15_s01_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t15_s02_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t15_s03_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t15_s04_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t16_s01_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t16_s02_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t16_s03_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t16_s04_f%02d.png", 4, 0.3)

    -- TiledID 180 + 1
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t17_s01_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t17_s02_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t17_s03_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t17_s04_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t18_s01_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t18_s02_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t18_s03_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t18_s04_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t19_s01_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t19_s02_f%02d.png", 4, 0.3)

    -- TiledID 190 + 1
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t19_s03_f%02d.png", 4, 0.3)
    tiledID = loadTiledAnimation(tiledID + 1, "c02_t19_s04_f%02d.png", 4, 0.3)
end

function AnimationLoader.getAnimationWithTiledID(tiledID)
    return display.getAnimationCache(toAnimationName(tiledID))
end

return AnimationLoader
