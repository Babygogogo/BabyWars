
--[[--------------------------------------------------------------------------------
-- ModelPlayerManager是战局上的玩家管理器，负责维护玩家列表及在适当时候更新玩家数据。
--
-- 主要职责
--   同上
--
-- 其他：
--  - 本类目前没有对应的view，因为暂时还不用显示。
--]]--------------------------------------------------------------------------------

local ModelPlayerManager = require("src.global.functions.class")("ModelPlayerManager")

local ModelPlayer      = require("src.app.models.sceneWar.ModelPlayer")
local SingletonGetters = require("src.app.utilities.SingletonGetters")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getRepairAmountAndCostForModelUnit(modelUnit, modelUnitMap, modelTileMap)
    local gridIndex = modelUnit:getGridIndex()
    if (modelUnitMap:getLoadedModelUnitWithUnitId(modelUnit:getUnitId())) then
        return modelUnitMap:getModelUnit(gridIndex):getRepairAmountAndCostForLoadedModelUnit(modelUnit)
    else
        return modelTileMap:getModelTile(gridIndex):getRepairAmountAndCost(modelUnit)
    end
end

local function dispatchEvtModelPlayerUpdated(sceneWarFileName, modelPlayer, playerIndex)
    SingletonGetters.getScriptEventDispatcher(sceneWarFileName):dispatchEvent({
        name        = "EvtModelPlayerUpdated",
        modelPlayer = modelPlayer,
        playerIndex = playerIndex,
    })
end

local function dispatchEvtSkillGroupActivated(sceneWarFileName, playerIndex, skillGroupID)
    SingletonGetters.getScriptEventDispatcher(sceneWarFileName):dispatchEvent({
        name         = "EvtSkillGroupActivated",
        playerIndex  = playerIndex,
        skillGroupID = skillGroupID,
    })
end

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtSceneWarStarted(self, event)
    self:forEachModelPlayer(function(modelPlayer, playerIndex)
        if (modelPlayer:isAlive()) then
            local activatingSkillGroupID = modelPlayer:getModelSkillConfiguration():getActivatingSkillGroupId()
            if (activatingSkillGroupID) then
                dispatchEvtSkillGroupActivated(self.m_SceneWarFileName, playerIndex, activatingSkillGroupID)
            end
        end
    end)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelPlayerManager:ctor(param)
    self.m_ModelPlayers = {}
    for i, player in ipairs(param) do
        self.m_ModelPlayers[i] = ModelPlayer:create(player)
    end

    return self
end

--------------------------------------------------------------------------------
-- The functions for serialization.
--------------------------------------------------------------------------------
function ModelPlayerManager:toSerializableTable()
    local t = {}
    self:forEachModelPlayer(function(modelPlayer, playerIndex)
        t[playerIndex] = modelPlayer:toSerializableTable()
    end)

    return t
end

--------------------------------------------------------------------------------
-- The callback functions on start running/script events.
--------------------------------------------------------------------------------
function ModelPlayerManager:onStartRunning(sceneWarFileName)
    self.m_SceneWarFileName = sceneWarFileName

    SingletonGetters.getScriptEventDispatcher(sceneWarFileName)
        :addEventListener("EvtSceneWarStarted",     self)

    return self
end

function ModelPlayerManager:onEvent(event)
    local eventName = event.name
    if (eventName == "EvtSceneWarStarted") then
        onEvtSceneWarStarted(self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelPlayerManager:getModelPlayer(playerIndex)
    return self.m_ModelPlayers[playerIndex]
end

function ModelPlayerManager:getPlayersCount()
    return #self.m_ModelPlayers
end

function ModelPlayerManager:getAlivePlayersCount()
    local count = 0
    for _, modelPlayer in ipairs(self.m_ModelPlayers) do
        if (modelPlayer:isAlive()) then
            count = count + 1
        end
    end

    return count
end

function ModelPlayerManager:getModelPlayerWithAccount(account)
    for playerIndex, modelPlayer in ipairs(self.m_ModelPlayers) do
        if (modelPlayer:getAccount() == account) then
            return modelPlayer, playerIndex
        end
    end

    return nil, nil
end

function ModelPlayerManager:forEachModelPlayer(func)
    for playerIndex, modelPlayer in ipairs(self.m_ModelPlayers) do
        func(modelPlayer, playerIndex)
    end

    return self
end

return ModelPlayerManager
