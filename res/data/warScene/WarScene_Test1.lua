
local WarScene_Test1 = {
    warField = "WarField_Test1",

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

return WarScene_Test1
