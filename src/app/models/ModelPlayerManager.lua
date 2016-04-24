
local ModelPlayerManager = class("ModelPlayerManager")

local Player      = require("app.models.ModelPlayer")

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
        self.m_RootScriptEventDispatcher:dispatchEvent({
            name        = "EvtModelPlayerUpdated",
            modelPlayer = modelPlayer,
            playerIndex = playerIndex,
        })
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

    eventDispatcher:dispatchEvent({
        name        = "EvtModelPlayerUpdated",
        modelPlayer = modelPlayer,
        playerIndex = playerIndex,
    })
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelPlayerManager:ctor(param)
    self.m_Players = {}
    for i, player in ipairs(param) do
        self.m_Players[i] = Player:create(player)
    end

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node/script events.
--------------------------------------------------------------------------------
function ModelPlayerManager:onEnter(rootActor)
    self.m_RootScriptEventDispatcher = rootActor:getModel():getScriptEventDispatcher()
    self.m_RootScriptEventDispatcher:addEventListener("EvtTurnPhaseGetFund", self)
        :addEventListener("EvtTurnPhaseRepairUnit", self)

    return self
end

function ModelPlayerManager:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtTurnPhaseRepairUnit", self)
        :removeEventListener("EvtTurnPhaseGetFund", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

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

return ModelPlayerManager
