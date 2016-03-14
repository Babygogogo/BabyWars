
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
            defenseTarget = {"infantry", "mech", "recon", "tank", "mdtank", "neotank", "megatank", "apc", "artillery", "rockets", "antiair", "missiles", "piperunner"},

            moveCost = {
                clear = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 1,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
                rain  = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 1,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
                snow  = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 2,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
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
            defenseTarget = {"infantry", "mech", "recon", "tank", "mdtank", "neotank", "megatank", "apc", "artillery", "rockets", "antiair", "missiles", "piperunner"},

            moveCost = {
                clear = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 1,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
                rain  = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 1,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
                snow  = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 2,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
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
            defenseTarget = {"infantry", "mech", "recon", "tank", "mdtank", "neotank", "megatank", "apc", "artillery", "rockets", "antiair", "missiles", "piperunner"},

            moveCost = {
                clear = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 1,
                    ship       = false,
                    lander     = false,
                    piperunner = 1,
                },
                rain  = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 1,
                    ship       = false,
                    lander     = false,
                    piperunner = 1,
                },
                snow  = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 2,
                    ship       = false,
                    lander     = false,
                    piperunner = 1,
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
            defenseTarget = {"infantry", "mech", "recon", "tank", "mdtank", "neotank", "megatank", "apc", "artillery", "rockets", "antiair", "missiles", "piperunner"},

            moveCost = {
                clear = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 1,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
                rain  = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 1,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
                snow  = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 2,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
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
            defenseTarget = {"infantry", "mech", "recon", "tank", "mdtank", "neotank", "megatank", "apc", "artillery", "rockets", "antiair", "missiles", "piperunner",
                             "battleship", "cruiser", "lander", "submarine", "blackboat", "carrier"},

            moveCost = {
                clear = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 1,
                    ship       = 1,
                    lander     = 1,
                    piperunner = false,
                },
                rain  = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 1,
                    ship       = 1,
                    lander     = 1,
                    piperunner = false,
                },
                snow  = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 2,
                    ship       = 2,
                    lander     = 2,
                    piperunner = false,
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
            defenseTarget = {"infantry", "mech", "recon", "tank", "mdtank", "neotank", "megatank", "apc", "artillery", "rockets", "antiair", "missiles", "piperunner"},

            moveCost = {
                clear = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 2,
                    air        = 1,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
                rain  = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 2,
                    tires      = 3,
                    air        = 1,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
                snow  = {
                    infantry   = 2,
                    mech       = 1,
                    treads     = 2,
                    tires      = 3,
                    air        = 2,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
            },

            description = "A rich, green plain. Easy to traverse, but offers little defensive cover.",
        },

        road = {
            defenseBonus = 0,
            defenseTarget = {},

            moveCost = {
                clear = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 1,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
                rain  = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 1,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
                snow  = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 2,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
            },

            description = "A paved road. Easy to traverse, but offers little defensive cover.",
        },

        forest = {
            defenseBonus = 20,
            defenseTarget = {"infantry", "mech", "recon", "tank", "mdtank", "neotank", "megatank", "apc", "artillery", "rockets", "antiair", "missiles", "piperunner"},

            moveCost = {
                clear = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 2,
                    tires      = 3,
                    air        = 1,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
                rain  = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 3,
                    tires      = 4,
                    air        = 1,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
                snow  = {
                    infantry   = 2,
                    mech       = 1,
                    treads     = 3,
                    tires      = 4,
                    air        = 2,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
            },

            description = "In Fog of War, units hidden here can only be seen by adjacent units and air units.",
        },

        river = {
            defenseBonus = 0,
            defenseTarget = {},

            moveCost = {
                clear = {
                    infantry   = 2,
                    mech       = 1,
                    treads     = false,
                    tires      = false,
                    air        = 1,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
                rain  = {
                    infantry   = 2,
                    mech       = 1,
                    treads     = false,
                    tires      = false,
                    air        = 1,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
                snow  = {
                    infantry   = 2,
                    mech       = 1,
                    treads     = false,
                    tires      = false,
                    air        = 2,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
            },

            description = "A gentle, flowing river. Only infantry units can ford rivers.",
        },

        sea = {
            defenseBonus = 0,
            defenseTarget = {},

            moveCost = {
                clear = {
                    infantry   = false,
                    mech       = false,
                    treads     = false,
                    tires      = false,
                    air        = 1,
                    ship       = 1,
                    lander     = 1,
                    piperunner = false,
                },
                rain  = {
                    infantry   = false,
                    mech       = false,
                    treads     = false,
                    tires      = false,
                    air        = 1,
                    ship       = 1,
                    lander     = 1,
                    piperunner = false,
                },
                snow  = {
                    infantry   = false,
                    mech       = false,
                    treads     = false,
                    tires      = false,
                    air        = 2,
                    ship       = 2,
                    lander     = 2,
                    piperunner = false,
                },
            },

            description = "A body of water. Only naval and air units can traverse seas.",
        },

        reef = {
            defenseBonus = 10,
            defenseTarget = {"battleship", "cruiser", "lander", "submarine", "blackboat", "carrier"},

            moveCost = {
                clear = {
                    infantry   = false,
                    mech       = false,
                    treads     = false,
                    tires      = false,
                    air        = 1,
                    ship       = 2,
                    lander     = 2,
                    piperunner = false,
                },
                rain  = {
                    infantry   = false,
                    mech       = false,
                    treads     = false,
                    tires      = false,
                    air        = 1,
                    ship       = 2,
                    lander     = 2,
                    piperunner = false,
                },
                snow  = {
                    infantry   = false,
                    mech       = false,
                    treads     = false,
                    tires      = false,
                    air        = 2,
                    ship       = 2,
                    lander     = 2,
                    piperunner = false,
                },
            },

            description = "In Fog of War, units hidden here can only be seen by adjacent units and air units.",
        },

        shoal = {
            defenseBonus = 0,
            defenseTarget = {},

            moveCost = {
                clear = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 1,
                    ship       = false,
                    lander     = 1,
                    piperunner = false,
                },
                rain  = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 1,
                    ship       = false,
                    lander     = 1,
                    piperunner = false,
                },
                snow  = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 2,
                    ship       = false,
                    lander     = 1,
                    piperunner = false,
                },
            },

            description = "A sandy shoal. Lander units load and unload units here.",
        },

        mountain = {
            defenseBonus = 40,
            defenseTarget = {"infantry", "mech"},

            moveCost = {
                clear = {
                    infantry   = 2,
                    mech       = 1,
                    treads     = false,
                    tires      = false,
                    air        = 1,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
                rain  = {
                    infantry   = 2,
                    mech       = 1,
                    treads     = false,
                    tires      = false,
                    air        = 1,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
                snow  = {
                    infantry   = 4,
                    mech       = 2,
                    treads     = false,
                    tires      = false,
                    air        = 2,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
            },

            description = "A steep mountain. Infantry units add 3 to their vision range from here.",
        },

        bridge = {
            defenseBonus = 0,
            defenseTarget = {},

            moveCost = {
                clear = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 1,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
                rain  = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 1,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
                snow  = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 2,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
            },

            description = "A bridge allows units to traverse rivers, but offers no terrain benefits.",
        },

        pipeline = {
            defenseBonus = 0,
            defenseTarget = {},

            moveCost = {
                clear = {
                    infantry   = false,
                    mech       = false,
                    treads     = false,
                    tires      = false,
                    air        = false,
                    ship       = false,
                    lander     = false,
                    piperunner = 1,
                },
                rain  = {
                    infantry   = false,
                    mech       = false,
                    treads     = false,
                    tires      = false,
                    air        = false,
                    ship       = false,
                    lander     = false,
                    piperunner = 1,
                },
                snow  = {
                    infantry   = false,
                    mech       = false,
                    treads     = false,
                    tires      = false,
                    air        = false,
                    ship       = false,
                    lander     = false,
                    piperunner = 1,
                },
            },

            description = "A pipeline. Thick armor renders it indestructible. No units can pass it.",
        },

        joint = {
            defenseBonus = 0,
            defenseTarget = {},

            moveCost = {
                clear = {
                    infantry   = false,
                    mech       = false,
                    treads     = false,
                    tires      = false,
                    air        = false,
                    ship       = false,
                    lander     = false,
                    piperunner = 1,
                },
                rain  = {
                    infantry   = false,
                    mech       = false,
                    treads     = false,
                    tires      = false,
                    air        = false,
                    ship       = false,
                    lander     = false,
                    piperunner = 1,
                },
                snow  = {
                    infantry   = false,
                    mech       = false,
                    treads     = false,
                    tires      = false,
                    air        = false,
                    ship       = false,
                    lander     = false,
                    piperunner = 1,
                },
            },

            description = "A joint of pipelines. The armor is weaker here than on other sections of the pipeline.",
        },

        silo = {
            defenseBonus = 30,
            defenseTarget = {"infantry", "mech", "recon", "tank", "mdtank", "neotank", "megatank", "apc", "artillery", "rockets", "antiair", "missiles", "piperunner"},

            moveCost = {
                clear = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 1,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
                rain  = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 1,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
                snow  = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 2,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
            },

            description = "A missile silo. Has a huge blast radius and unlimited range, but can only fire once.",
        },

        cmdtower = {
            defenseBonus = 30,
            defenseTarget = {"infantry", "mech", "recon", "tank", "mdtank", "neotank", "megatank", "apc", "artillery", "rockets", "antiair", "missiles", "piperunner"},

            moveCost = {
                clear = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 1,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
                rain  = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 1,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
                snow  = {
                    infantry   = 1,
                    mech       = 1,
                    treads     = 1,
                    tires      = 1,
                    air        = 2,
                    ship       = false,
                    lander     = false,
                    piperunner = false,
                },
            },

            description = "A command tower.",
        },
    },

    Mapping_IdToTemplateModelUnit = {
        infantry = {
            movementRange = 3,
            movementType  = "infantry",

            vision        = 2,

            fuel = {
                maxFuel                = 99,
                consumptionPerTurn     = 0,
                descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
                destroyOnOutOfFuel     = false,
            },

            defense = {
                fatal = {
                    "mdtank", "neotank", "artillery", "rockets", "antiair", "bomber", "battleship"
                },
                weak   = {
                    "infantry", "mech", "recon", "tank", "bcopter"
                },
            },

            description = "Infantry units have the lowest deployment cost. They can capture bases but have low firepower.",

            specialProperties = {
                {
                    name            = "AttackDoer",
                    primaryWeapon   = nil,
                    secondaryWeapon = {
                        baseDamage  = {
                            infantry = 55,
                            mech = 45,
                            recon = 12,
                            tank = 5,
                            mdtank = 1,
                            neotank = 1,
                            apc = 14,
                            artillery = 15,
                            rockets = 25,
                            antiair = 5,
                            missiles = 26,
                            fighter = false,
                            bomber = false,
                            bcopter = 7,
                            tcopter = 30,
                            battleship = false,
                            cruiser = false,
                            lander = false,
                            submarine = false,
                        },
                        fatal  = {},
                        strong = {
                            "infantry", "mech"
                        }
                    },
                },
            },
        },

        mech = {
            movementRange = 2,
            movementType  = "mech",

            vision        = 2,

            fuel = {
                maxFuel                = 70,
                consumptionPerTurn     = 0,
                descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
                destroyOnOutOfFuel     = false,
            },

            defense = {
                fatal = {
                    "mdtank", "neotank", "artillery", "rockets", "antiair", "bomber", "battleship"
                },
                weak   = {
                    "infantry", "mech", "recon", "tank", "bcopter"
                },
            },

            description = "Mech units can capture bases, traverse most terrain types, and have superior firepower.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        baseDamage  = {
                            infantry = false,
                            mech = false,
                            recon = 85,
                            tank = 55,
                            mdtank = 15,
                            neotank = 15,
                            apc = 75,
                            artillery = 70,
                            rockets = 85,
                            antiair = 65,
                            missiles = 85,
                            fighter = false,
                            bomber = false,
                            bcopter = false,
                            tcopter = false,
                            battleship = false,
                            cruiser = false,
                            lander = false,
                            submarine = false,
                        },
                        fatal  = {
                            "recon", "rockets", "missiles"
                        },
                        strong = {
                            "tank", "apc", "artillery", "antiair"
                        },
                        maxAmmo     = 3,
                    },
                    secondaryWeapon = {
                        baseDamage  = {
                            infantry = 65,
                            mech = 55,
                            recon = 18,
                            tank = 6,
                            mdtank = 1,
                            neotank = 1,
                            apc = 20,
                            artillery = 32,
                            rockets = 35,
                            antiair = 6,
                            missiles = 35,
                            fighter = false,
                            bomber = false,
                            bcopter = 9,
                            tcopter = 35,
                            battleship = false,
                            cruiser = false,
                            lander = false,
                            submarine = false,
                        },
                        fatal  = {},
                        strong = {
                            "infantry", "mech"
                        }
                    },
                },
            },
        },

        recon = {
            movementRange = 8,
            movementType  = "tires",

            vision        = 5,

            fuel = {
                maxFuel                = 80,
                consumptionPerTurn     = 0,
                descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
                destroyOnOutOfFuel     = false,
            },

            defense = {
                fatal = {
                    "mech", "tank", "mdtank", "neotank", "artillery", "rockets", "bomber", "battleship"
                },
                weak   = {
                    "antiair", "bcopter"
                },
            },

            description = "Recon units have high movement range and are strong against infantry units.",

            specialProperties = {
                {
                    name            = "AttackDoer",
                    primaryWeapon   = nil,
                    secondaryWeapon = {
                        baseDamage  = {
                            infantry = 70,
                            mech = 65,
                            recon = 35,
                            tank = 6,
                            mdtank = 1,
                            neotank = 1,
                            apc = 45,
                            artillery = 45,
                            rockets = 55,
                            antiair = 4,
                            missiles = 28,
                            fighter = false,
                            bomber = false,
                            bcopter = 12,
                            tcopter = 35,
                            battleship = false,
                            cruiser = false,
                            lander = false,
                            submarine = false,
                        },
                        fatal  = {},
                        strong = {
                            "infantry", "mech", "apc", "artillery", "rockets"
                        },
                    },
                },
            },
        },

        tank = {
            movementRange = 6,
            movementType  = "treads",

            vision        = 3,

            fuel = {
                maxFuel                = 70,
                consumptionPerTurn     = 0,
                descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
                destroyOnOutOfFuel     = false,
            },

            defense = {
                fatal = {
                    "mdtank", "neotank", "rockets", "bomber", "battleship"
                },
                weak   = {
                    "mech", "tank", "artillery", "bcopter"
                },
            },

            description = "Tank units have high movement range and are inexpensive, so they're easy to deploy.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        baseDamage  = {
                            infantry = false,
                            mech = false,
                            recon = 85,
                            tank = 55,
                            mdtank = 15,
                            neotank = 15,
                            apc = 75,
                            artillery = 70,
                            rockets = 85,
                            antiair = 65,
                            missiles = 85,
                            fighter = false,
                            bomber = false,
                            bcopter = false,
                            tcopter = false,
                            battleship = 1,
                            cruiser = 5,
                            lander = 10,
                            submarine = 1,
                        },
                        maxAmmo     = 9,
                        fatal  = {
                            "recon", "rockets", "missiles"
                        },
                        strong = {
                            "tank", "apc", "artillery", "antiair"
                        },
                    },
                    secondaryWeapon = {
                        baseDamage  = {
                            infantry = 75,
                            mech = 70,
                            recon = 40,
                            tank = 6,
                            mdtank = 1,
                            neotank = 1,
                            apc = 45,
                            artillery = 45,
                            rockets = 55,
                            antiair = 5,
                            missiles = 30,
                            fighter = false,
                            bomber = false,
                            bcopter = 10,
                            tcopter = 40,
                            battleship = false,
                            cruiser = false,
                            lander = false,
                            submarine = false,
                        },
                        fatal  = {},
                        strong = {
                            "infantry", "mech", "recon", "apc", "artillery", "rockets", "tcopter"
                        }
                    },
                },
           },
        },

        mdtank = {
            movementRange = 5,
            movementType  = "treads",

            vision        = 1,

            fuel = {
                maxFuel                = 50,
                consumptionPerTurn     = 0,
                descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
                destroyOnOutOfFuel     = false,
            },

            defense = {
                fatal = {
                    "bomber"
                },
                weak   = {
                    "mdtank", "neotank", "artillery", "rockets", "battleship"
                },
            },

            description = "Md(medium) tank units' defensive and offensive ratings are the second best among ground units.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        baseDamage  = {
                            infantry = false,
                            mech = false,
                            recon = 105,
                            tank = 85,
                            mdtank = 55,
                            neotank = 45,
                            apc = 105,
                            artillery = 105,
                            rockets = 105,
                            antiair = 105,
                            missiles = 105,
                            fighter = false,
                            bomber = false,
                            bcopter = false,
                            tcopter = false,
                            battleship = 10,
                            cruiser = 45,
                            lander = 35,
                            submarine = 10,
                        },
                        fatal  = {
                            "recon", "tank", "apc", "artillery", "rockets", "antiair", "missiles"
                        },
                        strong = {
                            "mdtank", "neotank", "cruiser"
                        },
                        maxAmmo     = 8,
                    },
                    secondaryWeapon = {
                        baseDamage  = {
                            infantry = 105,
                            mech = 95,
                            recon = 45,
                            tank = 8,
                            mdtank = 1,
                            neotank = 1,
                            apc = 45,
                            artillery = 45,
                            rockets = 55,
                            antiair = 7,
                            missiles = 35,
                            fighter = false,
                            bomber = false,
                            bcopter = 12,
                            tcopter = 45,
                            battleship = false,
                            cruiser = false,
                            lander = false,
                            submarine = false,
                        },
                        fatal  = {
                            "infantry", "mech"
                        },
                        strong = {
                            "recon", "apc", "artillery", "rockets", "tcopter"
                        }
                    },
                },
            },
        },

        neotank = {
            movementRange = 6,
            movementType  = "treads",

            vision        = 1,

            fuel = {
                maxFuel                = 99,
                consumptionPerTurn     = 0,
                descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
                destroyOnOutOfFuel     = false,
            },

            defense = {
                fatal = {
                    "bomber"
                },
                weak   = {
                    "mdtank", "neotank", "artillery", "rockets", "battleship"
                },
            },

            description = "Neotank units are new weapons developed recently. They are more powerful than Md tanks.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        baseDamage  = {
                            infantry = false,
                            mech = false,
                            recon = 125,
                            tank = 105,
                            mdtank = 75,
                            neotank = 55,
                            apc = 125,
                            artillery = 115,
                            rockets = 125,
                            antiair = 115,
                            missiles = 125,
                            fighter = false,
                            bomber = false,
                            bcopter = false,
                            tcopter = false,
                            battleship = 15,
                            cruiser = 50,
                            lander = 50,
                            submarine = 15,
                        },
                        fatal  = {
                            "recon", "tank", "apc", "artillery", "rockets", "antiair", "missiles"
                        },
                        strong = {
                            "mdtank", "neotank", "cruiser", "lander"
                        },
                        maxAmmo     = 9,
                    },
                    secondaryWeapon = {
                        baseDamage  = {
                            infantry = 125,
                            mech = 115,
                            recon = 65,
                            tank = 10,
                            mdtank = 1,
                            neotank = 1,
                            apc = 65,
                            artillery = 65,
                            rockets = 75,
                            antiair = 17,
                            missiles = 55,
                            fighter = false,
                            bomber = false,
                            bcopter = 22,
                            tcopter = 55,
                            battleship = false,
                            cruiser = false,
                            lander = false,
                            submarine = false,
                        },
                        fatal  = {
                            "infantry", "mech"
                        },
                        strong = {
                            "recon", "apc", "artillery", "rockets", "missiles", "tcopter"
                        },
                    },
                },
            },
        },

        apc = {
            movementRange = 6,
            movementType  = "treads",

            vision        = 1,

            fuel = {
                maxFuel                = 70,
                consumptionPerTurn     = 0,
                descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
                destroyOnOutOfFuel     = false,
            },

            defendse = {
                fatal = {
                    "mdtank", "neotank", "rockets", "bomber", "battleship"
                },
                weak = {
                    "mech", "recon", "tank", "artillery", "antiair", "bcopter"
                },
            },

            description = "APC units transport infantry units and supply rations, gas, and ammo to deployed units.",

            specialProperties = {
            },
        },

        artillery = {
            movementRange = 5,
            movementType  = "treads",

            vision        = 1,

            fuel = {
                maxFuel                = 50,
                consumptionPerTurn     = 0,
                descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
                destroyOnOutOfFuel     = false,
            },

            defendse = {
                fatal = {
                    "mdtank", "neotank", "rockets", "bomber", "battleship"
                },
                weak = {
                    "mech", "recon", "tank", "artillery", "antiair", "bcopter"
                },
            },

            description = "Artillery units are an inexpensive way to gain indirect offensive attack capabilities.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        baseDamage  = {
                            infantry = 90,
                            mech = 85,
                            recon = 80,
                            tank = 70,
                            mdtank = 45,
                            neotank = 40,
                            apc = 70,
                            artillery = 75,
                            rockets = 80,
                            antiair = 75,
                            missiles = 80,
                            fighter = false,
                            bomber = false,
                            bcopter = false,
                            tcopter = false,
                            battleship = 40,
                            cruiser = 65,
                            lander = 55,
                            submarine = 60,
                        },
                        fatal  = {
                            "infantry", "mech", "recon", "rockets", "missiles"
                        },
                        strong = {
                            "tank", "mdtank", "neotank", "apc", "artillery", "antiair", "battleship", "cruiser", "lander", "submarine"
                        },
                        maxAmmo     = 9,
                    },
                    secondaryWeapon = nil,
                },
            },
        },

        rockets = {
            movementRange = 5,
            movementType  = "tires",

            vision        = 1,

            fuel = {
                maxFuel                = 50,
                consumptionPerTurn     = 0,
                descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
                destroyOnOutOfFuel     = false,
            },

            defendse = {
                fatal = {
                    "mech", "tank", "mdtank", "neotank", "artillery", "rockets", "bomber", "battleship"
                },
                weak = {
                    "recon", "antiair", "bcopter"
                },
            },

            description = "Rocket units are valuable, because they can fire on both land and naval units.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        baseDamage  = {
                            infantry = 95,
                            mech = 90,
                            recon = 90,
                            tank = 80,
                            mdtank = 55,
                            neotank = 50,
                            apc = 80,
                            artillery = 80,
                            rockets = 85,
                            antiair = 85,
                            missiles = 90,
                            fighter = false,
                            bomber = false,
                            bcopter = false,
                            tcopter = false,
                            battleship = 55,
                            cruiser = 85,
                            lander = 60,
                            submarine = 85,
                        },
                        fatal  = {
                            "infantry", "mech", "recon", "tank", "apc", "artillery", "rockets", "antiair", "missiles", "cruiser", "submarine"
                        },
                        strong = {
                            "mdtank", "neotank", "battleship", "lander",
                        },
                        maxAmmo     = 6,
                    },
                    secondaryWeapon = nil,
                },
            },
        },

        antiair = {
            movementRange = 6,
            movementType  = "treads",

            vision        = 2,

            fuel = {
                maxFuel                = 60,
                consumptionPerTurn     = 0,
                descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
                destroyOnOutOfFuel     = false,
            },

            defendse = {
                fatal = {
                    "mdtank", "neotank", "rockets", "bomber", "battleship"
                },
                weak = {
                    "mech", "tank", "artillery", "antiair"
                },
            },

            description = "Anti-air units work well against infantry and air units. They're weak against tanks.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        baseDamage  = {
                            infantry = 105,
                            mech = 105,
                            recon = 60,
                            tank = 25,
                            mdtank = 10,
                            neotank = 5,
                            apc = 50,
                            artillery = 50,
                            rockets = 55,
                            antiair = 45,
                            missiles = 55,
                            fighter = 65,
                            bomber = 75,
                            bcopter = 120,
                            tcopter = 120,
                            battleship = false,
                            cruiser = false,
                            lander = false,
                            submarine = false,
                        },
                        fatal = {
                            "infantry", "mech", "bcopter", "tcopter"
                        },
                        strong = {
                            "recon", "apc", "artillery", "rockets", "antiair", "missiles", "fighter", "bomber"
                        },
                        maxAmmo     = 9,
                    },
                    secondaryWeapon = nil,
                },
            },
        },

        missiles = {
            movementRange = 5,
            movementType  = "tires",

            vision        = 5,

            fuel = {
                maxFuel                = 50,
                consumptionPerTurn     = 0,
                descriptionOnOutOfFuel = "This unit can't move when out of fuel.",
                destroyOnOutOfFuel     = false,
            },

            defendse = {
                fatal = {
                    "mech", "tank", "mdtank", "neotank", "artillery", "rockets", "bomber", "battleship"
                },
                weak = {
                    "antiair", "bcopter"
                },
            },

            description = "Missile units are essential in defending against air units. Their vision range is large.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        baseDamage  = {
                            infantry = false,
                            mech = false,
                            recon = false,
                            tank = false,
                            mdtank = false,
                            neotank = false,
                            apc = false,
                            artillery = false,
                            rockets = false,
                            antiair = false,
                            missiles = false,
                            fighter = 100,
                            bomber = 100,
                            bcopter = 120,
                            tcopter = 120,
                            battleship = false,
                            cruiser = false,
                            lander = false,
                            submarine = false,
                        },
                        fatal = {
                            "fighter", "bomber", "bcopter", "tcopter"
                        },
                        strong = {
                        },
                        maxAmmo     = 6,
                    },
                    secondaryWeapon = nil,
                },
            },
        },

        fighter = {
            movementRange = 9,
            movementType  = "air",

            vision        = 2,

            fuel = {
                maxFuel                = 99,
                consumptionPerTurn     = 5,
                descriptionOnOutOfFuel = "This unit crashes when out of fuel.",
                destroyOnOutOfFuel     = true,
            },

            defendse = {
                fatal = {
                    "missiles"
                },
                weak = {
                    "antiair", "fighter", "cruiser"
                },
            },

            description = "Fighter units are strong vs. other air units. They also have the highest movements.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        baseDamage  = {
                            infantry = false,
                            mech = false,
                            recon = false,
                            tank = false,
                            mdtank = false,
                            neotank = false,
                            apc = false,
                            artillery = false,
                            rockets = false,
                            antiair = false,
                            missiles = false,
                            fighter = 55,
                            bomber = 100,
                            bcopter = 100,
                            tcopter = 100,
                            battleship = false,
                            cruiser = false,
                            lander = false,
                            submarine = false,
                        },
                        fatal = {
                            "bomber", "bcopter", "tcopter"
                        },
                        strong = {
                            "fighter"
                        },
                        maxAmmo     = 9,
                    },
                    secondaryWeapon = nil,
                },
            },
        },

        bomber = {
            movementRange = 7,
            movementType  = "air",

            vision        = 2,

            fuel = {
                maxFuel                = 99,
                consumptionPerTurn     = 5,
                descriptionOnOutOfFuel = "This unit crashes when out of fuel.",
                destroyOnOutOfFuel     = true,
            },

            defense = {
                fatal = {
                    "missiles", "fighter"
                },
                weak = {
                    "antiair", "cruiser"
                },
            },

            description = "Bomber units can fire on ground and naval units with a high destructive force.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        baseDamage  = {
                            infantry = 110,
                            mech = 110,
                            recon = 105,
                            tank = 105,
                            mdtank = 95,
                            neotank = 90,
                            apc = 105,
                            artillery = 105,
                            rockets = 105,
                            antiair = 95,
                            missiles = 105,
                            fighter = false,
                            bomber = false,
                            bcopter = false,
                            tcopter = false,
                            battleship = 75,
                            cruiser = 85,
                            lander = 95,
                            submarine = 95,
                        },
                        fatal = {
                            "infantry", "mech", "recon", "tank", "mdtank", "neotank", "apc", "artillery", "rockets", "antiair", "missiles", "cruiser", "lander", "submarine"
                        },
                        strong = {
                            "battleship"
                        },
                        maxAmmo     = 9,
                    },
                    secondaryWeapon = nil,
                },
            },
        },

        bcopter = {
            movementRange = 6,
            movementType  = "air",

            vision        = 3,

            fuel = {
                maxFuel                = 99,
                consumptionPerTurn     = 2,
                descriptionOnOutOfFuel = "This unit crashes when out of fuel.",
                destroyOnOutOfFuel     = true,
            },

            defense = {
                fatal = {
                    "antiair", "missiles", "fighter", "cruiser"
                },
                weak = {
                    "bcopter"
                },
            },

            description = "B(Battle) copter units can fire on many unit types, so they're quite valuable.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        baseDamage  = {
                            infantry = false,
                            mech = false,
                            recon = 55,
                            tank = 55,
                            mdtank = 25,
                            neotank = 20,
                            apc = 60,
                            artillery = 65,
                            rockets = 65,
                            antiair = 25,
                            missiles = 65,
                            fighter = false,
                            bomber = false,
                            bcopter = false,
                            tcopter = false,
                            battleship = 25,
                            cruiser = 55,
                            lander = 25,
                            submarine = 25,
                        },
                        fatal = {
                        },
                        strong = {
                            "recon", "tank", "apc", "artillery", "rockets", "missiles", "cruiser"
                        },
                        maxAmmo     = 6,
                    },
                    secondaryWeapon = {
                        baseDamage  = {
                            infantry = 75,
                            mech = 75,
                            recon = 30,
                            tank = 6,
                            mdtank = 1,
                            neotank = 1,
                            apc = 20,
                            artillery = 25,
                            rockets = 35,
                            antiair = 6,
                            missiles = 35,
                            fighter = false,
                            bomber = false,
                            bcopter = 65,
                            tcopter = 95,
                            battleship = false,
                            cruiser = false,
                            lander = false,
                            submarine = false,
                        },
                        fatal = {
                            "tcopter"
                        },
                        strong = {
                            "infantry", "mech", "bcopter"
                        },
                    },
                },
            },
        },

        tcopter = {
            movementRange = 6,
            movementType  = "air",

            vision        = 2,

            fuel = {
                maxFuel                = 99,
                consumptionPerTurn     = 2,
                descriptionOnOutOfFuel = "This unit crashes when out of fuel.",
                destroyOnOutOfFuel     = true,
            },

            defense = {
                fatal = {
                    "antiair", "missiles", "fighter", "bcopter", "cruiser"
                },
                weak = {
                    "tank", "mdtank", "neotank"
                },
            },

            description = "T copters can transport both infantry and mech units.",

            specialProperties = {
            },
        },

        battleship = {
            movementRange = 5,
            movementType  = "ship",

            vision        = 2,

            fuel = {
                maxFuel                = 99,
                consumptionPerTurn     = 1,
                descriptionOnOutOfFuel = "This unit sinks when out of fuel.",
                destroyOnOutOfFuel     = true,
            },

            defense = {
                fatal = {
                },
                weak = {
                    "artillery", "rockets", "bomber", "battleship", "submarine"
                },
            },

            description = "B(Battle) ships have a larger attack range than even rocket units.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        baseDamage  = {
                            infantry = 95,
                            mech = 90,
                            recon = 90,
                            tank = 80,
                            mdtank = 55,
                            neotank = 50,
                            apc = 80,
                            artillery = 80,
                            rockets = 85,
                            antiair = 85,
                            missiles = 90,
                            fighter = false,
                            bomber = false,
                            bcopter = false,
                            tcopter = false,
                            battleship = 50,
                            cruiser = 95,
                            lander = 95,
                            submarine = 95,
                        },
                        fatal = {
                            "infantry", "mech", "recon", "tank", "apc", "artillery", "rockets", "antiair", "missiles", "cruiser", "lander", "submarine"
                        },
                        strong = {
                            "mdtank", "neotank", "battleship"
                        },
                        maxAmmo     = 9,
                    },
                    secondaryWeapon = nil,
                },
            },
        },

        cruiser = {
            movementRange = 6,
            movementType  = "ship",

            vision        = 3,

            fuel = {
                maxFuel                = 99,
                consumptionPerTurn     = 1,
                descriptionOnOutOfFuel = "This unit sinks when out of fuel.",
                destroyOnOutOfFuel     = true,
            },

            defense = {
                fatal = {
                    "rockets", "bomber", "battleship"
                },
                weak = {
                    "mdtank", "neotank", "artillery", "bcopter"
                },
            },

            description = "Cruisers are strong against subs and air units, and they can carry two copter units.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        baseDamage  = {
                            infantry = false,
                            mech = false,
                            recon = false,
                            tank = false,
                            mdtank = false,
                            neotank = false,
                            apc = false,
                            artillery = false,
                            rockets = false,
                            antiair = false,
                            missiles = false,
                            fighter = false,
                            bomber = false,
                            bcopter = false,
                            tcopter = false,
                            battleship = false,
                            cruiser = false,
                            lander = false,
                            submarine = 90,
                        },
                        fatal = {
                            "submarine"
                        },
                        strong = {
                        },
                        maxAmmo     = 9,
                    },
                    secondaryWeapon = {
                        baseDamage  = {
                            infantry = false,
                            mech = false,
                            recon = false,
                            tank = false,
                            mdtank = false,
                            neotank = false,
                            apc = false,
                            artillery = false,
                            rockets = false,
                            antiair = false,
                            missiles = false,
                            fighter = 55,
                            bomber = 65,
                            bcopter = 115,
                            tcopter = 115,
                            battleship = false,
                            cruiser = false,
                            lander = false,
                            submarine = false,
                        },
                        fatal = {
                            "bcopter", "tcopter"
                        },
                        strong = {
                            "fighter", "bomber"
                        },
                    },
                },
            },
        },

        lander = {
            movementRange = 6,
            movementType  = "lander",

            vision        = 1,

            fuel = {
                maxFuel                = 99,
                consumptionPerTurn     = 1,
                descriptionOnOutOfFuel = "This unit sinks when out of fuel.",
                destroyOnOutOfFuel     = true,
            },

            defense = {
                fatal = {
                    "bomber", "battleship", "submarine"
                },
                weak = {
                    "neotank", "artillery", "rockets"
                },
            },

            description = "Landers can transport two ground units. If the lander sinks, the units vanish.",

            specialProperties = {
            },
        },

        submarine = {
            movementRange = 5,
            movementType  = "ship",

            vision        = 5,

            fuel = {
                maxFuel                = 60,
                consumptionPerTurn     = 1,
                descriptionOnOutOfFuel = "This unit sinks when out of fuel.",
                destroyOnOutOfFuel     = true,
            },

            defense = {
                fatal = {
                    "rockets", "bomber", "battleship", "cruiser"
                },
                weak = {
                    "artillery", "submarine"
                },
            },

            description = "Submerged subs are difficult to find, and only cruisers and subs can fire on them.",

            specialProperties = {
                {
                    name         = "AttackDoer",
                    primaryWeapon = {
                        baseDamage  = {
                            infantry = false,
                            mech = false,
                            recon = false,
                            tank = false,
                            mdtank = false,
                            neotank = false,
                            apc = false,
                            artillery = false,
                            rockets = false,
                            antiair = false,
                            missiles = false,
                            fighter = false,
                            bomber = false,
                            bcopter = false,
                            tcopter = false,
                            battleship = 55,
                            cruiser = 25,
                            lander = 95,
                            submarine = 55,
                        },
                        fatal = {
                            "lander"
                        },
                        strong = {
                            "battleship", "submarine"
                        },
                        maxAmmo     = 6,
                    },
                    secondaryWeapon = nil,
                },
            },
        },
    },
}

return GameConstant
