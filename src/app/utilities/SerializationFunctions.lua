
local SerializationFunctions = {}

function SerializationFunctions.serialize(o, spaces)
    spaces = spaces or ""
    local subSpaces = spaces .. " "

    if (type(o) == "number") then
        return "" .. o
    elseif (type(o) == "string") then
        return string.format("%q", o)
    elseif (type(o) == "boolean") then
        return (o) and ("true") or ("false")
    elseif (type(o) == "table") then
        local strList = {"{\n"}
        for k, v in pairs(o) do
            strList[#strList + 1] = subSpaces
            if (type(k) ~= "number") then
                strList[#strList + 1] = "" .. k .. " = "
            end
            strList[#strList + 1] = SerializationFunctions.serialize(v, subSpaces)
            strList[#strList + 1] = ",\n"
        end
        strList[#strList + 1] = spaces .. "}"

        return table.concat(strList)
    else
        error("cannot serialize a " .. type(o))
    end
end

return SerializationFunctions
