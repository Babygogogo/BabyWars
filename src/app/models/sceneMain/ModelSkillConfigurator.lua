
local ModelSkillConfigurator = class("ModelSkillConfigurator")

local ModelSkillConfiguration = require("src.app.models.common.ModelSkillConfiguration")
local LocalizationFunctions   = require("src.app.utilities.LocalizationFunctions")
local GameConstantFunctions   = require("src.app.utilities.GameConstantFunctions")
local getLocalizedText        = LocalizationFunctions.getLocalizedText

local MIN_POINTS, MAX_POINTS, POINTS_PER_STEP = GameConstantFunctions.getSkillPointsMinMaxStep()
local SKILL_GROUP_ID_PASSIVE   = ModelSkillConfiguration.getSkillGroupIdPassive()
local SKILL_GROUP_ID_ACTIVE_1  = ModelSkillConfiguration.getSkillGroupIdActive1()
local SKILL_GROUP_ID_ACTIVE_2  = ModelSkillConfiguration.getSkillGroupIdActive2()
local ACTIVE_SKILL_SLOTS_COUNT = GameConstantFunctions.getActiveSkillSlotsCount()

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getConfigurationTitle(configurationID)
    return string.format("%s %d", getLocalizedText(3, "Configuration"), configurationID)
end

local function setItemsSkillGroupActiveState(self, isSkillEnabled)
    local view = self.m_View
    if (view) then
        view:setItemEnabled(1, not isSkillEnabled)
        for i = 2, 3 + ACTIVE_SKILL_SLOTS_COUNT do
            view:setItemEnabled(i, isSkillEnabled)
        end
    end
end

--------------------------------------------------------------------------------
-- The functions for setting state.
--------------------------------------------------------------------------------
local function setStateMain(self)
    self.m_State           = "stateMain"
    self.m_ConfigurationID = nil
    self.m_ModelSkillConfiguration:ctor()

    if (self.m_View) then
        self.m_View:setMenuTitle(getLocalizedText(1, "ConfigSkills"))
            :setMenuItems(self.m_ItemsAllConfigurations)
            :setOverviewVisible(false)
            :setButtonSaveVisible(false)
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
            :setButtonSaveVisible(true)
            :setEnabled(true)

        local configuration = self.m_ModelSkillConfiguration
        if (configuration:isEmpty()) then
            view:setOverviewString(getLocalizedText(3, "GettingConfiguration"))
                :setButtonSaveEnabled(false)
            for i = 1, #self.m_ItemsOverview do
                view:setItemEnabled(i, false)
            end
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
            :setButtonSaveVisible(false)
    end
end

local function setStateOverviewSkillGroupPassive(self)
    self.m_State        = "stateOverviewSkillGroupPassive"
    self.m_SkillGroupID = SKILL_GROUP_ID_PASSIVE

    if (self.m_View) then
        self.m_View:setMenuTitle(getLocalizedText(3, "PassiveSkill"))
            :setMenuItems(self.m_ItemsSkillGroupPassive)
            :setButtonSaveVisible(false)
    end
end

local function setStateOverviewSkillGroupActive(self, skillGroupID)
    assert((skillGroupID == SKILL_GROUP_ID_ACTIVE_1) or (skillGroupID == SKILL_GROUP_ID_ACTIVE_2))
    self.m_State        = "stateOverviewSkillGroupActive"
    self.m_SkillGroupID = skillGroupID

    if (self.m_View) then
        self.m_View:setMenuTitle(string.format("%s %d", getLocalizedText(3, "ActiveSkill"), skillGroupID))
            :setMenuItems(self.m_ItemsSkillGroupActive)
            :setButtonSaveVisible(false)

        setItemsSkillGroupActiveState(self, self.m_ModelSkillConfiguration:isModelSkillGroupEnabled(skillGroupID))
    end
end

local function setStateSelectEnergyRequirement(self)
    self.m_State = "stateSelectEnergyRequirement"

    if (self.m_View) then
        self.m_View:setMenuTitle(getLocalizedText(3, "EnergyRequirement"))
            :setMenuItems(self.m_ItemsEnergyRequirement)
            :setButtonSaveVisible(false)
    end
end

local function setStateSelectSkillCategory(self, slotIndex)
    self.m_State        = "stateSelectSkillCategory"
    self.m_SlotIndex    = slotIndex

    if (self.m_View) then
        self.m_View:setMenuTitle(string.format("%s %d", getLocalizedText(3, "Skill"), slotIndex))
            :setMenuItems(self.m_ItemsSkillCategories)
    end
end

local function setStateSelectSkill(self, categoryName)
    self.m_State        = "stateSelectSkill"
    self.m_CategoryName = categoryName

    if (self.m_View) then
        self.m_View:setMenuItems(self.m_ItemsSkills[categoryName])
    end
end

local function setStateSelectSkillLevel(self, skillID)
    self.m_State   = "stateSelectSkillLevel"
    self.m_SkillID = skillID

    if (self.m_View) then
        self.m_View:setMenuItems(self.m_ItemsSkillLevels[skillID])
    end
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initItemsAllConfigurations(self)
    local items = {}
    for i = 1, GameConstantFunctions.getSkillConfigurationsCount() do
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

    self.m_ItemsAllConfigurations = items
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
                setStateOverviewSkillGroupPassive(self)
            end,
        },
        {
            name     = getLocalizedText(3, "ActiveSkill") .. " 1",
            callback = function()
                setStateOverviewSkillGroupActive(self, SKILL_GROUP_ID_ACTIVE_1)
            end,
        },
        {
            name     = getLocalizedText(3, "ActiveSkill") .. " 2",
            callback = function()
                setStateOverviewSkillGroupActive(self, SKILL_GROUP_ID_ACTIVE_2)
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
                self.m_ModelSkillConfiguration:setMaxSkillPoints(points)
                setStateOverviewConfiguration(self, self.m_ConfigurationID)
            end,
        }
    end

    self.m_ItemsMaxPoints = items
end

local function initItemsEnergyRequirement(self)
    local items          = {}
    local minReq, maxReq = GameConstantFunctions.getEnergyRequirementMinMax()
    for requirement = minReq, maxReq do
        items[#items + 1] = {
            name     = "" .. requirement,
            callback = function()
                self.m_ModelSkillConfiguration:setEnergyRequirement(self.m_SkillGroupID, requirement)

                if (self.m_View) then
                    self.m_View:setOverviewString(self.m_ModelSkillConfiguration:getDescription())
                end
            end,
        }
    end

    self.m_ItemsEnergyRequirement = items
end

local function initItemsSkillGroupPassive(self)
    local items = {}
    for i = 1, GameConstantFunctions.getPassiveSkillSlotsCount() do
        items[#items + 1] = {
            name     = string.format("%s %d", getLocalizedText(3, "Skill"), i),
            callback = function()
                setStateSelectSkillCategory(self, i)
            end,
        }
    end

    self.m_ItemsSkillGroupPassive = items
end

local function initItemsSkillGroupActive(self)
    local items = {
        {
            name      = getLocalizedText(3, "Enable"),
            callback  = function()
                self.m_ModelSkillConfiguration:setModelSkillGroupEnabled(self.m_SkillGroupID, true)
                if (self.m_View) then
                    self.m_View:setOverviewString(self.m_ModelSkillConfiguration:getDescription())
                    setItemsSkillGroupActiveState(self, true)
                end
            end,
        },
        {
            name     = getLocalizedText(3, "Disable"),
            callback = function()
                self.m_ModelSkillConfiguration:setModelSkillGroupEnabled(self.m_SkillGroupID, false)
                if (self.m_View) then
                    self.m_View:setOverviewString(self.m_ModelSkillConfiguration:getDescription())
                    setItemsSkillGroupActiveState(self, false)
                end
            end,
        },
        {
            name     = getLocalizedText(3, "SetEnergyRequirement"),
            callback = function()
                setStateSelectEnergyRequirement(self)
            end,
        },
    }
    for i = 1, ACTIVE_SKILL_SLOTS_COUNT do
        items[#items + 1] = {
            name     = string.format("%s %d", getLocalizedText(3, "Skill"), i),
            callback = function()
                setStateSelectSkillCategory(self, i)
            end,
        }
    end

    self.m_ItemsSkillGroupActive = items
end

local function initItemsSkillCategories(self)
    local items = {
        {
            name     = getLocalizedText(3, "Clear"),
            callback = function()
                self.m_ModelSkillConfiguration:clearSkill(self.m_SkillGroupID, self.m_SlotIndex)

                if (self.m_View) then
                    self.m_View:setOverviewString(self.m_ModelSkillConfiguration:getDescription())
                end
            end,
        }
    }

    for _, categoryName in ipairs(GameConstantFunctions.getCategory("SkillCategories")) do
        items[#items + 1] = {
            name     = getLocalizedText(6, categoryName),
            callback = function()
                setStateSelectSkill(self, categoryName)
            end,
        }
    end

    self.m_ItemsSkillCategories = items
end

local function initItemsSkills(self)
    local items = {}
    for _, categoryName in ipairs(GameConstantFunctions.getCategory("SkillCategories")) do
        local subItems = {}
        for _, skillID in ipairs(GameConstantFunctions.getCategory(categoryName)) do
            subItems[#subItems + 1] = {
                name     = getLocalizedText(5, skillID),
                callback = function()
                    setStateSelectSkillLevel(self, skillID)
                end,
            }
        end
        items[categoryName] = subItems
    end

    self.m_ItemsSkills = items
end

local function initItemsSkillLevels(self)
    local items = {}
    for _, categoryName in ipairs(GameConstantFunctions.getCategory("SkillCategories")) do
        for _, skillID in ipairs(GameConstantFunctions.getCategory(categoryName)) do
            if (items[skillID]) then
                break
            end

            local subItems = {}
            local minLevel, maxLevel = GameConstantFunctions.getSkillLevelMinMax(skillID)
            for i = maxLevel, minLevel, -1 do
                subItems[#subItems + 1] = {
                    name     = string.format("%s %d", getLocalizedText(3, "Level"), i),
                    callback = function()
                        self.m_ModelSkillConfiguration:setSkill(self.m_SkillGroupID, self.m_SlotIndex, self.m_SkillID, i)
                        if (self.m_View) then
                            self.m_View:setOverviewString(self.m_ModelSkillConfiguration:getDescription())
                        end
                    end,
                }
            end

            items[skillID] = subItems
        end
    end

    self.m_ItemsSkillLevels = items
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelSkillConfigurator:ctor()
    self.m_State                   = "stateDisabled"
    self.m_ModelSkillConfiguration = ModelSkillConfiguration:create()

    initItemsAllConfigurations(self)
    initItemsOverview(         self)
    initItemsMaxPoints(        self)
    initItemsEnergyRequirement(self)
    initItemsSkillGroupPassive(self)
    initItemsSkillGroupActive( self)
    initItemsSkillCategories(  self)
    initItemsSkills(           self)
    initItemsSkillLevels(      self)

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

function ModelSkillConfigurator:setModelMessageIndicator(model)
    assert(self.m_ModelMessageIndicator == nil,
        "ModelSkillConfigurator:setModelMessageIndicator() the model has been set already.")
    self.m_ModelMessageIndicator = model

    return self
end

--------------------------------------------------------------------------------
-- The public functions for doing actions.
--------------------------------------------------------------------------------
function ModelSkillConfigurator:doActionGetSkillConfiguration(action)
    if ((self.m_State           == "stateOverviewConfiguration") and
        (self.m_ConfigurationID == action.configurationID))      then
        self.m_ModelSkillConfiguration:ctor(action.configuration)

        local view = self.m_View
        if (view) then
            view:setOverviewString(self.m_ModelSkillConfiguration:getDescription())
                :setButtonSaveEnabled(true)
            for i = 1, #self.m_ItemsOverview do
                view:setItemEnabled(i, true)
            end
        end
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
    elseif (state == "stateSelectSkillCategory") then
        if (self.m_SkillGroupID == SKILL_GROUP_ID_PASSIVE) then setStateOverviewSkillGroupPassive(self)
        else                                                    setStateOverviewSkillGroupActive(self, self.m_SkillGroupID)
        end
    elseif (state == "stateOverviewConfiguration")     then setStateMain(                    self)
    elseif (state == "stateSelectMaxPoint")            then setStateOverviewConfiguration(   self, self.m_ConfigurationID)
    elseif (state == "stateOverviewSkillGroupPassive") then setStateOverviewConfiguration(   self, self.m_ConfigurationID)
    elseif (state == "stateOverviewSkillGroupActive")  then setStateOverviewConfiguration(   self, self.m_ConfigurationID)
    elseif (state == "stateSelectEnergyRequirement")   then setStateOverviewSkillGroupActive(self, self.m_SkillGroupID)
    elseif (state == "stateSelectSkill")               then setStateSelectSkillCategory(     self, self.m_SlotIndex)
    elseif (state == "stateSelectSkillLevel")          then setStateSelectSkill(             self, self.m_CategoryName)
    else   error("ModelSkillConfigurator:onButtonBackTouched() the current state is invalid: " .. state)
    end

    return self
end

function ModelSkillConfigurator:onButtonSaveTouched()
    assert(self.m_State == "stateOverviewConfiguration")
    local isConfigurationValid, err = self.m_ModelSkillConfiguration:isValid()
    if (not isConfigurationValid) then
        self.m_ModelMessageIndicator:showMessage(err)
    else
        self.m_ModelMessageIndicator:showMessage(getLocalizedText(3, "SettingConfiguration"))
        self.m_RootScriptEventDispatcher:dispatchEvent({
            name            = "EvtPlayerRequestDoAction",
            actionName      = "SetSkillConfiguration",
            configurationID = self.m_ConfigurationID,
            configuration   = self.m_ModelSkillConfiguration:toSerializableTable(),
        })

        if (self.m_View) then
            self.m_View:disableButtonSaveForSecs()
        end
    end

    return self
end

return ModelSkillConfigurator
