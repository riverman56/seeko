local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Zone = require(ReplicatedStorage.Packages.Zone)

local Zones = Workspace:WaitForChild("Zones")

local AtmospheresFolder = Lighting:WaitForChild("Atmospheres")

local PlayerZones = {}

for _, ZoneFolder in Zones:GetChildren() do
    if not ZoneFolder:IsA("Folder") then
        continue
    end

    local NewZone = Zone.new(ZoneFolder)

    NewZone.playerEntered:Connect(function(Player : Player)
        if PlayerZones[Player] == ZoneFolder.Name then
            return
        end

        local ZoneLighting = AtmospheresFolder:FindFirstChild(ZoneFolder.Name)

        PlayerZones[Player] = Zone.Name
        
        if ZoneLighting then
            ReplicatedStorage.Remotes.Effects:FireClient(Player, "Lighting", "ChangeCurrentAtmosphere", ZoneLighting)
        end
    end)
end