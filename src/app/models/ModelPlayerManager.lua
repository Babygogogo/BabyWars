
--[[--------------------------------------------------------------------------------
-- ModelPlayerManager是战局上的玩家管理器，负责维护玩家列表及在适当时候更新玩家数据。
--
-- 主要职责
--   同上
--
-- 使用场景举例：
--   - 在回合进入“获得收入”的阶段（即收到EvtTurnPhaseGetFund消息）时，更新相应的player属性。
--   - 在回合进入“维修单位”的阶段（即收到EvtTurnPhaseRepairUnit消息）时，更新相应的unit和player的属性。
--
-- 其他：
--  - 在本类中响应“维修单位”有点不合理，可以移动到别的地方处理
--
--  - 本类目前没有对应的view，因为暂时还不用显示。
--]]--------------------------------------------------------------------------------

local ModelPlayerManager = class("ModelPlayerManager")

local ModelPlayer = require("app.models.ModelPlayer")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getRepairableModelUnits(modelUnitMap, modelTileMap, playerIndex)
    local units = {}
    modelUnitMap:forEachModelUnit(function(modelUnit)
        if (modelUnit:getPlayerIndex() == playerIndex) then
            local modelTile = modelTileMap:getModelTile(modelUnit:getGridIndex())
            if ((modelTile.canRepairTarget) and (modelTile:canRepairTarget(modelUnit))) then
                units[#units + 1] = modelUnit
            end
        end
    end)

    table.sort(units, function(unit1, unit2)
        local cost1, cost2 = unit1:getProductionCost(), unit2:getProductionCost()
        return ((cost1 > cost2) or
                (cost1 == cost2) and (unit1:getUnitId() < unit2:getUnitId()))
    end)

    return units
end

local function dispatchEvtModelPlayerUpdated(dispatcher, modelPlayer, playerIndex)
    dispatcher:dispatchEvent({
        name        = "EvtModelPlayerUpdated",
        modelPlayer = modelPlayer,
        playerIndex = playerIndex,
    })
end

local function serializePlayers(self, spacesCount)
    local str = ""
    for _, modelPlayer in ipairs(self.m_Players) do
        str = str .. modelPlayer:serialize(spacesCount) .. ",\n"
    end

    return str
end

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtTurnPhaseGetFund(self, event)
    local playerIndex = event.playerIndex
    local modelPlayer = self:getModelPlayer(playerIndex)

    if (modelPlayer:isAlive()) then
        local income = 0
        event.modelTileMap:forEachModelTile(function(modelTile)
            if (modelTile.getIncomeAmount) then
                income = income + (modelTile:getIncomeAmount(playerIndex) or 0)
            end
        end)

        modelPlayer:setFund(modelPlayer:getFund() + income)
        dispatchEvtModelPlayerUpdated(self.m_RootScriptEventDispatcher, modelPlayer, playerIndex)
    end
end

local function onEvtTurnPhaseRepairUnit(self, event)
    local modelTileMap    = event.modelTileMap
    local playerIndex     = event.playerIndex
    local modelPlayer     = self.m_Players[playerIndex]
    local eventDispatcher = self.m_RootScriptEventDispatcher
    for _, unit in ipairs(getRepairableModelUnits(event.modelUnitMap, modelTileMap, playerIndex)) do
        local repairAmount, repairCost = modelTileMap:getModelTile(unit:getGridIndex()):getRepairAmountAndCost(unit, modelPlayer)

        unit:setCurrentHP(unit:getCurrentHP() + repairAmount)
            :setCurrentFuel(unit:getMaxFuel())
        if ((unit.hasPrimaryWeapon) and (unit:hasPrimaryWeapon())) then
            unit:setPrimaryWeaponCurrentAmmo(unit:getPrimaryWeaponMaxAmmo())
        end
        unit:updateView()
        eventDispatcher:dispatchEvent({name = "EvtModelUnitUpdated", modelUnit = unit})

        modelPlayer:setFund(modelPlayer:getFund() - repairCost)
    end

    dispatchEvtModelPlayerUpdated(eventDispatcher, modelPlayer, playerIndex)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelPlayerManager:ctor(param)
    self.m_Players = {}
    for i, player in ipairs(param) do
        self.m_Players[i] = ModelPlayer:create(player)
    end

    return self
end

function ModelPlayerManager:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelPlayerManager:setRootScriptEventDispatcher() the dispatcher has been set.")

    self.m_RootScriptEventDispatcher = dispatcher
    dispatcher:addEventListener("EvtTurnPhaseGetFund", self)
        :addEventListener("EvtTurnPhaseRepairUnit", self)

    return self
end

function ModelPlayerManager:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "ModelPlayerManager:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")

    self.m_RootScriptEventDispatcher:removeEventListener("EvtTurnPhaseRepairUnit", self)
        :removeEventListener("EvtTurnPhaseGetFund", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
function ModelPlayerManager:onEvent(event)
    local eventName = event.name
    if (eventName == "EvtTurnPhaseGetFund") then
        onEvtTurnPhaseGetFund(self, event)
    elseif (eventName == "EvtTurnPhaseRepairUnit") then
        onEvtTurnPhaseRepairUnit(self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelPlayerManager:getModelPlayer(playerIndex)
    return self.m_Players[playerIndex]
end

function ModelPlayerManager:getPlayersCount()
    return #self.m_Players
end

function ModelPlayerManager:serialize(spacesCount)
    spacesCount = spacesCount or 0
    local spaces         = string.rep(" ", spacesCount)

    return string.format("%splayers = {\n%s%s}",
        spaces,
        serializePlayers(self, spacesCount + 4),
        spaces
    )
end

--------------------------------------------------------------------------------
-- The public functions for doing actions.
--------------------------------------------------------------------------------
function ModelPlayerManager:doActionProduceOnTile(action)
    local playerIndex = action.playerIndex
    local modelPlayer = self:getModelPlayer(action.playerIndex)

    modelPlayer:setFund(modelPlayer:getFund() - action.cost)
    dispatchEvtModelPlayerUpdated(self.m_RootScriptEventDispatcher, modelPlayer, playerIndex)

    return self
end

return ModelPlayerManager
