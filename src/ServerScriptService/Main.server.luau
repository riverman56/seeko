local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local JanitorStorage = {}

local Janitor = require(ReplicatedStorage.Source.Modules.Utility.Janitor)

local ProfileHandler = require(ServerStorage.Source.Modules.Data.ProfileHandler)

local function HandleCharacterSpawn(Player : Player)
    local Character = Player.Character or Player.CharacterAdded:Wait()

    if not Character:IsDescendantOf(workspace) then
        repeat task.wait()
        until Character:IsDescendantOf(workspace)
    end

    Character.Parent = workspace.Users
    Character.PrimaryPart = Character:FindFirstChild("HumanoidRootPart")

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