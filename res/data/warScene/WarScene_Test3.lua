
local WarScen_Test3 = {
    warField = {
        tileMap = {
            template = "FullTest",

            grids = {
                {
                    GridIndexable = {
                        gridIndex = {x = 17, y = 5},
                    },
                    objectID = 107,
                },
                {
                    GridIndexable = {
                        gridIndex = {x = 18, y = 5},
                    },
                    objectID = 107,
                },
                {
                    GridIndexable = {
                        gridIndex = {x = 19, y = 5},
                    },
                    objectID = 107,
                },
                {
                    GridIndexable = {
                        gridIndex = {x = 19, y = 4},
                    },
                    objectID = 107,
                },
                {
                    GridIndexable = {
                        gridIndex = {x = 17, y = 3},
                    },
                    objectID = 107,
                },
                {
                    GridIndexable = {
                        gridIndex = {x = 18, y = 3},
                    },
                    objectID = 107,
                },
                {
                    GridIndexable = {
                        gridIndex = {x = 19, y = 3},
                    },
                    objectID = 107,
                },
                {
                    GridIndexable = {
                        gridIndex = {x = 19, y = 2},
                    },
                    objectID = 107,
                },
                {
                    GridIndexable = {
                        gridIndex = {x = 17, y = 1},
                    },
                    objectID = 107,
                },
                {
                    GridIndexable = {
                        gridIndex = {x = 18, y = 1},
                    },
                    objectID = 107,
                },
                {
                    GridIndexable = {
                        gridIndex = {x = 19, y = 1},
                    },
                    objectID = 107,
                },
            },
        },

        unitMap = {
            -- There's no template map, so that the grids data is used.
            mapSize = {width = 25, height = 16},

            grids = {
                {
                    tiledID = 163,
                    unitID  = 1,
                    GridIndexable = {gridIndex = {x = 6, y = 7}},
                },
                {
                    tiledID = 164,
                    unitID  = 2,
                    GridIndexable = {gridIndex = {x = 7, y = 7}},
                },
                {
                    tiledID = 165,
                    unitID  = 3,
                    GridIndexable = {gridIndex = {x = 8, y = 7}},
                },
                {
                    tiledID = 166,
                    unitID  = 4,
                    GridIndexable = {gridIndex = {x = 9, y = 7}},
                },
            },
        },
    },

    turn = {
        turnIndex   = 1,
        playerIndex = 1,
        phase       = "beginning",
    },

    players = {
        {
            account       = "babygogogo",
            nickname      = "Red Alice",
            fund          = 0,
            isAlive       = true,
            currentEnergy = 1,
            passiveSkill = {

            },
            activeSkill1 = {
                energyRequirement = 2,
            },
            activeSkill2 = {
                energyRequirement = 3,
            },
        },
        {
            account       = "tester1",
            nickname      = "Blue Bob",
            fund          = 0,
            isAlive       = true,
            currentEnergy = 2,
            passiveSkill = {

            },
            activeSkill1 = {
                energyRequirement = 4,
            },
            activeSkill2 = {
                energyRequirement = 6,
            },
        },
        {
            account       = "tester2",
            nickname      = "Yellow Cat",
            fund          = 0,
            isAlive       = true,
            currentEnergy = 3,
            passiveSkill = {

            },
            activeSkill1 = {
                energyRequirement = 6,
            },
            activeSkill2 = {
                energyRequirement = 9,
            },
        },
        {
            account       = "tester3",
            nickname      = "Black Dog",
            fund          = 0,
            isAlive       = true,
            currentEnergy = 4,
            passiveSkill = {

            },
            activeSkill1 = {
                energyRequirement = 8,
            },
            activeSkill2 = {
                energyRequirement = 12,
            },
        },
    },

    weather = {
        current = "clear"
    },
}

return WarScen_Test3
