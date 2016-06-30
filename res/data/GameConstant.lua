
local GameConstant = {}

GameConstant.version = "0.1.5.0"

GameConstant.gridSize = {
    width = 72, height = 72
}

GameConstant.indexesForTileOrUnit = {
    {name = "plain",       firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 1,  },
    {name = "river",       firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 16, },
    {name = "sea",         firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 47, },
    {name = "beach",       firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 12, },
    {name = "road",        firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 11, },
    {name = "bridge",      firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 11, },
    {name = "wood",        firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 1,  },
    {name = "mountain",    firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 1,  },
    {name = "wasteland",   firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 1,  },
    {name = "ruins",       firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 1,  },
    {name = "fire",        firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 1,  },
    {name = "rough",       firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 1,  },
    {name = "mist",        firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 1,  },
    {name = "reef",        firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 1,  },
    {name = "plasma",      firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 1,  },
    {name = "meteor",      firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 1,  },
    {name = "silo",        firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 2,  },
    {name = "hq",          firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "city",        firstPlayerIndex = 0, isSamePlayerIndex = false, shapesCount = 5,  },
    {name = "comtower",    firstPlayerIndex = 0, isSamePlayerIndex = false, shapesCount = 5,  },
    {name = "radar",       firstPlayerIndex = 0, isSamePlayerIndex = false, shapesCount = 5,  },
    {name = "factory",     firstPlayerIndex = 0, isSamePlayerIndex = false, shapesCount = 5,  },
    {name = "airport",     firstPlayerIndex = 0, isSamePlayerIndex = false, shapesCount = 5,  },
    {name = "seaport",     firstPlayerIndex = 0, isSamePlayerIndex = false, shapesCount = 5,  },
    {name = "tempairport", firstPlayerIndex = 0, isSamePlayerIndex = false, shapesCount = 5,  },
    {name = "tempseaport", firstPlayerIndex = 0, isSamePlayerIndex = false, shapesCount = 5,  },

    {name = "infantry",    firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "mech",        firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "bike",        firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "recon",       firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "flare",       firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "antiair",     firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "tank",        firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "mdtank",      firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "wartank",     firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "artillery",   firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "antitank",    firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "rockets",     firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "missiles",    firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "rig",         firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "fighter",     firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "bomber",      firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "duster",      firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "bcopter",     firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "tcopter",     firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "seaplane",    firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "battleship",  firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "carrier",     firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "submarine",   firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "cruiser",     firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "lander",      firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "gunboat",     firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
}

GameConstant.tileAnimations = {
    plain       = {typeIndex = 1,  shapesCount = 1,  framesCount = 1, durationPerFrame = 999999, fillsGrid = true,  },
    river       = {typeIndex = 2,  shapesCount = 16, framesCount = 1, durationPerFrame = 999999, fillsGrid = true,  },
    sea         = {typeIndex = 3,  shapesCount = 47, framesCount = 8, durationPerFrame = 0.2,    fillsGrid = true,  },
    beach       = {typeIndex = 4,  shapesCount = 12, framesCount = 8, durationPerFrame = 0.2,    fillsGrid = true,  },
    road        = {typeIndex = 5,  shapesCount = 11, framesCount = 1, durationPerFrame = 999999, fillsGrid = false, },
    bridge      = {typeIndex = 6,  shapesCount = 11, framesCount = 1, durationPerFrame = 999999, fillsGrid = false, },
    wood        = {typeIndex = 7,  shapesCount = 1,  framesCount = 1, durationPerFrame = 999999, fillsGrid = true,  },
    mountain    = {typeIndex = 8,  shapesCount = 1,  framesCount = 1, durationPerFrame = 999999, fillsGrid = true,  },
    wasteland   = {typeIndex = 9,  shapesCount = 1,  framesCount = 1, durationPerFrame = 999999, fillsGrid = true,  },
    ruins       = {typeIndex = 10, shapesCount = 1,  framesCount = 1, durationPerFrame = 999999, fillsGrid = true,  },
    fire        = {typeIndex = 11, shapesCount = 1,  framesCount = 5, durationPerFrame = 0.1,    fillsGrid = true,  },
    rough       = {typeIndex = 12, shapesCount = 1,  framesCount = 8, durationPerFrame = 0.2,    fillsGrid = true,  },
    mist        = {typeIndex = 13, shapesCount = 1,  framesCount = 8, durationPerFrame = 0.2,    fillsGrid = true,  },
    reef        = {typeIndex = 14, shapesCount = 1,  framesCount = 8, durationPerFrame = 0.2,    fillsGrid = true,  },
    plasma      = {typeIndex = 15, shapesCount = 1,  framesCount = 3, durationPerFrame = 0.1,    fillsGrid = false, },
    meteor      = {typeIndex = 16, shapesCount = 1,  framesCount = 1, durationPerFrame = 999999, fillsGrid = false, },
    silo        = {typeIndex = 17, shapesCount = 2,  framesCount = 1, durationPerFrame = 999999, fillsGrid = true,  },
    hq          = {typeIndex = 18, shapesCount = 4,  framesCount = 2, durationPerFrame = 0.5,    fillsGrid = true,  },
    city        = {typeIndex = 19, shapesCount = 5,  framesCount = 2, durationPerFrame = 0.5,    fillsGrid = true,  },
    comtower    = {typeIndex = 20, shapesCount = 5,  framesCount = 2, durationPerFrame = 0.5,    fillsGrid = true,  },
    radar       = {typeIndex = 21, shapesCount = 5,  framesCount = 2, durationPerFrame = 0.5,    fillsGrid = true,  },
    factory     = {typeIndex = 22, shapesCount = 5,  framesCount = 2, durationPerFrame = 0.5,    fillsGrid = true,  },
    airport     = {typeIndex = 23, shapesCount = 5,  framesCount = 2, durationPerFrame = 0.5,    fillsGrid = true,  },
    seaport     = {typeIndex = 24, shapesCount = 5,  framesCount = 2, durationPerFrame = 0.5,    fillsGrid = false, },
    tempairport = {typeIndex = 25, shapesCount = 5,  framesCount = 1, durationPerFrame = 999999, fillsGrid = true,  },
    tempseaport = {typeIndex = 26, shapesCount = 5,  framesCount = 1, durationPerFrame = 999999, fillsGrid = false, },
}

GameConstant.unitAnimations = {
    infantry = {
        {
            normal = {pattern = "c02_t01_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t01_s05_f%02d.png", framesCount = 4, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t01_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t01_s06_f%02d.png", framesCount = 4, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t01_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t01_s07_f%02d.png", framesCount = 4, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t01_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t01_s08_f%02d.png", framesCount = 4, durationPerFrame = 0.11},
        },
    },

    mech = {
        {
            normal = {pattern = "c02_t02_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t02_s05_f%02d.png", framesCount = 4, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t02_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t02_s06_f%02d.png", framesCount = 4, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t02_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t02_s07_f%02d.png", framesCount = 4, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t02_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t02_s08_f%02d.png", framesCount = 4, durationPerFrame = 0.11},
        },
    },

    bike = {
        {
            normal = {pattern = "c02_t03_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t03_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t03_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t03_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t03_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t03_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t03_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t03_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    recon = {
        {
            normal = {pattern = "c02_t04_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t04_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t04_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t04_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t04_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t04_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t04_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t04_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    flare = {
        {
            normal = {pattern = "c02_t05_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t05_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t05_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t05_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t05_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t05_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t05_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t05_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    antiair = {
        {
            normal = {pattern = "c02_t06_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t06_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t06_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t06_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t06_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t06_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t06_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t06_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    tank = {
        {
            normal = {pattern = "c02_t07_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t07_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t07_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t07_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t07_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t07_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t07_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t07_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    mdtank = {
        {
            normal = {pattern = "c02_t08_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t08_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t08_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t08_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t08_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t08_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t08_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t08_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    wartank = {
        {
            normal = {pattern = "c02_t09_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t09_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t09_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t09_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t09_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t09_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t09_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t09_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    artillery = {
        {
            normal = {pattern = "c02_t10_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t10_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t10_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t10_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t10_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t10_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t10_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t10_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    antitank = {
        {
            normal = {pattern = "c02_t11_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t11_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t11_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t11_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t11_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t11_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t11_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t11_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    rockets = {
        {
            normal = {pattern = "c02_t12_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t12_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t12_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t12_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t12_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t12_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t12_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t12_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    missiles = {
        {
            normal = {pattern = "c02_t13_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t13_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t13_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t13_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t13_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t13_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t13_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t13_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    rig = {
        {
            normal = {pattern = "c02_t14_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t14_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t14_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t14_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t14_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t14_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t14_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t14_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    fighter = {
        {
            normal = {pattern = "c02_t15_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t15_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t15_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t15_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t15_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t15_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t15_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t15_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    bomber = {
        {
            normal = {pattern = "c02_t16_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t16_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t16_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t16_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t16_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t16_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t16_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t16_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    duster = {
        {
            normal = {pattern = "c02_t17_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t17_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t17_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t17_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t17_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t17_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t17_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t17_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    bcopter = {
        {
            normal = {pattern = "c02_t18_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t18_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t18_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t18_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t18_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t18_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t18_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t18_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    tcopter = {
        {
            normal = {pattern = "c02_t19_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t19_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t19_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t19_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t19_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t19_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t19_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t19_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    seaplane = {
        {
            normal = {pattern = "c02_t20_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t20_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t20_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t20_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t20_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t20_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t20_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t20_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    battleship = {
        {
            normal = {pattern = "c02_t21_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t21_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t21_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t21_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t21_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t21_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t21_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t21_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    carrier = {
        {
            normal = {pattern = "c02_t22_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t22_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t22_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t22_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t22_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t22_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t22_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t22_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    submarine = {
        {
            normal = {pattern = "c02_t23_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t23_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t23_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t23_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t23_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t23_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t23_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t23_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    cruiser = {
        {
            normal = {pattern = "c02_t24_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t24_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t24_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t24_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t24_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t24_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t24_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t24_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    lander = {
        {
            normal = {pattern = "c02_t25_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t25_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t25_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t25_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t25_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t25_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t25_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t25_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    gunboat = {
        {
            normal = {pattern = "c02_t26_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t26_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t26_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t26_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t26_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t26_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t26_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t26_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },
}

GameConstant.unitCatagory = {
    allUnits = {
        "infantry",
        "mech",
        "bike",
        "recon",
        "flare",
        "antiair",
        "tank",
        "mdtank",
        "wartank",
        "artillery",
        "antitank",
        "rockets",
        "missiles",
        "rig",
        "fighter",
        "bomber",
        "duster",
        "bcopter",
        "tcopter",
        "seaplane",
        "battleship",
        "carrier",
        "submarine",
        "cruiser",
        "lander",
        "gunboat",
    },

    groundUnits = {
        "infantry",
        "mech",
        "bike",
        "recon",
        "flare",
        "antiair",
        "tank",
        "mdtank",
        "wartank",
        "artillery",
        "antitank",
        "rockets",
        "missiles",
        "rig",
    },

    navalUnits = {
        "battleship",
        "carrier",
        "submarine",
        "cruiser",
        "lander",
        "gunboat",
    },

    airUnits = {
        "fighter",
        "bomber",
        "duster",
        "bcopter",
        "tcopter",
        "seaplane",
    },

    groundOrNavalUnits = {
        "infantry",
        "mech",
        "bike",
        "recon",
        "flare",
        "antiair",
        "tank",
        "mdtank",
        "wartank",
        "artillery",
        "antitank",
        "rockets",
        "missiles",
        "rig",
        "battleship",
        "carrier",
        "submarine",
        "cruiser",
        "lander",
        "gunboat",
    },

    none = {
    },

    footUnits = {
        "infantry",
        "mech"
    },
}

GameConstant.maxCapturePoint = 20
GameConstant.unitMaxHP       = 100
GameConstant.tileMaxHP       = 99
GameConstant.incomePerTurn   = 1000

GameConstant.maxLevel   = 3
GameConstant.levelBonus = {
    {attack = 5,  defense = 5 },
    {attack = 10, defense = 10},
    {attack = 20, defense = 20},
}

GameConstant.moveTypes = {
    "infantry",
    "mech",
    "tireA",
    "tireB",
    "tank",
    "air",
    "ship",
    "transport",
}

GameConstant.templateModelTiles = {
    plain = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 10,
            targetCatagory = {
                [1] = "陆军",
                [2] = "Ground units",
            },
            targetList     = GameConstant.unitCatagory.groundUnits,
        },

        MoveCostOwner = {
            infantry  = 1,
            mech      = 1,
            tireA     = 2,
            tireB     = 1,
            tank      = 1,
            air       = 1,
            ship      = false,
            transport = false,
        },
    },

    river = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 0,
            targetCatagory = {
                [1] = "无",
                [2] = "None",
            },
            targetList     = GameConstant.unitCatagory.none,
        },

        MoveCostOwner = {
            infantry  = 2,
            mech      = 1,
            tireA     = false,
            tireB     = false,
            tank      = false,
            air       = 1,
            ship      = false,
            transport = false,
        },
    },

    sea = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 0,
            targetCatagory = {
                [1] = "无",
                [2] = "None",
            },
            targetList     = GameConstant.unitCatagory.none,
        },

        MoveCostOwner = {
            infantry  = false,
            mech      = false,
            tireA     = false,
            tireB     = false,
            tank      = false,
            air       = 1,
            ship      = 1,
            transport = 1,
        },
    },

    beach = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 0,
            targetCatagory = {
                [1] = "无",
                [2] = "None",
            },
            targetList     = GameConstant.unitCatagory.none,
        },

        MoveCostOwner = {
            infantry  = 1,
            mech      = 1,
            tireA     = 2,
            tireB     = 2,
            tank      = 1,
            air       = 1,
            ship      = false,
            transport = 1,
        },
    },

    road = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 0,
            targetCatagory = {
                [1] = "无",
                [2] = "None",
            },
            targetList     = GameConstant.unitCatagory.none,
        },

        MoveCostOwner = {
            infantry  = 1,
            mech      = 1,
            tireA     = 1,
            tireB     = 1,
            tank      = 1,
            air       = 1,
            ship      = false,
            transport = false,
        },
    },

    bridge = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 0,
            targetCatagory = {
                [1] = "无",
                [2] = "None",
            },
            targetList     = GameConstant.unitCatagory.none,
        },

        MoveCostOwner = {
            infantry  = 1,
            mech      = 1,
            tireA     = 1,
            tireB     = 1,
            tank      = 1,
            air       = 1,
            ship      = 1,
            transport = 1,
        },
    },

    bridgeOnRiver = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 0,
            targetCatagory = {
                [1] = "无",
                [2] = "None",
            },
            targetList     = GameConstant.unitCatagory.none,
        },

        MoveCostOwner = {
            infantry  = 1,
            mech      = 1,
            tireA     = 1,
            tireB     = 1,
            tank      = 1,
            air       = 1,
            ship      = false,
            transport = false,
        },
    },

    bridgeOnSea = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 0,
            targetCatagory = {
                [1] = "无",
                [2] = "None",
            },
            targetList     = GameConstant.unitCatagory.none,
        },

        MoveCostOwner = {
            infantry  = 1,
            mech      = 1,
            tireA     = 1,
            tireB     = 1,
            tank      = 1,
            air       = 1,
            ship      = 1,
            transport = 1,
        },
    },

    wood = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 30,
            targetCatagory = {
                [1] = "陆军",
                [2] = "Ground units",
            },
            targetList     = GameConstant.unitCatagory.groundUnits,
        },

        MoveCostOwner = {
            infantry  = 1,
            mech      = 1,
            tireA     = 3,
            tireB     = 3,
            tank      = 2,
            air       = 1,
            ship      = false,
            transport = false,
        },
    },

    mountain = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 40,
            targetCatagory = {
                [1] = "步兵/炮兵",
                [2] = "Foot Units",
            },
            targetList     = GameConstant.unitCatagory.footUnits,
        },

        MoveCostOwner = {
            infantry  = 2,
            mech      = 1,
            tireA     = false,
            tireB     = false,
            tank      = false,
            air       = 1,
            ship      = false,
            transport = false,
        },
    },

    wasteland = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 20,
            targetCatagory = {
                [1] = "陆军",
                [2] = "Ground units",
            },
            targetList     = GameConstant.unitCatagory.groundUnits,
        },

        MoveCostOwner = {
            infantry  = 1,
            mech      = 1,
            tireA     = 3,
            tireB     = 3,
            tank      = 2,
            air       = 1,
            ship      = false,
            transport = false,
        },
    },

    ruins = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 10,
            targetCatagory = {
                [1] = "陆军",
                [2] = "Ground units",
            },
            targetList     = GameConstant.unitCatagory.groundUnits,
        },

        MoveCostOwner = {
            infantry  = 1,
            mech      = 1,
            tireA     = 2,
            tireB     = 1,
            tank      = 1,
            air       = 1,
            ship      = false,
            transport = false,
        },
    },

    fire = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 0,
            targetCatagory = {
                [1] = "无",
                [2] = "None",
            },
            targetList     = GameConstant.unitCatagory.none,
        },

        MoveCostOwner = {
            infantry  = false,
            mech      = false,
            tireA     = false,
            tireB     = false,
            tank      = false,
            air       = false,
            ship      = false,
            transport = false,
        },
    },

    rough = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 20,
            targetCatagory = {
                [1] = "海军",
                [2] = "Naval Units",
            },
            targetList     = GameConstant.unitCatagory.navalUnits,
        },

        MoveCostOwner = {
            infantry  = false,
            mech      = false,
            tireA     = false,
            tireB     = false,
            tank      = false,
            air       = 1,
            ship      = 2,
            transport = 2,
        },
    },

    mist = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 10,
            targetCatagory = {
                [1] = "海军",
                [2] = "Naval Units",
            },
            targetList     = GameConstant.unitCatagory.navalUnits,
        },

        MoveCostOwner = {
            infantry  = false,
            mech      = false,
            tireA     = false,
            tireB     = false,
            tank      = false,
            air       = 1,
            ship      = 1,
            transport = 1,
        },
    },

    reef = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 20,
            targetCatagory = {
                [1] = "海军",
                [2] = "Naval Units",
            },
            targetList     = GameConstant.unitCatagory.navalUnits,
        },

        MoveCostOwner = {
            infantry  = false,
            mech      = false,
            tireA     = false,
            tireB     = false,
            tank      = false,
            air       = 1,
            ship      = 2,
            transport = 2,
        },
    },

    plasma = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 0,
            targetCatagory = {
                [1] = "无",
                [2] = "None",
            },
            targetList     = GameConstant.unitCatagory.none,
        },

        MoveCostOwner = {
            infantry  = false,
            mech      = false,
            tireA     = false,
            tireB     = false,
            tank      = false,
            air       = false,
            ship      = false,
            transport = false,
        },
    },

    meteor = {
        GridIndexable = {},

        AttackTaker = {
            maxHP            = GameConstant.tileMaxHP,
            currentHP        = GameConstant.tileMaxHP,
            defenseType      = "meteor",
            isAffectedByLuck = false,
        },

        DefenseBonusProvider = {
            amount         = 0,
            targetCatagory = {
                [1] = "无",
                [2] = "None",
            },
            targetList     = GameConstant.unitCatagory.none,
        },

        MoveCostOwner = {
            infantry  = false,
            mech      = false,
            tireA     = false,
            tireB     = false,
            tank      = false,
            air       = false,
            ship      = false,
            transport = false,
        },
    },

    silo = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 20,
            targetCatagory = {
                [1] = "陆军",
                [2] = "Ground units",
            },
            targetList     = GameConstant.unitCatagory.groundUnits,
        },

        MoveCostOwner = {
            infantry  = 1,
            mech      = 1,
            tireA     = 1,
            tireB     = 1,
            tank      = 1,
            air       = 1,
            ship      = false,
            transport = false,
        },
    },

    hq = {
        GridIndexable = {},

        CaptureTaker = {
            maxCapturePoint     = GameConstant.maxCapturePoint,
            currentCapturePoint = GameConstant.maxCapturePoint,
            defeatOnCapture     = true,
        },

        RepairDoer = {
            targetCatagory = {
                [1] = "陆军",
                [2] = "Ground units",
            },
            targetList     = GameConstant.unitCatagory.groundUnits,
            amount         = 2,
        },

        IncomeProvider = {
            amount = 1000,
        },

        DefenseBonusProvider = {
            amount         = 40,
            targetCatagory = {
                [1] = "陆军",
                [2] = "Ground units",
            },
            targetList     = GameConstant.unitCatagory.groundUnits,
        },

        MoveCostOwner = {
            infantry  = 1,
            mech      = 1,
            tireA     = 1,
            tireB     = 1,
            tank      = 1,
            air       = 1,
            ship      = false,
            transport = false,
        },
    },

    city = {
        GridIndexable = {},

        CaptureTaker = {
            maxCapturePoint     = GameConstant.maxCapturePoint,
            currentCapturePoint = GameConstant.maxCapturePoint,
            defeatOnCapture     = false,
        },

        RepairDoer = {
            targetCatagory = {
                [1] = "陆军",
                [2] = "Ground units",
            },
            targetList     = GameConstant.unitCatagory.groundUnits,
            amount         = 2,
        },

        IncomeProvider = {
            amount = 1000,
        },

        DefenseBonusProvider = {
            amount         = 20,
            targetCatagory = {
                [1] = "陆军",
                [2] = "Ground units",
            },
            targetList     = GameConstant.unitCatagory.groundUnits,
        },

        MoveCostOwner = {
            infantry  = 1,
            mech      = 1,
            tireA     = 1,
            tireB     = 1,
            tank      = 1,
            air       = 1,
            ship      = false,
            transport = false,
        },
    },

    comtower = {
        GridIndexable = {},

        CaptureTaker = {
            maxCapturePoint     = GameConstant.maxCapturePoint,
            currentCapturePoint = GameConstant.maxCapturePoint,
            defeatOnCapture     = false,
        },

        IncomeProvider = {
            amount = 1000,
        },

        DefenseBonusProvider = {
            amount         = 30,
            targetCatagory = {
                [1] = "陆军",
                [2] = "Ground units",
            },
            targetList     = GameConstant.unitCatagory.groundUnits,
        },

        MoveCostOwner = {
            infantry  = 1,
            mech      = 1,
            tireA     = 1,
            tireB     = 1,
            tank      = 1,
            air       = 1,
            ship      = false,
            transport = false,
        },
    },

    radar = {
        GridIndexable = {},

        CaptureTaker = {
            maxCapturePoint     = GameConstant.maxCapturePoint,
            currentCapturePoint = GameConstant.maxCapturePoint,
            defeatOnCapture     = false,
        },

        IncomeProvider = {
            amount = 1000,
        },

        DefenseBonusProvider = {
            amount         = 30,
            targetCatagory = {
                [1] = "陆军",
                [2] = "Ground units",
            },
            targetList     = GameConstant.unitCatagory.groundUnits,
        },

        MoveCostOwner = {
            infantry  = 1,
            mech      = 1,
            tireA     = 1,
            tireB     = 1,
            tank      = 1,
            air       = 1,
            ship      = false,
            transport = false,
        },
    },

    factory = {
        GridIndexable = {},

        CaptureTaker = {
            maxCapturePoint     = GameConstant.maxCapturePoint,
            currentCapturePoint = GameConstant.maxCapturePoint,
            defeatOnCapture     = false,
        },

        RepairDoer = {
            targetCatagory = {
                [1] = "陆军",
                [2] = "Ground units",
            },
            targetList     = GameConstant.unitCatagory.groundUnits,
            amount         = 2,
        },

        IncomeProvider = {
            amount = 1000,
        },

        DefenseBonusProvider = {
            amount         = 30,
            targetCatagory = {
                [1] = "陆军",
                [2] = "Ground units",
            },
            targetList     = GameConstant.unitCatagory.groundUnits,
        },

        MoveCostOwner = {
            infantry  = 1,
            mech      = 1,
            tireA     = 1,
            tireB     = 1,
            tank      = 1,
            air       = 1,
            ship      = false,
            transport = false,
        },

        UnitProducer = {
            productionList = {
                "infantry",
                "mech",
                "bike",
                "recon",
                "flare",
                "antiair",
                "tank",
                "mdtank",
                "wartank",
                "artillery",
                "antitank",
                "rockets",
                "missiles",
                "rig",
            },
        },
    },

    airport = {
        GridIndexable = {},

        CaptureTaker = {
            maxCapturePoint     = GameConstant.maxCapturePoint,
            currentCapturePoint = GameConstant.maxCapturePoint,
            defeatOnCapture     = false,
        },

        RepairDoer = {
            targetCatagory = {
                [1] = "空军",
                [2] = "Air units",
            },
            targetList     = GameConstant.unitCatagory.airUnits,
            amount         = 2,
        },

        IncomeProvider = {
            amount = 1000,
        },

        DefenseBonusProvider = {
            amount         = 30,
            targetCatagory = {
                [1] = "陆军",
                [2] = "Ground units",
            },
            targetList     = GameConstant.unitCatagory.groundUnits,
        },

        MoveCostOwner = {
            infantry  = 1,
            mech      = 1,
            tireA     = 1,
            tireB     = 1,
            tank      = 1,
            air       = 1,
            ship      = false,
            transport = false,
        },

        UnitProducer = {
            productionList = {
                "fighter",
                "bomber",
                "duster",
                "bcopter",
                "tcopter",
            },
        },
    },

    seaport = {
        GridIndexable = {},

        CaptureTaker = {
            maxCapturePoint     = GameConstant.maxCapturePoint,
            currentCapturePoint = GameConstant.maxCapturePoint,
            defeatOnCapture     = false,
        },

        RepairDoer = {
            targetCatagory = {
                [1] = "海军",
                [2] = "Naval units",
            },
            targetList     = GameConstant.unitCatagory.navalUnits,
            amount         = 2,
        },

        IncomeProvider = {
            amount = 1000,
        },

        DefenseBonusProvider = {
            amount         = 30,
            targetCatagory = {
                [1] = "陆军/海军",
                [2] = "Ground/Naval Units",
            },
            targetList     = GameConstant.unitCatagory.groundOrNavalUnits,
        },

        MoveCostOwner = {
            infantry  = 1,
            mech      = 1,
            tireA     = 1,
            tireB     = 1,
            tank      = 1,
            air       = 1,
            ship      = 1,
            transport = 1,
        },

        UnitProducer = {
            productionList = {
                "battleship",
                "carrier",
                "submarine",
                "cruiser",
                "lander",
                "gunboat",
            },
        },
    },

    tempairport = {
        GridIndexable = {},

        CaptureTaker = {
            maxCapturePoint     = GameConstant.maxCapturePoint,
            currentCapturePoint = GameConstant.maxCapturePoint,
            defeatOnCapture     = false,
        },

        RepairDoer = {
            targetCatagory = {
                [1] = "空军",
                [2] = "Air units",
            },
            targetList     = GameConstant.unitCatagory.airUnits,
            amount         = 2,
        },

        DefenseBonusProvider = {
            amount         = 10,
            targetCatagory = {
                [1] = "陆军",
                [2] = "Ground units",
            },
            targetList     = GameConstant.unitCatagory.groundUnits,
        },

        MoveCostOwner = {
            infantry  = 1,
            mech      = 1,
            tireA     = 1,
            tireB     = 1,
            tank      = 1,
            air       = 1,
            ship      = false,
            transport = false,
        },
    },

    tempseaport = {
        GridIndexable = {},

        CaptureTaker = {
            maxCapturePoint     = GameConstant.maxCapturePoint,
            currentCapturePoint = GameConstant.maxCapturePoint,
            defeatOnCapture     = false,
        },

        RepairDoer = {
            targetCatagory = {
                [1] = "海军",
                [2] = "Naval units",
            },
            targetList     = GameConstant.unitCatagory.navalUnits,
            amount         = 2,
        },

        DefenseBonusProvider = {
            amount         = 10,
            targetCatagory = {
                [1] = "陆军/海军",
                [2] = "Ground/Naval Units",
            },
            targetList     = GameConstant.unitCatagory.groundOrNavalUnits,
        },

        MoveCostOwner = {
            infantry  = 1,
            mech      = 1,
            tireA     = 1,
            tireB     = 1,
            tank      = 1,
            air       = 1,
            ship      = 1,
            transport = 1,
        },
    },
}

GameConstant.templateModelUnits = {
    infantry   = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon   = nil,
            secondaryWeapon = {
                type        = "MachineGun",
                baseDamage  = {
                    infantry   = 55,
                    mech       = 45,
                    bike       = 45,
                    recon      = 12,
                    flare      = 10,
                    antiair    = 3,
                    tank       = 5,
                    mdtank     = 5,
                    wartank    = 1,
                    artillery  = 10,
                    antitank   = 30,
                    rockets    = 20,
                    missiles   = 20,
                    rig        = 14,
                    fighter    = nil,
                    bomber     = nil,
                    duster     = nil,
                    bcopter    = 8,
                    tcopter    = 30,
                    seaplane   = nil,
                    battleship = nil,
                    carrier    = nil,
                    submarine  = nil,
                    cruiser    = nil,
                    lander     = nil,
                    gunboat    = nil,
                    meteor     = 1,
                },
            },
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "infantry",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 3,
            type     = "infantry",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        LevelOwner = {
            level = 0,
        },

        CaptureDoer = {
            isCapturing = false,
        },

        cost        = 1500,
        vision      = 2,
    },

    mech       = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "Barzooka",
                baseDamage  = {
                    infantry   = nil,
                    mech       = nil,
                    bike       = nil,
                    recon      = 85,
                    flare      = 80,
                    antiair    = 55,
                    tank       = 55,
                    mdtank     = 25,
                    wartank    = 15,
                    artillery  = 70,
                    antitank   = 55,
                    rockets    = 85,
                    missiles   = 85,
                    rig        = 75,
                    fighter    = nil,
                    bomber     = nil,
                    duster     = nil,
                    bcopter    = nil,
                    tcopter    = nil,
                    seaplane   = nil,
                    battleship = nil,
                    carrier    = nil,
                    submarine  = nil,
                    cruiser    = nil,
                    lander     = nil,
                    gunboat    = nil,
                    meteor     = 15,
                },
                maxAmmo     = 3,
                currentAmmo = 3,
            },
            secondaryWeapon = {
                type        = "MachineGun",
                baseDamage  = {
                    infantry   = 65,
                    mech       = 55,
                    bike       = 55,
                    recon      = 18,
                    flare      = 15,
                    antiair    = 5,
                    tank       = 8,
                    mdtank     = 5,
                    wartank    = 1,
                    artillery  = 15,
                    antitank   = 35,
                    rockets    = 35,
                    missiles   = 35,
                    rig        = 20,
                    fighter    = nil,
                    bomber     = nil,
                    duster     = nil,
                    bcopter    = 12,
                    tcopter    = 35,
                    seaplane   = nil,
                    battleship = nil,
                    carrier    = nil,
                    submarine  = nil,
                    cruiser    = nil,
                    lander     = nil,
                    gunboat    = nil,
                    meteor     = 1,
                },
            },
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "mech",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 2,
            type     = "mech",
        },

        FuelOwner = {
            max                    = 70,
            current                = 70,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        LevelOwner = {
            level = 0,
        },

        CaptureDoer = {
            isCapturing = false,
        },

        cost        = 2500,
        vision      = 2,
    },

    bike       = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon   = nil,
            secondaryWeapon = {
                type        = "MachineGun",
                baseDamage  = {
                    infantry   = 65,
                    mech       = 55,
                    bike       = 55,
                    recon      = 18,
                    flare      = 15,
                    antiair    = 5,
                    tank       = 8,
                    mdtank     = 5,
                    wartank    = 1,
                    artillery  = 15,
                    antitank   = 35,
                    rockets    = 35,
                    missiles   = 35,
                    rig        = 20,
                    fighter    = nil,
                    bomber     = nil,
                    duster     = nil,
                    bcopter    = 12,
                    tcopter    = 35,
                    seaplane   = nil,
                    battleship = nil,
                    carrier    = nil,
                    submarine  = nil,
                    cruiser    = nil,
                    lander     = nil,
                    gunboat    = nil,
                    meteor     = 1,
                },
            },
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "bike",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 5,
            type     = "tireB",
        },

        FuelOwner = {
            max                    = 70,
            current                = 70,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        LevelOwner = {
            level = 0,
        },

        CaptureDoer = {
            isCapturing = false,
        },

        cost        = 2500,
        vision      = 2,
    },

    recon      = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon   = nil,
            secondaryWeapon = {
                type        = "MachineGun",
                baseDamage  = {
                    infantry   = 75,
                    mech       = 65,
                    bike       = 65,
                    recon      = 35,
                    flare      = 30,
                    antiair    = 8,
                    tank       = 8,
                    mdtank     = 5,
                    wartank    = 1,
                    artillery  = 45,
                    antitank   = 25,
                    rockets    = 55,
                    missiles   = 55,
                    rig        = 45,
                    fighter    = nil,
                    bomber     = nil,
                    duster     = nil,
                    bcopter    = 18,
                    tcopter    = 35,
                    seaplane   = nil,
                    battleship = nil,
                    carrier    = nil,
                    submarine  = nil,
                    cruiser    = nil,
                    lander     = nil,
                    gunboat    = nil,
                    meteor     = 1,
                },
            },
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "recon",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 8,
            type     = "tireA",
        },

        FuelOwner = {
            max                    = 80,
            current                = 80,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        LevelOwner = {
            level = 0,
        },

        cost        = 4000,
        vision      = 5,
    },

    flare      = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon   = nil,
            secondaryWeapon = {
                type        = "MachineGun",
                baseDamage  = {
                    infantry   = 80,
                    mech       = 70,
                    bike       = 70,
                    recon      = 60,
                    flare      = 50,
                    antiair    = 45,
                    tank       = 10,
                    mdtank     = 5,
                    wartank    = 1,
                    artillery  = 45,
                    antitank   = 25,
                    rockets    = 55,
                    missiles   = 55,
                    rig        = 45,
                    fighter    = nil,
                    bomber     = nil,
                    duster     = nil,
                    bcopter    = 18,
                    tcopter    = 35,
                    seaplane   = nil,
                    battleship = nil,
                    carrier    = nil,
                    submarine  = nil,
                    cruiser    = nil,
                    lander     = nil,
                    gunboat    = nil,
                    meteor     = 5,
                },
            },
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "flare",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 5,
            type     = "tank",
        },

        FuelOwner = {
            max                    = 60,
            current                = 60,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        LevelOwner = {
            level = 0,
        },

        cost        = 5000,
        vision      = 2,
    },

    antiair    = {
        GridIndexable = {},

        AttackDoer = {
            name               = "AttackDoer",
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "Cannon",
                baseDamage  = {
                    infantry   = 105,
                    mech       = 105,
                    bike       = 105,
                    recon      = 60,
                    flare      = 50,
                    antiair    = 45,
                    tank       = 15,
                    mdtank     = 10,
                    wartank    = 5,
                    artillery  = 50,
                    antitank   = 25,
                    rockets    = 55,
                    missiles   = 55,
                    rig        = 50,
                    fighter    = 70,
                    bomber     = 70,
                    duster     = 75,
                    bcopter    = 105,
                    tcopter    = 120,
                    seaplane   = 75,
                    battleship = nil,
                    carrier    = nil,
                    submarine  = nil,
                    cruiser    = nil,
                    lander     = nil,
                    gunboat    = nil,
                    meteor     = 10,
                },
                maxAmmo     = 6,
                currentAmmo = 6,
            },
            secondaryWeapon = nil,
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "antiair",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 6,
            type     = "tank",
        },

        FuelOwner = {
            max                    = 60,
            current                = 60,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        LevelOwner = {
            level = 0,
        },

        cost        = 7000,
        vision      = 3,
    },

    tank       = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "TankGun",
                baseDamage  = {
                    infantry   = nil,
                    mech       = nil,
                    bike       = nil,
                    recon      = 85,
                    flare      = 80,
                    antiair    = 75,
                    tank       = 55,
                    mdtank     = 35,
                    wartank    = 20,
                    artillery  = 70,
                    antitank   = 30,
                    rockets    = 85,
                    missiles   = 85,
                    rig        = 75,
                    fighter    = nil,
                    bomber     = nil,
                    duster     = nil,
                    bcopter    = nil,
                    tcopter    = nil,
                    seaplane   = nil,
                    battleship = 8,
                    carrier    = 8,
                    submarine  = 9,
                    cruiser    = 9,
                    lander     = 18,
                    gunboat    = 55,
                    meteor     = 20,
                },
                maxAmmo     = 6,
                currentAmmo = 6,
            },
            secondaryWeapon = {
                type        = "MachineGun",
                baseDamage  = {
                    infantry   = 75,
                    mech       = 70,
                    bike       = 70,
                    recon      = 40,
                    flare      = 35,
                    antiair    = 8,
                    tank       = 8,
                    mdtank     = 5,
                    wartank    = 1,
                    artillery  = 45,
                    antitank   = 1,
                    rockets    = 55,
                    missiles   = 55,
                    rig        = 45,
                    fighter    = nil,
                    bomber     = nil,
                    duster     = nil,
                    bcopter    = 18,
                    tcopter    = 35,
                    seaplane   = nil,
                    battleship = nil,
                    carrier    = nil,
                    submarine  = nil,
                    cruiser    = nil,
                    lander     = nil,
                    gunboat    = nil,
                    meteor     = 1,
                },
            },
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "tank",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 6,
            type     = "tank",
        },

        FuelOwner = {
            max                    = 70,
            current                = 70,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        LevelOwner = {
            level = 0,
        },

        cost        = 7000,
        vision      = 3,
    },

    mdtank     = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "HeavyTankGun",
                baseDamage  = {
                    infantry   = nil,
                    mech       = nil,
                    bike       = nil,
                    recon      = 95,
                    flare      = 90,
                    antiair    = 90,
                    tank       = 70,
                    mdtank     = 55,
                    wartank    = 35,
                    artillery  = 85,
                    antitank   = 35,
                    rockets    = 90,
                    missiles   = 90,
                    rig        = 90,
                    fighter    = nil,
                    bomber     = nil,
                    duster     = nil,
                    bcopter    = nil,
                    tcopter    = nil,
                    seaplane   = nil,
                    battleship = 10,
                    carrier    = 10,
                    submarine  = 12,
                    cruiser    = 12,
                    lander     = 22,
                    gunboat    = 55,
                    meteor     = 35,
                },
                maxAmmo     = 5,
                currentAmmo = 5,
            },
            secondaryWeapon = {
                type        = "MachineGun",
                baseDamage  = {
                    infantry   = 90,
                    mech       = 80,
                    bike       = 80,
                    recon      = 40,
                    flare      = 35,
                    antiair    = 8,
                    tank       = 8,
                    mdtank     = 5,
                    wartank    = 1,
                    artillery  = 45,
                    antitank   = 1,
                    rockets    = 60,
                    missiles   = 60,
                    rig        = 45,
                    fighter    = nil,
                    bomber     = nil,
                    duster     = nil,
                    bcopter    = 24,
                    tcopter    = 40,
                    seaplane   = nil,
                    battleship = nil,
                    carrier    = nil,
                    submarine  = nil,
                    cruiser    = nil,
                    lander     = nil,
                    gunboat    = nil,
                    meteor     = 1,
                },
            },
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "mdtank",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 5,
            type     = "tank",
        },

        FuelOwner = {
            max                    = 50,
            current                = 50,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        LevelOwner = {
            level = 0,
        },

        cost        = 12000,
        vision      = 2,
    },

    wartank    = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "MegaGun",
                baseDamage  = {
                    infantry   = nil,
                    mech       = nil,
                    bike       = nil,
                    recon      = 105,
                    flare      = 105,
                    antiair    = 105,
                    tank       = 85,
                    mdtank     = 75,
                    wartank    = 55,
                    artillery  = 105,
                    antitank   = 40,
                    rockets    = 105,
                    missiles   = 105,
                    rig        = 105,
                    fighter    = nil,
                    bomber     = nil,
                    duster     = nil,
                    bcopter    = nil,
                    tcopter    = nil,
                    seaplane   = nil,
                    battleship = 12,
                    carrier    = 12,
                    submarine  = 14,
                    cruiser    = 14,
                    lander     = 28,
                    gunboat    = 65,
                    meteor     = 55,
                },
                maxAmmo     = 5,
                currentAmmo = 5,
            },
            secondaryWeapon = {
                type        = "MachineGun",
                baseDamage  = {
                    infantry   = 105,
                    mech       = 95,
                    bike       = 95,
                    recon      = 45,
                    flare      = 40,
                    antiair    = 10,
                    tank       = 10,
                    mdtank     = 10,
                    wartank    = 1,
                    artillery  = 45,
                    antitank   = 1,
                    rockets    = 65,
                    missiles   = 65,
                    rig        = 45,
                    fighter    = nil,
                    bomber     = nil,
                    duster     = nil,
                    bcopter    = 35,
                    tcopter    = 45,
                    seaplane   = nil,
                    battleship = nil,
                    carrier    = nil,
                    submarine  = nil,
                    cruiser    = nil,
                    lander     = nil,
                    gunboat    = nil,
                    meteor     = 1,
                },
            },
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "wartank",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 4,
            type     = "tank",
        },

        FuelOwner = {
            max                    = 50,
            current                = 50,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        LevelOwner = {
            level = 0,
        },

        cost        = 16000,
        vision      = 2,
    },

    artillery  = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 2,
            maxAttackRange     = 3,
            canAttackAfterMove = false,

            primaryWeapon = {
                type       = "Cannon",
                baseDamage = {
                    infantry   = 90,
                    mech       = 85,
                    bike       = 85,
                    recon      = 80,
                    flare      = 75,
                    antiair    = 65,
                    tank       = 60,
                    mdtank     = 45,
                    wartank    = 35,
                    artillery  = 75,
                    antitank   = 55,
                    rockets    = 80,
                    missiles   = 80,
                    rig        = 70,
                    fighter    = nil,
                    bomber     = nil,
                    duster     = nil,
                    bcopter    = nil,
                    tcopter    = nil,
                    seaplane   = nil,
                    battleship = 45,
                    carrier    = 45,
                    submarine  = 55,
                    cruiser    = 55,
                    lander     = 65,
                    gunboat    = 100,
                    meteor     = 45,
                },
                maxAmmo     = 6,
                currentAmmo = 6,
            },
            secondaryWeapon = nil,
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "artillery",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 5,
            type     = "tank",
        },

        FuelOwner = {
            max                    = 50,
            current                = 50,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        LevelOwner = {
            level = 0,
        },

        cost        = 6000,
        vision      = 3,
    },

    antitank   = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 3,
            canAttackAfterMove = false,

            primaryWeapon = {
                type       = "Cannon",
                baseDamage = {
                    infantry   = 75,
                    mech       = 65,
                    bike       = 65,
                    recon      = 75,
                    flare      = 75,
                    antiair    = 75,
                    tank       = 75,
                    mdtank     = 65,
                    wartank    = 55,
                    artillery  = 65,
                    antitank   = 55,
                    rockets    = 70,
                    missiles   = 70,
                    rig        = 65,
                    fighter    = nil,
                    bomber     = nil,
                    duster     = nil,
                    bcopter    = 45,
                    tcopter    = 55,
                    seaplane   = nil,
                    battleship = nil,
                    carrier    = nil,
                    submarine  = nil,
                    cruiser    = nil,
                    lander     = nil,
                    gunboat    = nil,
                    meteor     = 55,
                },
                maxAmmo     = 6,
                currentAmmo = 6,
            },
            secondaryWeapon = nil,
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "antitank",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 4,
            type     = "tireB",
        },

        FuelOwner = {
            max                    = 50,
            current                = 50,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        LevelOwner = {
            level = 0,
        },

        cost        = 11000,
        vision      = 3,
    },

    rockets    = {
        GridIndexable = {},

        AttackDoer = {
            name               = "AttackDoer",
            minAttackRange     = 3,
            maxAttackRange     = 5,
            canAttackAfterMove = false,

            primaryWeapon = {
                type        = "Rockets",
                baseDamage  = {
                    infantry   = 95,
                    mech       = 90,
                    bike       = 90,
                    recon      = 90,
                    flare      = 85,
                    antiair    = 75,
                    tank       = 70,
                    mdtank     = 55,
                    wartank    = 45,
                    artillery  = 80,
                    antitank   = 65,
                    rockets    = 85,
                    missiles   = 85,
                    rig        = 80,
                    fighter    = nil,
                    bomber     = nil,
                    duster     = nil,
                    bcopter    = nil,
                    tcopter    = nil,
                    seaplane   = nil,
                    battleship = 55,
                    carrier    = 55,
                    submarine  = 65,
                    cruiser    = 65,
                    lander     = 75,
                    gunboat    = 105,
                    meteor     = 55,
                },
                maxAmmo     = 5,
                currentAmmo = 5,
            },
            secondaryWeapon = nil,
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "rockets",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 5,
            type     = "tireA",
        },

        FuelOwner = {
            max                    = 50,
            current                = 50,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        LevelOwner = {
            level = 0,
        },

        cost        = 15000,
        vision      = 3,
    },

    missiles   = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 3,
            maxAttackRange     = 6,
            canAttackAfterMove = false,

            primaryWeapon = {
                type        = "AAMissiles",
                baseDamage  = {
                    infantry   = nil,
                    mech       = nil,
                    bike       = nil,
                    recon      = nil,
                    flare      = nil,
                    antiair    = nil,
                    tank       = nil,
                    mdtank     = nil,
                    wartank    = nil,
                    artillery  = nil,
                    antitank   = nil,
                    rockets    = nil,
                    missiles   = nil,
                    rig        = nil,
                    fighter    = 100,
                    bomber     = 100,
                    duster     = 100,
                    bcopter    = 120,
                    tcopter    = 120,
                    seaplane   = 100,
                    battleship = nil,
                    carrier    = nil,
                    submarine  = nil,
                    cruiser    = nil,
                    lander     = nil,
                    gunboat    = nil,
                    meteor     = nil,
                },
                maxAmmo     = 5,
                currentAmmo = 5,
            },
            secondaryWeapon = nil,
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "missiles",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 5,
            type     = "tireA",
        },

        FuelOwner = {
            max                    = 50,
            current                = 50,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        LevelOwner = {
            level = 0,
        },

        cost        = 12000,
        vision      = 5,
    },

    rig        = {
        GridIndexable = {},

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "rig",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 6,
            type     = "tank",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        cost        = 5000,
        vision      = 1,
    },

    fighter    = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "AAMissiles",
                baseDamage  = {
                    infantry   = nil,
                    mech       = nil,
                    bike       = nil,
                    recon      = nil,
                    flare      = nil,
                    antiair    = nil,
                    tank       = nil,
                    mdtank     = nil,
                    wartank    = nil,
                    artillery  = nil,
                    antitank   = nil,
                    rockets    = nil,
                    missiles   = nil,
                    rig        = nil,
                    fighter    = 55,
                    bomber     = 65,
                    duster     = 80,
                    bcopter    = 120,
                    tcopter    = 120,
                    seaplane   = 65,
                    battleship = nil,
                    carrier    = nil,
                    submarine  = nil,
                    cruiser    = nil,
                    lander     = nil,
                    gunboat    = nil,
                    meteor     = nil,
                },
                maxAmmo     = 6,
                currentAmmo = 6,
            },
            secondaryWeapon = nil,
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "fighter",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 9,
            type     = "air",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 5,
            destroyOnOutOfFuel     = true,
        },

        LevelOwner = {
            level = 0,
        },

        cost        = 20000,
        vision      = 5,
    },

    bomber     = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "Bombs",
                baseDamage  = {
                    infantry   = 115,
                    mech       = 110,
                    bike       = 110,
                    recon      = 105,
                    flare      = 105,
                    antiair    = 85,
                    tank       = 105,
                    mdtank     = 95,
                    wartank    = 75,
                    artillery  = 105,
                    antitank   = 80,
                    rockets    = 105,
                    missiles   = 95,
                    rig        = 105,
                    fighter    = nil,
                    bomber     = nil,
                    duster     = nil,
                    bcopter    = nil,
                    tcopter    = nil,
                    seaplane   = nil,
                    battleship = 85,
                    carrier    = 85,
                    submarine  = 95,
                    cruiser    = 50,
                    lander     = 95,
                    gunboat    = 120,
                    meteor     = 90,
                },
                maxAmmo     = 6,
                currentAmmo = 6,
            },
            secondaryWeapon = nil,
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "bomber",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 7,
            type     = "air",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 5,
            destroyOnOutOfFuel     = true,
        },

        LevelOwner = {
            level = 0,
        },

        cost        = 20000,
        vision      = 3,
    },

    duster     = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "MachineGun",
                baseDamage  = {
                    infantry   = 55,
                    mech       = 45,
                    bike       = 45,
                    recon      = 18,
                    flare      = 15,
                    antiair    = 5,
                    tank       = 8,
                    mdtank     = 5,
                    wartank    = 1,
                    artillery  = 15,
                    antitank   = 5,
                    rockets    = 20,
                    missiles   = 20,
                    rig        = 15,
                    fighter    = 40,
                    bomber     = 45,
                    duster     = 55,
                    bcopter    = 75,
                    tcopter    = 90,
                    seaplane   = 45,
                    battleship = nil,
                    carrier    = nil,
                    submarine  = nil,
                    cruiser    = nil,
                    lander     = nil,
                    gunboat    = nil,
                    meteor     = 1,
                },
                maxAmmo     = 9,
                currentAmmo = 9,
            },
            secondaryWeapon = nil,
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "duster",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 8,
            type     = "air",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 5,
            destroyOnOutOfFuel     = true,
        },

        LevelOwner = {
            level = 0,
        },

        cost        = 13000,
        vision      = 4,
    },

    bcopter    = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "Missiles",
                baseDamage  = {
                    infantry   = nil,
                    mech       = nil,
                    bike       = nil,
                    recon      = 75,
                    flare      = 75,
                    antiair    = 10,
                    tank       = 70,
                    mdtank     = 45,
                    wartank    = 35,
                    artillery  = 65,
                    antitank   = 20,
                    rockets    = 75,
                    missiles   = 55,
                    rig        = 70,
                    fighter    = nil,
                    bomber     = nil,
                    duster     = nil,
                    bcopter    = nil,
                    tcopter    = nil,
                    seaplane   = nil,
                    battleship = 25,
                    carrier    = 25,
                    submarine  = 25,
                    cruiser    = 5,
                    lander     = 25,
                    gunboat    = 85,
                    meteor     = 20,
                },
                maxAmmo     = 6,
                currentAmmo = 6,
            },
            secondaryWeapon = {
                type        = "MachineGun",
                baseDamage  = {
                    infantry   = 75,
                    mech       = 65,
                    bike       = 65,
                    recon      = 30,
                    flare      = 30,
                    antiair    = 1,
                    tank       = 8,
                    mdtank     = 8,
                    wartank    = 1,
                    artillery  = 25,
                    antitank   = 1,
                    rockets    = 35,
                    missiles   = 25,
                    rig        = 20,
                    fighter    = nil,
                    bomber     = nil,
                    duster     = nil,
                    bcopter    = 65,
                    tcopter    = 85,
                    seaplane   = nil,
                    battleship = nil,
                    carrier    = nil,
                    submarine  = nil,
                    cruiser    = nil,
                    lander     = nil,
                    gunboat    = nil,
                    meteor     = 1,
                },
            },
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "bcopter",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 6,
            type     = "air",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 2,
            destroyOnOutOfFuel     = true,
        },

        LevelOwner = {
            level = 0,
        },

        cost        = 9000,
        vision      = 2,
    },

    tcopter    = {
        GridIndexable = {},

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "tcopter",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 6,
            type     = "air",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 2,
            destroyOnOutOfFuel     = true,
        },

        cost        = 5000,
        vision      = 1,
    },

    seaplane   = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "Missiles",
                baseDamage  = {
                    infantry   = 90,
                    mech       = 85,
                    bike       = 85,
                    recon      = 80,
                    flare      = 80,
                    antiair    = 45,
                    tank       = 75,
                    mdtank     = 65,
                    wartank    = 55,
                    artillery  = 70,
                    antitank   = 50,
                    rockets    = 80,
                    missiles   = 70,
                    rig        = 75,
                    fighter    = 45,
                    bomber     = 55,
                    duster     = 65,
                    bcopter    = 85,
                    tcopter    = 95,
                    seaplane   = 55,
                    battleship = 45,
                    carrier    = 65,
                    submarine  = 55,
                    cruiser    = 40,
                    lander     = 85,
                    gunboat    = 105,
                    meteor     = 55,
                },
                maxAmmo     = 3,
                currentAmmo = 3,
            },
            secondaryWeapon = nil,
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "seaplane",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 7,
            type     = "air",
        },

        FuelOwner = {
            max                    = 40,
            current                = 40,
            consumptionPerTurn     = 5,
            destroyOnOutOfFuel     = true,
        },

        LevelOwner = {
            level = 0,
        },

        cost        = 15000,
        vision      = 4,
    },

    battleship = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 3,
            maxAttackRange     = 5,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "Cannon",
                baseDamage  = {
                    infantry   = 75,
                    mech       = 70,
                    bike       = 70,
                    recon      = 70,
                    flare      = 70,
                    antiair    = 65,
                    tank       = 65,
                    mdtank     = 50,
                    wartank    = 40,
                    artillery  = 70,
                    antitank   = 55,
                    rockets    = 75,
                    missiles   = 75,
                    rig        = 65,
                    fighter    = nil,
                    bomber     = nil,
                    duster     = nil,
                    bcopter    = nil,
                    tcopter    = nil,
                    seaplane   = nil,
                    battleship = 45,
                    carrier    = 50,
                    submarine  = 65,
                    cruiser    = 65,
                    lander     = 75,
                    gunboat    = 95,
                    meteor     = 55,
                },
                maxAmmo     = 6,
                currentAmmo = 6,
            },
            secondaryWeapon = nil,
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "battleship",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 5,
            type     = "ship",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 1,
            destroyOnOutOfFuel     = true,
        },

        LevelOwner = {
            level = 0,
        },

        cost        = 25000,
        vision      = 3,
    },

    carrier    = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = nil,
            secondaryWeapon = {
                type        = "AAGun",
                baseDamage  = {
                    infantry   = nil,
                    mech       = nil,
                    bike       = nil,
                    recon      = nil,
                    flare      = nil,
                    antiair    = nil,
                    tank       = nil,
                    mdtank     = nil,
                    wartank    = nil,
                    artillery  = nil,
                    antitank   = nil,
                    rockets    = nil,
                    missiles   = nil,
                    rig        = nil,
                    fighter    = 35,
                    bomber     = 35,
                    duster     = 40,
                    bcopter    = 45,
                    tcopter    = 55,
                    seaplane   = 40,
                    battleship = nil,
                    carrier    = nil,
                    submarine  = nil,
                    cruiser    = nil,
                    lander     = nil,
                    gunboat    = nil,
                    meteor     = nil,
                },
            },
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "carrier",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 5,
            type     = "ship",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 1,
            destroyOnOutOfFuel     = true,
        },

        LevelOwner = {
            level = 0,
        },

        cost        = 28000,
        vision      = 4,
    },

    submarine  = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "Torpedoes",
                baseDamage  = {
                    infantry   = nil,
                    mech       = nil,
                    bike       = nil,
                    recon      = nil,
                    flare      = nil,
                    antiair    = nil,
                    tank       = nil,
                    mdtank     = nil,
                    wartank    = nil,
                    artillery  = nil,
                    antitank   = nil,
                    rockets    = nil,
                    missiles   = nil,
                    rig        = nil,
                    fighter    = nil,
                    bomber     = nil,
                    duster     = nil,
                    bcopter    = nil,
                    tcopter    = nil,
                    seaplane   = nil,
                    battleship = 80,
                    carrier    = 110,
                    submarine  = 55,
                    cruiser    = 20,
                    lander     = 85,
                    gunboat    = 120,
                    meteor     = nil,
                },
                maxAmmo     = 6,
                currentAmmo = 6,
            },
            secondaryWeapon = nil,
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "submarine",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 5,
            type     = "ship",
        },

        FuelOwner = {
            max                    = 70,
            current                = 70,
            consumptionPerTurn     = 1,
            destroyOnOutOfFuel     = true,
        },

        LevelOwner = {
            level = 0,
        },

        cost        = 20000,
        vision      = 5,
    },

    cruiser    = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "ASMissiles",
                baseDamage  = {
                    infantry   = nil,
                    mech       = nil,
                    bike       = nil,
                    recon      = nil,
                    flare      = nil,
                    antiair    = nil,
                    tank       = nil,
                    mdtank     = nil,
                    wartank    = nil,
                    artillery  = nil,
                    antitank   = nil,
                    rockets    = nil,
                    missiles   = nil,
                    rig        = nil,
                    fighter    = nil,
                    bomber     = nil,
                    duster     = nil,
                    bcopter    = nil,
                    tcopter    = nil,
                    seaplane   = nil,
                    battleship = 38,
                    carrier    = 38,
                    submarine  = 95,
                    cruiser    = 28,
                    lander     = 40,
                    gunboat    = 85,
                    meteor     = nil,
                },
                maxAmmo     = 9,
                currentAmmo = 9,
            },
            secondaryWeapon = {
                type        = "AAGun",
                baseDamage  = {
                    infantry   = nil,
                    mech       = nil,
                    bike       = nil,
                    recon      = nil,
                    flare      = nil,
                    antiair    = nil,
                    tank       = nil,
                    mdtank     = nil,
                    wartank    = nil,
                    artillery  = nil,
                    antitank   = nil,
                    rockets    = nil,
                    missiles   = nil,
                    rig        = nil,
                    fighter    = 105,
                    bomber     = 105,
                    duster     = 105,
                    bcopter    = 120,
                    tcopter    = 120,
                    seaplane   = 105,
                    battleship = nil,
                    carrier    = nil,
                    submarine  = nil,
                    cruiser    = nil,
                    lander     = nil,
                    gunboat    = nil,
                    meteor     = nil,
                },
            },
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "cruiser",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 6,
            type     = "ship",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 1,
            destroyOnOutOfFuel     = true,
        },

        LevelOwner = {
            level = 0,
        },

        cost        = 16000,
        vision      = 5,
    },

    lander     = {
        GridIndexable = {},

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "lander",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 6,
            type     = "transport",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 1,
            destroyOnOutOfFuel     = true,
        },

        cost        = 10000,
        vision      = 1,
    },

    gunboat    = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "ASMissiles",
                baseDamage  = {
                    infantry   = nil,
                    mech       = nil,
                    bike       = nil,
                    recon      = nil,
                    flare      = nil,
                    antiair    = nil,
                    tank       = nil,
                    mdtank     = nil,
                    wartank    = nil,
                    artillery  = nil,
                    antitank   = nil,
                    rockets    = nil,
                    missiles   = nil,
                    rig        = nil,
                    fighter    = nil,
                    bomber     = nil,
                    duster     = nil,
                    bcopter    = nil,
                    tcopter    = nil,
                    seaplane   = nil,
                    battleship = 40,
                    carrier    = 40,
                    submarine  = 40,
                    cruiser    = 40,
                    lander     = 55,
                    gunboat    = 75,
                    meteor     = nil,
                },
                maxAmmo     = 1,
                currentAmmo = 1,
            },
            secondaryWeapon = nil,
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "gunboat",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 7,
            type     = "transport",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 1,
            destroyOnOutOfFuel     = true,
        },

        LevelOwner = {
            level = 0,
        },

        cost        = 6000,
        vision      = 2,
    },
}

return GameConstant
