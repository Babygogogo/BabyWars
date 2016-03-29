
local ModelWeatherManager = class("ModelWeatherManager")

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelWeatherManager:ctor(param)
    self.m_CurrentWeather = param.current
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelWeatherManager:getCurrentWeather()
    return self.m_CurrentWeather
end

function ModelWeatherManager:getNextWeather()
    -- TODO: add code to do the real job.
    return self.m_CurrentWeather
end

return ModelWeatherManager
