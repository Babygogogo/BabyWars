
local ModelNewGameCreator = class("ModelNewGameCreator")

--------------------------------------------------------------------------------
-- The new game item.
--------------------------------------------------------------------------------
local function createItemListWarField(self)
    local list = {}
    for _, warField in ipairs(require("res.data.templateWarField.WarFieldList")) do
        list[#list + 1] = {
            name     = warField.name,
            callback = function()
                print(string.format("Creating a game with '%s' is not implemented.", warField.name))
            end,
        }
    end

    return list
end

local function initWithItemListWarField(self, list)
    self.m_ItemListWarField = list
end

--------------------------------------------------------------------------------
-- The back item.
--------------------------------------------------------------------------------
local function createItemBack(self)
    return {
        name     = "back",
        callback = function()
            self:setEnabled(false)
            self.m_ModelMainMenu:setMenuEnabled(true)
        end,
    }
end

local function initWithItemBack(self, item)
    self.m_ItemBack = item
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelNewGameCreator:ctor(param)
    initWithItemListWarField(self, createItemListWarField(self))
    initWithItemBack(        self, createItemBack(self))

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelNewGameCreator:initView()
    local view = self.m_View
    assert(view, "ModelNewGameCreator:initView() no view is attached to the actor of the model.")

    view:removeAllItems()
        :setItemBack(self.m_ItemBack)
        :showListWarField(self.m_ItemListWarField)

    return self
end

function ModelNewGameCreator:setModelMainMenu(model)
    assert(self.m_ModelMainMenu == nil, "ModelNewGameCreator:setModelMainMenu() the model has been set.")
    self.m_ModelMainMenu = model

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelNewGameCreator:setEnabled(enabled)
    if (self.m_View) then
        self.m_View:setVisible(enabled)
    end

    return self
end

return ModelNewGameCreator
