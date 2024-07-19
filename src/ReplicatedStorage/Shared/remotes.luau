local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remo = require(ReplicatedStorage.Packages.Remo)

local remotes = Remo.createRemotes({
	dispatch = Remo.remote(),
	start = Remo.remote(),
	selectClass = Remo.remote(),
})

return remotes
