
local Requirer = {}

function Requirer.templateTileMap(mapName)
	return require("res.Templates.TileMap." .. mapName)
end

function Requirer.templateUnitMap(mapName)
	return require("res.Templates.UnitMap." .. mapName)
end

function Requirer.templateWarField(fieldName)
	return require("res.Templates.WarField." .. fieldName)
end

function Requirer.templateWarScene(sceneName)
	return require("res.Templates.WarScene." .. sceneName)
end

function Requirer.component(componentName)
	return require("app.components." .. componentName)
end

function Requirer.view(viewName)
	return require("app.views." .. viewName)
end

function Requirer.utility(utilityName)
	return require("app.utilities." .. utilityName)
end

function Requirer.gameConstant()
	return require("res.GameConstant")
end

return Requirer
