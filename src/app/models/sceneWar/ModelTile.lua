
--[[--------------------------------------------------------------------------------
-- ModelTile是战场上的一块地形。
--
-- 主要职责和使用场景举例：
--   构造地块，维护相关数值，提供接口给外界访问
--
-- 其他：
--   - ObjectID与BaseID，以及tile为何需要分层
--     ObjectID与BaseID实质上也是tiledID，但因为tile需要分层（某些情况不能只用1个tiledID来表示ModelTile），所以在tile内部根据情况，需要区分这两种id。
--     - 考虑plain地形。plain没有特殊功能，因此只用一个tiledID就足够表示了。类似的情况下，该tiledID就是BaseID。
--
--     - 考虑meteor地形。meteor被击破后，残留的地形既可能是sea，也可能是plain或其他。
--       如果只用一个tiledID来表示meteor，那势必需要根据残留地形的不同，预留足够多的id号给meteor使用，否则程序无法知道meteor击破后残留的地形是什么。
--       但如果用两个tiledID来表示meteor，那么ObjectID表示meteor自身，BaseID表示meteor底下的地形。这样，meteor被击破后，就可以用BaseID来生成新地形了。
--
--     - 考虑bridge地形。bridge底下的既可能是sea，也可能是river。
--       bridge本身有十几种形态，river也是十几种，sea更高达四十多种。如果只用一个tiledID来表示bridge，那么为了能够描述所有可能的组合，就必须为bridge预留几百个id号。
--       这就意味着，在地图编辑器中，必须为bridge预留几百个不同形态的图片。这不现实。
--
--     综上，地形必须分两层来构造，也就是一块地形可能会有两个tiledID。对于不需要两层的地形（如plain），那么只需一个tiledID（BaseID）即可代表。
--     不过，这些细节对于外界都是透明的。外界只知道每个tile都有一个对应的tiledID。当外界需要获取这个tiledID的时候，tile优先返回ObjectID，若不存在就返回BaseID即可。
--
--     目前，只需要BaseID就能构造的地形包括：plain，sea，beach，river。它们又可称为base地形（因为它们位于地图底层，上层可能会有其他地形）
--     除了base地形，其他的地形都可称为object地形。这些地形都可以放置在base地形之上。
--
--   - 什么是instantialData（嗯，这个名字很怪，原谅我想不到别的）
--     instantialData指的是一个tile实例的非模板的数据。它在构造tile的时候会被用到。
--     - 考虑plain地形。plain本身看上去没有任何非模板的状态，但和其他所有tile一样，它有自己的坐标值（GridIndex），这在模板中不可能体现出来。
--       为了构造plain（以及其他所有tile），我们需要用到与模板不同的数据（在本例中就是坐标值），这个数据就是instantialData（的一部分）。
--
--     - 考虑meteor地形。meteor一大特点是有生命值。如果只用模板（即GameConstant中的相应模板）来构造meteor的实例，那么该实例就是满血的。
--       为了能构造一个不满血的meteor，我们还需要用到与模板不同的数据（在本例中就是meteor的血量），这个数据就是instantialData（的一部分）。
--
--     顺带一提，在保存战局时，instantialData是肯定需要保存下来的。为避免保存无意义数据，相关代码需要判断tile当前状态与模板有何不同，只保存不同的部分即可。
--     此外，ModelUnit中同样有instantialData的概念，其意义和这里所说的一致。
--
--   - ModelTile（以及ModelUnit）是component的重度使用者。即使是GridIndex这样的所有ModelTile都具有的属性，也是通过绑定GridIndexable这个component来持有的。
--     之所以如此依赖component，是因为我认为这样可以减低ModelTile本身的理解复杂度。
--     虽然理解component机制需要花一点功夫（参看ComponentManager与各component的注释），但一旦理解，那么不管ModelTile绑定了多少component，理解起来都很轻松。
--     相对的，如果不用component，那么ModelTile很可能要写的很长（我看到长文件会晕），理解也更费力。
--
--   - ModelTile的构造流程（ModelUnit与此类似）
--     ModelTile需要由objectID，baseID以及instantialData来构造。
--     1. 使用objectID与baseID，通过GameConstantFunctions获取模板（objectID可以不存在，如果构造的刚好是base地形）
--     2. 按照模板进行构造
--        2.1. 直接用self.m_Template指向模板（模板中存在某些常量数据，一个个拷贝到tile中没有太多意义，不如直接指向模板以便以后访问。当然，决不能改变模板中的内容）
--        2.2. 按照模板，初始化并绑定component（目前判断模板中的某个元素是不是component，依据是该元素名的第一个字母是不是大写……有点简陋，但能用，后续可考虑换个方式）
--     3. 读取instantialData中的数据
--]]--------------------------------------------------------------------------------

local ModelTile = class("ModelTile")

local ComponentManager      = require("global.components.ComponentManager")
local TypeChecker           = require("app.utilities.TypeChecker")
local GameConstantFunctions = require("app.utilities.GameConstantFunctions")
local TableFunctions        = require("app.utilities.TableFunctions")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function initWithTiledID(self, objectID, baseID)
    self.m_InitialObjectID = self.m_InitialObjectID or objectID
    self.m_InitialBaseID   = self.m_InitialBaseID   or baseID

    self.m_ObjectID = objectID or self.m_ObjectID
    self.m_BaseID   = baseID   or self.m_BaseID
    assert(self.m_ObjectID and self.m_BaseID, "ModelTile-initWithTiledID() failed to init self.m_ObjectID and/or self.m_BaseID.")

    local template = GameConstantFunctions.getTemplateModelTileWithTiledId(self.m_ObjectID, self.m_BaseID)
    assert(template, "ModelTile-initWithTiledID() failed to get the template model tile with param objectID and baseID.")

    if (self.m_Template ~= template) then
        self.m_Template = template

        ComponentManager.unbindAllComponents(self)
        for name, data in pairs(template) do
            if (string.byte(name) > string.byte("z")) or (string.byte(name) < string.byte("a")) then
                ComponentManager.bindComponent(self, name, {template = data, instantialData = data})
            end
        end
    end
end

local function loadInstantialData(self, param)
    for name, data in pairs(param) do
        if (string.byte(name) > string.byte("z")) or (string.byte(name) < string.byte("a")) then
            local component = ComponentManager.getComponent(self, name)
            assert(component, "ModelTile-loadInstantialData() attempting to update a component that the model hasn't bound with.")

            component:loadInstantialData(data)
        end
    end
end

local function serializeObjectIdToStringList(self, spaces)
    if (self.m_InitialObjectID == self.m_ObjectID) then
        return nil
    else
        return {string.format("%sobjectID = %d", spaces or "", self.m_ObjectID)}
    end
end

local function serializeBaseIdToStringList(self, spaces)
    if (self.m_InitialBaseID == self.m_BaseID) then
        return nil
    else
        return {string.format("%sbaseID = %d", spaces or "", self.m_BaseID)}
    end
end

local function serializeComponentsToStringList(self, spaces)
    spaces = spaces or ""
    local strList, componentsCount = {}, 0
    local appendList = TableFunctions.appendList

    for name, component in pairs(ComponentManager.getAllComponents(self)) do
        if (component.toStringList) then
            local componentStrList = component:toStringList(spaces)
            if (componentStrList) then
                appendList(strList, component:toStringList(spaces), ",\n")
                componentsCount = componentsCount + 1
            end
        end
    end

    return strList, componentsCount
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelTile:ctor(param)
    if ((param.objectID) or (param.baseID)) then
        initWithTiledID(self, param.objectID, param.baseID)
    end

    loadInstantialData(self, param)

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelTile:initView()
    local view = self.m_View
    assert(view, "ModelTile:initView() no view is attached to the actor of the model.")

    self:setViewPositionWithGridIndex()
        :updateView()

    return self
end

function ModelTile:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelTile:setRootScriptEventDispatcher() the dispatcher has been set.")
    self.m_RootScriptEventDispatcher = dispatcher

    for _, component in pairs(ComponentManager.getAllComponents(self)) do
        if (component.setRootScriptEventDispatcher) then
            component:setRootScriptEventDispatcher(dispatcher)
        end
    end

    return self
end

function ModelTile:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "ModelTile:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")
    self.m_RootScriptEventDispatcher = nil

    for _, component in pairs(ComponentManager.getAllComponents(self)) do
        if (component.unsetRootScriptEventDispatcher) then
            component:unsetRootScriptEventDispatcher()
        end
    end

    return self
end

--------------------------------------------------------------------------------
-- The function for serialization.
--------------------------------------------------------------------------------
function ModelTile:toStringList(spaces)
    spaces = spaces or ""
    local subSpaces = spaces .. "    "

    local componentStrList, componentsCount = serializeComponentsToStringList(self, subSpaces)
    if ((self.m_InitialBaseID == self.m_BaseID) and (self.m_InitialObjectID == self.m_ObjectID) and (componentsCount <= 1)) then
        return nil
    else
        local strList = {spaces .. "{\n"}
        local appendList = TableFunctions.appendList
        appendList(strList, serializeObjectIdToStringList(self, subSpaces), ",\n")
        appendList(strList, serializeBaseIdToStringList(  self, subSpaces), ",\n")
        appendList(strList, componentStrList,                               spaces .. "}")

        return strList
    end
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelTile:updateView()
    if (self.m_View) then
        self.m_View:setViewObjectWithTiledId(self.m_ObjectID)
            :setViewBaseWithTiledId(self.m_BaseID)
    end

    return self
end

function ModelTile:getTiledID()
    return (self.m_ObjectID > 0) and (self.m_ObjectID) or (self.m_BaseID)
end

function ModelTile:getPlayerIndex()
    return GameConstantFunctions.getPlayerIndexWithTiledId(self:getTiledID())
end

function ModelTile:getDescription()
    return self.m_Template.description
end

function ModelTile:destroyModelTileObject()
    assert(self.m_ObjectID > 0, "ModelTile:destroyModelTileObject() there's no tile object.")

    local gridIndex, dispatcher = self:getGridIndex(), self.m_RootScriptEventDispatcher
    self:unsetRootScriptEventDispatcher()
    initWithTiledID(self, 0, self.m_BaseID)
    loadInstantialData(self, {GridIndexable = {gridIndex = gridIndex}})
    self:setRootScriptEventDispatcher(dispatcher)

    dispatcher:dispatchEvent({name = "EvtModelTileUpdated", modelTile = self})

    return self
end

function ModelTile:destroyViewTileObject()
    if (self.m_View) then
        self.m_View:setViewObjectWithTiledId(0)
    end
end

function ModelTile:updateWithPlayerIndex(playerIndex)
    assert(self:getPlayerIndex() ~= playerIndex, "ModelTile:updateWithPlayerIndex() the param playerIndex is the same as the one of self.")
    self.m_ObjectID = GameConstantFunctions.getTiledIdWithTileOrUnitName(GameConstantFunctions.getTileNameWithTiledId(self:getTiledID()), playerIndex)

    return self
end

function ModelTile:doActionAttack(action, isAttacker)
    assert(not isAttacker, "ModelTile:doActionAttack() the param is invalid.")
    for _, component in pairs(ComponentManager.getAllComponents(self)) do
        if (component.doActionAttack) then
            component:doActionAttack(action, isAttacker)
        end
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtModelTileUpdated", modelTile = self})

    return self
end

function ModelTile:doActionCapture(action)
    for _, component in pairs(ComponentManager.getAllComponents(self)) do
        if (component.doActionCapture) then
            component:doActionCapture(action)
        end
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtModelTileUpdated", modelTile = self})

    return self
end

function ModelTile:doActionWait(action)
    for _, component in pairs(ComponentManager.getAllComponents(self)) do
        if (component.doActionWait) then
            component:doActionWait(action)
        end
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtModelTileUpdated", modelTile = self})

    return self
end

return ModelTile