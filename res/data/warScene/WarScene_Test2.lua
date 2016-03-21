
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
            energy  = 1,
            isAlive = true,
        },
        {
            id      = 2,
            name    = "Bob",
            fund    = 222222,
            energy  = 2,
            isAlive = true,
        },
    },
}

return WarScene_Test2
