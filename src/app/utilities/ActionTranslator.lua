
local ActionTranslator = {}

local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getCurrentPlayerID(playerManagerModel, turnManagerModel)
    return playerManagerModel:getModelPlayer(turnManagerModel:getPlayerIndex()):getID()
end

local function getPlayerIDForModelUnit(modelUnit, modelPlayerManager)
    return modelPlayerManager:getModelPlayer(modelUnit:getPlayerIndex()):getID()
end

local function isModelUnitVisible(modelUnit, modelWeatherManager)
    -- TODO: add code to do the real job.
    return true
end

--------------------------------------------------------------------------------
-- The translate functions.
--------------------------------------------------------------------------------
-- This translation ignores the existing unit of the same player at the end of the path, so that the actions of Join/Attack/Wait can reuse this function.
local function translatePath(path, modelUnitMap, modelTileMap, modelWeatherManager, modelPlayerManager, currentPlayerID)
    local modelFocusUnit = modelUnitMap:getModelUnit(path[1].gridIndex)
    if (not modelFocusUnit) then
        return nil, "ActionTranslator-translatePath() there is no unit on the starting grid of the path."
    elseif (getPlayerIDForModelUnit(modelFocusUnit, modelPlayerManager) ~= currentPlayerID) then
        return nil, "ActionTranslator-translatePath() the player ID of the moving unit is not the same as the one of the in-turn player."
    elseif (modelFocusUnit:getState() ~= "idle") then
        return nil, "ActionTranslator-translatePath() the moving unit is not in idle state."
    end

    local moveType             = modelFocusUnit:getMoveType()
    local weather              = modelWeatherManager:getCurrentWeather()
    local totalFuelConsumption = 0
    local translatedPath       = {GridIndexFunctions.clone(path[1].gridIndex), length = 1}

    for i = 2, #path do
        local gridIndex = GridIndexFunctions.clone(path[i].gridIndex)
        if (not GridIndexFunctions.isAdjacent(path[i - 1].gridIndex, gridIndex)) then
            return nil, "ActionTranslator-translatePath() the path is invalid because some grids are not adjacent to previous ones."
        end

        local existingModelUnit = modelUnitMap:getModelUnit(gridIndex)
        if (existingModelUnit) and (getPlayerIDForModelUnit(existingModelUnit, modelPlayerManager) ~= currentPlayerID) then
            if (isModelUnitVisible(existingModelUnit, modelWeatherManager)) then
                return nil, "ActionTranslator-translatePath() the path is invalid because it is blocked by a visible enemy unit."
            else
                translatedPath.isBlocked = true
                break
            end
        end

        local fuelConsumption = modelTileMap:getModelTile(path[i].gridIndex):getMoveCost(moveType, weather)
        if (not fuelConsumption) then
            return nil, "ActionTranslator-translatedPath() the path is invalid because some tiles on it is impassable."
        end

        totalFuelConsumption = totalFuelConsumption + fuelConsumption
        translatedPath.length = translatedPath.length + 1
        translatedPath[translatedPath.length] = gridIndex
    end

    if (totalFuelConsumption > modelFocusUnit:getCurrentFuel()) or (totalFuelConsumption > modelFocusUnit:getMoveRange()) then
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

local function translateWait(action, modelScene, currentPlayerID)
    local modelWarField       = modelScene:getModelWarField()
    local modelUnitMap        = modelWarField:getModelUnitMap()
    local modelTileMap        = modelWarField:getModelTileMap()
    local modelPlayerManager  = modelScene:getModelPlayerManager()
    local modelWeatherManager = modelScene:getModelWeatherManager()

    local translatedPath, translateMsg = translatePath(action.path, modelUnitMap, modelTileMap, modelWeatherManager, modelPlayerManager, currentPlayerID)
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

local function translateAttack(action, modelScene, currentPlayerID)
    local modelWarField       = modelScene:getModelWarField()
    local modelUnitMap        = modelWarField:getModelUnitMap()
    local modelTileMap        = modelWarField:getModelTileMap()
    local modelPlayerManager  = modelScene:getModelPlayerManager()
    local modelWeatherManager = modelScene:getModelWeatherManager()

    local translatedPath, translateMsg = translatePath(action.path, modelUnitMap, modelTileMap, modelWeatherManager, modelPlayerManager, currentPlayerID)
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

local function translateCapture(action, modelScene, currentPlayerID)
    local modelWarField       = modelScene:getModelWarField()
    local modelUnitMap        = modelWarField:getModelUnitMap()
    local modelTileMap        = modelWarField:getModelTileMap()
    local modelPlayerManager  = modelScene:getModelPlayerManager()
    local modelWeatherManager = modelScene:getModelWeatherManager()

    local translatedPath, translateMsg = translatePath(action.path, modelUnitMap, modelTileMap, modelWeatherManager, modelPlayerManager, currentPlayerID)
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
    local currentPlayerID = getCurrentPlayerID(modelScene:getModelPlayerManager(), modelScene:getModelTurnManager())
    if (currentPlayerID ~= action.playerID) then
        return nil, "ActionTranslator.translate() the ID of the actioning player is not the same as the one of the in-turn player."
    end

    local actionName = action.actionName
    if (actionName == "EndTurn") then
        return translateEndTurn(action, modelScene)
    elseif (actionName == "Wait") then
        return translateWait(   action, modelScene, currentPlayerID)
    elseif (actionName == "Attack") then
        return translateAttack( action, modelScene, currentPlayerID)
    elseif (actionName == "Capture") then
        return translateCapture(action, modelScene, currentPlayerID)
    elseif (actionName == "ProduceOnTile") then
        return translateProduceOnTile(action, modelScene, currentPlayerID)
    else
        return nil, "ActionTranslator.translate() unrecognized action name."
    end
end

return ActionTranslator
