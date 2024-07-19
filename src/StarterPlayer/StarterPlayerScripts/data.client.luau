local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

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

local devtoolsEvent = ReplicatedStorage:FindFirstChild("REFLEX_DEVTOOLS")

local function devtoolsMiddleware()
	return function(nextAction, actionName)
		return function(...)
			local state = nextAction(...)
			if RunService:IsStudio() and devtoolsEvent then
				devtoolsEvent:FireServer({
					name = actionName,
					args = { ... },
					state = state,
				})
			end

			return state
		end
	end
end

rootProducer:applyMiddleware(receiver.middleware, devtoolsMiddleware)
