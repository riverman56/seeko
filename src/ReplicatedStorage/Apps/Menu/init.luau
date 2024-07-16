local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactReflex = require(Packages.ReactReflex)
local ReactRoblox = require(Packages.ReactRoblox)

local Components = script.Components
local Items = require(Components.Items)
local Button = require(Components.Button)

local rootProducer = require(ReplicatedStorage.Shared.RootProducer)

local app = React.createElement(ReactReflex.ReflexContext.Provider, {
	value = rootProducer,
}, {
	React.createElement("ScreenGui", {
		ResetOnSpawn = false,
		Enabled = true,
	}, {
		React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 14),
			PaddingLeft = UDim.new(0, 14),
		}),

		React.createElement(Items),
		React.createElement(Button),
	}),
})

return function()
	local root = ReactRoblox.createRoot(Instance.new("Folder"))
	root:render(ReactRoblox.createPortal(app, Players.LocalPlayer.PlayerGui))
end
