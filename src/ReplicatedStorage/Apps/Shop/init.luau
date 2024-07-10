local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactReflex = require(Packages.ReactReflex)
local ReactRoblox = require(Packages.ReactRoblox)

local Components = script.Components
local Base = require(Components.Base)

local RootProducer = require(script.Parent.RootProducer)

--[[local app = ReactReflex.ReflexProvider({
	producer = RootProducer,
	children = {
		React.createElement("ScreenGui", {
			ResetOnSpawn = false,
		}, {
			React.createElement(Base),
		}),
	},
})]]

local app = React.createElement(ReactReflex.ReflexContext.Provider, {
	value = RootProducer,
}, {
	React.createElement("ScreenGui", {
		ResetOnSpawn = false,
	}, {
		React.createElement(Base),
	}),
})

return function()
	local root = ReactRoblox.createRoot(Instance.new("Folder"))
	root:render(ReactRoblox.createPortal(app, Players.LocalPlayer.PlayerGui))
end
