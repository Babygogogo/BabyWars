
local ModelSkillConfigurator = class("ModelSkillConfigurator")

local ModelSkillConfiguration = require("src.app.models.common.ModelSkillConfiguration")
local LocalizationFunctions   = require("src.app.utilities.LocalizationFunctions")
local GameConstantFunctions   = require("src.app.utilities.GameConstantFunctions")
local getLocalizedText        = LocalizationFunctions.getLocalizedText

local MIN_POINTS, MAX_POINTS, POINTS_PER_STEP = GameConstantFunctions.getSkillPointsMinMaxStep()

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getConfigurationTitle(configurationID)
    return string.format("%s %d", getLocalizedText(3, "Configuration"), configurationID)
end

--------------------------------------------------------------------------------
-- The functions for setting state.
--------------------------------------------------------------------------------
local function setStateMain(self)
    self.m_State = "stateMain"
    if (self.m_View) then
        self.m_View:setMenuTitle(getLocalizedText(1, "ConfigSkills"))
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

    local view = self.m_View
    if (view) then
        view:setMenuTitle(getConfigurationTitle(configurationID))
            :setMenuItems(self.m_ItemsOverview)
            :setOverviewVisible(true)
            :setEnabled(true)

        local configuration = self.m_ModelSkillConfituration
        if (configuration:isEmpty()) then
            view:setOverviewString(getLocalizedText(3, "GettingConfiguration"))
        else
            view:setOverviewString(configuration:getDescription())
        end
    end
end

local function setStateSelectMaxPoint(self)
    self.m_State = "stateSelectMaxPoint"

    if (self.m_View) then
        self.m_View:setMenuTitle(getLocalizedText(3, "MaxPoints"))
            :setMenuItems(self.m_ItemsMaxPoints)
            :setOverviewVisible(false)
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
                self.m_RootScriptEventDispatcher:dispatchEvent({
                    name            = "EvtPlayerRequestDoAction",
                    actionName      = "GetSkillConfiguration",
                    configurationID = i,
                })
            end,
        }
    end

    self.m_ItemsMain = items
end

local function initItemsOverview(self)
    local items = {
        {
            name     = getLocalizedText(3, "SetSkillPoint"),
            callback = function()
                setStateSelectMaxPoint(self)
            end,
        },
        {
            name     = getLocalizedText(3, "PassiveSkill"),
            callback = function()
            end,
        },
        {
            name     = getLocalizedText(3, "ActiveSkill") .. " 1",
            callback = function()
            end,
        },
        {
            name     = getLocalizedText(3, "ActiveSkill") .. " 2",
            callback = function()
            end,
        },
    }

    self.m_ItemsOverview = items
end

local function initItemsMaxPoints(self)
    local items = {}
    for points = MIN_POINTS, MAX_POINTS, POINTS_PER_STEP do
        items[#items + 1] = {
            name     = "" .. points,
            callback = function()
                self.m_ModelSkillConfituration:setMaxPoints(points)
                setStateOverviewConfiguration(self, self.m_ConfigurationID)
            end,
        }
    end

    self.m_ItemsMaxPoints = items
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelSkillConfigurator:ctor()
    self.m_State                   = "stateDisabled"
    self.m_ModelSkillConfituration = ModelSkillConfiguration:create()

    initItemsMain(     self)
    initItemsOverview( self)
    initItemsMaxPoints(self)

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

function ModelSkillConfigurator:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil,
        "ModelSkillConfigurator:setRootScriptEventDispatcher() the model has been set already.")
    self.m_RootScriptEventDispatcher = dispatcher

    return self
end

--------------------------------------------------------------------------------
-- The public functions for doing actions.
--------------------------------------------------------------------------------
function ModelSkillConfigurator:doActionGetSkillConfiguration(action)
    if ((self.m_State == "stateOverviewConfiguration")      and
        (self.m_ConfigurationID == action.configurationID)) then
        self.m_ModelSkillConfituration:ctor(action.configuration)
        self.m_View:setOverviewString(self.m_ModelSkillConfituration:getDescription())
    end

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
    elseif (state == "stateSelectMaxPoint") then
        setStateOverviewConfiguration(self, self.m_ConfigurationID)
    else
        error("ModelSkillConfigurator:onButtonBackTouched() the current state is invalid: " .. state)
    end

    return self
end

return ModelSkillConfigurator
