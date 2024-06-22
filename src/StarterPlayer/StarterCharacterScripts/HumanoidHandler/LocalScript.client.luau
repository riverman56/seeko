if not script:IsDescendantOf(workspace) then
    repeat task.wait()
    until script:IsDescendantOf(workspace)
end

local RunService = game:GetService("RunService")

local Character = script:FindFirstAncestorOfClass("Model")
local Humanoid: Humanoid = Character:WaitForChild("Humanoid")
local RootPart: BasePart = Character:WaitForChild("HumanoidRootPart")

repeat task.wait()
until Humanoid:GetAttribute("Stamina") ~= nil

local ReducedSpeed = false

Humanoid.Jumping:Connect(function(Value : boolean)
    if Value == true then
        script.Parent.JumpRemote:FireServer()
    end
end)

RunService.Heartbeat:Connect(function()
    local FrontPoint = RootPart.Position + RootPart.CFrame.LookVector * 1
    local BackPoint = RootPart.Position + RootPart.CFrame.LookVector * -1.5

    local MovePosition = Humanoid.MoveDirection + RootPart.Position

    if (MovePosition - FrontPoint).Magnitude < (BackPoint - MovePosition).Magnitude and not ReducedSpeed then
        ReducedSpeed = true
        Humanoid.WalkSpeed += 3
    elseif ReducedSpeed then
        ReducedSpeed = false
        Humanoid.WalkSpeed -= 3
    end

    if Humanoid:GetAttribute("Stamina") < 35 and Humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping) == true then
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
	elseif Humanoid:GetAttribute("Stamina") >= 35 and Humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping) == false then
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
	end
end)