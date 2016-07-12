
--[[--------------------------------------------------------------------------------
-- GridIndexable是ModelUnit/ModelTile可用的组件。只有绑定了本组件，宿主才具有“在地图上的坐标”的属性。
-- 主要职责：
--   维护相关数值并提供必要接口给外界访问
-- 使用场景举例：
--   宿主初始化时，根据自身属性来绑定和初始化本组件（所有ModelUnit/ModelTile都需要绑定，但具体由GameConstant决定）
--   移动、攻击、占领等绝大多数单位操作都会用到本组件
-- 其他：
--   GridIndex即坐标（实在想不到名字），其中的x和y都应当是整数
--   - 游戏中，一个格子上最多只能有一个ModelUnit和一个ModelTile。代码利用了这一点，使用GridIndex对unit和tile进行快速索引
--     此外，客户端发送给服务器的操作消息也都用GridIndex来指代特定的unit或tile
--]]--------------------------------------------------------------------------------

local GridIndexable = class("GridIndexable")

local TypeChecker        = require("app.utilities.TypeChecker")
local ComponentManager   = require("global.components.ComponentManager")
local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

local EXPORTED_METHODS = {
    "getGridIndex",
    "setGridIndex",
    "setViewPositionWithGridIndex"
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function GridIndexable:ctor(param)
    self.m_GridIndex = {x = 0, y = 0}
    self:loadInstantialData(param.instantialData)

    return self
end

function GridIndexable:loadInstantialData(data)
    if (data.gridIndex) then
        self:setGridIndex(data.gridIndex)
    end

    return self
end

--------------------------------------------------------------------------------
-- The function for serialization.
--------------------------------------------------------------------------------
function GridIndexable:toSerializableTable()
    return {
        gridIndex = {
            x = self.m_GridIndex.x,
            y = self.m_GridIndex.y,
        },
    }
end

--------------------------------------------------------------------------------
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function GridIndexable:onBind(target)
    assert(self.m_Owner == nil, "GridIndexable:onBind() the GridIndexable has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Owner = target

    return self
end

function GridIndexable:onUnbind()
    assert(self.m_Owner, "GridIndexable:unbind() the component has not bound a target.")

    ComponentManager.unsetMethods(self.m_Owner, EXPORTED_METHODS)
    self.m_Owner = nil

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function GridIndexable:getGridIndex()
    return self.m_GridIndex
end

function GridIndexable:setGridIndex(gridIndex, shouldMoveView)
    self.m_GridIndex.x, self.m_GridIndex.y = gridIndex.x, gridIndex.y

    if (shouldMoveView ~= false) then
        self:setViewPositionWithGridIndex(self.m_GridIndex)
    end

    return self.m_Owner
end

-- The param gridIndex may be nil. If so, the function set the position of view with self.m_GridIndex .
function GridIndexable:setViewPositionWithGridIndex(gridIndex)
    local view = self.m_Owner and self.m_Owner.m_View or nil
    if (view) then
        view:setPosition(GridIndexFunctions.toPosition(gridIndex or self.m_GridIndex))
    end

    return self.m_Owner
end

return GridIndexable
