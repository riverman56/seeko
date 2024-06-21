local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local DynamicFOV = {}
DynamicFOV.BaseFOV = ReplicatedFirst:WaitForChild("FOV", math.huge)
DynamicFOV.PreviousVelocity = 0

local HBInfo = TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

function DynamicFOV.Set(New : number, Info : TweenInfo)
    if Info then
        TweenService:Create(DynamicFOV.BaseFOV, Info, {Value = New}):Play()

        -- Incase DynamicFOV is not running
        if not LocalPlayer:GetAttribute("FunkyCamera") then
            TweenService:Create(Camera, Info, {FieldOfView = New}):Play()
        end
        
        return
    end

    DynamicFOV.BaseFOV.Value = New

    if not LocalPlayer:GetAttribute("FunkyCamera") then
        Camera.FieldOfView = New
    end
end

function DynamicFOV.Get()
    return DynamicFOV.BaseFOV.Value
end

function DynamicFOV.Reset(Info : TweenInfo)
    if Info then
        TweenService:Create(DynamicFOV.BaseFOV, Info, {Value = 70}):Play()

        if not LocalPlayer:GetAttribute("FunkyCamera") then
            TweenService:Create(Camera, Info, {FieldOfView = 70}):Play()
        end

        return
    end

    DynamicFOV.BaseFOV.Value = 70
    
    if not LocalPlayer:GetAttribute("FunkyCamera") then
        Camera.FieldOfView = 70
    end
end

RunService.Heartbeat:Connect(function(DeltaTime : number)
    if LocalPlayer:GetAttribute("FunkyCamera") then
        
        if not Character:FindFirstChild("HumanoidRootPart") then
            return
        end

        local Velocity = math.round(Character.HumanoidRootPart.AssemblyLinearVelocity.Magnitude)

        DynamicFOV.PreviousVelocity = Velocity
        
        TweenService:Create(Camera, HBInfo, {FieldOfView = DynamicFOV.Get() + Velocity * 0.17}):Play()
    end
end)

LocalPlayer.CharacterAdded:Connect(function(NewCharacter : Model)
    NewCharacter:WaitForChild("Humanoid", 5)

    Character = NewCharacter
end)

return DynamicFOV