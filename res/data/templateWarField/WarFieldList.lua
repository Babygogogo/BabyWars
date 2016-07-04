
local templateWarFieldPath = "res.data.templateWarField."

return {
    Chessboard   = require(templateWarFieldPath .. "Chessboard")  .warFieldName,
    EqualIsland  = require(templateWarFieldPath .. "EqualIsland") .warFieldName,
    FullTest     = require(templateWarFieldPath .. "FullTest")    .warFieldName,
    CoilRange    = require(templateWarFieldPath .. "CoilRange")   .warFieldName,
    PlugMountain = require(templateWarFieldPath .. "PlugMountain").warFieldName,
}
