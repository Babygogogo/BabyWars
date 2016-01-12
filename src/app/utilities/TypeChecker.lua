
local TypeChecker = {}

local function isInt(checkee, checkeeName)
	if (math.floor(checkee) == checkee) then
		return true, string.format("%s is an integer.", checkeeName)
	else
		return false, string.format("%s is not an integer.", checkeeName)
	end
end

local function isExpectedType(checkee, checkeeName, checkParams)
	local checkeeType = type(checkee)
	local expectedTypeNames = ""
	for _, expectedType in ipairs(checkParams) do
		if (checkeeType == expectedType) then
			return true, string.format("%s is a %s, as expected.", checkeeName, expectedType)
		end
		expectedTypeNames = expectedTypeNames .. expectedType
	end
	return false, string.format("%s is a %s; expected one of: %s", checkeeName, checkeeType, expectedTypeNames)
end

local function check(callerName, checker, checkee, checkeeName, checkParams)
	local checkResult, checkMsg = checker(checkee, checkeeName, checkParams)
	if (checkResult) then
		return true
	else
		print(string.format("TypeChecker.%s() %s", callerName, checkMsg))
		return false
	end
end

-- GridIndex: {rowIndex : number_int, colIndex : number_int}
local isGridIndex = "isGridIndex"
TypeChecker[isGridIndex] = function(gridIndex)
	return	check(isGridIndex, isExpectedType, gridIndex, 			"gridIndex",			{"table"})
		and check(isGridIndex, isExpectedType, gridIndex.rowIndex,	"gridIndex.rowIndex",	{"number"})
		and check(isGridIndex, isExpectedType, gridIndex.colIndex,	"gridIndex.colIndex",	{"number"})
		and	check(isGridIndex, isInt, gridIndex.rowIndex, "gridIndex.rowIndex")
		and	check(isGridIndex, isInt, gridIndex.colIndex, "gridIndex.colIndex")
		
end

return TypeChecker
