
local WarScene_Test2 = {
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
                        gridIndex = {x = 17, y = 2},
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
            template = "FullTest",

            grids = {
                -- There's a template map, so that the grids data is ignored even if it's not empty.
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
            id      = 1,
            name    = "Red Alice",
            fund    = 0,
            isAlive = true,
            co      = {
                currentEnergy    = 1,
                coPowerEnergy    = 2,
                superPowerEnergy = 10,
            },
        },
        {
            id      = 2,
            name    = "Blue Bob",
            fund    = 0,
            isAlive = true,
            co      = {
                currentEnergy    = 2,
                coPowerEnergy    = 4,
                superPowerEnergy = 10,
            },
        },
        {
            id      = 3,
            name    = "Yellow Cat",
            fund    = 0,
            isAlive = true,
            co      = {
                currentEnergy    = 3,
                coPowerEnergy    = 6,
                superPowerEnergy = 10,
            },
        },
        {
            id      = 4,
            name    = "Black Dog",
            fund    = 0,
            isAlive = true,
            co      = {
                currentEnergy    = 4,
                coPowerEnergy    = 6,
                superPowerEnergy = 10,
            },
        },
    },

    weather = {
        current = "clear"
    },
}

return WarScene_Test2
