
local GameConstant = {}

GameConstant.version = "0.1.7.3"

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
        61,
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
GameConstant.skillPointsPerStep              = 25
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
        maxLevelPassive     = 20,
        minLevelActive      = -6,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels = {
            [-6] = {modifierPassive = -24, modifierActive = -60, pointsPassive = -150, pointsActive = -150, minEnergy = 12},
            [-5] = {modifierPassive = -20, modifierActive = -50, pointsPassive = -125, pointsActive = -125, minEnergy = 10},
            [-4] = {modifierPassive = -16, modifierActive = -40, pointsPassive = -100, pointsActive = -100, minEnergy = 8},
            [-3] = {modifierPassive = -12, modifierActive = -30, pointsPassive = -75, pointsActive = -75, minEnergy = 6},
            [-2] = {modifierPassive = -8, modifierActive = -20, pointsPassive = -50, pointsActive = -50, minEnergy = 4},
            [-1] = {modifierPassive = -4, modifierActive = -10, pointsPassive = -25, pointsActive = -25, minEnergy = 2},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 2, modifierActive = 4, pointsPassive = 25, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 4, modifierActive = 8, pointsPassive = 50, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 6, modifierActive = 12, pointsPassive = 75, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 8, modifierActive = 16, pointsPassive = 100, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 10, modifierActive = 20, pointsPassive = 125, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 12, modifierActive = 24, pointsPassive = 150, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 14, modifierActive = 28, pointsPassive = 175, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 16, modifierActive = 32, pointsPassive = 200, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 18, modifierActive = 36, pointsPassive = 225, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 20, modifierActive = 40, pointsPassive = 250, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 22, modifierActive = 44, pointsPassive = 275, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 24, modifierActive = 48, pointsPassive = 300, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 26, modifierActive = 52, pointsPassive = 325, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 28, modifierActive = 56, pointsPassive = 350, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 30, modifierActive = 60, pointsPassive = 375, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 32, modifierActive = 64, pointsPassive = 400, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 34, modifierActive = 68, pointsPassive = 425, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 36, modifierActive = 72, pointsPassive = 450, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 38, modifierActive = 76, pointsPassive = 475, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 40, modifierActive = 80, pointsPassive = 500, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Modify the defense power for all units of a player.
    [2] = {
        minLevelPassive     = -6,
        maxLevelPassive     = 20,
        minLevelActive      = -6,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels = {
            [-6] = {modifierPassive = -24.6, modifierActive = -61.5, pointsPassive = -150, pointsActive = -150, minEnergy = 12},
            [-5] = {modifierPassive = -20.5, modifierActive = -51.25, pointsPassive = -125, pointsActive = -125, minEnergy = 10},
            [-4] = {modifierPassive = -16.4, modifierActive = -41, pointsPassive = -100, pointsActive = -100, minEnergy = 8},
            [-3] = {modifierPassive = -12.3, modifierActive = -30.75, pointsPassive = -75, pointsActive = -75, minEnergy = 6},
            [-2] = {modifierPassive = -8.2, modifierActive = -20.5, pointsPassive = -50, pointsActive = -50, minEnergy = 4},
            [-1] = {modifierPassive = -4.1, modifierActive = -10.25, pointsPassive = -25, pointsActive = -25, minEnergy = 2},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 2.05, modifierActive = 4.1, pointsPassive = 25, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 4.1, modifierActive = 8.2, pointsPassive = 50, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 6.15, modifierActive = 12.3, pointsPassive = 75, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 8.2, modifierActive = 16.4, pointsPassive = 100, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 10.25, modifierActive = 20.5, pointsPassive = 125, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 12.3, modifierActive = 24.6, pointsPassive = 150, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 14.35, modifierActive = 28.7, pointsPassive = 175, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 16.4, modifierActive = 32.8, pointsPassive = 200, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 18.45, modifierActive = 36.9, pointsPassive = 225, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 20.5, modifierActive = 41, pointsPassive = 250, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 22.55, modifierActive = 45.1, pointsPassive = 275, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 24.6, modifierActive = 49.2, pointsPassive = 300, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 26.65, modifierActive = 53.3, pointsPassive = 325, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 28.7, modifierActive = 57.4, pointsPassive = 350, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 30.75, modifierActive = 61.5, pointsPassive = 375, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 32.8, modifierActive = 65.6, pointsPassive = 400, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 34.85, modifierActive = 69.7, pointsPassive = 425, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 36.9, modifierActive = 73.8, pointsPassive = 450, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 38.95, modifierActive = 77.9, pointsPassive = 475, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 41, modifierActive = 82, pointsPassive = 500, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Modify the production cost for all units of a player.
    [3] = {
        minLevelPassive     = -6,
        maxLevelPassive     = 20,
        minLevelActive      = 1,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels = {
            [-6] = {modifierPassive = 16, modifierActive = nil, pointsPassive = -150, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = 13.3333333333333, modifierActive = nil, pointsPassive = -125, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = 10.6666666666667, modifierActive = nil, pointsPassive = -100, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = 8, modifierActive = nil, pointsPassive = -75, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = 5.33333333333333, modifierActive = nil, pointsPassive = -50, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = 2.66666666666667, modifierActive = nil, pointsPassive = -25, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = -1.33333333333333, modifierActive = -10, pointsPassive = 25, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = -2.66666666666667, modifierActive = -20, pointsPassive = 50, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = -4, modifierActive = -30, pointsPassive = 75, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = -5.33333333333333, modifierActive = -40, pointsPassive = 100, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = -6.66666666666667, modifierActive = -50, pointsPassive = 125, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = -8, modifierActive = -60, pointsPassive = 150, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = -9.33333333333333, modifierActive = -70, pointsPassive = 175, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = -10.6666666666667, modifierActive = -80, pointsPassive = 200, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = -12, modifierActive = -90, pointsPassive = 225, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = -13.3333333333333, modifierActive = -100, pointsPassive = 250, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = -14.6666666666667, modifierActive = -110, pointsPassive = 275, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = -16, modifierActive = -120, pointsPassive = 300, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = -17.3333333333333, modifierActive = -130, pointsPassive = 325, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = -18.6666666666667, modifierActive = -140, pointsPassive = 350, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = -20, modifierActive = -150, pointsPassive = 375, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = -21.3333333333333, modifierActive = -160, pointsPassive = 400, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = -22.6666666666667, modifierActive = -170, pointsPassive = 425, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = -24, modifierActive = -180, pointsPassive = 450, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = -25.3333333333333, modifierActive = -190, pointsPassive = 475, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = -26.6666666666667, modifierActive = -200, pointsPassive = 500, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Instant: Modify HPs of all units of the currently-in-turn player.
    [4] = {
        minLevelActive      = 1,
        maxLevelActive      = 9,
        modifierUnit = "HP",
        levels = {
            [1] = {modifierPassive = nil, modifierActive = 1, pointsPassive = nil, pointsActive = 150, minEnergy = 1},
            [2] = {modifierPassive = nil, modifierActive = 2, pointsPassive = nil, pointsActive = 275, minEnergy = 2},
            [3] = {modifierPassive = nil, modifierActive = 3, pointsPassive = nil, pointsActive = 400, minEnergy = 3},
            [4] = {modifierPassive = nil, modifierActive = 4, pointsPassive = nil, pointsActive = 500, minEnergy = 4},
            [5] = {modifierPassive = nil, modifierActive = 5, pointsPassive = nil, pointsActive = 575, minEnergy = 5},
            [6] = {modifierPassive = nil, modifierActive = 6, pointsPassive = nil, pointsActive = 650, minEnergy = 6},
            [7] = {modifierPassive = nil, modifierActive = 7, pointsPassive = nil, pointsActive = 700, minEnergy = 7},
            [8] = {modifierPassive = nil, modifierActive = 8, pointsPassive = nil, pointsActive = 725, minEnergy = 8},
            [9] = {modifierPassive = nil, modifierActive = 9, pointsPassive = nil, pointsActive = 750, minEnergy = 9},
        },
    },

    -- Instant: Modify HPs of all units of the opponents.
    [5] = {
        minLevelActive     = 1,
        maxLevelActive     = 9,
        modifierUnit = "HP",
        levels = {
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
            [1] = {modifierPassive = nil, modifierActive = 1, pointsPassive = nil, pointsActive = 175, minEnergy = 2},
            [2] = {modifierPassive = nil, modifierActive = 2, pointsPassive = nil, pointsActive = 350, minEnergy = 4},
            [3] = {modifierPassive = nil, modifierActive = 3, pointsPassive = nil, pointsActive = 525, minEnergy = 6},
            [4] = {modifierPassive = nil, modifierActive = 4, pointsPassive = nil, pointsActive = 700, minEnergy = 8},
            [5] = {modifierPassive = nil, modifierActive = 5, pointsPassive = nil, pointsActive = 875, minEnergy = 10},
        },
    },

    -- Modify max attack range of all indirect units of the owner player.
    [7] = {
        minLevelPassive     = -1,
        maxLevelPassive     = 3,
        minLevelActive      = 1,
        maxLevelActive      = 3,
        modifierUnit = "",
        levels = {
            [-1] = {modifierPassive = -1, modifierActive = nil, pointsPassive = -25, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 1, modifierActive = 1, pointsPassive = 250, pointsActive = 175, minEnergy = 3},
            [2] = {modifierPassive = 2, modifierActive = 2, pointsPassive = 500, pointsActive = 350, minEnergy = 6},
            [3] = {modifierPassive = 3, modifierActive = 3, pointsPassive = 750, pointsActive = 525, minEnergy = 9},
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
            [1] = {modifierPassive = nil, modifierActive = -50, pointsPassive = nil, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = nil, modifierActive = -100, pointsPassive = nil, pointsActive = 100, minEnergy = 2},
            [3] = {modifierPassive = nil, modifierActive = -150, pointsPassive = nil, pointsActive = 150, minEnergy = 3},
            [4] = {modifierPassive = nil, modifierActive = -200, pointsPassive = nil, pointsActive = 200, minEnergy = 4},
            [5] = {modifierPassive = nil, modifierActive = -250, pointsPassive = nil, pointsActive = 250, minEnergy = 5},
            [6] = {modifierPassive = nil, modifierActive = -300, pointsPassive = nil, pointsActive = 300, minEnergy = 6},
            [7] = {modifierPassive = nil, modifierActive = -350, pointsPassive = nil, pointsActive = 350, minEnergy = 7},
            [8] = {modifierPassive = nil, modifierActive = -400, pointsPassive = nil, pointsActive = 400, minEnergy = 8},
            [9] = {modifierPassive = nil, modifierActive = -450, pointsPassive = nil, pointsActive = 450, minEnergy = 9},
            [10] = {modifierPassive = nil, modifierActive = -500, pointsPassive = nil, pointsActive = 500, minEnergy = 10},
        },
    },

    -- Modify the repair amount of buildings of the owner player.
    [10] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 5,
        modifierUnit = "HP",
        levels       = {
            [1] = {modifierPassive = 1, modifierActive = nil, pointsPassive = 50, pointsActive = nil, minEnergy = nil},
            [2] = {modifierPassive = 2, modifierActive = nil, pointsPassive = 75, pointsActive = nil, minEnergy = nil},
            [3] = {modifierPassive = 3, modifierActive = nil, pointsPassive = 100, pointsActive = nil, minEnergy = nil},
            [4] = {modifierPassive = 5, modifierActive = nil, pointsPassive = 125, pointsActive = nil, minEnergy = nil},
            [5] = {modifierPassive = 7, modifierActive = nil, pointsPassive = 150, pointsActive = nil, minEnergy = nil},
        },
    },

    -- Modify the repair cost of the owner player.
    [11] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 10,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = -25, modifierActive = nil, pointsPassive = 25, pointsActive = nil, minEnergy = nil},
            [2] = {modifierPassive = -50, modifierActive = nil, pointsPassive = 50, pointsActive = nil, minEnergy = nil},
            [3] = {modifierPassive = -75, modifierActive = nil, pointsPassive = 75, pointsActive = nil, minEnergy = nil},
            [4] = {modifierPassive = -100, modifierActive = nil, pointsPassive = 100, pointsActive = nil, minEnergy = nil},
            [5] = {modifierPassive = -125, modifierActive = nil, pointsPassive = 125, pointsActive = nil, minEnergy = nil},
            [6] = {modifierPassive = -150, modifierActive = nil, pointsPassive = 150, pointsActive = nil, minEnergy = nil},
            [7] = {modifierPassive = -175, modifierActive = nil, pointsPassive = 175, pointsActive = nil, minEnergy = nil},
            [8] = {modifierPassive = -200, modifierActive = nil, pointsPassive = 200, pointsActive = nil, minEnergy = nil},
            [9] = {modifierPassive = -225, modifierActive = nil, pointsPassive = 225, pointsActive = nil, minEnergy = nil},
            [10] = {modifierPassive = -250, modifierActive = nil, pointsPassive = 250, pointsActive = nil, minEnergy = nil},
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
        minLevelActive     = 1,
        maxLevelActive     = 10,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = nil, modifierActive = -4, pointsPassive = nil, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = nil, modifierActive = -8, pointsPassive = nil, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = nil, modifierActive = -12, pointsPassive = nil, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = nil, modifierActive = -16, pointsPassive = nil, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = nil, modifierActive = -20, pointsPassive = nil, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = nil, modifierActive = -24, pointsPassive = nil, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = nil, modifierActive = -28, pointsPassive = nil, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = nil, modifierActive = -32, pointsPassive = nil, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = nil, modifierActive = -36, pointsPassive = nil, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = nil, modifierActive = -40, pointsPassive = nil, pointsActive = 500, minEnergy = 5},
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
            [1] = {modifierPassive = 2, modifierActive = 7, pointsPassive = 25, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 4, modifierActive = 14, pointsPassive = 50, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 6, modifierActive = 21, pointsPassive = 75, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 8, modifierActive = 28, pointsPassive = 100, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 10, modifierActive = 35, pointsPassive = 125, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 12, modifierActive = 42, pointsPassive = 150, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 14, modifierActive = 49, pointsPassive = 175, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 16, modifierActive = 56, pointsPassive = 200, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 18, modifierActive = 63, pointsPassive = 225, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 20, modifierActive = 70, pointsPassive = 250, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 22, modifierActive = 77, pointsPassive = 275, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 24, modifierActive = 84, pointsPassive = 300, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 26, modifierActive = 91, pointsPassive = 325, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 28, modifierActive = 98, pointsPassive = 350, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 30, modifierActive = 105, pointsPassive = 375, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 32, modifierActive = 112, pointsPassive = 400, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 34, modifierActive = 119, pointsPassive = 425, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 36, modifierActive = 126, pointsPassive = 450, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 38, modifierActive = 133, pointsPassive = 475, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 40, modifierActive = 140, pointsPassive = 500, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Modify the capture speed of the owner player.
    [15] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 11,
        minLevelActive      = 1,
        maxLevelActive      = 6,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = 10, modifierActive = 20, pointsPassive = 25, pointsActive = 25, minEnergy = 1},
            [2] = {modifierPassive = 20, modifierActive = 40, pointsPassive = 50, pointsActive = 50, minEnergy = 2},
            [3] = {modifierPassive = 30, modifierActive = 60, pointsPassive = 75, pointsActive = 75, minEnergy = 3},
            [4] = {modifierPassive = 40, modifierActive = 80, pointsPassive = 100, pointsActive = 100, minEnergy = 4},
            [5] = {modifierPassive = 50, modifierActive = 100, pointsPassive = 125, pointsActive = 300, minEnergy = 6},
            [6] = {modifierPassive = 60, modifierActive = 2000, pointsPassive = 150, pointsActive = 450, minEnergy = 8},
            [7] = {modifierPassive = 70, modifierActive = nil, pointsPassive = 175, pointsActive = nil, minEnergy = nil},
            [8] = {modifierPassive = 80, modifierActive = nil, pointsPassive = 200, pointsActive = nil, minEnergy = nil},
            [9] = {modifierPassive = 90, modifierActive = nil, pointsPassive = 225, pointsActive = nil, minEnergy = nil},
            [10] = {modifierPassive = 100, modifierActive = nil, pointsPassive = 900, pointsActive = nil, minEnergy = nil},
            [11] = {modifierPassive = 2000, modifierActive = nil, pointsPassive = 1500, pointsActive = nil, minEnergy = nil},
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
            [1] = {modifierPassive = 1.25, modifierActive = nil, pointsPassive = 25, pointsActive = nil, minEnergy = nil},
            [2] = {modifierPassive = 2.5, modifierActive = nil, pointsPassive = 50, pointsActive = nil, minEnergy = nil},
            [3] = {modifierPassive = 3.75, modifierActive = nil, pointsPassive = 75, pointsActive = nil, minEnergy = nil},
            [4] = {modifierPassive = 5, modifierActive = nil, pointsPassive = 100, pointsActive = nil, minEnergy = nil},
            [5] = {modifierPassive = 6.25, modifierActive = nil, pointsPassive = 125, pointsActive = nil, minEnergy = nil},
            [6] = {modifierPassive = 7.5, modifierActive = nil, pointsPassive = 150, pointsActive = nil, minEnergy = nil},
            [7] = {modifierPassive = 8.75, modifierActive = nil, pointsPassive = 175, pointsActive = nil, minEnergy = nil},
            [8] = {modifierPassive = 10, modifierActive = nil, pointsPassive = 200, pointsActive = nil, minEnergy = nil},
            [9] = {modifierPassive = 11.25, modifierActive = nil, pointsPassive = 225, pointsActive = nil, minEnergy = nil},
            [10] = {modifierPassive = 12.5, modifierActive = nil, pointsPassive = 250, pointsActive = nil, minEnergy = nil},
            [11] = {modifierPassive = 13.75, modifierActive = nil, pointsPassive = 275, pointsActive = nil, minEnergy = nil},
            [12] = {modifierPassive = 15, modifierActive = nil, pointsPassive = 300, pointsActive = nil, minEnergy = nil},
            [13] = {modifierPassive = 16.25, modifierActive = nil, pointsPassive = 325, pointsActive = nil, minEnergy = nil},
            [14] = {modifierPassive = 17.5, modifierActive = nil, pointsPassive = 350, pointsActive = nil, minEnergy = nil},
            [15] = {modifierPassive = 18.75, modifierActive = nil, pointsPassive = 375, pointsActive = nil, minEnergy = nil},
            [16] = {modifierPassive = 20, modifierActive = nil, pointsPassive = 400, pointsActive = nil, minEnergy = nil},
            [17] = {modifierPassive = 21.25, modifierActive = nil, pointsPassive = 425, pointsActive = nil, minEnergy = nil},
            [18] = {modifierPassive = 22.5, modifierActive = nil, pointsPassive = 450, pointsActive = nil, minEnergy = nil},
            [19] = {modifierPassive = 23.75, modifierActive = nil, pointsPassive = 475, pointsActive = nil, minEnergy = nil},
            [20] = {modifierPassive = 25, modifierActive = nil, pointsPassive = 500, pointsActive = nil, minEnergy = nil},
        },
    },

    -- Stop the damage cost per the energy requirement from increasing as skills are activated.
    [18] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 1,
        modifierUnit = "",
        levels       = {
            [1] = {modifierPassive = nil, modifierActive = nil, pointsPassive = 125, pointsActive = nil, minEnergy = nil},
        },
    },

    -- Modify the growth rate of the energy of the owner player.
    [19] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 20,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = 6, modifierActive = nil, pointsPassive = 25, pointsActive = nil, minEnergy = nil},
            [2] = {modifierPassive = 12, modifierActive = nil, pointsPassive = 50, pointsActive = nil, minEnergy = nil},
            [3] = {modifierPassive = 18, modifierActive = nil, pointsPassive = 75, pointsActive = nil, minEnergy = nil},
            [4] = {modifierPassive = 24, modifierActive = nil, pointsPassive = 100, pointsActive = nil, minEnergy = nil},
            [5] = {modifierPassive = 30, modifierActive = nil, pointsPassive = 125, pointsActive = nil, minEnergy = nil},
            [6] = {modifierPassive = 36, modifierActive = nil, pointsPassive = 150, pointsActive = nil, minEnergy = nil},
            [7] = {modifierPassive = 42, modifierActive = nil, pointsPassive = 175, pointsActive = nil, minEnergy = nil},
            [8] = {modifierPassive = 48, modifierActive = nil, pointsPassive = 200, pointsActive = nil, minEnergy = nil},
            [9] = {modifierPassive = 54, modifierActive = nil, pointsPassive = 225, pointsActive = nil, minEnergy = nil},
            [10] = {modifierPassive = 60, modifierActive = nil, pointsPassive = 250, pointsActive = nil, minEnergy = nil},
            [11] = {modifierPassive = 66, modifierActive = nil, pointsPassive = 275, pointsActive = nil, minEnergy = nil},
            [12] = {modifierPassive = 72, modifierActive = nil, pointsPassive = 300, pointsActive = nil, minEnergy = nil},
            [13] = {modifierPassive = 78, modifierActive = nil, pointsPassive = 325, pointsActive = nil, minEnergy = nil},
            [14] = {modifierPassive = 84, modifierActive = nil, pointsPassive = 350, pointsActive = nil, minEnergy = nil},
            [15] = {modifierPassive = 90, modifierActive = nil, pointsPassive = 375, pointsActive = nil, minEnergy = nil},
            [16] = {modifierPassive = 96, modifierActive = nil, pointsPassive = 400, pointsActive = nil, minEnergy = nil},
            [17] = {modifierPassive = 102, modifierActive = nil, pointsPassive = 425, pointsActive = nil, minEnergy = nil},
            [18] = {modifierPassive = 108, modifierActive = nil, pointsPassive = 450, pointsActive = nil, minEnergy = nil},
            [19] = {modifierPassive = 114, modifierActive = nil, pointsPassive = 475, pointsActive = nil, minEnergy = nil},
            [20] = {modifierPassive = 120, modifierActive = nil, pointsPassive = 500, pointsActive = nil, minEnergy = nil},
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
            [1] = {modifierPassive = 0.75, modifierActive = 2.5, pointsPassive = 25, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 1.5, modifierActive = 5, pointsPassive = 50, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 2.25, modifierActive = 7.5, pointsPassive = 75, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 3, modifierActive = 10, pointsPassive = 100, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 3.75, modifierActive = 12.5, pointsPassive = 125, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 4.5, modifierActive = 15, pointsPassive = 150, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 5.25, modifierActive = 17.5, pointsPassive = 175, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 6, modifierActive = 20, pointsPassive = 200, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 6.75, modifierActive = 22.5, pointsPassive = 225, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 7.5, modifierActive = 25, pointsPassive = 250, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 8.25, modifierActive = 27.5, pointsPassive = 275, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 9, modifierActive = 30, pointsPassive = 300, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 9.75, modifierActive = 32.5, pointsPassive = 325, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 10.5, modifierActive = 35, pointsPassive = 350, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 11.25, modifierActive = 37.5, pointsPassive = 375, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 12, modifierActive = 40, pointsPassive = 400, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 12.75, modifierActive = 42.5, pointsPassive = 425, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 13.5, modifierActive = 45, pointsPassive = 450, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 14.25, modifierActive = 47.5, pointsPassive = 475, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 15, modifierActive = 50, pointsPassive = 500, pointsActive = 1000, minEnergy = 10},
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
            [1] = {modifierPassive = 0.75, modifierActive = 2.5, pointsPassive = 25, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 1.5, modifierActive = 5, pointsPassive = 50, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 2.25, modifierActive = 7.5, pointsPassive = 75, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 3, modifierActive = 10, pointsPassive = 100, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 3.75, modifierActive = 12.5, pointsPassive = 125, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 4.5, modifierActive = 15, pointsPassive = 150, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 5.25, modifierActive = 17.5, pointsPassive = 175, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 6, modifierActive = 20, pointsPassive = 200, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 6.75, modifierActive = 22.5, pointsPassive = 225, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 7.5, modifierActive = 25, pointsPassive = 250, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 8.25, modifierActive = 27.5, pointsPassive = 275, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 9, modifierActive = 30, pointsPassive = 300, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 9.75, modifierActive = 32.5, pointsPassive = 325, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 10.5, modifierActive = 35, pointsPassive = 350, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 11.25, modifierActive = 37.5, pointsPassive = 375, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 12, modifierActive = 40, pointsPassive = 400, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 12.75, modifierActive = 42.5, pointsPassive = 425, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 13.5, modifierActive = 45, pointsPassive = 450, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 14.25, modifierActive = 47.5, pointsPassive = 475, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 15, modifierActive = 50, pointsPassive = 500, pointsActive = 1000, minEnergy = 10},
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
            [1] = {modifierPassive = 1.75, modifierActive = 7, pointsPassive = 25, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 3.5, modifierActive = 14, pointsPassive = 50, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 5.25, modifierActive = 21, pointsPassive = 75, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 7, modifierActive = 28, pointsPassive = 100, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 8.75, modifierActive = 35, pointsPassive = 125, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 10.5, modifierActive = 42, pointsPassive = 150, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 12.25, modifierActive = 49, pointsPassive = 175, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 14, modifierActive = 56, pointsPassive = 200, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 15.75, modifierActive = 63, pointsPassive = 225, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 17.5, modifierActive = 70, pointsPassive = 250, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 19.25, modifierActive = 77, pointsPassive = 275, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 21, modifierActive = 84, pointsPassive = 300, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 22.75, modifierActive = 91, pointsPassive = 325, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 24.5, modifierActive = 98, pointsPassive = 350, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 26.25, modifierActive = 105, pointsPassive = 375, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 28, modifierActive = 112, pointsPassive = 400, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 29.75, modifierActive = 119, pointsPassive = 425, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 31.5, modifierActive = 126, pointsPassive = 450, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 33.25, modifierActive = 133, pointsPassive = 475, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 35, modifierActive = 140, pointsPassive = 500, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Tiles offer addional attack power for units on it, according to the base defense bonus.
    [23] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 20,
        minLevelActive      = 1,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = 1.35, modifierActive = 2.7, pointsPassive = 25, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 2.7, modifierActive = 5.4, pointsPassive = 50, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 4.05, modifierActive = 8.1, pointsPassive = 75, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 5.4, modifierActive = 10.8, pointsPassive = 100, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 6.75, modifierActive = 13.5, pointsPassive = 125, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 8.1, modifierActive = 16.2, pointsPassive = 150, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 9.45, modifierActive = 18.9, pointsPassive = 175, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 10.8, modifierActive = 21.6, pointsPassive = 200, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 12.15, modifierActive = 24.3, pointsPassive = 225, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 13.5, modifierActive = 27, pointsPassive = 250, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 14.85, modifierActive = 29.7, pointsPassive = 275, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 16.2, modifierActive = 32.4, pointsPassive = 300, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 17.55, modifierActive = 35.1, pointsPassive = 325, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 18.9, modifierActive = 37.8, pointsPassive = 350, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 20.25, modifierActive = 40.5, pointsPassive = 375, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 21.6, modifierActive = 43.2, pointsPassive = 400, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 22.95, modifierActive = 45.9, pointsPassive = 425, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 24.3, modifierActive = 48.6, pointsPassive = 450, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 25.65, modifierActive = 51.3, pointsPassive = 475, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 27, modifierActive = 54, pointsPassive = 500, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Tiles offer addional defense power for units on it, according to the base defense bonus.
    [24] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 20,
        minLevelActive      = 1,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = 1.4, modifierActive = 2.8, pointsPassive = 25, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 2.8, modifierActive = 5.6, pointsPassive = 50, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 4.2, modifierActive = 8.4, pointsPassive = 75, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 5.6, modifierActive = 11.2, pointsPassive = 100, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 7, modifierActive = 14, pointsPassive = 125, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 8.4, modifierActive = 16.8, pointsPassive = 150, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 9.8, modifierActive = 19.6, pointsPassive = 175, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 11.2, modifierActive = 22.4, pointsPassive = 200, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 12.6, modifierActive = 25.2, pointsPassive = 225, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 14, modifierActive = 28, pointsPassive = 250, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 15.4, modifierActive = 30.8, pointsPassive = 275, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 16.8, modifierActive = 33.6, pointsPassive = 300, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 18.2, modifierActive = 36.4, pointsPassive = 325, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 19.6, modifierActive = 39.2, pointsPassive = 350, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 21, modifierActive = 42, pointsPassive = 375, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 22.4, modifierActive = 44.8, pointsPassive = 400, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 23.8, modifierActive = 47.6, pointsPassive = 425, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 25.2, modifierActive = 50.4, pointsPassive = 450, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 26.6, modifierActive = 53.2, pointsPassive = 475, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 28, modifierActive = 56, pointsPassive = 500, pointsActive = 1000, minEnergy = 10},
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
            [1] = {modifierPassive = 2, modifierActive = 7, pointsPassive = 25, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 4, modifierActive = 14, pointsPassive = 50, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 6, modifierActive = 21, pointsPassive = 75, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 8, modifierActive = 28, pointsPassive = 100, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 10, modifierActive = 35, pointsPassive = 125, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 12, modifierActive = 42, pointsPassive = 150, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 14, modifierActive = 49, pointsPassive = 175, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 16, modifierActive = 56, pointsPassive = 200, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 18, modifierActive = 63, pointsPassive = 225, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 20, modifierActive = 70, pointsPassive = 250, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 22, modifierActive = 77, pointsPassive = 275, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 24, modifierActive = 84, pointsPassive = 300, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 26, modifierActive = 91, pointsPassive = 325, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 28, modifierActive = 98, pointsPassive = 350, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 30, modifierActive = 105, pointsPassive = 375, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 32, modifierActive = 112, pointsPassive = 400, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 34, modifierActive = 119, pointsPassive = 425, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 36, modifierActive = 126, pointsPassive = 450, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 38, modifierActive = 133, pointsPassive = 475, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 40, modifierActive = 140, pointsPassive = 500, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Modify the promotion of the units of the owner player.
    [26] = {
        minLevelActive     = 1,
        maxLevelActive     = 3,
        modifierUnit = "",
        levels       = {
            [1] = {modifierPassive = nil, modifierActive = 1, pointsPassive = nil, pointsActive = 150, minEnergy = 1},
            [2] = {modifierPassive = nil, modifierActive = 2, pointsPassive = nil, pointsActive = 375, minEnergy = 2},
            [3] = {modifierPassive = nil, modifierActive = 3, pointsPassive = nil, pointsActive = 525, minEnergy = 4},
        },
    },

    -- Modify the promotion of the newly produced units of the owner player.
    [27] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 3,
        modifierUnit = "",
        levels       = {
            [1] = {modifierPassive = 1, modifierActive = nil, pointsPassive = 75, pointsActive = nil, minEnergy = nil},
            [2] = {modifierPassive = 2, modifierActive = nil, pointsPassive = 200, pointsActive = nil, minEnergy = nil},
            [3] = {modifierPassive = 3, modifierActive = nil, pointsPassive = 425, pointsActive = nil, minEnergy = nil},
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
            [1] = {modifierPassive = nil, modifierActive = nil, pointsPassive = 225, pointsActive = 125, minEnergy = 2},
        },
    },

    -- Modify the attack of the direct units.
    [29] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 20,
        minLevelActive      = 1,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels       = {
            [-6] = {modifierPassive = -30, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 2.1, modifierActive = 4.2, pointsPassive = 25, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 4.2, modifierActive = 8.4, pointsPassive = 50, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 6.3, modifierActive = 12.6, pointsPassive = 75, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 8.4, modifierActive = 16.8, pointsPassive = 100, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 10.5, modifierActive = 21, pointsPassive = 125, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 12.6, modifierActive = 25.2, pointsPassive = 150, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 14.7, modifierActive = 29.4, pointsPassive = 175, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 16.8, modifierActive = 33.6, pointsPassive = 200, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 18.9, modifierActive = 37.8, pointsPassive = 225, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 21, modifierActive = 42, pointsPassive = 250, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 23.1, modifierActive = 46.2, pointsPassive = 275, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 25.2, modifierActive = 50.4, pointsPassive = 300, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 27.3, modifierActive = 54.6, pointsPassive = 325, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 29.4, modifierActive = 58.8, pointsPassive = 350, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 31.5, modifierActive = 63, pointsPassive = 375, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 33.6, modifierActive = 67.2, pointsPassive = 400, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 35.7, modifierActive = 71.4, pointsPassive = 425, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 37.8, modifierActive = 75.6, pointsPassive = 450, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 39.9, modifierActive = 79.8, pointsPassive = 475, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 42, modifierActive = 84, pointsPassive = 500, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Modify the attack of the indirect units.
    [30] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 20,
        minLevelActive      = 1,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels       = {
            [-6] = {modifierPassive = -30, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 2.4, modifierActive = 4.8, pointsPassive = 25, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 4.8, modifierActive = 9.6, pointsPassive = 50, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 7.2, modifierActive = 14.4, pointsPassive = 75, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 9.6, modifierActive = 19.2, pointsPassive = 100, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 12, modifierActive = 24, pointsPassive = 125, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 14.4, modifierActive = 28.8, pointsPassive = 150, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 16.8, modifierActive = 33.6, pointsPassive = 175, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 19.2, modifierActive = 38.4, pointsPassive = 200, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 21.6, modifierActive = 43.2, pointsPassive = 225, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 24, modifierActive = 48, pointsPassive = 250, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 26.4, modifierActive = 52.8, pointsPassive = 275, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 28.8, modifierActive = 57.6, pointsPassive = 300, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 31.2, modifierActive = 62.4, pointsPassive = 325, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 33.6, modifierActive = 67.2, pointsPassive = 350, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 36, modifierActive = 72, pointsPassive = 375, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 38.4, modifierActive = 76.8, pointsPassive = 400, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 40.8, modifierActive = 81.6, pointsPassive = 425, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 43.2, modifierActive = 86.4, pointsPassive = 450, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 45.6, modifierActive = 91.2, pointsPassive = 475, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 48, modifierActive = 96, pointsPassive = 500, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Modify the attack of the ground units.
    [31] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 20,
        minLevelActive      = 1,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels       = {
            [-6] = {modifierPassive = -30, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 2.1, modifierActive = 4.2, pointsPassive = 25, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 4.2, modifierActive = 8.4, pointsPassive = 50, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 6.3, modifierActive = 12.6, pointsPassive = 75, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 8.4, modifierActive = 16.8, pointsPassive = 100, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 10.5, modifierActive = 21, pointsPassive = 125, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 12.6, modifierActive = 25.2, pointsPassive = 150, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 14.7, modifierActive = 29.4, pointsPassive = 175, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 16.8, modifierActive = 33.6, pointsPassive = 200, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 18.9, modifierActive = 37.8, pointsPassive = 225, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 21, modifierActive = 42, pointsPassive = 250, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 23.1, modifierActive = 46.2, pointsPassive = 275, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 25.2, modifierActive = 50.4, pointsPassive = 300, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 27.3, modifierActive = 54.6, pointsPassive = 325, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 29.4, modifierActive = 58.8, pointsPassive = 350, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 31.5, modifierActive = 63, pointsPassive = 375, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 33.6, modifierActive = 67.2, pointsPassive = 400, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 35.7, modifierActive = 71.4, pointsPassive = 425, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 37.8, modifierActive = 75.6, pointsPassive = 450, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 39.9, modifierActive = 79.8, pointsPassive = 475, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 42, modifierActive = 84, pointsPassive = 500, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Modify the attack of the air units.
    [32] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 20,
        minLevelActive      = 1,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels       = {
            [-6] = {modifierPassive = -30, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 2.5, modifierActive = 5, pointsPassive = 25, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 5, modifierActive = 10, pointsPassive = 50, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 7.5, modifierActive = 15, pointsPassive = 75, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 10, modifierActive = 20, pointsPassive = 100, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 12.5, modifierActive = 25, pointsPassive = 125, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 15, modifierActive = 30, pointsPassive = 150, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 17.5, modifierActive = 35, pointsPassive = 175, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 20, modifierActive = 40, pointsPassive = 200, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 22.5, modifierActive = 45, pointsPassive = 225, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 25, modifierActive = 50, pointsPassive = 250, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 27.5, modifierActive = 55, pointsPassive = 275, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 30, modifierActive = 60, pointsPassive = 300, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 32.5, modifierActive = 65, pointsPassive = 325, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 35, modifierActive = 70, pointsPassive = 350, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 37.5, modifierActive = 75, pointsPassive = 375, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 40, modifierActive = 80, pointsPassive = 400, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 42.5, modifierActive = 85, pointsPassive = 425, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 45, modifierActive = 90, pointsPassive = 450, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 47.5, modifierActive = 95, pointsPassive = 475, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 50, modifierActive = 100, pointsPassive = 500, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Modify the attack of the naval units.
    [33] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 20,
        minLevelActive      = 1,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels       = {
            [-6] = {modifierPassive = -30, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 2.5, modifierActive = 5, pointsPassive = 25, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 5, modifierActive = 10, pointsPassive = 50, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 7.5, modifierActive = 15, pointsPassive = 75, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 10, modifierActive = 20, pointsPassive = 100, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 12.5, modifierActive = 25, pointsPassive = 125, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 15, modifierActive = 30, pointsPassive = 150, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 17.5, modifierActive = 35, pointsPassive = 175, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 20, modifierActive = 40, pointsPassive = 200, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 22.5, modifierActive = 45, pointsPassive = 225, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 25, modifierActive = 50, pointsPassive = 250, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 27.5, modifierActive = 55, pointsPassive = 275, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 30, modifierActive = 60, pointsPassive = 300, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 32.5, modifierActive = 65, pointsPassive = 325, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 35, modifierActive = 70, pointsPassive = 350, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 37.5, modifierActive = 75, pointsPassive = 375, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 40, modifierActive = 80, pointsPassive = 400, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 42.5, modifierActive = 85, pointsPassive = 425, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 45, modifierActive = 90, pointsPassive = 450, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 47.5, modifierActive = 95, pointsPassive = 475, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 50, modifierActive = 100, pointsPassive = 500, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Modify the attack of the infantry units, including Infantry, Mech and Bike.
    [34] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 20,
        minLevelActive      = 1,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels       = {
            [-6] = {modifierPassive = -30, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 3, modifierActive = 6, pointsPassive = 25, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 6, modifierActive = 12, pointsPassive = 50, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 9, modifierActive = 18, pointsPassive = 75, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 12, modifierActive = 24, pointsPassive = 100, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 15, modifierActive = 30, pointsPassive = 125, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 18, modifierActive = 36, pointsPassive = 150, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 21, modifierActive = 42, pointsPassive = 175, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 24, modifierActive = 48, pointsPassive = 200, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 27, modifierActive = 54, pointsPassive = 225, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 30, modifierActive = 60, pointsPassive = 250, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 33, modifierActive = 66, pointsPassive = 275, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 36, modifierActive = 72, pointsPassive = 300, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 39, modifierActive = 78, pointsPassive = 325, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 42, modifierActive = 84, pointsPassive = 350, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 45, modifierActive = 90, pointsPassive = 375, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 48, modifierActive = 96, pointsPassive = 400, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 51, modifierActive = 102, pointsPassive = 425, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 54, modifierActive = 108, pointsPassive = 450, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 57, modifierActive = 114, pointsPassive = 475, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 60, modifierActive = 120, pointsPassive = 500, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Modify the attack of the vehicle units.
    [35] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 20,
        minLevelActive      = 1,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels       = {
            [-6] = {modifierPassive = -30, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 2.3, modifierActive = 4.6, pointsPassive = 25, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 4.6, modifierActive = 9.2, pointsPassive = 50, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 6.9, modifierActive = 13.8, pointsPassive = 75, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 9.2, modifierActive = 18.4, pointsPassive = 100, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 11.5, modifierActive = 23, pointsPassive = 125, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 13.8, modifierActive = 27.6, pointsPassive = 150, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 16.1, modifierActive = 32.2, pointsPassive = 175, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 18.4, modifierActive = 36.8, pointsPassive = 200, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 20.7, modifierActive = 41.4, pointsPassive = 225, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 23, modifierActive = 46, pointsPassive = 250, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 25.3, modifierActive = 50.6, pointsPassive = 275, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 27.6, modifierActive = 55.2, pointsPassive = 300, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 29.9, modifierActive = 59.8, pointsPassive = 325, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 32.2, modifierActive = 64.4, pointsPassive = 350, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 34.5, modifierActive = 69, pointsPassive = 375, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 36.8, modifierActive = 73.6, pointsPassive = 400, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 39.1, modifierActive = 78.2, pointsPassive = 425, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 41.4, modifierActive = 82.8, pointsPassive = 450, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 43.7, modifierActive = 87.4, pointsPassive = 475, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 46, modifierActive = 92, pointsPassive = 500, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Modify the attack of direct non-infantry units.
    [36] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 20,
        minLevelActive      = 1,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels       = {
            [-6] = {modifierPassive = -30, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 2.3, modifierActive = 4.6, pointsPassive = 25, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 4.6, modifierActive = 9.2, pointsPassive = 50, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 6.9, modifierActive = 13.8, pointsPassive = 75, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 9.2, modifierActive = 18.4, pointsPassive = 100, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 11.5, modifierActive = 23, pointsPassive = 125, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 13.8, modifierActive = 27.6, pointsPassive = 150, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 16.1, modifierActive = 32.2, pointsPassive = 175, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 18.4, modifierActive = 36.8, pointsPassive = 200, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 20.7, modifierActive = 41.4, pointsPassive = 225, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 23, modifierActive = 46, pointsPassive = 250, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 25.3, modifierActive = 50.6, pointsPassive = 275, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 27.6, modifierActive = 55.2, pointsPassive = 300, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 29.9, modifierActive = 59.8, pointsPassive = 325, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 32.2, modifierActive = 64.4, pointsPassive = 350, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 34.5, modifierActive = 69, pointsPassive = 375, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 36.8, modifierActive = 73.6, pointsPassive = 400, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 39.1, modifierActive = 78.2, pointsPassive = 425, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 41.4, modifierActive = 82.8, pointsPassive = 450, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 43.7, modifierActive = 87.4, pointsPassive = 475, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 46, modifierActive = 92, pointsPassive = 500, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Modify the defense of the direct units.
    [37] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 20,
        minLevelActive      = 1,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels       = {
            [-6] = {modifierPassive = -30, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 2.15, modifierActive = 4.3, pointsPassive = 25, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 4.3, modifierActive = 8.6, pointsPassive = 50, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 6.45, modifierActive = 12.9, pointsPassive = 75, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 8.6, modifierActive = 17.2, pointsPassive = 100, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 10.75, modifierActive = 21.5, pointsPassive = 125, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 12.9, modifierActive = 25.8, pointsPassive = 150, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 15.05, modifierActive = 30.1, pointsPassive = 175, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 17.2, modifierActive = 34.4, pointsPassive = 200, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 19.35, modifierActive = 38.7, pointsPassive = 225, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 21.5, modifierActive = 43, pointsPassive = 250, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 23.65, modifierActive = 47.3, pointsPassive = 275, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 25.8, modifierActive = 51.6, pointsPassive = 300, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 27.95, modifierActive = 55.9, pointsPassive = 325, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 30.1, modifierActive = 60.2, pointsPassive = 350, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 32.25, modifierActive = 64.5, pointsPassive = 375, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 34.4, modifierActive = 68.8, pointsPassive = 400, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 36.55, modifierActive = 73.1, pointsPassive = 425, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 38.7, modifierActive = 77.4, pointsPassive = 450, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 40.85, modifierActive = 81.7, pointsPassive = 475, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 43, modifierActive = 86, pointsPassive = 500, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Modify the defense of the indirect units.
    [38] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 20,
        minLevelActive      = 1,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels       = {
            [-6] = {modifierPassive = -30, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 2.5, modifierActive = 5, pointsPassive = 25, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 5, modifierActive = 10, pointsPassive = 50, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 7.5, modifierActive = 15, pointsPassive = 75, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 10, modifierActive = 20, pointsPassive = 100, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 12.5, modifierActive = 25, pointsPassive = 125, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 15, modifierActive = 30, pointsPassive = 150, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 17.5, modifierActive = 35, pointsPassive = 175, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 20, modifierActive = 40, pointsPassive = 200, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 22.5, modifierActive = 45, pointsPassive = 225, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 25, modifierActive = 50, pointsPassive = 250, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 27.5, modifierActive = 55, pointsPassive = 275, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 30, modifierActive = 60, pointsPassive = 300, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 32.5, modifierActive = 65, pointsPassive = 325, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 35, modifierActive = 70, pointsPassive = 350, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 37.5, modifierActive = 75, pointsPassive = 375, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 40, modifierActive = 80, pointsPassive = 400, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 42.5, modifierActive = 85, pointsPassive = 425, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 45, modifierActive = 90, pointsPassive = 450, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 47.5, modifierActive = 95, pointsPassive = 475, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 50, modifierActive = 100, pointsPassive = 500, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Modify the defense of the ground units.
    [39] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 20,
        minLevelActive      = 1,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels       = {
            [-6] = {modifierPassive = -30, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 2.2, modifierActive = 4.4, pointsPassive = 25, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 4.4, modifierActive = 8.8, pointsPassive = 50, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 6.6, modifierActive = 13.2, pointsPassive = 75, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 8.8, modifierActive = 17.6, pointsPassive = 100, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 11, modifierActive = 22, pointsPassive = 125, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 13.2, modifierActive = 26.4, pointsPassive = 150, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 15.4, modifierActive = 30.8, pointsPassive = 175, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 17.6, modifierActive = 35.2, pointsPassive = 200, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 19.8, modifierActive = 39.6, pointsPassive = 225, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 22, modifierActive = 44, pointsPassive = 250, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 24.2, modifierActive = 48.4, pointsPassive = 275, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 26.4, modifierActive = 52.8, pointsPassive = 300, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 28.6, modifierActive = 57.2, pointsPassive = 325, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 30.8, modifierActive = 61.6, pointsPassive = 350, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 33, modifierActive = 66, pointsPassive = 375, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 35.2, modifierActive = 70.4, pointsPassive = 400, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 37.4, modifierActive = 74.8, pointsPassive = 425, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 39.6, modifierActive = 79.2, pointsPassive = 450, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 41.8, modifierActive = 83.6, pointsPassive = 475, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 44, modifierActive = 88, pointsPassive = 500, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Modify the defense of the air units.
    [40] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 20,
        minLevelActive      = 1,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels       = {
            [-6] = {modifierPassive = -30, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 2.5, modifierActive = 5, pointsPassive = 25, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 5, modifierActive = 10, pointsPassive = 50, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 7.5, modifierActive = 15, pointsPassive = 75, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 10, modifierActive = 20, pointsPassive = 100, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 12.5, modifierActive = 25, pointsPassive = 125, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 15, modifierActive = 30, pointsPassive = 150, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 17.5, modifierActive = 35, pointsPassive = 175, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 20, modifierActive = 40, pointsPassive = 200, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 22.5, modifierActive = 45, pointsPassive = 225, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 25, modifierActive = 50, pointsPassive = 250, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 27.5, modifierActive = 55, pointsPassive = 275, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 30, modifierActive = 60, pointsPassive = 300, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 32.5, modifierActive = 65, pointsPassive = 325, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 35, modifierActive = 70, pointsPassive = 350, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 37.5, modifierActive = 75, pointsPassive = 375, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 40, modifierActive = 80, pointsPassive = 400, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 42.5, modifierActive = 85, pointsPassive = 425, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 45, modifierActive = 90, pointsPassive = 450, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 47.5, modifierActive = 95, pointsPassive = 475, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 50, modifierActive = 100, pointsPassive = 500, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Modify the defense of the naval units.
    [41] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 20,
        minLevelActive      = 1,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels       = {
            [-6] = {modifierPassive = -30, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 2.5, modifierActive = 5, pointsPassive = 25, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 5, modifierActive = 10, pointsPassive = 50, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 7.5, modifierActive = 15, pointsPassive = 75, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 10, modifierActive = 20, pointsPassive = 100, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 12.5, modifierActive = 25, pointsPassive = 125, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 15, modifierActive = 30, pointsPassive = 150, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 17.5, modifierActive = 35, pointsPassive = 175, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 20, modifierActive = 40, pointsPassive = 200, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 22.5, modifierActive = 45, pointsPassive = 225, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 25, modifierActive = 50, pointsPassive = 250, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 27.5, modifierActive = 55, pointsPassive = 275, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 30, modifierActive = 60, pointsPassive = 300, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 32.5, modifierActive = 65, pointsPassive = 325, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 35, modifierActive = 70, pointsPassive = 350, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 37.5, modifierActive = 75, pointsPassive = 375, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 40, modifierActive = 80, pointsPassive = 400, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 42.5, modifierActive = 85, pointsPassive = 425, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 45, modifierActive = 90, pointsPassive = 450, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 47.5, modifierActive = 95, pointsPassive = 475, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 50, modifierActive = 100, pointsPassive = 500, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Modify the defense of the infantry units, including Infantry, Mech and Bike.
    [42] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 20,
        minLevelActive      = 1,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels       = {
            [-6] = {modifierPassive = -30, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 3, modifierActive = 6, pointsPassive = 25, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 6, modifierActive = 12, pointsPassive = 50, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 9, modifierActive = 18, pointsPassive = 75, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 12, modifierActive = 24, pointsPassive = 100, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 15, modifierActive = 30, pointsPassive = 125, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 18, modifierActive = 36, pointsPassive = 150, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 21, modifierActive = 42, pointsPassive = 175, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 24, modifierActive = 48, pointsPassive = 200, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 27, modifierActive = 54, pointsPassive = 225, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 30, modifierActive = 60, pointsPassive = 250, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 33, modifierActive = 66, pointsPassive = 275, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 36, modifierActive = 72, pointsPassive = 300, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 39, modifierActive = 78, pointsPassive = 325, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 42, modifierActive = 84, pointsPassive = 350, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 45, modifierActive = 90, pointsPassive = 375, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 48, modifierActive = 96, pointsPassive = 400, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 51, modifierActive = 102, pointsPassive = 425, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 54, modifierActive = 108, pointsPassive = 450, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 57, modifierActive = 114, pointsPassive = 475, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 60, modifierActive = 120, pointsPassive = 500, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Modify the defense of the vehicle units.
    [43] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 20,
        minLevelActive      = 1,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels       = {
            [-6] = {modifierPassive = -30, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 2.4, modifierActive = 4.8, pointsPassive = 25, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 4.8, modifierActive = 9.6, pointsPassive = 50, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 7.2, modifierActive = 14.4, pointsPassive = 75, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 9.6, modifierActive = 19.2, pointsPassive = 100, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 12, modifierActive = 24, pointsPassive = 125, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 14.4, modifierActive = 28.8, pointsPassive = 150, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 16.8, modifierActive = 33.6, pointsPassive = 175, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 19.2, modifierActive = 38.4, pointsPassive = 200, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 21.6, modifierActive = 43.2, pointsPassive = 225, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 24, modifierActive = 48, pointsPassive = 250, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 26.4, modifierActive = 52.8, pointsPassive = 275, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 28.8, modifierActive = 57.6, pointsPassive = 300, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 31.2, modifierActive = 62.4, pointsPassive = 325, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 33.6, modifierActive = 67.2, pointsPassive = 350, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 36, modifierActive = 72, pointsPassive = 375, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 38.4, modifierActive = 76.8, pointsPassive = 400, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 40.8, modifierActive = 81.6, pointsPassive = 425, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 43.2, modifierActive = 86.4, pointsPassive = 450, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 45.6, modifierActive = 91.2, pointsPassive = 475, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 48, modifierActive = 96, pointsPassive = 500, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Modify the defense of direct non-infantry units.
    [44] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 20,
        minLevelActive      = 1,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels       = {
            [-6] = {modifierPassive = -30, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 2.35, modifierActive = 4.7, pointsPassive = 25, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 4.7, modifierActive = 9.4, pointsPassive = 50, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 7.05, modifierActive = 14.1, pointsPassive = 75, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 9.4, modifierActive = 18.8, pointsPassive = 100, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 11.75, modifierActive = 23.5, pointsPassive = 125, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 14.1, modifierActive = 28.2, pointsPassive = 150, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 16.45, modifierActive = 32.9, pointsPassive = 175, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 18.8, modifierActive = 37.6, pointsPassive = 200, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 21.15, modifierActive = 42.3, pointsPassive = 225, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 23.5, modifierActive = 47, pointsPassive = 250, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 25.85, modifierActive = 51.7, pointsPassive = 275, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 28.2, modifierActive = 56.4, pointsPassive = 300, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 30.55, modifierActive = 61.1, pointsPassive = 325, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 32.9, modifierActive = 65.8, pointsPassive = 350, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 35.25, modifierActive = 70.5, pointsPassive = 375, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 37.6, modifierActive = 75.2, pointsPassive = 400, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 39.95, modifierActive = 79.9, pointsPassive = 425, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 42.3, modifierActive = 84.6, pointsPassive = 450, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 44.65, modifierActive = 89.3, pointsPassive = 475, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 47, modifierActive = 94, pointsPassive = 500, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Modify the defense of the transport units.
    [45] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 20,
        minLevelActive      = 1,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels       = {
            [-6] = {modifierPassive = -30, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, modifierActive = nil, pointsPassive = 0, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, modifierActive = 0, pointsPassive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 15, modifierActive = 30, pointsPassive = 25, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 30, modifierActive = 60, pointsPassive = 50, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 45, modifierActive = 90, pointsPassive = 75, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 60, modifierActive = 120, pointsPassive = 100, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 75, modifierActive = 150, pointsPassive = 125, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 90, modifierActive = 180, pointsPassive = 150, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 105, modifierActive = 210, pointsPassive = 175, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 120, modifierActive = 240, pointsPassive = 200, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 135, modifierActive = 270, pointsPassive = 225, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 150, modifierActive = 300, pointsPassive = 250, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 165, modifierActive = 330, pointsPassive = 275, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 180, modifierActive = 360, pointsPassive = 300, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 195, modifierActive = 390, pointsPassive = 325, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 210, modifierActive = 420, pointsPassive = 350, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 225, modifierActive = 450, pointsPassive = 375, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 240, modifierActive = 480, pointsPassive = 400, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 255, modifierActive = 510, pointsPassive = 425, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 270, modifierActive = 540, pointsPassive = 450, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 285, modifierActive = 570, pointsPassive = 475, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 300, modifierActive = 600, pointsPassive = 500, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Modify movements of direct units of the owner player.
    [46] = {
        minLevelActive     = 1,
        maxLevelActive     = 5,
        modifierUnit = "",
        levels = {
            [1] = {modifierPassive = nil, modifierActive = 1, pointsPassive = nil, pointsActive = 175, minEnergy = 1},
            [2] = {modifierPassive = nil, modifierActive = 2, pointsPassive = nil, pointsActive = 350, minEnergy = 3},
            [3] = {modifierPassive = nil, modifierActive = 3, pointsPassive = nil, pointsActive = 525, minEnergy = 5},
            [4] = {modifierPassive = nil, modifierActive = 4, pointsPassive = nil, pointsActive = 700, minEnergy = 7},
            [5] = {modifierPassive = nil, modifierActive = 5, pointsPassive = nil, pointsActive = 875, minEnergy = 9},
        },
    },

    -- Modify movements of indirect units of the owner player.
    [47] = {
        minLevelActive     = 1,
        maxLevelActive     = 5,
        modifierUnit = "",
        levels = {
            [1] = {modifierPassive = nil, modifierActive = 1, pointsPassive = nil, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = nil, modifierActive = 2, pointsPassive = nil, pointsActive = 100, minEnergy = 2},
            [3] = {modifierPassive = nil, modifierActive = 3, pointsPassive = nil, pointsActive = 150, minEnergy = 3},
            [4] = {modifierPassive = nil, modifierActive = 4, pointsPassive = nil, pointsActive = 200, minEnergy = 4},
            [5] = {modifierPassive = nil, modifierActive = 5, pointsPassive = nil, pointsActive = 250, minEnergy = 5},
        },
    },

    -- Modify movements of ground units of the owner player.
    [48] = {
        minLevelActive     = 1,
        maxLevelActive     = 5,
        modifierUnit = "",
        levels = {
            [1] = {modifierPassive = nil, modifierActive = 1, pointsPassive = nil, pointsActive = 150, minEnergy = 1},
            [2] = {modifierPassive = nil, modifierActive = 2, pointsPassive = nil, pointsActive = 325, minEnergy = 3},
            [3] = {modifierPassive = nil, modifierActive = 3, pointsPassive = nil, pointsActive = 475, minEnergy = 5},
            [4] = {modifierPassive = nil, modifierActive = 4, pointsPassive = nil, pointsActive = 650, minEnergy = 7},
            [5] = {modifierPassive = nil, modifierActive = 5, pointsPassive = nil, pointsActive = 800, minEnergy = 9},
        },
    },

    -- Modify movements of air units of the owner player.
    [49] = {
        minLevelActive     = 1,
        maxLevelActive     = 5,
        modifierUnit = "",
        levels = {
            [1] = {modifierPassive = nil, modifierActive = 1, pointsPassive = nil, pointsActive = 125, minEnergy = 1},
            [2] = {modifierPassive = nil, modifierActive = 2, pointsPassive = nil, pointsActive = 250, minEnergy = 3},
            [3] = {modifierPassive = nil, modifierActive = 3, pointsPassive = nil, pointsActive = 375, minEnergy = 5},
            [4] = {modifierPassive = nil, modifierActive = 4, pointsPassive = nil, pointsActive = 500, minEnergy = 7},
            [5] = {modifierPassive = nil, modifierActive = 5, pointsPassive = nil, pointsActive = 625, minEnergy = 9},
        },
    },

    -- Modify movements of naval units of the owner player.
    [50] = {
        minLevelActive     = 1,
        maxLevelActive     = 5,
        modifierUnit = "",
        levels = {
            [1] = {modifierPassive = nil, modifierActive = 1, pointsPassive = nil, pointsActive = 125, minEnergy = 1},
            [2] = {modifierPassive = nil, modifierActive = 2, pointsPassive = nil, pointsActive = 250, minEnergy = 3},
            [3] = {modifierPassive = nil, modifierActive = 3, pointsPassive = nil, pointsActive = 375, minEnergy = 5},
            [4] = {modifierPassive = nil, modifierActive = 4, pointsPassive = nil, pointsActive = 500, minEnergy = 7},
            [5] = {modifierPassive = nil, modifierActive = 5, pointsPassive = nil, pointsActive = 625, minEnergy = 9},
        },
    },

    -- Modify movements of infantry units of the owner player.
    [51] = {
        minLevelActive     = 1,
        maxLevelActive     = 5,
        modifierUnit = "",
        levels = {
            [1] = {modifierPassive = nil, modifierActive = 1, pointsPassive = nil, pointsActive = 100, minEnergy = 1},
            [2] = {modifierPassive = nil, modifierActive = 2, pointsPassive = nil, pointsActive = 200, minEnergy = 3},
            [3] = {modifierPassive = nil, modifierActive = 3, pointsPassive = nil, pointsActive = 300, minEnergy = 5},
            [4] = {modifierPassive = nil, modifierActive = 4, pointsPassive = nil, pointsActive = 400, minEnergy = 7},
            [5] = {modifierPassive = nil, modifierActive = 5, pointsPassive = nil, pointsActive = 500, minEnergy = 9},
        },
    },

    -- Modify movements of vehicle units of the owner player.
    [52] = {
        minLevelActive     = 1,
        maxLevelActive     = 5,
        modifierUnit = "",
        levels = {
            [1] = {modifierPassive = nil, modifierActive = 1, pointsPassive = nil, pointsActive = 150, minEnergy = 1},
            [2] = {modifierPassive = nil, modifierActive = 2, pointsPassive = nil, pointsActive = 300, minEnergy = 3},
            [3] = {modifierPassive = nil, modifierActive = 3, pointsPassive = nil, pointsActive = 450, minEnergy = 5},
            [4] = {modifierPassive = nil, modifierActive = 4, pointsPassive = nil, pointsActive = 600, minEnergy = 7},
            [5] = {modifierPassive = nil, modifierActive = 5, pointsPassive = nil, pointsActive = 750, minEnergy = 9},
        },
    },

    -- Modify movements of direct non-infantry units of the owner player.
    [53] = {
        minLevelActive     = 1,
        maxLevelActive     = 5,
        modifierUnit = "",
        levels = {
            [1] = {modifierPassive = nil, modifierActive = 1, pointsPassive = nil, pointsActive = 175, minEnergy = 1},
            [2] = {modifierPassive = nil, modifierActive = 2, pointsPassive = nil, pointsActive = 325, minEnergy = 3},
            [3] = {modifierPassive = nil, modifierActive = 3, pointsPassive = nil, pointsActive = 500, minEnergy = 5},
            [4] = {modifierPassive = nil, modifierActive = 4, pointsPassive = nil, pointsActive = 650, minEnergy = 7},
            [5] = {modifierPassive = nil, modifierActive = 5, pointsPassive = nil, pointsActive = 825, minEnergy = 9},
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
            [1] = {modifierPassive = 1, modifierActive = 1, pointsPassive = 75, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 2, modifierActive = 2, pointsPassive = 150, pointsActive = 100, minEnergy = 2},
            [3] = {modifierPassive = 3, modifierActive = 3, pointsPassive = 225, pointsActive = 150, minEnergy = 3},
            [4] = {modifierPassive = 4, modifierActive = 4, pointsPassive = 300, pointsActive = 200, minEnergy = 4},
            [5] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 375, pointsActive = 250, minEnergy = 5},
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
            [1] = {modifierPassive = 1, modifierActive = 1, pointsPassive = 200, pointsActive = 125, minEnergy = 1},
            [2] = {modifierPassive = 2, modifierActive = 2, pointsPassive = 400, pointsActive = 250, minEnergy = 2},
            [3] = {modifierPassive = 3, modifierActive = 3, pointsPassive = 600, pointsActive = 375, minEnergy = 3},
            [4] = {modifierPassive = 4, modifierActive = 4, pointsPassive = 800, pointsActive = 500, minEnergy = 4},
            [5] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 1000, pointsActive = 625, minEnergy = 5},
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
            [1] = {modifierPassive = 1, modifierActive = 1, pointsPassive = 150, pointsActive = 75, minEnergy = 1},
            [2] = {modifierPassive = 2, modifierActive = 2, pointsPassive = 300, pointsActive = 150, minEnergy = 2},
            [3] = {modifierPassive = 3, modifierActive = 3, pointsPassive = 450, pointsActive = 225, minEnergy = 3},
            [4] = {modifierPassive = 4, modifierActive = 4, pointsPassive = 600, pointsActive = 300, minEnergy = 4},
            [5] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 750, pointsActive = 375, minEnergy = 5},
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
        [1] = {modifierPassive = 1, modifierActive = 1, pointsPassive = 225, pointsActive = 150, minEnergy = 1},
        [2] = {modifierPassive = 2, modifierActive = 2, pointsPassive = 450, pointsActive = 300, minEnergy = 2},
        [3] = {modifierPassive = 3, modifierActive = 3, pointsPassive = 675, pointsActive = 450, minEnergy = 3},
        [4] = {modifierPassive = 4, modifierActive = 4, pointsPassive = 900, pointsActive = 600, minEnergy = 4},
        [5] = {modifierPassive = 5, modifierActive = 5, pointsPassive = 1125, pointsActive = 750, minEnergy = 5},
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
            [1] = {modifierPassive = nil, modifierActive = nil, pointsPassive = 225, pointsActive = 125, minEnergy = 1},
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
            [1] = {modifierPassive = nil, modifierActive = nil, pointsPassive = 150, pointsActive = 100, minEnergy = 1},
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
            [1] = {modifierPassive = nil, modifierActive = nil, pointsPassive = 250, pointsActive = 150, minEnergy = 1},
        },
    },

    -- Add energy instantly.
    [61] = {
        minLevelActive = 1,
        maxLevelActive = 4,
        modifierUnit = "",
        levels = {
            [1] = {modifierPassive = nil, modifierActive = 0.25, pointsPassive = nil, pointsActive = 25, minEnergy = 1},
            [2] = {modifierPassive = nil, modifierActive = 0.5, pointsPassive = nil, pointsActive = 50, minEnergy = 1},
            [3] = {modifierPassive = nil, modifierActive = 0.75, pointsPassive = nil, pointsActive = 75, minEnergy = 1},
            [4] = {modifierPassive = nil, modifierActive = 1, pointsPassive = nil, pointsActive = 100, minEnergy = 1},
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
        },
        active2 = {
            energyRequirement = 5,
            {
                id    = 6,
                level = 2,
            },
            {
                id    = 1,
                level = 2,
            },
        },
    },

    Andy = {
        maxPoints = 100,
        passive = {
        },
        active1 = {
            energyRequirement = 3,
            {
                id    = 4,
                level = 2,
            },
            {
                id    = 1,
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
                level = 2,
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
                level = -5,
            },
            {
                id    = 3,
                level = 13,
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
                level = 14,
            },
        },
    },

    Drake = {
        maxPoints = 100,
        passive = {
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
            energyRequirement = 7,
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
                id    = 40,
                level = 4,
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
                level = -5,
            },
            {
                id    = 2,
                level = -2,
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
                level = 2,
            },
        },
    },

    Grimm = {
        maxPoints = 100,
        passive = {
            {
                id    = 1,
                level = 15,
            },
            {
                id    = 2,
                level = -5,
            },
        },
        active1 = {
            energyRequirement = 3,
            {
                id    = 1,
                level = 5,
            },
        },
        active2 = {
            energyRequirement = 6,
            {
                id    = 1,
                level = 10,
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
            {
                id    = 30,
                level = -2,
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
                level = 2,
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
                level = 2,
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
                level = 4,
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
                level = 6,
            },
        },
        active1 = {
            energyRequirement = 4,
            {
                id    = 28,
                level = 1,
            },
        },
        active2 = {
            energyRequirement = 7,
            {
                id    = 23,
                level = 3,
            },
            {
                id    = 24,
                level = 3,
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
                level = 2,
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
                level = 4,
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
                level = 4,
            },
        },
        active1 = {
            energyRequirement = 3,
            {
                id    = 14,
                level = 3,
            },
        },
        active2 = {
            energyRequirement = 6,
            {
                id    = 14,
                level = 6,
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
                level = 3,
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
                level = 3,
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
                level = 6,
            },
            {
                id    = 34,
                level = 6,
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
                level = 4,
            },
        },
        active1 = {
            energyRequirement = 2,
            {
                id    = 13,
                level = 5,
            },
        },
        active2 = {
            energyRequirement = 6,
            {
                id    = 22,
                level = 10,
            },
        },
    },
}

return GameConstant
