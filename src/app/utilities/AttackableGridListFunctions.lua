
local AttackableGridListFunctions = {}

local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

local function canAttackTargetOnGridIndex(attacker, destination, targetGridIndex, modelTileMap, modelUnitMap)
    if (not GridIndexFunctions.isWithinMap(targetGridIndex, modelTileMap:getMapSize())) then
        return false
    end

    local canAttack, baseDoDamage, baseGetDamage = attacker:canAttackTarget(destination, modelTileMap:getModelTile(targetGridIndex), targetGridIndex)
    if (canAttack) then
        return canAttack, baseDoDamage, baseGetDamage
    else
        return attacker:canAttackTarget(destination, modelUnitMap:getModelUnit(targetGridIndex), targetGridIndex)
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

function AttackableGridListFunctions.createList(attacker, destination, modelTileMap, modelUnitMap)
    if ((not attacker.canAttackTarget) or
       ((not attacker:canAttackAfterMove()) and (not GridIndexFunctions.isEqual(attacker:getGridIndex(), destination)))) then
        return {}
    end

    local minRange, maxRange = attacker:getAttackRangeMinMax()
    return GridIndexFunctions.getGridsWithinDistance(destination, minRange, maxRange, function(targetGridIndex)
        local canAttack, baseDoDamage, baseGetDamage = canAttackTargetOnGridIndex(attacker, destination, targetGridIndex, modelTileMap, modelUnitMap)
        if (canAttack) then
            targetGridIndex.baseDoDamage  = baseDoDamage
            targetGridIndex.baseGetDamage = baseGetDamage
        end
        return canAttack
    end)
end

return AttackableGridListFunctions
