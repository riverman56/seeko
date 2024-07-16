local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Reflex = require(Packages.Reflex)

local Apps = ReplicatedStorage.Apps

local shopProducer = require(Apps.Shop.Producer)
local menuProducer = require(Apps.Menu.Producer)

local sharedProducers = require(script.Parent.SharedProducers)

local rootSlices = {
	shop = shopProducer,
	menu = menuProducer,
}

for name, producer in sharedProducers do
	rootSlices[name] = producer
end

return Reflex.combineProducers(rootSlices)
