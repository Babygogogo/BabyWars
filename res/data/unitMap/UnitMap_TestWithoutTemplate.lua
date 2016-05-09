
local UnitMap_TestWithoutTemplate = {
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
}

return UnitMap_TestWithoutTemplate
