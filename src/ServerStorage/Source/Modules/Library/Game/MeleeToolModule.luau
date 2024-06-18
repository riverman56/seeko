local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local Janitor = require(ReplicatedStorage.Source.Modules.Utility.Janitor)

local CMTF = require(script.Parent.CommonToolFunctions)
local MeleeModule = require(script.Parent.MeleeModule)

local MeleeToolModule = {}

function MeleeToolModule.Load(Tool : Tool)
	assert(Tool and typeof(Tool) == "Instance" and Tool:IsA("Tool"), "Unexpected argument #1, expected Instance<Tool>, got " .. typeof(Tool))
	
	local Character
	local Humanoid : Humanoid
	local Animator : Animator
	local RootPart : BasePart
	local Player
	
	local Weapon_Model
	
	local Equipped = false
	
	local Animations
	
	local Equipping = false
	
	local LastStrike = os.clock()

	local NewJanitor = Janitor.new()
	NewJanitor:LinkToInstances(Character, Tool)
	
	Tool.Equipped:Connect(function()
		Character = Tool:FindFirstAncestorOfClass("Model")
		Humanoid = Character:WaitForChild("Humanoid")
		Animator = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", Humanoid)
 		RootPart = Character:WaitForChild("HumanoidRootPart")
		Player = Players:GetPlayerFromCharacter(Character)

		Animations = MeleeModule:LoadAnimations(Animator, Tool.Animations)
				
		local PotentialGripR = Character["Right Arm"]:FindFirstChild("RightGripAttachment")
		local PotentialGripL = Character["Left Arm"]:FindFirstChild("LeftGripAttachment")
		
		local GripR
		local GripL
		
		if not PotentialGripL then
			GripL = Instance.new("Attachment")
			GripL.Position = Vector3.new(0, -1, 0)
			GripL.Name = "LeftGripAttachment"
			GripL.Parent = Character["Left Arm"]
		else
			GripL = PotentialGripL
			PotentialGripL = nil
		end
		
		if not PotentialGripR then
			GripR = Instance.new("Attachment")
			GripR.Position = Vector3.new(0, -1, 0)
			GripR.Name = "RightGripAttachment"
			GripR.Parent = Character["Right Arm"]
		else
			GripR = PotentialGripR
			PotentialGripR = nil
		end
		
		local Appearance
		
		for _, Object in ReplicatedStorage.Assets.Models.Weapons:GetDescendants() do
			if not Object:IsA("Model") then
				continue
			end
			
			if Object.Name == "Default " .. Tool.Name then
				Appearance = Object
			end
		end
		
		Weapon_Model = CMTF.LoadModelSkin(Player, Appearance, Tool)
		
		NewJanitor:Add(Animations.Equip:GetMarkerReachedSignal("Switch_Handle"):Connect(function(...)
			for _, Object in Weapon_Model:GetDescendants() do
				if not (Object:IsA("Motor6D") or Object:IsA("BasePart")) then
					continue
				end

				if Object:IsA("BasePart") and Object.Name == "Sheath_Handle" then
					Object.Weld.Part1 = nil
				end
 
				if Object.Name == "Weapon_Handle" and Object:IsA("Motor6D") then
					Object.Part0 = Character[tostring(...)]
				end
 			end
		end), "Disconnect")

		Animations.Equip:Play()
		Animations.SheathIdle:Play()

		task.delay(0.2, function()
			Animations.Idle:Play()
		end)
		
		Equipped = true
	end)
	
	Tool.Unequipped:Connect(function()
		Equipped = false

		if Animations.Idle.IsPlaying == true then
			Animations.Idle:Stop()
		end

		NewJanitor:Cleanup()
	end)
end

return MeleeToolModule