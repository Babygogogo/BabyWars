
local InstantSkillExecutor = {}

local GameConstantFunctions = requireBW("src.app.utilities.GameConstantFunctions")
local SingletonGetters      = requireBW("src.app.utilities.SingletonGetters")
local SkillDataAccessors    = requireBW("src.app.utilities.SkillDataAccessors")
local SupplyFunctions       = requireBW("src.app.utilities.SupplyFunctions")

local IS_SERVER = GameConstantFunctions.isServer()

local getPlayerIndexLoggedIn = SingletonGetters.getPlayerIndexLoggedIn
local getSkillModifier       = SkillDataAccessors.getSkillModifier

local s_Executors = {}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function modifyModelUnitHp(modelUnit, modifier)
    local newHP     = math.min(100, modelUnit:getCurrentHP() + modifier)
    newHP           = math.max(1, newHP)
    modelUnit:setCurrentHP(newHP)
        :updateView()
end

local function round(num)
    return math.floor(num + 0.5)
end

--------------------------------------------------------------------------------
-- The functions for executing instant skills.
--------------------------------------------------------------------------------
-- Modify HPs of all units of the currently-in-turn player.
s_Executors.execute4 = function(modelSceneWar, level)
    local modifier     = getSkillModifier(4, level, true) * 10
    local playerIndex  = modelSceneWar:getModelTurnManager():getPlayerIndex()
    local func         = function(modelUnit)
        if (modelUnit:getPlayerIndex() == playerIndex) then
            modifyModelUnitHp(modelUnit, modifier)
        end
    end

    modelSceneWar:getModelWarField():getModelUnitMap():forEachModelUnitOnMap(func)
        :forEachModelUnitLoaded(func)

    modelSceneWar:getScriptEventDispatcher():dispatchEvent({name = "EvtModelUnitMapUpdated"})
end

s_Executors.execute5 = function(modelSceneWar, level)
    local modifier     = getSkillModifier(5, level, true) * 10
    local playerIndex  = modelSceneWar:getModelTurnManager():getPlayerIndex()
    local func         = function(modelUnit)
        if (modelUnit:getPlayerIndex() ~= playerIndex) then
            modifyModelUnitHp(modelUnit, modifier)
        end
    end

    modelSceneWar:getModelWarField():getModelUnitMap():forEachModelUnitOnMap(func)
        :forEachModelUnitLoaded(func)

    modelSceneWar:getScriptEventDispatcher():dispatchEvent({name = "EvtModelUnitMapUpdated"})
end

s_Executors.execute8 = function(modelSceneWar, level)
    local playerIndex = modelSceneWar:getModelTurnManager():getPlayerIndex()
    local func        = function(modelUnit)
        if ((modelUnit:getPlayerIndex() == playerIndex)                                             and
            (not GameConstantFunctions.isTypeInCategory(modelUnit:getUnitType(), "InfantryUnits"))) then
            modelUnit:setStateIdle()
                :updateView()
        end
    end

    modelSceneWar:getModelWarField():getModelUnitMap():forEachModelUnitOnMap(func)
        :forEachModelUnitLoaded(func)

    modelSceneWar:getScriptEventDispatcher():dispatchEvent({name = "EvtModelUnitMapUpdated"})
end

s_Executors.execute9 = function(modelSceneWar, level)
    local playerIndex  = modelSceneWar:getModelTurnManager():getPlayerIndex()
    local baseModifier = getSkillModifier(9, level, true)
    local modifier     = (baseModifier >= 0) and ((100 + baseModifier) / 100) or (100 / (100 - baseModifier))
    local func         = function(modelUnit)
        if (modelUnit:getPlayerIndex() ~= playerIndex) then
            modelUnit:setCurrentFuel(math.min(modelUnit:getMaxFuel(), round(modelUnit:getCurrentFuel() * modifier)))
                :updateView()
        end
    end

    modelSceneWar:getModelWarField():getModelUnitMap():forEachModelUnitOnMap(func)
        :forEachModelUnitLoaded(func)

    modelSceneWar:getScriptEventDispatcher():dispatchEvent({name = "EvtModelUnitMapUpdated"})
end

s_Executors.execute12 = function(modelSceneWar, level)
    local playerIndex  = modelSceneWar:getModelTurnManager():getPlayerIndex()
    local modelPlayer  = modelSceneWar:getModelPlayerManager():getModelPlayer(playerIndex)
    local baseModifier = getSkillModifier(12, level, true)
    modelPlayer:setFund(round(modelPlayer:getFund() * (baseModifier + 100) / 100))

    modelSceneWar:getScriptEventDispatcher():dispatchEvent({
        name        = "EvtModelPlayerUpdated",
        modelPlayer = modelPlayer,
        playerIndex = playerIndex,
    })
end

s_Executors.execute13 = function(modelSceneWar, level)
    local modelPlayerManager = modelSceneWar:getModelPlayerManager()
    local playerIndex        = modelSceneWar:getModelTurnManager():getPlayerIndex()
    local fund               = modelPlayerManager:getModelPlayer(playerIndex):getFund()
    local modifier           = getSkillModifier(13, level, true) * fund / 1000000

    modelPlayerManager:forEachModelPlayer(function(modelPlayer, index)
        if ((modelPlayer:isAlive()) and (index ~= playerIndex)) then
            local _, req1, req2 = modelPlayer:getEnergy()
            if (req2) then
                local maxDamageCost = round(req2 * modelPlayer:getCurrentDamageCostPerEnergyRequirement())
                modelPlayer:setDamageCost(math.max(
                    0,
                    math.min(
                        round(modelPlayer:getDamageCost() + maxDamageCost * modifier),
                        maxDamageCost
                    )
                ))
            end
        end
    end)
end

s_Executors.execute16 = function(modelSceneWar, level)
    local playerIndex = modelSceneWar:getModelTurnManager():getPlayerIndex()
    local func        = function(modelUnit)
        if (modelUnit:getPlayerIndex() == playerIndex) then
            SupplyFunctions.supplyWithAmmoAndFuel(modelUnit)
            if (modelUnit.setCurrentMaterial) then
                modelUnit:setCurrentMaterial(modelUnit:getMaxMaterial())
            end
        end
    end

    modelSceneWar:getModelWarField():getModelUnitMap():forEachModelUnitOnMap(func)
        :forEachModelUnitLoaded(func)

    modelSceneWar:getScriptEventDispatcher():dispatchEvent({name = "EvtModelUnitMapUpdated"})
end

s_Executors.execute26 = function(modelSceneWar, level)
    local playerIndex  = modelSceneWar:getModelTurnManager():getPlayerIndex()
    local modifier     = getSkillModifier(26, level, true)
    local maxPromotion = GameConstantFunctions.getMaxPromotion()
    local func         = function(modelUnit)
        if ((modelUnit:getPlayerIndex() == playerIndex) and
            (modelUnit.getCurrentPromotion))            then
            modelUnit:setCurrentPromotion(math.min(maxPromotion, modelUnit:getCurrentPromotion() + modifier))
        end
    end

    modelSceneWar:getModelWarField():getModelUnitMap():forEachModelUnitOnMap(func)
        :forEachModelUnitLoaded(func)

    modelSceneWar:getScriptEventDispatcher():dispatchEvent({name = "EvtModelUnitMapUpdated"})
end

s_Executors.execute55 = function(modelSceneWar, level)
    local playerIndex = modelSceneWar:getModelTurnManager():getPlayerIndex()
    if ((IS_SERVER) or (modelSceneWar:isTotalReplay()) or (playerIndex == getPlayerIndexLoggedIn(modelSceneWar))) then
        modelSceneWar:getModelWarField():getModelFogMap():resetMapForUnitsForPlayerIndex(playerIndex)
    end
end

s_Executors.execute56 = function(modelSceneWar, level)
    local playerIndex = modelSceneWar:getModelTurnManager():getPlayerIndex()
    if ((IS_SERVER) or (modelSceneWar:isTotalReplay()) or (playerIndex == getPlayerIndexLoggedIn(modelSceneWar))) then
        modelSceneWar:getModelWarField():getModelFogMap():resetMapForTilesForPlayerIndex(playerIndex)
    end
end

s_Executors.execute57 = function(modelSceneWar, level)
    local playerIndex = modelSceneWar:getModelTurnManager():getPlayerIndex()
    if ((IS_SERVER) or (modelSceneWar:isTotalReplay()) or (playerIndex == getPlayerIndexLoggedIn(modelSceneWar))) then
        modelSceneWar:getModelWarField():getModelFogMap():resetMapForTilesForPlayerIndex(playerIndex)
            :resetMapForUnitsForPlayerIndex(playerIndex)
    end
end

s_Executors.execute61 = function(modelSceneWar, level)
    local modelPlayer         = modelSceneWar:getModelPlayerManager():getModelPlayer(modelSceneWar:getModelTurnManager():getPlayerIndex())
    local _, req1, req2       = modelPlayer:getEnergy()
    local damageCostPerEnergy = modelPlayer:getCurrentDamageCostPerEnergyRequirement()
    local maxDamageCost       = round(req2 * damageCostPerEnergy)
    modelPlayer:setDamageCost(math.max(
        0,
        math.min(
            round(modelPlayer:getDamageCost() + round(damageCostPerEnergy * getSkillModifier(61, level, true))),
            maxDamageCost
        )
    ))
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function InstantSkillExecutor.activateSkillGroup(modelSceneWar, skillGroupID)
    local modelSkillConfiguration = modelSceneWar:getModelPlayerManager():getModelPlayer(modelSceneWar:getModelTurnManager():getPlayerIndex()):getModelSkillConfiguration()
    for _, skill in pairs(modelSkillConfiguration:getAllSkillsInGroup(skillGroupID)) do
        local id, level  = skill.id, skill.level
        local methodName = "execute" .. id
        if (s_Executors[methodName]) then
            s_Executors[methodName](modelSceneWar, skill.level)
        end
    end

    return InstantSkillExecutor
end

return InstantSkillExecutor
