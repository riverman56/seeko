task.wait()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")

local Attributes = {
	["Character"] = {},
	["Player"] = {
		["FunkyCamera"] = true,
		["Hitbox"] = false,
	},
	["Humanoid"] = {
		["Stamina"] = 200,
		["MaxStamina"] = 200,
		["DefMaxStamina"] = 200,
		["Guard"] = false,
		["Stun"] = false,
		["Running"] = false,
		["CombatTime"] = 0,
	},
}

local JanitorStorage = {}
local CharacterJanitorStuff = {}

local Janitor = require(ReplicatedStorage.Modules.Utility.Janitor)

local ProfileHandler = require(ServerStorage.Modules.Data.ProfileHandler)

-- Debugging Handle stuff, only for studio
for _, Object in game:GetDescendants() do
	if not Object:IsA("BasePart") then
		continue
	end

	if Object:GetAttribute("NoDebug") ~= nil then
		Object.Transparency = 1
		continue
	end

	if Object:GetAttribute("MainHandle") ~= nil then
		Object.Color = Color3.fromRGB(0, 255, 0)
		Object.Material = Enum.Material.SmoothPlastic
		Object.Transparency = 1

		if RunService:IsStudio() then
			Object.Transparency = 0
		end
	elseif Object:GetAttribute("SheathHandle") ~= nil then
		Object.Color = Color3.fromRGB(255, 0, 0)
		Object.Material = Enum.Material.SmoothPlastic
		Object.Transparency = 1

		if RunService:IsStudio() then
			Object.Transparency = 0
		end
	end
end

if not RunService:IsStudio() then
	workspace.Music.Playing = true
end

local function HandleCharacterSpawn(Player: Player)
	local Character = Player.Character or Player.CharacterAdded:Wait()

	if not Character:IsDescendantOf(workspace) then
		repeat
			task.wait()
		until Character:IsDescendantOf(workspace)
	end

	RunService.Stepped:Wait()

	local NewCharacterJanitor = Janitor.new()
	NewCharacterJanitor:LinkToInstances(Player, Character)
	CharacterJanitorStuff[Player] = NewCharacterJanitor

	local Humanoid = Character:WaitForChild("Humanoid")

	Character.Parent = workspace.Users
	Character.PrimaryPart = Character:FindFirstChild("HumanoidRootPart")

	for AttributeName, AttributeValue in Attributes.Character do
		Character:SetAttribute(AttributeName, AttributeValue)
	end

	for AttributeName, AttributeValue in Attributes.Humanoid do
		Humanoid:SetAttribute(AttributeName, AttributeValue)
	end

	for _, Item: BasePart in Character:GetDescendants() do
		if not Item:IsA("BasePart") then
			continue
		end

		Item.CollisionGroup = "Players"
		Item.Locked = false
	end

	Humanoid.Died:Once(function()
		print("Died")

		local Tags = Character.TagFolder:GetChildren()

		local DivideBy = math.clamp(#Tags - 2, 1, math.huge)

		for _, Tag in Tags do
			if not Tag:IsA("ObjectValue") then
				continue
			end

			local TagPlayer = Players:GetPlayerFromCharacter(Tag.Value)

			if TagPlayer == Player or TagPlayer == nil then
				continue
			end

			local TagCharacter = Tag.Value
			local TagHumanoid = TagCharacter:FindFirstChildOfClass("Humanoid")

			if not TagCharacter or not TagHumanoid then
				continue
			end

			TagHumanoid.MaxHealth = TagHumanoid:GetAttribute("DefMaxHealth")
			TagHumanoid.Health = TagHumanoid.MaxHealth

			TagHumanoid:SetAttribute("MaxStamina", TagHumanoid:GetAttribute("DefMaxStamina"))
			TagHumanoid:SetAttribute("Stamina", TagHumanoid:GetAttribute("MaxStamina"))
		end
	end)

	local TagFolder = Instance.new("Folder")
	TagFolder.Name = "TagFolder"
	TagFolder.Parent = Character

	local LastTimeUpdate = 0

	task.spawn(function()
		NewCharacterJanitor:Add(
			RunService.Stepped:Connect(function()
				if os.clock() - LastTimeUpdate >= 1 then
					LastTimeUpdate = os.clock()

					if Humanoid:GetAttribute("CombatTime") > 0 then
						Humanoid:SetAttribute("CombatTime", Humanoid:GetAttribute("CombatTime") - 1)
					end

					if Humanoid:GetState() == Enum.HumanoidStateType.Dead then
						NewCharacterJanitor:Destroy()
						return
					end
				end
			end),
			"Disconnect"
		)
	end)
end

local function HandlePlayerAdded(Player: Player)
	local PlayerProfile = ProfileHandler.Add(Player)

	if not PlayerProfile then
		Player:Kick("Could not retrieve Profile")
		return
	end

	-- Flush out old or outdated values and add new ones if required
	task.defer(function()
		for AttributeName, AttributeValue in Attributes.Player do
			Player:SetAttribute(AttributeName, AttributeValue)
		end

		for Index, Value in ProfileHandler.DefaultData do
			if not PlayerProfile.Data[Index] then
				PlayerProfile.Data[Index] = Value
			end
		end

		for Name, _ in PlayerProfile.Data do
			if not ProfileHandler.DefaultData[Name] then
				PlayerProfile.Data[Name] = nil
			end
		end
	end)

	local NewJanitor = Janitor.new()
	NewJanitor:LinkToInstance(Player)

	JanitorStorage[Player] = NewJanitor

	task.defer(function()
		NewJanitor:Add(function()
			print(Player.Name, "removing")
		end, true)
	end)

	if Player.Character then
		task.defer(HandleCharacterSpawn, Player)
	end

	Player.CharacterAdded:Connect(function()
		HandleCharacterSpawn(Player)
	end)

	Player.CharacterRemoving:Connect(function()
		local CharacterJanitor = CharacterJanitorStuff[Player]

		if CharacterJanitor ~= nil and CharacterJanitor.Destroy ~= nil then
			CharacterJanitor:Destroy()
			CharacterJanitor = nil
		end
	end)
end

local function HandlePlayerRemoving(Player: Player)
	local PlayerJanitor = JanitorStorage[Player]

	if PlayerJanitor ~= nil then
		PlayerJanitor:Destroy()
		PlayerJanitor = nil
	end

	ProfileHandler.Remove(Player)
end

for _, Player in Players:GetPlayers() do
	task.defer(HandlePlayerAdded, Player)
end

Players.PlayerAdded:Connect(HandlePlayerAdded)
Players.PlayerRemoving:Connect(HandlePlayerRemoving)
