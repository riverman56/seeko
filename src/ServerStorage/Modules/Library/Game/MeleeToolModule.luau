local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local Janitor = require(ReplicatedStorage.Modules.Utility.Janitor)
local CommonFunctions = require(ReplicatedStorage.Modules.Utility.CommonFunctions)

local CMTF = require(script.Parent.CommonToolFunctions)
local MeleeModule = require(script.Parent.MeleeModule)

local Hitbox = require(script.Parent.Parent.Packages.Hitbox)

local MeleeToolModule = {}

function MeleeToolModule.Load(Tool: Tool)
	assert(
		Tool and typeof(Tool) == "Instance" and Tool:IsA("Tool"),
		"Unexpected argument #1, expected Instance<Tool>, got " .. typeof(Tool)
	)

	local Character
	local Humanoid: Humanoid
	local Animator: Animator
	local RootPart: BasePart
	local Player: Player

	local Weapon_Model

	local MainHandle
	local SheathHandle

	local Equipped = false

	local AnimationsLoaded = false
	local Animations = nil

	local Equipping = false

	local LastStrike = 0
	local AttackDebounce = false

	local NewJanitor = Janitor.new()
	NewJanitor:LinkToInstance(Tool)

	Tool.Equipped:Connect(function()
		Character = Tool:FindFirstAncestorOfClass("Model")
		Humanoid = Character:WaitForChild("Humanoid")
		Animator = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", Humanoid)
		RootPart = Character:WaitForChild("HumanoidRootPart")
		Player = Players:GetPlayerFromCharacter(Character)

		if AnimationsLoaded == false then
			AnimationsLoaded = true
			Animations = MeleeModule:LoadEquipAnimations(Animator, Tool.Animations)
		end

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

		for _, Object in Weapon_Model:GetDescendants() do
			if not Object:IsA("BasePart") then
				continue
			end

			if Object:GetAttribute("MainHandle") == true then
				MainHandle = Object
			end

			if Object:GetAttribute("SheathHandle") == true then
				SheathHandle = Object
			end
		end

		if MeleeModule.CheckEquip(Character, Tool) == false then
			NewJanitor:Add(Animations.Equip:GetMarkerReachedSignal("SwitchHandle"):Once(function(...)
				CommonFunctions.PlaySound(MainHandle, Tool.SFX["SFX_Unsheathe"], 5)
	
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
		end
		
		Tool:SetAttribute("InHand", true)

		Equipped = true
	end)

	Tool.Unequipped:Connect(function()
		Equipped = false

		if MeleeModule.CheckEquip(Character, Tool) == true then
			NewJanitor:Add(Animations.Unequip:GetMarkerReachedSignal("SwitchHandle"):Once(function(...)
				CommonFunctions.PlaySound(MainHandle, Tool.SFX["SFX_Sheathe"], 5)
	
				for _, Object in Weapon_Model:GetDescendants() do
					if not (Object:IsA("Motor6D") or Object:IsA("BasePart")) then
						continue
					end
	
					if Object:IsA("Motor6D") and Object.Name == "Weapon_Handle" then
						Object.Part0 = nil
					end
	
					if Object:IsA("BasePart") and Object.Name == "Sheath_Handle" then
						Object.Weld.Part1 = MainHandle
					end
				end
			end), "Disconnect")
	
			NewJanitor:Add(Animations.Unequip:GetMarkerReachedSignal("Swing"):Once(function(...)
				CommonFunctions.PlayRandomSound(Tool.SFX, "SFX_Swing", MainHandle)
			end), "Disconnect")
	
			Animations.Unequip:Play()
		end

		Tool:SetAttribute("InHand", false)
	end)

	NewJanitor:Add(
		Tool.Remotes.Attack.OnServerEvent:Connect(function(ReceivedPlayer: Player, RequestedAnimation: Instance)
			if not Player or not Character or not Humanoid or not RootPart or not Equipped then
				return
			end

			if ReceivedPlayer ~= Player then
				ReceivedPlayer:Kick("nice going idiot")
				return
			end

			if Humanoid:GetState() == Enum.HumanoidStateType.Dead or Humanoid.PlatformStand == true then
				return
			end

			if Humanoid:GetAttribute("Stamina") < Tool:GetAttribute("StaminaCost") then
				return
			end

			if os.clock() - LastStrike < 0.25 then
				return
			end

			LastStrike = os.clock()

			local NewHitbox = Hitbox.new(Character)
			NewHitbox.Size = Vector3.new(5, 5, 5)
			NewHitbox.MultiHit = false
			NewHitbox.Lifetime = 0.1
			
			NewHitbox.OnHit:Connect(function(HitCharacter : Model, HitHumanoid : Humanoid, HitRootPart : BasePart)
				HitHumanoid:TakeDamage(Tool:GetAttribute("Damage") or 20)

				ReplicatedStorage.Remotes.Effects:FireAllClients("Game", "DamageIndicator", HitCharacter.Head, Tool:GetAttribute("Damage") or 20)
				ReplicatedStorage.Remotes.Effects:FireAllClients("Game", "DamageHighlight", HitCharacter)

				local BV = Instance.new("BodyVelocity")
				BV.MaxForce = Vector3.new(math.huge, 0, math.huge)
				BV.Velocity = Character.Torso.CFrame.LookVector * Tool:GetAttribute("Knockback")
				BV.Parent = HitRootPart
				Debris:AddItem(BV, 0.1)

				if Tool:GetAttribute("CanDismember") == true then
					CommonFunctions.SpawnParticle(Tool, "BloodSpillEffect", Character:FindFirstChild("BloodOrigin", true).Parent)
				end
				
				task.delay(0.1, function()
					CommonFunctions.PlayRandomSound(Tool.SFX, "SFX_Hit", HitRootPart)
				end)
			end)
		end, "Disconnect")
	)
end

return MeleeToolModule
