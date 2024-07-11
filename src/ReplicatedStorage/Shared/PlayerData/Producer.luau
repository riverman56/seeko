local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Reflex = require(ReplicatedStorage.Packages.Reflex)

local Actions = script.Parent.Actions
local setPlayerData = require(Actions.setPlayerData)

local producer = Reflex.createProducer({}, {
	setPlayerData = setPlayerData,
})

return producer
