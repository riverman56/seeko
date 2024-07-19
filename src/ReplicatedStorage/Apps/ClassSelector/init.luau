local Lighting = game:GetService("Lighting")
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

local playerData = rootProducer:getState(function(state)
	return state.playerData[localPlayer.Name]
end)

if playerData and playerData.isNew then
	rootProducer.setIsClassSelectorOpen(true)
end

rootProducer:subscribe(function(state)
	local data = state.playerData[localPlayer.Name] or {}
	return data.isNew
end, function(isNew)
	if isNew then
		rootProducer.setIsClassSelectorOpen(true)
	end
end)

rootProducer:subscribe(function(state)
	return state.classSelector.isOpen
end, function(isOpen)
	Lighting.Blur.Size = if isOpen then 30 else 0
end)

return function()
	local root = ReactRoblox.createRoot(Instance.new("Folder"))
	root:render(ReactRoblox.createPortal(app, localPlayer.PlayerGui))
end
