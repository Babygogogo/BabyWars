
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

local DamageCalculator       = require("src.app.utilities.DamageCalculator")
local GridIndexFunctions     = require("src.app.utilities.GridIndexFunctions")
local ReachableAreaFunctions = require("src.app.utilities.ReachableAreaFunctions")
local ActorManager           = require("src.global.actors.ActorManager")

local isWithinMap            = GridIndexFunctions.isWithinMap

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function updateAttackableArea(area, mapSize, originX, originY, minRange, maxRange)
    local width, height = mapSize.width, mapSize.height
    for rotated = 1, 2 do
        for sign = -1, 1, 2 do
            for offset1 = 0, maxRange - 1 do
                for offset2 = math.max(1, minRange - offset1), maxRange - offset1 do
                    local x = originX + sign * ((rotated == 1) and (offset1) or (offset2))
                    local y = originY + sign * ((rotated == 1) and (offset2) or (-offset1))
                    if ((x >= 1) and (x <= width) and (y >= 1) and (y <= height)) then
                        area[x] = area[x] or {}
                        area[x][y] = true
                    end
                end
            end
        end
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

function AttackableGridListFunctions.createList(pathNodes, launchUnitID)
    local modelSceneWar = ActorManager.getRootActor():getModel()
    local modelWarField = modelSceneWar:getModelWarField()
    local modelUnitMap  = modelWarField:getModelUnitMap()
    local attacker      = modelUnitMap:getFocusModelUnit(pathNodes[1], launchUnitID)
    if ((not attacker.canAttackAfterMove)                          or
        ((not attacker:canAttackAfterMove()) and (#pathNodes > 1))) then
        return {}
    end

    local modelTileMap       = modelWarField:getModelTileMap()
    local mapSize            = modelTileMap:getMapSize()
    local minRange, maxRange = attacker:getAttackRangeMinMax()
    return GridIndexFunctions.getGridsWithinDistance(
        pathNodes[#pathNodes],
        minRange,
        maxRange,
        mapSize,
        function(targetGridIndex)
            targetGridIndex.estimatedAttackDamage, targetGridIndex.estimatedCounterDamage =
                DamageCalculator.getEstimatedBattleDamage(pathNodes, launchUnitID, targetGridIndex, modelSceneWar)

            return targetGridIndex.estimatedAttackDamage ~= nil
        end
    )
end

function AttackableGridListFunctions.createAttackableArea(attackerGridIndex, modelTileMap, modelUnitMap, existingArea)
    local attacker            = modelUnitMap:getModelUnit(attackerGridIndex)
    local attackerPlayerIndex = attacker:getPlayerIndex()
    local mapSize             = modelTileMap:getMapSize()
    local minRange, maxRange  = attacker:getAttackRangeMinMax()
    existingArea              = existingArea or {}

    if (not attacker:canAttackAfterMove()) then
        updateAttackableArea(existingArea, mapSize, attackerGridIndex.x, attackerGridIndex.y, minRange, maxRange)
        return existingArea
    else
        local reachableArea = ReachableAreaFunctions.createArea(
            attackerGridIndex,
            math.min(attacker:getMoveRange(), attacker:getCurrentFuel()),
            function(gridIndex)
                if (not isWithinMap(gridIndex, mapSize)) then
                    return nil
                else
                    local existingModelUnit = modelUnitMap:getModelUnit(gridIndex)
                    if ((existingModelUnit)                                          and
                        (existingModelUnit:getPlayerIndex() ~= attackerPlayerIndex)) then
                        return nil
                    else
                        return modelTileMap:getModelTile(gridIndex):getMoveCostWithModelUnit(attacker)
                    end
                end
            end
        )
        local originX, originY = attackerGridIndex.x, attackerGridIndex.y
        for x, column in pairs(reachableArea) do
            if (type(column) == "table") then
                for y, _ in pairs(column) do
                    updateAttackableArea(existingArea, mapSize, x, y, minRange, maxRange)
                end
            end
        end

        return existingArea
    end
end

return AttackableGridListFunctions
