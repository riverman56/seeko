local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")

local Attributes = {
    ["Character"] = {},
    ["Player"] = {},
    ["Humanoid"] = {
        ["Stamina"] = 100,
        ["MaxStamina"] = 100,
        ["DefMaxStamina"] = 100,
        ["Guard"] = false,
        ["Stun"] = false,
    },
}

local JanitorStorage = {}

local Janitor = require(ReplicatedStorage.Modules.Utility.Janitor)

local ProfileHandler = require(ServerStorage.Modules.Data.ProfileHandler)

-- Debugging Handle stuff, only for studio
for _, Object in game:GetDescendants() do
    if not Object:IsA("BasePart") then
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

local function HandleCharacterSpawn(Player : Player)
    local Character = Player.Character or Player.CharacterAdded:Wait()

    if not Character:IsDescendantOf(workspace) then
        repeat task.wait()
        until Character:IsDescendantOf(workspace)
    end

    local Humanoid = Character:WaitForChild("Humanoid")

    Character.Parent = workspace.Users
    Character.PrimaryPart = Character:FindFirstChild("HumanoidRootPart")

    for AttributeName, AttributeValue in Attributes.Character do
        Character:SetAttribute(AttributeName, AttributeValue)
    end

    for AttributeName, AttributeValue in Attributes.Humanoid do
        Humanoid:SetAttribute(AttributeName, AttributeValue)
    end

    for _, Item : BasePart in Character:GetDescendants() do
        if not Item:IsA("BasePart") then
            continue
        end

        Item.CollisionGroup = "Players"
        Item.Locked = false
    end
end

local function HandlePlayerAdded(Player : Player)
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
end

local function HandlePlayerRemoving(Player : Player)
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