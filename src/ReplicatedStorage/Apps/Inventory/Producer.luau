local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Reflex = require(Packages.Reflex)

local Actions = script.Parent.Actions
local setSelectedInventoryItem = require(Actions.setSelectedInventoryItem)
local setSelectedInventoryCategory = require(Actions.setSelectedInventoryCategory)
local setIsInventoryOpen = require(Actions.setIsInventoryOpen)

local InitialState = require(script.Parent.InitialState)

local producer = Reflex.createProducer(InitialState, {
	setSelectedInventoryCategory = setSelectedInventoryCategory,
	setSelectedInventoryItem = setSelectedInventoryItem,
	setIsInventoryOpen = setIsInventoryOpen,
})

return producer
