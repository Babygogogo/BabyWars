
local SingletonGetters = {}

local IS_SERVER       = require("src.app.utilities.GameConstantFunctions").isServer()
local SceneWarManager = (    IS_SERVER) and (require("src.app.utilities.SceneWarManager")) or (nil)
local ActorManager    = (not IS_SERVER) and (require("src.global.actors.ActorManager"))    or (nil)

function SingletonGetters.getModelSceneWar(sceneWarFileName)
    return (ActorManager)                                           and
        (ActorManager.getRootActor():getModel())                    or
        (SceneWarManager.getOngoingModelSceneWar(sceneWarFileName))
end

function SingletonGetters.getSceneWarFileName()
    return SingletonGetters.getModelSceneWar():getFileName()
end

function SingletonGetters.getActionId(sceneWarFileName)
    return SingletonGetters.getModelSceneWar(sceneWarFileName):getActionId()
end

function SingletonGetters.getModelConfirmBox(sceneWarFileName)
    return SingletonGetters.getModelSceneWar(sceneWarFileName):getModelConfirmBox()
end

function SingletonGetters.getModelMessageIndicator(sceneWarFileName)
    return SingletonGetters.getModelSceneWar(sceneWarFileName):getModelMessageIndicator()
end

function SingletonGetters.getModelPlayerManager(sceneWarFileName)
    return SingletonGetters.getModelSceneWar(sceneWarFileName):getModelPlayerManager()
end

function SingletonGetters.getModelTurnManager(sceneWarFileName)
    return SingletonGetters.getModelSceneWar(sceneWarFileName):getModelTurnManager()
end

function SingletonGetters.getModelWarField(sceneWarFileName)
    return SingletonGetters.getModelSceneWar(sceneWarFileName):getModelWarField()
end

function SingletonGetters.getScriptEventDispatcher(sceneWarFileName)
    return SingletonGetters.getModelSceneWar(sceneWarFileName):getScriptEventDispatcher()
end

function SingletonGetters.getModelTileMap(sceneWarFileName)
    return SingletonGetters.getModelWarField(sceneWarFileName):getModelTileMap()
end

function SingletonGetters.getModelUnitMap(sceneWarFileName)
    return SingletonGetters.getModelWarField(sceneWarFileName):getModelUnitMap()
end

return SingletonGetters
