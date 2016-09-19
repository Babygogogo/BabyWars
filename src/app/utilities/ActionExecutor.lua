
local ActionExecutor = {}

local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")
local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")
local SingletonGetters      = require("src.app.utilities.SingletonGetters")
local Actor                 = require("src.global.actors.Actor")

local IS_SERVER             = GameConstantFunctions.isServer()
local WebSocketManager      = (IS_SERVER) and (nil) or (require("src.app.utilities.WebSocketManager"))
local ActorManager          = (IS_SERVER) and (nil) or (require("src.global.actors.ActorManager"))

local getLocalizedText         = LocalizationFunctions.getLocalizedText
local getModelMessageIndicator = SingletonGetters.getModelMessageIndicator
local getSceneWarFileName      = SingletonGetters.getSceneWarFileName
local getScriptEventDispatcher = SingletonGetters.getScriptEventDispatcher

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function runSceneMain(modelSceneMainParam, playerAccount, playerPassword)
    assert(not IS_SERVER, "ActionExecutor-runSceneMain() the main scene can't be run on the server.")

    local modelSceneMain = Actor.createModel("sceneMain.ModelSceneMain", modelSceneMainParam)
    local viewSceneMain  = Actor.createView( "sceneMain.ViewSceneMain")

    WebSocketManager.setLoggedInAccountAndPassword(playerAccount, playerPassword)
    ActorManager.setAndRunRootActor(Actor.createWithModelAndViewInstance(modelSceneMain, viewSceneMain), "FADE", 1)
end

local function requestReloadSceneWar(action, durationSec)
    assert(not IS_SERVER, "ActionExecutor-requestReloadSceneWar() the server shouldn't request reload.")

    getModelMessageIndicator():showMessage(action.message or "")
        :showPersistentMessage(getLocalizedText(80, "TransferingData"))
    getScriptEventDispatcher():dispatchEvent({
        name    = "EvtIsWaitingForServerResponse",
        waiting = true,
    })

    WebSocketManager.sendAction({
        actionName = "GetSceneWarData",
        fileName   = getSceneWarFileName(),
    })
end

--------------------------------------------------------------------------------
-- The private executors.
--------------------------------------------------------------------------------
local function executeLogout(action)
    if (not IS_SERVER) then
        runSceneMain({confirmText = action.message})
    end
end

local function executeMessage(action)
    if (not IS_SERVER) then
        getModelMessageIndicator():showMessage(action.message)
    end
end

local function executeError(action)
    if (not IS_SERVER) then
        error("ActionExecutor-executeError() " .. (action.error or ""))
    end
end

local function executeRunSceneMain(action)
    if (not IS_SERVER) then
        local param = {
            isPlayerLoggedIn = true,
            confirmText      = action.message,
        }
        runSceneMain(param, WebSocketManager.getLoggedInAccountAndPassword())
    end
end

local function executeGetSceneWarData(action)
    if (not IS_SERVER) then
        if (action.message) then
            getModelMessageIndicator():showPersistentMessage(action.message)
        end

        local actorSceneWar = Actor.createWithModelAndViewName("sceneWar.ModelSceneWar", action.data, "sceneWar.ViewSceneWar")
        ActorManager.setAndRunRootActor(actorSceneWar, "FADE", 1)
    end
end

local function executeReloadCurrentScene(action)
    if (not IS_SERVER) then
        requestReloadSceneWar(action)
    end
end

--------------------------------------------------------------------------------
-- The public function.
--------------------------------------------------------------------------------
function ActionExecutor.execute(action)
    local modelSceneWar = SingletonGetters.getModelScene(action.fileName)
    if ((not modelSceneWar) or (not modelSceneWar.getModelWarField)) then
        return
    end

    local actionName = action.actionName
    if     (actionName == "Logout")             then return executeLogout(            action)
    elseif (actionName == "Message")            then return executeMessage(           action)
    elseif (actionName == "Error")              then return executeError(             action)
    elseif (actionName == "RunSceneMain")       then return executeRunSceneMain(      action)
    elseif (actionName == "GetSceneWarData")    then return executeGetSceneWarData(   action)
    elseif (actionName == "ReloadCurrentScene") then return executeReloadCurrentScene(action)
    end
end

return ActionExecutor
