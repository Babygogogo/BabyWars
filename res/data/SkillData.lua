
local SkillData = {}

SkillData.minBasePoints                   = 0
SkillData.maxBasePoints                   = 1000
SkillData.basePointsPerStep               = 25
SkillData.minEnergyRequirement            = 1
SkillData.maxEnergyRequirement            = 15
SkillData.skillPointsPerEnergyRequirement = 100
SkillData.damageCostPerEnergyRequirement  = 18000
SkillData.damageCostGrowthRates           = 20
SkillData.skillConfigurationsCount        = 10
SkillData.passiveSkillSlotsCount          = 4
SkillData.activeSkillSlotsCount           = 4

SkillData.categories = {
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
        -- 29,
        30,
        31,
        32,
        33,
        34,
        -- 35,
        36,
    },

    ["SkillCategoryActiveAttack"] = {
        1,
        20,
        23,
        14,
        25,
        -- 29,
        30,
        31,
        32,
        33,
        34,
        -- 35,
        36,
    },

    ["SkillCategoryPassiveDefense"] = {
        2,
        21,
        24,
        -- 37,
        -- 38,
        39,
        40,
        41,
        42,
        -- 43,
        44,
        45,
    },

    ["SkillCategoryActiveDefense"] = {
        2,
        21,
        24,
        -- 37,
        -- 38,
        39,
        40,
        41,
        42,
        -- 43,
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
        -- 46,
        -- 47,
        -- 48,
        -- 49,
        -- 50,
        51,
        -- 52,
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
        64,
        61,
    },

    ["SkillCategoryActiveHP"] = {
        4,
        62,
    },

    ["SkillCategoryPassivePromotion"] = {
        27,
    },

    ["SkillCategoryActivePromotion"] = {
        26,
    },

    ["SkillCategoryActiveLogistics"] = {
        63,
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

SkillData.skills = {
    -- Modify the attack power for all units of a player.
    [1] = {
        minLevelPassive     = -6,
        maxLevelPassive     = 20,
        minLevelActive      = -6,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels = {
            [-6] = {modifierPassive = -22.5, pointsPassive = -150, modifierActive = -30, pointsActive = -150, minEnergy = 12},
            [-5] = {modifierPassive = -18.75, pointsPassive = -125, modifierActive = -25, pointsActive = -125, minEnergy = 10},
            [-4] = {modifierPassive = -15, pointsPassive = -100, modifierActive = -20, pointsActive = -100, minEnergy = 8},
            [-3] = {modifierPassive = -11.25, pointsPassive = -75, modifierActive = -15, pointsActive = -75, minEnergy = 6},
            [-2] = {modifierPassive = -7.5, pointsPassive = -50, modifierActive = -10, pointsActive = -50, minEnergy = 4},
            [-1] = {modifierPassive = -3.75, pointsPassive = -25, modifierActive = -5, pointsActive = -25, minEnergy = 2},
            [0] = {modifierPassive = 0, pointsPassive = 0, modifierActive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 2.5, pointsPassive = 25, modifierActive = 5, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 5, pointsPassive = 50, modifierActive = 10, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 7.5, pointsPassive = 75, modifierActive = 15, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 10, pointsPassive = 100, modifierActive = 20, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 12.5, pointsPassive = 125, modifierActive = 25, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 15, pointsPassive = 150, modifierActive = 30, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 17.5, pointsPassive = 175, modifierActive = 35, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 20, pointsPassive = 200, modifierActive = 40, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 22.5, pointsPassive = 225, modifierActive = 45, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 25, pointsPassive = 250, modifierActive = 50, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 27.5, pointsPassive = 275, modifierActive = 55, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 30, pointsPassive = 300, modifierActive = 60, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 32.5, pointsPassive = 325, modifierActive = 65, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 35, pointsPassive = 350, modifierActive = 70, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 37.5, pointsPassive = 375, modifierActive = 75, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 40, pointsPassive = 400, modifierActive = 80, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 42.5, pointsPassive = 425, modifierActive = 85, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 45, pointsPassive = 450, modifierActive = 90, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 47.5, pointsPassive = 475, modifierActive = 95, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 50, pointsPassive = 500, modifierActive = 100, pointsActive = 1000, minEnergy = 10},
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
            [-6] = {modifierPassive = -23.4, pointsPassive = -150, modifierActive = -31.2, pointsActive = -150, minEnergy = 12},
            [-5] = {modifierPassive = -19.5, pointsPassive = -125, modifierActive = -26, pointsActive = -125, minEnergy = 10},
            [-4] = {modifierPassive = -15.6, pointsPassive = -100, modifierActive = -20.8, pointsActive = -100, minEnergy = 8},
            [-3] = {modifierPassive = -11.7, pointsPassive = -75, modifierActive = -15.6, pointsActive = -75, minEnergy = 6},
            [-2] = {modifierPassive = -7.8, pointsPassive = -50, modifierActive = -10.4, pointsActive = -50, minEnergy = 4},
            [-1] = {modifierPassive = -3.9, pointsPassive = -25, modifierActive = -5.2, pointsActive = -25, minEnergy = 2},
            [0] = {modifierPassive = 0, pointsPassive = 0, modifierActive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 2.6, pointsPassive = 25, modifierActive = 5.2, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 5.2, pointsPassive = 50, modifierActive = 10.4, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 7.8, pointsPassive = 75, modifierActive = 15.6, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 10.4, pointsPassive = 100, modifierActive = 20.8, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 13, pointsPassive = 125, modifierActive = 26, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 15.6, pointsPassive = 150, modifierActive = 31.2, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 18.2, pointsPassive = 175, modifierActive = 36.4, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 20.8, pointsPassive = 200, modifierActive = 41.6, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 23.4, pointsPassive = 225, modifierActive = 46.8, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 26, pointsPassive = 250, modifierActive = 52, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 28.6, pointsPassive = 275, modifierActive = 57.2, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 31.2, pointsPassive = 300, modifierActive = 62.4, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 33.8, pointsPassive = 325, modifierActive = 67.6, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 36.4, pointsPassive = 350, modifierActive = 72.8, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 39, pointsPassive = 375, modifierActive = 78, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 41.6, pointsPassive = 400, modifierActive = 83.2, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 44.2, pointsPassive = 425, modifierActive = 88.4, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 46.8, pointsPassive = 450, modifierActive = 93.6, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 49.4, pointsPassive = 475, modifierActive = 98.8, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 52, pointsPassive = 500, modifierActive = 104, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Modify the production cost for all units of a player.
    [3] = {
        minLevelPassive     = -4,
        maxLevelPassive     = 20,
        minLevelActive      = 1,
        maxLevelActive      = 20,
        modifierUnit = "%",
        levels = {
            [-4] = {modifierPassive = 20, pointsPassive = -200, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = 17, pointsPassive = -175, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = 14, pointsPassive = -150, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = 11, pointsPassive = -125, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, pointsPassive = 0, modifierActive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = -2.1, pointsPassive = 25, modifierActive = -6, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = -4.2, pointsPassive = 50, modifierActive = -12, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = -6.3, pointsPassive = 75, modifierActive = -18, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = -8.4, pointsPassive = 100, modifierActive = -24, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = -10.5, pointsPassive = 125, modifierActive = -30, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = -12.6, pointsPassive = 150, modifierActive = -36, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = -14.7, pointsPassive = 175, modifierActive = -42, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = -16.8, pointsPassive = 200, modifierActive = -48, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = -18.9, pointsPassive = 225, modifierActive = -54, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = -21, pointsPassive = 250, modifierActive = -60, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = -23.1, pointsPassive = 275, modifierActive = -66, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = -25.2, pointsPassive = 300, modifierActive = -72, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = -27.3, pointsPassive = 325, modifierActive = -78, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = -29.4, pointsPassive = 350, modifierActive = -84, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = -31.5, pointsPassive = 375, modifierActive = -90, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = -33.6, pointsPassive = 400, modifierActive = -96, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = -35.7, pointsPassive = 425, modifierActive = -102, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = -37.8, pointsPassive = 450, modifierActive = -108, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = -39.9, pointsPassive = 475, modifierActive = -114, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = -42, pointsPassive = 500, modifierActive = -120, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Instant: Modify HPs of all units of the currently-in-turn player.
    [4] = {
        minLevelActive      = 1,
        maxLevelActive      = 9,
        modifierUnit = "HP",
        levels = {
            [1] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 1, pointsActive = 125, minEnergy = 2},
            [2] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 2, pointsActive = 250, minEnergy = 3},
            [3] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 3, pointsActive = 350, minEnergy = 4},
            [4] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 4, pointsActive = 450, minEnergy = 5},
            [5] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 5, pointsActive = 525, minEnergy = 6},
            [6] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 6, pointsActive = 600, minEnergy = 7},
            [7] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 7, pointsActive = 650, minEnergy = 8},
            [8] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 8, pointsActive = 700, minEnergy = 9},
            [9] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 9, pointsActive = 725, minEnergy = 10},
        },
    },

    -- Instant (deprecated): Modify HPs of all units of the opponents and teammates.
    [5] = {
        minLevelActive     = 1,
        maxLevelActive     = 9,
        modifierUnit = "HP",
        levels = {
            [1] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -1, pointsActive = 300, minEnergy = 3},
            [2] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -2, pointsActive = 575, minEnergy = 6},
            [3] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -3, pointsActive = 825, minEnergy = 9},
            [4] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -4, pointsActive = 1050, minEnergy = 12},
            [5] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -5, pointsActive = 1250, minEnergy = 15},
            [6] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -6, pointsActive = 1425, minEnergy = 18},
            [7] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -7, pointsActive = 1575, minEnergy = 21},
            [8] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -8, pointsActive = 1700, minEnergy = 24},
            [9] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -9, pointsActive = 1800, minEnergy = 27},
        },
    },

    -- Modify movements of all units of the owner player.
    [6] = {
        minLevelActive     = 1,
        maxLevelActive     = 5,
        modifierUnit = "",
        levels = {
            [1] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 1, pointsActive = 200, minEnergy = 2},
            [2] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 2, pointsActive = 350, minEnergy = 4},
            [3] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 3, pointsActive = 475, minEnergy = 6},
            [4] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 4, pointsActive = 600, minEnergy = 8},
            [5] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 5, pointsActive = 725, minEnergy = 10},
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
            [-1] = {modifierPassive = -1, pointsPassive = -25, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, pointsPassive = 0, modifierActive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 1, pointsPassive = 200, modifierActive = 1, pointsActive = 200, minEnergy = 2},
            [2] = {modifierPassive = 2, pointsPassive = 400, modifierActive = 2, pointsActive = 400, minEnergy = 4},
            [3] = {modifierPassive = 3, pointsPassive = 600, modifierActive = 3, pointsActive = 600, minEnergy = 6},
        },
    },

    -- Instant: Set all units, except inf units (Infantry, Mech, Bike), as idle (i.e. move again).
    [8] = {
        minLevelActive     = 1,
        maxLevelActive     = 1,
        modifierUnit = "",
        levels       = {
            [1] = {modifierPassive = nil, pointsPassive = nil, modifierActive = nil, pointsActive = 825, minEnergy = 9},
        },
    },

    -- Instant (deprecated): Modify the fuel of the opponents and teammates' units.
    [9] = {
        minLevelActive     = 1,
        maxLevelActive     = 12,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -33.3333333333333, pointsActive = 25, minEnergy = 1},
            [2] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -66.6666666666667, pointsActive = 50, minEnergy = 2},
            [3] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -100, pointsActive = 75, minEnergy = 3},
            [4] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -133.333333333333, pointsActive = 100, minEnergy = 4},
            [5] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -166.666666666667, pointsActive = 125, minEnergy = 5},
            [6] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -200, pointsActive = 150, minEnergy = 6},
            [7] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -233.333333333333, pointsActive = 175, minEnergy = 7},
            [8] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -266.666666666667, pointsActive = 200, minEnergy = 8},
            [9] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -300, pointsActive = 225, minEnergy = 9},
            [10] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -333.333333333333, pointsActive = 250, minEnergy = 10},
            [11] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -366.666666666667, pointsActive = 275, minEnergy = 11},
            [12] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -400, pointsActive = 300, minEnergy = 12},
        },
    },

    -- Modify the repair amount of buildings of the owner player.
    [10] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 3,
        modifierUnit = "HP",
        levels       = {
            [1] = {modifierPassive = 1, pointsPassive = 25, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [2] = {modifierPassive = 3, pointsPassive = 50, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [3] = {modifierPassive = 7, pointsPassive = 75, modifierActive = nil, pointsActive = nil, minEnergy = nil},
        },
    },

    -- Modify the repair cost of the owner player.
    [11] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 5,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = -20, pointsPassive = 25, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [2] = {modifierPassive = -40, pointsPassive = 50, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [3] = {modifierPassive = -60, pointsPassive = 75, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [4] = {modifierPassive = -80, pointsPassive = 100, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [5] = {modifierPassive = -100, pointsPassive = 125, modifierActive = nil, pointsActive = nil, minEnergy = nil},
        },
    },

    -- Instant: Modify the fund of the owner player.
    [12] = {
        minLevelActive     = 1,
        maxLevelActive     = 20,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 5, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 10, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 15, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 20, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 25, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 30, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 35, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 40, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 45, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 50, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 55, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 60, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 65, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 70, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 75, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 80, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 85, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 90, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 95, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 100, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Instant (deprecated): Modify the energy of the opponents and teammates.
    [13] = {
        minLevelActive     = 1,
        maxLevelActive     = 10,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -2, pointsActive = 25, minEnergy = 1},
            [2] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -4, pointsActive = 50, minEnergy = 1},
            [3] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -6, pointsActive = 75, minEnergy = 2},
            [4] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -8, pointsActive = 100, minEnergy = 2},
            [5] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -10, pointsActive = 125, minEnergy = 3},
            [6] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -12, pointsActive = 150, minEnergy = 3},
            [7] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -14, pointsActive = 175, minEnergy = 4},
            [8] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -16, pointsActive = 200, minEnergy = 4},
            [9] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -18, pointsActive = 225, minEnergy = 5},
            [10] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -20, pointsActive = 250, minEnergy = 5},
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
            [1] = {modifierPassive = 5, pointsPassive = 50, modifierActive = 5, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 10, pointsPassive = 100, modifierActive = 10, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 15, pointsPassive = 150, modifierActive = 15, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 20, pointsPassive = 200, modifierActive = 20, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 25, pointsPassive = 250, modifierActive = 25, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 30, pointsPassive = 300, modifierActive = 30, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 35, pointsPassive = 350, modifierActive = 35, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 40, pointsPassive = 400, modifierActive = 40, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 45, pointsPassive = 450, modifierActive = 45, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 50, pointsPassive = 500, modifierActive = 50, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 55, pointsPassive = 550, modifierActive = 55, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 60, pointsPassive = 600, modifierActive = 60, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 65, pointsPassive = 650, modifierActive = 65, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 70, pointsPassive = 700, modifierActive = 70, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 75, pointsPassive = 750, modifierActive = 75, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 80, pointsPassive = 800, modifierActive = 80, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 85, pointsPassive = 850, modifierActive = 85, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 90, pointsPassive = 900, modifierActive = 90, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 95, pointsPassive = 950, modifierActive = 95, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 100, pointsPassive = 1000, modifierActive = 100, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Modify the capture speed of the owner player.
    [15] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 6,
        minLevelActive      = 1,
        maxLevelActive      = 2,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = 20, pointsPassive = 25, modifierActive = 100, pointsActive = 400, minEnergy = 5},
            [2] = {modifierPassive = 40, pointsPassive = 50, modifierActive = 2000, pointsActive = 500, minEnergy = 6},
            [3] = {modifierPassive = 60, pointsPassive = 75, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [4] = {modifierPassive = 80, pointsPassive = 100, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [5] = {modifierPassive = 100, pointsPassive = 275, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [6] = {modifierPassive = 2000, pointsPassive = 400, modifierActive = nil, pointsActive = nil, minEnergy = nil},
        },
    },

    -- Instant: Fills the ammo, fuel, material of all units of the owner player.
    [16] = {
        minLevelActive     = 1,
        maxLevelActive     = 1,
        modifierUnit = "",
        levels       = {
            [1] = {modifierPassive = nil, pointsPassive = nil, modifierActive = nil, pointsActive = 75, minEnergy = 1},
        }
    },

    -- Modify the income of the owner player.
    [17] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 20,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = 2, pointsPassive = 25, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [2] = {modifierPassive = 4, pointsPassive = 50, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [3] = {modifierPassive = 6, pointsPassive = 75, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [4] = {modifierPassive = 8, pointsPassive = 100, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [5] = {modifierPassive = 10, pointsPassive = 125, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [6] = {modifierPassive = 12, pointsPassive = 150, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [7] = {modifierPassive = 14, pointsPassive = 175, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [8] = {modifierPassive = 16, pointsPassive = 200, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [9] = {modifierPassive = 18, pointsPassive = 225, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [10] = {modifierPassive = 20, pointsPassive = 250, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [11] = {modifierPassive = 22, pointsPassive = 275, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [12] = {modifierPassive = 24, pointsPassive = 300, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [13] = {modifierPassive = 26, pointsPassive = 325, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [14] = {modifierPassive = 28, pointsPassive = 350, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [15] = {modifierPassive = 30, pointsPassive = 375, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [16] = {modifierPassive = 32, pointsPassive = 400, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [17] = {modifierPassive = 34, pointsPassive = 425, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [18] = {modifierPassive = 36, pointsPassive = 450, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [19] = {modifierPassive = 38, pointsPassive = 475, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [20] = {modifierPassive = 40, pointsPassive = 500, modifierActive = nil, pointsActive = nil, minEnergy = nil},
        },
    },

    -- Stop the damage cost per the energy requirement from increasing as skills are activated.
    [18] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 1,
        modifierUnit = "",
        levels       = {
            [1] = {modifierPassive = nil, pointsPassive = 75, modifierActive = nil, pointsActive = nil, minEnergy = nil},
        },
    },

    -- Modify the growth rate of the energy of the owner player.
    [19] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 20,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = 6, pointsPassive = 25, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [2] = {modifierPassive = 12, pointsPassive = 50, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [3] = {modifierPassive = 18, pointsPassive = 75, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [4] = {modifierPassive = 24, pointsPassive = 100, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [5] = {modifierPassive = 30, pointsPassive = 125, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [6] = {modifierPassive = 36, pointsPassive = 150, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [7] = {modifierPassive = 42, pointsPassive = 175, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [8] = {modifierPassive = 48, pointsPassive = 200, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [9] = {modifierPassive = 54, pointsPassive = 225, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [10] = {modifierPassive = 60, pointsPassive = 250, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [11] = {modifierPassive = 66, pointsPassive = 275, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [12] = {modifierPassive = 72, pointsPassive = 300, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [13] = {modifierPassive = 78, pointsPassive = 325, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [14] = {modifierPassive = 84, pointsPassive = 350, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [15] = {modifierPassive = 90, pointsPassive = 375, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [16] = {modifierPassive = 96, pointsPassive = 400, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [17] = {modifierPassive = 102, pointsPassive = 425, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [18] = {modifierPassive = 108, pointsPassive = 450, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [19] = {modifierPassive = 114, pointsPassive = 475, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [20] = {modifierPassive = 120, pointsPassive = 500, modifierActive = nil, pointsActive = nil, minEnergy = nil},
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
            [1] = {modifierPassive = 0.75, pointsPassive = 25, modifierActive = 2, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 1.5, pointsPassive = 50, modifierActive = 4, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 2.25, pointsPassive = 75, modifierActive = 6, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 3, pointsPassive = 100, modifierActive = 8, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 3.75, pointsPassive = 125, modifierActive = 10, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 4.5, pointsPassive = 150, modifierActive = 12, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 5.25, pointsPassive = 175, modifierActive = 14, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 6, pointsPassive = 200, modifierActive = 16, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 6.75, pointsPassive = 225, modifierActive = 18, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 7.5, pointsPassive = 250, modifierActive = 20, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 8.25, pointsPassive = 275, modifierActive = 22, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 9, pointsPassive = 300, modifierActive = 24, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 9.75, pointsPassive = 325, modifierActive = 26, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 10.5, pointsPassive = 350, modifierActive = 28, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 11.25, pointsPassive = 375, modifierActive = 30, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 12, pointsPassive = 400, modifierActive = 32, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 12.75, pointsPassive = 425, modifierActive = 34, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 13.5, pointsPassive = 450, modifierActive = 36, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 14.25, pointsPassive = 475, modifierActive = 38, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 15, pointsPassive = 500, modifierActive = 40, pointsActive = 1000, minEnergy = 10},
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
            [1] = {modifierPassive = 0.75, pointsPassive = 25, modifierActive = 2.5, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 1.5, pointsPassive = 50, modifierActive = 5, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 2.25, pointsPassive = 75, modifierActive = 7.5, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 3, pointsPassive = 100, modifierActive = 10, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 3.75, pointsPassive = 125, modifierActive = 12.5, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 4.5, pointsPassive = 150, modifierActive = 15, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 5.25, pointsPassive = 175, modifierActive = 17.5, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 6, pointsPassive = 200, modifierActive = 20, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 6.75, pointsPassive = 225, modifierActive = 22.5, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 7.5, pointsPassive = 250, modifierActive = 25, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 8.25, pointsPassive = 275, modifierActive = 27.5, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 9, pointsPassive = 300, modifierActive = 30, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 9.75, pointsPassive = 325, modifierActive = 32.5, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 10.5, pointsPassive = 350, modifierActive = 35, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 11.25, pointsPassive = 375, modifierActive = 37.5, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 12, pointsPassive = 400, modifierActive = 40, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 12.75, pointsPassive = 425, modifierActive = 42.5, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 13.5, pointsPassive = 450, modifierActive = 45, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 14.25, pointsPassive = 475, modifierActive = 47.5, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 15, pointsPassive = 500, modifierActive = 50, pointsActive = 1000, minEnergy = 10},
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
            [1] = {modifierPassive = 5, pointsPassive = 25, modifierActive = 5, pointsActive = 25, minEnergy = 1},
            [2] = {modifierPassive = 10, pointsPassive = 50, modifierActive = 10, pointsActive = 50, minEnergy = 1},
            [3] = {modifierPassive = 15, pointsPassive = 75, modifierActive = 15, pointsActive = 75, minEnergy = 2},
            [4] = {modifierPassive = 20, pointsPassive = 100, modifierActive = 20, pointsActive = 100, minEnergy = 2},
            [5] = {modifierPassive = 25, pointsPassive = 125, modifierActive = 25, pointsActive = 125, minEnergy = 3},
            [6] = {modifierPassive = 30, pointsPassive = 150, modifierActive = 30, pointsActive = 150, minEnergy = 3},
            [7] = {modifierPassive = 35, pointsPassive = 175, modifierActive = 35, pointsActive = 175, minEnergy = 4},
            [8] = {modifierPassive = 40, pointsPassive = 200, modifierActive = 40, pointsActive = 200, minEnergy = 4},
            [9] = {modifierPassive = 45, pointsPassive = 225, modifierActive = 45, pointsActive = 225, minEnergy = 5},
            [10] = {modifierPassive = 50, pointsPassive = 250, modifierActive = 50, pointsActive = 250, minEnergy = 5},
            [11] = {modifierPassive = 55, pointsPassive = 275, modifierActive = 55, pointsActive = 275, minEnergy = 6},
            [12] = {modifierPassive = 60, pointsPassive = 300, modifierActive = 60, pointsActive = 300, minEnergy = 6},
            [13] = {modifierPassive = 65, pointsPassive = 325, modifierActive = 65, pointsActive = 325, minEnergy = 7},
            [14] = {modifierPassive = 70, pointsPassive = 350, modifierActive = 70, pointsActive = 350, minEnergy = 7},
            [15] = {modifierPassive = 75, pointsPassive = 375, modifierActive = 75, pointsActive = 375, minEnergy = 8},
            [16] = {modifierPassive = 80, pointsPassive = 400, modifierActive = 80, pointsActive = 400, minEnergy = 8},
            [17] = {modifierPassive = 85, pointsPassive = 425, modifierActive = 85, pointsActive = 425, minEnergy = 9},
            [18] = {modifierPassive = 90, pointsPassive = 450, modifierActive = 90, pointsActive = 450, minEnergy = 9},
            [19] = {modifierPassive = 95, pointsPassive = 475, modifierActive = 95, pointsActive = 475, minEnergy = 10},
            [20] = {modifierPassive = 100, pointsPassive = 500, modifierActive = 100, pointsActive = 500, minEnergy = 10},
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
            [1] = {modifierPassive = 2, pointsPassive = 25, modifierActive = 4, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 4, pointsPassive = 50, modifierActive = 8, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 6, pointsPassive = 75, modifierActive = 12, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 8, pointsPassive = 100, modifierActive = 16, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 10, pointsPassive = 125, modifierActive = 20, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 12, pointsPassive = 150, modifierActive = 24, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 14, pointsPassive = 175, modifierActive = 28, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 16, pointsPassive = 200, modifierActive = 32, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 18, pointsPassive = 225, modifierActive = 36, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 20, pointsPassive = 250, modifierActive = 40, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 22, pointsPassive = 275, modifierActive = 44, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 24, pointsPassive = 300, modifierActive = 48, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 26, pointsPassive = 325, modifierActive = 52, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 28, pointsPassive = 350, modifierActive = 56, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 30, pointsPassive = 375, modifierActive = 60, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 32, pointsPassive = 400, modifierActive = 64, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 34, pointsPassive = 425, modifierActive = 68, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 36, pointsPassive = 450, modifierActive = 72, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 38, pointsPassive = 475, modifierActive = 76, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 40, pointsPassive = 500, modifierActive = 80, pointsActive = 1000, minEnergy = 10},
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
            [1] = {modifierPassive = 2.2, pointsPassive = 25, modifierActive = 5, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 4.4, pointsPassive = 50, modifierActive = 10, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 6.6, pointsPassive = 75, modifierActive = 15, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 8.8, pointsPassive = 100, modifierActive = 20, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 11, pointsPassive = 125, modifierActive = 25, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 13.2, pointsPassive = 150, modifierActive = 30, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 15.4, pointsPassive = 175, modifierActive = 35, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 17.6, pointsPassive = 200, modifierActive = 40, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 19.8, pointsPassive = 225, modifierActive = 45, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 22, pointsPassive = 250, modifierActive = 50, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 24.2, pointsPassive = 275, modifierActive = 55, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 26.4, pointsPassive = 300, modifierActive = 60, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 28.6, pointsPassive = 325, modifierActive = 65, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 30.8, pointsPassive = 350, modifierActive = 70, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 33, pointsPassive = 375, modifierActive = 75, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 35.2, pointsPassive = 400, modifierActive = 80, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 37.4, pointsPassive = 425, modifierActive = 85, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 39.6, pointsPassive = 450, modifierActive = 90, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 41.8, pointsPassive = 475, modifierActive = 95, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 44, pointsPassive = 500, modifierActive = 100, pointsActive = 1000, minEnergy = 10},
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
            [1] = {modifierPassive = 5, pointsPassive = 50, modifierActive = 5, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 10, pointsPassive = 100, modifierActive = 10, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 15, pointsPassive = 150, modifierActive = 15, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 20, pointsPassive = 200, modifierActive = 20, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 25, pointsPassive = 250, modifierActive = 25, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 30, pointsPassive = 300, modifierActive = 30, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 35, pointsPassive = 350, modifierActive = 35, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 40, pointsPassive = 400, modifierActive = 40, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 45, pointsPassive = 450, modifierActive = 45, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 50, pointsPassive = 500, modifierActive = 50, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 55, pointsPassive = 550, modifierActive = 55, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 60, pointsPassive = 600, modifierActive = 60, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 65, pointsPassive = 650, modifierActive = 65, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 70, pointsPassive = 700, modifierActive = 70, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 75, pointsPassive = 750, modifierActive = 75, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 80, pointsPassive = 800, modifierActive = 80, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 85, pointsPassive = 850, modifierActive = 85, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 90, pointsPassive = 900, modifierActive = 90, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 95, pointsPassive = 950, modifierActive = 95, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 100, pointsPassive = 1000, modifierActive = 100, pointsActive = 1000, minEnergy = 10},
        },
    },

    -- Modify the promotion of the units of the owner player.
    [26] = {
        minLevelActive     = 1,
        maxLevelActive     = 3,
        modifierUnit = "",
        levels       = {
            [1] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 1, pointsActive = 200, minEnergy = 2},
            [2] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 2, pointsActive = 400, minEnergy = 4},
            [3] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 3, pointsActive = 600, minEnergy = 6},
        },
    },

    -- Modify the promotion of the newly produced units of the owner player.
    [27] = {
        minLevelPassive     = 1,
        maxLevelPassive     = 3,
        modifierUnit = "",
        levels       = {
            [1] = {modifierPassive = 1, pointsPassive = 75, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [2] = {modifierPassive = 2, pointsPassive = 200, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [3] = {modifierPassive = 3, pointsPassive = 300, modifierActive = nil, pointsActive = nil, minEnergy = nil},
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
            [1] = {modifierPassive = nil, pointsPassive = 125, modifierActive = nil, pointsActive = 100, minEnergy = 1},
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
            [-6] = {modifierPassive = -30, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, pointsPassive = 0, modifierActive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 2.1, pointsPassive = 25, modifierActive = 4.2, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 4.2, pointsPassive = 50, modifierActive = 8.4, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 6.3, pointsPassive = 75, modifierActive = 12.6, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 8.4, pointsPassive = 100, modifierActive = 16.8, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 10.5, pointsPassive = 125, modifierActive = 21, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 12.6, pointsPassive = 150, modifierActive = 25.2, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 14.7, pointsPassive = 175, modifierActive = 29.4, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 16.8, pointsPassive = 200, modifierActive = 33.6, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 18.9, pointsPassive = 225, modifierActive = 37.8, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 21, pointsPassive = 250, modifierActive = 42, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 23.1, pointsPassive = 275, modifierActive = 46.2, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 25.2, pointsPassive = 300, modifierActive = 50.4, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 27.3, pointsPassive = 325, modifierActive = 54.6, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 29.4, pointsPassive = 350, modifierActive = 58.8, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 31.5, pointsPassive = 375, modifierActive = 63, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 33.6, pointsPassive = 400, modifierActive = 67.2, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 35.7, pointsPassive = 425, modifierActive = 71.4, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 37.8, pointsPassive = 450, modifierActive = 75.6, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 39.9, pointsPassive = 475, modifierActive = 79.8, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 42, pointsPassive = 500, modifierActive = 84, pointsActive = 1000, minEnergy = 10},
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
            [-6] = {modifierPassive = -30, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, pointsPassive = 0, modifierActive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 6, pointsPassive = 25, modifierActive = 12, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 12, pointsPassive = 50, modifierActive = 24, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 18, pointsPassive = 75, modifierActive = 36, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 24, pointsPassive = 100, modifierActive = 48, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 30, pointsPassive = 125, modifierActive = 60, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 36, pointsPassive = 150, modifierActive = 72, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 42, pointsPassive = 175, modifierActive = 84, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 48, pointsPassive = 200, modifierActive = 96, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 54, pointsPassive = 225, modifierActive = 108, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 60, pointsPassive = 250, modifierActive = 120, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 66, pointsPassive = 275, modifierActive = 132, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 72, pointsPassive = 300, modifierActive = 144, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 78, pointsPassive = 325, modifierActive = 156, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 84, pointsPassive = 350, modifierActive = 168, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 90, pointsPassive = 375, modifierActive = 180, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 96, pointsPassive = 400, modifierActive = 192, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 102, pointsPassive = 425, modifierActive = 204, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 108, pointsPassive = 450, modifierActive = 216, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 114, pointsPassive = 475, modifierActive = 228, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 120, pointsPassive = 500, modifierActive = 240, pointsActive = 1000, minEnergy = 10},
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
            [-6] = {modifierPassive = -30, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, pointsPassive = 0, modifierActive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 3, pointsPassive = 25, modifierActive = 6, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 6, pointsPassive = 50, modifierActive = 12, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 9, pointsPassive = 75, modifierActive = 18, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 12, pointsPassive = 100, modifierActive = 24, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 15, pointsPassive = 125, modifierActive = 30, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 18, pointsPassive = 150, modifierActive = 36, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 21, pointsPassive = 175, modifierActive = 42, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 24, pointsPassive = 200, modifierActive = 48, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 27, pointsPassive = 225, modifierActive = 54, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 30, pointsPassive = 250, modifierActive = 60, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 33, pointsPassive = 275, modifierActive = 66, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 36, pointsPassive = 300, modifierActive = 72, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 39, pointsPassive = 325, modifierActive = 78, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 42, pointsPassive = 350, modifierActive = 84, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 45, pointsPassive = 375, modifierActive = 90, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 48, pointsPassive = 400, modifierActive = 96, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 51, pointsPassive = 425, modifierActive = 102, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 54, pointsPassive = 450, modifierActive = 108, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 57, pointsPassive = 475, modifierActive = 114, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 60, pointsPassive = 500, modifierActive = 120, pointsActive = 1000, minEnergy = 10},
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
            [-6] = {modifierPassive = -30, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, pointsPassive = 0, modifierActive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 10, pointsPassive = 25, modifierActive = 20, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 20, pointsPassive = 50, modifierActive = 40, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 30, pointsPassive = 75, modifierActive = 60, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 40, pointsPassive = 100, modifierActive = 80, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 50, pointsPassive = 125, modifierActive = 100, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 60, pointsPassive = 150, modifierActive = 120, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 70, pointsPassive = 175, modifierActive = 140, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 80, pointsPassive = 200, modifierActive = 160, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 90, pointsPassive = 225, modifierActive = 180, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 100, pointsPassive = 250, modifierActive = 200, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 110, pointsPassive = 275, modifierActive = 220, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 120, pointsPassive = 300, modifierActive = 240, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 130, pointsPassive = 325, modifierActive = 260, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 140, pointsPassive = 350, modifierActive = 280, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 150, pointsPassive = 375, modifierActive = 300, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 160, pointsPassive = 400, modifierActive = 320, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 170, pointsPassive = 425, modifierActive = 340, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 180, pointsPassive = 450, modifierActive = 360, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 190, pointsPassive = 475, modifierActive = 380, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 200, pointsPassive = 500, modifierActive = 400, pointsActive = 1000, minEnergy = 10},
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
            [-6] = {modifierPassive = -30, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, pointsPassive = 0, modifierActive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 10, pointsPassive = 25, modifierActive = 20, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 20, pointsPassive = 50, modifierActive = 40, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 30, pointsPassive = 75, modifierActive = 60, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 40, pointsPassive = 100, modifierActive = 80, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 50, pointsPassive = 125, modifierActive = 100, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 60, pointsPassive = 150, modifierActive = 120, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 70, pointsPassive = 175, modifierActive = 140, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 80, pointsPassive = 200, modifierActive = 160, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 90, pointsPassive = 225, modifierActive = 180, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 100, pointsPassive = 250, modifierActive = 200, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 110, pointsPassive = 275, modifierActive = 220, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 120, pointsPassive = 300, modifierActive = 240, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 130, pointsPassive = 325, modifierActive = 260, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 140, pointsPassive = 350, modifierActive = 280, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 150, pointsPassive = 375, modifierActive = 300, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 160, pointsPassive = 400, modifierActive = 320, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 170, pointsPassive = 425, modifierActive = 340, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 180, pointsPassive = 450, modifierActive = 360, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 190, pointsPassive = 475, modifierActive = 380, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 200, pointsPassive = 500, modifierActive = 400, pointsActive = 1000, minEnergy = 10},
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
            [-6] = {modifierPassive = -30, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, pointsPassive = 0, modifierActive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 5.5, pointsPassive = 25, modifierActive = 11, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 11, pointsPassive = 50, modifierActive = 22, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 16.5, pointsPassive = 75, modifierActive = 33, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 22, pointsPassive = 100, modifierActive = 44, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 27.5, pointsPassive = 125, modifierActive = 55, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 33, pointsPassive = 150, modifierActive = 66, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 38.5, pointsPassive = 175, modifierActive = 77, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 44, pointsPassive = 200, modifierActive = 88, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 49.5, pointsPassive = 225, modifierActive = 99, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 55, pointsPassive = 250, modifierActive = 110, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 60.5, pointsPassive = 275, modifierActive = 121, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 66, pointsPassive = 300, modifierActive = 132, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 71.5, pointsPassive = 325, modifierActive = 143, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 77, pointsPassive = 350, modifierActive = 154, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 82.5, pointsPassive = 375, modifierActive = 165, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 88, pointsPassive = 400, modifierActive = 176, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 93.5, pointsPassive = 425, modifierActive = 187, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 99, pointsPassive = 450, modifierActive = 198, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 104.5, pointsPassive = 475, modifierActive = 209, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 110, pointsPassive = 500, modifierActive = 220, pointsActive = 1000, minEnergy = 10},
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
            [-6] = {modifierPassive = -30, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, pointsPassive = 0, modifierActive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 2.3, pointsPassive = 25, modifierActive = 4.6, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 4.6, pointsPassive = 50, modifierActive = 9.2, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 6.9, pointsPassive = 75, modifierActive = 13.8, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 9.2, pointsPassive = 100, modifierActive = 18.4, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 11.5, pointsPassive = 125, modifierActive = 23, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 13.8, pointsPassive = 150, modifierActive = 27.6, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 16.1, pointsPassive = 175, modifierActive = 32.2, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 18.4, pointsPassive = 200, modifierActive = 36.8, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 20.7, pointsPassive = 225, modifierActive = 41.4, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 23, pointsPassive = 250, modifierActive = 46, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 25.3, pointsPassive = 275, modifierActive = 50.6, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 27.6, pointsPassive = 300, modifierActive = 55.2, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 29.9, pointsPassive = 325, modifierActive = 59.8, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 32.2, pointsPassive = 350, modifierActive = 64.4, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 34.5, pointsPassive = 375, modifierActive = 69, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 36.8, pointsPassive = 400, modifierActive = 73.6, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 39.1, pointsPassive = 425, modifierActive = 78.2, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 41.4, pointsPassive = 450, modifierActive = 82.8, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 43.7, pointsPassive = 475, modifierActive = 87.4, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 46, pointsPassive = 500, modifierActive = 92, pointsActive = 1000, minEnergy = 10},
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
            [-6] = {modifierPassive = -30, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, pointsPassive = 0, modifierActive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 3.5, pointsPassive = 25, modifierActive = 7, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 7, pointsPassive = 50, modifierActive = 14, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 10.5, pointsPassive = 75, modifierActive = 21, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 14, pointsPassive = 100, modifierActive = 28, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 17.5, pointsPassive = 125, modifierActive = 35, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 21, pointsPassive = 150, modifierActive = 42, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 24.5, pointsPassive = 175, modifierActive = 49, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 28, pointsPassive = 200, modifierActive = 56, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 31.5, pointsPassive = 225, modifierActive = 63, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 35, pointsPassive = 250, modifierActive = 70, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 38.5, pointsPassive = 275, modifierActive = 77, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 42, pointsPassive = 300, modifierActive = 84, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 45.5, pointsPassive = 325, modifierActive = 91, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 49, pointsPassive = 350, modifierActive = 98, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 52.5, pointsPassive = 375, modifierActive = 105, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 56, pointsPassive = 400, modifierActive = 112, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 59.5, pointsPassive = 425, modifierActive = 119, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 63, pointsPassive = 450, modifierActive = 126, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 66.5, pointsPassive = 475, modifierActive = 133, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 70, pointsPassive = 500, modifierActive = 140, pointsActive = 1000, minEnergy = 10},
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
            [-6] = {modifierPassive = -30, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, pointsPassive = 0, modifierActive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 2.15, pointsPassive = 25, modifierActive = 4.4, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 4.3, pointsPassive = 50, modifierActive = 8.8, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 6.45, pointsPassive = 75, modifierActive = 13.2, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 8.6, pointsPassive = 100, modifierActive = 17.6, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 10.75, pointsPassive = 125, modifierActive = 22, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 12.9, pointsPassive = 150, modifierActive = 26.4, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 15.05, pointsPassive = 175, modifierActive = 30.8, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 17.2, pointsPassive = 200, modifierActive = 35.2, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 19.35, pointsPassive = 225, modifierActive = 39.6, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 21.5, pointsPassive = 250, modifierActive = 44, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 23.65, pointsPassive = 275, modifierActive = 48.4, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 25.8, pointsPassive = 300, modifierActive = 52.8, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 27.95, pointsPassive = 325, modifierActive = 57.2, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 30.1, pointsPassive = 350, modifierActive = 61.6, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 32.25, pointsPassive = 375, modifierActive = 66, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 34.4, pointsPassive = 400, modifierActive = 70.4, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 36.55, pointsPassive = 425, modifierActive = 74.8, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 38.7, pointsPassive = 450, modifierActive = 79.2, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 40.85, pointsPassive = 475, modifierActive = 83.6, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 43, pointsPassive = 500, modifierActive = 88, pointsActive = 1000, minEnergy = 10},
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
            [-6] = {modifierPassive = -30, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, pointsPassive = 0, modifierActive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 2.5, pointsPassive = 25, modifierActive = 6, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 5, pointsPassive = 50, modifierActive = 12, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 7.5, pointsPassive = 75, modifierActive = 18, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 10, pointsPassive = 100, modifierActive = 24, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 12.5, pointsPassive = 125, modifierActive = 30, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 15, pointsPassive = 150, modifierActive = 36, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 17.5, pointsPassive = 175, modifierActive = 42, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 20, pointsPassive = 200, modifierActive = 48, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 22.5, pointsPassive = 225, modifierActive = 54, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 25, pointsPassive = 250, modifierActive = 60, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 27.5, pointsPassive = 275, modifierActive = 66, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 30, pointsPassive = 300, modifierActive = 72, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 32.5, pointsPassive = 325, modifierActive = 78, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 35, pointsPassive = 350, modifierActive = 84, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 37.5, pointsPassive = 375, modifierActive = 90, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 40, pointsPassive = 400, modifierActive = 96, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 42.5, pointsPassive = 425, modifierActive = 102, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 45, pointsPassive = 450, modifierActive = 108, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 47.5, pointsPassive = 475, modifierActive = 114, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 50, pointsPassive = 500, modifierActive = 120, pointsActive = 1000, minEnergy = 10},
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
            [-6] = {modifierPassive = -30, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, pointsPassive = 0, modifierActive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 3.1, pointsPassive = 25, modifierActive = 6.2, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 6.2, pointsPassive = 50, modifierActive = 12.4, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 9.3, pointsPassive = 75, modifierActive = 18.6, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 12.4, pointsPassive = 100, modifierActive = 24.8, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 15.5, pointsPassive = 125, modifierActive = 31, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 18.6, pointsPassive = 150, modifierActive = 37.2, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 21.7, pointsPassive = 175, modifierActive = 43.4, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 24.8, pointsPassive = 200, modifierActive = 49.6, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 27.9, pointsPassive = 225, modifierActive = 55.8, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 31, pointsPassive = 250, modifierActive = 62, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 34.1, pointsPassive = 275, modifierActive = 68.2, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 37.2, pointsPassive = 300, modifierActive = 74.4, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 40.3, pointsPassive = 325, modifierActive = 80.6, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 43.4, pointsPassive = 350, modifierActive = 86.8, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 46.5, pointsPassive = 375, modifierActive = 93, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 49.6, pointsPassive = 400, modifierActive = 99.2, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 52.7, pointsPassive = 425, modifierActive = 105.4, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 55.8, pointsPassive = 450, modifierActive = 111.6, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 58.9, pointsPassive = 475, modifierActive = 117.8, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 62, pointsPassive = 500, modifierActive = 124, pointsActive = 1000, minEnergy = 10},
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
            [-6] = {modifierPassive = -30, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, pointsPassive = 0, modifierActive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 10, pointsPassive = 25, modifierActive = 20, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 20, pointsPassive = 50, modifierActive = 40, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 30, pointsPassive = 75, modifierActive = 60, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 40, pointsPassive = 100, modifierActive = 80, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 50, pointsPassive = 125, modifierActive = 100, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 60, pointsPassive = 150, modifierActive = 120, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 70, pointsPassive = 175, modifierActive = 140, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 80, pointsPassive = 200, modifierActive = 160, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 90, pointsPassive = 225, modifierActive = 180, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 100, pointsPassive = 250, modifierActive = 200, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 110, pointsPassive = 275, modifierActive = 220, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 120, pointsPassive = 300, modifierActive = 240, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 130, pointsPassive = 325, modifierActive = 260, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 140, pointsPassive = 350, modifierActive = 280, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 150, pointsPassive = 375, modifierActive = 300, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 160, pointsPassive = 400, modifierActive = 320, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 170, pointsPassive = 425, modifierActive = 340, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 180, pointsPassive = 450, modifierActive = 360, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 190, pointsPassive = 475, modifierActive = 380, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 200, pointsPassive = 500, modifierActive = 400, pointsActive = 1000, minEnergy = 10},
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
            [-6] = {modifierPassive = -30, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, pointsPassive = 0, modifierActive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 10, pointsPassive = 25, modifierActive = 20, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 20, pointsPassive = 50, modifierActive = 40, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 30, pointsPassive = 75, modifierActive = 60, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 40, pointsPassive = 100, modifierActive = 80, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 50, pointsPassive = 125, modifierActive = 100, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 60, pointsPassive = 150, modifierActive = 120, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 70, pointsPassive = 175, modifierActive = 140, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 80, pointsPassive = 200, modifierActive = 160, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 90, pointsPassive = 225, modifierActive = 180, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 100, pointsPassive = 250, modifierActive = 200, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 110, pointsPassive = 275, modifierActive = 220, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 120, pointsPassive = 300, modifierActive = 240, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 130, pointsPassive = 325, modifierActive = 260, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 140, pointsPassive = 350, modifierActive = 280, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 150, pointsPassive = 375, modifierActive = 300, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 160, pointsPassive = 400, modifierActive = 320, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 170, pointsPassive = 425, modifierActive = 340, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 180, pointsPassive = 450, modifierActive = 360, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 190, pointsPassive = 475, modifierActive = 380, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 200, pointsPassive = 500, modifierActive = 400, pointsActive = 1000, minEnergy = 10},
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
            [-6] = {modifierPassive = -30, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, pointsPassive = 0, modifierActive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 6, pointsPassive = 25, modifierActive = 12, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 12, pointsPassive = 50, modifierActive = 24, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 18, pointsPassive = 75, modifierActive = 36, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 24, pointsPassive = 100, modifierActive = 48, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 30, pointsPassive = 125, modifierActive = 60, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 36, pointsPassive = 150, modifierActive = 72, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 42, pointsPassive = 175, modifierActive = 84, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 48, pointsPassive = 200, modifierActive = 96, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 54, pointsPassive = 225, modifierActive = 108, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 60, pointsPassive = 250, modifierActive = 120, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 66, pointsPassive = 275, modifierActive = 132, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 72, pointsPassive = 300, modifierActive = 144, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 78, pointsPassive = 325, modifierActive = 156, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 84, pointsPassive = 350, modifierActive = 168, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 90, pointsPassive = 375, modifierActive = 180, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 96, pointsPassive = 400, modifierActive = 192, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 102, pointsPassive = 425, modifierActive = 204, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 108, pointsPassive = 450, modifierActive = 216, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 114, pointsPassive = 475, modifierActive = 228, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 120, pointsPassive = 500, modifierActive = 240, pointsActive = 1000, minEnergy = 10},
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
            [-6] = {modifierPassive = -30, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, pointsPassive = 0, modifierActive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 2.4, pointsPassive = 25, modifierActive = 4.9, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 4.8, pointsPassive = 50, modifierActive = 9.8, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 7.2, pointsPassive = 75, modifierActive = 14.7, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 9.6, pointsPassive = 100, modifierActive = 19.6, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 12, pointsPassive = 125, modifierActive = 24.5, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 14.4, pointsPassive = 150, modifierActive = 29.4, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 16.8, pointsPassive = 175, modifierActive = 34.3, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 19.2, pointsPassive = 200, modifierActive = 39.2, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 21.6, pointsPassive = 225, modifierActive = 44.1, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 24, pointsPassive = 250, modifierActive = 49, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 26.4, pointsPassive = 275, modifierActive = 53.9, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 28.8, pointsPassive = 300, modifierActive = 58.8, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 31.2, pointsPassive = 325, modifierActive = 63.7, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 33.6, pointsPassive = 350, modifierActive = 68.6, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 36, pointsPassive = 375, modifierActive = 73.5, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 38.4, pointsPassive = 400, modifierActive = 78.4, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 40.8, pointsPassive = 425, modifierActive = 83.3, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 43.2, pointsPassive = 450, modifierActive = 88.2, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 45.6, pointsPassive = 475, modifierActive = 93.1, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 48, pointsPassive = 500, modifierActive = 98, pointsActive = 1000, minEnergy = 10},
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
            [-6] = {modifierPassive = -30, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, pointsPassive = 0, modifierActive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 3.6, pointsPassive = 25, modifierActive = 7.2, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 7.2, pointsPassive = 50, modifierActive = 14.4, pointsActive = 100, minEnergy = 1},
            [3] = {modifierPassive = 10.8, pointsPassive = 75, modifierActive = 21.6, pointsActive = 150, minEnergy = 2},
            [4] = {modifierPassive = 14.4, pointsPassive = 100, modifierActive = 28.8, pointsActive = 200, minEnergy = 2},
            [5] = {modifierPassive = 18, pointsPassive = 125, modifierActive = 36, pointsActive = 250, minEnergy = 3},
            [6] = {modifierPassive = 21.6, pointsPassive = 150, modifierActive = 43.2, pointsActive = 300, minEnergy = 3},
            [7] = {modifierPassive = 25.2, pointsPassive = 175, modifierActive = 50.4, pointsActive = 350, minEnergy = 4},
            [8] = {modifierPassive = 28.8, pointsPassive = 200, modifierActive = 57.6, pointsActive = 400, minEnergy = 4},
            [9] = {modifierPassive = 32.4, pointsPassive = 225, modifierActive = 64.8, pointsActive = 450, minEnergy = 5},
            [10] = {modifierPassive = 36, pointsPassive = 250, modifierActive = 72, pointsActive = 500, minEnergy = 5},
            [11] = {modifierPassive = 39.6, pointsPassive = 275, modifierActive = 79.2, pointsActive = 550, minEnergy = 6},
            [12] = {modifierPassive = 43.2, pointsPassive = 300, modifierActive = 86.4, pointsActive = 600, minEnergy = 6},
            [13] = {modifierPassive = 46.8, pointsPassive = 325, modifierActive = 93.6, pointsActive = 650, minEnergy = 7},
            [14] = {modifierPassive = 50.4, pointsPassive = 350, modifierActive = 100.8, pointsActive = 700, minEnergy = 7},
            [15] = {modifierPassive = 54, pointsPassive = 375, modifierActive = 108, pointsActive = 750, minEnergy = 8},
            [16] = {modifierPassive = 57.6, pointsPassive = 400, modifierActive = 115.2, pointsActive = 800, minEnergy = 8},
            [17] = {modifierPassive = 61.2, pointsPassive = 425, modifierActive = 122.4, pointsActive = 850, minEnergy = 9},
            [18] = {modifierPassive = 64.8, pointsPassive = 450, modifierActive = 129.6, pointsActive = 900, minEnergy = 9},
            [19] = {modifierPassive = 68.4, pointsPassive = 475, modifierActive = 136.8, pointsActive = 950, minEnergy = 10},
            [20] = {modifierPassive = 72, pointsPassive = 500, modifierActive = 144, pointsActive = 1000, minEnergy = 10},
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
            [-6] = {modifierPassive = -30, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-5] = {modifierPassive = -25, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-4] = {modifierPassive = -20, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-3] = {modifierPassive = -15, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-2] = {modifierPassive = -10, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [-1] = {modifierPassive = -5, pointsPassive = 0, modifierActive = nil, pointsActive = nil, minEnergy = nil},
            [0] = {modifierPassive = 0, pointsPassive = 0, modifierActive = 0, pointsActive = 0, minEnergy = 0},
            [1] = {modifierPassive = 25, pointsPassive = 25, modifierActive = 25, pointsActive = 25, minEnergy = 1},
            [2] = {modifierPassive = 50, pointsPassive = 50, modifierActive = 50, pointsActive = 50, minEnergy = 1},
            [3] = {modifierPassive = 75, pointsPassive = 75, modifierActive = 75, pointsActive = 75, minEnergy = 2},
            [4] = {modifierPassive = 100, pointsPassive = 100, modifierActive = 100, pointsActive = 100, minEnergy = 2},
            [5] = {modifierPassive = 125, pointsPassive = 125, modifierActive = 125, pointsActive = 125, minEnergy = 3},
            [6] = {modifierPassive = 150, pointsPassive = 150, modifierActive = 150, pointsActive = 150, minEnergy = 3},
            [7] = {modifierPassive = 175, pointsPassive = 175, modifierActive = 175, pointsActive = 175, minEnergy = 4},
            [8] = {modifierPassive = 200, pointsPassive = 200, modifierActive = 200, pointsActive = 200, minEnergy = 4},
            [9] = {modifierPassive = 225, pointsPassive = 225, modifierActive = 225, pointsActive = 225, minEnergy = 5},
            [10] = {modifierPassive = 250, pointsPassive = 250, modifierActive = 250, pointsActive = 250, minEnergy = 5},
            [11] = {modifierPassive = 275, pointsPassive = 275, modifierActive = 275, pointsActive = 275, minEnergy = 6},
            [12] = {modifierPassive = 300, pointsPassive = 300, modifierActive = 300, pointsActive = 300, minEnergy = 6},
            [13] = {modifierPassive = 325, pointsPassive = 325, modifierActive = 325, pointsActive = 325, minEnergy = 7},
            [14] = {modifierPassive = 350, pointsPassive = 350, modifierActive = 350, pointsActive = 350, minEnergy = 7},
            [15] = {modifierPassive = 375, pointsPassive = 375, modifierActive = 375, pointsActive = 375, minEnergy = 8},
            [16] = {modifierPassive = 400, pointsPassive = 400, modifierActive = 400, pointsActive = 400, minEnergy = 8},
            [17] = {modifierPassive = 425, pointsPassive = 425, modifierActive = 425, pointsActive = 425, minEnergy = 9},
            [18] = {modifierPassive = 450, pointsPassive = 450, modifierActive = 450, pointsActive = 450, minEnergy = 9},
            [19] = {modifierPassive = 475, pointsPassive = 475, modifierActive = 475, pointsActive = 475, minEnergy = 10},
            [20] = {modifierPassive = 500, pointsPassive = 500, modifierActive = 500, pointsActive = 500, minEnergy = 10},
        },
    },

    -- Modify movements of direct units of the owner player.
    [46] = {
        minLevelActive     = 1,
        maxLevelActive     = 5,
        modifierUnit = "",
        levels = {
            [1] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 1, pointsActive = 175, minEnergy = 1},
            [2] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 2, pointsActive = 350, minEnergy = 3},
            [3] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 3, pointsActive = 525, minEnergy = 5},
            [4] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 4, pointsActive = 700, minEnergy = 7},
            [5] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 5, pointsActive = 875, minEnergy = 9},
        },
    },

    -- Modify movements of indirect units of the owner player.
    [47] = {
        minLevelActive     = 1,
        maxLevelActive     = 5,
        modifierUnit = "",
        levels = {
            [1] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 1, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 2, pointsActive = 100, minEnergy = 2},
            [3] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 3, pointsActive = 150, minEnergy = 3},
            [4] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 4, pointsActive = 200, minEnergy = 4},
            [5] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 5, pointsActive = 250, minEnergy = 5},
        },
    },

    -- Modify movements of ground units of the owner player.
    [48] = {
        minLevelActive     = 1,
        maxLevelActive     = 5,
        modifierUnit = "",
        levels = {
            [1] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 1, pointsActive = 150, minEnergy = 1},
            [2] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 2, pointsActive = 325, minEnergy = 3},
            [3] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 3, pointsActive = 475, minEnergy = 5},
            [4] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 4, pointsActive = 650, minEnergy = 7},
            [5] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 5, pointsActive = 800, minEnergy = 9},
        },
    },

    -- Modify movements of air units of the owner player.
    [49] = {
        minLevelActive     = 1,
        maxLevelActive     = 5,
        modifierUnit = "",
        levels = {
            [1] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 1, pointsActive = 125, minEnergy = 1},
            [2] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 2, pointsActive = 250, minEnergy = 3},
            [3] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 3, pointsActive = 375, minEnergy = 5},
            [4] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 4, pointsActive = 500, minEnergy = 7},
            [5] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 5, pointsActive = 625, minEnergy = 9},
        },
    },

    -- Modify movements of naval units of the owner player.
    [50] = {
        minLevelActive     = 1,
        maxLevelActive     = 5,
        modifierUnit = "",
        levels = {
            [1] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 1, pointsActive = 125, minEnergy = 1},
            [2] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 2, pointsActive = 250, minEnergy = 3},
            [3] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 3, pointsActive = 375, minEnergy = 5},
            [4] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 4, pointsActive = 500, minEnergy = 7},
            [5] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 5, pointsActive = 625, minEnergy = 9},
        },
    },

    -- Modify movements of infantry units of the owner player.
    [51] = {
        minLevelActive     = 1,
        maxLevelActive     = 5,
        modifierUnit = "",
        levels = {
            [1] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 1, pointsActive = 100, minEnergy = 1},
            [2] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 2, pointsActive = 200, minEnergy = 2},
            [3] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 3, pointsActive = 300, minEnergy = 3},
            [4] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 4, pointsActive = 400, minEnergy = 4},
            [5] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 5, pointsActive = 500, minEnergy = 5},
        },
    },

    -- Modify movements of vehicle units of the owner player.
    [52] = {
        minLevelActive     = 1,
        maxLevelActive     = 5,
        modifierUnit = "",
        levels = {
            [1] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 1, pointsActive = 150, minEnergy = 1},
            [2] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 2, pointsActive = 300, minEnergy = 3},
            [3] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 3, pointsActive = 450, minEnergy = 5},
            [4] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 4, pointsActive = 600, minEnergy = 7},
            [5] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 5, pointsActive = 750, minEnergy = 9},
        },
    },

    -- Modify movements of direct non-infantry units of the owner player.
    [53] = {
        minLevelActive     = 1,
        maxLevelActive     = 5,
        modifierUnit = "",
        levels = {
            [1] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 1, pointsActive = 175, minEnergy = 2},
            [2] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 2, pointsActive = 300, minEnergy = 3},
            [3] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 3, pointsActive = 400, minEnergy = 4},
            [4] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 4, pointsActive = 500, minEnergy = 5},
            [5] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 5, pointsActive = 600, minEnergy = 6},
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
            [1] = {modifierPassive = 1, pointsPassive = 50, modifierActive = 1, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 2, pointsPassive = 100, modifierActive = 2, pointsActive = 100, minEnergy = 2},
            [3] = {modifierPassive = 3, pointsPassive = 150, modifierActive = 3, pointsActive = 150, minEnergy = 3},
            [4] = {modifierPassive = 4, pointsPassive = 200, modifierActive = 4, pointsActive = 200, minEnergy = 4},
            [5] = {modifierPassive = 5, pointsPassive = 250, modifierActive = 5, pointsActive = 250, minEnergy = 5},
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
            [1] = {modifierPassive = 1, pointsPassive = 75, modifierActive = 1, pointsActive = 75, minEnergy = 1},
            [2] = {modifierPassive = 2, pointsPassive = 125, modifierActive = 2, pointsActive = 125, minEnergy = 2},
            [3] = {modifierPassive = 3, pointsPassive = 175, modifierActive = 3, pointsActive = 175, minEnergy = 3},
            [4] = {modifierPassive = 4, pointsPassive = 225, modifierActive = 4, pointsActive = 225, minEnergy = 4},
            [5] = {modifierPassive = 5, pointsPassive = 275, modifierActive = 5, pointsActive = 275, minEnergy = 5},
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
            [1] = {modifierPassive = 1, pointsPassive = 50, modifierActive = 1, pointsActive = 50, minEnergy = 1},
            [2] = {modifierPassive = 2, pointsPassive = 100, modifierActive = 2, pointsActive = 100, minEnergy = 2},
            [3] = {modifierPassive = 3, pointsPassive = 150, modifierActive = 3, pointsActive = 150, minEnergy = 3},
            [4] = {modifierPassive = 4, pointsPassive = 200, modifierActive = 4, pointsActive = 200, minEnergy = 4},
            [5] = {modifierPassive = 5, pointsPassive = 250, modifierActive = 5, pointsActive = 250, minEnergy = 5},
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
            [1] = {modifierPassive = 1, pointsPassive = 100, modifierActive = 1, pointsActive = 100, minEnergy = 1},
            [2] = {modifierPassive = 2, pointsPassive = 150, modifierActive = 2, pointsActive = 150, minEnergy = 2},
            [3] = {modifierPassive = 3, pointsPassive = 200, modifierActive = 3, pointsActive = 200, minEnergy = 3},
            [4] = {modifierPassive = 4, pointsPassive = 250, modifierActive = 4, pointsActive = 250, minEnergy = 4},
            [5] = {modifierPassive = 5, pointsPassive = 300, modifierActive = 5, pointsActive = 300, minEnergy = 5},
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
            [1] = {modifierPassive = nil, pointsPassive = 150, modifierActive = nil, pointsActive = 150, minEnergy = 1},
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
            [1] = {modifierPassive = nil, pointsPassive = 75, modifierActive = nil, pointsActive = 75, minEnergy = 1},
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
            [1] = {modifierPassive = nil, pointsPassive = 175, modifierActive = nil, pointsActive = 175, minEnergy = 1},
        },
    },

    -- Add energy instantly.
    [61] = {
        minLevelActive = 1,
        maxLevelActive = 4,
        modifierUnit = "",
        levels = {
            [1] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 0.25, pointsActive = 25, minEnergy = 2},
            [2] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 0.5, pointsActive = 50, minEnergy = 4},
            [3] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 0.75, pointsActive = 75, minEnergy = 6},
            [4] = {modifierPassive = nil, pointsPassive = nil, modifierActive = 1, pointsActive = 100, minEnergy = 8},
        },
    },

    -- Instant: Modify HPs of all units of the opponents.
    [62] = {
        minLevelActive     = 1,
        maxLevelActive     = 9,
        modifierUnit = "HP",
        levels = {
            [1] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -1, pointsActive = 300, minEnergy = 3},
            [2] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -2, pointsActive = 575, minEnergy = 6},
            [3] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -3, pointsActive = 825, minEnergy = 9},
            [4] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -4, pointsActive = 1050, minEnergy = 12},
            [5] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -5, pointsActive = 1250, minEnergy = 15},
            [6] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -6, pointsActive = 1425, minEnergy = 18},
            [7] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -7, pointsActive = 1575, minEnergy = 21},
            [8] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -8, pointsActive = 1700, minEnergy = 24},
            [9] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -9, pointsActive = 1800, minEnergy = 27},
        },
    },

    -- Instant: Modify the fuel of the opponents' units.
    [63] = {
        minLevelActive     = 1,
        maxLevelActive     = 12,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -33.3333333333333, pointsActive = 25, minEnergy = 1},
            [2] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -66.6666666666667, pointsActive = 50, minEnergy = 2},
            [3] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -100, pointsActive = 75, minEnergy = 3},
            [4] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -133.333333333333, pointsActive = 100, minEnergy = 4},
            [5] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -166.666666666667, pointsActive = 125, minEnergy = 5},
            [6] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -200, pointsActive = 150, minEnergy = 6},
            [7] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -233.333333333333, pointsActive = 175, minEnergy = 7},
            [8] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -266.666666666667, pointsActive = 200, minEnergy = 8},
            [9] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -300, pointsActive = 225, minEnergy = 9},
            [10] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -333.333333333333, pointsActive = 250, minEnergy = 10},
            [11] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -366.666666666667, pointsActive = 275, minEnergy = 11},
            [12] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -400, pointsActive = 300, minEnergy = 12},
        },
    },

    -- Instant: Modify the energy of the opponents.
    [64] = {
        minLevelActive     = 1,
        maxLevelActive     = 10,
        modifierUnit = "%",
        levels       = {
            [1] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -2, pointsActive = 25, minEnergy = 1},
            [2] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -4, pointsActive = 50, minEnergy = 1},
            [3] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -6, pointsActive = 75, minEnergy = 2},
            [4] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -8, pointsActive = 100, minEnergy = 2},
            [5] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -10, pointsActive = 125, minEnergy = 3},
            [6] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -12, pointsActive = 150, minEnergy = 3},
            [7] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -14, pointsActive = 175, minEnergy = 4},
            [8] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -16, pointsActive = 200, minEnergy = 4},
            [9] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -18, pointsActive = 225, minEnergy = 5},
            [10] = {modifierPassive = nil, pointsPassive = nil, modifierActive = -20, pointsActive = 250, minEnergy = 5},
        },
    },
}

SkillData.skillPresets = {
    -- Adder
    {
        name      = "Adder",
        basePoints = 100,
        passive   = {
            {
                id    = 18,
                level = 1,
            },
        },
        active1 = {
            energyRequirement = 2,
            skills            = {
                {
                    id    = 6,
                    level = 1,
                },
            }
        },
        active2 = {
            energyRequirement = 5,
            skills            = {
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
    },

    -- Andy
    {
        name      = "Andy",
        basePoints = 100,
        passive = {
        },
        active1 = {
            energyRequirement = 3,
            skills            = {
                {
                    id    = 4,
                    level = 2,
                },
                {
                    id    = 1,
                    level = 2,
                },
            },
        },
        active2 = {
            energyRequirement = 6,
            skills            = {
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
    },

    -- Colin
    {
        name      = "Colin",
        basePoints = 100,
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
            skills            = {
                {
                    id    = 12,
                    level = 6,
                },
            },
        },
        active2 = {
            energyRequirement = 6,
            skills            = {
                {
                    id    = 20,
                    level = 14,
                },
            },
        },
    },

    -- Drake
    {
        name      = "Drake",
        basePoints = 100,
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
            energyRequirement = 4,
            skills            = {
                {
                    id    = 62,
                    level = 1,
                },
                {
                    id    = 63,
                    level = 2,
                },
            },
        },
        active2 = {
            energyRequirement = 7,
            skills            = {
                {
                    id    = 62,
                    level = 2,
                },
                {
                    id    = 63,
                    level = 4,
                },
            },
        },
    },

    -- Eagle
    {
        name      = "Eagle",
        basePoints = 100,
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
            skills            = {
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
        },
        active2 = {
            energyRequirement = 9,
            skills            = {
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
    },

    -- Grimm
    {
        name      = "Grimm",
        basePoints = 100,
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
            skills            = {
                {
                    id    = 1,
                    level = 5,
                },
            },
        },
        active2 = {
            energyRequirement = 6,
            skills            = {
                {
                    id    = 1,
                    level = 10,
                },
            },
        },
    },

    -- Grit
    {
        name      = "Grit",
        basePoints = 100,
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
            skills            = {
                {
                    id    = 7,
                    level = 1,
                },
                {
                    id    = 30,
                    level = 2,
                },
            },
        },
        active2 = {
            energyRequirement = 6,
            skills            = {
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
    },

    -- Hawke
    {
        name      = "Hawke",
        basePoints = 100,
        passive = {
            {
                id    = 1,
                level = 2,
            },
        },
        active1 = {
            energyRequirement = 5,
            skills            = {
                {
                    id    = 4,
                    level = 1,
                },
                {
                    id    = 62,
                    level = 1,
                },
            },
        },
        active2 = {
            energyRequirement = 9,
            skills            = {
                {
                    id    = 4,
                    level = 2,
                },
                {
                    id    = 62,
                    level = 2,
                },
            },
        },
    },

    -- Jess
    {
        name      = "Jess",
        basePoints = 100,
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
            skills            = {
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
        },
        active2 = {
            energyRequirement = 6,
            skills            = {
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
    },

    -- Lash
    {
        name      = "Lash",
        basePoints = 100,
        passive = {
            {
                id    = 23,
                level = 3,
            },
        },
        active1 = {
            energyRequirement = 4,
            skills            = {
                {
                    id    = 28,
                    level = 1,
                },
                {
                    id    = 23,
                    level = 1,
                },
                {
                    id    = 24,
                    level = 1,
                },
            },
        },
        active2 = {
            energyRequirement = 7,
            skills            = {
                {
                    id    = 28,
                    level = 1,
                },
                {
                    id    = 23,
                    level = 2,
                },
                {
                    id    = 24,
                    level = 2,
                },
            },
        },
    },

    -- Max
    {
        name      = "Max",
        basePoints = 100,
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
            skills            = {
                {
                    id    = 36,
                    level = 2,
                },
                {
                    id    = 53,
                    level = 1,
                },
            },
        },
        active2 = {
            energyRequirement = 6,
            skills            = {
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
    },

    -- Nell
    {
        name      = "Nell",
        basePoints = 100,
        passive = {
            {
                id    = 14,
                level = 4,
            },
        },
        active1 = {
            energyRequirement = 3,
            skills            = {
                {
                    id    = 14,
                    level = 3,
                },
            },
        },
        active2 = {
            energyRequirement = 6,
            skills            = {
                {
                    id    = 14,
                    level = 6,
                },
            },
        },
    },

    -- Sami
    {
        name      = "Sami",
        basePoints = 100,
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
            skills            = {
                {
                    id    = 34,
                    level = 3,
                },
                {
                    id    = 51,
                    level = 1,
                },
            },
        },
        active2 = {
            energyRequirement = 8,
            skills            = {
                {
                    id    = 15,
                    level = 5,
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
    },

    -- Sasha
    {
        name      = "Sasha",
        basePoints = 100,
        passive = {
            {
                id    = 17,
                level = 4,
            },
        },
        active1 = {
            energyRequirement = 2,
            skills            = {
                {
                    id    = 64,
                    level = 5,
                },
            },
        },
        active2 = {
            energyRequirement = 6,
            skills            = {
                {
                    id    = 22,
                    level = 10,
                },
            },
        },
    },

    -- Zhaotiantong
    {
        name       = "Zhaotiantong",
        basePoints = 100,
        passive    = {
            {
                id    = 1,
                level = 3,
            },
            {
                id    = 2,
                level = 3,
            },
            {
                id    = 3,
                level = 4,
            },
        },
        active1 = {},
        active2 = {},
    },
}

return SkillData
