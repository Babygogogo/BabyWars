
--[[--------------------------------------------------------------------------------
-- ModelWeatherManager是战局上的天气管理器，负责维护有关天气的数据。
--
-- 主要职责：
--   同上
--
-- 使用场景举例：
--   - 回合切换时，根据战局设定决定是否切换天气
--   - 发动特定co技能时切换天气
--
-- 其他：
--   目前还没有正式开始实现天气功能。
--]]--------------------------------------------------------------------------------

local ModelWeatherManager = requireBW("src.global.functions.class")("ModelWeatherManager")

local WEATHER_CODES = {
    Clear = 1,
    Rainy = 2,
    Snowy = 3,
    Sandy = 4,
}
local s_WeatherNames

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelWeatherManager:ctor(param)
    self.m_CurrentWeatherCode            = param.currentWeatherCode or param.defaultWeatherCode
    self.m_DefaultWeatherCode            = param.defaultWeatherCode
    self.m_ExpiringPlayerIndexForWeather = param.expiringPlayerIndexForWeather
    self.m_ExpiringTurnIndexForWeather   = param.expiringTurnIndexForWeather

    return self
end

--------------------------------------------------------------------------------
-- The functions for serialization.
--------------------------------------------------------------------------------
function ModelWeatherManager:toSerializableTable()
    return {
        currentWeatherCode            = (self.m_CurrentWeatherCode ~= self.m_DefaultWeatherCode) and (self.m_CurrentWeatherCode) or (nil),
        defaultWeatherCode            = self.m_DefaultWeatherCode,
        expiringPlayerIndexForWeather = self.m_ExpiringPlayerIndexForWeather,
        expiringTurnIndexForWeather   = self.m_ExpiringTurnIndexForWeather,
    }
end

function ModelWeatherManager:toSerializableTableForPlayerIndex(playerIndex)
    return self:toSerializableTable()
end

function ModelWeatherManager:toSerializableReplayData()
    return {defaultWeatherCode = self.m_DefaultWeatherCode}
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelWeatherManager.getWeatherName(weatherCode)
    if (not s_WeatherNames) then
        s_WeatherNames = {}
        for name, code in pairs(WEATHER_CODES) do
            s_WeatherNames[code] = name
        end
    end

    local name = s_WeatherNames[weatherCode]
    assert(name, "ModelWeatherManager.getWeatherName() invalid weatherCode: " .. (weatherCode or ""))
    return name
end

return ModelWeatherManager
