local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Reflex = require(Packages.Reflex)

local Actions = script.Parent.Actions
local setSelectedCategory = require(Actions.setSelectedCategory)
local setSelectedItem = require(Actions.setSelectedItem)

local InitialState = require(script.Parent.InitialState)

local producer = Reflex.createProducer(InitialState, {
	setSelectedCategory = setSelectedCategory,
	setSelectedItem = setSelectedItem,
})

return producer
