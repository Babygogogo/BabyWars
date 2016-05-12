
local ModelMainMenu = class("ModelMainMenu")

--------------------------------------------------------------------------------
-- The new game item.
--------------------------------------------------------------------------------
local function createItemNewGame(self)
    return {
        name = "New Game",
        callback = function()
            print("New Game is not implemented.")
        end,
    }
end

local function initWithItemNewGame(self, item)
    self.m_ItemNewGame = item
end

--------------------------------------------------------------------------------
-- The continue item.
--------------------------------------------------------------------------------
local function createItemContinue(self)
    return {
        name     = "Continue",
        callback = function()
            self:setEnabled(false)
            self.m_ModelWarList:setEnabled(true)
        end,
    }
end

local function initWithItemContinue(self, item)
    self.m_ItemContinue = item
end

--------------------------------------------------------------------------------
-- The config skills item.
--------------------------------------------------------------------------------
local function createItemConfigSkills(self)
    return {
        name = "Config Skills",
        callback = function()
            print("Config Skills is not implemented.")
        end,
    }
end

local function initWithItemConfigSkills(self, item)
    self.m_ItemConfigSkills = item
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelMainMenu:ctor(param)
    initWithItemNewGame(     self, createItemNewGame(self))
    initWithItemContinue(    self, createItemContinue(self))
    initWithItemConfigSkills(self, createItemConfigSkills(self))

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelMainMenu:initView()
    local view = self.m_View
    assert(view, "ModelMainMenu:initView() no view is attached to the actor of the model.")

    view:removeAllItems()
        :createAndPushBackItem(self.m_ItemNewGame)
        :createAndPushBackItem(self.m_ItemContinue)
        :createAndPushBackItem(self.m_ItemConfigSkills)

    return self
end

function ModelMainMenu:setModelWarList(model)
    assert(self.m_ModelWarList == nil, "ModelMainMenu:setModelWarList() the model has been set.")
    self.m_ModelWarList = model

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelMainMenu:setEnabled(enabled)
    if (self.m_View) then
        self.m_View:setVisible(enabled)
    end

    return self
end

return ModelMainMenu
