local ReplicatedStorage = game:GetService("ReplicatedStorage")

local root = require(ReplicatedStorage.Shared.RootProducer)

root:subscribe(function(new, old)
	print(new)
end)
