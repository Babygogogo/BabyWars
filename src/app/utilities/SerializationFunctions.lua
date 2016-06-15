
local SerializationFunctions = {}

local INDENT_SPACES = " "

function SerializationFunctions.toString(o, spaces)
    spaces = spaces or ""
    local subSpaces = spaces .. INDENT_SPACES

    if (type(o) == "number") then
        return "" .. o
    elseif (type(o) == "string") then
        return string.format("%q", o)
    elseif (type(o) == "boolean") then
        return (o) and ("true") or ("false")
    elseif (type(o) == "table") then
        local strList = {"{\n"}
        for k, v in pairs(o) do
            local keyType = type(k)
            if (keyType == "number") then
                strList[#strList + 1] = string.format("%s[%d] = ", subSpaces, k)
            elseif (keyType == "string") then
                strList[#strList + 1] = string.format("%s[%q] = ", subSpaces, k)
            else
                error("SerializationFunctions.toString() cannot serialize a key with " .. keyType)
            end

            strList[#strList + 1] = SerializationFunctions.toString(v, subSpaces)
            strList[#strList + 1] = ",\n"
        end
        strList[#strList + 1] = spaces .. "}"

        return table.concat(strList)
    else
        error("SerializationFunctions.toString() cannot serialize a " .. type(o))
    end
end

function SerializationFunctions.appendToFile(o, spaces, file)
    spaces = spaces or ""
    local subSpaces = spaces .. INDENT_SPACES

    local t = type(o)
    if (t == "number") then
        file:write(o)
    elseif (t == "string") then
        file:write(string.format("%q", o))
    elseif (t == "boolean") then
        file:write(o and "true" or "false")
    elseif (t == "table") then
        file:write("{\n")

        for k, v in pairs(o) do
            local keyType = type(k)
            if (keyType == "number") then
                file:write(string.format("%s[%d] = ", subSpaces, k))
            elseif (keyType == "string") then
                file:write(string.format("%s[%q] = ", subSpaces, k))
            else
                error("SerializationFunctions.appendToFile() cannot serialize a key with type " .. keyType)
            end

            SerializationFunctions.appendToFile(v, subSpaces, file)
            file:write(",\n")
        end

        file:write(spaces, "}")
    else
        error("SerializationFunctions.appendToFile() cannot serialize a key with type " .. keyType)
    end
end

return SerializationFunctions
