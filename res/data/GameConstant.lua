
local GameConstant = {
	GridSize = {width = 80, height = 80},

    Mapping_TiledIdToTemplateModelIdTileOrUnit = {
        -- TiledID 0 + 1
        "hq",          "hq",          "hq",          "hq",          "city",        "city",        "city",        "city",        "city",        "base",
        "base",        "base",        "base",        "base",        "airport",     "airport",     "airport",     "airport",     "airport",     "seaport",
        "seaport",     "seaport",     "seaport",     "seaport",     "plain",       "plain",       "plain",       "plain",       "road",        "road",
        "road",        "road",        "road",        "road",        "road",        "road",        "road",        "road",        "road",        "forest",
        "river",       "river",       "river",       "river",       "river",       "river",       "river",       "river",       "river",       "river",
        "sea",         "sea",         "sea",         "sea",         "sea",         "sea",         "sea",         "sea",         "sea",         "sea",
        "sea",         "sea",         "sea",         "sea",         "sea",         "sea",         "sea",         "sea",         "sea",         "sea",
        "sea",         "sea",         "sea",         "sea",         "sea",         "sea",         "sea",         "sea",         "sea",         "reef",
        "shoal",       "shoal",       "shoal",       "shoal",       "shoal",       "shoal",       "shoal",       "shoal",       "shoal",       "shoal",
        "shoal",       "shoal",       "shoal",       "shoal",       "shoal",       "shoal",       "shoal",       "shoal",       "shoal",       "shoal",

        -- TiledID 100 + 1
        "mountain",    "mountain",    "bridge",      "bridge",      "pipeline",    "pipeline",    "pipeline",    "pipeline",    "pipeline",    "pipeline",
        "pipeline",    "pipeline",    "pipeline",    "pipeline",    "joint",       "joint",       "infantry",    "infantry",    "infantry",    "infantry",
        "mech",        "mech",        "mech",        "mech",        "recon",       "recon",       "recon",       "recon",       "tank",        "tank",
        "tank",        "tank",        "mdtank",      "mdtank",      "mdtank",      "mdtank",      "neotank",     "neotank",     "neotank",     "neotank",
        "apc",         "apc",         "apc",         "apc",         "artillery",   "artillery",   "artillery",   "artillery",   "rockets",     "rockets",
        "rockets",     "rockets",     "antiair",     "antiair",     "antiair",     "antiair",     "missiles",    "missiles",    "missiles",    "missiles",
        "fighter",     "fighter",     "fighter",     "fighter",     "bomber",      "bomber",      "bomber",      "bomber",      "bcopter",     "bcopter",
        "bcopter",     "bcopter",     "tcopter",     "tcopter",     "tcopter",     "tcopter",     "battleship",  "battleship",  "battleship",  "battleship",
        "cruiser",     "cruiser",     "cruiser",     "cruiser",     "lander",      "lander",      "lander",      "lander",      "submarine",   "submarine",
        "submarine",   "submarine",
    },

    Mapping_TiledIdToTemplateViewTileOrUnit = {
        {
            -- TiledID 1
            animations = {
                normal = {pattern = "c01_t01_s01_f%02d.png", framesCount = 2, durationPerFrame = 0.5}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t01_s02_f%02d.png", framesCount = 2, durationPerFrame = 0.5}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t01_s03_f%02d.png", framesCount = 2, durationPerFrame = 0.5}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t01_s04_f%02d.png", framesCount = 2, durationPerFrame = 0.5}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t02_s01_f%02d.png", framesCount = 2, durationPerFrame = 0.5}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t02_s02_f%02d.png", framesCount = 2, durationPerFrame = 0.5}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t02_s03_f%02d.png", framesCount = 2, durationPerFrame = 0.5}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t02_s04_f%02d.png", framesCount = 2, durationPerFrame = 0.5}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t02_s05_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t03_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.25}
            }
        },

        {
            -- TiledID 11
            animations = {
                normal = {pattern = "c01_t03_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.25}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t03_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.25}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t03_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.25}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t03_s05_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t04_s01_f%02d.png", framesCount = 2, durationPerFrame = 0.5}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t04_s02_f%02d.png", framesCount = 2, durationPerFrame = 0.5}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t04_s03_f%02d.png", framesCount = 2, durationPerFrame = 0.5}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t04_s04_f%02d.png", framesCount = 2, durationPerFrame = 0.5}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t04_s05_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t05_s01_f%02d.png", framesCount = 2, durationPerFrame = 0.5}
            }
        },

        {
            -- TiledID 21
            animations = {
                normal = {pattern = "c01_t05_s02_f%02d.png", framesCount = 2, durationPerFrame = 0.5}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t05_s03_f%02d.png", framesCount = 2, durationPerFrame = 0.5}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t05_s04_f%02d.png", framesCount = 2, durationPerFrame = 0.5}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t05_s05_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t06_s01_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t06_s02_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t06_s03_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t06_s04_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t07_s01_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t07_s02_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },

        {
            -- TiledID 31
            animations = {
                normal = {pattern = "c01_t07_s03_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t07_s04_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t07_s05_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t07_s06_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t07_s07_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t07_s08_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t07_s09_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t07_s10_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t07_s11_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t08_s01_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },

        {
            -- TiledID 41
            animations = {
                normal = {pattern = "c01_t09_s01_f%02d.png", framesCount = 8, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t09_s02_f%02d.png", framesCount = 8, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t09_s03_f%02d.png", framesCount = 8, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t09_s04_f%02d.png", framesCount = 8, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t09_s05_f%02d.png", framesCount = 8, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t09_s06_f%02d.png", framesCount = 8, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t09_s07_f%02d.png", framesCount = 8, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t09_s08_f%02d.png", framesCount = 8, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t09_s09_f%02d.png", framesCount = 8, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t09_s10_f%02d.png", framesCount = 8, durationPerFrame = 0.2}
            }
        },

        -- TiledID 50 + 1
        {
            animations = {
                normal = {pattern = "c01_t10_s01_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t10_s02_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t10_s03_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t10_s04_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t10_s05_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t10_s06_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t10_s07_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t10_s08_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t10_s09_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t10_s10_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },

        -- TiledID 60 + 1
        {
            animations = {
                normal = {pattern = "c01_t10_s11_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t10_s12_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t10_s13_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t10_s14_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t10_s15_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t10_s16_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t10_s17_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t10_s18_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t10_s19_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t10_s20_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },

        -- TiledID 70 + 1
        {
            animations = {
                normal = {pattern = "c01_t10_s21_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t10_s22_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t10_s23_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t10_s24_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t10_s25_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t10_s26_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t10_s27_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t10_s28_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t10_s29_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t11_s01_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },

        -- TiledID 80 + 1
        {
            animations = {
                normal = {pattern = "c01_t12_s01_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t12_s02_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t12_s03_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t12_s04_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t12_s05_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t12_s06_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t12_s07_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t12_s08_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t12_s09_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t12_s10_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },

        -- TiledID 90 + 1
        {
            animations = {
                normal = {pattern = "c01_t12_s11_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t12_s12_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t12_s13_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t12_s14_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t12_s15_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t12_s16_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t12_s17_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t12_s18_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t12_s19_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t12_s20_f%02d.png", framesCount = 6, durationPerFrame = 0.2}
            }
        },

        -- TiledID 100 + 1
        {
            animations = {
                normal = {pattern = "c01_t13_s01_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t13_s02_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t14_s01_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t14_s02_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t15_s01_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t15_s02_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t15_s03_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t15_s04_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t15_s05_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t15_s06_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },

        -- TiledID 110 + 1; Units start from "c02..."
        {
            animations = {
                normal = {pattern = "c01_t15_s07_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t15_s08_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t15_s09_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t15_s10_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t16_s01_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c01_t16_s02_f%02d.png", framesCount = 1, durationPerFrame = 99999}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t01_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t01_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t01_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t01_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },

        -- TiledID 120 + 1
        {
            animations = {
                normal = {pattern = "c02_t02_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t02_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t02_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t02_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t03_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t03_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t03_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t03_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t04_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t04_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },

        -- TiledID 130 + 1
        {
            animations = {
                normal = {pattern = "c02_t04_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t04_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t05_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t05_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t05_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t05_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t06_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t06_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t06_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t06_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },

        {
            animations = {
                normal = {pattern = "c02_t07_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },    -- TiledID 140 + 1
        {
            animations = {
                normal = {pattern = "c02_t07_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t07_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t07_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t08_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t08_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t08_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t08_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t09_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t09_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },

        {
            animations = {
                normal = {pattern = "c02_t09_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },    -- TiledID 150 + 1
        {
            animations = {
                normal = {pattern = "c02_t09_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t10_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t10_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t10_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t10_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t11_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t11_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t11_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t11_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },

        {
            animations = {
                normal = {pattern = "c02_t12_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },    -- TiledID 160 + 1
        {
            animations = {
                normal = {pattern = "c02_t12_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t12_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t12_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t13_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t13_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t13_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t13_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t14_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t14_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },

        {
            animations = {
                normal = {pattern = "c02_t14_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },    -- TiledID 170 + 1
        {
            animations = {
                normal = {pattern = "c02_t14_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t15_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t15_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t15_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t15_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t16_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t16_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t16_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t16_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },

        {
            animations = {
                normal = {pattern = "c02_t17_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },    -- TiledID 180 + 1
        {
            animations = {
                normal = {pattern = "c02_t17_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t17_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t17_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t18_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t18_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t18_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t18_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t19_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
        {
            animations = {
                normal = {pattern = "c02_t19_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },

        {
            animations = {
                normal = {pattern = "c02_t19_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },    -- TiledID 190 + 1
        {
            animations = {
                normal = {pattern = "c02_t19_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3}
            }
        },
    },

    Mapping_IdToTemplateModelTile = {
        hq = {
            defenseBonus = 40,
            defenseTarget = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11},

            moveCost = {
                clear = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 1,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
                rain  = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 1,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
                snow  = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 2,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
            },

            description = "An army HQ. Battle ends if it's captured. Ground units get HP and supplies here.",

            specialProperties = {
                {
                    name = "CaptureTaker",
                    onCapture = "Defeat"
                },
                --[[
                {
                    name = "FundProvider"
                },
                {
                    name = "SupplyProvider",
                    target = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}
                },
                {
                    name = "RepairProvider",
                    target = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}
                }
                --]]
            },
        },

        city = {
            defenseBonus = 30,
            defenseTarget = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11},

            moveCost = {
                clear = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 1,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
                rain  = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 1,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
                snow  = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 2,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
            },

            description = "A normal city. Ground units gain supplies and HP in allied cities.",

            specialProperties = {
                {
                    name = "CaptureTaker",
                    onCapture = "ChangeCapturer"
                },
                --[[
                {
                    name = "FundProvider"
                },
                {
                    name = "SupplyProvider",
                    target = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}
                },
                {
                    name = "RepairProvider",
                    target = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}
                }
                --]]
            }
        },

        base = {
            defenseBonus = 30,
            defenseTarget = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11},

            moveCost = {
                clear = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 1,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = 1,
                },
                rain  = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 1,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = 1,
                },
                snow  = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 2,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = 1,
                },
            },

            description = "A base. Allied bases deploy, supply, and restore HP to ground units.",

            specialProperties = {
                {
                    name = "CaptureTaker",
                    onCapture = "ChangeCapturer"
                },
                --[[
                {
                    name = "FundProvider"
                },
                {
                    name = "SupplyProvider",
                    target = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}
                },
                {
                    name = "RepairProvider",
                    target = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}
                }
                --]]
            }
        },

        airport = {
            defenseBonus = 30,
            defenseTarget = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11},

            moveCost = {
                clear = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 1,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
                rain  = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 1,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
                snow  = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 2,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
            },

            description = "An air base. Allied bases deploy, supply, and restore HP to air units.",

            specialProperties = {
                {
                    name = "CaptureTaker",
                    onCapture = "ChangeCapturer"
                },
                --[[
                {
                    name = "FundProvider"
                },
                {
                    name = "SupplyProvider",
                    target = {12, 13, 14, 15}
                },
                {
                    name = "RepairProvider",
                    target = {12, 13, 14, 15}
                }
                --]]
            }
        },

        seaport = {
            defenseBonus = 30,
            defenseTarget = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 16, 17, 18, 19},

            moveCost = {
                clear = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 1,
                    Ship       = 1,
                    Lander     = 1,
                    Piperunner = false,
                },
                rain  = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 1,
                    Ship       = 1,
                    Lander     = 1,
                    Piperunner = false,
                },
                snow  = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 2,
                    Ship       = 2,
                    Lander     = 2,
                    Piperunner = false,
                },
            },

            description = "A naval base. Allied bases deploy, supply, and restore HP to naval units.",

            specialProperties = {
                {
                    name = "CaptureTaker",
                    onCapture = "ChangeCapturer"
                },
                --[[
                {
                    name = "FundProvider"
                },
                {
                    name = "SupplyProvider",
                    target = {16, 17, 18, 19}
                },
                {
                    name = "RepairProvider",
                    target = {16, 17, 18, 19}
                }
                --]]
            }
        },

        plain = {
            defenseBonus = 10,
            defenseTarget = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11},

            moveCost = {
                clear = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 2,
                    Air        = 1,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
                rain  = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 2,
                    Tires      = 3,
                    Air        = 1,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
                snow  = {
                    Infantry   = 2,
                    Mech       = 1,
                    Treads     = 2,
                    Tires      = 3,
                    Air        = 2,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
            },

            description = "A rich, green plain. Easy to traverse, but offers little defensive cover.",
        },

        road = {
            defenseBonus = 0,
            defenseTarget = {},

            moveCost = {
                clear = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 1,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
                rain  = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 1,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
                snow  = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 2,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
            },

            description = "A paved road. Easy to traverse, but offers little defensive cover.",
        },

        forest = {
            defenseBonus = 20,
            defenseTarget = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11},

            moveCost = {
                clear = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 2,
                    Tires      = 3,
                    Air        = 1,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
                rain  = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 3,
                    Tires      = 4,
                    Air        = 1,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
                snow  = {
                    Infantry   = 2,
                    Mech       = 1,
                    Treads     = 3,
                    Tires      = 4,
                    Air        = 2,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
            },

            description = "In Fog of War, units hidden here can only be seen by adjacent units and air units.",
        },

        river = {
            defenseBonus = 0,
            defenseTarget = {},

            moveCost = {
                clear = {
                    Infantry   = 2,
                    Mech       = 1,
                    Treads     = false,
                    Tires      = false,
                    Air        = 1,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
                rain  = {
                    Infantry   = 2,
                    Mech       = 1,
                    Treads     = false,
                    Tires      = false,
                    Air        = 1,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
                snow  = {
                    Infantry   = 2,
                    Mech       = 1,
                    Treads     = false,
                    Tires      = false,
                    Air        = 2,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
            },

            description = "A gentle, flowing river. Only infantry units can ford rivers.",
        },

        sea = {
            defenseBonus = 0,
            defenseTarget = {},

            moveCost = {
                clear = {
                    Infantry   = false,
                    Mech       = false,
                    Treads     = false,
                    Tires      = false,
                    Air        = 1,
                    Ship       = 1,
                    Lander     = 1,
                    Piperunner = false,
                },
                rain  = {
                    Infantry   = false,
                    Mech       = false,
                    Treads     = false,
                    Tires      = false,
                    Air        = 1,
                    Ship       = 1,
                    Lander     = 1,
                    Piperunner = false,
                },
                snow  = {
                    Infantry   = false,
                    Mech       = false,
                    Treads     = false,
                    Tires      = false,
                    Air        = 2,
                    Ship       = 2,
                    Lander     = 2,
                    Piperunner = false,
                },
            },

            description = "A body of water. Only naval and air units can traverse seas.",
        },

        reef = {
            defenseBonus = 10,
            defenseTarget = {16, 17, 18, 19},

            moveCost = {
                clear = {
                    Infantry   = false,
                    Mech       = false,
                    Treads     = false,
                    Tires      = false,
                    Air        = 1,
                    Ship       = 2,
                    Lander     = 2,
                    Piperunner = false,
                },
                rain  = {
                    Infantry   = false,
                    Mech       = false,
                    Treads     = false,
                    Tires      = false,
                    Air        = 1,
                    Ship       = 2,
                    Lander     = 2,
                    Piperunner = false,
                },
                snow  = {
                    Infantry   = false,
                    Mech       = false,
                    Treads     = false,
                    Tires      = false,
                    Air        = 2,
                    Ship       = 2,
                    Lander     = 2,
                    Piperunner = false,
                },
            },

            description = "In Fog of War, units hidden here can only be seen by adjacent units and air units.",
        },

        shoal = {
            defenseBonus = 0,
            defenseTarget = {},

            moveCost = {
                clear = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 1,
                    Ship       = false,
                    Lander     = 1,
                    Piperunner = false,
                },
                rain  = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 1,
                    Ship       = false,
                    Lander     = 1,
                    Piperunner = false,
                },
                snow  = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 2,
                    Ship       = false,
                    Lander     = 1,
                    Piperunner = false,
                },
            },

            description = "A sandy shoal. Lander units load and unload units here.",
        },

        mountain = {
            defenseBonus = 40,
            defenseTarget = {1, 2},

            moveCost = {
                clear = {
                    Infantry   = 2,
                    Mech       = 1,
                    Treads     = false,
                    Tires      = false,
                    Air        = 1,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
                rain  = {
                    Infantry   = 2,
                    Mech       = 1,
                    Treads     = false,
                    Tires      = false,
                    Air        = 1,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
                snow  = {
                    Infantry   = 4,
                    Mech       = 2,
                    Treads     = false,
                    Tires      = false,
                    Air        = 2,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
            },

            description = "A steep mountain. Infantry units add 3 to their vision range from here.",
        },

        bridge = {
            defenseBonus = 0,
            defenseTarget = {},

            moveCost = {
                clear = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 1,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
                rain  = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 1,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
                snow  = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 2,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
            },

            description = "A bridge allows units to traverse rivers, but offers no terrain benefits.",
        },

        pipeline = {
            defenseBonus = 0,
            defenseTarget = {},

            moveCost = {
                clear = {
                    Infantry   = false,
                    Mech       = false,
                    Treads     = false,
                    Tires      = false,
                    Air        = false,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = 1,
                },
                rain  = {
                    Infantry   = false,
                    Mech       = false,
                    Treads     = false,
                    Tires      = false,
                    Air        = false,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = 1,
                },
                snow  = {
                    Infantry   = false,
                    Mech       = false,
                    Treads     = false,
                    Tires      = false,
                    Air        = false,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = 1,
                },
            },

            description = "A pipeline. Thick armor renders it indestructible. No units can pass it.",
        },

        joint = {
            defenseBonus = 0,
            defenseTarget = {},

            moveCost = {
                clear = {
                    Infantry   = false,
                    Mech       = false,
                    Treads     = false,
                    Tires      = false,
                    Air        = false,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = 1,
                },
                rain  = {
                    Infantry   = false,
                    Mech       = false,
                    Treads     = false,
                    Tires      = false,
                    Air        = false,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = 1,
                },
                snow  = {
                    Infantry   = false,
                    Mech       = false,
                    Treads     = false,
                    Tires      = false,
                    Air        = false,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = 1,
                },
            },

            description = "A joint of pipelines. The armor is weaker here than on other sections of the pipeline.",
        },

        silo = {
            defenseBonus = 30,
            defenseTarget = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11},

            moveCost = {
                clear = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 1,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
                rain  = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 1,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
                snow  = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 2,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
            },

            description = "A missile silo. Has a huge blast radius and unlimited range, but can only fire once.",
        },

        cmdtower = {
            defenseBonus = 30,
            defenseTarget = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11},

            moveCost = {
                clear = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 1,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
                rain  = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 1,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
                snow  = {
                    Infantry   = 1,
                    Mech       = 1,
                    Treads     = 1,
                    Tires      = 1,
                    Air        = 2,
                    Ship       = false,
                    Lander     = false,
                    Piperunner = false,
                },
            },

            description = "A command tower.",
        },
    },

    Mapping_IdToTemplateModelUnit = {
        infantry = {
            movementRange = 3,
            movementType  = "Infantry",

            vision        = 2,

            fuel = {
                maxFuel                = 99,
                consumptionPerTurn     = 0,
                descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
                destroyOnOutOfFuel     = false,
            },

            description = "Infantry units have the lowest deployment cost. They can capture bases but have low firepower.",

            specialProperties = {
                {
                    name            = "AttackDoer",
                    primaryWeapon   = nil,
                    secondaryWeapon = {
                        baseDamage  = {55, 45, 12, 5, 1, 1, 14, 15, 25, 5, 26, false, false, 7, 30, false, false, false, false},
                    },
                },
            },
        },

        mech = {
            movementRange = 2,
            movementType  = "Mech",

            vision        = 2,

            fuel = {
                maxFuel                = 70,
                consumptionPerTurn     = 0,
                descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
                destroyOnOutOfFuel     = false,
            },

            description = "Mech units can capture bases, traverse most terrain types, and have superior firepower.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        target      = {},
                        baseDamage  = {false, false, 85, 55, 15, 15, 75, 70, 85, 65, 85, false, false, false, false, false, false, false, false},
                        maxAmmo     = 3,
                    },
                    secondaryWeapon = {
                        baseDamage  = {65, 55, 18, 6, 1, 1, 20, 32, 35, 6, 35, false, false, 9, 35, false, false, false, false},
                    },
                },
            },
        },

        recon = {
            movementRange = 8,
            movementType  = "Tires",

            vision        = 5,

            fuel = {
                maxFuel                = 80,
                consumptionPerTurn     = 0,
                descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
                destroyOnOutOfFuel     = false,
            },

            description = "Recon units have high movement range and are strong against infantry units.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = nil,
                    secondaryWeapon = {
                        baseDamage  = {70, 65, 35, 6, 1, 1, 45, 45, 55, 4, 28, false, false, 12, 35, false, false, false, false},
                    },
                },
            },
        },

        tank = {
            movementRange = 6,
            movementType  = "Treads",

            vision        = 3,

            fuel = {
                maxFuel                = 70,
                consumptionPerTurn     = 0,
                descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
                destroyOnOutOfFuel     = false,
            },

            description = "Tank units have high movement range and are inexpensive, so they're easy to deploy.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        baseDamage  = {false, false, 85, 55, 15, 15, 75, 70, 85, 65, 85, false, false, false, false, 1, 5, 10, 1},
                        maxAmmo     = 9,
                    },
                    secondaryWeapon = {
                        baseDamage  = {75, 70, 40, 6, 1, 1, 45, 45, 55, 5, 30, false, false, 10, 40, false, false, false, false},
                    },
                },
           },
        },

        mdtank = {
            movementRange = 5,
            movementType  = "Treads",

            vision        = 1,

            fuel = {
                maxFuel                = 50,
                consumptionPerTurn     = 0,
                descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
                destroyOnOutOfFuel     = false,
            },

            description = "Md(medium) tank units' defensive and offensive ratings are the second best among ground units.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        baseDamage  = {false, false, 105, 85, 55, 45, 105, 105, 105, 105, 105, false, false, false, false, 10, 45, 35, 10},
                        maxAmmo     = 8,
                    },
                    secondaryWeapon = {
                        baseDamage  = {105, 95, 45, 8, 1, 1, 45, 45, 55, 7, 35, false, false, 12, 45, false, false, false, false},
                    },
                },
            },
        },

        neotank = {
            movementRange = 6,
            movementType  = "Treads",

            vision        = 1,

            fuel = {
                maxFuel                = 99,
                consumptionPerTurn     = 0,
                descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
                destroyOnOutOfFuel     = false,
            },

            description = "Neotank units are new weapons developed recently. They are more powerful than Md tanks.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        baseDamage  = {false, false, 125, 105, 75, 55, 125, 115, 125, 115, 125, false, false, false, false, 15, 50, 50, 15},
                        maxAmmo     = 9,
                    },
                    secondaryWeapon = {
                        baseDamage  = {125, 115, 65, 10, 1, 1, 65, 65, 75, 17, 55, false, false, 22, 55, false, false, false, false},
                    },
                },
            },
        },

        apc = {
            movementRange = 6,
            movementType  = "Treads",

            vision        = 1,

            fuel = {
                maxFuel                = 70,
                consumptionPerTurn     = 0,
                descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
                destroyOnOutOfFuel     = false,
            },

            description = "APC units transport infantry units and supply rations, gas, and ammo to deployed units.",

            specialProperties = {
            },
        },

        artillery = {
            movementRange = 5,
            movementType  = "Treads",

            vision        = 1,

            fuel = {
                maxFuel                = 50,
                consumptionPerTurn     = 0,
                descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
                destroyOnOutOfFuel     = false,
            },

            description = "Artillery units are an inexpensive way to gain indirect offensive attack capabilities.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        baseDamage  = {90, 85, 80, 70, 45, 40, 70, 75, 80, 75, 80, false, false, false, false, 40, 65, 55, 60},
                        maxAmmo     = 9,
                    },
                    secondaryWeapon = nil,
                },
            },
        },

        rockets = {
            movementRange = 5,
            movementType  = "Tires",

            vision        = 1,

            fuel = {
                maxFuel                = 50,
                consumptionPerTurn     = 0,
                descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
                destroyOnOutOfFuel     = false,
            },

            description = "Rocket units are valuable, because they can fire on both land and naval units.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        baseDamage  = {95, 90, 90, 80, 55, 50, 80, 80, 85, 85, 90, false, false, false, false, 55, 85, 60, 85},
                        maxAmmo     = 6,
                    },
                    secondaryWeapon = nil,
                },
            },
        },

        antiair = {
            movementRange = 6,
            movementType  = "Treads",

            vision        = 2,

            fuel = {
                maxFuel                = 60,
                consumptionPerTurn     = 0,
                descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
                destroyOnOutOfFuel     = false,
            },

            description = "Anti-air units work well against infantry and air units. They're weak against tanks.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        baseDamage  = {105, 105, 60, 25, 10, 5, 50, 50, 55, 45, 55, 65, 75, 120, 120, false, false, false, false},
                        maxAmmo     = 9,
                    },
                    secondaryWeapon = nil,
                },
            },
        },

        missiles = {
            movementRange = 5,
            movementType  = "Tires",

            vision        = 5,

            fuel = {
                maxFuel                = 50,
                consumptionPerTurn     = 0,
                descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
                destroyOnOutOfFuel     = false,
            },

            description = "Missile units are essential in defending against air units. Their vision range is large.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        baseDamage  = {false, false, false, false, false, false, false, false, false, false, false, 100, 100, 120, 120, false, false, false, false},
                        maxAmmo     = 6,
                    },
                    secondaryWeapon = nil,
                },
            },
        },

        fighter = {
            movementRange = 9,
            movementType  = "Air",

            vision        = 2,

            fuel = {
                maxFuel                = 99,
                consumptionPerTurn     = 5,
                descriptionOnOutOfFuel = "This unit crashes when out of fuel.",
                destroyOnOutOfFuel     = true,
            },

            description = "Fighter units are strong vs. other air units. They also have the highest movements.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        baseDamage  = {false, false, false, false, false, false, false, false, false, false, false, 55, 100, 100, 100, false, false, false, false},
                        maxAmmo     = 9,
                    },
                    secondaryWeapon = nil,
                },
            },
        },

        bomber = {
            movementRange = 7,
            movementType  = "Air",

            vision        = 2,

            fuel = {
                maxFuel                = 99,
                consumptionPerTurn     = 5,
                descriptionOnOutOfFuel = "This unit crashes when out of fuel.",
                destroyOnOutOfFuel     = true,
            },

            description = "Bomber units can fire on ground and naval units with a high destructive force.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        baseDamage  = {110, 110, 105, 105, 95, 90, 105, 105, 105, 95, 105, false, false, false, false, 75, 85, 95, 95},
                        maxAmmo     = 9,
                    },
                    secondaryWeapon = nil,
                },
            },
        },

        bcopter = {
            movementRange = 6,
            movementType  = "Air",

            vision        = 3,

            fuel = {
                maxFuel                = 99,
                consumptionPerTurn     = 2,
                descriptionOnOutOfFuel = "This unit crashes when out of fuel.",
                destroyOnOutOfFuel     = true,
            },

            description = "B(Battle) copter units can fire on many unit types, so they're quite valuable.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        baseDamage  = {false, false, 55, 55, 25, 20, 60, 65, 65, 25, 65, false, false, false, false, 25, 55, 25, 25},
                        maxAmmo     = 6,
                    },
                    secondaryWeapon = {
                        baseDamage  = {75, 75, 30, 6, 1, 1, 20, 25, 35, 6, 35, false, false, 65, 95, false, false, false, false},
                    },
                },
            },
        },

        tcopter = {
            movementRange = 6,
            movementType  = "Air",

            vision        = 2,

            fuel = {
                maxFuel                = 99,
                consumptionPerTurn     = 2,
                descriptionOnOutOfFuel = "This unit crashes when out of fuel.",
                destroyOnOutOfFuel     = true,
            },

            description = "T copters can transport both infantry and mech units.",

            specialProperties = {
            },
        },

        battleship = {
            movementRange = 5,
            movementType  = "Ship",

            vision        = 2,

            fuel = {
                maxFuel                = 99,
                consumptionPerTurn     = 1,
                descriptionOnOutOfFuel = "This unit sinks when out of fuel.",
                destroyOnOutOfFuel     = true,
            },

            description = "B(Battle) ships have a larger attack range than even rocket units.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        baseDamage  = {95, 90, 90, 80, 55, 50, 80, 80, 85, 85, 90, false, false, false, false, 50, 95, 95, 95},
                        maxAmmo     = 9,
                    },
                    secondaryWeapon = nil,
                },
            },
        },

        cruiser = {
            movementRange = 6,
            movementType  = "Ship",

            vision        = 3,

            fuel = {
                maxFuel                = 99,
                consumptionPerTurn     = 1,
                descriptionOnOutOfFuel = "This unit sinks when out of fuel.",
                destroyOnOutOfFuel     = true,
            },

            description = "Cruisers are strong against subs and air units, and they can carry two copter units.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        baseDamage  = {false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, 90},
                        maxAmmo     = 9,
                    },
                    secondaryWeapon = {
                        baseDamage  = {false, false, false, false, false, false, false, false, false, false, false, 55, 65, 115, 115, false, false, false, false},
                    },
                },
            },
        },

        lander = {
            movementRange = 6,
            movementType  = "Lander",

            vision        = 1,

            fuel = {
                maxFuel                = 99,
                consumptionPerTurn     = 1,
                descriptionOnOutOfFuel = "This unit sinks when out of fuel.",
                destroyOnOutOfFuel     = true,
            },

            description = "Landers can transport two ground units. If the lander sinks, the units vanish.",

            specialProperties = {
            },
        },

        submarine = {
            movementRange = 5,
            movementType  = "Ship",

            vision        = 5,

            fuel = {
                maxFuel                = 60,
                consumptionPerTurn     = 1,
                descriptionOnOutOfFuel = "This unit sinks when out of fuel.",
                destroyOnOutOfFuel     = true,
            },

            description = "Submerged subs are difficult to find, and only cruisers and subs can fire on them.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        baseDamage  = {false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, 55, 25, 95, 55},
                        maxAmmo     = 6,
                    },
                    secondaryWeapon = nil,
                },
            },
        },
    },
}

return GameConstant
