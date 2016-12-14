
local WebSocketManager = {}

local SerializationFunctions = require("src.app.utilities.SerializationFunctions")
local ActorManager           = require("src.global.actors.ActorManager")

local encode = SerializationFunctions.encode
local decode = SerializationFunctions.decode

local SERVER_URL = "e1t5268499.imwork.net:27370/BabyWars"
--[[
local SERVER_URL = "localhost:19297/BabyWars"
--]]

local HEARTBEAT_INTERVAL = 10

local s_Socket
local s_Account, s_Password

local s_HeartbeatCounter
local s_HeartbeatScheduleID
local s_IsHeartbeatAnswered

local s_Scheduler = cc.Director:getInstance():getScheduler()

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function heartbeat()
    print("WebSocketManager-heartbeat", s_HeartbeatCounter)
    if (not s_IsHeartbeatAnswered) then
        WebSocketManager.close()
    else
        s_HeartbeatCounter    = s_HeartbeatCounter + 1
        s_IsHeartbeatAnswered = false
        WebSocketManager.sendAction({
            actionName       = "NetworkHeartbeat",
            heartbeatCounter = s_HeartbeatCounter,
        })
    end
end

local function cleanup()
    s_Socket:unregisterScriptHandler(cc.WEBSOCKET_OPEN)
    s_Socket:unregisterScriptHandler(cc.WEBSOCKET_MESSAGE)
    s_Socket:unregisterScriptHandler(cc.WEBSOCKET_CLOSE)
    s_Socket:unregisterScriptHandler(cc.WEBSOCKET_ERROR)
    s_Socket = nil

    if (s_HeartbeatScheduleID) then
        s_Scheduler:unscheduleScriptEntry(s_HeartbeatScheduleID)
        s_HeartbeatScheduleID = nil
    end
end

local function sendString(str)
    assert(WebSocketManager.isInitialized(), "WebSocketManager.sendString() the socket hasn't been initialized.")
    s_Socket:sendString(str)
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function WebSocketManager.isInitialized()
    return s_Socket ~= nil
end

function WebSocketManager.init()
    assert(not WebSocketManager.isInitialized(), "WebSocketManager.init() the socket has been initialized.")
    s_Socket = cc.WebSocket:create(SERVER_URL)

    s_Socket:registerScriptHandler(function()
        ActorManager.getRootActor():getModel():onWebSocketEvent("open")

        s_HeartbeatCounter    = 0
        s_IsHeartbeatAnswered = true
        s_HeartbeatScheduleID = s_Scheduler:scheduleScriptFunc(heartbeat, HEARTBEAT_INTERVAL, false)
        heartbeat()
    end, cc.WEBSOCKET_OPEN)

    s_Socket:registerScriptHandler(function(msg)
        local action = assert(loadstring("return " .. msg))()
        if (action.actionName == "NetworkHeartbeat") then
            s_IsHeartbeatAnswered = action.heartbeatCounter == s_HeartbeatCounter
        else
            ActorManager.getRootActor():getModel():onWebSocketEvent("message", {
                message = msg,
                action  = action,
            })
        end
    end, cc.WEBSOCKET_MESSAGE)

    s_Socket:registerScriptHandler(function()
        ActorManager.getRootActor():getModel():onWebSocketEvent("close")

        cleanup()
        WebSocketManager.init()
    end, cc.WEBSOCKET_CLOSE)

    s_Socket:registerScriptHandler(function(err)
        ActorManager.getRootActor():getModel():onWebSocketEvent("error", {error = err})

        cleanup()
        WebSocketManager.init()
    end, cc.WEBSOCKET_ERROR)

    return WebSocketManager
end

function WebSocketManager.setLoggedInAccountAndPassword(account, password)
    s_Account, s_Password = account, password

    return WebSocketManager
end

function WebSocketManager.getLoggedInAccountAndPassword()
    return s_Account, s_Password
end

function WebSocketManager.sendAction(action)
    action.playerAccount  = action.playerAccount  or s_Account
    action.playerPassword = action.playerPassword or s_Password

    WebSocketManager.sendString(SerializationFunctions.toString(action))

    return WebSocketManager
end

function WebSocketManager.close()
    assert(WebSocketManager.isInitialized(), "WebSocketManager.close() the socket hasn't been initialized.")
    s_Socket:close()

    return WebSocketManager
end

return WebSocketManager
