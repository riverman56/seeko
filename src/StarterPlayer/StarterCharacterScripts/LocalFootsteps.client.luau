local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")

local Sounds = SoundService:WaitForChild("FootstepSounds")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:FindFirstChildOfClass("Humanoid")
local RootPart = Humanoid.RootPart

local LastMaterial
local Walking = false

local function GetMaterial()
    local FloorMaterial = Humanoid.FloorMaterial

    if not FloorMaterial then
        FloorMaterial = "Air"
    end

    local MaterialString = FloorMaterial.Name

    return MaterialString
end

Humanoid.Running:Connect(function(Speed : number)
    if Speed > Humanoid.WalkSpeed / 2 then
        Walking = true
    else
        Walking = false
    end
end)

RunService.Heartbeat:Connect(function()
    if Walking then
        local Material = GetMaterial()

        if Material ~= LastMaterial and LastMaterial ~= nil then
            Sounds[LastMaterial]:Stop()
        end

        local MaterialSound = Sounds:FindFirstChild(Material)

        if not MaterialSound then
            return
        end

        MaterialSound.PlaybackSpeed = Humanoid.WalkSpeed / 13
        MaterialSound.Playing = true

        LastMaterial = Material
    else
        for _, Sound in Sounds:GetChildren() do
            if Sound.Playing == true then
                Sound:Stop()
            end
        end
    end
end)