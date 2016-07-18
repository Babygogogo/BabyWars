
--[[--------------------------------------------------------------------------------
-- AttackableGridListFunctions是和“可攻击的格子的列表”相关的函数集合。
-- 所谓可攻击格子列表，其内容物是某unit可以攻击到的格子的坐标、预计的伤害和反击伤害等。在视觉上就是点击Attack指令后，画面上泛红的格子。
-- 主要职责：
--   计算及访问上述列表
-- 使用场景举例：
--   玩家操作单位，点击Attack指令后，需要调用本文件函数来计算可攻击格子以及预估伤害
-- 其他：
--   格子上能够被攻击的对象可能是unit或tile，计算时需要考虑在内。
--   这些函数原本都是在ModelActionPlanner内的，由于planner日益臃肿，因此独立出来。
--]]--------------------------------------------------------------------------------

local AttackableGridListFunctions = {}

local GridIndexFunctions = require("src.app.utilities.GridIndexFunctions")

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
