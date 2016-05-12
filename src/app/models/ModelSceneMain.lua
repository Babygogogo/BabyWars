
--[[--------------------------------------------------------------------------------
-- ModelSceneMain是主场景。刚打开游戏，以及退出战局后所看到的就是这个场景。
--
-- 主要职责和使用场景举例：
--   同上
--
-- 其他：
--  - 目前本类功能很少。预定需要增加的功能包括（在本类中直接实现，或通过添加新的类来实现）：
--    - 创建新战局
--    - 加入已有战局
--    - 配置技能
--    - 显示玩家形象、id、积分、排名、战绩
--]]--------------------------------------------------------------------------------

local ModelSceneMain = class("ModelSceneMain")

local Actor	                = require("global.actors.Actor")
local GameConstantFunctions = require("app.utilities.GameConstantFunctions")

--------------------------------------------------------------------------------
-- The composition confirm box actor.
--------------------------------------------------------------------------------
local function createActorConfirmBox()
    return Actor.createWithModelAndViewName("ModelConfirmBox", nil, "ViewConfirmBox")
end

local function initWithActorConfirmBox(self, actor)
    actor:getModel():setEnabled(false)
    self.m_ActorConfirmBox = actor
end

--------------------------------------------------------------------------------
-- The composition main menu actor.
--------------------------------------------------------------------------------
local function createActorMainMenu()
    return Actor.createWithModelAndViewName("ModelMainMenu", nil, "ViewMainMenu")
end

local function initWithActorMainMenu(self, actor)
    self.m_ActorMainMenu = actor
end

--------------------------------------------------------------------------------
-- The composition war list actor.
--------------------------------------------------------------------------------
local function createActorWarList(mapListData)
    return Actor.createWithModelAndViewName("ModelWarList", mapListData, "ViewWarList", mapListData)
end

local function initWithActorWarList(self, actor)
    local modelMainMenu = self.m_ActorMainMenu:getModel()
    local modelWarList  = actor:getModel()
    modelMainMenu:setModelWarList(modelWarList)
    modelWarList:setModelConfirmBox(self.m_ActorConfirmBox:getModel())
        :setModelMainMenu(modelMainMenu)
        :setEnabled(false)

    self.m_ActorWarList = actor
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelSceneMain:ctor(param)
    initWithActorConfirmBox(self, createActorConfirmBox())
    initWithActorMainMenu(  self, createActorMainMenu())
    initWithActorWarList(   self, createActorWarList("WarSceneList"))

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelSceneMain:initView()
    local view = self.m_View
    assert(view, "ModelSceneMain:initView() no view is attached to the owner actor of the model.")

    view:setViewConfirmBox(self.m_ActorConfirmBox:getView())
        :setViewMainMenu(  self.m_ActorMainMenu:getView())
        :setViewWarList(   self.m_ActorWarList:getView())
        :setGameVersion(GameConstantFunctions.getGameVersion())

    return self
end

return ModelSceneMain
