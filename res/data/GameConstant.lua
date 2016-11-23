
local GameConstant = {}

GameConstant.version = "0.1.7.1"

GameConstant.gridSize = {
    width = 72, height = 72
}

GameConstant.indexesForTileOrUnit = {
    {name = "Plain",           firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 1,  },
    {name = "River",           firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 16, },
    {name = "Sea",             firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 47, },
    {name = "Beach",           firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 36, },
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
    {name = "Plasma",          firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 16, },
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
    {name = "GreenPlasma",     firstPlayerIndex = 0, isSamePlayerIndex = true,  shapesCount = 16, },

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
    Beach        = {typeIndex = 4,  shapesCount = 36, framesCount = 8, durationPerFrame = 0.2,    fillsGrid = true,  },
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
    Plasma       = {typeIndex = 15, shapesCount = 16, framesCount = 3, durationPerFrame = 0.1,    fillsGrid = false, },
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
    GreenPlasma  = {typeIndex = 28, shapesCount = 16, framesCount = 3, durationPerFrame = 0.1,    fillsGrid = false, },
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

    ["Ground/AirUnits"] = {
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
    },

    ["DirectUnits"] = {
        "Infantry",
        "Mech",
        "Bike",
        "Recon",
        "Flare",
        "AntiAir",
        "Tank",
        "MediumTank",
        "WarTank",
        "Fighter",
        "Bomber",
        "Duster",
        "BattleCopter",
        "Seaplane",
        "Carrier",
        "Submarine",
        "Cruiser",
        "Gunboat",
    },

    ["IndirectUnits"] = {
        "Artillery",
        "AntiTank",
        "Rockets",
        "Missiles",
        "Battleship",
    },

    ["None"] = {
    },

    ["FootUnits"] = {
        "Infantry",
        "Mech"
    },

    ["InfantryUnits"] = {
        "Infantry",
        "Mech",
        "Bike",
    },

    ["VehicleUnits"] = {
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

    ["DirectMachineUnits"] = {
        "Recon",
        "Flare",
        "AntiAir",
        "Tank",
        "MediumTank",
        "WarTank",
        "Fighter",
        "Bomber",
        "Duster",
        "BattleCopter",
        "Seaplane",
        "Carrier",
        "Submarine",
        "Cruiser",
        "Gunboat",
    },

    ["TransportUnits"] = {
        "Rig",
        "TransportCopter",
        "Lander",
    },

    ["LargeNavalUnits"] = {
        "Battleship",
        "Carrier",
        "Submarine",
        "Cruiser",
    },

    ["CopterUnits"] = {
        "BattleCopter",
        "TransportCopter",
    },

    ["SkillCategoriesForPassive"] = {
        "SkillCategoryPassiveAttack",
        "SkillCategoryPassiveDefense",
        "SkillCategoryPassiveMoney",
        "SkillCategoryPassiveMovement",
        "SkillCategoryPassiveAttackRange",
        "SkillCategoryPassiveCapture",
        "SkillCategoryPassiveRepair",
        "SkillCategoryPassivePromotion",
        "SkillCategoryPassiveEnergy",
        "SkillCategoryPassiveVision",
    },

    ["SkillCategoriesForActive"] = {
        "SkillCategoryActiveAttack",
        "SkillCategoryActiveDefense",
        "SkillCategoryActiveMoney",
        "SkillCategoryActiveMovement",
        "SkillCategoryActiveAttackRange",
        "SkillCategoryActiveCapture",
        "SkillCategoryActiveHP",
        "SkillCategoryActivePromotion",
        "SkillCategoryActiveEnergy",
        "SkillCategoryActiveLogistics",
        "SkillCategoryActiveVision",
    },

    ["SkillCategoryPassiveAttack"] = {
        1,
        20,
        23,
        14,
        25,
        29,
        30,
        31,
        32,
        33,
        34,
        35,
        36,
    },

    ["SkillCategoryActiveAttack"] = {
        1,
        20,
        23,
        14,
        25,
        29,
        30,
        31,
        32,
        33,
        34,
        35,
        36,
    },

    ["SkillCategoryPassiveDefense"] = {
        2,
        21,
        24,
        37,
        38,
        39,
        40,
        41,
        42,
        43,
        44,
        45,
    },

    ["SkillCategoryActiveDefense"] = {
        2,
        21,
        24,
        37,
        38,
        39,
        40,
        41,
        42,
        43,
        44,
        45,
    },

    ["SkillCategoryPassiveMoney"] = {
        3,
        17,
        20,
        21,
        22,
    },

    ["SkillCategoryActiveMoney"] = {
        3,
        12,
        20,
        21,
        22,
    },

    ["SkillCategoryPassiveMovement"] = {
        28,
        54,
    },

    ["SkillCategoryActiveMovement"] = {
        6,
        8,
        28,
        46,
        47,
        48,
        49,
        50,
        51,
        52,
        53,
        54,
    },

    ["SkillCategoryPassiveAttackRange"] = {
        7,
    },

    ["SkillCategoryActiveAttackRange"] = {
        7,
    },

    ["SkillCategoryPassiveCapture"] = {
        15,
    },

    ["SkillCategoryActiveCapture"] = {
        15,
    },

    ["SkillCategoryPassiveRepair"] = {
        10,
        11,
    },

    ["SkillCategoryPassiveEnergy"] = {
        18,
        19,
    },

    ["SkillCategoryActiveEnergy"] = {
        13,
    },

    ["SkillCategoryActiveHP"] = {
        4,
        5,
    },

    ["SkillCategoryPassivePromotion"] = {
        27,
    },

    ["SkillCategoryActivePromotion"] = {
        26,
    },

    ["SkillCategoryActiveLogistics"] = {
        9,
        16,
    },

    ["SkillCategoryPassiveVision"] = {
        55,
        56,
        57,
        58,
        59,
        60,
    },

    ["SkillCategoryActiveVision"] = {
        55,
        56,
        57,
        58,
        59,
        60,
    },
}

GameConstant.maxCapturePoint            = 20
GameConstant.maxBuildPoint              = 20
GameConstant.unitMaxHP                  = 100
GameConstant.tileMaxHP                  = 99
GameConstant.incomePerTurn              = 1000
GameConstant.commandTowerAttackBonus    = 5
GameConstant.commandTowerDefenseBonus   = 5
GameConstant.baseNormalizedRepairAmount = 2

GameConstant.maxPromotion   = 3
GameConstant.promotionBonus = {
    {attack = 5,  defense = 0 },
    {attack = 10, defense = 0 },
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

        UnitHider = {
            targetCategoryType = "GroundUnits",
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

        UnitHider = {
            targetCategoryType = "GroundUnits",
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

        VisionOwner = {
            vision                 = 5,
            isEnabledForAllPlayers = true,
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

        UnitHider = {
            targetCategoryType = "NavalUnits",
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

        UnitHider = {
            targetCategoryType = "NavalUnits",
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

    GreenPlasma = {
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

        VisionOwner = {
            vision                 = 2,
            isEnabledForAllPlayers = false,
        },

        UnitHider = {
            targetCategoryType = "GroundUnits",
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

        VisionOwner = {
            vision                 = 2,
            isEnabledForAllPlayers = false,
        },

        UnitHider = {
            targetCategoryType = "GroundUnits",
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

        VisionOwner = {
            vision                 = 2,
            isEnabledForAllPlayers = false,
        },

        UnitHider = {
            targetCategoryType = "GroundUnits",
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

        VisionOwner = {
            vision                 = 5,
            isEnabledForAllPlayers = false,
        },

        UnitHider = {
            targetCategoryType = "GroundUnits",
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

        VisionOwner = {
            vision                 = 2,
            isEnabledForAllPlayers = false,
        },

        UnitHider = {
            targetCategoryType = "GroundUnits",
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

        VisionOwner = {
            vision                 = 2,
            isEnabledForAllPlayers = false,
        },

        UnitHider = {
            targetCategoryType = "Ground/AirUnits",
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

        VisionOwner = {
            vision                 = 2,
            isEnabledForAllPlayers = false,
        },

        UnitHider = {
            targetCategoryType = "Ground/NavalUnits",
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

        VisionOwner = {
            vision                 = 2,
            isEnabledForAllPlayers = false,
        },

        UnitHider = {
            targetCategoryType = "Ground/AirUnits",
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

        VisionOwner = {
            vision                 = 2,
            isEnabledForAllPlayers = false,
        },

        UnitHider = {
            targetCategoryType = "Ground/NavalUnits",
        },
    },
}

GameConstant.templateModelUnits = {
    Infantry   = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange        = 1,
            maxAttackRange        = 1,
            canAttackAfterMove    = true,
            canAttackDivingTarget = false,

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

        VisionOwner = {
            vision                 = 2,
            isEnabledForAllPlayers = false,
            bonusOnTiles = {
                Mountain = 3,
            },
        },
    },

    Mech       = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange        = 1,
            maxAttackRange        = 1,
            canAttackAfterMove    = true,
            canAttackDivingTarget = false,

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

        VisionOwner = {
            vision                 = 2,
            isEnabledForAllPlayers = false,
            bonusOnTiles = {
                Mountain = 3,
            },
        },
    },

    Bike       = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange        = 1,
            maxAttackRange        = 1,
            canAttackAfterMove    = true,
            canAttackDivingTarget = false,

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

        VisionOwner = {
            vision                 = 2,
            isEnabledForAllPlayers = false,
        },
    },

    Recon      = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange        = 1,
            maxAttackRange        = 1,
            canAttackAfterMove    = true,
            canAttackDivingTarget = false,

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

        VisionOwner = {
            vision                 = 5,
            isEnabledForAllPlayers = false,
        },
    },

    Flare      = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange        = 1,
            maxAttackRange        = 1,
            canAttackAfterMove    = true,
            canAttackDivingTarget = false,

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

        VisionOwner = {
            vision                 = 2,
            isEnabledForAllPlayers = false,
        },

        FlareLauncher = {
            maxAmmo     = 3,
            currentAmmo = 3,
            maxRange    = 5,
            areaRadius  = 2,
        },
    },

    AntiAir    = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange        = 1,
            maxAttackRange        = 1,
            canAttackAfterMove    = true,
            canAttackDivingTarget = false,

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

        VisionOwner = {
            vision                 = 3,
            isEnabledForAllPlayers = false,
        },
    },

    Tank       = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange        = 1,
            maxAttackRange        = 1,
            canAttackAfterMove    = true,
            canAttackDivingTarget = false,

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

        VisionOwner = {
            vision                 = 3,
            isEnabledForAllPlayers = false,
        },
    },

    MediumTank = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange        = 1,
            maxAttackRange        = 1,
            canAttackAfterMove    = true,
            canAttackDivingTarget = false,

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

        VisionOwner = {
            vision                 = 2,
            isEnabledForAllPlayers = false,
        },
    },

    WarTank    = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange        = 1,
            maxAttackRange        = 1,
            canAttackAfterMove    = true,
            canAttackDivingTarget = false,

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

        VisionOwner = {
            vision                 = 2,
            isEnabledForAllPlayers = false,
        },
    },

    Artillery  = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange        = 2,
            maxAttackRange        = 3,
            canAttackAfterMove    = false,
            canAttackDivingTarget = false,

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

        VisionOwner = {
            vision                 = 3,
            isEnabledForAllPlayers = false,
        },
    },

    AntiTank   = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange        = 1,
            maxAttackRange        = 3,
            canAttackAfterMove    = false,
            canAttackDivingTarget = false,

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

        VisionOwner = {
            vision                 = 3,
            isEnabledForAllPlayers = false,
        },
    },

    Rockets    = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange        = 3,
            maxAttackRange        = 5,
            canAttackAfterMove    = false,
            canAttackDivingTarget = false,

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

        VisionOwner = {
            vision                 = 3,
            isEnabledForAllPlayers = false,
        },
    },

    Missiles   = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange        = 3,
            maxAttackRange        = 6,
            canAttackAfterMove    = false,
            canAttackDivingTarget = false,

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

        VisionOwner = {
            vision                 = 5,
            isEnabledForAllPlayers = false,
        },
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
            canRepair          = false,
        },

        UnitSupplier = {},

        MaterialOwner = {
            max     = 1,
            current = 1,
        },

        Promotable = {
            current = 0,
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

        VisionOwner = {
            vision                 = 1,
            isEnabledForAllPlayers = false,
        },
    },

    Fighter    = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange        = 1,
            maxAttackRange        = 1,
            canAttackAfterMove    = true,
            canAttackDivingTarget = false,

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

        VisionOwner = {
            vision                 = 5,
            isEnabledForAllPlayers = false,
        },
    },

    Bomber     = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange        = 1,
            maxAttackRange        = 1,
            canAttackAfterMove    = true,
            canAttackDivingTarget = false,

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

        VisionOwner = {
            vision                 = 3,
            isEnabledForAllPlayers = false,
        },
    },

    Duster     = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange        = 1,
            maxAttackRange        = 1,
            canAttackAfterMove    = true,
            canAttackDivingTarget = false,

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

        VisionOwner = {
            vision                 = 4,
            isEnabledForAllPlayers = false,
        },
    },

    BattleCopter    = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange        = 1,
            maxAttackRange        = 1,
            canAttackAfterMove    = true,
            canAttackDivingTarget = false,

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

        VisionOwner = {
            vision                 = 2,
            isEnabledForAllPlayers = false,
        },
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
            canRepair          = false,
        },

        Promotable = {
            current = 0,
        },

        Producible = {
            productionCost = 5000,
        },

        Joinable = {},

        VisionOwner = {
            vision                 = 1,
            isEnabledForAllPlayers = false,
        },
    },

    Seaplane   = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange        = 1,
            maxAttackRange        = 1,
            canAttackAfterMove    = true,
            canAttackDivingTarget = false,

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

        VisionOwner = {
            vision                 = 4,
            isEnabledForAllPlayers = false,
        },
    },

    Battleship = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange        = 3,
            maxAttackRange        = 5,
            canAttackAfterMove    = true,
            canAttackDivingTarget = false,

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

        VisionOwner = {
            vision                 = 3,
            isEnabledForAllPlayers = false,
        },
    },

    Carrier    = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange        = 1,
            maxAttackRange        = 1,
            canAttackAfterMove    = true,
            canAttackDivingTarget = false,

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
            canRepair          = true,
            repairAmount       = 2,
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

        VisionOwner = {
            vision                 = 4,
            isEnabledForAllPlayers = false,
        },
    },

    Submarine  = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange        = 1,
            maxAttackRange        = 1,
            canAttackAfterMove    = true,
            canAttackDivingTarget = true,

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
            range    = 6,
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

        Diver = {
            isDiving                  = true,
            additionalFuelConsumption = 4,
        },

        Joinable = {},

        VisionOwner = {
            vision                 = 5,
            isEnabledForAllPlayers = false,
        },
    },

    Cruiser    = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange        = 1,
            maxAttackRange        = 1,
            canAttackAfterMove    = true,
            canAttackDivingTarget = true,

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
            canLaunch          = false,
            canDrop            = true,
            canSupply          = true,
            canRepair          = false,
        },

        Producible = {
            productionCost = 16000,
        },

        Joinable = {},

        VisionOwner = {
            vision                 = 5,
            isEnabledForAllPlayers = false,
        },
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
            targetTileTypes    = {
                "Beach",
                "Seaport",
                "TempSeaport",
            },
            canLaunch          = false,
            canDrop            = true,
            canSupply          = false,
            canRepair          = false,
        },

        Promotable = {
            current = 0,
        },

        Producible = {
            productionCost = 10000,
        },

        Joinable = {},

        VisionOwner = {
            vision                 = 1,
            isEnabledForAllPlayers = false,
        },
    },

    Gunboat    = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange        = 1,
            maxAttackRange        = 1,
            canAttackAfterMove    = true,
            canAttackDivingTarget = false,

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
            targetTileTypes    = {
                "Beach",
                "Seaport",
                "TempSeaport",
            },
            canLaunch          = false,
            canDrop            = true,
            canSupply          = false,
            canRepair          = false,
        },

        Promotable = {
            current = 0,
        },

        Producible = {
            productionCost = 6000,
        },

        Joinable = {},

        VisionOwner = {
            vision                 = 2,
            isEnabledForAllPlayers = false,
        },
    },
}

GameConstant.minSkillPoints                  = 0
GameConstant.maxSkillPoints                  = 200
GameConstant.skillPointsPerStep              = 20
GameConstant.minEnergyRequirement            = 1
GameConstant.maxEnergyRequirement            = 15
GameConstant.skillPointsPerEnergyRequirement = 100
GameConstant.damageCostPerEnergyRequirement  = 18000
GameConstant.damageCostGrowthRates           = 20
GameConstant.skillConfigurationsCount        = 10
GameConstant.passiveSkillSlotsCount          = 4
GameConstant.activeSkillSlotsCount           = 4

GameConstant.skills = {
    -- Modify the attack power for all units of a player.
    [1] = {
        minLevelPassive     = -6,
        maxLevelPassive     = 12,
        minLevelActive      = -6,
        maxLevelActive      = 10,
        modifierUnit = "%",
        levels = {
            [-10] = {modifierPassive = -50, modifierActive = -50, pointsPassive = -500, pointsActive = -125, minEnergy = 5},
            [-9] = {modifierPassive = -45, modifierActive = -45, pointsPassive = -450, pointsActive = -112.5, minEnergy = 5},
            [-8] = {modifierPassive = -40, modifierActive = -40, pointsPassive = -400, pointsActive = -100, minEnergy = 4},
            [-7] = {modifierPassive = -35, modifierActive = -35, pointsPassive = -350, pointsActive = -87.5, minEnergy = 4},
            [-6] = {modifierPassive = -30, modifierActive = -30, pointsPassive = -300, pointsActive = -75, minEnergy = 3},
            [-5] = {modifierPassive = -25, modifierActive = -25, pointsPassive = -250, pointsActive = -62.5, minEnergy = 3},
            [-4] = {modifierPassive = -20, modifierActive = -20, pointsPassive = -200, pointsActive = -50, minEnergy = 2},
            [-3] = {modifierPassive = -15, modifierActive = -15, pointsPassive = -150, pointsActive = -37.5, minEnergy = 2},
            [-2] = {modifierPassive = -10, modifierActive = -10, pointsPassive = -100, pointsActive = -25, minEnergy = 1},
            [-1] = {modifierPassive = -5, modifierActive = -5, pointsPassive = -50, pointsActive = -12.5, minEnergy = 1},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 65, pointsActive = 65, minEnergy = 1},
            [2] = {modifierPassive = 10, modifierActive = 10, pointsPassive = 130, pointsActive = 130, minEnergy = 1},
            [3] = {modifierPassive = 15, modifierActive = 15, pointsPassive = 195, pointsActive = 195, minEnergy = 2},
            [4] = {modifierPassive = 20, modifierActive = 20, pointsPassive = 260, pointsActive = 260, minEnergy = 2},
            [5] = {modifierPassive = 25, modifierActive = 25, pointsPassive = 325, pointsActive = 325, minEnergy = 3},
            [6] = {modifierPassive = 30, modifierActive = 30, pointsPassive = 390, pointsActive = 390, minEnergy = 3},
            [7] = {modifierPassive = 35, modifierActive = 35, pointsPassive = 455, pointsActive = 455, minEnergy = 4},
            [8] = {modifierPassive = 40, modifierActive = 40, pointsPassive = 520, pointsActive = 520, minEnergy = 4},
            [9] = {modifierPassive = 45, modifierActive = 45, pointsPassive = 585, pointsActive = 585, minEnergy = 5},
            [10] = {modifierPassive = 50, modifierActive = 50, pointsPassive = 650, pointsActive = 650, minEnergy = 5},
            [11] = {modifierPassive = 55, modifierActive = 55, pointsPassive = 715, pointsActive = 715, minEnergy = 6},
            [12] = {modifierPassive = 60, modifierActive = 60, pointsPassive = 780, pointsActive = 780, minEnergy = 6},
        },
    },

    -- Modify the defense power for all units of a player.
    [2] = {
        minLevelPassive     = -6,
        maxLevelPassive     = 12,
        minLevelActive      = -6,
        maxLevelActive      = 12,
        modifierUnit = "%",
        levels = {
            [-6] = {modifierPassive = -30, modifierActive = -30, pointsPassive = -300, pointsActive = -75, minEnergy = 3},
            [-5] = {modifierPassive = -25, modifierActive = -25, pointsPassive = -250, pointsActive = -62.5, minEnergy = 3},
            [-4] = {modifierPassive = -20, modifierActive = -20, pointsPassive = -200, pointsActive = -50, minEnergy = 2},
            [-3] = {modifierPassive = -15, modifierActive = -15, pointsPassive = -150, pointsActive = -37.5, minEnergy = 2},
            [-2] = {modifierPassive = -10, modifierActive = -10, pointsPassive = -100, pointsActive = -25, minEnergy = 1},
            [-1] = {modifierPassive = -5, modifierActive = -5, pointsPassive = -50, pointsActive = -12.5, minEnergy = 1},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 65, pointsActive = 65, minEnergy = 1},
            [2] = {modifierPassive = 10, modifierActive = 10, pointsPassive = 130, pointsActive = 130, minEnergy = 1},
            [3] = {modifierPassive = 15, modifierActive = 15, pointsPassive = 195, pointsActive = 195, minEnergy = 2},
            [4] = {modifierPassive = 20, modifierActive = 20, pointsPassive = 260, pointsActive = 260, minEnergy = 2},
            [5] = {modifierPassive = 25, modifierActive = 25, pointsPassive = 325, pointsActive = 325, minEnergy = 3},
            [6] = {modifierPassive = 30, modifierActive = 30, pointsPassive = 390, pointsActive = 390, minEnergy = 3},
            [7] = {modifierPassive = 35, modifierActive = 35, pointsPassive = 455, pointsActive = 455, minEnergy = 4},
            [8] = {modifierPassive = 40, modifierActive = 40, pointsPassive = 520, pointsActive = 520, minEnergy = 4},
            [9] = {modifierPassive = 45, modifierActive = 45, pointsPassive = 585, pointsActive = 585, minEnergy = 5},
            [10] = {modifierPassive = 50, modifierActive = 50, pointsPassive = 650, pointsActive = 650, minEnergy = 5},
            [11] = {modifierPassive = 55, modifierActive = 55, pointsPassive = 715, pointsActive = 715, minEnergy = 6},
            [12] = {modifierPassive = 60, modifierActive = 60, pointsPassive = 780, pointsActive = 780, minEnergy = 6},
        },
    },

    -- Modify the production cost for all units of a player.
    [3] = {
        minLevelPassive     = -6,
        maxLevelPassive     = 20,
        minLevelActive      = -6,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels = {
            [-6] = {modifierPassive = 30, modifierActive = 30, pointsPassive = -450, pointsActive = -15, minEnergy = 2},
            [-5] = {modifierPassive = 25, modifierActive = 25, pointsPassive = -375, pointsActive = -12.5, minEnergy = 2},
            [-4] = {modifierPassive = 20, modifierActive = 20, pointsPassive = -300, pointsActive = -10, minEnergy = 1},
            [-3] = {modifierPassive = 15, modifierActive = 15, pointsPassive = -225, pointsActive = -7.5, minEnergy = 1},
            [-2] = {modifierPassive = 10, modifierActive = 10, pointsPassive = -150, pointsActive = -5, minEnergy = 1},
            [-1] = {modifierPassive = 5, modifierActive = 5, pointsPassive = -75, pointsActive = -2.5, minEnergy = 1},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = -5, modifierActive = -5, pointsPassive = 95, pointsActive = 25, minEnergy = 1},
            [2] = {modifierPassive = -10, modifierActive = -10, pointsPassive = 190, pointsActive = 50, minEnergy = 1},
            [3] = {modifierPassive = -15, modifierActive = -15, pointsPassive = 285, pointsActive = 75, minEnergy = 1},
            [4] = {modifierPassive = -20, modifierActive = -20, pointsPassive = 380, pointsActive = 100, minEnergy = 1},
            [5] = {modifierPassive = -25, modifierActive = -25, pointsPassive = 475, pointsActive = 125, minEnergy = 2},
            [6] = {modifierPassive = -30, modifierActive = -30, pointsPassive = 570, pointsActive = 150, minEnergy = 2},
            [7] = {modifierPassive = -35, modifierActive = -35, pointsPassive = 665, pointsActive = 175, minEnergy = 2},
            [8] = {modifierPassive = -40, modifierActive = -40, pointsPassive = 760, pointsActive = 200, minEnergy = 2},
            [9] = {modifierPassive = -45, modifierActive = -45, pointsPassive = 855, pointsActive = 225, minEnergy = 3},
            [10] = {modifierPassive = -50, modifierActive = -50, pointsPassive = 950, pointsActive = 250, minEnergy = 3},
            [11] = {modifierPassive = -55, modifierActive = -55, pointsPassive = 1045, pointsActive = 275, minEnergy = 3},
            [12] = {modifierPassive = -60, modifierActive = -60, pointsPassive = 1140, pointsActive = 300, minEnergy = 3},
            [13] = {modifierPassive = -65, modifierActive = -65, pointsPassive = 1235, pointsActive = 325, minEnergy = 4},
            [14] = {modifierPassive = -70, modifierActive = -70, pointsPassive = 1330, pointsActive = 350, minEnergy = 4},
            [15] = {modifierPassive = -75, modifierActive = -75, pointsPassive = 1425, pointsActive = 375, minEnergy = 4},
            [16] = {modifierPassive = -80, modifierActive = -80, pointsPassive = 1520, pointsActive = 400, minEnergy = 4},
            [17] = {modifierPassive = -85, modifierActive = -85, pointsPassive = 1615, pointsActive = 425, minEnergy = 5},
            [18] = {modifierPassive = -90, modifierActive = -90, pointsPassive = 1710, pointsActive = 450, minEnergy = 5},
            [19] = {modifierPassive = -95, modifierActive = -95, pointsPassive = 1805, pointsActive = 475, minEnergy = 5},
            [20] = {modifierPassive = -100, modifierActive = -100, pointsPassive = 1900, pointsActive = 500, minEnergy = 5},
        },
    },

    -- Instant: Modify HPs of all units of the currently-in-turn player.
    [4] = {
        minLevelActive      = -9,
        maxLevelActive      = 9,
        modifierUnit = "HP",
        levels = {
            [-9] = {modifierPassive = nil, modifierActive = -9, pointsPassive = nil, pointsActive = -540, minEnergy = 9},
            [-8] = {modifierPassive = nil, modifierActive = -8, pointsPassive = nil, pointsActive = -500, minEnergy = 8},
            [-7] = {modifierPassive = nil, modifierActive = -7, pointsPassive = nil, pointsActive = -455, minEnergy = 7},
            [-6] = {modifierPassive = nil, modifierActive = -6, pointsPassive = nil, pointsActive = -405, minEnergy = 6},
            [-5] = {modifierPassive = nil, modifierActive = -5, pointsPassive = nil, pointsActive = -350, minEnergy = 5},
            [-4] = {modifierPassive = nil, modifierActive = -4, pointsPassive = nil, pointsActive = -290, minEnergy = 4},
            [-3] = {modifierPassive = nil, modifierActive = -3, pointsPassive = nil, pointsActive = -225, minEnergy = 3},
            [-2] = {modifierPassive = nil, modifierActive = -2, pointsPassive = nil, pointsActive = -155, minEnergy = 2},
            [-1] = {modifierPassive = nil, modifierActive = -1, pointsPassive = nil, pointsActive = -80, minEnergy = 1},
            [0] = {modifierPassive = nil, modifierActive = 0, pointsPassive = nil, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = nil, modifierActive = 1, pointsPassive = nil, pointsActive = 130, minEnergy = 1},
            [2] = {modifierPassive = nil, modifierActive = 2, pointsPassive = nil, pointsActive = 250, minEnergy = 2},
            [3] = {modifierPassive = nil, modifierActive = 3, pointsPassive = nil, pointsActive = 360, minEnergy = 3},
            [4] = {modifierPassive = nil, modifierActive = 4, pointsPassive = nil, pointsActive = 460, minEnergy = 4},
            [5] = {modifierPassive = nil, modifierActive = 5, pointsPassive = nil, pointsActive = 550, minEnergy = 5},
            [6] = {modifierPassive = nil, modifierActive = 6, pointsPassive = nil, pointsActive = 630, minEnergy = 6},
            [7] = {modifierPassive = nil, modifierActive = 7, pointsPassive = nil, pointsActive = 700, minEnergy = 7},
            [8] = {modifierPassive = nil, modifierActive = 8, pointsPassive = nil, pointsActive = 760, minEnergy = 8},
            [9] = {modifierPassive = nil, modifierActive = 9, pointsPassive = nil, pointsActive = 810, minEnergy = 9},
        },
    },

    -- Instant: Modify HPs of all units of the opponents.
    [5] = {
        minLevelActive     = -9,
        maxLevelActive     = 9,
        modifierUnit = "HP",
        levels = {
            [-9] = {modifierPassive = nil, modifierActive = 9, pointsPassive = nil, pointsActive = -270, minEnergy = 9},
            [-8] = {modifierPassive = nil, modifierActive = 8, pointsPassive = nil, pointsActive = -260, minEnergy = 8},
            [-7] = {modifierPassive = nil, modifierActive = 7, pointsPassive = nil, pointsActive = -245, minEnergy = 7},
            [-6] = {modifierPassive = nil, modifierActive = 6, pointsPassive = nil, pointsActive = -225, minEnergy = 6},
            [-5] = {modifierPassive = nil, modifierActive = 5, pointsPassive = nil, pointsActive = -200, minEnergy = 5},
            [-4] = {modifierPassive = nil, modifierActive = 4, pointsPassive = nil, pointsActive = -170, minEnergy = 4},
            [-3] = {modifierPassive = nil, modifierActive = 3, pointsPassive = nil, pointsActive = -135, minEnergy = 3},
            [-2] = {modifierPassive = nil, modifierActive = 2, pointsPassive = nil, pointsActive = -95, minEnergy = 2},
            [-1] = {modifierPassive = nil, modifierActive = 1, pointsPassive = nil, pointsActive = -50, minEnergy = 1},
            [0] = {modifierPassive = nil, modifierActive = 0, pointsPassive = nil, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = nil, modifierActive = -1, pointsPassive = nil, pointsActive = 375, minEnergy = 3},
            [2] = {modifierPassive = nil, modifierActive = -2, pointsPassive = nil, pointsActive = 725, minEnergy = 6},
            [3] = {modifierPassive = nil, modifierActive = -3, pointsPassive = nil, pointsActive = 1050, minEnergy = 9},
            [4] = {modifierPassive = nil, modifierActive = -4, pointsPassive = nil, pointsActive = 1350, minEnergy = 12},
            [5] = {modifierPassive = nil, modifierActive = -5, pointsPassive = nil, pointsActive = 1625, minEnergy = 15},
            [6] = {modifierPassive = nil, modifierActive = -6, pointsPassive = nil, pointsActive = 1875, minEnergy = 18},
            [7] = {modifierPassive = nil, modifierActive = -7, pointsPassive = nil, pointsActive = 2100, minEnergy = 21},
            [8] = {modifierPassive = nil, modifierActive = -8, pointsPassive = nil, pointsActive = 2300, minEnergy = 24},
            [9] = {modifierPassive = nil, modifierActive = -9, pointsPassive = nil, pointsActive = 2475, minEnergy = 27},
        },
    },

    -- Modify movements of all units of the owner player.
    [6] = {
        minLevelActive     = 1,
        maxLevelActive     = 5,
        modifierUnit = "",
        levels = {
            [1] = {modifierPassive = nil, modifierActive = 1, pointsPassive = nil, pointsActive = 190, minEnergy = 2},
            [2] = {modifierPassive = nil, modifierActive = 2, pointsPassive = nil, pointsActive = 380, minEnergy = 4},
            [3] = {modifierPassive = nil, modifierActive = 3, pointsPassive = nil, pointsActive = 570, minEnergy = 6},
            [4] = {modifierPassive = nil, modifierActive = 4, pointsPassive = nil, pointsActive = 760, minEnergy = 8},
            [5] = {modifierPassive = nil, modifierActive = 5, pointsPassive = nil, pointsActive = 950, minEnergy = 10},
        },
    },

    -- Modify max attack range of all indirect units of the owner player.
    [7] = {
        minLevelPassive     = -1,
        maxLevelPassive     = 3,
        minLevelActive      = -1,
        maxLevelActive      = 3,
        modifierUnit = "",
        levels = {
            [-1] = {modifierPassive = -1, modifierActive = -1, pointsPassive = -80, pointsActive = -20, minEnergy = 3},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 1, modifierActive = 1, pointsPassive = 300, pointsActive = 200, minEnergy = 3},
            [2] = {modifierPassive = 2, modifierActive = 2, pointsPassive = 600, pointsActive = 400, minEnergy = 6},
            [3] = {modifierPassive = 3, modifierActive = 3, pointsPassive = 900, pointsActive = 600, minEnergy = 9},
        },
    },

    -- Instant: Set all units, except inf units (Infantry, Mech, Bike), as idle (i.e. move again).
    [8] = {
        minLevelActive     = 1,
        maxLevelActive     = 1,
        modifierUnit = "",
        levels       = {
            [1] = {modifierPassive = nil, modifierActive = nil, pointsPassive = nil, pointsActive = 850, minEnergy = 8},
        },
    },

    -- Instant: Modify the fuel of the opponents' units.
    [9] = {
        minLevelActive     = 1,
        maxLevelActive     = 10,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = nil, modifierActive = -50, pointsPassive = nil, pointsActive = 60, minEnergy = 1},
            [2] = {modifierPassive = nil, modifierActive = -100, pointsPassive = nil, pointsActive = 120, minEnergy = 2},
            [3] = {modifierPassive = nil, modifierActive = -150, pointsPassive = nil, pointsActive = 180, minEnergy = 3},
            [4] = {modifierPassive = nil, modifierActive = -200, pointsPassive = nil, pointsActive = 240, minEnergy = 4},
            [5] = {modifierPassive = nil, modifierActive = -250, pointsPassive = nil, pointsActive = 300, minEnergy = 5},
            [6] = {modifierPassive = nil, modifierActive = -300, pointsPassive = nil, pointsActive = 360, minEnergy = 6},
            [7] = {modifierPassive = nil, modifierActive = -350, pointsPassive = nil, pointsActive = 420, minEnergy = 7},
            [8] = {modifierPassive = nil, modifierActive = -400, pointsPassive = nil, pointsActive = 480, minEnergy = 8},
            [9] = {modifierPassive = nil, modifierActive = -450, pointsPassive = nil, pointsActive = 540, minEnergy = 9},
            [10] = {modifierPassive = nil, modifierActive = -500, pointsPassive = nil, pointsActive = 600, minEnergy = 10},
        },
    },

    -- Modify the repair amount of buildings of the owner player.
    [10] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 7,
        modifierUnit = "HP",
        levels       = {
            [1] = {modifierPassive = 1, modifierActive = nil, pointsPassive = 35, pointsActive = nil, minEnergy = nil},
            [2] = {modifierPassive = 2, modifierActive = nil, pointsPassive = 65, pointsActive = nil, minEnergy = nil},
            [3] = {modifierPassive = 3, modifierActive = nil, pointsPassive = 90, pointsActive = nil, minEnergy = nil},
            [4] = {modifierPassive = 4, modifierActive = nil, pointsPassive = 110, pointsActive = nil, minEnergy = nil},
            [5] = {modifierPassive = 5, modifierActive = nil, pointsPassive = 125, pointsActive = nil, minEnergy = nil},
            [6] = {modifierPassive = 6, modifierActive = nil, pointsPassive = 135, pointsActive = nil, minEnergy = nil},
            [7] = {modifierPassive = 7, modifierActive = nil, pointsPassive = 140, pointsActive = nil, minEnergy = nil},
        },
    },

    -- Modify the repair cost of the owner player.
    [11] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 10,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = -10, modifierActive = nil, pointsPassive = 10, pointsActive = nil, minEnergy = nil},
            [2] = {modifierPassive = -20, modifierActive = nil, pointsPassive = 20, pointsActive = nil, minEnergy = nil},
            [3] = {modifierPassive = -30, modifierActive = nil, pointsPassive = 30, pointsActive = nil, minEnergy = nil},
            [4] = {modifierPassive = -40, modifierActive = nil, pointsPassive = 40, pointsActive = nil, minEnergy = nil},
            [5] = {modifierPassive = -50, modifierActive = nil, pointsPassive = 50, pointsActive = nil, minEnergy = nil},
            [6] = {modifierPassive = -60, modifierActive = nil, pointsPassive = 60, pointsActive = nil, minEnergy = nil},
            [7] = {modifierPassive = -70, modifierActive = nil, pointsPassive = 70, pointsActive = nil, minEnergy = nil},
            [8] = {modifierPassive = -80, modifierActive = nil, pointsPassive = 80, pointsActive = nil, minEnergy = nil},
            [9] = {modifierPassive = -90, modifierActive = nil, pointsPassive = 90, pointsActive = nil, minEnergy = nil},
            [10] = {modifierPassive = -100, modifierActive = nil, pointsPassive = 100, pointsActive = nil, minEnergy = nil},
        },
    },

    -- Instant: Modify the fund of the owner player.
    [12] = {
        minLevelActive     = 1,
        maxLevelActive     = 20,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = nil, modifierActive = 10, pointsPassive = nil, pointsActive = 75, minEnergy = 1},
            [2] = {modifierPassive = nil, modifierActive = 20, pointsPassive = nil, pointsActive = 150, minEnergy = 1},
            [3] = {modifierPassive = nil, modifierActive = 30, pointsPassive = nil, pointsActive = 225, minEnergy = 2},
            [4] = {modifierPassive = nil, modifierActive = 40, pointsPassive = nil, pointsActive = 300, minEnergy = 2},
            [5] = {modifierPassive = nil, modifierActive = 50, pointsPassive = nil, pointsActive = 375, minEnergy = 3},
            [6] = {modifierPassive = nil, modifierActive = 60, pointsPassive = nil, pointsActive = 450, minEnergy = 3},
            [7] = {modifierPassive = nil, modifierActive = 70, pointsPassive = nil, pointsActive = 525, minEnergy = 4},
            [8] = {modifierPassive = nil, modifierActive = 80, pointsPassive = nil, pointsActive = 600, minEnergy = 4},
            [9] = {modifierPassive = nil, modifierActive = 90, pointsPassive = nil, pointsActive = 675, minEnergy = 5},
            [10] = {modifierPassive = nil, modifierActive = 100, pointsPassive = nil, pointsActive = 750, minEnergy = 5},
            [11] = {modifierPassive = nil, modifierActive = 110, pointsPassive = nil, pointsActive = 825, minEnergy = 6},
            [12] = {modifierPassive = nil, modifierActive = 120, pointsPassive = nil, pointsActive = 900, minEnergy = 6},
            [13] = {modifierPassive = nil, modifierActive = 130, pointsPassive = nil, pointsActive = 975, minEnergy = 7},
            [14] = {modifierPassive = nil, modifierActive = 140, pointsPassive = nil, pointsActive = 1050, minEnergy = 7},
            [15] = {modifierPassive = nil, modifierActive = 150, pointsPassive = nil, pointsActive = 1125, minEnergy = 8},
            [16] = {modifierPassive = nil, modifierActive = 160, pointsPassive = nil, pointsActive = 1200, minEnergy = 8},
            [17] = {modifierPassive = nil, modifierActive = 170, pointsPassive = nil, pointsActive = 1275, minEnergy = 9},
            [18] = {modifierPassive = nil, modifierActive = 180, pointsPassive = nil, pointsActive = 1350, minEnergy = 9},
            [19] = {modifierPassive = nil, modifierActive = 190, pointsPassive = nil, pointsActive = 1425, minEnergy = 10},
            [20] = {modifierPassive = nil, modifierActive = 200, pointsPassive = nil, pointsActive = 1500, minEnergy = 10},
        },
    },

    -- Instant: Modify the energy of the opponent player.
    [13] = {
        minLevelActive     = -10,
        maxLevelActive     = 10,
        modifierUnit = "%",
        levels       = {
            [-10] = {modifierPassive = nil, modifierActive = 50, pointsPassive = nil, pointsActive = -50, minEnergy = 4},
            [-9] = {modifierPassive = nil, modifierActive = 45, pointsPassive = nil, pointsActive = -45, minEnergy = 3},
            [-8] = {modifierPassive = nil, modifierActive = 40, pointsPassive = nil, pointsActive = -40, minEnergy = 3},
            [-7] = {modifierPassive = nil, modifierActive = 35, pointsPassive = nil, pointsActive = -35, minEnergy = 3},
            [-6] = {modifierPassive = nil, modifierActive = 30, pointsPassive = nil, pointsActive = -30, minEnergy = 2},
            [-5] = {modifierPassive = nil, modifierActive = 25, pointsPassive = nil, pointsActive = -25, minEnergy = 2},
            [-4] = {modifierPassive = nil, modifierActive = 20, pointsPassive = nil, pointsActive = -20, minEnergy = 2},
            [-3] = {modifierPassive = nil, modifierActive = 15, pointsPassive = nil, pointsActive = -15, minEnergy = 1},
            [-2] = {modifierPassive = nil, modifierActive = 10, pointsPassive = nil, pointsActive = -10, minEnergy = 1},
            [-1] = {modifierPassive = nil, modifierActive = 5, pointsPassive = nil, pointsActive = -5, minEnergy = 1},
            [0] = {modifierPassive = nil, modifierActive = 0, pointsPassive = nil, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = nil, modifierActive = -5, pointsPassive = nil, pointsActive = 65, minEnergy = 1},
            [2] = {modifierPassive = nil, modifierActive = -10, pointsPassive = nil, pointsActive = 130, minEnergy = 1},
            [3] = {modifierPassive = nil, modifierActive = -15, pointsPassive = nil, pointsActive = 195, minEnergy = 1},
            [4] = {modifierPassive = nil, modifierActive = -20, pointsPassive = nil, pointsActive = 260, minEnergy = 2},
            [5] = {modifierPassive = nil, modifierActive = -25, pointsPassive = nil, pointsActive = 325, minEnergy = 2},
            [6] = {modifierPassive = nil, modifierActive = -30, pointsPassive = nil, pointsActive = 390, minEnergy = 2},
            [7] = {modifierPassive = nil, modifierActive = -35, pointsPassive = nil, pointsActive = 455, minEnergy = 3},
            [8] = {modifierPassive = nil, modifierActive = -40, pointsPassive = nil, pointsActive = 520, minEnergy = 3},
            [9] = {modifierPassive = nil, modifierActive = -45, pointsPassive = nil, pointsActive = 585, minEnergy = 3},
            [10] = {modifierPassive = nil, modifierActive = -50, pointsPassive = nil, pointsActive = 650, minEnergy = 4},
        },
    },

    -- Modify the upper limit of the luck damage of the owner player.
    [14] = {
        minLevelPassive = 1,
        maxLevelPassive = 20,
        minLevelActive  = 1,
        maxLevelActive  = 20,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 80, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 10, modifierActive = 10, pointsPassive = 160, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 15, modifierActive = 15, pointsPassive = 240, pointsActive = 150, minEnergy = 1},
            [4] = {modifierPassive = 20, modifierActive = 20, pointsPassive = 320, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 25, modifierActive = 25, pointsPassive = 400, pointsActive = 250, minEnergy = 2},
            [6] = {modifierPassive = 30, modifierActive = 30, pointsPassive = 480, pointsActive = 300, minEnergy = 2},
            [7] = {modifierPassive = 35, modifierActive = 35, pointsPassive = 560, pointsActive = 350, minEnergy = 3},
            [8] = {modifierPassive = 40, modifierActive = 40, pointsPassive = 640, pointsActive = 400, minEnergy = 3},
            [9] = {modifierPassive = 45, modifierActive = 45, pointsPassive = 720, pointsActive = 450, minEnergy = 3},
            [10] = {modifierPassive = 50, modifierActive = 50, pointsPassive = 800, pointsActive = 500, minEnergy = 4},
            [11] = {modifierPassive = 55, modifierActive = 55, pointsPassive = 880, pointsActive = 550, minEnergy = 4},
            [12] = {modifierPassive = 60, modifierActive = 60, pointsPassive = 960, pointsActive = 600, minEnergy = 4},
            [13] = {modifierPassive = 65, modifierActive = 65, pointsPassive = 1040, pointsActive = 650, minEnergy = 5},
            [14] = {modifierPassive = 70, modifierActive = 70, pointsPassive = 1120, pointsActive = 700, minEnergy = 5},
            [15] = {modifierPassive = 75, modifierActive = 75, pointsPassive = 1200, pointsActive = 750, minEnergy = 5},
            [16] = {modifierPassive = 80, modifierActive = 80, pointsPassive = 1280, pointsActive = 800, minEnergy = 6},
            [17] = {modifierPassive = 85, modifierActive = 85, pointsPassive = 1360, pointsActive = 850, minEnergy = 6},
            [18] = {modifierPassive = 90, modifierActive = 90, pointsPassive = 1440, pointsActive = 900, minEnergy = 6},
            [19] = {modifierPassive = 95, modifierActive = 95, pointsPassive = 1520, pointsActive = 950, minEnergy = 7},
            [20] = {modifierPassive = 100, modifierActive = 100, pointsPassive = 1600, pointsActive = 1000, minEnergy = 7},
        },
    },

    -- Modify the capture speed of the owner player.
    [15] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 11,
        minLevelActive      = 1,
        maxLevelActive      = 11,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = 10, modifierActive = 10, pointsPassive = 25, pointsActive = 12.5, minEnergy = 1},
            [2] = {modifierPassive = 20, modifierActive = 20, pointsPassive = 50, pointsActive = 25, minEnergy = 1},
            [3] = {modifierPassive = 30, modifierActive = 30, pointsPassive = 75, pointsActive = 37.5, minEnergy = 2},
            [4] = {modifierPassive = 40, modifierActive = 40, pointsPassive = 100, pointsActive = 50, minEnergy = 2},
            [5] = {modifierPassive = 50, modifierActive = 50, pointsPassive = 125, pointsActive = 62.5, minEnergy = 3},
            [6] = {modifierPassive = 60, modifierActive = 60, pointsPassive = 150, pointsActive = 75, minEnergy = 3},
            [7] = {modifierPassive = 70, modifierActive = 70, pointsPassive = 175, pointsActive = 87.5, minEnergy = 4},
            [8] = {modifierPassive = 80, modifierActive = 80, pointsPassive = 200, pointsActive = 100, minEnergy = 4},
            [9] = {modifierPassive = 90, modifierActive = 90, pointsPassive = 225, pointsActive = 112.5, minEnergy = 5},
            [10] = {modifierPassive = 100, modifierActive = 100, pointsPassive = 900, pointsActive = 300, minEnergy = 6},
            [11] = {modifierPassive = 2000, modifierActive = 2000, pointsPassive = 1500, pointsActive = 450, minEnergy = 8},
        },
    },

    -- Instant: Fills the ammo, fuel, material of all units of the owner player.
    [16] = {
        minLevelActive     = 1,
        maxLevelActive     = 1,
        modifierUnit = "",
        levels       = {
            [1] = {modifierPassive = nil, modifierActive = nil, pointsPassive = nil, pointsActive = 150, minEnergy = 3},
        }
    },

    -- Modify the income of the owner player.
    [17] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 20,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = 5, modifierActive = nil, pointsPassive = 100, pointsActive = nil, minEnergy = nil},
            [2] = {modifierPassive = 10, modifierActive = nil, pointsPassive = 200, pointsActive = nil, minEnergy = nil},
            [3] = {modifierPassive = 15, modifierActive = nil, pointsPassive = 300, pointsActive = nil, minEnergy = nil},
            [4] = {modifierPassive = 20, modifierActive = nil, pointsPassive = 400, pointsActive = nil, minEnergy = nil},
            [5] = {modifierPassive = 25, modifierActive = nil, pointsPassive = 500, pointsActive = nil, minEnergy = nil},
            [6] = {modifierPassive = 30, modifierActive = nil, pointsPassive = 600, pointsActive = nil, minEnergy = nil},
            [7] = {modifierPassive = 35, modifierActive = nil, pointsPassive = 700, pointsActive = nil, minEnergy = nil},
            [8] = {modifierPassive = 40, modifierActive = nil, pointsPassive = 800, pointsActive = nil, minEnergy = nil},
            [9] = {modifierPassive = 45, modifierActive = nil, pointsPassive = 900, pointsActive = nil, minEnergy = nil},
            [10] = {modifierPassive = 50, modifierActive = nil, pointsPassive = 1000, pointsActive = nil, minEnergy = nil},
            [11] = {modifierPassive = 55, modifierActive = nil, pointsPassive = 1100, pointsActive = nil, minEnergy = nil},
            [12] = {modifierPassive = 60, modifierActive = nil, pointsPassive = 1200, pointsActive = nil, minEnergy = nil},
            [13] = {modifierPassive = 65, modifierActive = nil, pointsPassive = 1300, pointsActive = nil, minEnergy = nil},
            [14] = {modifierPassive = 70, modifierActive = nil, pointsPassive = 1400, pointsActive = nil, minEnergy = nil},
            [15] = {modifierPassive = 75, modifierActive = nil, pointsPassive = 1500, pointsActive = nil, minEnergy = nil},
            [16] = {modifierPassive = 80, modifierActive = nil, pointsPassive = 1600, pointsActive = nil, minEnergy = nil},
            [17] = {modifierPassive = 85, modifierActive = nil, pointsPassive = 1700, pointsActive = nil, minEnergy = nil},
            [18] = {modifierPassive = 90, modifierActive = nil, pointsPassive = 1800, pointsActive = nil, minEnergy = nil},
            [19] = {modifierPassive = 95, modifierActive = nil, pointsPassive = 1900, pointsActive = nil, minEnergy = nil},
            [20] = {modifierPassive = 100, modifierActive = nil, pointsPassive = 2000, pointsActive = nil, minEnergy = nil},
        },
    },

    -- Stop the damage cost per the energy requirement from increasing as skills are activated.
    [18] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 1,
        modifierUnit = "",
        levels       = {
            [1] = {modifierPassive = nil, modifierActive = nil, pointsPassive = 130, pointsActive = nil, minEnergy = nil},
        },
    },

    -- Modify the growth rate of the energy of the owner player.
    [19] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 10,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = 10, modifierActive = nil, pointsPassive = 40, pointsActive = nil, minEnergy = nil},
            [2] = {modifierPassive = 20, modifierActive = nil, pointsPassive = 80, pointsActive = nil, minEnergy = nil},
            [3] = {modifierPassive = 30, modifierActive = nil, pointsPassive = 120, pointsActive = nil, minEnergy = nil},
            [4] = {modifierPassive = 40, modifierActive = nil, pointsPassive = 160, pointsActive = nil, minEnergy = nil},
            [5] = {modifierPassive = 50, modifierActive = nil, pointsPassive = 200, pointsActive = nil, minEnergy = nil},
            [6] = {modifierPassive = 60, modifierActive = nil, pointsPassive = 240, pointsActive = nil, minEnergy = nil},
            [7] = {modifierPassive = 70, modifierActive = nil, pointsPassive = 280, pointsActive = nil, minEnergy = nil},
            [8] = {modifierPassive = 80, modifierActive = nil, pointsPassive = 320, pointsActive = nil, minEnergy = nil},
            [9] = {modifierPassive = 90, modifierActive = nil, pointsPassive = 360, pointsActive = nil, minEnergy = nil},
            [10] = {modifierPassive = 100, modifierActive = nil, pointsPassive = 400, pointsActive = nil, minEnergy = nil},
        },
    },

    -- Modify the attack power regarding to money of the owner player.
    [20] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 20,
        minLevelActive      = 1,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = 2, modifierActive = 2, pointsPassive = 65, pointsActive = 40, minEnergy = 1},
            [2] = {modifierPassive = 4, modifierActive = 4, pointsPassive = 130, pointsActive = 80, minEnergy = 1},
            [3] = {modifierPassive = 6, modifierActive = 6, pointsPassive = 195, pointsActive = 120, minEnergy = 1},
            [4] = {modifierPassive = 8, modifierActive = 8, pointsPassive = 260, pointsActive = 160, minEnergy = 2},
            [5] = {modifierPassive = 10, modifierActive = 10, pointsPassive = 325, pointsActive = 200, minEnergy = 2},
            [6] = {modifierPassive = 12, modifierActive = 12, pointsPassive = 390, pointsActive = 240, minEnergy = 2},
            [7] = {modifierPassive = 14, modifierActive = 14, pointsPassive = 455, pointsActive = 280, minEnergy = 3},
            [8] = {modifierPassive = 16, modifierActive = 16, pointsPassive = 520, pointsActive = 320, minEnergy = 3},
            [9] = {modifierPassive = 18, modifierActive = 18, pointsPassive = 585, pointsActive = 360, minEnergy = 3},
            [10] = {modifierPassive = 20, modifierActive = 20, pointsPassive = 650, pointsActive = 400, minEnergy = 4},
            [11] = {modifierPassive = 22, modifierActive = 22, pointsPassive = 715, pointsActive = 440, minEnergy = 4},
            [12] = {modifierPassive = 24, modifierActive = 24, pointsPassive = 780, pointsActive = 480, minEnergy = 4},
            [13] = {modifierPassive = 26, modifierActive = 26, pointsPassive = 845, pointsActive = 520, minEnergy = 5},
            [14] = {modifierPassive = 28, modifierActive = 28, pointsPassive = 910, pointsActive = 560, minEnergy = 5},
            [15] = {modifierPassive = 30, modifierActive = 30, pointsPassive = 975, pointsActive = 600, minEnergy = 5},
            [16] = {modifierPassive = 32, modifierActive = 32, pointsPassive = 1040, pointsActive = 640, minEnergy = 6},
            [17] = {modifierPassive = 34, modifierActive = 34, pointsPassive = 1105, pointsActive = 680, minEnergy = 6},
            [18] = {modifierPassive = 36, modifierActive = 36, pointsPassive = 1170, pointsActive = 720, minEnergy = 6},
            [19] = {modifierPassive = 38, modifierActive = 38, pointsPassive = 1235, pointsActive = 760, minEnergy = 7},
            [20] = {modifierPassive = 40, modifierActive = 40, pointsPassive = 1300, pointsActive = 800, minEnergy = 7},
        },
    },

    -- Modify the defense power regarding to money of the owner player.
    [21] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 20,
        minLevelActive      = 1,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = 2, modifierActive = 2, pointsPassive = 65, pointsActive = 40, minEnergy = 1},
            [2] = {modifierPassive = 4, modifierActive = 4, pointsPassive = 130, pointsActive = 80, minEnergy = 1},
            [3] = {modifierPassive = 6, modifierActive = 6, pointsPassive = 195, pointsActive = 120, minEnergy = 1},
            [4] = {modifierPassive = 8, modifierActive = 8, pointsPassive = 260, pointsActive = 160, minEnergy = 2},
            [5] = {modifierPassive = 10, modifierActive = 10, pointsPassive = 325, pointsActive = 200, minEnergy = 2},
            [6] = {modifierPassive = 12, modifierActive = 12, pointsPassive = 390, pointsActive = 240, minEnergy = 2},
            [7] = {modifierPassive = 14, modifierActive = 14, pointsPassive = 455, pointsActive = 280, minEnergy = 3},
            [8] = {modifierPassive = 16, modifierActive = 16, pointsPassive = 520, pointsActive = 320, minEnergy = 3},
            [9] = {modifierPassive = 18, modifierActive = 18, pointsPassive = 585, pointsActive = 360, minEnergy = 3},
            [10] = {modifierPassive = 20, modifierActive = 20, pointsPassive = 650, pointsActive = 400, minEnergy = 4},
            [11] = {modifierPassive = 22, modifierActive = 22, pointsPassive = 715, pointsActive = 440, minEnergy = 4},
            [12] = {modifierPassive = 24, modifierActive = 24, pointsPassive = 780, pointsActive = 480, minEnergy = 4},
            [13] = {modifierPassive = 26, modifierActive = 26, pointsPassive = 845, pointsActive = 520, minEnergy = 5},
            [14] = {modifierPassive = 28, modifierActive = 28, pointsPassive = 910, pointsActive = 560, minEnergy = 5},
            [15] = {modifierPassive = 30, modifierActive = 30, pointsPassive = 975, pointsActive = 600, minEnergy = 5},
            [16] = {modifierPassive = 32, modifierActive = 32, pointsPassive = 1040, pointsActive = 640, minEnergy = 6},
            [17] = {modifierPassive = 34, modifierActive = 34, pointsPassive = 1105, pointsActive = 680, minEnergy = 6},
            [18] = {modifierPassive = 36, modifierActive = 36, pointsPassive = 1170, pointsActive = 720, minEnergy = 6},
            [19] = {modifierPassive = 38, modifierActive = 38, pointsPassive = 1235, pointsActive = 760, minEnergy = 7},
            [20] = {modifierPassive = 40, modifierActive = 40, pointsPassive = 1300, pointsActive = 800, minEnergy = 7},
        },
    },

    -- Get money according to the base damage cost that the owner player deal to the opponent with units' attack.
    [22] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 20,
        minLevelActive      = 1,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 90, pointsActive = 40, minEnergy = 1},
            [2] = {modifierPassive = 10, modifierActive = 10, pointsPassive = 180, pointsActive = 80, minEnergy = 1},
            [3] = {modifierPassive = 15, modifierActive = 15, pointsPassive = 270, pointsActive = 120, minEnergy = 1},
            [4] = {modifierPassive = 20, modifierActive = 20, pointsPassive = 360, pointsActive = 160, minEnergy = 2},
            [5] = {modifierPassive = 25, modifierActive = 25, pointsPassive = 450, pointsActive = 200, minEnergy = 2},
            [6] = {modifierPassive = 30, modifierActive = 30, pointsPassive = 540, pointsActive = 240, minEnergy = 2},
            [7] = {modifierPassive = 35, modifierActive = 35, pointsPassive = 630, pointsActive = 280, minEnergy = 3},
            [8] = {modifierPassive = 40, modifierActive = 40, pointsPassive = 720, pointsActive = 320, minEnergy = 3},
            [9] = {modifierPassive = 45, modifierActive = 45, pointsPassive = 810, pointsActive = 360, minEnergy = 3},
            [10] = {modifierPassive = 50, modifierActive = 50, pointsPassive = 900, pointsActive = 400, minEnergy = 4},
            [11] = {modifierPassive = 55, modifierActive = 55, pointsPassive = 990, pointsActive = 440, minEnergy = 4},
            [12] = {modifierPassive = 60, modifierActive = 60, pointsPassive = 1080, pointsActive = 480, minEnergy = 4},
            [13] = {modifierPassive = 65, modifierActive = 65, pointsPassive = 1170, pointsActive = 520, minEnergy = 5},
            [14] = {modifierPassive = 70, modifierActive = 70, pointsPassive = 1260, pointsActive = 560, minEnergy = 5},
            [15] = {modifierPassive = 75, modifierActive = 75, pointsPassive = 1350, pointsActive = 600, minEnergy = 5},
            [16] = {modifierPassive = 80, modifierActive = 80, pointsPassive = 1440, pointsActive = 640, minEnergy = 6},
            [17] = {modifierPassive = 85, modifierActive = 85, pointsPassive = 1530, pointsActive = 680, minEnergy = 6},
            [18] = {modifierPassive = 90, modifierActive = 90, pointsPassive = 1620, pointsActive = 720, minEnergy = 6},
            [19] = {modifierPassive = 95, modifierActive = 95, pointsPassive = 1710, pointsActive = 760, minEnergy = 7},
            [20] = {modifierPassive = 100, modifierActive = 100, pointsPassive = 1800, pointsActive = 800, minEnergy = 7},
        },
    },

    -- Tiles offer addional attack power for units on it, according to the base defense bonus.
    [23] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 10,
        minLevelActive      = 1,
        maxLevelActive      = 10,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 100, pointsActive = 100, minEnergy = 1},
            [2] = {modifierPassive = 10, modifierActive = 10, pointsPassive = 200, pointsActive = 200, minEnergy = 2},
            [3] = {modifierPassive = 15, modifierActive = 15, pointsPassive = 300, pointsActive = 300, minEnergy = 3},
            [4] = {modifierPassive = 20, modifierActive = 20, pointsPassive = 400, pointsActive = 400, minEnergy = 4},
            [5] = {modifierPassive = 25, modifierActive = 25, pointsPassive = 500, pointsActive = 500, minEnergy = 5},
            [6] = {modifierPassive = 30, modifierActive = 30, pointsPassive = 600, pointsActive = 600, minEnergy = 6},
            [7] = {modifierPassive = 35, modifierActive = 35, pointsPassive = 700, pointsActive = 700, minEnergy = 7},
            [8] = {modifierPassive = 40, modifierActive = 40, pointsPassive = 800, pointsActive = 800, minEnergy = 8},
            [9] = {modifierPassive = 45, modifierActive = 45, pointsPassive = 900, pointsActive = 900, minEnergy = 9},
            [10] = {modifierPassive = 50, modifierActive = 50, pointsPassive = 1000, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Tiles offer addional defense power for units on it, according to the base defense bonus.
    [24] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 10,
        minLevelActive      = 1,
        maxLevelActive      = 10,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 100, pointsActive = 100, minEnergy = 1},
            [2] = {modifierPassive = 10, modifierActive = 10, pointsPassive = 200, pointsActive = 200, minEnergy = 2},
            [3] = {modifierPassive = 15, modifierActive = 15, pointsPassive = 300, pointsActive = 300, minEnergy = 3},
            [4] = {modifierPassive = 20, modifierActive = 20, pointsPassive = 400, pointsActive = 400, minEnergy = 4},
            [5] = {modifierPassive = 25, modifierActive = 25, pointsPassive = 500, pointsActive = 500, minEnergy = 5},
            [6] = {modifierPassive = 30, modifierActive = 30, pointsPassive = 600, pointsActive = 600, minEnergy = 6},
            [7] = {modifierPassive = 35, modifierActive = 35, pointsPassive = 700, pointsActive = 700, minEnergy = 7},
            [8] = {modifierPassive = 40, modifierActive = 40, pointsPassive = 800, pointsActive = 800, minEnergy = 8},
            [9] = {modifierPassive = 45, modifierActive = 45, pointsPassive = 900, pointsActive = 900, minEnergy = 9},
            [10] = {modifierPassive = 50, modifierActive = 50, pointsPassive = 1000, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Modify the lower limit of the luck damage of the owner player.
    [25] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 20,
        minLevelActive      = 1,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 80, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 10, modifierActive = 10, pointsPassive = 160, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 15, modifierActive = 15, pointsPassive = 240, pointsActive = 150, minEnergy = 1},
            [4] = {modifierPassive = 20, modifierActive = 20, pointsPassive = 320, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 25, modifierActive = 25, pointsPassive = 400, pointsActive = 250, minEnergy = 2},
            [6] = {modifierPassive = 30, modifierActive = 30, pointsPassive = 480, pointsActive = 300, minEnergy = 2},
            [7] = {modifierPassive = 35, modifierActive = 35, pointsPassive = 560, pointsActive = 350, minEnergy = 3},
            [8] = {modifierPassive = 40, modifierActive = 40, pointsPassive = 640, pointsActive = 400, minEnergy = 3},
            [9] = {modifierPassive = 45, modifierActive = 45, pointsPassive = 720, pointsActive = 450, minEnergy = 3},
            [10] = {modifierPassive = 50, modifierActive = 50, pointsPassive = 800, pointsActive = 500, minEnergy = 4},
            [11] = {modifierPassive = 55, modifierActive = 55, pointsPassive = 880, pointsActive = 550, minEnergy = 4},
            [12] = {modifierPassive = 60, modifierActive = 60, pointsPassive = 960, pointsActive = 600, minEnergy = 4},
            [13] = {modifierPassive = 65, modifierActive = 65, pointsPassive = 1040, pointsActive = 650, minEnergy = 5},
            [14] = {modifierPassive = 70, modifierActive = 70, pointsPassive = 1120, pointsActive = 700, minEnergy = 5},
            [15] = {modifierPassive = 75, modifierActive = 75, pointsPassive = 1200, pointsActive = 750, minEnergy = 5},
            [16] = {modifierPassive = 80, modifierActive = 80, pointsPassive = 1280, pointsActive = 800, minEnergy = 6},
            [17] = {modifierPassive = 85, modifierActive = 85, pointsPassive = 1360, pointsActive = 850, minEnergy = 6},
            [18] = {modifierPassive = 90, modifierActive = 90, pointsPassive = 1440, pointsActive = 900, minEnergy = 6},
            [19] = {modifierPassive = 95, modifierActive = 95, pointsPassive = 1520, pointsActive = 950, minEnergy = 7},
            [20] = {modifierPassive = 100, modifierActive = 100, pointsPassive = 1600, pointsActive = 1000, minEnergy = 7},
        },
    },

    -- Modify the promotion of the units of the owner player.
    [26] = {
        minLevelActive     = 1,
        maxLevelActive     = 3,
        modifierUnit = "",
        levels       = {
            [1] = {modifierPassive = nil, modifierActive = 1, pointsPassive = nil, pointsActive = 180, minEnergy = 1},
            [2] = {modifierPassive = nil, modifierActive = 2, pointsPassive = nil, pointsActive = 360, minEnergy = 2},
            [3] = {modifierPassive = nil, modifierActive = 3, pointsPassive = nil, pointsActive = 540, minEnergy = 3},
        },
    },

    -- Modify the promotion of the newly produced units of the owner player.
    [27] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 3,
        modifierUnit = "",
        levels       = {
            [1] = {modifierPassive = 1, modifierActive = nil, pointsPassive = 95, pointsActive = nil, minEnergy = nil},
            [2] = {modifierPassive = 2, modifierActive = nil, pointsPassive = 220, pointsActive = nil, minEnergy = nil},
            [3] = {modifierPassive = 3, modifierActive = nil, pointsPassive = 410, pointsActive = nil, minEnergy = nil},
        },
    },

    -- "Perfect Movement".
    [28] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 1,
        minLevelActive      = 1,
        maxLevelActive      = 1,
        modifierUnit = "",
        levels       = {
            [1] = {modifierPassive = nil, modifierActive = nil, pointsPassive = 250, pointsActive = 125, minEnergy = 2},
        },
    },

    -- Modify the attack of the direct units.
    [29] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 12,
        minLevelActive      = 1,
        maxLevelActive      = 12,
        modifierUnit = "%",
        levels       = {
            [-4] = {modifierPassive = -20, modifierActive = -20, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-3] = {modifierPassive = -15, modifierActive = -15, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-2] = {modifierPassive = -10, modifierActive = -10, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [-1] = {modifierPassive = -5, modifierActive = -5, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 60, pointsActive = 60, minEnergy = 1},
            [2] = {modifierPassive = 10, modifierActive = 10, pointsPassive = 120, pointsActive = 120, minEnergy = 1},
            [3] = {modifierPassive = 15, modifierActive = 15, pointsPassive = 180, pointsActive = 180, minEnergy = 2},
            [4] = {modifierPassive = 20, modifierActive = 20, pointsPassive = 240, pointsActive = 240, minEnergy = 2},
            [5] = {modifierPassive = 25, modifierActive = 25, pointsPassive = 300, pointsActive = 300, minEnergy = 3},
            [6] = {modifierPassive = 30, modifierActive = 30, pointsPassive = 360, pointsActive = 360, minEnergy = 3},
            [7] = {modifierPassive = 35, modifierActive = 35, pointsPassive = 420, pointsActive = 420, minEnergy = 4},
            [8] = {modifierPassive = 40, modifierActive = 40, pointsPassive = 480, pointsActive = 480, minEnergy = 4},
            [9] = {modifierPassive = 45, modifierActive = 45, pointsPassive = 540, pointsActive = 540, minEnergy = 5},
            [10] = {modifierPassive = 50, modifierActive = 50, pointsPassive = 600, pointsActive = 600, minEnergy = 5},
            [11] = {modifierPassive = 55, modifierActive = 55, pointsPassive = 660, pointsActive = 660, minEnergy = 6},
            [12] = {modifierPassive = 60, modifierActive = 60, pointsPassive = 720, pointsActive = 720, minEnergy = 6},
        },
    },

    -- Modify the attack of the indirect units.
    [30] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 12,
        minLevelActive      = 1,
        maxLevelActive      = 12,
        modifierUnit = "%",
        levels       = {
            [-4] = {modifierPassive = -20, modifierActive = -20, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-3] = {modifierPassive = -15, modifierActive = -15, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-2] = {modifierPassive = -10, modifierActive = -10, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [-1] = {modifierPassive = -5, modifierActive = -5, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 55, pointsActive = 55, minEnergy = 1},
            [2] = {modifierPassive = 10, modifierActive = 10, pointsPassive = 110, pointsActive = 110, minEnergy = 1},
            [3] = {modifierPassive = 15, modifierActive = 15, pointsPassive = 165, pointsActive = 165, minEnergy = 2},
            [4] = {modifierPassive = 20, modifierActive = 20, pointsPassive = 220, pointsActive = 220, minEnergy = 2},
            [5] = {modifierPassive = 25, modifierActive = 25, pointsPassive = 275, pointsActive = 275, minEnergy = 3},
            [6] = {modifierPassive = 30, modifierActive = 30, pointsPassive = 330, pointsActive = 330, minEnergy = 3},
            [7] = {modifierPassive = 35, modifierActive = 35, pointsPassive = 385, pointsActive = 385, minEnergy = 4},
            [8] = {modifierPassive = 40, modifierActive = 40, pointsPassive = 440, pointsActive = 440, minEnergy = 4},
            [9] = {modifierPassive = 45, modifierActive = 45, pointsPassive = 495, pointsActive = 495, minEnergy = 5},
            [10] = {modifierPassive = 50, modifierActive = 50, pointsPassive = 550, pointsActive = 550, minEnergy = 5},
            [11] = {modifierPassive = 55, modifierActive = 55, pointsPassive = 605, pointsActive = 605, minEnergy = 6},
            [12] = {modifierPassive = 60, modifierActive = 60, pointsPassive = 660, pointsActive = 660, minEnergy = 6},
        },
    },

    -- Modify the attack of the ground units.
    [31] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 12,
        minLevelActive      = 1,
        maxLevelActive      = 12,
        modifierUnit = "%",
        levels       = {
            [-4] = {modifierPassive = -20, modifierActive = -20, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-3] = {modifierPassive = -15, modifierActive = -15, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-2] = {modifierPassive = -10, modifierActive = -10, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [-1] = {modifierPassive = -5, modifierActive = -5, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 60, pointsActive = 60, minEnergy = 1},
            [2] = {modifierPassive = 10, modifierActive = 10, pointsPassive = 120, pointsActive = 120, minEnergy = 1},
            [3] = {modifierPassive = 15, modifierActive = 15, pointsPassive = 180, pointsActive = 180, minEnergy = 2},
            [4] = {modifierPassive = 20, modifierActive = 20, pointsPassive = 240, pointsActive = 240, minEnergy = 2},
            [5] = {modifierPassive = 25, modifierActive = 25, pointsPassive = 300, pointsActive = 300, minEnergy = 3},
            [6] = {modifierPassive = 30, modifierActive = 30, pointsPassive = 360, pointsActive = 360, minEnergy = 3},
            [7] = {modifierPassive = 35, modifierActive = 35, pointsPassive = 420, pointsActive = 420, minEnergy = 4},
            [8] = {modifierPassive = 40, modifierActive = 40, pointsPassive = 480, pointsActive = 480, minEnergy = 4},
            [9] = {modifierPassive = 45, modifierActive = 45, pointsPassive = 540, pointsActive = 540, minEnergy = 5},
            [10] = {modifierPassive = 50, modifierActive = 50, pointsPassive = 600, pointsActive = 600, minEnergy = 5},
            [11] = {modifierPassive = 55, modifierActive = 55, pointsPassive = 660, pointsActive = 660, minEnergy = 6},
            [12] = {modifierPassive = 60, modifierActive = 60, pointsPassive = 720, pointsActive = 720, minEnergy = 6},
        },
    },

    -- Modify the attack of the air units.
    [32] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 12,
        minLevelActive      = 1,
        maxLevelActive      = 12,
        modifierUnit = "%",
        levels       = {
            [-4] = {modifierPassive = -20, modifierActive = -20, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-3] = {modifierPassive = -15, modifierActive = -15, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-2] = {modifierPassive = -10, modifierActive = -10, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [-1] = {modifierPassive = -5, modifierActive = -5, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 50, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 10, modifierActive = 10, pointsPassive = 100, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 15, modifierActive = 15, pointsPassive = 150, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 20, modifierActive = 20, pointsPassive = 200, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 25, modifierActive = 25, pointsPassive = 250, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 30, modifierActive = 30, pointsPassive = 300, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 35, modifierActive = 35, pointsPassive = 350, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 40, modifierActive = 40, pointsPassive = 400, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 45, modifierActive = 45, pointsPassive = 450, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 50, modifierActive = 50, pointsPassive = 500, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 55, modifierActive = 55, pointsPassive = 550, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 60, modifierActive = 60, pointsPassive = 600, pointsActive = 600, minEnergy = 6},
        },
    },

    -- Modify the attack of the naval units.
    [33] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 12,
        minLevelActive      = 1,
        maxLevelActive      = 12,
        modifierUnit = "%",
        levels       = {
            [-4] = {modifierPassive = -20, modifierActive = -20, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-3] = {modifierPassive = -15, modifierActive = -15, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-2] = {modifierPassive = -10, modifierActive = -10, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [-1] = {modifierPassive = -5, modifierActive = -5, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 50, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 10, modifierActive = 10, pointsPassive = 100, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 15, modifierActive = 15, pointsPassive = 150, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 20, modifierActive = 20, pointsPassive = 200, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 25, modifierActive = 25, pointsPassive = 250, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 30, modifierActive = 30, pointsPassive = 300, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 35, modifierActive = 35, pointsPassive = 350, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 40, modifierActive = 40, pointsPassive = 400, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 45, modifierActive = 45, pointsPassive = 450, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 50, modifierActive = 50, pointsPassive = 500, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 55, modifierActive = 55, pointsPassive = 550, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 60, modifierActive = 60, pointsPassive = 600, pointsActive = 600, minEnergy = 6},
        },
    },

    -- Modify the attack of the infantry units, including Infantry, Mech and Bike.
    [34] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 12,
        minLevelActive      = 1,
        maxLevelActive      = 12,
        modifierUnit = "%",
        levels       = {
            [-4] = {modifierPassive = -20, modifierActive = -20, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-3] = {modifierPassive = -15, modifierActive = -15, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-2] = {modifierPassive = -10, modifierActive = -10, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [-1] = {modifierPassive = -5, modifierActive = -5, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 40, pointsActive = 40, minEnergy = 1},
            [2] = {modifierPassive = 10, modifierActive = 10, pointsPassive = 80, pointsActive = 80, minEnergy = 1},
            [3] = {modifierPassive = 15, modifierActive = 15, pointsPassive = 120, pointsActive = 120, minEnergy = 2},
            [4] = {modifierPassive = 20, modifierActive = 20, pointsPassive = 160, pointsActive = 160, minEnergy = 2},
            [5] = {modifierPassive = 25, modifierActive = 25, pointsPassive = 200, pointsActive = 200, minEnergy = 3},
            [6] = {modifierPassive = 30, modifierActive = 30, pointsPassive = 240, pointsActive = 240, minEnergy = 3},
            [7] = {modifierPassive = 35, modifierActive = 35, pointsPassive = 280, pointsActive = 280, minEnergy = 4},
            [8] = {modifierPassive = 40, modifierActive = 40, pointsPassive = 320, pointsActive = 320, minEnergy = 4},
            [9] = {modifierPassive = 45, modifierActive = 45, pointsPassive = 360, pointsActive = 360, minEnergy = 5},
            [10] = {modifierPassive = 50, modifierActive = 50, pointsPassive = 400, pointsActive = 400, minEnergy = 5},
            [11] = {modifierPassive = 55, modifierActive = 55, pointsPassive = 440, pointsActive = 440, minEnergy = 6},
            [12] = {modifierPassive = 60, modifierActive = 60, pointsPassive = 480, pointsActive = 480, minEnergy = 6},
        },
    },

    -- Modify the attack of the vehicle units.
    [35] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 12,
        minLevelActive      = 1,
        maxLevelActive      = 12,
        modifierUnit = "%",
        levels       = {
            [-4] = {modifierPassive = -20, modifierActive = -20, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-3] = {modifierPassive = -15, modifierActive = -15, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-2] = {modifierPassive = -10, modifierActive = -10, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [-1] = {modifierPassive = -5, modifierActive = -5, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 55, pointsActive = 55, minEnergy = 1},
            [2] = {modifierPassive = 10, modifierActive = 10, pointsPassive = 110, pointsActive = 110, minEnergy = 1},
            [3] = {modifierPassive = 15, modifierActive = 15, pointsPassive = 165, pointsActive = 165, minEnergy = 2},
            [4] = {modifierPassive = 20, modifierActive = 20, pointsPassive = 220, pointsActive = 220, minEnergy = 2},
            [5] = {modifierPassive = 25, modifierActive = 25, pointsPassive = 275, pointsActive = 275, minEnergy = 3},
            [6] = {modifierPassive = 30, modifierActive = 30, pointsPassive = 330, pointsActive = 330, minEnergy = 3},
            [7] = {modifierPassive = 35, modifierActive = 35, pointsPassive = 385, pointsActive = 385, minEnergy = 4},
            [8] = {modifierPassive = 40, modifierActive = 40, pointsPassive = 440, pointsActive = 440, minEnergy = 4},
            [9] = {modifierPassive = 45, modifierActive = 45, pointsPassive = 495, pointsActive = 495, minEnergy = 5},
            [10] = {modifierPassive = 50, modifierActive = 50, pointsPassive = 550, pointsActive = 550, minEnergy = 5},
            [11] = {modifierPassive = 55, modifierActive = 55, pointsPassive = 605, pointsActive = 605, minEnergy = 6},
            [12] = {modifierPassive = 60, modifierActive = 60, pointsPassive = 660, pointsActive = 660, minEnergy = 6},
        },
    },

    -- Modify the attack of direct non-infantry units.
    [36] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 12,
        minLevelActive      = 1,
        maxLevelActive      = 12,
        modifierUnit = "%",
        levels       = {
            [-4] = {modifierPassive = -20, modifierActive = -20, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-3] = {modifierPassive = -15, modifierActive = -15, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-2] = {modifierPassive = -10, modifierActive = -10, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [-1] = {modifierPassive = -5, modifierActive = -5, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 55, pointsActive = 55, minEnergy = 1},
            [2] = {modifierPassive = 10, modifierActive = 10, pointsPassive = 110, pointsActive = 110, minEnergy = 1},
            [3] = {modifierPassive = 15, modifierActive = 15, pointsPassive = 165, pointsActive = 165, minEnergy = 2},
            [4] = {modifierPassive = 20, modifierActive = 20, pointsPassive = 220, pointsActive = 220, minEnergy = 2},
            [5] = {modifierPassive = 25, modifierActive = 25, pointsPassive = 275, pointsActive = 275, minEnergy = 3},
            [6] = {modifierPassive = 30, modifierActive = 30, pointsPassive = 330, pointsActive = 330, minEnergy = 3},
            [7] = {modifierPassive = 35, modifierActive = 35, pointsPassive = 385, pointsActive = 385, minEnergy = 4},
            [8] = {modifierPassive = 40, modifierActive = 40, pointsPassive = 440, pointsActive = 440, minEnergy = 4},
            [9] = {modifierPassive = 45, modifierActive = 45, pointsPassive = 495, pointsActive = 495, minEnergy = 5},
            [10] = {modifierPassive = 50, modifierActive = 50, pointsPassive = 550, pointsActive = 550, minEnergy = 5},
            [11] = {modifierPassive = 55, modifierActive = 55, pointsPassive = 605, pointsActive = 605, minEnergy = 6},
            [12] = {modifierPassive = 60, modifierActive = 60, pointsPassive = 660, pointsActive = 660, minEnergy = 6},
        },
    },

    -- Modify the defense of the direct units.
    [37] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 12,
        minLevelActive      = 1,
        maxLevelActive      = 12,
        modifierUnit = "%",
        levels       = {
            [-4] = {modifierPassive = -20, modifierActive = -20, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-3] = {modifierPassive = -15, modifierActive = -15, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-2] = {modifierPassive = -10, modifierActive = -10, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [-1] = {modifierPassive = -5, modifierActive = -5, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 60, pointsActive = 60, minEnergy = 1},
            [2] = {modifierPassive = 10, modifierActive = 10, pointsPassive = 120, pointsActive = 120, minEnergy = 1},
            [3] = {modifierPassive = 15, modifierActive = 15, pointsPassive = 180, pointsActive = 180, minEnergy = 2},
            [4] = {modifierPassive = 20, modifierActive = 20, pointsPassive = 240, pointsActive = 240, minEnergy = 2},
            [5] = {modifierPassive = 25, modifierActive = 25, pointsPassive = 300, pointsActive = 300, minEnergy = 3},
            [6] = {modifierPassive = 30, modifierActive = 30, pointsPassive = 360, pointsActive = 360, minEnergy = 3},
            [7] = {modifierPassive = 35, modifierActive = 35, pointsPassive = 420, pointsActive = 420, minEnergy = 4},
            [8] = {modifierPassive = 40, modifierActive = 40, pointsPassive = 480, pointsActive = 480, minEnergy = 4},
            [9] = {modifierPassive = 45, modifierActive = 45, pointsPassive = 540, pointsActive = 540, minEnergy = 5},
            [10] = {modifierPassive = 50, modifierActive = 50, pointsPassive = 600, pointsActive = 600, minEnergy = 5},
            [11] = {modifierPassive = 55, modifierActive = 55, pointsPassive = 660, pointsActive = 660, minEnergy = 6},
            [12] = {modifierPassive = 60, modifierActive = 60, pointsPassive = 720, pointsActive = 720, minEnergy = 6},
        },
    },

    -- Modify the defense of the indirect units.
    [38] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 12,
        minLevelActive      = 1,
        maxLevelActive      = 12,
        modifierUnit = "%",
        levels       = {
            [-4] = {modifierPassive = -20, modifierActive = -20, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-3] = {modifierPassive = -15, modifierActive = -15, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-2] = {modifierPassive = -10, modifierActive = -10, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [-1] = {modifierPassive = -5, modifierActive = -5, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 55, pointsActive = 55, minEnergy = 1},
            [2] = {modifierPassive = 10, modifierActive = 10, pointsPassive = 110, pointsActive = 110, minEnergy = 1},
            [3] = {modifierPassive = 15, modifierActive = 15, pointsPassive = 165, pointsActive = 165, minEnergy = 2},
            [4] = {modifierPassive = 20, modifierActive = 20, pointsPassive = 220, pointsActive = 220, minEnergy = 2},
            [5] = {modifierPassive = 25, modifierActive = 25, pointsPassive = 275, pointsActive = 275, minEnergy = 3},
            [6] = {modifierPassive = 30, modifierActive = 30, pointsPassive = 330, pointsActive = 330, minEnergy = 3},
            [7] = {modifierPassive = 35, modifierActive = 35, pointsPassive = 385, pointsActive = 385, minEnergy = 4},
            [8] = {modifierPassive = 40, modifierActive = 40, pointsPassive = 440, pointsActive = 440, minEnergy = 4},
            [9] = {modifierPassive = 45, modifierActive = 45, pointsPassive = 495, pointsActive = 495, minEnergy = 5},
            [10] = {modifierPassive = 50, modifierActive = 50, pointsPassive = 550, pointsActive = 550, minEnergy = 5},
            [11] = {modifierPassive = 55, modifierActive = 55, pointsPassive = 605, pointsActive = 605, minEnergy = 6},
            [12] = {modifierPassive = 60, modifierActive = 60, pointsPassive = 660, pointsActive = 660, minEnergy = 6},
        },
    },

    -- Modify the defense of the ground units.
    [39] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 12,
        minLevelActive      = 1,
        maxLevelActive      = 12,
        modifierUnit = "%",
        levels       = {
            [-4] = {modifierPassive = -20, modifierActive = -20, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-3] = {modifierPassive = -15, modifierActive = -15, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-2] = {modifierPassive = -10, modifierActive = -10, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [-1] = {modifierPassive = -5, modifierActive = -5, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 60, pointsActive = 60, minEnergy = 1},
            [2] = {modifierPassive = 10, modifierActive = 10, pointsPassive = 120, pointsActive = 120, minEnergy = 1},
            [3] = {modifierPassive = 15, modifierActive = 15, pointsPassive = 180, pointsActive = 180, minEnergy = 2},
            [4] = {modifierPassive = 20, modifierActive = 20, pointsPassive = 240, pointsActive = 240, minEnergy = 2},
            [5] = {modifierPassive = 25, modifierActive = 25, pointsPassive = 300, pointsActive = 300, minEnergy = 3},
            [6] = {modifierPassive = 30, modifierActive = 30, pointsPassive = 360, pointsActive = 360, minEnergy = 3},
            [7] = {modifierPassive = 35, modifierActive = 35, pointsPassive = 420, pointsActive = 420, minEnergy = 4},
            [8] = {modifierPassive = 40, modifierActive = 40, pointsPassive = 480, pointsActive = 480, minEnergy = 4},
            [9] = {modifierPassive = 45, modifierActive = 45, pointsPassive = 540, pointsActive = 540, minEnergy = 5},
            [10] = {modifierPassive = 50, modifierActive = 50, pointsPassive = 600, pointsActive = 600, minEnergy = 5},
            [11] = {modifierPassive = 55, modifierActive = 55, pointsPassive = 660, pointsActive = 660, minEnergy = 6},
            [12] = {modifierPassive = 60, modifierActive = 60, pointsPassive = 720, pointsActive = 720, minEnergy = 6},
        },
    },

    -- Modify the defense of the air units.
    [40] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 12,
        minLevelActive      = 1,
        maxLevelActive      = 12,
        modifierUnit = "%",
        levels       = {
            [-4] = {modifierPassive = -20, modifierActive = -20, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-3] = {modifierPassive = -15, modifierActive = -15, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-2] = {modifierPassive = -10, modifierActive = -10, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [-1] = {modifierPassive = -5, modifierActive = -5, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 50, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 10, modifierActive = 10, pointsPassive = 100, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 15, modifierActive = 15, pointsPassive = 150, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 20, modifierActive = 20, pointsPassive = 200, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 25, modifierActive = 25, pointsPassive = 250, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 30, modifierActive = 30, pointsPassive = 300, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 35, modifierActive = 35, pointsPassive = 350, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 40, modifierActive = 40, pointsPassive = 400, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 45, modifierActive = 45, pointsPassive = 450, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 50, modifierActive = 50, pointsPassive = 500, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 55, modifierActive = 55, pointsPassive = 550, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 60, modifierActive = 60, pointsPassive = 600, pointsActive = 600, minEnergy = 6},
        },
    },

    -- Modify the defense of the naval units.
    [41] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 12,
        minLevelActive      = 1,
        maxLevelActive      = 12,
        modifierUnit = "%",
        levels       = {
            [-4] = {modifierPassive = -20, modifierActive = -20, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-3] = {modifierPassive = -15, modifierActive = -15, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-2] = {modifierPassive = -10, modifierActive = -10, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [-1] = {modifierPassive = -5, modifierActive = -5, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 50, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 10, modifierActive = 10, pointsPassive = 100, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 15, modifierActive = 15, pointsPassive = 150, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 20, modifierActive = 20, pointsPassive = 200, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 25, modifierActive = 25, pointsPassive = 250, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 30, modifierActive = 30, pointsPassive = 300, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 35, modifierActive = 35, pointsPassive = 350, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 40, modifierActive = 40, pointsPassive = 400, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 45, modifierActive = 45, pointsPassive = 450, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 50, modifierActive = 50, pointsPassive = 500, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 55, modifierActive = 55, pointsPassive = 550, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 60, modifierActive = 60, pointsPassive = 600, pointsActive = 600, minEnergy = 6},
        },
    },

    -- Modify the defense of the infantry units, including Infantry, Mech and Bike.
    [42] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 12,
        minLevelActive      = 1,
        maxLevelActive      = 12,
        modifierUnit = "%",
        levels       = {
            [-4] = {modifierPassive = -20, modifierActive = -20, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-3] = {modifierPassive = -15, modifierActive = -15, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-2] = {modifierPassive = -10, modifierActive = -10, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [-1] = {modifierPassive = -5, modifierActive = -5, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 40, pointsActive = 40, minEnergy = 1},
            [2] = {modifierPassive = 10, modifierActive = 10, pointsPassive = 80, pointsActive = 80, minEnergy = 1},
            [3] = {modifierPassive = 15, modifierActive = 15, pointsPassive = 120, pointsActive = 120, minEnergy = 2},
            [4] = {modifierPassive = 20, modifierActive = 20, pointsPassive = 160, pointsActive = 160, minEnergy = 2},
            [5] = {modifierPassive = 25, modifierActive = 25, pointsPassive = 200, pointsActive = 200, minEnergy = 3},
            [6] = {modifierPassive = 30, modifierActive = 30, pointsPassive = 240, pointsActive = 240, minEnergy = 3},
            [7] = {modifierPassive = 35, modifierActive = 35, pointsPassive = 280, pointsActive = 280, minEnergy = 4},
            [8] = {modifierPassive = 40, modifierActive = 40, pointsPassive = 320, pointsActive = 320, minEnergy = 4},
            [9] = {modifierPassive = 45, modifierActive = 45, pointsPassive = 360, pointsActive = 360, minEnergy = 5},
            [10] = {modifierPassive = 50, modifierActive = 50, pointsPassive = 400, pointsActive = 400, minEnergy = 5},
            [11] = {modifierPassive = 55, modifierActive = 55, pointsPassive = 440, pointsActive = 440, minEnergy = 6},
            [12] = {modifierPassive = 60, modifierActive = 60, pointsPassive = 480, pointsActive = 480, minEnergy = 6},
        },
    },

    -- Modify the defense of the vehicle units.
    [43] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 12,
        minLevelActive      = 1,
        maxLevelActive      = 12,
        modifierUnit = "%",
        levels       = {
            [-4] = {modifierPassive = -20, modifierActive = -20, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-3] = {modifierPassive = -15, modifierActive = -15, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-2] = {modifierPassive = -10, modifierActive = -10, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [-1] = {modifierPassive = -5, modifierActive = -5, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 55, pointsActive = 55, minEnergy = 1},
            [2] = {modifierPassive = 10, modifierActive = 10, pointsPassive = 110, pointsActive = 110, minEnergy = 1},
            [3] = {modifierPassive = 15, modifierActive = 15, pointsPassive = 165, pointsActive = 165, minEnergy = 2},
            [4] = {modifierPassive = 20, modifierActive = 20, pointsPassive = 220, pointsActive = 220, minEnergy = 2},
            [5] = {modifierPassive = 25, modifierActive = 25, pointsPassive = 275, pointsActive = 275, minEnergy = 3},
            [6] = {modifierPassive = 30, modifierActive = 30, pointsPassive = 330, pointsActive = 330, minEnergy = 3},
            [7] = {modifierPassive = 35, modifierActive = 35, pointsPassive = 385, pointsActive = 385, minEnergy = 4},
            [8] = {modifierPassive = 40, modifierActive = 40, pointsPassive = 440, pointsActive = 440, minEnergy = 4},
            [9] = {modifierPassive = 45, modifierActive = 45, pointsPassive = 495, pointsActive = 495, minEnergy = 5},
            [10] = {modifierPassive = 50, modifierActive = 50, pointsPassive = 550, pointsActive = 550, minEnergy = 5},
            [11] = {modifierPassive = 55, modifierActive = 55, pointsPassive = 605, pointsActive = 605, minEnergy = 6},
            [12] = {modifierPassive = 60, modifierActive = 60, pointsPassive = 660, pointsActive = 660, minEnergy = 6},
        },
    },

    -- Modify the defense of direct non-infantry units.
    [44] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 12,
        minLevelActive      = 1,
        maxLevelActive      = 12,
        modifierUnit = "%",
        levels       = {
            [-4] = {modifierPassive = -20, modifierActive = -20, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-3] = {modifierPassive = -15, modifierActive = -15, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-2] = {modifierPassive = -10, modifierActive = -10, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [-1] = {modifierPassive = -5, modifierActive = -5, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 55, pointsActive = 55, minEnergy = 1},
            [2] = {modifierPassive = 10, modifierActive = 10, pointsPassive = 110, pointsActive = 110, minEnergy = 1},
            [3] = {modifierPassive = 15, modifierActive = 15, pointsPassive = 165, pointsActive = 165, minEnergy = 2},
            [4] = {modifierPassive = 20, modifierActive = 20, pointsPassive = 220, pointsActive = 220, minEnergy = 2},
            [5] = {modifierPassive = 25, modifierActive = 25, pointsPassive = 275, pointsActive = 275, minEnergy = 3},
            [6] = {modifierPassive = 30, modifierActive = 30, pointsPassive = 330, pointsActive = 330, minEnergy = 3},
            [7] = {modifierPassive = 35, modifierActive = 35, pointsPassive = 385, pointsActive = 385, minEnergy = 4},
            [8] = {modifierPassive = 40, modifierActive = 40, pointsPassive = 440, pointsActive = 440, minEnergy = 4},
            [9] = {modifierPassive = 45, modifierActive = 45, pointsPassive = 495, pointsActive = 495, minEnergy = 5},
            [10] = {modifierPassive = 50, modifierActive = 50, pointsPassive = 550, pointsActive = 550, minEnergy = 5},
            [11] = {modifierPassive = 55, modifierActive = 55, pointsPassive = 605, pointsActive = 605, minEnergy = 6},
            [12] = {modifierPassive = 60, modifierActive = 60, pointsPassive = 660, pointsActive = 660, minEnergy = 6},
        },
    },

    -- Modify the defense of the transport units.
    [45] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 12,
        minLevelActive      = 1,
        maxLevelActive      = 12,
        modifierUnit = "%",
        levels       = {
            [-4] = {modifierPassive = -20, modifierActive = -20, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-3] = {modifierPassive = -15, modifierActive = -15, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [-2] = {modifierPassive = -10, modifierActive = -10, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [-1] = {modifierPassive = -5, modifierActive = -5, pointsPassive = 0, pointsActive = 0, minEnergy = 1},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 15, pointsActive = 15, minEnergy = 1},
            [2] = {modifierPassive = 10, modifierActive = 10, pointsPassive = 30, pointsActive = 30, minEnergy = 1},
            [3] = {modifierPassive = 15, modifierActive = 15, pointsPassive = 45, pointsActive = 45, minEnergy = 2},
            [4] = {modifierPassive = 20, modifierActive = 20, pointsPassive = 60, pointsActive = 60, minEnergy = 2},
            [5] = {modifierPassive = 25, modifierActive = 25, pointsPassive = 75, pointsActive = 75, minEnergy = 3},
            [6] = {modifierPassive = 30, modifierActive = 30, pointsPassive = 90, pointsActive = 90, minEnergy = 3},
            [7] = {modifierPassive = 35, modifierActive = 35, pointsPassive = 105, pointsActive = 105, minEnergy = 4},
            [8] = {modifierPassive = 40, modifierActive = 40, pointsPassive = 120, pointsActive = 120, minEnergy = 4},
            [9] = {modifierPassive = 45, modifierActive = 45, pointsPassive = 135, pointsActive = 135, minEnergy = 5},
            [10] = {modifierPassive = 50, modifierActive = 50, pointsPassive = 150, pointsActive = 150, minEnergy = 5},
            [11] = {modifierPassive = 55, modifierActive = 55, pointsPassive = 165, pointsActive = 165, minEnergy = 6},
            [12] = {modifierPassive = 60, modifierActive = 60, pointsPassive = 180, pointsActive = 180, minEnergy = 6},
        },
    },

    -- Modify movements of direct units of the owner player.
    [46] = {
        minLevelActive     = 1,
        maxLevelActive     = 5,
        modifierUnit = "",
        levels = {
            [-1] = {modifierPassive = nil, modifierActive = -1, pointsPassive = nil, pointsActive = 0, minEnergy = 2},
            [0] = {modifierPassive = nil, modifierActive = 0, pointsPassive = nil, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = nil, modifierActive = 1, pointsPassive = nil, pointsActive = 170, minEnergy = 2},
            [2] = {modifierPassive = nil, modifierActive = 2, pointsPassive = nil, pointsActive = 340, minEnergy = 4},
            [3] = {modifierPassive = nil, modifierActive = 3, pointsPassive = nil, pointsActive = 510, minEnergy = 6},
            [4] = {modifierPassive = nil, modifierActive = 4, pointsPassive = nil, pointsActive = 680, minEnergy = 8},
            [5] = {modifierPassive = nil, modifierActive = 5, pointsPassive = nil, pointsActive = 850, minEnergy = 10},
        },
    },

    -- Modify movements of indirect units of the owner player.
    [47] = {
        minLevelActive     = 1,
        maxLevelActive     = 5,
        modifierUnit = "",
        levels = {
            [-1] = {modifierPassive = nil, modifierActive = -1, pointsPassive = nil, pointsActive = 0, minEnergy = 2},
            [0] = {modifierPassive = nil, modifierActive = 0, pointsPassive = nil, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = nil, modifierActive = 1, pointsPassive = nil, pointsActive = 50, minEnergy = 2},
            [2] = {modifierPassive = nil, modifierActive = 2, pointsPassive = nil, pointsActive = 100, minEnergy = 4},
            [3] = {modifierPassive = nil, modifierActive = 3, pointsPassive = nil, pointsActive = 150, minEnergy = 6},
            [4] = {modifierPassive = nil, modifierActive = 4, pointsPassive = nil, pointsActive = 200, minEnergy = 8},
            [5] = {modifierPassive = nil, modifierActive = 5, pointsPassive = nil, pointsActive = 250, minEnergy = 10},
        },
    },

    -- Modify movements of ground units of the owner player.
    [48] = {
        minLevelActive     = 1,
        maxLevelActive     = 5,
        modifierUnit = "",
        levels = {
            [-1] = {modifierPassive = nil, modifierActive = -1, pointsPassive = nil, pointsActive = 0, minEnergy = 2},
            [0] = {modifierPassive = nil, modifierActive = 0, pointsPassive = nil, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = nil, modifierActive = 1, pointsPassive = nil, pointsActive = 170, minEnergy = 2},
            [2] = {modifierPassive = nil, modifierActive = 2, pointsPassive = nil, pointsActive = 340, minEnergy = 4},
            [3] = {modifierPassive = nil, modifierActive = 3, pointsPassive = nil, pointsActive = 510, minEnergy = 6},
            [4] = {modifierPassive = nil, modifierActive = 4, pointsPassive = nil, pointsActive = 680, minEnergy = 8},
            [5] = {modifierPassive = nil, modifierActive = 5, pointsPassive = nil, pointsActive = 850, minEnergy = 10},
        },
    },

    -- Modify movements of air units of the owner player.
    [49] = {
        minLevelActive     = 1,
        maxLevelActive     = 5,
        modifierUnit = "",
        levels = {
            [-1] = {modifierPassive = nil, modifierActive = -1, pointsPassive = nil, pointsActive = 0, minEnergy = 2},
            [0] = {modifierPassive = nil, modifierActive = 0, pointsPassive = nil, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = nil, modifierActive = 1, pointsPassive = nil, pointsActive = 130, minEnergy = 2},
            [2] = {modifierPassive = nil, modifierActive = 2, pointsPassive = nil, pointsActive = 260, minEnergy = 4},
            [3] = {modifierPassive = nil, modifierActive = 3, pointsPassive = nil, pointsActive = 390, minEnergy = 6},
            [4] = {modifierPassive = nil, modifierActive = 4, pointsPassive = nil, pointsActive = 520, minEnergy = 8},
            [5] = {modifierPassive = nil, modifierActive = 5, pointsPassive = nil, pointsActive = 650, minEnergy = 10},
        },
    },

    -- Modify movements of naval units of the owner player.
    [50] = {
        minLevelActive     = 1,
        maxLevelActive     = 5,
        modifierUnit = "",
        levels = {
            [-1] = {modifierPassive = nil, modifierActive = -1, pointsPassive = nil, pointsActive = 0, minEnergy = 2},
            [0] = {modifierPassive = nil, modifierActive = 0, pointsPassive = nil, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = nil, modifierActive = 1, pointsPassive = nil, pointsActive = 130, minEnergy = 2},
            [2] = {modifierPassive = nil, modifierActive = 2, pointsPassive = nil, pointsActive = 260, minEnergy = 4},
            [3] = {modifierPassive = nil, modifierActive = 3, pointsPassive = nil, pointsActive = 390, minEnergy = 6},
            [4] = {modifierPassive = nil, modifierActive = 4, pointsPassive = nil, pointsActive = 520, minEnergy = 8},
            [5] = {modifierPassive = nil, modifierActive = 5, pointsPassive = nil, pointsActive = 650, minEnergy = 10},
        },
    },

    -- Modify movements of infantry units of the owner player.
    [51] = {
        minLevelActive     = 1,
        maxLevelActive     = 5,
        modifierUnit = "",
        levels = {
            [-1] = {modifierPassive = nil, modifierActive = -1, pointsPassive = nil, pointsActive = 0, minEnergy = 2},
            [0] = {modifierPassive = nil, modifierActive = 0, pointsPassive = nil, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = nil, modifierActive = 1, pointsPassive = nil, pointsActive = 100, minEnergy = 2},
            [2] = {modifierPassive = nil, modifierActive = 2, pointsPassive = nil, pointsActive = 200, minEnergy = 4},
            [3] = {modifierPassive = nil, modifierActive = 3, pointsPassive = nil, pointsActive = 300, minEnergy = 6},
            [4] = {modifierPassive = nil, modifierActive = 4, pointsPassive = nil, pointsActive = 400, minEnergy = 8},
            [5] = {modifierPassive = nil, modifierActive = 5, pointsPassive = nil, pointsActive = 500, minEnergy = 10},
        },
    },

    -- Modify movements of vehicle units of the owner player.
    [52] = {
        minLevelActive     = 1,
        maxLevelActive     = 5,
        modifierUnit = "",
        levels = {
            [-1] = {modifierPassive = nil, modifierActive = -1, pointsPassive = nil, pointsActive = 0, minEnergy = 2},
            [0] = {modifierPassive = nil, modifierActive = 0, pointsPassive = nil, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = nil, modifierActive = 1, pointsPassive = nil, pointsActive = 150, minEnergy = 2},
            [2] = {modifierPassive = nil, modifierActive = 2, pointsPassive = nil, pointsActive = 300, minEnergy = 4},
            [3] = {modifierPassive = nil, modifierActive = 3, pointsPassive = nil, pointsActive = 450, minEnergy = 6},
            [4] = {modifierPassive = nil, modifierActive = 4, pointsPassive = nil, pointsActive = 600, minEnergy = 8},
            [5] = {modifierPassive = nil, modifierActive = 5, pointsPassive = nil, pointsActive = 750, minEnergy = 10},
        },
    },

    -- Modify movements of direct non-infantry units of the owner player.
    [53] = {
        minLevelActive     = 1,
        maxLevelActive     = 5,
        modifierUnit = "",
        levels = {
            [-1] = {modifierPassive = nil, modifierActive = -1, pointsPassive = nil, pointsActive = 0, minEnergy = 2},
            [0] = {modifierPassive = nil, modifierActive = 0, pointsPassive = nil, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = nil, modifierActive = 1, pointsPassive = nil, pointsActive = 160, minEnergy = 2},
            [2] = {modifierPassive = nil, modifierActive = 2, pointsPassive = nil, pointsActive = 320, minEnergy = 4},
            [3] = {modifierPassive = nil, modifierActive = 3, pointsPassive = nil, pointsActive = 480, minEnergy = 6},
            [4] = {modifierPassive = nil, modifierActive = 4, pointsPassive = nil, pointsActive = 640, minEnergy = 8},
            [5] = {modifierPassive = nil, modifierActive = 5, pointsPassive = nil, pointsActive = 800, minEnergy = 10},
        },
    },

    -- Modify movements of transport units of the owner player.
    [54] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 5,
        minLevelActive      = 1,
        maxLevelActive      = 5,
        modifierUnit = "",
        levels = {
            [-1] = {modifierPassive = -1, modifierActive = -1, pointsPassive = 0, pointsActive = 0, minEnergy = 2},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 1, modifierActive = 1, pointsPassive = 100, pointsActive = 50, minEnergy = 2},
            [2] = {modifierPassive = 2, modifierActive = 2, pointsPassive = 200, pointsActive = 100, minEnergy = 4},
            [3] = {modifierPassive = 3, modifierActive = 3, pointsPassive = 300, pointsActive = 150, minEnergy = 6},
            [4] = {modifierPassive = 4, modifierActive = 4, pointsPassive = 400, pointsActive = 200, minEnergy = 8},
            [5] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 500, pointsActive = 250, minEnergy = 10},
        },
    },

    -- Modify vision of units of the owner player.
    [55] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 5,
        minLevelActive      = 1,
        maxLevelActive      = 5,
        modifierUnit = "",
        levels = {
            [1] = {modifierPassive = 1, modifierActive = 1, pointsPassive = 240, pointsActive = 120, minEnergy = 1},
            [2] = {modifierPassive = 2, modifierActive = 2, pointsPassive = 480, pointsActive = 240, minEnergy = 2},
            [3] = {modifierPassive = 3, modifierActive = 3, pointsPassive = 720, pointsActive = 360, minEnergy = 3},
            [4] = {modifierPassive = 4, modifierActive = 4, pointsPassive = 960, pointsActive = 480, minEnergy = 4},
            [5] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 1200, pointsActive = 600, minEnergy = 5},
        },
    },

    -- Modify vision of buildings of the owner player.
    [56] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 5,
        minLevelActive      = 1,
        maxLevelActive      = 5,
        modifierUnit = "",
        levels = {
            [1] = {modifierPassive = 1, modifierActive = 1, pointsPassive = 160, pointsActive = 80, minEnergy = 1},
            [2] = {modifierPassive = 2, modifierActive = 2, pointsPassive = 320, pointsActive = 160, minEnergy = 2},
            [3] = {modifierPassive = 3, modifierActive = 3, pointsPassive = 480, pointsActive = 240, minEnergy = 3},
            [4] = {modifierPassive = 4, modifierActive = 4, pointsPassive = 640, pointsActive = 320, minEnergy = 4},
            [5] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 800, pointsActive = 400, minEnergy = 5},
        },
    },

    -- Modify vision of units and buildings of the owner player.
    [57] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 5,
        minLevelActive      = 1,
        maxLevelActive      = 5,
        modifierUnit = "",
        levels = {
            [1] = {modifierPassive = 1, modifierActive = 1, pointsPassive = 300, pointsActive = 150, minEnergy = 1},
            [2] = {modifierPassive = 2, modifierActive = 2, pointsPassive = 600, pointsActive = 300, minEnergy = 2},
            [3] = {modifierPassive = 3, modifierActive = 3, pointsPassive = 900, pointsActive = 450, minEnergy = 3},
            [4] = {modifierPassive = 4, modifierActive = 4, pointsPassive = 1200, pointsActive = 600, minEnergy = 4},
            [5] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 1500, pointsActive = 750, minEnergy = 5},
        },
    },

    -- Enable of units of the owner player to reveal the hiding places in distance.
    [58] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 1,
        minLevelActive      = 1,
        maxLevelActive      = 1,
        modifierUnit = "",
        levels = {
            [1] = {modifierPassive = nil, modifierActive = nil, pointsPassive = 240, pointsActive = 120, minEnergy = 1},
        },
    },

    -- Enable of buildings of the owner player to reveal the hiding places in distance.
    [59] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 1,
        minLevelActive      = 1,
        maxLevelActive      = 1,
        modifierUnit = "",
        levels = {
            [1] = {modifierPassive = nil, modifierActive = nil, pointsPassive = 160, pointsActive = 80, minEnergy = 1},
        },
    },

    -- Enable of units and buildings of the owner player to reveal the hiding places in distance.
    [60] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 1,
        minLevelActive      = 1,
        maxLevelActive      = 1,
        modifierUnit = "",
        levels = {
            [1] = {modifierPassive = nil, modifierActive = nil, pointsPassive = 300, pointsActive = 150, minEnergy = 1},
        },
    },
}

GameConstant.skillPresets = {
    Adder = {
        maxPoints = 100,
        passive = {
            {
                id    = 18,
                level = 1,
            },
        },
        active1 = {
            energyRequirement = 2,
            {
                id    = 6,
                level = 1,
            },
            {
                id    = 1,
                level = 3,
            },
        },
        active2 = {
            energyRequirement = 5,
            {
                id    = 6,
                level = 2,
            },
            {
                id    = 1,
                level = 8,
            },
        },
    },

    Andy = {
        maxPoints = 100,
        passive = {
            {
                id    = 2,
                level = 2,
            },
        },
        active1 = {
            energyRequirement = 3,
            {
                id    = 4,
                level = 2,
            },
        },
        active2 = {
            energyRequirement = 6,
            {
                id    = 4,
                level = 5,
            },
            {
                id    = 1,
                level = 4,
            },
            {
                id    = 6,
                level = 1,
            },
        },
    },

    Colin = {
        maxPoints = 100,
        passive = {
            {
                id    = 1,
                level = -2,
            },
            {
                id    = 3,
                level = 3,
            }
        },
        active1 = {
            energyRequirement = 2,
            {
                id    = 12,
                level = 4,
            },
        },
        active2 = {
            energyRequirement = 6,
            {
                id    = 20,
                level = 15,
            },
        },
    },

    Drake = {
        maxPoints = 100,
        passive = {
            {
                id    = 33,
                level = 4,
            },
            {
                id    = 41,
                level = 4,
            },
            {
                id    = 32,
                level = -2,
            },
        },
        active1 = {
            energyRequirement = 3,
            {
                id    = 5,
                level = 1,
            },
            {
                id    = 9,
                level = 2,
            },
        },
        active2 = {
            energyRequirement = 6,
            {
                id    = 5,
                level = 2,
            },
            {
                id    = 9,
                level = 4,
            },
        },
    },

    Eagle = {
        maxPoints = 100,
        passive = {
            {
                id    = 32,
                level = 3,
            },
            {
                id    = 40,
                level = 2,
            },
            {
                id    = 33,
                level = -4
            },
        },
        active1 = {
            energyRequirement = 3,
            {
                id    = 8,
                level = 1,
            },
            {
                id    = 1,
                level = -10,
            },
            {
                id    = 2,
                level = -4,
            },
        },
        active2 = {
            energyRequirement = 9,
            {
                id    = 8,
                level = 1,
            },
            {
                id    = 32,
                level = 4,
            },
        },
    },

    Grimm = {
        maxPoints = 100,
        passive = {
            {
                id    = 1,
                level = 6,
            },
            {
                id    = 2,
                level = -2,
            },
        },
        active1 = {
            energyRequirement = 3,
            {
                id    = 1,
                level = 6,
            },
        },
        active2 = {
            energyRequirement = 6,
            {
                id    = 1,
                level = 12,
            },
        },
    },

    Grit = {
        maxPoints = 100,
        passive = {
            {
                id    = 7,
                level = 1,
            },
            {
                id    = 36,
                level = -4,
            },
        },
        active1 = {
            energyRequirement = 3,
            {
                id    = 7,
                level = 1,
            },
            {
                id    = 30,
                level = 2,
            },
        },
        active2 = {
            energyRequirement = 6,
            {
                id    = 7,
                level = 2,
            },
            {
                id    = 30,
                level = 4,
            },
        },
    },

    Hawke = {
        maxPoints = 100,
        passive = {
            {
                id    = 1,
                level = 2,
            },
        },
        active1 = {
            energyRequirement = 5,
            {
                id    = 4,
                level = 1,
            },
            {
                id    = 5,
                level = 1,
            },
        },
        active2 = {
            energyRequirement = 9,
            {
                id    = 4,
                level = 2,
            },
            {
                id    = 5,
                level = 2,
            },
        },
    },

    Jess = {
        maxPoints = 100,
        passive   = {
            {
                id    = 35,
                level = 4,
            },
            {
                id    = 32,
                level = -2,
            },
            {
                id    = 33,
                level = -2,
            },
        },
        active1 = {
            energyRequirement = 3,
            {
                id    = 35,
                level = 4,
            },
            {
                id    = 52,
                level = 1,
            },
            {
                id    = 16,
                level = 1,
            },
        },
        active2 = {
            energyRequirement = 6,
            {
                id    = 35,
                level = 8,
            },
            {
                id    = 52,
                level = 2,
            },
            {
                id    = 16,
                level = 1,
            },
        },
    },

    Lash = {
        maxPoints = 100,
        passive = {
            {
                id    = 23,
                level = 2,
            },
        },
        active1 = {
            energyRequirement = 4,
            {
                id    = 23,
                level = 2,
            },
            {
                id    = 24,
                level = 2,
            },
            {
                id    = 28,
                level = 1,
            },
        },
        active2 = {
            energyRequirement = 7,
            {
                id    = 23,
                level = 4,
            },
            {
                id    = 24,
                level = 4,
            },
            {
                id    = 28,
                level = 1,
            },
        },
    },

    Max = {
        maxPoints = 100,
        passive = {
            {
                id    = 36,
                level = 4,
            },
            {
                id    = 7,
                level = -1,
            },
        },
        active1 = {
            energyRequirement = 3,
            {
                id    = 36,
                level = 4,
            },
            {
                id    = 53,
                level = 1,
            },
        },
        active2 = {
            energyRequirement = 6,
            {
                id    = 36,
                level = 8,
            },
            {
                id    = 53,
                level = 2,
            },
        },
    },

    Nell = {
        maxPoints = 100,
        passive = {
            {
                id    = 14,
                level = 2,
            },
        },
        active1 = {
            energyRequirement = 3,
            {
                id    = 14,
                level = 6,
            },
        },
        active2 = {
            energyRequirement = 6,
            {
                id    = 14,
                level = 12,
            },
        },
    },

    Sami = {
        maxPoints = 100,
        passive = {
            {
                id    = 15,
                level = 5,
            },
            {
                id    = 34,
                level = 6,
            },
            {
                id    = 36,
                level = -2,
            },
            {
                id    = 54,
                level = 1,
            }
        },
        active1 = {
            energyRequirement = 3,
            {
                id    = 34,
                level = 6,
            },
            {
                id    = 51,
                level = 1,
            },
        },
        active2 = {
            energyRequirement = 8,
            {
                id    = 15,
                level = 11,
            },
            {
                id    = 34,
                level = 8,
            },
            {
                id    = 51,
                level = 2,
            },
        },
    },

    Sasha = {
        maxPoints = 100,
        passive = {
            {
                id    = 17,
                level = 2,
            },
        },
        active1 = {
            energyRequirement = 2,
            {
                id    = 13,
                level = 4,
            },
        },
        active2 = {
            energyRequirement = 6,
            {
                id    = 22,
                level = 16,
            },
        },
    },
}

return GameConstant
