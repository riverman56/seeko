local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Reflex = require(Packages.Reflex)

local Actions = script.Parent.Actions
local setSelectedShopCategory = require(Actions.setSelectedShopCategory)
local setSelectedShopItem = require(Actions.setSelectedShopItem)
local setIsShopOpen = require(Actions.setIsShopOpen)

local InitialState = require(script.Parent.InitialState)

local producer = Reflex.createProducer(InitialState, {
	setSelectedShopCategory = setSelectedShopCategory,
	setSelectedShopItem = setSelectedShopItem,
	setIsShopOpen = setIsShopOpen,
})

return producer
