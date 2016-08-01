
local templateWarFieldPath = "res.data.templateWarField."

return {
    Chessboard       = require(templateWarFieldPath .. "Chessboard")      .warFieldName,
    EqualIsland      = require(templateWarFieldPath .. "EqualIsland")     .warFieldName,
    FullTest         = require(templateWarFieldPath .. "FullTest")        .warFieldName,
    HuanXingShanMai  = require(templateWarFieldPath .. "HuanXingShanMai") .warFieldName,
    ChaZuoShanMai    = require(templateWarFieldPath .. "ChaZuoShanMai")   .warFieldName,
    QianTanDengLu    = require(templateWarFieldPath .. "QianTanDengLu")   .warFieldName,
    HuiXingDeMaiDong = require(templateWarFieldPath .. "HuiXingDeMaiDong").warFieldName,
}
