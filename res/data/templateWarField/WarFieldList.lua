
local templateWarFieldPath = "res.data.templateWarField."

return {
    JiangQi          = require(templateWarFieldPath .. "JiangQi")         .warFieldName,
    DuiChenDaoYu     = require(templateWarFieldPath .. "DuiChenDaoYu")    .warFieldName,
    FullTest         = require(templateWarFieldPath .. "FullTest")        .warFieldName,
    HuanXingShanMai  = require(templateWarFieldPath .. "HuanXingShanMai") .warFieldName,
    ChaZuoShanMai    = require(templateWarFieldPath .. "ChaZuoShanMai")   .warFieldName,
    QianTanDengLu    = require(templateWarFieldPath .. "QianTanDengLu")   .warFieldName,
    HuiXingDeMaiDong = require(templateWarFieldPath .. "HuiXingDeMaiDong").warFieldName,
}
