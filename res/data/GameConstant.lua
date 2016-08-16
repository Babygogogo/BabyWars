
local GameConstant = {}

GameConstant.version = "0.1.6.0.2"

GameConstant.gridSize = {
    width = 72, height = 72
}

GameConstant.indexesForTileOrUnit = {
    {name = "Plain",           firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 1,  },
    {name = "River",           firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 16, },
    {name = "Sea",             firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 47, },
    {name = "Beach",           firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 12, },
    {name = "Road",            firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 11, },
    {name = "Bridge",          firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 11, },
    {name = "Wood",            firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 1,  },
    {name = "Mountain",        firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 1,  },
    {name = "Wasteland",       firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 1,  },
    {name = "Ruins",           firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 1,  },
    {name = "Fire",            firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 1,  },
    {name = "Rough",           firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 1,  },
    {name = "Mist",            firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 1,  },
    {name = "Reef",            firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 1,  },
    {name = "Plasma",          firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 1,  },
    {name = "Meteor",          firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 1,  },
    {name = "Silo",            firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 1,  },
    {name = "EmptySilo",       firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 1,  },
    {name = "Headquarters",    firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "City",            firstPlayerIndex = 0, isSamePlayerIndex = false, shapesCount = 5,  },
    {name = "CommandTower",    firstPlayerIndex = 0, isSamePlayerIndex = false, shapesCount = 5,  },
    {name = "Radar",           firstPlayerIndex = 0, isSamePlayerIndex = false, shapesCount = 5,  },
    {name = "Factory",         firstPlayerIndex = 0, isSamePlayerIndex = false, shapesCount = 5,  },
    {name = "Airport",         firstPlayerIndex = 0, isSamePlayerIndex = false, shapesCount = 5,  },
    {name = "Seaport",         firstPlayerIndex = 0, isSamePlayerIndex = false, shapesCount = 5,  },
    {name = "TempAirport",     firstPlayerIndex = 0, isSamePlayerIndex = false, shapesCount = 5,  },
    {name = "TempSeaport",     firstPlayerIndex = 0, isSamePlayerIndex = false, shapesCount = 5,  },
    {name = "RedPlasma",       firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 1,  },

    {name = "Infantry",        firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "Mech",            firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "Bike",            firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "Recon",           firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "Flare",           firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "AntiAir",         firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "Tank",            firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "MediumTank",      firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "WarTank",         firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "Artillery",       firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "AntiTank",        firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "Rockets",         firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "Missiles",        firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "Rig",             firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "Fighter",         firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "Bomber",          firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "Duster",          firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "BattleCopter",    firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "TransportCopter", firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "Seaplane",        firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "Battleship",      firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "Carrier",         firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "Submarine",       firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "Cruiser",         firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "Lander",          firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
    {name = "Gunboat",         firstPlayerIndex = 1, isSamePlayerIndex = false, shapesCount = 4,  },
}

GameConstant.tileAnimations = {
    Plain        = {typeIndex = 1,  shapesCount = 1,  framesCount = 1, durationPerFrame = 999999, fillsGrid = true,  },
    River        = {typeIndex = 2,  shapesCount = 16, framesCount = 1, durationPerFrame = 999999, fillsGrid = true,  },
    Sea          = {typeIndex = 3,  shapesCount = 47, framesCount = 8, durationPerFrame = 0.2,    fillsGrid = true,  },
    Beach        = {typeIndex = 4,  shapesCount = 12, framesCount = 8, durationPerFrame = 0.2,    fillsGrid = true,  },
    Road         = {typeIndex = 5,  shapesCount = 11, framesCount = 1, durationPerFrame = 999999, fillsGrid = false, },
    Bridge       = {typeIndex = 6,  shapesCount = 11, framesCount = 1, durationPerFrame = 999999, fillsGrid = false, },
    Wood         = {typeIndex = 7,  shapesCount = 1,  framesCount = 1, durationPerFrame = 999999, fillsGrid = true,  },
    Mountain     = {typeIndex = 8,  shapesCount = 1,  framesCount = 1, durationPerFrame = 999999, fillsGrid = true,  },
    Wasteland    = {typeIndex = 9,  shapesCount = 1,  framesCount = 1, durationPerFrame = 999999, fillsGrid = true,  },
    Ruins        = {typeIndex = 10, shapesCount = 1,  framesCount = 1, durationPerFrame = 999999, fillsGrid = true,  },
    Fire         = {typeIndex = 11, shapesCount = 1,  framesCount = 5, durationPerFrame = 0.1,    fillsGrid = true,  },
    Rough        = {typeIndex = 12, shapesCount = 1,  framesCount = 8, durationPerFrame = 0.2,    fillsGrid = true,  },
    Mist         = {typeIndex = 13, shapesCount = 1,  framesCount = 1, durationPerFrame = 999999, fillsGrid = false, },
    Reef         = {typeIndex = 14, shapesCount = 1,  framesCount = 8, durationPerFrame = 0.2,    fillsGrid = true,  },
    Plasma       = {typeIndex = 15, shapesCount = 1,  framesCount = 3, durationPerFrame = 0.1,    fillsGrid = false, },
    Meteor       = {typeIndex = 16, shapesCount = 1,  framesCount = 1, durationPerFrame = 999999, fillsGrid = false, },
    Silo         = {typeIndex = 17, shapesCount = 1,  framesCount = 1, durationPerFrame = 999999, fillsGrid = true,  },
    EmptySilo    = {typeIndex = 18, shapesCount = 1,  framesCount = 1, durationPerFrame = 999999, fillsGrid = true,  },
    Headquarters = {typeIndex = 19, shapesCount = 4,  framesCount = 2, durationPerFrame = 0.5,    fillsGrid = true,  },
    City         = {typeIndex = 20, shapesCount = 5,  framesCount = 2, durationPerFrame = 0.5,    fillsGrid = true,  },
    CommandTower = {typeIndex = 21, shapesCount = 5,  framesCount = 2, durationPerFrame = 0.5,    fillsGrid = true,  },
    Radar        = {typeIndex = 22, shapesCount = 5,  framesCount = 2, durationPerFrame = 0.5,    fillsGrid = true,  },
    Factory      = {typeIndex = 23, shapesCount = 5,  framesCount = 2, durationPerFrame = 0.5,    fillsGrid = true,  },
    Airport      = {typeIndex = 24, shapesCount = 5,  framesCount = 2, durationPerFrame = 0.5,    fillsGrid = true,  },
    Seaport      = {typeIndex = 25, shapesCount = 5,  framesCount = 2, durationPerFrame = 0.5,    fillsGrid = false, },
    TempAirport  = {typeIndex = 26, shapesCount = 5,  framesCount = 1, durationPerFrame = 999999, fillsGrid = false, },
    TempSeaport  = {typeIndex = 27, shapesCount = 5,  framesCount = 1, durationPerFrame = 999999, fillsGrid = false, },
    RedPlasma    = {typeIndex = 28, shapesCount = 1,  framesCount = 3, durationPerFrame = 0.1,    fillsGrid = false, },
}

GameConstant.unitAnimations = {
    Infantry = {
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

    Mech = {
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

    Bike = {
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

    Recon = {
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

    Flare = {
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

    AntiAir = {
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

    Tank = {
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

    MediumTank = {
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

    WarTank = {
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

    Artillery = {
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

    AntiTank = {
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

    Rockets = {
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

    Missiles = {
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

    Rig = {
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

    Fighter = {
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

    Bomber = {
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

    Duster = {
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

    BattleCopter = {
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

    TransportCopter = {
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

    Seaplane = {
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

    Battleship = {
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

    Carrier = {
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

    Submarine = {
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

    Cruiser = {
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

    Lander = {
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

    Gunboat = {
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

GameConstant.categories = {
    ["AllUnits"] = {
        "Infantry",
        "Mech",
        "Bike",
        "Recon",
        "Flare",
        "AntiAir",
        "Tank",
        "MediumTank",
        "WarTank",
        "Artillery",
        "AntiTank",
        "Rockets",
        "Missiles",
        "Rig",
        "Fighter",
        "Bomber",
        "Duster",
        "BattleCopter",
        "TransportCopter",
        "Seaplane",
        "Battleship",
        "Carrier",
        "Submarine",
        "Cruiser",
        "Lander",
        "Gunboat",
    },

    ["GroundUnits"] = {
        "Infantry",
        "Mech",
        "Bike",
        "Recon",
        "Flare",
        "AntiAir",
        "Tank",
        "MediumTank",
        "WarTank",
        "Artillery",
        "AntiTank",
        "Rockets",
        "Missiles",
        "Rig",
    },

    ["NavalUnits"] = {
        "Battleship",
        "Carrier",
        "Submarine",
        "Cruiser",
        "Lander",
        "Gunboat",
    },

    ["AirUnits"] = {
        "Fighter",
        "Bomber",
        "Duster",
        "BattleCopter",
        "TransportCopter",
        "Seaplane",
    },

    ["Ground/NavalUnits"] = {
        "Infantry",
        "Mech",
        "Bike",
        "Recon",
        "Flare",
        "AntiAir",
        "Tank",
        "MediumTank",
        "WarTank",
        "Artillery",
        "AntiTank",
        "Rockets",
        "Missiles",
        "Rig",
        "Battleship",
        "Carrier",
        "Submarine",
        "Cruiser",
        "Lander",
        "Gunboat",
    },

    ["None"] = {
    },

    ["FootUnits"] = {
        "Infantry",
        "Mech"
    },

    ["CopterUnits"] = {
        "BattleCopter",
        "TransportCopter",
    },

    ["SkillCategories"] = {
        "SkillCategoryAttack",
        "SkillCategoryDefense",
        "SkillCategoryCost",
    },

    ["SkillCategoryAttack"] = {
        1,
    },

    ["SkillCategoryDefense"] = {
        2,
    },

    ["SkillCategoryCost"] = {
        3,
    },
}

GameConstant.maxCapturePoint         = 20
GameConstant.maxBuildPoint           = 20
GameConstant.unitMaxHP               = 100
GameConstant.tileMaxHP               = 99
GameConstant.incomePerTurn           = 1000
GameConstant.commandTowerAttackBonus = 8

GameConstant.maxPromotion   = 3
GameConstant.promotionBonus = {
    {attack = 5,  defense = 5 },
    {attack = 10, defense = 10},
    {attack = 20, defense = 20},
}

GameConstant.moveTypes = {
    "Infantry",
    "Mech",
    "TireA",
    "TireB",
    "Tank",
    "Air",
    "Ship",
    "Transport",
}

GameConstant.templateModelTiles = {
    Plain = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 10,
            targetCategoryType = "GroundUnits",
        },

        MoveCostOwner = {
            Infantry  = 1,
            Mech      = 1,
            TireA     = 2,
            TireB     = 1,
            Tank      = 1,
            Air       = 1,
            Ship      = false,
            Transport = false,
        },

        Buildable = {
            currentBuildPoint = GameConstant.maxBuildPoint,
            maxBuildPoint     = GameConstant.maxBuildPoint,
        },
    },

    River = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 0,
            targetCategoryType = "None",
        },

        MoveCostOwner = {
            Infantry  = 2,
            Mech      = 1,
            TireA     = false,
            TireB     = false,
            Tank      = false,
            Air       = 1,
            Ship      = false,
            Transport = false,
        },
    },

    Sea = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 0,
            targetCategoryType = "None",
        },

        MoveCostOwner = {
            Infantry  = false,
            Mech      = false,
            TireA     = false,
            TireB     = false,
            Tank      = false,
            Air       = 1,
            Ship      = 1,
            Transport = 1,
        },
    },

    Beach = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 0,
            targetCategoryType = "None",
        },

        MoveCostOwner = {
            Infantry  = 1,
            Mech      = 1,
            TireA     = 2,
            TireB     = 2,
            Tank      = 1,
            Air       = 1,
            Ship      = false,
            Transport = 1,
        },

        Buildable = {
            currentBuildPoint = GameConstant.maxBuildPoint,
            maxBuildPoint     = GameConstant.maxBuildPoint,
        },
    },

    Road = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 0,
            targetCategoryType = "None",
        },

        MoveCostOwner = {
            Infantry  = 1,
            Mech      = 1,
            TireA     = 1,
            TireB     = 1,
            Tank      = 1,
            Air       = 1,
            Ship      = false,
            Transport = false,
        },
    },

    BridgeOnRiver = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 0,
            targetCategoryType = "None",
        },

        MoveCostOwner = {
            Infantry  = 1,
            Mech      = 1,
            TireA     = 1,
            TireB     = 1,
            Tank      = 1,
            Air       = 1,
            Ship      = false,
            Transport = false,
        },
    },

    BridgeOnSea = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 0,
            targetCategoryType = "None",
        },

        MoveCostOwner = {
            Infantry  = 1,
            Mech      = 1,
            TireA     = 1,
            TireB     = 1,
            Tank      = 1,
            Air       = 1,
            Ship      = 1,
            Transport = 1,
        },
    },

    Wood = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 30,
            targetCategoryType = "GroundUnits",
        },

        MoveCostOwner = {
            Infantry  = 1,
            Mech      = 1,
            TireA     = 3,
            TireB     = 3,
            Tank      = 2,
            Air       = 1,
            Ship      = false,
            Transport = false,
        },
    },

    Mountain = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 40,
            targetCategoryType = "FootUnits",
        },

        MoveCostOwner = {
            Infantry  = 2,
            Mech      = 1,
            TireA     = false,
            TireB     = false,
            Tank      = false,
            Air       = 1,
            Ship      = false,
            Transport = false,
        },
    },

    Wasteland = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 20,
            targetCategoryType = "GroundUnits",
        },

        MoveCostOwner = {
            Infantry  = 1,
            Mech      = 1,
            TireA     = 3,
            TireB     = 3,
            Tank      = 2,
            Air       = 1,
            Ship      = false,
            Transport = false,
        },
    },

    Ruins = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 10,
            targetCategoryType = "GroundUnits",
        },

        MoveCostOwner = {
            Infantry  = 1,
            Mech      = 1,
            TireA     = 2,
            TireB     = 1,
            Tank      = 1,
            Air       = 1,
            Ship      = false,
            Transport = false,
        },
    },

    Fire = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 0,
            targetCategoryType = "None",
        },

        MoveCostOwner = {
            Infantry  = false,
            Mech      = false,
            TireA     = false,
            TireB     = false,
            Tank      = false,
            Air       = false,
            Ship      = false,
            Transport = false,
        },
    },

    Rough = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 20,
            targetCategoryType = "NavalUnits",
        },

        MoveCostOwner = {
            Infantry  = false,
            Mech      = false,
            TireA     = false,
            TireB     = false,
            Tank      = false,
            Air       = 1,
            Ship      = 2,
            Transport = 2,
        },
    },

    Mist = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 10,
            targetCategoryType = "NavalUnits",
        },

        MoveCostOwner = {
            Infantry  = false,
            Mech      = false,
            TireA     = false,
            TireB     = false,
            Tank      = false,
            Air       = 1,
            Ship      = 1,
            Transport = 1,
        },
    },

    Reef = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 20,
            targetCategoryType = "NavalUnits",
        },

        MoveCostOwner = {
            Infantry  = false,
            Mech      = false,
            TireA     = false,
            TireB     = false,
            Tank      = false,
            Air       = 1,
            Ship      = 2,
            Transport = 2,
        },
    },

    Plasma = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 0,
            targetCategoryType = "None",
        },

        MoveCostOwner = {
            Infantry  = false,
            Mech      = false,
            TireA     = false,
            TireB     = false,
            Tank      = false,
            Air       = false,
            Ship      = false,
            Transport = false,
        },
    },

    RedPlasma = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount         = 0,
            targetCategoryType = "None",
        },

        MoveCostOwner = {
            Infantry  = false,
            Mech      = false,
            TireA     = false,
            TireB     = false,
            Tank      = false,
            Air       = false,
            Ship      = false,
            Transport = false,
        },
    },

    Meteor = {
        GridIndexable = {},

        AttackTaker = {
            maxHP            = GameConstant.tileMaxHP,
            currentHP        = GameConstant.tileMaxHP,
            defenseType      = "Meteor",
            isAffectedByLuck = false,
        },

        DefenseBonusProvider = {
            amount         = 0,
            targetCategoryType = "None",
        },

        MoveCostOwner = {
            Infantry  = false,
            Mech      = false,
            TireA     = false,
            TireB     = false,
            Tank      = false,
            Air       = false,
            Ship      = false,
            Transport = false,
        },
    },

    Silo = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount             = 20,
            targetCategoryType = "GroundUnits",
        },

        MoveCostOwner = {
            Infantry  = 1,
            Mech      = 1,
            TireA     = 1,
            TireB     = 1,
            Tank      = 1,
            Air       = 1,
            Ship      = false,
            Transport = false,
        },
    },

    EmptySilo = {
        GridIndexable = {},

        DefenseBonusProvider = {
            amount             = 20,
            targetCategoryType = "GroundUnits",
        },

        MoveCostOwner = {
            Infantry  = 1,
            Mech      = 1,
            TireA     = 1,
            TireB     = 1,
            Tank      = 1,
            Air       = 1,
            Ship      = false,
            Transport = false,
        },
    },

    Headquarters = {
        GridIndexable = {},

        Capturable = {
            maxCapturePoint     = GameConstant.maxCapturePoint,
            currentCapturePoint = GameConstant.maxCapturePoint,
            defeatOnCapture     = true,
        },

        RepairDoer = {
            targetCategoryType = "GroundUnits",
            amount         = 2,
        },

        IncomeProvider = {
            amount = 1000,
        },

        DefenseBonusProvider = {
            amount         = 40,
            targetCategoryType = "GroundUnits",
        },

        MoveCostOwner = {
            Infantry  = 1,
            Mech      = 1,
            TireA     = 1,
            TireB     = 1,
            Tank      = 1,
            Air       = 1,
            Ship      = false,
            Transport = false,
        },
    },

    City = {
        GridIndexable = {},

        Capturable = {
            maxCapturePoint     = GameConstant.maxCapturePoint,
            currentCapturePoint = GameConstant.maxCapturePoint,
            defeatOnCapture     = false,
        },

        RepairDoer = {
            targetCategoryType = "GroundUnits",
            amount         = 2,
        },

        IncomeProvider = {
            amount = 1000,
        },

        DefenseBonusProvider = {
            amount         = 20,
            targetCategoryType = "GroundUnits",
        },

        MoveCostOwner = {
            Infantry  = 1,
            Mech      = 1,
            TireA     = 1,
            TireB     = 1,
            Tank      = 1,
            Air       = 1,
            Ship      = false,
            Transport = false,
        },
    },

    CommandTower = {
        GridIndexable = {},

        Capturable = {
            maxCapturePoint     = GameConstant.maxCapturePoint,
            currentCapturePoint = GameConstant.maxCapturePoint,
            defeatOnCapture     = false,
        },

        IncomeProvider = {
            amount = 1000,
        },

        DefenseBonusProvider = {
            amount         = 30,
            targetCategoryType = "GroundUnits",
        },

        MoveCostOwner = {
            Infantry  = 1,
            Mech      = 1,
            TireA     = 1,
            TireB     = 1,
            Tank      = 1,
            Air       = 1,
            Ship      = false,
            Transport = false,
        },
    },

    Radar = {
        GridIndexable = {},

        Capturable = {
            maxCapturePoint     = GameConstant.maxCapturePoint,
            currentCapturePoint = GameConstant.maxCapturePoint,
            defeatOnCapture     = false,
        },

        IncomeProvider = {
            amount = 1000,
        },

        DefenseBonusProvider = {
            amount         = 30,
            targetCategoryType = "GroundUnits",
        },

        MoveCostOwner = {
            Infantry  = 1,
            Mech      = 1,
            TireA     = 1,
            TireB     = 1,
            Tank      = 1,
            Air       = 1,
            Ship      = false,
            Transport = false,
        },
    },

    Factory = {
        GridIndexable = {},

        Capturable = {
            maxCapturePoint     = GameConstant.maxCapturePoint,
            currentCapturePoint = GameConstant.maxCapturePoint,
            defeatOnCapture     = false,
        },

        RepairDoer = {
            targetCategoryType = "GroundUnits",
            amount         = 2,
        },

        IncomeProvider = {
            amount = 1000,
        },

        DefenseBonusProvider = {
            amount         = 30,
            targetCategoryType = "GroundUnits",
        },

        MoveCostOwner = {
            Infantry  = 1,
            Mech      = 1,
            TireA     = 1,
            TireB     = 1,
            Tank      = 1,
            Air       = 1,
            Ship      = false,
            Transport = false,
        },

        UnitProducer = {
            productionList = {
                "Infantry",
                "Mech",
                "Bike",
                "Recon",
                "Flare",
                "AntiAir",
                "Tank",
                "MediumTank",
                "WarTank",
                "Artillery",
                "AntiTank",
                "Rockets",
                "Missiles",
                "Rig",
            },
        },
    },

    Airport = {
        GridIndexable = {},

        Capturable = {
            maxCapturePoint     = GameConstant.maxCapturePoint,
            currentCapturePoint = GameConstant.maxCapturePoint,
            defeatOnCapture     = false,
        },

        RepairDoer = {
            targetCategoryType = "AirUnits",
            amount         = 2,
        },

        IncomeProvider = {
            amount = 1000,
        },

        DefenseBonusProvider = {
            amount         = 30,
            targetCategoryType = "GroundUnits",
        },

        MoveCostOwner = {
            Infantry  = 1,
            Mech      = 1,
            TireA     = 1,
            TireB     = 1,
            Tank      = 1,
            Air       = 1,
            Ship      = false,
            Transport = false,
        },

        UnitProducer = {
            productionList = {
                "Fighter",
                "Bomber",
                "Duster",
                "BattleCopter",
                "TransportCopter",
            },
        },
    },

    Seaport = {
        GridIndexable = {},

        Capturable = {
            maxCapturePoint     = GameConstant.maxCapturePoint,
            currentCapturePoint = GameConstant.maxCapturePoint,
            defeatOnCapture     = false,
        },

        RepairDoer = {
            targetCategoryType = "NavalUnits",
            amount         = 2,
        },

        IncomeProvider = {
            amount = 1000,
        },

        DefenseBonusProvider = {
            amount         = 30,
            targetCategoryType = "Ground/NavalUnits",
        },

        MoveCostOwner = {
            Infantry  = 1,
            Mech      = 1,
            TireA     = 1,
            TireB     = 1,
            Tank      = 1,
            Air       = 1,
            Ship      = 1,
            Transport = 1,
        },

        UnitProducer = {
            productionList = {
                "Battleship",
                "Carrier",
                "Submarine",
                "Cruiser",
                "Lander",
                "Gunboat",
            },
        },
    },

    TempAirport = {
        GridIndexable = {},

        Capturable = {
            maxCapturePoint     = GameConstant.maxCapturePoint,
            currentCapturePoint = GameConstant.maxCapturePoint,
            defeatOnCapture     = false,
        },

        RepairDoer = {
            targetCategoryType = "AirUnits",
            amount         = 2,
        },

        DefenseBonusProvider = {
            amount         = 10,
            targetCategoryType = "GroundUnits",
        },

        MoveCostOwner = {
            Infantry  = 1,
            Mech      = 1,
            TireA     = 1,
            TireB     = 1,
            Tank      = 1,
            Air       = 1,
            Ship      = false,
            Transport = false,
        },
    },

    TempSeaport = {
        GridIndexable = {},

        Capturable = {
            maxCapturePoint     = GameConstant.maxCapturePoint,
            currentCapturePoint = GameConstant.maxCapturePoint,
            defeatOnCapture     = false,
        },

        RepairDoer = {
            targetCategoryType = "NavalUnits",
            amount         = 2,
        },

        DefenseBonusProvider = {
            amount         = 10,
            targetCategoryType = "Ground/NavalUnits",
        },

        MoveCostOwner = {
            Infantry  = 1,
            Mech      = 1,
            TireA     = 1,
            TireB     = 1,
            Tank      = 1,
            Air       = 1,
            Ship      = 1,
            Transport = 1,
        },
    },
}

GameConstant.templateModelUnits = {
    Infantry   = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon   = nil,
            secondaryWeapon = {
                type        = "MachineGun",
                baseDamage  = {
                    Infantry        = 55,
                    Mech            = 45,
                    Bike            = 45,
                    Recon           = 12,
                    Flare           = 10,
                    AntiAir         = 3,
                    Tank            = 5,
                    MediumTank      = 5,
                    WarTank         = 1,
                    Artillery       = 10,
                    AntiTank        = 30,
                    Rockets         = 20,
                    Missiles        = 20,
                    Rig             = 14,
                    Fighter         = nil,
                    Bomber          = nil,
                    Duster          = nil,
                    BattleCopter    = 8,
                    TransportCopter = 30,
                    Seaplane        = nil,
                    Battleship      = nil,
                    Carrier         = nil,
                    Submarine       = nil,
                    Cruiser         = nil,
                    Lander          = nil,
                    Gunboat         = nil,
                    Meteor          = 1,
                },
            },
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "Infantry",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 3,
            type     = "Infantry",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        Promotable = {
            current = 0,
        },

        Capturer = {
            isCapturing = false,
        },

        SiloLauncher = {
            targetType   = "Silo",
            launchedType = "EmptySilo",
        },

        Producible = {
            productionCost = 1500,
        },

        Joinable = {},

        vision      = 2,
    },

    Mech       = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "Barzooka",
                baseDamage  = {
                    Infantry        = nil,
                    Mech            = nil,
                    Bike            = nil,
                    Recon           = 85,
                    Flare           = 80,
                    AntiAir         = 55,
                    Tank            = 55,
                    MediumTank      = 25,
                    WarTank         = 15,
                    Artillery       = 70,
                    AntiTank        = 55,
                    Rockets         = 85,
                    Missiles        = 85,
                    Rig             = 75,
                    Fighter         = nil,
                    Bomber          = nil,
                    Duster          = nil,
                    BattleCopter    = nil,
                    TransportCopter = nil,
                    Seaplane        = nil,
                    Battleship      = nil,
                    Carrier         = nil,
                    Submarine       = nil,
                    Cruiser         = nil,
                    Lander          = nil,
                    Gunboat         = nil,
                    Meteor          = 15,
                },
                maxAmmo     = 3,
                currentAmmo = 3,
            },
            secondaryWeapon = {
                type        = "MachineGun",
                baseDamage  = {
                    Infantry        = 65,
                    Mech            = 55,
                    Bike            = 55,
                    Recon           = 18,
                    Flare           = 15,
                    AntiAir         = 5,
                    Tank            = 8,
                    MediumTank      = 5,
                    WarTank         = 1,
                    Artillery       = 15,
                    AntiTank        = 35,
                    Rockets         = 35,
                    Missiles        = 35,
                    Rig             = 20,
                    Fighter         = nil,
                    Bomber          = nil,
                    Duster          = nil,
                    BattleCopter    = 12,
                    TransportCopter = 35,
                    Seaplane        = nil,
                    Battleship      = nil,
                    Carrier         = nil,
                    Submarine       = nil,
                    Cruiser         = nil,
                    Lander          = nil,
                    Gunboat         = nil,
                    Meteor          = 1,
                },
            },
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "Mech",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 2,
            type     = "Mech",
        },

        FuelOwner = {
            max                    = 70,
            current                = 70,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        Promotable = {
            current = 0,
        },

        Capturer = {
            isCapturing = false,
        },

        SiloLauncher = {
            targetType   = "Silo",
            launchedType = "EmptySilo",
        },

        Producible = {
            productionCost = 2500,
        },

        Joinable = {},

        vision      = 2,
    },

    Bike       = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon   = nil,
            secondaryWeapon = {
                type        = "MachineGun",
                baseDamage  = {
                    Infantry        = 65,
                    Mech            = 55,
                    Bike            = 55,
                    Recon           = 18,
                    Flare           = 15,
                    AntiAir         = 5,
                    Tank            = 8,
                    MediumTank      = 5,
                    WarTank         = 1,
                    Artillery       = 15,
                    AntiTank        = 35,
                    Rockets         = 35,
                    Missiles        = 35,
                    Rig             = 20,
                    Fighter         = nil,
                    Bomber          = nil,
                    Duster          = nil,
                    BattleCopter    = 12,
                    TransportCopter = 35,
                    Seaplane        = nil,
                    Battleship      = nil,
                    Carrier         = nil,
                    Submarine       = nil,
                    Cruiser         = nil,
                    Lander          = nil,
                    Gunboat         = nil,
                    Meteor          = 1,
                },
            },
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "Bike",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 5,
            type     = "TireB",
        },

        FuelOwner = {
            max                    = 70,
            current                = 70,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        Promotable = {
            current = 0,
        },

        Capturer = {
            isCapturing = false,
        },

        SiloLauncher = {
            targetType   = "Silo",
            launchedType = "EmptySilo",
        },

        Producible = {
            productionCost = 2500,
        },

        Joinable = {},

        vision      = 2,
    },

    Recon      = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon   = nil,
            secondaryWeapon = {
                type        = "MachineGun",
                baseDamage  = {
                    Infantry        = 75,
                    Mech            = 65,
                    Bike            = 65,
                    Recon           = 35,
                    Flare           = 30,
                    AntiAir         = 8,
                    Tank            = 8,
                    MediumTank      = 5,
                    WarTank         = 1,
                    Artillery       = 45,
                    AntiTank        = 25,
                    Rockets         = 55,
                    Missiles        = 55,
                    Rig             = 45,
                    Fighter         = nil,
                    Bomber          = nil,
                    Duster          = nil,
                    BattleCopter    = 18,
                    TransportCopter = 35,
                    Seaplane        = nil,
                    Battleship      = nil,
                    Carrier         = nil,
                    Submarine       = nil,
                    Cruiser         = nil,
                    Lander          = nil,
                    Gunboat         = nil,
                    Meteor          = 1,
                },
            },
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "Recon",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 8,
            type     = "TireA",
        },

        FuelOwner = {
            max                    = 80,
            current                = 80,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        Promotable = {
            current = 0,
        },

        Producible = {
            productionCost = 4000,
        },

        Joinable = {},

        vision      = 5,
    },

    Flare      = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon   = nil,
            secondaryWeapon = {
                type        = "MachineGun",
                baseDamage  = {
                    Infantry        = 80,
                    Mech            = 70,
                    Bike            = 70,
                    Recon           = 60,
                    Flare           = 50,
                    AntiAir         = 45,
                    Tank            = 10,
                    MediumTank      = 5,
                    WarTank         = 1,
                    Artillery       = 45,
                    AntiTank        = 25,
                    Rockets         = 55,
                    Missiles        = 55,
                    Rig             = 45,
                    Fighter         = nil,
                    Bomber          = nil,
                    Duster          = nil,
                    BattleCopter    = 18,
                    TransportCopter = 35,
                    Seaplane        = nil,
                    Battleship      = nil,
                    Carrier         = nil,
                    Submarine       = nil,
                    Cruiser         = nil,
                    Lander          = nil,
                    Gunboat         = nil,
                    Meteor          = 5,
                },
            },
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "Flare",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 5,
            type     = "Tank",
        },

        FuelOwner = {
            max                    = 60,
            current                = 60,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        Promotable = {
            current = 0,
        },

        Producible = {
            productionCost = 5000,
        },

        Joinable = {},

        vision      = 2,
    },

    AntiAir    = {
        GridIndexable = {},

        AttackDoer = {
            name               = "AttackDoer",
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "Cannon",
                baseDamage  = {
                    Infantry        = 105,
                    Mech            = 105,
                    Bike            = 105,
                    Recon           = 60,
                    Flare           = 50,
                    AntiAir         = 45,
                    Tank            = 15,
                    MediumTank      = 10,
                    WarTank         = 5,
                    Artillery       = 50,
                    AntiTank        = 25,
                    Rockets         = 55,
                    Missiles        = 55,
                    Rig             = 50,
                    Fighter         = 70,
                    Bomber          = 70,
                    Duster          = 75,
                    BattleCopter    = 105,
                    TransportCopter = 120,
                    Seaplane        = 75,
                    Battleship      = nil,
                    Carrier         = nil,
                    Submarine       = nil,
                    Cruiser         = nil,
                    Lander          = nil,
                    Gunboat         = nil,
                    Meteor          = 10,
                },
                maxAmmo     = 6,
                currentAmmo = 6,
            },
            secondaryWeapon = nil,
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "AntiAir",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 6,
            type     = "Tank",
        },

        FuelOwner = {
            max                    = 60,
            current                = 60,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        Promotable = {
            current = 0,
        },

        Producible = {
            productionCost = 7000,
        },

        Joinable = {},

        vision      = 3,
    },

    Tank       = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "TankGun",
                baseDamage  = {
                    Infantry        = nil,
                    Mech            = nil,
                    Bike            = nil,
                    Recon           = 85,
                    Flare           = 80,
                    AntiAir         = 75,
                    Tank            = 55,
                    MediumTank      = 35,
                    WarTank         = 20,
                    Artillery       = 70,
                    AntiTank        = 30,
                    Rockets         = 85,
                    Missiles        = 85,
                    Rig             = 75,
                    Fighter         = nil,
                    Bomber          = nil,
                    Duster          = nil,
                    BattleCopter    = nil,
                    TransportCopter = nil,
                    Seaplane        = nil,
                    Battleship      = 8,
                    Carrier         = 8,
                    Submarine       = 9,
                    Cruiser         = 9,
                    Lander          = 18,
                    Gunboat         = 55,
                    Meteor          = 20,
                },
                maxAmmo     = 6,
                currentAmmo = 6,
            },
            secondaryWeapon = {
                type        = "MachineGun",
                baseDamage  = {
                    Infantry        = 75,
                    Mech            = 70,
                    Bike            = 70,
                    Recon           = 40,
                    Flare           = 35,
                    AntiAir         = 8,
                    Tank            = 8,
                    MediumTank      = 5,
                    WarTank         = 1,
                    Artillery       = 45,
                    AntiTank        = 1,
                    Rockets         = 55,
                    Missiles        = 55,
                    Rig             = 45,
                    Fighter         = nil,
                    Bomber          = nil,
                    Duster          = nil,
                    BattleCopter    = 18,
                    TransportCopter = 35,
                    Seaplane        = nil,
                    Battleship      = nil,
                    Carrier         = nil,
                    Submarine       = nil,
                    Cruiser         = nil,
                    Lander          = nil,
                    Gunboat         = nil,
                    Meteor          = 1,
                },
            },
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "Tank",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 6,
            type     = "Tank",
        },

        FuelOwner = {
            max                    = 70,
            current                = 70,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        Promotable = {
            current = 0,
        },

        Producible = {
            productionCost = 7000,
        },

        Joinable = {},

        vision      = 3,
    },

    MediumTank = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "HeavyTankGun",
                baseDamage  = {
                    Infantry        = nil,
                    Mech            = nil,
                    Bike            = nil,
                    Recon           = 95,
                    Flare           = 90,
                    AntiAir         = 90,
                    Tank            = 70,
                    MediumTank      = 55,
                    WarTank         = 35,
                    Artillery       = 85,
                    AntiTank        = 35,
                    Rockets         = 90,
                    Missiles        = 90,
                    Rig             = 90,
                    Fighter         = nil,
                    Bomber          = nil,
                    Duster          = nil,
                    BattleCopter    = nil,
                    TransportCopter = nil,
                    Seaplane        = nil,
                    Battleship      = 10,
                    Carrier         = 10,
                    Submarine       = 12,
                    Cruiser         = 12,
                    Lander          = 22,
                    Gunboat         = 55,
                    Meteor          = 35,
                },
                maxAmmo     = 5,
                currentAmmo = 5,
            },
            secondaryWeapon = {
                type        = "MachineGun",
                baseDamage  = {
                    Infantry        = 90,
                    Mech            = 80,
                    Bike            = 80,
                    Recon           = 40,
                    Flare           = 35,
                    AntiAir         = 8,
                    Tank            = 8,
                    MediumTank      = 5,
                    WarTank         = 1,
                    Artillery       = 45,
                    AntiTank        = 1,
                    Rockets         = 60,
                    Missiles        = 60,
                    Rig             = 45,
                    Fighter         = nil,
                    Bomber          = nil,
                    Duster          = nil,
                    BattleCopter    = 24,
                    TransportCopter = 40,
                    Seaplane        = nil,
                    Battleship      = nil,
                    Carrier         = nil,
                    Submarine       = nil,
                    Cruiser         = nil,
                    Lander          = nil,
                    Gunboat         = nil,
                    Meteor          = 1,
                },
            },
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "MediumTank",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 5,
            type     = "Tank",
        },

        FuelOwner = {
            max                    = 50,
            current                = 50,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        Promotable = {
            current = 0,
        },

        Producible = {
            productionCost = 12000,
        },

        Joinable = {},

        vision      = 2,
    },

    WarTank    = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "MegaGun",
                baseDamage  = {
                    Infantry        = nil,
                    Mech            = nil,
                    Bike            = nil,
                    Recon           = 105,
                    Flare           = 105,
                    AntiAir         = 105,
                    Tank            = 85,
                    MediumTank      = 75,
                    WarTank         = 55,
                    Artillery       = 105,
                    AntiTank        = 40,
                    Rockets         = 105,
                    Missiles        = 105,
                    Rig             = 105,
                    Fighter         = nil,
                    Bomber          = nil,
                    Duster          = nil,
                    BattleCopter    = nil,
                    TransportCopter = nil,
                    Seaplane        = nil,
                    Battleship      = 12,
                    Carrier         = 12,
                    Submarine       = 14,
                    Cruiser         = 14,
                    Lander          = 28,
                    Gunboat         = 65,
                    Meteor          = 55,
                },
                maxAmmo     = 5,
                currentAmmo = 5,
            },
            secondaryWeapon = {
                type        = "MachineGun",
                baseDamage  = {
                    Infantry        = 105,
                    Mech            = 95,
                    Bike            = 95,
                    Recon           = 45,
                    Flare           = 40,
                    AntiAir         = 10,
                    Tank            = 10,
                    MediumTank      = 10,
                    WarTank         = 1,
                    Artillery       = 45,
                    AntiTank        = 1,
                    Rockets         = 65,
                    Missiles        = 65,
                    Rig             = 45,
                    Fighter         = nil,
                    Bomber          = nil,
                    Duster          = nil,
                    BattleCopter    = 35,
                    TransportCopter = 45,
                    Seaplane        = nil,
                    Battleship      = nil,
                    Carrier         = nil,
                    Submarine       = nil,
                    Cruiser         = nil,
                    Lander          = nil,
                    Gunboat         = nil,
                    Meteor          = 1,
                },
            },
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "WarTank",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 4,
            type     = "Tank",
        },

        FuelOwner = {
            max                    = 50,
            current                = 50,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        Promotable = {
            current = 0,
        },

        Producible = {
            productionCost = 16000,
        },

        Joinable = {},

        vision      = 2,
    },

    Artillery  = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 2,
            maxAttackRange     = 3,
            canAttackAfterMove = false,

            primaryWeapon = {
                type       = "Cannon",
                baseDamage = {
                    Infantry        = 90,
                    Mech            = 85,
                    Bike            = 85,
                    Recon           = 80,
                    Flare           = 75,
                    AntiAir         = 65,
                    Tank            = 60,
                    MediumTank      = 45,
                    WarTank         = 35,
                    Artillery       = 75,
                    AntiTank        = 55,
                    Rockets         = 80,
                    Missiles        = 80,
                    Rig             = 70,
                    Fighter         = nil,
                    Bomber          = nil,
                    Duster          = nil,
                    BattleCopter    = nil,
                    TransportCopter = nil,
                    Seaplane        = nil,
                    Battleship      = 45,
                    Carrier         = 45,
                    Submarine       = 55,
                    Cruiser         = 55,
                    Lander          = 65,
                    Gunboat         = 100,
                    Meteor          = 45,
                },
                maxAmmo     = 6,
                currentAmmo = 6,
            },
            secondaryWeapon = nil,
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "Artillery",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 5,
            type     = "Tank",
        },

        FuelOwner = {
            max                    = 50,
            current                = 50,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        Promotable = {
            current = 0,
        },

        Producible = {
            productionCost = 6000,
        },

        Joinable = {},

        vision      = 3,
    },

    AntiTank   = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 3,
            canAttackAfterMove = false,

            primaryWeapon = {
                type       = "Cannon",
                baseDamage = {
                    Infantry        = 75,
                    Mech            = 65,
                    Bike            = 65,
                    Recon           = 75,
                    Flare           = 75,
                    AntiAir         = 75,
                    Tank            = 75,
                    MediumTank      = 65,
                    WarTank         = 55,
                    Artillery       = 65,
                    AntiTank        = 55,
                    Rockets         = 70,
                    Missiles        = 70,
                    Rig             = 65,
                    Fighter         = nil,
                    Bomber          = nil,
                    Duster          = nil,
                    BattleCopter    = 45,
                    TransportCopter = 55,
                    Seaplane        = nil,
                    Battleship      = nil,
                    Carrier         = nil,
                    Submarine       = nil,
                    Cruiser         = nil,
                    Lander          = nil,
                    Gunboat         = nil,
                    Meteor          = 55,
                },
                maxAmmo     = 6,
                currentAmmo = 6,
            },
            secondaryWeapon = nil,
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "AntiTank",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 4,
            type     = "TireB",
        },

        FuelOwner = {
            max                    = 50,
            current                = 50,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        Promotable = {
            current = 0,
        },

        Producible = {
            productionCost = 11000,
        },

        Joinable = {},

        vision      = 3,
    },

    Rockets    = {
        GridIndexable = {},

        AttackDoer = {
            name               = "AttackDoer",
            minAttackRange     = 3,
            maxAttackRange     = 5,
            canAttackAfterMove = false,

            primaryWeapon = {
                type        = "Rockets",
                baseDamage  = {
                    Infantry        = 95,
                    Mech            = 90,
                    Bike            = 90,
                    Recon           = 90,
                    Flare           = 85,
                    AntiAir         = 75,
                    Tank            = 70,
                    MediumTank      = 55,
                    WarTank         = 45,
                    Artillery       = 80,
                    AntiTank        = 65,
                    Rockets         = 85,
                    Missiles        = 85,
                    Rig             = 80,
                    Fighter         = nil,
                    Bomber          = nil,
                    Duster          = nil,
                    BattleCopter    = nil,
                    TransportCopter = nil,
                    Seaplane        = nil,
                    Battleship      = 55,
                    Carrier         = 55,
                    Submarine       = 65,
                    Cruiser         = 65,
                    Lander          = 75,
                    Gunboat         = 105,
                    Meteor          = 55,
                },
                maxAmmo     = 5,
                currentAmmo = 5,
            },
            secondaryWeapon = nil,
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "Rockets",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 5,
            type     = "TireA",
        },

        FuelOwner = {
            max                    = 50,
            current                = 50,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        Promotable = {
            current = 0,
        },

        Producible = {
            productionCost = 15000,
        },

        Joinable = {},

        vision      = 3,
    },

    Missiles   = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 3,
            maxAttackRange     = 6,
            canAttackAfterMove = false,

            primaryWeapon = {
                type        = "AAMissiles",
                baseDamage  = {
                    Infantry        = nil,
                    Mech            = nil,
                    Bike            = nil,
                    Recon           = nil,
                    Flare           = nil,
                    AntiAir         = nil,
                    Tank            = nil,
                    MediumTank      = nil,
                    WarTank         = nil,
                    Artillery       = nil,
                    AntiTank        = nil,
                    Rockets         = nil,
                    Missiles        = nil,
                    Rig             = nil,
                    Fighter         = 100,
                    Bomber          = 100,
                    Duster          = 100,
                    BattleCopter    = 120,
                    TransportCopter = 120,
                    Seaplane        = 100,
                    Battleship      = nil,
                    Carrier         = nil,
                    Submarine       = nil,
                    Cruiser         = nil,
                    Lander          = nil,
                    Gunboat         = nil,
                    Meteor          = nil,
                },
                maxAmmo     = 5,
                currentAmmo = 5,
            },
            secondaryWeapon = nil,
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "Missiles",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 5,
            type     = "TireA",
        },

        FuelOwner = {
            max                    = 50,
            current                = 50,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        Promotable = {
            current = 0,
        },

        Producible = {
            productionCost = 12000,
        },

        Joinable = {},

        vision      = 5,
    },

    Rig        = {
        GridIndexable = {},

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "Rig",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 6,
            type     = "Tank",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 0,
            destroyOnOutOfFuel     = false,
        },

        UnitLoader = {
            maxLoadCount       = 1,
            targetCategoryType = "FootUnits",
            canLaunch          = false,
            canDrop            = true,
            canSupply          = false,
        },

        UnitSupplier = {},

        MaterialOwner = {
            max     = 1,
            current = 1,
        },

        TileBuilder = {
            buildList = {
                Plain = "TempAirport",
                Beach = "TempSeaport",
            }
        },

        Producible = {
            productionCost = 5000,
        },

        Joinable = {},

        vision      = 1,
    },

    Fighter    = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "AAMissiles",
                baseDamage  = {
                    Infantry        = nil,
                    Mech            = nil,
                    Bike            = nil,
                    Recon           = nil,
                    Flare           = nil,
                    AntiAir         = nil,
                    Tank            = nil,
                    MediumTank      = nil,
                    WarTank         = nil,
                    Artillery       = nil,
                    AntiTank        = nil,
                    Rockets         = nil,
                    Missiles        = nil,
                    Rig             = nil,
                    Fighter         = 55,
                    Bomber          = 65,
                    Duster          = 80,
                    BattleCopter    = 120,
                    TransportCopter = 120,
                    Seaplane        = 65,
                    Battleship      = nil,
                    Carrier         = nil,
                    Submarine       = nil,
                    Cruiser         = nil,
                    Lander          = nil,
                    Gunboat         = nil,
                    Meteor          = nil,
                },
                maxAmmo     = 6,
                currentAmmo = 6,
            },
            secondaryWeapon = nil,
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "Fighter",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 9,
            type     = "Air",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 5,
            destroyOnOutOfFuel     = true,
        },

        Promotable = {
            current = 0,
        },

        Producible = {
            productionCost = 20000,
        },

        Joinable = {},

        vision      = 5,
    },

    Bomber     = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "Bombs",
                baseDamage  = {
                    Infantry        = 115,
                    Mech            = 110,
                    Bike            = 110,
                    Recon           = 105,
                    Flare           = 105,
                    AntiAir         = 85,
                    Tank            = 105,
                    MediumTank      = 95,
                    WarTank         = 75,
                    Artillery       = 105,
                    AntiTank        = 80,
                    Rockets         = 105,
                    Missiles        = 95,
                    Rig             = 105,
                    Fighter         = nil,
                    Bomber          = nil,
                    Duster          = nil,
                    BattleCopter    = nil,
                    TransportCopter = nil,
                    Seaplane        = nil,
                    Battleship      = 85,
                    Carrier         = 85,
                    Submarine       = 95,
                    Cruiser         = 50,
                    Lander          = 95,
                    Gunboat         = 120,
                    Meteor          = 90,
                },
                maxAmmo     = 6,
                currentAmmo = 6,
            },
            secondaryWeapon = nil,
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "Bomber",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 7,
            type     = "Air",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 5,
            destroyOnOutOfFuel     = true,
        },

        Promotable = {
            current = 0,
        },

        Producible = {
            productionCost = 20000,
        },

        Joinable = {},

        vision      = 3,
    },

    Duster     = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "MachineGun",
                baseDamage  = {
                    Infantry        = 55,
                    Mech            = 45,
                    Bike            = 45,
                    Recon           = 18,
                    Flare           = 15,
                    AntiAir         = 5,
                    Tank            = 8,
                    MediumTank      = 5,
                    WarTank         = 1,
                    Artillery       = 15,
                    AntiTank        = 5,
                    Rockets         = 20,
                    Missiles        = 20,
                    Rig             = 15,
                    Fighter         = 40,
                    Bomber          = 45,
                    Duster          = 55,
                    BattleCopter    = 75,
                    TransportCopter = 90,
                    Seaplane        = 45,
                    Battleship      = nil,
                    Carrier         = nil,
                    Submarine       = nil,
                    Cruiser         = nil,
                    Lander          = nil,
                    Gunboat         = nil,
                    Meteor          = 1,
                },
                maxAmmo     = 9,
                currentAmmo = 9,
            },
            secondaryWeapon = nil,
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "Duster",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 8,
            type     = "Air",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 5,
            destroyOnOutOfFuel     = true,
        },

        Promotable = {
            current = 0,
        },

        Producible = {
            productionCost = 13000,
        },

        Joinable = {},

        vision      = 4,
    },

    BattleCopter    = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "Missiles",
                baseDamage  = {
                    Infantry        = nil,
                    Mech            = nil,
                    Bike            = nil,
                    Recon           = 75,
                    Flare           = 75,
                    AntiAir         = 10,
                    Tank            = 70,
                    MediumTank      = 45,
                    WarTank         = 35,
                    Artillery       = 65,
                    AntiTank        = 20,
                    Rockets         = 75,
                    Missiles        = 55,
                    Rig             = 70,
                    Fighter         = nil,
                    Bomber          = nil,
                    Duster          = nil,
                    BattleCopter    = nil,
                    TransportCopter = nil,
                    Seaplane        = nil,
                    Battleship      = 25,
                    Carrier         = 25,
                    Submarine       = 25,
                    Cruiser         = 5,
                    Lander          = 25,
                    Gunboat         = 85,
                    Meteor          = 20,
                },
                maxAmmo     = 6,
                currentAmmo = 6,
            },
            secondaryWeapon = {
                type        = "MachineGun",
                baseDamage  = {
                    Infantry        = 75,
                    Mech            = 65,
                    Bike            = 65,
                    Recon           = 30,
                    Flare           = 30,
                    AntiAir         = 1,
                    Tank            = 8,
                    MediumTank      = 8,
                    WarTank         = 1,
                    Artillery       = 25,
                    AntiTank        = 1,
                    Rockets         = 35,
                    Missiles        = 25,
                    Rig             = 20,
                    Fighter         = nil,
                    Bomber          = nil,
                    Duster          = nil,
                    BattleCopter    = 65,
                    TransportCopter = 85,
                    Seaplane        = nil,
                    Battleship      = nil,
                    Carrier         = nil,
                    Submarine       = nil,
                    Cruiser         = nil,
                    Lander          = nil,
                    Gunboat         = nil,
                    Meteor          = 1,
                },
            },
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "BattleCopter",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 6,
            type     = "Air",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 2,
            destroyOnOutOfFuel     = true,
        },

        Promotable = {
            current = 0,
        },

        Producible = {
            productionCost = 9000,
        },

        Joinable = {},

        vision      = 2,
    },

    TransportCopter    = {
        GridIndexable = {},

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "TransportCopter",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 6,
            type     = "Air",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 2,
            destroyOnOutOfFuel     = true,
        },

        UnitLoader = {
            maxLoadCount       = 1,
            targetCategoryType = "FootUnits",
            canLaunch          = false,
            canDrop            = true,
            canSupply          = false,
        },

        Producible = {
            productionCost = 5000,
        },

        Joinable = {},

        vision      = 1,
    },

    Seaplane   = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "Missiles",
                baseDamage  = {
                    Infantry        = 90,
                    Mech            = 85,
                    Bike            = 85,
                    Recon           = 80,
                    Flare           = 80,
                    AntiAir         = 45,
                    Tank            = 75,
                    MediumTank      = 65,
                    WarTank         = 55,
                    Artillery       = 70,
                    AntiTank        = 50,
                    Rockets         = 80,
                    Missiles        = 70,
                    Rig             = 75,
                    Fighter         = 45,
                    Bomber          = 55,
                    Duster          = 65,
                    BattleCopter    = 85,
                    TransportCopter = 95,
                    Seaplane        = 55,
                    Battleship      = 45,
                    Carrier         = 65,
                    Submarine       = 55,
                    Cruiser         = 40,
                    Lander          = 85,
                    Gunboat         = 105,
                    Meteor          = 55,
                },
                maxAmmo     = 3,
                currentAmmo = 3,
            },
            secondaryWeapon = nil,
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "Seaplane",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 7,
            type     = "Air",
        },

        FuelOwner = {
            max                    = 40,
            current                = 40,
            consumptionPerTurn     = 5,
            destroyOnOutOfFuel     = true,
        },

        Promotable = {
            current = 0,
        },

        Producible = {
            productionCost = 15000,
        },

        Joinable = {},

        vision      = 4,
    },

    Battleship = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 3,
            maxAttackRange     = 5,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "Cannon",
                baseDamage  = {
                    Infantry        = 75,
                    Mech            = 70,
                    Bike            = 70,
                    Recon           = 70,
                    Flare           = 70,
                    AntiAir         = 65,
                    Tank            = 65,
                    MediumTank      = 50,
                    WarTank         = 40,
                    Artillery       = 70,
                    AntiTank        = 55,
                    Rockets         = 75,
                    Missiles        = 75,
                    Rig             = 65,
                    Fighter         = nil,
                    Bomber          = nil,
                    Duster          = nil,
                    BattleCopter    = nil,
                    TransportCopter = nil,
                    Seaplane        = nil,
                    Battleship      = 45,
                    Carrier         = 50,
                    Submarine       = 65,
                    Cruiser         = 65,
                    Lander          = 75,
                    Gunboat         = 95,
                    Meteor          = 55,
                },
                maxAmmo     = 6,
                currentAmmo = 6,
            },
            secondaryWeapon = nil,
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "Battleship",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 5,
            type     = "Ship",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 1,
            destroyOnOutOfFuel     = true,
        },

        Promotable = {
            current = 0,
        },

        Producible = {
            productionCost = 25000,
        },

        Joinable = {},

        vision      = 3,
    },

    Carrier    = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = nil,
            secondaryWeapon = {
                type        = "AAGun",
                baseDamage  = {
                    Infantry        = nil,
                    Mech            = nil,
                    Bike            = nil,
                    Recon           = nil,
                    Flare           = nil,
                    AntiAir         = nil,
                    Tank            = nil,
                    MediumTank      = nil,
                    WarTank         = nil,
                    Artillery       = nil,
                    AntiTank        = nil,
                    Rockets         = nil,
                    Missiles        = nil,
                    Rig             = nil,
                    Fighter         = 35,
                    Bomber          = 35,
                    Duster          = 40,
                    BattleCopter    = 45,
                    TransportCopter = 55,
                    Seaplane        = 40,
                    Battleship      = nil,
                    Carrier         = nil,
                    Submarine       = nil,
                    Cruiser         = nil,
                    Lander          = nil,
                    Gunboat         = nil,
                    Meteor          = nil,
                },
            },
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "Carrier",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 5,
            type     = "Ship",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 1,
            destroyOnOutOfFuel     = true,
        },

        UnitLoader = {
            maxLoadCount       = 2,
            targetCategoryType = "AirUnits",
            canLaunch          = true,
            canDrop            = false,
            canSupply          = true,
        },

        Promotable = {
            current = 0,
        },

        MaterialOwner = {
            max     = 4,
            current = 4,
        },

        MovableUnitProducer = {
            targetType = "Seaplane",
        },

        Producible = {
            productionCost = 28000,
        },

        Joinable = {},

        vision      = 4,
    },

    Submarine  = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "Torpedoes",
                baseDamage  = {
                    Infantry        = nil,
                    Mech            = nil,
                    Bike            = nil,
                    Recon           = nil,
                    Flare           = nil,
                    AntiAir         = nil,
                    Tank            = nil,
                    MediumTank      = nil,
                    WarTank         = nil,
                    Artillery       = nil,
                    AntiTank        = nil,
                    Rockets         = nil,
                    Missiles        = nil,
                    Rig             = nil,
                    Fighter         = nil,
                    Bomber          = nil,
                    Duster          = nil,
                    BattleCopter    = nil,
                    TransportCopter = nil,
                    Seaplane        = nil,
                    Battleship      = 80,
                    Carrier         = 110,
                    Submarine       = 55,
                    Cruiser         = 20,
                    Lander          = 85,
                    Gunboat         = 120,
                    Meteor          = nil,
                },
                maxAmmo     = 6,
                currentAmmo = 6,
            },
            secondaryWeapon = nil,
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "Submarine",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 5,
            type     = "Ship",
        },

        FuelOwner = {
            max                    = 70,
            current                = 70,
            consumptionPerTurn     = 1,
            destroyOnOutOfFuel     = true,
        },

        Promotable = {
            current = 0,
        },

        Producible = {
            productionCost = 20000,
        },

        Joinable = {},

        vision      = 5,
    },

    Cruiser    = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "ASMissiles",
                baseDamage  = {
                    Infantry        = nil,
                    Mech            = nil,
                    Bike            = nil,
                    Recon           = nil,
                    Flare           = nil,
                    AntiAir         = nil,
                    Tank            = nil,
                    MediumTank      = nil,
                    WarTank         = nil,
                    Artillery       = nil,
                    AntiTank        = nil,
                    Rockets         = nil,
                    Missiles        = nil,
                    Rig             = nil,
                    Fighter         = nil,
                    Bomber          = nil,
                    Duster          = nil,
                    BattleCopter    = nil,
                    TransportCopter = nil,
                    Seaplane        = nil,
                    Battleship      = 38,
                    Carrier         = 38,
                    Submarine       = 95,
                    Cruiser         = 28,
                    Lander          = 40,
                    Gunboat         = 85,
                    Meteor          = nil,
                },
                maxAmmo     = 9,
                currentAmmo = 9,
            },
            secondaryWeapon = {
                type        = "AAGun",
                baseDamage  = {
                    Infantry        = nil,
                    Mech            = nil,
                    Bike            = nil,
                    Recon           = nil,
                    Flare           = nil,
                    AntiAir         = nil,
                    Tank            = nil,
                    MediumTank      = nil,
                    WarTank         = nil,
                    Artillery       = nil,
                    AntiTank        = nil,
                    Rockets         = nil,
                    Missiles        = nil,
                    Rig             = nil,
                    Fighter         = 105,
                    Bomber          = 105,
                    Duster          = 105,
                    BattleCopter    = 120,
                    TransportCopter = 120,
                    Seaplane        = 105,
                    Battleship      = nil,
                    Carrier         = nil,
                    Submarine       = nil,
                    Cruiser         = nil,
                    Lander          = nil,
                    Gunboat         = nil,
                    Meteor          = nil,
                },
            },
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "Cruiser",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 6,
            type     = "Ship",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 1,
            destroyOnOutOfFuel     = true,
        },

        Promotable = {
            current = 0,
        },

        UnitLoader = {
            maxLoadCount       = 2,
            targetCategoryType = "CopterUnits",
            canLaunch          = true,
            canDrop            = false,
            canSupply          = true,
        },

        Producible = {
            productionCost = 16000,
        },

        Joinable = {},

        vision      = 5,
    },

    Lander     = {
        GridIndexable = {},

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "Lander",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 6,
            type     = "Transport",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 1,
            destroyOnOutOfFuel     = true,
        },

        UnitLoader = {
            maxLoadCount       = 2,
            targetCategoryType = "GroundUnits",
            canLaunch          = false,
            canDrop            = true,
            canSupply          = false,
        },

        Producible = {
            productionCost = 10000,
        },

        Joinable = {},

        vision      = 1,
    },

    Gunboat    = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                type        = "ASMissiles",
                baseDamage  = {
                    Infantry        = nil,
                    Mech            = nil,
                    Bike            = nil,
                    Recon           = nil,
                    Flare           = nil,
                    AntiAir         = nil,
                    Tank            = nil,
                    MediumTank      = nil,
                    WarTank         = nil,
                    Artillery       = nil,
                    AntiTank        = nil,
                    Rockets         = nil,
                    Missiles        = nil,
                    Rig             = nil,
                    Fighter         = nil,
                    Bomber          = nil,
                    Duster          = nil,
                    BattleCopter    = nil,
                    TransportCopter = nil,
                    Seaplane        = nil,
                    Battleship      = 40,
                    Carrier         = 40,
                    Submarine       = 40,
                    Cruiser         = 40,
                    Lander          = 55,
                    Gunboat         = 75,
                    Meteor          = nil,
                },
                maxAmmo     = 1,
                currentAmmo = 1,
            },
            secondaryWeapon = nil,
        },

        AttackTaker = {
            maxHP            = GameConstant.unitMaxHP,
            currentHP        = GameConstant.unitMaxHP,
            defenseType      = "Gunboat",
            isAffectedByLuck = true,
        },

        MoveDoer = {
            range    = 7,
            type     = "Transport",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 1,
            destroyOnOutOfFuel     = true,
        },

        UnitLoader = {
            maxLoadCount       = 1,
            targetCategoryType = "FootUnits",
            canLaunch          = false,
            canDrop            = true,
            canSupply          = false,
        },

        Promotable = {
            current = 0,
        },

        Producible = {
            productionCost = 6000,
        },

        Joinable = {},

        vision      = 2,
    },
}

GameConstant.minSkillPoints                  = 0
GameConstant.maxSkillPoints                  = 500
GameConstant.minEnergyRequirement            = 1
GameConstant.maxEnergyRequirement            = 15
GameConstant.skillPointsPerStep              = 25
GameConstant.skillPointsPerEnergyRequirement = 100
GameConstant.damageCostPerEnergyRequirement  = 9000
GameConstant.damageCostGrowthRates           = 20
GameConstant.skillConfigurationsCount        = 10
GameConstant.passiveSkillSlotsCount          = 4
GameConstant.activeSkillSlotsCount           = 4

GameConstant.skills = {
    -- Modify the attack power for all units of a player.
    [1] = {
        minLevel     = -50,
        maxLevel     = 50,
        modifierUnit = "%",
        levels = {
            [-50] = {modifier = -50, points = -500,},
            [-49] = {modifier = -49, points = -490,},
            [-48] = {modifier = -48, points = -480,},
            [-47] = {modifier = -47, points = -470,},
            [-46] = {modifier = -46, points = -460,},
            [-45] = {modifier = -45, points = -450,},
            [-44] = {modifier = -44, points = -440,},
            [-43] = {modifier = -43, points = -430,},
            [-42] = {modifier = -42, points = -420,},
            [-41] = {modifier = -41, points = -410,},
            [-40] = {modifier = -40, points = -400,},
            [-39] = {modifier = -39, points = -390,},
            [-38] = {modifier = -38, points = -380,},
            [-37] = {modifier = -37, points = -370,},
            [-36] = {modifier = -36, points = -360,},
            [-35] = {modifier = -35, points = -350,},
            [-34] = {modifier = -34, points = -340,},
            [-33] = {modifier = -33, points = -330,},
            [-32] = {modifier = -32, points = -320,},
            [-31] = {modifier = -31, points = -310,},
            [-30] = {modifier = -30, points = -300,},
            [-29] = {modifier = -29, points = -290,},
            [-28] = {modifier = -28, points = -280,},
            [-27] = {modifier = -27, points = -270,},
            [-26] = {modifier = -26, points = -260,},
            [-25] = {modifier = -25, points = -250,},
            [-24] = {modifier = -24, points = -240,},
            [-23] = {modifier = -23, points = -230,},
            [-22] = {modifier = -22, points = -220,},
            [-21] = {modifier = -21, points = -210,},
            [-20] = {modifier = -20, points = -200,},
            [-19] = {modifier = -19, points = -190,},
            [-18] = {modifier = -18, points = -180,},
            [-17] = {modifier = -17, points = -170,},
            [-16] = {modifier = -16, points = -160,},
            [-15] = {modifier = -15, points = -150,},
            [-14] = {modifier = -14, points = -140,},
            [-13] = {modifier = -13, points = -130,},
            [-12] = {modifier = -12, points = -120,},
            [-11] = {modifier = -11, points = -110,},
            [-10] = {modifier = -10, points = -100,},
            [-9]  = {modifier = -9,  points = -90,},
            [-8]  = {modifier = -8,  points = -80,},
            [-7]  = {modifier = -7,  points = -70,},
            [-6]  = {modifier = -6,  points = -60,},
            [-5]  = {modifier = -5,  points = -50,},
            [-4]  = {modifier = -4,  points = -40,},
            [-3]  = {modifier = -3,  points = -30,},
            [-2]  = {modifier = -2,  points = -20,},
            [-1]  = {modifier = -1,  points = -10,},
            [0]   = {modifier = 0,   points = 0,},
            [1]   = {modifier = 1,   points = 10,},
            [2]   = {modifier = 2,   points = 20,},
            [3]   = {modifier = 3,   points = 30,},
            [4]   = {modifier = 4,   points = 40,},
            [5]   = {modifier = 5,   points = 50,},
            [6]   = {modifier = 6,   points = 60,},
            [7]   = {modifier = 7,   points = 70,},
            [8]   = {modifier = 8,   points = 80,},
            [9]   = {modifier = 9,   points = 90,},
            [10]  = {modifier = 10,  points = 100,},
            [11]  = {modifier = 11,  points = 110,},
            [12]  = {modifier = 12,  points = 120,},
            [13]  = {modifier = 13,  points = 130,},
            [14]  = {modifier = 14,  points = 140,},
            [15]  = {modifier = 15,  points = 150,},
            [16]  = {modifier = 16,  points = 160,},
            [17]  = {modifier = 17,  points = 170,},
            [18]  = {modifier = 18,  points = 180,},
            [19]  = {modifier = 19,  points = 190,},
            [20]  = {modifier = 20,  points = 200,},
            [21]  = {modifier = 21,  points = 210,},
            [22]  = {modifier = 22,  points = 220,},
            [23]  = {modifier = 23,  points = 230,},
            [24]  = {modifier = 24,  points = 240,},
            [25]  = {modifier = 25,  points = 250,},
            [26]  = {modifier = 26,  points = 260,},
            [27]  = {modifier = 27,  points = 270,},
            [28]  = {modifier = 28,  points = 280,},
            [29]  = {modifier = 29,  points = 290,},
            [30]  = {modifier = 30,  points = 300,},
            [31]  = {modifier = 31,  points = 310,},
            [32]  = {modifier = 32,  points = 320,},
            [33]  = {modifier = 33,  points = 330,},
            [34]  = {modifier = 34,  points = 340,},
            [35]  = {modifier = 35,  points = 350,},
            [36]  = {modifier = 36,  points = 360,},
            [37]  = {modifier = 37,  points = 370,},
            [38]  = {modifier = 38,  points = 380,},
            [39]  = {modifier = 39,  points = 390,},
            [40]  = {modifier = 40,  points = 400,},
            [41]  = {modifier = 41,  points = 410,},
            [42]  = {modifier = 42,  points = 420,},
            [43]  = {modifier = 43,  points = 430,},
            [44]  = {modifier = 44,  points = 440,},
            [45]  = {modifier = 45,  points = 450,},
            [46]  = {modifier = 46,  points = 460,},
            [47]  = {modifier = 47,  points = 470,},
            [48]  = {modifier = 48,  points = 480,},
            [49]  = {modifier = 49,  points = 490,},
            [50]  = {modifier = 50,  points = 500,},
        },
    },

    -- Modify the defense power for all units of a player.
    [2] = {
        minLevel     = -50,
        maxLevel     = 50,
        modifierUnit = "%",
        levels = {
            [-50] = {modifier = -50, points = -500,},
            [-49] = {modifier = -49, points = -490,},
            [-48] = {modifier = -48, points = -480,},
            [-47] = {modifier = -47, points = -470,},
            [-46] = {modifier = -46, points = -460,},
            [-45] = {modifier = -45, points = -450,},
            [-44] = {modifier = -44, points = -440,},
            [-43] = {modifier = -43, points = -430,},
            [-42] = {modifier = -42, points = -420,},
            [-41] = {modifier = -41, points = -410,},
            [-40] = {modifier = -40, points = -400,},
            [-39] = {modifier = -39, points = -390,},
            [-38] = {modifier = -38, points = -380,},
            [-37] = {modifier = -37, points = -370,},
            [-36] = {modifier = -36, points = -360,},
            [-35] = {modifier = -35, points = -350,},
            [-34] = {modifier = -34, points = -340,},
            [-33] = {modifier = -33, points = -330,},
            [-32] = {modifier = -32, points = -320,},
            [-31] = {modifier = -31, points = -310,},
            [-30] = {modifier = -30, points = -300,},
            [-29] = {modifier = -29, points = -290,},
            [-28] = {modifier = -28, points = -280,},
            [-27] = {modifier = -27, points = -270,},
            [-26] = {modifier = -26, points = -260,},
            [-25] = {modifier = -25, points = -250,},
            [-24] = {modifier = -24, points = -240,},
            [-23] = {modifier = -23, points = -230,},
            [-22] = {modifier = -22, points = -220,},
            [-21] = {modifier = -21, points = -210,},
            [-20] = {modifier = -20, points = -200,},
            [-19] = {modifier = -19, points = -190,},
            [-18] = {modifier = -18, points = -180,},
            [-17] = {modifier = -17, points = -170,},
            [-16] = {modifier = -16, points = -160,},
            [-15] = {modifier = -15, points = -150,},
            [-14] = {modifier = -14, points = -140,},
            [-13] = {modifier = -13, points = -130,},
            [-12] = {modifier = -12, points = -120,},
            [-11] = {modifier = -11, points = -110,},
            [-10] = {modifier = -10, points = -100,},
            [-9]  = {modifier = -9,  points = -90,},
            [-8]  = {modifier = -8,  points = -80,},
            [-7]  = {modifier = -7,  points = -70,},
            [-6]  = {modifier = -6,  points = -60,},
            [-5]  = {modifier = -5,  points = -50,},
            [-4]  = {modifier = -4,  points = -40,},
            [-3]  = {modifier = -3,  points = -30,},
            [-2]  = {modifier = -2,  points = -20,},
            [-1]  = {modifier = -1,  points = -10,},
            [0]   = {modifier = 0,   points = 0,},
            [1]   = {modifier = 1,   points = 10,},
            [2]   = {modifier = 2,   points = 20,},
            [3]   = {modifier = 3,   points = 30,},
            [4]   = {modifier = 4,   points = 40,},
            [5]   = {modifier = 5,   points = 50,},
            [6]   = {modifier = 6,   points = 60,},
            [7]   = {modifier = 7,   points = 70,},
            [8]   = {modifier = 8,   points = 80,},
            [9]   = {modifier = 9,   points = 90,},
            [10]  = {modifier = 10,  points = 100,},
            [11]  = {modifier = 11,  points = 110,},
            [12]  = {modifier = 12,  points = 120,},
            [13]  = {modifier = 13,  points = 130,},
            [14]  = {modifier = 14,  points = 140,},
            [15]  = {modifier = 15,  points = 150,},
            [16]  = {modifier = 16,  points = 160,},
            [17]  = {modifier = 17,  points = 170,},
            [18]  = {modifier = 18,  points = 180,},
            [19]  = {modifier = 19,  points = 190,},
            [20]  = {modifier = 20,  points = 200,},
            [21]  = {modifier = 21,  points = 210,},
            [22]  = {modifier = 22,  points = 220,},
            [23]  = {modifier = 23,  points = 230,},
            [24]  = {modifier = 24,  points = 240,},
            [25]  = {modifier = 25,  points = 250,},
            [26]  = {modifier = 26,  points = 260,},
            [27]  = {modifier = 27,  points = 270,},
            [28]  = {modifier = 28,  points = 280,},
            [29]  = {modifier = 29,  points = 290,},
            [30]  = {modifier = 30,  points = 300,},
            [31]  = {modifier = 31,  points = 310,},
            [32]  = {modifier = 32,  points = 320,},
            [33]  = {modifier = 33,  points = 330,},
            [34]  = {modifier = 34,  points = 340,},
            [35]  = {modifier = 35,  points = 350,},
            [36]  = {modifier = 36,  points = 360,},
            [37]  = {modifier = 37,  points = 370,},
            [38]  = {modifier = 38,  points = 380,},
            [39]  = {modifier = 39,  points = 390,},
            [40]  = {modifier = 40,  points = 400,},
            [41]  = {modifier = 41,  points = 410,},
            [42]  = {modifier = 42,  points = 420,},
            [43]  = {modifier = 43,  points = 430,},
            [44]  = {modifier = 44,  points = 440,},
            [45]  = {modifier = 45,  points = 450,},
            [46]  = {modifier = 46,  points = 460,},
            [47]  = {modifier = 47,  points = 470,},
            [48]  = {modifier = 48,  points = 480,},
            [49]  = {modifier = 49,  points = 490,},
            [50]  = {modifier = 50,  points = 500,},
        },
    },

    -- Modify the production cost for all units of a player.
    [3] = {
        minLevel     = -50,
        maxLevel     = 50,
        modifierUnit = "%",
        levels = {
            [-50] = {modifier = 50,  points = -500,},
            [-49] = {modifier = 49,  points = -490,},
            [-48] = {modifier = 48,  points = -480,},
            [-47] = {modifier = 47,  points = -470,},
            [-46] = {modifier = 46,  points = -460,},
            [-45] = {modifier = 45,  points = -450,},
            [-44] = {modifier = 44,  points = -440,},
            [-43] = {modifier = 43,  points = -430,},
            [-42] = {modifier = 42,  points = -420,},
            [-41] = {modifier = 41,  points = -410,},
            [-40] = {modifier = 40,  points = -400,},
            [-39] = {modifier = 39,  points = -390,},
            [-38] = {modifier = 38,  points = -380,},
            [-37] = {modifier = 37,  points = -370,},
            [-36] = {modifier = 36,  points = -360,},
            [-35] = {modifier = 35,  points = -350,},
            [-34] = {modifier = 34,  points = -340,},
            [-33] = {modifier = 33,  points = -330,},
            [-32] = {modifier = 32,  points = -320,},
            [-31] = {modifier = 31,  points = -310,},
            [-30] = {modifier = 30,  points = -300,},
            [-29] = {modifier = 29,  points = -290,},
            [-28] = {modifier = 28,  points = -280,},
            [-27] = {modifier = 27,  points = -270,},
            [-26] = {modifier = 26,  points = -260,},
            [-25] = {modifier = 25,  points = -250,},
            [-24] = {modifier = 24,  points = -240,},
            [-23] = {modifier = 23,  points = -230,},
            [-22] = {modifier = 22,  points = -220,},
            [-21] = {modifier = 21,  points = -210,},
            [-20] = {modifier = 20,  points = -200,},
            [-19] = {modifier = 19,  points = -190,},
            [-18] = {modifier = 18,  points = -180,},
            [-17] = {modifier = 17,  points = -170,},
            [-16] = {modifier = 16,  points = -160,},
            [-15] = {modifier = 15,  points = -150,},
            [-14] = {modifier = 14,  points = -140,},
            [-13] = {modifier = 13,  points = -130,},
            [-12] = {modifier = 12,  points = -120,},
            [-11] = {modifier = 11,  points = -110,},
            [-10] = {modifier = 10,  points = -100,},
            [-9]  = {modifier = 9,   points = -90,},
            [-8]  = {modifier = 8,   points = -80,},
            [-7]  = {modifier = 7,   points = -70,},
            [-6]  = {modifier = 6,   points = -60,},
            [-5]  = {modifier = 5,   points = -50,},
            [-4]  = {modifier = 4,   points = -40,},
            [-3]  = {modifier = 3,   points = -30,},
            [-2]  = {modifier = 2,   points = -20,},
            [-1]  = {modifier = 1,   points = -10,},
            [0]   = {modifier = 0,   points = 0,},
            [1]   = {modifier = -1,  points = 10,},
            [2]   = {modifier = -2,  points = 20,},
            [3]   = {modifier = -3,  points = 30,},
            [4]   = {modifier = -4,  points = 40,},
            [5]   = {modifier = -5,  points = 50,},
            [6]   = {modifier = -6,  points = 60,},
            [7]   = {modifier = -7,  points = 70,},
            [8]   = {modifier = -8,  points = 80,},
            [9]   = {modifier = -9,  points = 90,},
            [10]  = {modifier = -10, points = 100,},
            [11]  = {modifier = -11, points = 110,},
            [12]  = {modifier = -12, points = 120,},
            [13]  = {modifier = -13, points = 130,},
            [14]  = {modifier = -14, points = 140,},
            [15]  = {modifier = -15, points = 150,},
            [16]  = {modifier = -16, points = 160,},
            [17]  = {modifier = -17, points = 170,},
            [18]  = {modifier = -18, points = 180,},
            [19]  = {modifier = -19, points = 190,},
            [20]  = {modifier = -20, points = 200,},
            [21]  = {modifier = -21, points = 210,},
            [22]  = {modifier = -22, points = 220,},
            [23]  = {modifier = -23, points = 230,},
            [24]  = {modifier = -24, points = 240,},
            [25]  = {modifier = -25, points = 250,},
            [26]  = {modifier = -26, points = 260,},
            [27]  = {modifier = -27, points = 270,},
            [28]  = {modifier = -28, points = 280,},
            [29]  = {modifier = -29, points = 290,},
            [30]  = {modifier = -30, points = 300,},
            [31]  = {modifier = -31, points = 310,},
            [32]  = {modifier = -32, points = 320,},
            [33]  = {modifier = -33, points = 330,},
            [34]  = {modifier = -34, points = 340,},
            [35]  = {modifier = -35, points = 350,},
            [36]  = {modifier = -36, points = 360,},
            [37]  = {modifier = -37, points = 370,},
            [38]  = {modifier = -38, points = 380,},
            [39]  = {modifier = -39, points = 390,},
            [40]  = {modifier = -40, points = 400,},
            [41]  = {modifier = -41, points = 410,},
            [42]  = {modifier = -42, points = 420,},
            [43]  = {modifier = -43, points = 430,},
            [44]  = {modifier = -44, points = 440,},
            [45]  = {modifier = -45, points = 450,},
            [46]  = {modifier = -46, points = 460,},
            [47]  = {modifier = -47, points = 470,},
            [48]  = {modifier = -48, points = 480,},
            [49]  = {modifier = -49, points = 490,},
            [50]  = {modifier = -50, points = 500,},
        },
    },
}

return GameConstant
