
local SkillData = {}

SkillData.minBasePoints                   = 0
SkillData.maxBasePoints                   = 200
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

SkillData.skills = {
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
                    level = 4,
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
            energyRequirement = 3,
            skills            = {
                {
                    id    = 5,
                    level = 1,
                },
                {
                    id    = 9,
                    level = 2,
                },
            },
        },
        active2 = {
            energyRequirement = 7,
            skills            = {
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
                    id    = 5,
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
                    id    = 5,
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
                level = 6,
            },
        },
        active1 = {
            energyRequirement = 4,
            skills            = {
                {
                    id    = 28,
                    level = 1,
                },
            },
        },
        active2 = {
            energyRequirement = 7,
            skills            = {
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
                    id    = 13,
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
