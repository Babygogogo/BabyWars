
local ModelSkillConfigurator = class("ModelSkillConfigurator")

local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getConfigurationTitle(configurationID)
    return string.format("%s %d", LocalizationFunctions.getLocalizedText(3, "Configuration"), configurationID)
end

--------------------------------------------------------------------------------
-- The functions for setting state.
--------------------------------------------------------------------------------
local function setStateMain(self)
    self.m_State = "stateMain"
    if (self.m_View) then
        self.m_View:setMenuTitle(LocalizationFunctions.getLocalizedText(1, "ConfigSkills"))
            :setMenuItems(self.m_ItemsMain)
            :setOverviewVisible(false)
            :setEnabled(true)
    end
end

local function setStateDisabled(self)
    self.m_State = "stateDisabled"
    if (self.m_View) then
        self.m_View:setEnabled(false)
    end
end

local function setStateOverviewConfiguration(self, configurationID)
    self.m_State           = "stateOverviewConfiguration"
    self.m_ConfigurationID = configurationID

    if (self.m_View) then
        self.m_View:setMenuTitle(getConfigurationTitle(configurationID))
            :setMenuItems(self.m_ItemsOverview)
            :setOverviewVisible(true)
            :setEnabled(true)
    end
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initItemsMain(self)
    local items = {}
    for i = 1, 10 do
        items[#items + 1] = {
            name     = getConfigurationTitle(i),
            callback = function()
                setStateOverviewConfiguration(self, i)
            end,
        }
    end

    self.m_ItemsMain = items
end

local function initItemsOverview(self)
    local items = {
        {
            name     = LocalizationFunctions.getLocalizedText(3, "PassiveSkill"),
            callback = function()
            end,
        },
        {
            name     = LocalizationFunctions.getLocalizedText(3, "ActiveSkill") .. " 1",
            callback = function()
            end,
        },
        {
            name     = LocalizationFunctions.getLocalizedText(3, "ActiveSkill") .. " 2",
            callback = function()
            end,
        },
    }

    self.m_ItemsOverview = items
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelSkillConfigurator:ctor()
    self.m_State = "stateDisabled"
    initItemsMain(    self)
    initItemsOverview(self)

    return self
end

function ModelSkillConfigurator:initView()
    return self
end

function ModelSkillConfigurator:setModelMainMenu(model)
    assert(self.m_ModelMainMenu == nil, "ModelSkillConfigurator:setModelMainMenu() the model has been set already.")
    self.m_ModelMainMenu = model

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelSkillConfigurator:setEnabled(enabled)
    if (enabled) then
        setStateMain(self)
    else
        setStateDisabled(self)
    end

    return self
end

function ModelSkillConfigurator:onButtonBackTouched()
    local state = self.m_State
    if (state == "stateMain") then
        setStateDisabled(self)
        self.m_ModelMainMenu:setMenuEnabled(true)
    elseif (state == "stateOverviewConfiguration") then
        setStateMain(self)
    else
        error("ModelSkillConfigurator:onButtonBackTouched() the current state is invalid: " .. state)
    end

    return self
end

return ModelSkillConfigurator
