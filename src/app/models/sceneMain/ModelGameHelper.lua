
local ModelGameHelper = class("ModelGameHelper")

local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")

--------------------------------------------------------------------------------
-- The composition items.
--------------------------------------------------------------------------------
local function initItemGameFlow(self)
    local item = {
        name     = LocalizationFunctions.getLocalizedText(9),
        callback = function()
            if (self.m_View) then
                self.m_View:setHelpVisible(true)
                    :setHelpText(LocalizationFunctions.getLocalizedText(12))
            end
        end,
    }

    self.m_ItemGameFlow = item
end

local function initItemWarControl(self)
    local item = {
        name     = LocalizationFunctions.getLocalizedText(10),
        callback = function()
            self.m_View:setHelpVisible(true)
                :setHelpText(LocalizationFunctions.getLocalizedText(13))
        end,
    }

    self.m_ItemWarControl = item
end

local function initItemAbout(self)
    local item = {
        name     = LocalizationFunctions.getLocalizedText(11),
        callback = function()
            self.m_View:setHelpVisible(true)
                :setHelpText(LocalizationFunctions.getLocalizedText(14))
        end,
    }

    self.m_ItemAbout = item
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelGameHelper:ctor()
    initItemGameFlow(  self)
    initItemWarControl(self)
    initItemAbout(     self)

    return self
end

function ModelGameHelper:initView()
    assert(self.m_View, "ModelGameHelper:initView() no view is attached to the owner actor of the model.")
    self.m_View:createAndPushBackItem(self.m_ItemGameFlow)
        :createAndPushBackItem(self.m_ItemWarControl)
        :createAndPushBackItem(self.m_ItemAbout)

    return self
end

function ModelGameHelper:setModelMainMenu(model)
    assert(self.m_ModelMainMenu == nil, "ModelGameHelper:setModelMainMenu() the model has been set.")
    self.m_ModelMainMenu = model

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelGameHelper:setEnabled(enabled)
    if (self.m_View) then
        self.m_View:setVisible(enabled)
            :setMenuVisible(true)
            :setHelpVisible(false)
    end

    return self
end

function ModelGameHelper:onButtonBackTouched()
    self:setEnabled(false)
    self.m_ModelMainMenu:setMenuEnabled(true)

    return self
end

return ModelGameHelper
