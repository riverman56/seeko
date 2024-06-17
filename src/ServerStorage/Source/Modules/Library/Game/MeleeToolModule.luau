local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local CMTF = require(script.Parent.CommonToolFunctions)

local MeleeToolModule = {}

function MeleeToolModule.Load(Tool : Tool)
	assert(Tool and typeof(Tool) == "Instance" and Tool:IsA("Tool"), "Unexpected argument #1, expected Instance<Tool>, got " .. typeof(Tool))
	
	local Character
	local Humanoid : Humanoid
	local RootPart : BasePart
	local Player
	
	local Weapon_Model
	
	local Equipped = false
	
	local AnimationsLoaded = false
	
	local Equipping = false
	
	local LastStrike = os.clock()
	
	Tool.Equipped:Connect(function()
		Character = Tool:FindFirstAncestorOfClass("Model")
		Humanoid = Character:WaitForChild("Humanoid")
		RootPart = Character:WaitForChild("HumanoidRootPart")
		Player = Players:GetPlayerFromCharacter(Character)
				
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
		
		Equipped = true
	end)
	
	Tool.Unequipped:Connect(function()
		Equipped = false
	end)
end

return MeleeToolModule