
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

local ModelWeatherManager = require("src.global.functions.class")("ModelWeatherManager")

local TableFunctions      = require("src.app.utilities.TableFunctions")

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelWeatherManager:ctor(param)
    self.m_CurrentWeather = param.current
end

--------------------------------------------------------------------------------
-- The functions for serialization.
--------------------------------------------------------------------------------
function ModelWeatherManager:toSerializableTable()
    return {
        current = self:getCurrentWeather(),
    }
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

function ModelWeatherManager:isInFog()
    -- TODO: add code to do the real job.
    return false
end

return ModelWeatherManager
