
local ActorManager = {}

local s_RootActor

function ActorManager.setAndRunRootActor(actor, transition, time, more)
    s_RootActor = actor
    display.runScene(actor:getView(), transition, time, more)
end

function ActorManager.getRootActor()
    return RootActor
end

return ActorManager
