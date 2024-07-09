local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Reflex = require(Packages.Reflex)

local Apps = script.Parent

local shopProducer = require(Apps.Shop.Producer)

return Reflex.combineProducers({
	shop = shopProducer,
})
