local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Reflex = require(ReplicatedStorage.Packages.Reflex)

local Actions = script.Parent.Actions
local setPlayerData = require(Actions.setPlayerData)
local setIsNew = require(Actions.setIsNew)
local addWeapon = require(Actions.addWeapon)
local removeWeapon = require(Actions.removeWeapon)

local producer = Reflex.createProducer({}, {
	setPlayerData = setPlayerData,
	removeWeapon = removeWeapon,
	addWeapon = addWeapon,
	setIsNew = setIsNew,
})

return producer
