local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local DynamicFOV = require(script.DynamicFOV)

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Character = Player.Character or Player.CharacterAdded:Wait()
local RootPart : BasePart
local Torso : BasePart
local Humanoid : Humanoid

local RenderStepped

local function Update(NewCharacter : Model)
    NewCharacter:WaitForChild("Humanoid", 5)

    Character = Character
    RootPart = Character:WaitForChild("HumanoidRootPart")
    Humanoid = Character:WaitForChild("Humanoid")
    Torso = Character:WaitForChild("Torso")
    Camera = workspace.CurrentCamera

    print("Camera initialized")
end

local function OnRenderStepped(DeltaTime : number)
    local Offset = Torso.CFrame:ToObjectSpace(RootPart.CFrame).Position

    Humanoid.CameraOffset = Offset + Vector3.new(0, 0.25, 0)

    local Direction = Humanoid.MoveDirection
    local DotProduct = Camera.CFrame.RightVector:Dot(Direction) * 60 * DeltaTime

    Camera.CFrame = Camera.CFrame:Lerp(Camera.CFrame * CFrame.Angles(0, 0, math.rad(-DotProduct)), 0.2)
end

local function ChangeEnabledState(New : boolean)
    if New then
        if not RenderStepped then
            RenderStepped = RunService.RenderStepped:Connect(OnRenderStepped)
        end
    else
        if RenderStepped then
            RenderStepped:Disconnect()
            RenderStepped = nil
        end

        Humanoid.CameraOffset = Vector3.zero
    end
end

Update(Character)
ChangeEnabledState(true)

Player.CharacterAdded:Connect(Update)
Player.AttributeChanged:Connect(function(Attribute : string)
    if Attribute == "FunkyCamera" then
        ChangeEnabledState(Player:GetAttribute("FunkyCamera"))
    elseif Attribute == "LegacyCamera" then
        Player:SetAttribute("FunkyCamera", not Player:GetAttribute("LegacyCamera"))
    end
end)