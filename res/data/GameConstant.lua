
local GameConstant = {}

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
    plain       = {typeIndex = 1,  shapesCount = 1,  framesCount = 1, durationPerFrame = 999999,},
    river       = {typeIndex = 2, shapesCount = 16, framesCount = 1, durationPerFrame = 999999,},
    sea         = {typeIndex = 3,  shapesCount = 47, framesCount = 8, durationPerFrame = 0.2,   },
    beach       = {typeIndex = 4, shapesCount = 12, framesCount = 8, durationPerFrame = 0.2,   },
    road        = {typeIndex = 5,  shapesCount = 11, framesCount = 1, durationPerFrame = 999999,},
    bridge      = {typeIndex = 6,  shapesCount = 11, framesCount = 1, durationPerFrame = 999999,},
    wood        = {typeIndex = 7,  shapesCount = 1,  framesCount = 1, durationPerFrame = 999999,},
    mountain    = {typeIndex = 8,  shapesCount = 1,  framesCount = 1, durationPerFrame = 999999,},
    wasteland   = {typeIndex = 9,  shapesCount = 1,  framesCount = 1, durationPerFrame = 999999,},
    ruins       = {typeIndex = 10,  shapesCount = 1,  framesCount = 1, durationPerFrame = 999999,},
    fire        = {typeIndex = 11,  shapesCount = 1,  framesCount = 5, durationPerFrame = 0.1,   },
    rough       = {typeIndex = 12, shapesCount = 1,  framesCount = 8, durationPerFrame = 0.2,   },
    mist        = {typeIndex = 13, shapesCount = 1,  framesCount = 8, durationPerFrame = 0.2,   },
    reef        = {typeIndex = 14, shapesCount = 1,  framesCount = 8, durationPerFrame = 0.2,   },
    plasma      = {typeIndex = 15, shapesCount = 1,  framesCount = 3, durationPerFrame = 0.1,   },
    meteor      = {typeIndex = 16, shapesCount = 1,  framesCount = 1, durationPerFrame = 999999,},
    silo        = {typeIndex = 17, shapesCount = 2,  framesCount = 1, durationPerFrame = 999999,},
    hq          = {typeIndex = 18, shapesCount = 4,  framesCount = 2, durationPerFrame = 0.5,   },
    city        = {typeIndex = 19, shapesCount = 5,  framesCount = 2, durationPerFrame = 0.5,   },
    comtower    = {typeIndex = 20, shapesCount = 5,  framesCount = 2, durationPerFrame = 0.5,   },
    radar       = {typeIndex = 21, shapesCount = 5,  framesCount = 2, durationPerFrame = 0.5,   },
    factory     = {typeIndex = 22, shapesCount = 5,  framesCount = 2, durationPerFrame = 0.5,   },
    airport     = {typeIndex = 23, shapesCount = 5,  framesCount = 2, durationPerFrame = 0.5,   },
    seaport     = {typeIndex = 24, shapesCount = 5,  framesCount = 2, durationPerFrame = 0.5,   },
    tempairport = {typeIndex = 25, shapesCount = 5,  framesCount = 1, durationPerFrame = 999999,},
    tempseaport = {typeIndex = 26, shapesCount = 5,  framesCount = 1, durationPerFrame = 999999,},
}

GameConstant.unitAnimations = {
    infantry = {
        {
            normal = {pattern = "c02_t01_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t01_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t01_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t01_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
    },
    mech = {
        {
            normal = {pattern = "c02_t02_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t02_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t02_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t02_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
    },
    bike = {
        {
            normal = {pattern = "c02_t03_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t03_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t03_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t03_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
    },
    recon = {
        {
            normal = {pattern = "c02_t04_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t04_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t04_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t04_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
    },
    flare = {
        {
            normal = {pattern = "c02_t05_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t05_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t05_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t05_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
    },
    antiair = {
        {
            normal = {pattern = "c02_t06_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t06_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t06_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t06_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
    },
    tank = {
        {
            normal = {pattern = "c02_t07_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t07_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t07_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t07_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
    },
    mdtank = {
        {
            normal = {pattern = "c02_t08_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t08_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t08_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t08_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
    },
    wartank = {
        {
            normal = {pattern = "c02_t09_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t09_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t09_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t09_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
    },
    artillery = {
        {
            normal = {pattern = "c02_t10_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t10_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t10_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t10_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
    },
    antitank = {
        {
            normal = {pattern = "c02_t11_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t11_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t11_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t11_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
    },
    rockets = {
        {
            normal = {pattern = "c02_t12_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t12_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t12_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t12_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
    },
    missiles = {
        {
            normal = {pattern = "c02_t13_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t13_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t13_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t13_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
    },
    rig = {
        {
            normal = {pattern = "c02_t14_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t14_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t14_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t14_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
    },
    fighter = {
        {
            normal = {pattern = "c02_t15_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t15_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t15_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t15_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
    },
    bomber = {
        {
            normal = {pattern = "c02_t16_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t16_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t16_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t16_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
    },
    duster = {
        {
            normal = {pattern = "c02_t17_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t17_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t17_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t17_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
    },
    bcopter = {
        {
            normal = {pattern = "c02_t18_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t18_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t18_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t18_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
    },
    tcopter = {
        {
            normal = {pattern = "c02_t19_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t19_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t19_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t19_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
    },
    seaplane = {
        {
            normal = {pattern = "c02_t20_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t20_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t20_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t20_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
    },
    battleship = {
        {
            normal = {pattern = "c02_t21_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t21_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t21_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t21_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
    },
    carrier = {
        {
            normal = {pattern = "c02_t22_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t22_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t22_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t22_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
    },
    submarine = {
        {
            normal = {pattern = "c02_t23_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t23_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t23_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t23_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
    },
    cruiser = {
        {
            normal = {pattern = "c02_t24_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t24_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t24_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t24_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
    },
    lander = {
        {
            normal = {pattern = "c02_t25_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t25_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t25_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t25_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
    },
    gunboat = {
        {
            normal = {pattern = "c02_t26_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t26_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t26_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
        },
        {
            normal = {pattern = "c02_t26_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
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

        defenseBonus = {
            amount         = 10,
            targetCatagory = "Ground units",
            targetList     = GameConstant.unitCatagory.groundUnits,
        },

        moveCost = {
            clear = {
                infantry  = 1,
                mech      = 1,
                tireA     = 2,
                tireB     = 1,
                tank      = 1,
                air       = 1,
                ship      = false,
                transport = false,
            },
            rain  = {
                infantry  = 1,
                mech      = 1,
                tireA     = 2,
                tireB     = 1,
                tank      = 1,
                air       = 1,
                ship      = false,
                transport = false,
            },
            snow  = {
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

        isFullGrid  = true,
        isTileBase  = true,
        description = "A rich, green plain. Easy to traverse, but offers little defensive cover.",
    },

    road = {
        GridIndexable = {},

        defenseBonus = {
            amount         = 0,
            targetCatagory = "None",
            targetList     = GameConstant.unitCatagory.none,
        },

        moveCost = {
            clear = {
                infantry  = 1,
                mech      = 1,
                tireA     = 1,
                tireB     = 1,
                tank      = 1,
                air       = 1,
                ship      = false,
                transport = false,
            },
            rain  = {
                infantry  = 1,
                mech      = 1,
                tireA     = 1,
                tireB     = 1,
                tank      = 1,
                air       = 1,
                ship      = false,
                transport = false,
            },
            snow  = {
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

        isFullGrid  = false,
        isTileBase  = false,
        description = "A paved road. Easy to traverse, but offers little defensive cover.",
    },

    wood = {
        GridIndexable = {},

        defenseBonus = {
            amount         = 20,
            targetCatagory = "Ground units",
            targetList     = GameConstant.unitCatagory.groundUnits,
        },

        moveCost = {
            clear = {
                infantry  = 1,
                mech      = 1,
                tireA     = 3,
                tireB     = 3,
                tank      = 2,
                air       = 1,
                ship      = false,
                transport = false,
            },
            rain  = {
                infantry  = 1,
                mech      = 1,
                tireA     = 3,
                tireB     = 3,
                tank      = 2,
                air       = 1,
                ship      = false,
                transport = false,
            },
            snow  = {
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

        isFullGrid  = true,
        isTileBase  = false,
        description = "In Fog of War, units hidden here can only be seen by adjacent units and air units.",
    },

    mountain = {
        GridIndexable = {},

        defenseBonus = {
            amount         = 40,
            targetCatagory = "Foot units",
            targetList     = GameConstant.unitCatagory.footUnits,
        },

        moveCost = {
            clear = {
                infantry  = 2,
                mech      = 1,
                tireA     = false,
                tireB     = false,
                tank      = false,
                air       = 1,
                ship      = false,
                transport = false,
            },
            rain  = {
                infantry  = 2,
                mech      = 1,
                tireA     = false,
                tireB     = false,
                tank      = false,
                air       = 1,
                ship      = false,
                transport = false,
            },
            snow  = {
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

        isFullGrid  = true,
        isTileBase  = false,
        description = "A steep mountain. Infantry units add 3 to their vision range from here.",
    },

    wasteland = {
        GridIndexable = {},

        defenseBonus = {
            amount         = 40,
            targetCatagory = "Foot units",
            targetList     = GameConstant.unitCatagory.footUnits,
        },

        moveCost = {
            clear = {
                infantry  = 2,
                mech      = 1,
                tireA     = false,
                tireB     = false,
                tank      = false,
                air       = 1,
                ship      = false,
                transport = false,
            },
            rain  = {
                infantry  = 2,
                mech      = 1,
                tireA     = false,
                tireB     = false,
                tank      = false,
                air       = 1,
                ship      = false,
                transport = false,
            },
            snow  = {
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

        isFullGrid  = true,
        isTileBase  = false,
        description = "A steep mountain. Infantry units add 3 to their vision range from here.",
    },

    ruins = {
        GridIndexable = {},

        defenseBonus = {
            amount         = 40,
            targetCatagory = "Foot units",
            targetList     = GameConstant.unitCatagory.footUnits,
        },

        moveCost = {
            clear = {
                infantry  = 2,
                mech      = 1,
                tireA     = false,
                tireB     = false,
                tank      = false,
                air       = 1,
                ship      = false,
                transport = false,
            },
            rain  = {
                infantry  = 2,
                mech      = 1,
                tireA     = false,
                tireB     = false,
                tank      = false,
                air       = 1,
                ship      = false,
                transport = false,
            },
            snow  = {
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

        isFullGrid  = true,
        isTileBase  = false,
        description = "A steep mountain. Infantry units add 3 to their vision range from here.",
    },

    fire = {
        GridIndexable = {},

        defenseBonus = {
            amount         = 40,
            targetCatagory = "Foot units",
            targetList     = GameConstant.unitCatagory.footUnits,
        },

        moveCost = {
            clear = {
                infantry  = 2,
                mech      = 1,
                tireA     = false,
                tireB     = false,
                tank      = false,
                air       = 1,
                ship      = false,
                transport = false,
            },
            rain  = {
                infantry  = 2,
                mech      = 1,
                tireA     = false,
                tireB     = false,
                tank      = false,
                air       = 1,
                ship      = false,
                transport = false,
            },
            snow  = {
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

        isFullGrid  = true,
        isTileBase  = false,
        description = "A steep mountain. Infantry units add 3 to their vision range from here.",
    },

    sea = {
        GridIndexable = {},

        defenseBonus = {
            amount         = 0,
            targetCatagory = "None",
            targetList     = GameConstant.unitCatagory.none,
        },

        moveCost = {
            clear = {
                infantry  = false,
                mech      = false,
                tireA     = false,
                tireB     = false,
                tank      = false,
                air       = 1,
                ship      = 1,
                transport = 1,
            },
            rain  = {
                infantry  = false,
                mech      = false,
                tireA     = false,
                tireB     = false,
                tank      = false,
                air       = 1,
                ship      = 1,
                transport = 1,
            },
            snow  = {
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

        isFullGrid  = true,
        isTileBase  = true,
        description = "A body of water. Only naval and air units can traverse seas.",
    },

    bridge = {
        GridIndexable = {},

        defenseBonus = {
            amount         = 0,
            targetCatagory = "None",
            targetList     = GameConstant.unitCatagory.none,
        },

        moveCost = {
            clear = {
                infantry  = 1,
                mech      = 1,
                tireA     = 1,
                tireB     = 1,
                tank      = 1,
                air       = 1,
                ship      = 1,
                transport = 1,
            },
            rain  = {
                infantry  = 1,
                mech      = 1,
                tireA     = 1,
                tireB     = 1,
                tank      = 1,
                air       = 1,
                ship      = 1,
                transport = 1,
            },
            snow  = {
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

        isFullGrid  = false,
        isTileBase  = false,
        description = "A bridge allows units to traverse rivers, but offers no terrain benefits.",
    },

    river = {
        GridIndexable = {},

        defenseBonus = {
            amount         = 0,
            targetCatagory = "None",
            targetList     = GameConstant.unitCatagory.none,
        },

        moveCost = {
            clear = {
                infantry  = 2,
                mech      = 1,
                tireA     = false,
                tireB     = false,
                tank      = false,
                air       = 1,
                ship      = false,
                transport = false,
            },
            rain  = {
                infantry  = 2,
                mech      = 1,
                tireA     = false,
                tireB     = false,
                tank      = false,
                air       = 1,
                ship      = false,
                transport = false,
            },
            snow  = {
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

        isFullGrid  = true,
        isTileBase  = true,
        description = "A gentle, flowing river. Only infantry units can ford rivers.",
    },

    beach = {
        GridIndexable = {},

        defenseBonus = {
            amount         = 0,
            targetCatagory = "None",
            targetList     = GameConstant.unitCatagory.none,
        },

        moveCost = {
            clear = {
                infantry  = 1,
                mech      = 1,
                tireA     = 2,
                tireB     = 2,
                tank      = 1,
                air       = 1,
                ship      = false,
                transport = 1,
            },
            rain  = {
                infantry  = 1,
                mech      = 1,
                tireA     = 2,
                tireB     = 2,
                tank      = 1,
                air       = 1,
                ship      = false,
                transport = 1,
            },
            snow  = {
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

        isFullGrid  = true,
        isTileBase  = true,
        description = "A sandy shoal. Lander units load and unload units here.",
    },

    rough = {
        GridIndexable = {},

        defenseBonus = {
            amount         = 0,
            targetCatagory = "None",
            targetList     = GameConstant.unitCatagory.none,
        },

        moveCost = {
            clear = {
                infantry  = 1,
                mech      = 1,
                tireA     = 2,
                tireB     = 2,
                tank      = 1,
                air       = 1,
                ship      = false,
                transport = 1,
            },
            rain  = {
                infantry  = 1,
                mech      = 1,
                tireA     = 2,
                tireB     = 2,
                tank      = 1,
                air       = 1,
                ship      = false,
                transport = 1,
            },
            snow  = {
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

        isFullGrid  = true,
        isTileBase  = false,
        description = "A sandy shoal. Lander units load and unload units here.",
    },

    mist = {
        GridIndexable = {},

        defenseBonus = {
            amount         = 0,
            targetCatagory = "None",
            targetList     = GameConstant.unitCatagory.none,
        },

        moveCost = {
            clear = {
                infantry  = 1,
                mech      = 1,
                tireA     = 2,
                tireB     = 2,
                tank      = 1,
                air       = 1,
                ship      = false,
                transport = 1,
            },
            rain  = {
                infantry  = 1,
                mech      = 1,
                tireA     = 2,
                tireB     = 2,
                tank      = 1,
                air       = 1,
                ship      = false,
                transport = 1,
            },
            snow  = {
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

        isFullGrid  = true,
        isTileBase  = false,
        description = "A sandy shoal. Lander units load and unload units here.",
    },

    reef = {
        GridIndexable = {},

        defenseBonus = {
            amount         = 10,
            targetCatagory = "Naval units",
            targetList     = GameConstant.unitCatagory.navalUnits,
        },

        moveCost = {
            clear = {
                infantry  = false,
                mech      = false,
                tireA     = false,
                tireB     = false,
                tank      = false,
                air       = 1,
                ship      = 2,
                transport = 2,
            },
            rain  = {
                infantry  = false,
                mech      = false,
                tireA     = false,
                tireB     = false,
                tank      = false,
                air       = 1,
                ship      = 2,
                transport = 2,
            },
            snow  = {
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

        isFullGrid  = true,
        isTileBase  = false,
        description = "In Fog of War, units hidden here can only be seen by adjacent units and air units.",
    },

    city = {
        GridIndexable = {},

        defenseBonus = {
            amount         = 30,
            targetCatagory = "Ground units",
            targetList     = GameConstant.unitCatagory.groundUnits,
        },

        moveCost = {
            clear = {
                infantry  = 1,
                mech      = 1,
                tireA     = 1,
                tireB     = 1,
                tank      = 1,
                air       = 1,
                ship      = false,
                transport = false,
            },
            rain  = {
                infantry  = 1,
                mech      = 1,
                tireA     = 1,
                tireB     = 1,
                tank      = 1,
                air       = 1,
                ship      = false,
                transport = false,
            },
            snow  = {
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

        isFullGrid  = true,
        isTileBase  = false,
        description = "A normal city. Ground units gain supplies and HP in allied cities.",

        specialProperties = {
            {
                name            = "CaptureTaker",
                maxCapturePoint = GameConstant.maxCapturePoint,
                onCapture       = "ChangeCapturer"
            },
            {
                name           = "RepairDoer",
                targetCatagory = "Ground units",
                targetList     = GameConstant.unitCatagory.groundUnits,
                amount         = 2,
            },
            {
                name   = "IncomeProvider",
                amount = GameConstant.incomePerTurn
            },
            --[[
            {
                name = "SupplyProvider",
                target = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}
            },
            --]]
        }
    },

    comtower = {
        GridIndexable = {},

        defenseBonus = {
            amount         = 30,
            targetCatagory = "Ground units",
            targetList     = GameConstant.unitCatagory.groundUnits,
        },

        moveCost = {
            clear = {
                infantry  = 1,
                mech      = 1,
                tireA     = 1,
                tireB     = 1,
                tank      = 1,
                air       = 1,
                ship      = false,
                transport = false,
            },
            rain  = {
                infantry  = 1,
                mech      = 1,
                tireA     = 1,
                tireB     = 1,
                tank      = 1,
                air       = 1,
                ship      = false,
                transport = false,
            },
            snow  = {
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

        isFullGrid  = true,
        isTileBase  = false,
        description = "A command tower.",

        specialProperties = {
            {
                name            = "CaptureTaker",
                maxCapturePoint = GameConstant.maxCapturePoint,
                onCapture       = "ChangeCapturer"
            },
        },
    },

    radar = {
        GridIndexable = {},

        defenseBonus = {
            amount         = 30,
            targetCatagory = "Ground units",
            targetList     = GameConstant.unitCatagory.groundUnits,
        },

        moveCost = {
            clear = {
                infantry  = 1,
                mech      = 1,
                tireA     = 1,
                tireB     = 1,
                tank      = 1,
                air       = 1,
                ship      = false,
                transport = false,
            },
            rain  = {
                infantry  = 1,
                mech      = 1,
                tireA     = 1,
                tireB     = 1,
                tank      = 1,
                air       = 1,
                ship      = false,
                transport = false,
            },
            snow  = {
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

        isFullGrid  = true,
        isTileBase  = false,
        description = "A command tower.",

        specialProperties = {
            {
                name            = "CaptureTaker",
                maxCapturePoint = GameConstant.maxCapturePoint,
                onCapture       = "ChangeCapturer"
            },
        },
    },

    silo = {
        GridIndexable = {},

        defenseBonus = {
            amount         = 30,
            targetCatagory = "Ground units",
            targetList     = GameConstant.unitCatagory.groundUnits,
        },

        moveCost = {
            clear = {
                infantry  = 1,
                mech      = 1,
                tireA     = 1,
                tireB     = 1,
                tank      = 1,
                air       = 1,
                ship      = false,
                transport = false,
            },
            rain  = {
                infantry  = 1,
                mech      = 1,
                tireA     = 1,
                tireB     = 1,
                tank      = 1,
                air       = 1,
                ship      = false,
                transport = false,
            },
            snow  = {
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

        isFullGrid  = true,
        isTileBase  = false,
        description = "A missile silo. Has a huge blast radius and unlimited range, but can only fire once.",
    },

    plasma = {
        GridIndexable = {},

        defenseBonus = {
            amount         = 0,
            targetCatagory = "None",
            targetList     = GameConstant.unitCatagory.none,
        },

        moveCost = {
            clear = {
                infantry  = false,
                mech      = false,
                tireA     = false,
                tireB     = false,
                tank      = false,
                air       = false,
                ship      = false,
                transport = false,
            },
            rain  = {
                infantry  = false,
                mech      = false,
                tireA     = false,
                tireB     = false,
                tank      = false,
                air       = false,
                ship      = false,
                transport = false,
            },
            snow  = {
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

        isFullGrid  = false,
        isTileBase  = false,
        description = "A pipeline. Thick armor renders it indestructible. No units can pass it.",
    },

    meteor = {
        GridIndexable = {},

        AttackTaker = {
            maxHP            = GameConstant.tileMaxHP,
            currentHP        = GameConstant.tileMaxHP,
            defenseType      = "mdtank",
            isAffectedByLuck = false,
        },

        defenseBonus = {
            amount         = 0,
            targetCatagory = "None",
            targetList     = GameConstant.unitCatagory.none,
        },

        moveCost = {
            clear = {
                infantry  = false,
                mech      = false,
                tireA     = false,
                tireB     = false,
                tank      = false,
                air       = false,
                ship      = false,
                transport = false,
            },
            rain  = {
                infantry  = false,
                mech      = false,
                tireA     = false,
                tireB     = false,
                tank      = false,
                air       = false,
                ship      = false,
                transport = false,
            },
            snow  = {
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

        isFullGrid  = false,
        isTileBase  = false,
        description = "A joint of pipelines. The armor is weaker here than on other sections of the pipeline.",

        specialProperties = {
        },
    },

    hq = {
        GridIndexable = {},

        defenseBonus = {
            amount         = 40,
            targetCatagory = "Ground units",
            targetList     = GameConstant.unitCatagory.groundUnits,
        },

        moveCost = {
            clear = {
                infantry  = 1,
                mech      = 1,
                tireA     = 1,
                tireB     = 1,
                tank      = 1,
                air       = 1,
                ship      = false,
                transport = false,
            },
            rain  = {
                infantry  = 1,
                mech      = 1,
                tireA     = 1,
                tireB     = 1,
                tank      = 1,
                air       = 1,
                ship      = false,
                transport = false,
            },
            snow  = {
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

        isFullGrid  = true,
        isTileBase  = false,
        description = "An army HQ. Battle ends if it's captured. Ground units get HP and supplies here.",

        specialProperties = {
            {
                name            = "CaptureTaker",
                maxCapturePoint = GameConstant.maxCapturePoint,
                onCapture       = "Defeat"
            },
            {
                name           = "RepairDoer",
                targetCatagory = "Ground units",
                targetList     = GameConstant.unitCatagory.groundUnits,
                amount         = 2,
            },
            {
                name   = "IncomeProvider",
                amount = GameConstant.incomePerTurn
            },
            --[[
            {
                name = "SupplyProvider",
                target = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}
            },
            --]]
        },
    },

    factory = {
        GridIndexable = {},

        defenseBonus = {
            amount         = 30,
            targetCatagory = "Ground units",
            targetList     = GameConstant.unitCatagory.groundUnits,
        },

        moveCost = {
            clear = {
                infantry  = 1,
                mech      = 1,
                tireA     = 1,
                tireB     = 1,
                tank      = 1,
                air       = 1,
                ship      = false,
                transport = false,
            },
            rain  = {
                infantry  = 1,
                mech      = 1,
                tireA     = 1,
                tireB     = 1,
                tank      = 1,
                air       = 1,
                ship      = false,
                transport = false,
            },
            snow  = {
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

        isFullGrid  = true,
        isTileBase  = false,
        description = "A base. Allied bases deploy, supply, and restore HP to ground units.",

        specialProperties = {
            {
                name            = "CaptureTaker",
                maxCapturePoint = GameConstant.maxCapturePoint,
                onCapture       = "ChangeCapturer"
            },
            {
                name           = "RepairDoer",
                targetCatagory = "Ground units",
                targetList     = GameConstant.unitCatagory.groundUnits,
                amount         = 2,
            },
            {
                name   = "IncomeProvider",
                amount = GameConstant.incomePerTurn
            },
            --[[
            {
                name = "SupplyProvider",
                target = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}
            },
            {
                name = "RepairDoer",
                target = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}
            }
            --]]
        }
    },

    airport = {
        GridIndexable = {},

        defenseBonus = {
            amount         = 30,
            targetCatagory = "Ground units",
            targetList     = GameConstant.unitCatagory.groundUnits,
        },

        moveCost = {
            clear = {
                infantry  = 1,
                mech      = 1,
                tireA     = 1,
                tireB     = 1,
                tank      = 1,
                air       = 1,
                ship      = false,
                transport = false,
            },
            rain  = {
                infantry  = 1,
                mech      = 1,
                tireA     = 1,
                tireB     = 1,
                tank      = 1,
                air       = 1,
                ship      = false,
                transport = false,
            },
            snow  = {
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

        isFullGrid  = true,
        isTileBase  = false,
        description = "An air base. Allied bases deploy, supply, and restore HP to air units.",

        specialProperties = {
            {
                name            = "CaptureTaker",
                maxCapturePoint = GameConstant.maxCapturePoint,
                onCapture       = "ChangeCapturer"
            },
            {
                name           = "RepairDoer",
                targetCatagory = "Air units",
                targetList     = GameConstant.unitCatagory.airUnits,
                amount         = 2,
            },
            {
                name   = "IncomeProvider",
                amount = GameConstant.incomePerTurn
            },
            --[[
            {
                name = "SupplyProvider",
                target = {12, 13, 14, 15}
            },
            {
                name = "RepairDoer",
                target = {12, 13, 14, 15}
            }
            --]]
        }
    },

    seaport = {
        GridIndexable = {},

        defenseBonus = {
            amount         = 30,
            targetCatagory = "Ground/naval units",
            targetList     = GameConstant.unitCatagory.groundOrNavalUnits,
        },

        moveCost = {
            clear = {
                infantry  = 1,
                mech      = 1,
                tireA     = 1,
                tireB     = 1,
                tank      = 1,
                air       = 1,
                ship      = 1,
                transport = 1,
            },
            rain  = {
                infantry  = 1,
                mech      = 1,
                tireA     = 1,
                tireB     = 1,
                tank      = 1,
                air       = 1,
                ship      = 1,
                transport = 1,
            },
            snow  = {
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

        isFullGrid  = false,
        isTileBase  = false,
        description = "A naval base. Allied bases deploy, supply, and restore HP to naval units.",

        specialProperties = {
            {
                name            = "CaptureTaker",
                maxCapturePoint = GameConstant.maxCapturePoint,
                onCapture       = "ChangeCapturer"
            },
            {
                name           = "RepairDoer",
                targetCatagory = "Naval units",
                targetList     = GameConstant.unitCatagory.navalUnits,
                amount         = 2,
            },
            {
                name   = "IncomeProvider",
                amount = GameConstant.incomePerTurn
            },
            --[[
            {
                name = "SupplyProvider",
                target = {16, 17, 18, 19}
            },
            {
                name = "RepairDoer",
                target = {16, 17, 18, 19}
            }
            --]]
        }
    },

    tempairport = {
        GridIndexable = {},

        defenseBonus = {
            amount         = 30,
            targetCatagory = "Ground units",
            targetList     = GameConstant.unitCatagory.groundUnits,
        },

        moveCost = {
            clear = {
                infantry  = 1,
                mech      = 1,
                tireA     = 1,
                tireB     = 1,
                tank      = 1,
                air       = 1,
                ship      = false,
                transport = false,
            },
            rain  = {
                infantry  = 1,
                mech      = 1,
                tireA     = 1,
                tireB     = 1,
                tank      = 1,
                air       = 1,
                ship      = false,
                transport = false,
            },
            snow  = {
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

        isFullGrid  = true,
        isTileBase  = false,
        description = "An air base. Allied bases deploy, supply, and restore HP to air units.",

        specialProperties = {
            {
                name            = "CaptureTaker",
                maxCapturePoint = GameConstant.maxCapturePoint,
                onCapture       = "ChangeCapturer"
            },
            {
                name           = "RepairDoer",
                targetCatagory = "Air units",
                targetList     = GameConstant.unitCatagory.airUnits,
                amount         = 2,
            },
            {
                name   = "IncomeProvider",
                amount = GameConstant.incomePerTurn
            },
            --[[
            {
                name = "SupplyProvider",
                target = {12, 13, 14, 15}
            },
            {
                name = "RepairDoer",
                target = {12, 13, 14, 15}
            }
            --]]
        }
    },

    tempseaport = {
        GridIndexable = {},

        defenseBonus = {
            amount         = 30,
            targetCatagory = "Ground/naval units",
            targetList     = GameConstant.unitCatagory.groundOrNavalUnits,
        },

        moveCost = {
            clear = {
                infantry  = 1,
                mech      = 1,
                tireA     = 1,
                tireB     = 1,
                tank      = 1,
                air       = 1,
                ship      = 1,
                transport = 1,
            },
            rain  = {
                infantry  = 1,
                mech      = 1,
                tireA     = 1,
                tireB     = 1,
                tank      = 1,
                air       = 1,
                ship      = 1,
                transport = 1,
            },
            snow  = {
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

        isFullGrid  = false,
        isTileBase  = false,
        description = "A naval base. Allied bases deploy, supply, and restore HP to naval units.",

        specialProperties = {
            {
                name            = "CaptureTaker",
                maxCapturePoint = GameConstant.maxCapturePoint,
                onCapture       = "ChangeCapturer"
            },
            {
                name           = "RepairDoer",
                targetCatagory = "Naval units",
                targetList     = GameConstant.unitCatagory.navalUnits,
                amount         = 2,
            },
            {
                name   = "IncomeProvider",
                amount = GameConstant.incomePerTurn
            },
            --[[
            {
                name = "SupplyProvider",
                target = {16, 17, 18, 19}
            },
            {
                name = "RepairDoer",
                target = {16, 17, 18, 19}
            }
            --]]
        }
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
                name        = "Machine gun",
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
            range = 3,
            type  = "infantry",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 0,
            descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
            destroyOnOutOfFuel     = false,
        },

        cost        = 1500,
        vision      = 2,

        description = "Infantry units have the lowest deployment cost. They can capture bases but have low firepower.",
    },

    mech       = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                name = "Barzooka",
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
                name        = "Machine gun",
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
            range = 2,
            type  = "mech",
        },

        FuelOwner = {
            max                    = 70,
            current                = 70,
            consumptionPerTurn     = 0,
            descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
            destroyOnOutOfFuel     = false,
        },

        cost        = 2500,
        vision      = 2,

        description = "Mech units can capture bases, traverse most terrain types, and have superior firepower.",
    },

    bike       = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon   = nil,
            secondaryWeapon = {
                name        = "Machine gun",
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
            range = 5,
            type  = "tireB",
        },

        FuelOwner = {
            max                    = 70,
            current                = 70,
            consumptionPerTurn     = 0,
            descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
            destroyOnOutOfFuel     = false,
        },

        cost        = 2500,
        vision      = 2,

        description = "Bike is an infantry unit with high mobility. They can capture bases but have low firepower.",
    },

    recon      = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon   = nil,
            secondaryWeapon = {
                name        = "Machine gun",
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
            range = 8,
            type  = "tireA",
        },

        FuelOwner = {
            max                    = 80,
            current                = 80,
            consumptionPerTurn     = 0,
            descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
            destroyOnOutOfFuel     = false,
        },

        cost        = 4000,
        vision      = 5,

        description = "Recon units have high movement range and are strong against infantry units.",
    },

    flare      = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon   = nil,
            secondaryWeapon = {
                name        = "Machine gun",
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
            range = 5,
            type  = "tank",
        },

        FuelOwner = {
            max                    = 60,
            current                = 60,
            consumptionPerTurn     = 0,
            descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
            destroyOnOutOfFuel     = false,
        },

        cost        = 5000,
        vision      = 2,

        description = "Flares fire bright rockets that reveal a 13-square area in Fog of War.",
    },

    antiair    = {
        GridIndexable = {},

        AttackDoer = {
            name               = "AttackDoer",
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                name        = "Cannon",
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
            range = 6,
            type  = "tank",
        },

        FuelOwner = {
            max                    = 60,
            current                = 60,
            consumptionPerTurn     = 0,
            descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
            destroyOnOutOfFuel     = false,
        },

        cost        = 7000,
        vision      = 3,

        description = "Anti-air units work well against infantry and air units. They're weak against tanks.",
    },

    tank       = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                name        = "Tank Gun",
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
                name        = "Machine gun",
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
            range = 6,
            type  = "tank",
        },

        FuelOwner = {
            max                    = 70,
            current                = 70,
            consumptionPerTurn     = 0,
            descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
            destroyOnOutOfFuel     = false,
        },

        cost        = 7000,
        vision      = 3,

        description = "Tank units have high movement range and are inexpensive, so they're easy to deploy.",
    },

    mdtank     = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                name        = "Heavy Tank Gun",
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
                name        = "Machine gun",
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
            range = 5,
            type  = "tank",
        },

        FuelOwner = {
            max                    = 50,
            current                = 50,
            consumptionPerTurn     = 0,
            descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
            destroyOnOutOfFuel     = false,
        },

        cost        = 12000,
        vision      = 2,

        description = "Md(medium) tank units' defensive and offensive ratings are the second best among ground units.",
    },

    wartank    = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                name        = "Mega Gun",
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
                name        = "Machine gun",
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
            range = 4,
            type  = "tank",
        },

        FuelOwner = {
            max                    = 50,
            current                = 50,
            consumptionPerTurn     = 0,
            descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
            destroyOnOutOfFuel     = false,
        },

        cost        = 16000,
        vision      = 2,

        description = "The strongest tank in terms of both attack and defense.",
    },

    artillery  = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 2,
            maxAttackRange     = 3,
            canAttackAfterMove = false,

            primaryWeapon = {
                name       = "Cannon",
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
            range = 5,
            type  = "tank",
        },

        FuelOwner = {
            max                    = 50,
            current                = 50,
            consumptionPerTurn     = 0,
            descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
            destroyOnOutOfFuel     = false,
        },

        cost        = 6000,
        vision      = 3,

        description = "Artillery units are an inexpensive way to gain indirect offensive attack capabilities.",
    },

    antitank  = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 3,
            canAttackAfterMove = false,

            primaryWeapon = {
                name       = "Cannon",
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
            range = 4,
            type  = "tireB",
        },

        FuelOwner = {
            max                    = 50,
            current                = 50,
            consumptionPerTurn     = 0,
            descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
            destroyOnOutOfFuel     = false,
        },

        cost        = 11000,
        vision      = 3,

        description = "An indirect attacker that can counter-attack when under direct fire.",
    },

    rockets    = {
        GridIndexable = {},

        AttackDoer = {
            name               = "AttackDoer",
            minAttackRange     = 3,
            maxAttackRange     = 5,
            canAttackAfterMove = false,

            primaryWeapon = {
                name        = "Rockets",
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
            range = 5,
            type  = "tireA",
        },

        FuelOwner = {
            max                    = 50,
            current                = 50,
            consumptionPerTurn     = 0,
            descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
            destroyOnOutOfFuel     = false,
        },

        cost        = 15000,
        vision      = 3,

        description = "Rocket units are valuable, because they can fire on both land and naval units.",
    },

    missiles   = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 3,
            maxAttackRange     = 6,
            canAttackAfterMove = false,

            primaryWeapon = {
                name        = "AA Missiles",
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
            range = 5,
            type  = "tireA",
        },

        FuelOwner = {
            max                    = 50,
            current                = 50,
            consumptionPerTurn     = 0,
            descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
            destroyOnOutOfFuel     = false,
        },

        cost        = 12000,
        vision      = 5,

        description = "Missile units are essential in defending against air units. Their vision range is large.",
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
            range = 6,
            type  = "tank",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 0,
            descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
            destroyOnOutOfFuel     = false,
        },

        cost        = 5000,
        vision      = 1,

        description = "APC units transport infantry units and supply rations, gas, and ammo to deployed units.",
    },

    fighter    = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                name        = "AA Missiles",
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
            range = 9,
            type  = "air",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 5,
            descriptionOnOutOfFuel = "This unit crashes when out of fuel.",
            destroyOnOutOfFuel     = true,
        },

        cost        = 20000,
        vision      = 5,

        description = "Fighter units are strong vs. other air units. They also have the highest movements.",
    },

    bomber     = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                name        = "Bombs",
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
            range = 7,
            type  = "air",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 5,
            descriptionOnOutOfFuel = "This unit crashes when out of fuel.",
            destroyOnOutOfFuel     = true,
        },

        cost        = 20000,
        vision      = 3,

        description = "Bomber units can fire on ground and naval units with a high destructive force.",
    },

    duster     = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                name        = "Machine Gun",
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
            range = 8,
            type  = "air",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 5,
            descriptionOnOutOfFuel = "This unit crashes when out of fuel.",
            destroyOnOutOfFuel     = true,
        },

        cost        = 13000,
        vision      = 4,

        description = "A somewhat powerful plane that can attack both ground and air units.",
    },

    bcopter    = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                name        = "Missiles",
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
                name        = "Machine gun",
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
            range = 6,
            type  = "air",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 2,
            descriptionOnOutOfFuel = "This unit crashes when out of fuel.",
            destroyOnOutOfFuel     = true,
        },

        cost        = 9000,
        vision      = 2,

        description = "B(Battle) copter units can fire on many unit types, so they're quite valuable.",
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
            range = 6,
            type  = "air",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 2,
            descriptionOnOutOfFuel = "This unit crashes when out of fuel.",
            destroyOnOutOfFuel     = true,
        },

        cost        = 5000,
        vision      = 1,

        description = "T copters can transport both infantry and mech units.",
    },

    seaplane   = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                name        = "Missiles",
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
            range = 7,
            type  = "air",
        },

        FuelOwner = {
            max                    = 40,
            current                = 40,
            consumptionPerTurn     = 5,
            descriptionOnOutOfFuel = "This unit crashes when out of fuel.",
            destroyOnOutOfFuel     = true,
        },

        cost        = 15000,
        vision      = 4,

        description = "A plane produced at sea by carriers. It can attack any unit.",
    },

    battleship = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 3,
            maxAttackRange     = 5,
            canAttackAfterMove = true,

            primaryWeapon = {
                name        = "Cannon",
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
            range = 5,
            type  = "ship",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 1,
            descriptionOnOutOfFuel = "This unit sinks when out of fuel.",
            destroyOnOutOfFuel     = true,
        },

        cost        = 25000,
        vision      = 3,

        description = "B(Battle) ships have a larger attack range than even rocket units.",
    },

    carrier    = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = nil,
            secondaryWeapon = {
                name        = "AA Gun",
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
            range = 5,
            type  = "ship",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 1,
            descriptionOnOutOfFuel = "This unit sinks when out of fuel.",
            destroyOnOutOfFuel     = true,
        },

        cost        = 28000,
        vision      = 4,

        description = "A naval unit that can carrier 2 air units and produce seaplanes.",
    },

    submarine  = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                name        = "Torpedoes",
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
            range = 5,
            type  = "ship",
        },

        FuelOwner = {
            max                    = 70,
            current                = 70,
            consumptionPerTurn     = 1,
            descriptionOnOutOfFuel = "This unit sinks when out of fuel.",
            destroyOnOutOfFuel     = true,
        },

        cost        = 20000,
        vision      = 5,

        description = "Submerged subs are difficult to find, and only cruisers and subs can fire on them.",
    },

    cruiser    = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                name        = "Anti-Ship Missiles",
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
                name        = "AA gun",
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
            range = 6,
            type  = "ship",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 1,
            descriptionOnOutOfFuel = "This unit sinks when out of fuel.",
            destroyOnOutOfFuel     = true,
        },

        cost        = 16000,
        vision      = 5,

        description = "Cruisers are strong against subs and air units, and they can carry two copter units.",
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
            range = 6,
            type  = "transport",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 1,
            descriptionOnOutOfFuel = "This unit sinks when out of fuel.",
            destroyOnOutOfFuel     = true,
        },

        cost        = 10000,
        vision      = 1,

        description = "Landers can transport two ground units. If the lander sinks, the units vanish.",
    },

    gunboat    = {
        GridIndexable = {},

        AttackDoer = {
            minAttackRange     = 1,
            maxAttackRange     = 1,
            canAttackAfterMove = true,

            primaryWeapon = {
                name        = "Anti-Ship Missiles",
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
            range = 7,
            type  = "transport",
        },

        FuelOwner = {
            max                    = 99,
            current                = 99,
            consumptionPerTurn     = 1,
            descriptionOnOutOfFuel = "This unit sinks when out of fuel.",
            destroyOnOutOfFuel     = true,
        },

        cost        = 6000,
        vision      = 2,

        description = "A unit that can carry 1 foot soldier and attack other naval units.",
    },
}

return GameConstant
