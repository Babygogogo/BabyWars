
local AttackableGridListFunctions = {}

local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

local function canAttackTargetOnGridIndex(attacker, attackerGridIndex, targetGridIndex, modelTileMap, modelUnitMap)
    if (not GridIndexFunctions.isWithinMap(targetGridIndex, modelTileMap:getMapSize())) then
        return false
    end

    if (attacker:canAttackTarget(attackerGridIndex, modelUnitMap:getModelUnit(targetGridIndex), targetGridIndex)) then
        return true
    else
        return attacker:canAttackTarget(attackerGridIndex, modelTileMap:getModelTile(targetGridIndex), targetGridIndex)
    end
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function AttackableGridListFunctions.getListNode(list, gridIndex)
    for i = 1, #list do
        if (GridIndexFunctions.isEqual(list[i], gridIndex)) then
            return list[i]
        end
    end

    return nil
end

function AttackableGridListFunctions.createList(attacker, attackerGridIndex, modelTileMap, modelUnitMap)
    if ((not attacker.canAttackTarget) or
       ((not attacker:canAttackAfterMove()) and (not GridIndexFunctions.isEqual(attacker:getGridIndex(), attackerGridIndex)))) then
        return {}
    end

    local minRange, maxRange = attacker:getAttackRangeMinMax()
    local attackerTile = modelTileMap:getModelTile(attackerGridIndex)
    return GridIndexFunctions.getGridsWithinDistance(attackerGridIndex, minRange, maxRange, function(targetGridIndex)
        if (not canAttackTargetOnGridIndex(attacker, attackerGridIndex, targetGridIndex, modelTileMap, modelUnitMap)) then
            return false
        else
            local targetTile = modelTileMap:getModelTile(targetGridIndex)
            local target = modelUnitMap:getModelUnit(targetGridIndex) or targetTile
            targetGridIndex.estimatedAttackDamage, targetGridIndex.estimatedCounterDamage = attacker:getEstimatedBattleDamage(attackerTile, target, targetTile, modelPlayerManager, weather)

            return true
        end
    end)
end

return AttackableGridListFunctions
