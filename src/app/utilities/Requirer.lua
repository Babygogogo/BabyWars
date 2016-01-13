
local Requirer = {}

function Requirer.templateTileMap(mapName)
	return require("res.Templates.TileMap." .. mapName)
end

function Requirer.templateWarField(fieldName)
	return require("res.Templates.WarField." .. fieldName)
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
