
local WebSocketManager = {}

--[[
local SERVER_URL = "e1t5268499.imwork.net:27370/BabyWars"
--]]
local SERVER_URL = "localhost:19297/BabyWars"

local s_Socket ,s_Owner
local s_Account, s_Password

function WebSocketManager.isInitialized()
    return s_Socket ~= nil
end

function WebSocketManager.init()
    assert(not WebSocketManager.isInitialized(), "WebSocketManager.init() the socket has been initialized.")
    s_Socket = cc.WebSocket:create(SERVER_URL)

    return WebSocketManager
end

function WebSocketManager.setOwner(owner)
    assert(WebSocketManager.isInitialized(), "WebSocketManager.setOwner() the socket hasn't been initialized.")
    assert(type(owner.onWebSocketEvent) == "function", "WebSocketManager.setOwner() the param owner.onWebSocketEvent is not a function.")

    s_Socket:registerScriptHandler(function()
        owner:onWebSocketEvent("open")
    end, cc.WEBSOCKET_OPEN)

    s_Socket:registerScriptHandler(function(msg)
        owner:onWebSocketEvent("message", {message = msg})
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

    return WebSocketManager
end

return WebSocketManager
