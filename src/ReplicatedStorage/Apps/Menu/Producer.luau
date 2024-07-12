local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Reflex = require(Packages.Reflex)

local Actions = script.Parent.Actions
local setIsOpen = require(Actions.setIsOpen)

local InitialState = require(script.Parent.InitialState)

local producer = Reflex.createProducer(InitialState, {
	setIsOpen = setIsOpen,
})

return producer
