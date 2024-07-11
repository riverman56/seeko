local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Reflex = require(ReplicatedStorage.Packages.Reflex)
local rootProducer = require(ReplicatedStorage.Shared.RootProducer)

local remotes = require(ReplicatedStorage.Shared.remotes)

local receiver = Reflex.createBroadcastReceiver({
	start = function()
		remotes.start:fire()
	end,
})

remotes.dispatch:connect(function(actions)
	receiver:dispatch(actions)
end)

rootProducer:applyMiddleware(receiver.middleware)
