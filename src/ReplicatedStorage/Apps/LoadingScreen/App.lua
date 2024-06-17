local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)

local Components = script.Parent.Components
local Background = require(Components.Background)
local LoadingBar = require(Components.LoadingBar)

local App = React.Component:extend("App")

function App:render()
	return React.createElement("ScreenGui", {
		DisplayOrder = 999999999,
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
	}, {
		Background = Background(),
		LoadingBar = LoadingBar(0.5),
	})
end

return App
