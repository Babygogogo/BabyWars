
local TypeChecker = {}

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

local function isInt(checkee, checkeeName)
	if (not isExpectedType(checkee, checkeeName, {"number"})) then
		return false, string.format("%s is not a number.", checkeeName)
	elseif (math.floor(checkee) == checkee) then
		return true, string.format("%s is an integer.", checkeeName)
	else
		return false, string.format("%s is a number but not an integer.", checkeeName)
	end
end

local function isLargerThan(checkee, checkeeName, checkParams)
	if (checkee > checkParams) then
		return true, string.format("%s > %s", checkeeName, checkParams)
	else
		return false, string.format("%s <= %s", checkeeName, checkParams)
	end
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

local isIntWrapper = "isInt"
TypeChecker[isIntWrapper] = function(param)
	return	check(isIntWrapper, isInt, param, "param", {"number"})
end

-- GridIndex: {rowIndex : number_int, colIndex : number_int}
local isGridIndex = "isGridIndex"
TypeChecker[isGridIndex] = function(gridIndex)
	return	check(isGridIndex, isExpectedType,	gridIndex,			"gridIndex",			{"table"}	)
		and	check(isGridIndex, isInt,			gridIndex.rowIndex,	"gridIndex.rowIndex"				)
		and	check(isGridIndex, isInt,			gridIndex.colIndex,	"gridIndex.colIndex"				)
end

-- MapSize: {rowCount : number_int_>0, colCount : number_int_>0}
local isMapSize = "isMapSize"
TypeChecker[isMapSize] = function(mapSize)
	return	check(isMapSize, isExpectedType,	mapSize,			"mapSize",			{"table"}	)
		and	check(isMapSize, isInt,				mapSize.rowCount,	"mapSize.rowCount"				)
		and	check(isMapSize, isInt,				mapSize.colCount,	"mapSize.colCount"				)
		and check(isMapSize, isLargerThan,		mapSize.rowCount,	"mapSize.rowCount",	0			)
		and check(isMapSize, isLargerThan,		mapSize.colCount,	"mapSize.colCount",	0			)
end

return TypeChecker
