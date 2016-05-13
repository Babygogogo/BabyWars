
--[[--------------------------------------------------------------------------------
-- ActionTranslator是用于“翻译”玩家原始操作的辅助函数集合。
-- 主要职责：
--   翻译原始操作，也就是检查操作的合法性，并返回各model可响应的操作
--   如果发现操作不合法（原因可能是不同步，或者是客户端进行了非法修改），那么返回合适的值使得客户端重新载入战局（服务端不做任何更改）
-- 使用场景举例：
--   - 移动单位：在雾战中，玩家指定的移动路线可能被视野外的敌方单位阻挡。客户端把玩家指定的原始路线上传到服务器，
--     服务器使用本文件里的函数判断是否存在阻挡情况。如果存在，则返回截断的路径，并取消掉后续的原始操作（如移动后的攻击/占领/合流等），否则就正常移动
--   - 发起攻击：由于最终伤害涉及幸运伤害，所以最终伤害值必须由服务端计算，并返回计算结果给客户端
--     不必返回单位是否被摧毁的信息，因为客户端可以通过伤害值自行获取这一隐含的战斗结果
--   - 生产单位：生产单位需要消耗金钱，因此本文件里的函数需要判断玩家金钱是否足够，如发现不够则要求客户端重新载入战局，否则就正常生产
-- 其他：
--   - 本游戏架构中，在联机模式下，战局的所有信息都存放在服务器上，一切操作的合法与否都由服务器判断。客户端仅负责从服务器上获取信息并加以呈现
--   - 目前仅做了明战的部分实现
--   - 在雾战下，为避免作弊，客户端应当只能获取其应当获取的信息（如视野内的单位信息），这就要求本文件里的函数做出合适实现（比如，
--     某些操作会使得视野变化，此时服务器就应当返回新视野内的所有单位的信息）
--]]--------------------------------------------------------------------------------

local ActionTranslator = {}

local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getCurrentPlayerAccount(playerManagerModel, turnManagerModel)
    return playerManagerModel:getModelPlayer(turnManagerModel:getPlayerIndex()):getAccount()
end

local function getPlayerAccountForModelUnit(modelUnit, modelPlayerManager)
    return modelPlayerManager:getModelPlayer(modelUnit:getPlayerIndex()):getAccount()
end

local function isModelUnitVisible(modelUnit, modelWeatherManager)
    -- TODO: add code to do the real job.
    return true
end

--------------------------------------------------------------------------------
-- The translate functions.
--------------------------------------------------------------------------------
-- This translation ignores the existing unit of the same player at the end of the path, so that the actions of Join/Attack/Wait can reuse this function.
local function translatePath(path, modelUnitMap, modelTileMap, modelWeatherManager, modelPlayerManager, currentPlayerAccount, modelPlayer)
    local modelFocusUnit = modelUnitMap:getModelUnit(path[1].gridIndex)
    if (not modelFocusUnit) then
        return nil, "ActionTranslator-translatePath() there is no unit on the starting grid of the path."
    elseif (getPlayerAccountForModelUnit(modelFocusUnit, modelPlayerManager) ~= currentPlayerAccount) then
        return nil, "ActionTranslator-translatePath() the player account of the moving unit is not the same as the one of the in-turn player."
    elseif (modelFocusUnit:getState() ~= "idle") then
        return nil, "ActionTranslator-translatePath() the moving unit is not in idle state."
    end

    local moveType             = modelFocusUnit:getMoveType()
    local modelWeather         = modelWeatherManager:getCurrentWeather()
    local totalFuelConsumption = 0
    local translatedPath       = {GridIndexFunctions.clone(path[1].gridIndex), length = 1}

    for i = 2, #path do
        local gridIndex = GridIndexFunctions.clone(path[i].gridIndex)
        if (not GridIndexFunctions.isAdjacent(path[i - 1].gridIndex, gridIndex)) then
            return nil, "ActionTranslator-translatePath() the path is invalid because some grids are not adjacent to previous ones."
        end

        local existingModelUnit = modelUnitMap:getModelUnit(gridIndex)
        if (existingModelUnit) and (getPlayerAccountForModelUnit(existingModelUnit, modelPlayerManager) ~= currentPlayerAccount) then
            if (isModelUnitVisible(existingModelUnit, modelWeatherManager)) then
                return nil, "ActionTranslator-translatePath() the path is invalid because it is blocked by a visible enemy unit."
            else
                translatedPath.isBlocked = true
                break
            end
        end

        local fuelConsumption = modelTileMap:getModelTile(path[i].gridIndex):getMoveCost(moveType)
        if (not fuelConsumption) then
            return nil, "ActionTranslator-translatedPath() the path is invalid because some tiles on it is impassable."
        end

        totalFuelConsumption = totalFuelConsumption + fuelConsumption
        translatedPath.length = translatedPath.length + 1
        translatedPath[translatedPath.length] = gridIndex
    end

    if ((totalFuelConsumption > modelFocusUnit:getCurrentFuel()) or
        (totalFuelConsumption > modelFocusUnit:getMoveRange(modelPlayer, modelWeather))) then
        return nil, "ActionTranslator-translatedPath() the path is invalid because the fuel consumption is too high."
    else
        translatedPath.fuelConsumption = totalFuelConsumption
        return translatedPath
    end
end

local function translateEndTurn(action, modelScene)
    local playerManagerModel = modelScene:getModelPlayerManager()
    local turnManagerModel   = modelScene:getModelTurnManager()

    if (turnManagerModel:getTurnPhase() ~= "main") then
        return nil, "ActionTranslator-translateEndTurn() the current turn phase is expected to be 'main'."
    end

    return {actionName = "EndTurn", nextWeather = modelScene:getModelWeatherManager():getNextWeather()}
end

local function translateWait(action, modelScene, currentPlayerAccount)
    local modelWarField       = modelScene:getModelWarField()
    local modelUnitMap        = modelWarField:getModelUnitMap()
    local modelTileMap        = modelWarField:getModelTileMap()
    local modelPlayerManager  = modelScene:getModelPlayerManager()
    local modelWeatherManager = modelScene:getModelWeatherManager()
    local modelPlayer         = modelPlayerManager:getModelPlayer(modelScene:getModelTurnManager():getPlayerIndex())

    local translatedPath, translateMsg = translatePath(action.path, modelUnitMap, modelTileMap, modelWeatherManager, modelPlayerManager, currentPlayerAccount, modelPlayer)
    if (not translatedPath) then
        return nil, "ActionTranslator-translateWait() failed to translate the move path:\n" .. (translateMsg or "")
    end

    local existingModelUnit = modelUnitMap:getModelUnit(translatedPath[translatedPath.length])
    if (existingModelUnit) and (modelUnitMap:getModelUnit(translatedPath[1]) ~= existingModelUnit) then
        return nil, "ActionTranslator-translateWait() failed because there is another unit on the destination grid."
    else
        return {actionName = "Wait", path = translatedPath}
    end
end

local function translateAttack(action, modelScene, currentPlayerAccount)
    local modelWarField       = modelScene:getModelWarField()
    local modelUnitMap        = modelWarField:getModelUnitMap()
    local modelTileMap        = modelWarField:getModelTileMap()
    local modelPlayerManager  = modelScene:getModelPlayerManager()
    local modelWeatherManager = modelScene:getModelWeatherManager()
    local modelPlayer         = modelPlayerManager:getModelPlayer(modelScene:getModelTurnManager():getPlayerIndex())

    local translatedPath, translateMsg = translatePath(action.path, modelUnitMap, modelTileMap, modelWeatherManager, modelPlayerManager, currentPlayerAccount, modelPlayer)
    if (not translatedPath) then
        return nil, "ActionTranslator-translateAttack() failed to translate the move path:\n" .. (translateMsg or "")
    end

    if (translatedPath.isBlocked) then
        return {actionName = "Wait", path = translatedPath}
    end

    local attackerGridIndex = translatedPath[#translatedPath]
    local targetGridIndex   = action.targetGridIndex
    local attacker          = modelUnitMap:getModelUnit(translatedPath[1])
    local target            = modelUnitMap:getModelUnit(action.targetGridIndex) or modelTileMap:getModelTile(action.targetGridIndex)

    local existingModelUnit = modelUnitMap:getModelUnit(attackerGridIndex)
    if (existingModelUnit) and (attacker ~= existingModelUnit) then
        return nil, "ActionTranslator-translateAttack() failed because there is another unit on the destination grid."
    end
    if ((not attacker.canAttackTarget) or
        (not attacker:canAttackTarget(attackerGridIndex, target, targetGridIndex))) then
        return nil, "ActionTranslator-translateAttack() failed because the attacker can't attack the target."
    end

    local attackDamage, counterDamage = attacker:getUltimateBattleDamage(modelTileMap:getModelTile(attackerGridIndex), target, modelTileMap:getModelTile(targetGridIndex), modelPlayerManager, modelWeatherManager:getCurrentWeather())
    return {actionName = "Attack", path = translatedPath, targetGridIndex = GridIndexFunctions.clone(targetGridIndex), attackDamage = attackDamage, counterDamage = counterDamage}
end

local function translateCapture(action, modelScene, currentPlayerAccount)
    local modelWarField       = modelScene:getModelWarField()
    local modelUnitMap        = modelWarField:getModelUnitMap()
    local modelTileMap        = modelWarField:getModelTileMap()
    local modelPlayerManager  = modelScene:getModelPlayerManager()
    local modelWeatherManager = modelScene:getModelWeatherManager()
    local modelPlayer         = modelPlayerManager:getModelPlayer(modelScene:getModelTurnManager():getPlayerIndex())

    local translatedPath, translateMsg = translatePath(action.path, modelUnitMap, modelTileMap, modelWeatherManager, modelPlayerManager, currentPlayerAccount, modelPlayer)
    if (not translatedPath) then
        return nil, "ActionTranslator-translateAttack() failed to translate the move path:\n" .. (translateMsg or "")
    end
    if (translatedPath.isBlocked) then
        return {actionName = "Wait", path = translatedPath}
    end

    local destination = translatedPath[#translatedPath]
    local capturer          = modelUnitMap:getModelUnit(translatedPath[1])
    local existingModelUnit = modelUnitMap:getModelUnit(destination)
    if ((existingModelUnit) and (existingModelUnit ~= capturer)) then
        return nil, "ActionTranslator-translateCapture() failed because there's another unit on the destination grid."
    end
    if ((not capturer.canCapture) or (not capturer:canCapture(modelTileMap:getModelTile(destination)))) then
        return nil, "ActionTranslator-translateCapture() failed because the focus unit can't capture the target tile."
    end

    return {actionName = "Capture", path = translatedPath}
end

local function translateProduceOnTile(action, modelScene)
    local playerIndex   = modelScene:getModelTurnManager():getPlayerIndex()
    local modelPlayer   = modelScene:getModelPlayerManager():getModelPlayer(playerIndex)
    local modelWarField = modelScene:getModelWarField()
    local gridIndex     = action.gridIndex
    local tiledID       = action.tiledID

    if (modelWarField:getModelUnitMap():getModelUnit(gridIndex)) then
        return nil, "ActionTranslator-translateProduceOnTile() failed because there's a unit on the tile."
    end

    local modelTile = modelWarField:getModelTileMap():getModelTile(action.gridIndex)
    if (not modelTile.getProductionCostWithTiledId) then
        return nil, "ActionTranslator-translateProduceOnTile() failed because the tile can't produce units."
    end

    local cost = modelTile:getProductionCostWithTiledId(tiledID, modelPlayer)
    if ((not cost) or (cost > modelPlayer:getFund())) then
        return nil, "ActionTranslator-translateProduceOnTile() failed because the player has not enough fund."
    end

    return {actionName = "ProduceOnTile", gridIndex = GridIndexFunctions.clone(gridIndex), tiledID = tiledID, cost = cost}
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ActionTranslator.translate(action, modelScene)
    local currentPlayerAccount = getCurrentPlayerAccount(modelScene:getModelPlayerManager(), modelScene:getModelTurnManager())
    if (currentPlayerAccount ~= action.playerAccount) then
        return nil, "ActionTranslator.translate() the account of the actioning player is not the same as the one of the in-turn player."
    end

    local actionName = action.actionName
    if (actionName == "EndTurn") then
        return translateEndTurn(action, modelScene)
    elseif (actionName == "Wait") then
        return translateWait(   action, modelScene, currentPlayerAccount)
    elseif (actionName == "Attack") then
        return translateAttack( action, modelScene, currentPlayerAccount)
    elseif (actionName == "Capture") then
        return translateCapture(action, modelScene, currentPlayerAccount)
    elseif (actionName == "ProduceOnTile") then
        return translateProduceOnTile(action, modelScene, currentPlayerAccount)
    else
        return nil, "ActionTranslator.translate() unrecognized action name."
    end
end

return ActionTranslator
