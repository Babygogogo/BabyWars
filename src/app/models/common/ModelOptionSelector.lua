
local ModelOptionSelector = class("ModelOptionSelector")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getNextOptionIndex(options, currentIndex)
    return (currentIndex < #options) and (currentIndex + 1) or (1)
end

local function getPrevOptionIndex(options, currentIndex)
    return (currentIndex > 1) and (currentIndex - 1) or (#options)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelOptionSelector:ctor(titleText)
    self.m_TitleText = titleText or ""

    return self
end

function ModelOptionSelector:initView()
    assert(self.m_View, "ModelOptionSelector:initView() no view is attached to the owner actor of the model.")
    self.m_View:setTitleText(self.m_TitleText)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelOptionSelector:setButtonsEnabled(enabled)
    if (self.m_View) then
        self.m_View:setButtonsEnabled(enabled)
    end

    return self
end

function ModelOptionSelector:setOptionIndicatorTouchEnabled(enabled)
    if (self.m_View) then
        self.m_View:setOptionIndicatorTouchEnabled(enabled)
    end

    return self
end

function ModelOptionSelector:setOptions(options)
    self.m_Options = options
    self:setCurrentOptionIndex(1)

    return self
end

function ModelOptionSelector:getCurrentOption()
    assert(self.m_Options, "ModelOptionSelector:getCurrentOption() no option has been set yet.")
    return self.m_Options[self.m_OptionIndex].data
end

function ModelOptionSelector:setCurrentOptionIndex(index)
    local options = self.m_Options
    assert((index > 0) and (index <= #options) and (index == math.floor(index)),
        "ModelOptionSelector:setCurrentOptionIndex() the param index is invalid.")

    self.m_OptionIndex = index
    local option = options[index]
    if (option.callbackOnSwitched) then
        option.callbackOnSwitched()
    end
    if (self.m_View) then
        self.m_View:setOptionText(option.text)
    end

    return self
end

function ModelOptionSelector:onButtonPrevTouched()
    self:setCurrentOptionIndex(getPrevOptionIndex(self.m_Options, self.m_OptionIndex))

    return self
end

function ModelOptionSelector:onButtonNextTouched()
    self:setCurrentOptionIndex(getNextOptionIndex(self.m_Options, self.m_OptionIndex))

    return self
end

function ModelOptionSelector:onOptionIndicatorTouched()
    local callback = self.m_Options[self.m_OptionIndex].callbackOnOptionIndicatorTouched
    if (callback) then
        callback()
    end

    return self
end

return ModelOptionSelector
