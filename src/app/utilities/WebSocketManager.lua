
local WebSocketManager = {}

local SerializationFunctions = require("src.app.utilities.SerializationFunctions")

local SERVER_URL = "e1t5268499.imwork.net:27370/BabyWars"
--[[
local SERVER_URL = "localhost:19297/BabyWars"
--]]

local HEARTBEAT_INTERVAL = 20

local s_Socket ,s_Owner
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
        s_Socket:close()
    else
        s_HeartbeatCounter    = s_HeartbeatCounter + 1
        s_IsHeartbeatAnswered = false
        s_Socket:sendString(SerializationFunctions.toString({
            name             = "EvtPlayerRequestDoAction",
            actionName       = "NetworkHeartbeat",
            heartbeatCounter = s_HeartbeatCounter,
        }))
    end
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function WebSocketManager.isInitialized()
    return s_Socket ~= nil
end

function WebSocketManager.init()
    assert(not WebSocketManager.isInitialized(), "WebSocketManager.init() the socket has been initialized.")
    s_Socket              = cc.WebSocket:create(SERVER_URL)
    s_HeartbeatCounter    = 0
    s_IsHeartbeatAnswered = true

    return WebSocketManager
end

function WebSocketManager.setOwner(owner)
    assert(WebSocketManager.isInitialized(), "WebSocketManager.setOwner() the socket hasn't been initialized.")
    assert(type(owner.onWebSocketEvent) == "function", "WebSocketManager.setOwner() the param owner.onWebSocketEvent is not a function.")

    s_Socket:registerScriptHandler(function()
        owner:onWebSocketEvent("open")
        s_HeartbeatScheduleID = s_Scheduler:scheduleScriptFunc(heartbeat, HEARTBEAT_INTERVAL, false)
    end, cc.WEBSOCKET_OPEN)

    s_Socket:registerScriptHandler(function(msg)
        local action = assert(loadstring("return " .. msg))()
        if (action.actionName == "NetworkHeartbeat") then
            s_IsHeartbeatAnswered = action.heartbeatCounter == s_HeartbeatCounter
        else
            owner:onWebSocketEvent("message", {
                message = msg,
                action  = action,
            })
        end
    end, cc.WEBSOCKET_MESSAGE)

    s_Socket:registerScriptHandler(function()
        owner:onWebSocketEvent("close")
    end, cc.WEBSOCKET_CLOSE)

    s_Socket:registerScriptHandler(function(err)
        owner:onWebSocketEvent("error", {error = err})
    end, cc.WEBSOCKET_ERROR)

    s_Owner = owner

    return WebSocketManager
end

function WebSocketManager.setLoggedInAccountAndPassword(account, password)
    s_Account, s_Password = account, password

    return WebSocketManager
end

function WebSocketManager.getLoggedInAccountAndPassword()
    return s_Account, s_Password
end

function WebSocketManager.sendString(str)
    assert(WebSocketManager.isInitialized(), "WebSocketManager.sendString() the socket hasn't been initialized.")
    s_Socket:sendString(str)

    return WebSocketManager
end

function WebSocketManager.close()
    assert(WebSocketManager.isInitialized(), "WebSocketManager.close() the socket hasn't been initialized.")
    s_Socket:close()
    s_Socket = nil

    if (s_HeartbeatScheduleID) then
        s_Scheduler:unscheduleScriptEntry(s_HeartbeatScheduleID)
        s_HeartbeatScheduleID = nil
    end

    return WebSocketManager
end

return WebSocketManager
