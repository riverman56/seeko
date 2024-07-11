local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Reflex = require(ReplicatedStorage.Packages.Reflex)

local sharedProducers = require(ReplicatedStorage.Shared.SharedProducers)

local rootSlices = {}

for name, producer in sharedProducers do
	rootSlices[name] = producer
end

return Reflex.combineProducers(rootSlices)
