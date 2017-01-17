
local TableFunctions = {}

local pairs = pairs

function TableFunctions.appendList(list1, list2, additionalItem)
    assert(type(list1) == "table", "TableFunctions.appendList() the param list1 is invalid.")
    assert((type(list2) == "table") or (list2 == nil), "TableFunctions.appendList() the param list2 is invalid.")

    local length1, length2 = #list1, #(list2 or {})
    for i = 1, length2 do
        list1[length1 + i] = list2[i]
    end

    if (length2 > 0) then
        list1[length1 + length2 + 1] = additionalItem
    end
end

function TableFunctions.union(t1, t2)
    if ((t1 == nil) and (t2 == nil)) then
        return nil
    end

    local t = {}
    for k, v in pairs(t1 or {}) do
        t[k] = v
    end
    for k, v in pairs(t2 or {}) do
        t[k] = v
    end

    return t
end

function TableFunctions.clone(t, ignoredKeys)
    local clonedTable = {}
    for k, v in pairs(t) do
        clonedTable[k] = v
    end

    if (ignoredKeys) then
        for _, ignoredKey in pairs(ignoredKeys) do
            clonedTable[ignoredKey] = nil
        end
    end

    return clonedTable
end

function TableFunctions.deepClone(t)
    if (type(t) ~= "table") then
        return t
    else
        local clonedTable = {}
        for k, v in pairs(t) do
            clonedTable[TableFunctions.deepClone(k)] = TableFunctions.deepClone(v)
        end
        return clonedTable
    end
end

function TableFunctions.getPairsCount(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end

    return count
end

return TableFunctions
