local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Reflex = require(Packages.Reflex)

local Actions = script.Parent.Actions
local setIsMenuOpen = require(Actions.setIsMenuOpen)

local InitialState = require(script.Parent.InitialState)

local producer = Reflex.createProducer(InitialState, {
	setIsMenuOpen = setIsMenuOpen,
})

return producer
