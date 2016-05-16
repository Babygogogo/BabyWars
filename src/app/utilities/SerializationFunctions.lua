
local SerializationFunctions = {}

function SerializationFunctions.serialize(o)
    if (type(o) == "number") then
        return "" .. o
    elseif (type(o) == "string") then
        return string.format("%q", o)
    elseif (type(o) == "boolean") then
        return (o) and ("true") or ("false")
    elseif (type(o) == "table") then
        local strList = {"{\n"}
        for k, v in pairs(o) do
            if (type(k) ~= "number") then
                strList[#strList + 1] = " " .. k .. " = "
            end
            strList[#strList + 1] = SerializationFunctions.serialize(v)
            strList[#strList + 1] = ",\n"
        end
        strList[#strList + 1] = "}"

        return table.concat(strList)
    else
        error("cannot serialize a " .. type(o))
    end
end

return SerializationFunctions
