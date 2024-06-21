local RunService = game:GetService("RunService")

local MomentumFactor = 0.008
local MinimumMomentum = 0
local MaximumMomentum = math.huge
local Speed = 15

local Character = script:FindFirstAncestorOfClass("Model")
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

local M6D
local OriginalC0

if Humanoid.RigType == Enum.HumanoidRigType.R15 then
	local LowerTorso = Character.LowerTorso
	M6D = LowerTorso:WaitForChild("Root")
elseif Humanoid.RigType == Enum.HumanoidRigType.R6 then
	M6D = RootPart:WaitForChild("RootJoint")
end

OriginalC0 = M6D.C0

RunService.Heartbeat:Connect(function(DeltaTime)
	local Direction = RootPart.CFrame:VectorToObjectSpace(Humanoid.MoveDirection)
	local Momentum = RootPart.CFrame:VectorToObjectSpace(RootPart.Velocity) * MomentumFactor

	Momentum = Vector3.new(
		math.clamp(math.abs(Momentum.X), MinimumMomentum, MaximumMomentum),
		0,
		math.clamp(math.abs(Momentum.Z), MinimumMomentum, MaximumMomentum)
	)

	local X = Direction.X * Momentum.X
	local Z = Direction.Z * Momentum.Z

	local Angles
	if Humanoid.RigType == Enum.HumanoidRigType.R15 then
		Angles = { Z, 0, -X }
	elseif Humanoid.RigType == Enum.HumanoidRigType.R6 then
		Angles = { -Z, -X, 0 }
	end

	M6D.C0 = M6D.C0:Lerp(OriginalC0 * CFrame.Angles(table.unpack(Angles)), DeltaTime * Speed)
end)
