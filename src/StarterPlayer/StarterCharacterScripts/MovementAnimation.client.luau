local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local StarterPlayer = game:GetService("StarterPlayer")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid: Humanoid = Character:WaitForChild("Humanoid")

local LockInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local UnlockInfo = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local RootPart: BasePart = Character:WaitForChild("HumanoidRootPart")
local Torso = Character.Torso

local RootJoint = RootPart:WaitForChild("RootJoint")
local LeftHipJoint = Torso["Left Hip"]
local RightHipJoint = Torso["Right Hip"]

local Force = nil
local Direction = nil

local ClimbingSpeed = 0
local RightComponent = 0
local ForwardComponent = 0

local RootJointC0 = RootJoint.C0
local LeftHipJointC0 = LeftHipJoint.C0
local RightHipJointC0 = RightHipJoint.C0

local Neck = Torso:WaitForChild("Neck", math.huge)
local YOffset = Neck.C0.Y

local Camera = workspace.CurrentCamera

local function IsFirstPerson(Head: BasePart)
	return Head.LocalTransparencyModifier == 1
end

Humanoid.Climbing:Connect(function(Speed: number)
	ClimbingSpeed = Speed
end)

task.spawn(function()
	local Sounds = SoundService:WaitForChild("FootstepSounds")

	while RootPart do
		if not Character:IsDescendantOf(workspace) then
			break
		end

		if Humanoid:GetState() == Enum.HumanoidStateType.Dead then
			break
		end

		local Moving = (RootPart.AssemblyLinearVelocity - Vector3.new(0, RootPart.AssemblyLinearVelocity.Y, 0)).Magnitude

		local Rate = (StarterPlayer.CharacterWalkSpeed / 3) / Moving

		if RootPart:GetAttribute("Running") == false then
			Rate = (StarterPlayer.CharacterWalkSpeed / 2.3) / Moving
		else
			Rate = (StarterPlayer.CharacterWalkSpeed / 3) / Moving
		end

		local Walking = Moving > 2 and Humanoid.FloorMaterial ~= Enum.Material.Air

		if Walking or Humanoid:GetState() == Enum.HumanoidStateType.Climbing then
			local Name = "Brick"

			if
				math.abs(RootPart.AssemblyLinearVelocity.Y) > 0.1
				and Humanoid:GetState() == Enum.HumanoidStateType.Climbing
			then
				Name = "Ladder"

				task.spawn(function()
					local MaterialFolder = Sounds:WaitForChild(Name):GetChildren()
					local Sound = MaterialFolder[math.random(#MaterialFolder)]:Clone()
                    Sound.Parent = RootPart
					Sound.PlaybackSpeed = (Humanoid.WalkSpeed / 13) + math.random(-20, 30) / 100
					Sound:Play()
				end)
			elseif Walking and Humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
				if Sounds:FindFirstChild(Humanoid.FloorMaterial.Name) then
					Name = Humanoid.FloorMaterial.Name
				else
					Name = "Brick"
				end

				task.spawn(function()
					local MaterialFolder = Sounds:WaitForChild(Name):GetChildren()
					local Sound = MaterialFolder[math.random(#MaterialFolder)]:Clone()
                    Sound.Parent = RootPart
					Sound.PlaybackSpeed = (Humanoid.WalkSpeed / 13) + math.random(-20, 30) / 100
					Sound:Play()

					local FootParticle = ReplicatedStorage.Assets.Library.Particles.FootParticles:Clone()
					FootParticle.CFrame = RootPart.CFrame * CFrame.new(0, -3, 0)
					FootParticle.Parent = workspace.Visuals
					FootParticle.SmokeParticles:Emit(10)

                    Debris:AddItem(FootParticle, FootParticle.SmokeParticles.Lifetime.Max)
				end)
			end
		end

		if Walking then
			task.wait(Rate)
		elseif Humanoid:GetState() == Enum.HumanoidStateType.Climbing then
			local ClimbRate = (StarterPlayer.CharacterWalkSpeed / 3) / math.abs(ClimbingSpeed)
			task.wait(ClimbRate)
		else
			task.wait()
		end
	end
end)

RunService.RenderStepped:Connect(function()
	Force = RootPart.AssemblyLinearVelocity + Vector3.new(1, 0, 1)

	local CameraDirection = RootPart.CFrame:ToObjectSpace(Camera.CFrame).LookVector

	if Neck then
		if Humanoid.RigType == Enum.HumanoidRigType.R15 then
			Neck.C0 = CFrame.new(0, YOffset, 0)
				* CFrame.Angles(0, -math.asin(CameraDirection.X), 0)
				* CFrame.Angles(math.asin(CameraDirection.Y), 0, 0)
		elseif Humanoid.RigType == Enum.HumanoidRigType.R6 then
			Neck.C0 = CFrame.new(0, YOffset, 0)
				* CFrame.Angles(3 * math.pi / 2, 0, math.pi)
				* CFrame.Angles(0, 0, -math.asin(CameraDirection.X))
				* CFrame.Angles(-math.asin(CameraDirection.Y), 0, 0)
		end
	end

	if Force.Magnitude > 2 then
		Direction = Force.Unit
		RightComponent = RootPart.CFrame.RightVector:Dot(Direction)
		ForwardComponent = RootPart.CFrame.LookVector:Dot(Direction)
	else
		RightComponent = 0
		ForwardComponent = 0
	end

	if
		UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter
		and not IsFirstPerson(Character.Head)
		and Humanoid:GetState() ~= Enum.HumanoidStateType.Dead
	then
		if Humanoid.CameraOffset ~= Vector3.new(2, 0.4, 0) then
			TweenService:Create(Humanoid, LockInfo, { CameraOffset = Vector3.new(1.75, 0, 0) }):Play()
		end
	elseif UserInputService.MouseBehavior == Enum.MouseBehavior.Default or IsFirstPerson(Character.Head) then
		if Humanoid.CameraOffset ~= Vector3.zero then
			TweenService:Create(Humanoid, UnlockInfo, { CameraOffset = Vector3.zero }):Play()
		end
	end

	RootJoint.C0 = RootJoint.C0:Lerp(
		RootJointC0 * CFrame.Angles(math.rad(ForwardComponent * 5), math.rad(-RightComponent * 10), 0),
		0.2
	)
	LeftHipJoint.C0 = LeftHipJoint.C0:Lerp(LeftHipJointC0 * CFrame.Angles(math.rad(RightComponent * 10), 0, 0), 0.2)
	RightHipJoint.C0 = RightHipJoint.C0:Lerp(RightHipJointC0 * CFrame.Angles(math.rad(-RightComponent * 10), 0, 0), 0.2)
end)
