local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Reflex = require(ReplicatedStorage.Packages.Reflex)

local setIsClassSelectorOpen = require(script.Parent.Actions.setIsClassSelectorOpen)
local InitialState = require(script.Parent.InitialState)

local producer = Reflex.createProducer(InitialState, {
	setIsClassSelectorOpen = setIsClassSelectorOpen,
})

return producer
