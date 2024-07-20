local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Lapis = require(ServerStorage.Packages.Lapis)
local Reflex = require(ReplicatedStorage.Packages.Reflex)

local remotes = require(ReplicatedStorage.Shared.remotes)
local sharedProducers = require(ReplicatedStorage.Shared.SharedProducers)
local rootProducer = require(ServerStorage.Data.RootProducer)

local StarterKatana = ServerStorage.Weapons.Katanas.Katana
local StarterHandCombat = ServerStorage.Weapons.HandCombat.Unarmed

local DEFAULT_DATA = { isNew = true, ko = 0, level = 1, XP = 0, weapons = {}, settings = {} }

local collection = Lapis.createCollection("PlayerData", {
	defaultData = DEFAULT_DATA,
})

local documents = {}

local function addWeapons(player: Player, weaponNames: { string })
	for _, weaponName in weaponNames do
		local weaponTool = ServerStorage.Weapons:FindFirstChild(weaponName, true)
		if weaponTool and not player.StarterGear:FindFirstChild(weaponName) then
			weaponTool:Clone().Parent = player.StarterGear
		end

		if weaponTool and not player.Backpack:FindFirstChild(weaponName) then
			weaponTool:Clone().Parent = player.Backpack
		end
	end
end

local function createSettingsInstance(player: Player, existingData)
	local settings = Instance.new("Configuration")
	settings.Name = "Settings"

	if existingData.settings and typeof(existingData.settings) == "table" then
		for key, value in existingData.settings do
			settings:SetAttribute(key, value)
		end
	end

	settings.Parent = player
end

local function appendValues(existingData)
	local newData = table.clone(existingData)

	for key, value in DEFAULT_DATA do
		if newData[key] == nil then
			print("Added new key", key)
			newData[key] = value
		end
	end

	for key in newData do
		if DEFAULT_DATA[key] == nil then
			print("Removed old key", key)
			newData[key] = nil
		end
	end

	return newData
end

local function onPlayerAdded(player: Player)
	-- The second argument associates the document with the player's UserId which is useful
	-- for GDPR compliance.
	collection
		:load(`Player{player.UserId}`, { player.UserId })
		:andThen(function(document)
			if not player:IsDescendantOf(Players) then
				-- The player might have left before the document finished loading.
				-- The document needs to be closed because PlayerRemoving won't fire at this point
				document:close():catch(warn)
				return
			end

			documents[player] = document
			local data = document:read()

			if data == nil then
				data = DEFAULT_DATA
			else
				data = appendValues(data)
			end

			print("data", data)

			addWeapons(player, data.weapons)
			createSettingsInstance(player, data)
			rootProducer.setPlayerData(player.Name, data)
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
	if document then
		local playerData = rootProducer:getState(function(state)
			return state.playerData[player.Name]
		end)

		document:write(playerData)

		rootProducer.setPlayerData(player.Name, nil)

		documents[player] = nil
		document:close():catch(warn)
	end
end

for _, player in Players:GetPlayers() do
	onPlayerAdded(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- sync
local broadcaster = Reflex.createBroadcaster({
	producers = sharedProducers,
	dispatch = function(player, actions)
		remotes.dispatch:fire(player, actions)
	end,
	beforeDispatch = function(player, action)
		-- the player only receives their own data and no one else's
		if action.arguments[1] ~= player.Name then
			return
		end
		return action
	end,
})

remotes.start:connect(function(player)
	broadcaster:start(player)
end)

remotes.selectClass:connect(function(player, class)
	local isNew = rootProducer:getState(function(state)
		local playerData = state.playerData[player.Name]
		print(playerData)
		if playerData then
			return playerData.isNew
		end

		return false
	end)

	if not isNew then
		return
	end

	if class == "Katanas" then
		rootProducer.addWeapon(player.Name, StarterKatana.Name)
		addWeapons(player, {
			StarterKatana.Name,
		})
	elseif class == "HandCombat" then
		rootProducer.addWeapon(player.Name, StarterHandCombat.Name)
		addWeapons(player, {
			StarterHandCombat.Name,
		})
	end

	rootProducer.setIsNew(player.Name, false)
end)

rootProducer:applyMiddleware(broadcaster.middleware)
