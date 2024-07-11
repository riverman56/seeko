local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Lapis = require(ServerStorage.Packages.Lapis)
local Reflex = require(ReplicatedStorage.Packages.Reflex)

local remotes = require(ReplicatedStorage.Shared.remotes)
local sharedProducers = require(ReplicatedStorage.Shared.SharedProducers)
local rootProducer = require(ServerStorage.Data.RootProducer)

local DEFAULT_DATA = { ko = 0 }

local collection = Lapis.createCollection("PlayerData", {
	defaultData = DEFAULT_DATA,
})

local documents = {}

local function onPlayerAdded(player: Player)
	-- The second argument associates the document with the player's UserId which is useful
	-- for GDPR compliance.
	collection
		:load(`Player{player.UserId}`, { player.UserId })
		:andThen(function(document)
			if player.Parent == nil then
				-- The player might have left before the document finished loading.
				-- The document needs to be closed because PlayerRemoving won't fire at this point.
				document:close():catch(warn)
				return
			end

			documents[player] = document
			rootProducer.setPlayerData(player.Name, document:read())
		end)
		:catch(function(message)
			warn(`Player {player.Name}'s data failed to load: {message}`)

			-- Optionally, you can kick the player when their data fails to load:
			player:Kick("Data failed to load.")
		end)
end

local function onPlayerRemoving(player: Player)
	local document = documents[player]

	-- The document won't be added to the dictionary if PlayerRemoving fires bofore it finishes loading.
	if document ~= nil then
		documents[player] = nil
		document:close():catch(warn)
	end
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

for _, player in Players:GetPlayers() do
	onPlayerAdded(player)
end

-- sync
local broadcaster = Reflex.createBroadcaster({
	producers = sharedProducers,
	dispatch = function(player, actions)
		remotes.dispatch:fire(player, actions)
	end,
	beforeDispatch = function(player, action)
		-- the player only receives their own data and no one else's
		if action.name == "setPlayerData" and action.arguments[1] ~= player.Name then
			return
		end
		return action
	end,
})

remotes.start:connect(function(player)
	broadcaster:start(player)
end)

rootProducer:applyMiddleware(broadcaster.middleware)
