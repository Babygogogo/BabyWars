
--[[--------------------------------------------------------------------------------
-- ActorManager主要用于维护RootActor（参看Actor的注释）。后续也可能用于创建Actor实例。
--
-- 主要职责：
--   设定并运行RootActor
--   提供接口给外界访问RootActor
--
-- 使用场景举例：
--   在程序入口（main.lua），读取完必要的游戏资源后，就需要运行主场景了。程序入口创建主场景的actor，并调用ActorManager的相关函数，使得该actor得以运行。
--
-- 其他：
--   - 创建ActorManager的初衷
--     理想情况下除了view之外的所有代码都可以和引擎完全脱耦，但为了使rootActor中的view得以呈现，必须调用引擎提供的display.runScene()函数。
--     为避免在model中调用这个函数，我就创建了ActorManager，由它来调用runScene。
--     此外，考虑到在服务器上，程序应该可以完全脱离游戏引擎而独立运行，届时ActorManager应该还可以发挥别的作用（虽然还没想好）。
--]]--------------------------------------------------------------------------------

local ActorManager = {}

local s_RootActor

function ActorManager.setAndRunRootActor(actor, transition, time, more)
    if (s_RootActor) then
        local model = s_RootActor:getModel()
        if ((model) and (model.onStopRunning)) then
            model:onStopRunning()
        end
    end

    display.runScene(actor:getView(), transition, time, more)
    s_RootActor = actor

    local model = actor:getModel()
    if ((model) and (model.onStartRunning)) then
        model:onStartRunning()
    end

    return ActorManager
end

function ActorManager.getRootActor()
    return s_RootActor
end

return ActorManager
