local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Reflex = require(Packages.Reflex)

local Actions = script.Parent.Actions
local setIsSettingsOpen = require(Actions.setIsSettingsOpen)
local setSetting = require(Actions.setSetting)

local InitialState = require(script.Parent.InitialState)

local producer = Reflex.createProducer(InitialState, {
	setIsSettingsOpen = setIsSettingsOpen,
	setSetting = setSetting,
})

return producer
