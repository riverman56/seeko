local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Reflex = require(Packages.Reflex)

local Apps = ReplicatedStorage.Apps

local shopProducer = require(Apps.Shop.Producer)
local menuProducer = require(Apps.Menu.Producer)
local settingsProducer = require(Apps.Settings.Producer)
local classSelectorProducer = require(Apps.ClassSelector.Producer)
local inventoryProducer = require(Apps.Inventory.Producer)

local sharedProducers = require(script.Parent.SharedProducers)

local rootSlices = {
	shop = shopProducer,
	menu = menuProducer,
	settings = settingsProducer,
	inventory = inventoryProducer,
	classSelector = classSelectorProducer,
}

for name, producer in sharedProducers do
	rootSlices[name] = producer
end

return Reflex.combineProducers(rootSlices)
