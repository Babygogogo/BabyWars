
return {
    warField = {
        tileMap = {
            template = "Chessboard",
        },

        unitMap = {
            template = "Chessboard",
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
    },

    weather = {
        current = "clear"
    },
}
