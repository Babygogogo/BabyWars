
local templateWarFieldPath = "res.data.templateWarField."

return {
    ChaZuoShanMai     = require(templateWarFieldPath .. "ChaZuoShanMai")    .warFieldName,
    DuiChenDaoYu      = require(templateWarFieldPath .. "DuiChenDaoYu")     .warFieldName,
    FullTest          = require(templateWarFieldPath .. "FullTest")         .warFieldName,
    GaoLaMiJia        = require(templateWarFieldPath .. "GaoLaMiJia")       .warFieldName,
    HuanXingShanMai   = require(templateWarFieldPath .. "HuanXingShanMai")  .warFieldName,
    HuiXingDeMaiDong  = require(templateWarFieldPath .. "HuiXingDeMaiDong") .warFieldName,
    JiangQi           = require(templateWarFieldPath .. "JiangQi")          .warFieldName,
    QianTanDengLu     = require(templateWarFieldPath .. "QianTanDengLu")    .warFieldName,
    XiaoGuoZhengBaSai = require(templateWarFieldPath .. "XiaoGuoZhengBaSai").warFieldName,
}
