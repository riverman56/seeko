local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CommonFunctions = require(ReplicatedStorage.Source.Modules.Utility.CommonFunctions)

local Character = script:FindFirstAncestorOfClass("Model")
local Humanoid: Humanoid = Character:WaitForChild("Humanoid")
local RootPart: BasePart = Humanoid.RootPart
local Torso: BasePart = Character:WaitForChild("Torso")

local TouchDebounce = false

local CollisionPartSample = Instance.new("Part")
CollisionPartSample.Name = "RagdollCollision"
CollisionPartSample.Transparency = 1
CollisionPartSample.Anchored = false
CollisionPartSample.CanCollide = false
CollisionPartSample.CanQuery = false
CollisionPartSample.CanTouch = false
CollisionPartSample.Size = Vector3.one
CollisionPartSample.Massless = true
CollisionPartSample:AddTag("CollisionPart")

local Weld = Instance.new("Weld")
Weld.Part1 = CollisionPartSample
Weld.Name = "Weld"
Weld.Parent = CollisionPartSample

local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Exclude
RayParams.IgnoreWater = true
RayParams.FilterDescendantsInstances = {Character}

local function ToggleRagdoll(Value : boolean)
	if Value == nil then
		return
	end
	
	Humanoid:SetAttribute("Ragdoll", Value)
	
	for _, Motor6D in Torso:GetChildren() do
		if Motor6D:IsA("Motor6D") then
			Motor6D.Enabled = not Value
		end
	end
	
	for _, CollisionPart in Character:GetDescendants() do
		if CollisionPart:HasTag("CollisionPart") and CollisionPart:IsA("BasePart") then
			CollisionPart.CanCollide = Value
		end
	end
	
	Humanoid.AutoRotate = not Value
	
	if Value then
		Character.Head.Velocity = Character.Head.CFrame.LookVector * -5
	else
		-- local RayResults = workspace:Raycast(Torso.Position, Torso.CFrame.LookVector * 5, RayParams)
		
		-- getup animation?
		
		RootPart.CFrame = CFrame.new(Torso.Position + Vector3.new(0, 3, 0), Torso.CFrame.UpVector)
	end
end

Humanoid.BreakJointsOnDeath = false

Humanoid.Died:Once(function()
	ToggleRagdoll(true)
end)

Torso.Touched:Connect(function(HitPart: BasePart)
	if Humanoid:GetAttribute("Ragdoll") == true and not TouchDebounce and not HitPart:IsDescendantOf(Character) then
		TouchDebounce = true
		
		CommonFunctions.PlaySound(Torso, script:FindFirstChild("Collapse" .. math.random(3)), 5, NumberRange.new(0.9, 1.1))
		
		task.delay(0.5, function()
			TouchDebounce = false
		end)
	end
end)

Humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
	if Humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
		ToggleRagdoll(Humanoid.PlatformStand)
	end
end)

for _, Motor6D in Torso:GetChildren() do
	if Motor6D:IsA("Motor6D") then
		
		local BodyPart = string.gsub(Motor6D.Part1.Name, " ", "")
		
		local Offset = Vector3.zero
		local AddRotation = CFrame.Angles(0, 0, 0)
		
		local BallSocket = Instance.new("BallSocketConstraint")
		BallSocket.Name = BodyPart .. "JointSocket"
		BallSocket.MaxFrictionTorque = 1
		
		if BodyPart == "Head" then
			BallSocket.LimitsEnabled = true
			BallSocket.TwistLimitsEnabled = true
			BallSocket.UpperAngle = 45
			BallSocket.TwistUpperAngle = 45
			BallSocket.TwistLowerAngle = -45
		elseif string.find(BodyPart, "Arm") then
			Offset = Vector3.new(0, 0.5, 0)
			AddRotation = CFrame.Angles(0, math.rad(90), 0)
			
			BallSocket.LimitsEnabled = true
			BallSocket.UpperAngle = 45
			BallSocket.TwistUpperAngle = 170
			BallSocket.TwistLowerAngle = -170
		elseif string.find(BodyPart, "Leg") then
			AddRotation = CFrame.Angles(0, math.rad(90), 0)
			
			BallSocket.LimitsEnabled = true
			BallSocket.TwistLimitsEnabled = true
			BallSocket.UpperAngle = 45
			BallSocket.TwistUpperAngle = 100
			BallSocket.TwistLowerAngle = -100
		end
		
		local Collision = CollisionPartSample:Clone()
		Collision.Weld.Part0 = Motor6D.Part1
		Collision.Parent = Motor6D.Part1
		
		local JointAttachment0 = Instance.new("Attachment")
		JointAttachment0.Name = string.gsub(BodyPart .. "Joint", " ", "")
		JointAttachment0.CFrame = Motor6D.C0 * AddRotation + Offset
		JointAttachment0.Parent = Torso
		
		local JointAttachment1 = Instance.new("Attachment")
		JointAttachment1.Name = string.gsub(BodyPart .. "Joint", " ", "")
		JointAttachment1.CFrame = Motor6D.C1 * AddRotation + Offset
		JointAttachment1.Parent = Motor6D.Part1
		
		BallSocket.Attachment0 = JointAttachment0
		BallSocket.Attachment1 = JointAttachment1
		
		BallSocket.Name = "LimbConstraint"
		
		BallSocket.Parent = Motor6D.Part1
	end
end