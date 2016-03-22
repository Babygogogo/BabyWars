
local WarScene_Test2 = {
    warField = "WarField_Test2",

    turn = {
        turnIndex   = 1,
        playerIndex = 1,
        phase       = "standby",
    },

    players = {
        {
            id      = 1,
            name    = "Alice",
            fund    = 111111,
            isAlive = true,
            co      = {
                currentEnergy    = 1,
                coPowerEnergy    = 2,
                superPowerEnergy = 10,
            },
        },
        {
            id      = 2,
            name    = "Bob",
            fund    = 222222,
            isAlive = true,
            co      = {
                currentEnergy    = 2,
                coPowerEnergy    = 4,
                superPowerEnergy = 10,
            },
        },
        {
            id      = 3,
            name    = "Cat",
            fund    = 333333,
            isAlive = true,
            co      = {
                currentEnergy    = 3,
                coPowerEnergy    = 6,
                superPowerEnergy = 10,
            },
        },
        {
            id      = 4,
            name    = "Dog",
            fund    = 444444,
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
