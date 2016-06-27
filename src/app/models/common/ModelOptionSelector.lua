
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

function ModelOptionSelector:setOptions(options)
    self.m_OptionIndex = 1
    self.m_Options     = options

    if (self.m_View) then
        self.m_View:setOptionText(options[1].text)
    end

    return self
end

function ModelOptionSelector:getCurrentOption()
    return (self.m_Options) and (self.m_Options[self.m_OptionIndex].data) or nil
end

function ModelOptionSelector:onButtonPrevTouched()
    if (self.m_Options) then
        self.m_OptionIndex = getPrevOptionIndex(self.m_Options, self.m_OptionIndex)

        if (self.m_View) then
            self.m_View:setOptionText(self.m_Options[self.m_OptionIndex].text)
        end
    end

    return self
end

function ModelOptionSelector:onButtonNextTouched()
    if (self.m_Options) then
        self.m_OptionIndex = getNextOptionIndex(self.m_Options, self.m_OptionIndex)

        if (self.m_View) then
            self.m_View:setOptionText(self.m_Options[self.m_OptionIndex].text)
        end
    end

    return self
end

return ModelOptionSelector
