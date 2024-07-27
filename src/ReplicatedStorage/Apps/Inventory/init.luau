local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactReflex = require(Packages.ReactReflex)
local ReactRoblox = require(Packages.ReactRoblox)

local Components = script.Components
local Base = require(Components.Base)

local rootProducer = require(ReplicatedStorage.Shared.RootProducer)

local localPlayer = Players.LocalPlayer

local app = React.createElement(ReactReflex.ReflexContext.Provider, {
	value = rootProducer,
}, {
	React.createElement("ScreenGui", {
		ResetOnSpawn = false,
		Enabled = true,
	}, {
		React.createElement(Base),
	}),
})

return function()
	local root = ReactRoblox.createRoot(Instance.new("Folder"))
	root:render(ReactRoblox.createPortal(app, localPlayer.PlayerGui))
end
