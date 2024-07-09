local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")

local Janitor = require(ReplicatedStorage.Modules.Utility.Janitor)
local CommonFunctions = require(ReplicatedStorage.Modules.Utility.CommonFunctions)
local TagModule = require(ReplicatedStorage.Modules.Miscellaneous.TagSystem)

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
	local Animations: { [string]: AnimationTrack } = nil

	local LastStrike = 0

	local SpamCount = -2

	local NewJanitor = Janitor.new()
	NewJanitor:LinkToInstance(Tool)

	Tool.Equipped:Connect(function()
		Character = Tool:FindFirstAncestorOfClass("Model")
		Humanoid = Character:WaitForChild("Humanoid")
		Animator = Humanoid:FindFirstChildOfClass("Animator")
		RootPart = Character:WaitForChild("HumanoidRootPart")
		Player = Players:GetPlayerFromCharacter(Character)
		Animator.Parent = Humanoid

		Humanoid:SetAttribute("Guard", false)

		if AnimationsLoaded == false then
			AnimationsLoaded = true
			Animations = MeleeModule:LoadServerAnimations(Animator, Tool.Animations)
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

		if MeleeModule.CheckEquip(Character, Tool) == false and Animations.Equip then
			NewJanitor:Add(
				Animations.Equip:GetMarkerReachedSignal("SwitchHandle"):Once(function(...)
					CommonFunctions.PlaySound(MainHandle, Tool.SFX["SFX_Unsheathe"], 5)

					for _, Object in Weapon_Model:GetDescendants() do
						if not (Object:IsA("Motor6D") or Object:IsA("BasePart")) then
							continue
						end

						if Object == SheathHandle then
							Object.Weld.Part1 = nil
						end

						if Object.Name == "Weapon_Handle" and Object:IsA("Motor6D") --[[and Object:IsDescendantOf(SheathHandle)]] then
							Object.Part0 = Character[tostring(...)]
						end
					end
				end),
				"Disconnect"
			)

			Animations.Equip:Play()
		end

		Humanoid:GetAttributeChangedSignal("Guard"):Connect(function()
			if Humanoid:GetAttribute("Guard") == true and Equipped == true then
				Animations.Guard:Play()
			else
				Animations.Guard:Stop()
			end
		end)

		Tool:SetAttribute("InHand", true)

		Equipped = true
	end)

	Tool.Unequipped:Connect(function()
		Equipped = false

		if Animations.Equip and Animations.Equip.IsPlaying == true then
			Animations.Equip:Stop()
		end

		Humanoid:SetAttribute("Guard", false)

		if MeleeModule.CheckEquip(Character, Tool) == true and Animations.Unequip then
			NewJanitor:Add(
				Animations.Unequip:GetMarkerReachedSignal("SwitchHandle"):Once(function()
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
				end),
				"Disconnect"
			)

			NewJanitor:Add(
				Animations.Unequip:GetMarkerReachedSignal("PlaySound"):Once(function(SoundName: string)
					CommonFunctions.PlayRandomSound(Tool.SFX, SoundName, MainHandle)
				end),
				"Disconnect"
			)

			local OtherTool = Character:FindFirstChildOfClass("Tool")

			if OtherTool and OtherTool ~= Tool then
				Animations.Unequip:Play()
				Animations.Unequip:AdjustSpeed(100)
			elseif not OtherTool then
				Animations.Unequip:Play()
			end
		end

		Tool:SetAttribute("InHand", false)
	end)

	NewJanitor:Add(
		Tool.Remotes.Attack.OnServerEvent:Connect(function(ReceivedPlayer: Player, RequestedAnimation: AnimationTrack)
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

			local Connection: RBXScriptConnection
			local Checks = 0

			if string.find(RequestedAnimation.Name, "Attack") then
				if
					Humanoid:GetAttribute("Stamina") < Tool:GetAttribute("StaminaCost")
					or Humanoid:GetAttribute("Guard") == true
					or Humanoid:GetAttribute("Stun") == true
					or Tool:GetAttribute("Stun") == true
				then
					return
				end

				if os.clock() - LastStrike < 0.25 then
					return
				end

				Connection = RunService.Heartbeat:Connect(function()
					Checks += 1

					if RequestedAnimation then
						if Connection then
							Connection:Disconnect()
							Connection = nil
						end

						SpamCount += 1

						local SCMultiplier = 1 + math.clamp(SpamCount, 0, 10) / 2
						-- print(SCMultiplier)

						Humanoid:SetAttribute(
							"Stamina",
							math.clamp(
								Humanoid:GetAttribute("Stamina") - Tool:GetAttribute("StaminaCost") * SCMultiplier,
								0,
								Humanoid:GetAttribute("MaxStamina")
							)
						)

						task.delay(1.5, function()
							SpamCount -= 1
						end)
					elseif Checks <= 100 then
						Connection:Disconnect()
						Connection = nil
					end
				end)

				Humanoid:SetAttribute("Guard", false)

				LastStrike = os.clock()

				local NewHitbox = Hitbox.new(Character)
				NewHitbox.Size = RequestedAnimation:GetAttribute("Range") or Vector3.new(5, 5, 5)
				NewHitbox.MultiHit = false
				NewHitbox.Lifetime = 0.1

				NewHitbox.OnHit:Connect(
					function(HitCharacter: Model, HitHumanoid: Humanoid, HitRootPart: BasePart, HitPart: BasePart)
						local function Damage()
							local DamageAmount = Tool:GetAttribute("Damage") or 20

							HitHumanoid:TakeDamage(DamageAmount)
							TagModule.Tag(HitCharacter, Character, DamageAmount)

							ReplicatedStorage.Remotes.Effects:FireAllClients(
								"Game",
								"DamageIndicator",
								HitCharacter.Head,
								Tool:GetAttribute("Damage") or 20
							)
							ReplicatedStorage.Remotes.Effects:FireAllClients("Game", "DamageHighlight", HitCharacter)
							ReplicatedStorage.Remotes.Effects:FireAllClients("Game", "Hitmarker")

							local BV = Instance.new("BodyVelocity")
							BV.MaxForce = Vector3.new(math.huge, 0, math.huge)
							BV.Velocity = Character.Torso.CFrame.LookVector * Tool:GetAttribute("Knockback")
							BV.Parent = HitRootPart
							Debris:AddItem(BV, 0.1)

							if Tool:GetAttribute("CanDismember") == true then
								CommonFunctions.SpawnParticle(Tool, "BloodSpillEffect", HitPart, true)
							end

							task.delay(0.1, function()
								CommonFunctions.PlayRandomSound(
									Tool.SFX,
									RequestedAnimation:GetAttribute("SFX_Hit"),
									HitRootPart
								)
							end)

							if HitHumanoid:GetState() == Enum.HumanoidStateType.Dead or HitHumanoid.Health <= 0 then
								if Tool:GetAttribute("CanDismember") ~= true then
									return
								end

								local Constraints = {}

								for _, Object in HitCharacter:GetDescendants() do
									if not Object:IsA("BallSocketConstraint") then
										continue
									end

									if Object.Name == "LimbConstraint" then
										table.insert(Constraints, Object)
									end
								end

								if Constraints ~= nil and #Constraints >= 0 then
									local LimbConstraint = Constraints[math.random(#Constraints)]
									local LimbPart = LimbConstraint.Attachment1.Parent

									local LimbBV = Instance.new("BodyVelocity")
									LimbBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
									LimbBV.Velocity = Vector3.new(math.random(-20, 20), 20, math.random(-20, 20))

									local LimbAV = Instance.new("BodyAngularVelocity")
									LimbAV.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
									LimbAV.AngularVelocity =
										Vector3.new(math.random(-20, 20), math.random(-20, 20), math.random(-20, 20))

									LimbAV.Parent = LimbPart
									LimbBV.Parent = LimbPart

									Debris:AddItem(LimbAV, 0.1)
									Debris:AddItem(LimbBV, 0.1)

									LimbConstraint:Destroy()
									CommonFunctions.PlayRandomSound(
										ReplicatedStorage.Assets.Library.Sounds,
										"Dismember",
										LimbPart
									)

									local BloodEffect = Tool.VFX.BloodSpillEffect:Clone()
									BloodEffect.Parent = LimbPart
									BloodEffect.Emission:SetAttribute("Rate_Burst", 0)
									BloodEffect.Emission:SetAttribute("Rate", 5)
									BloodEffect.Enabled = true
								end
							end
						end

						local Status =
							CommonFunctions.CheckStatus(Humanoid, HitHumanoid, Tool:GetAttribute("Damage") or 20)

						if Status == "Damaged" then
							Damage()
						elseif Status == "Blocked" then
							local HitTool = HitCharacter:FindFirstChildOfClass("Tool")

							if HitTool then
								if
									HitTool:GetAttribute("InHand") == true
									and HitHumanoid:GetAttribute("Stamina") >= Tool:GetAttribute("StaminaDamage")
								then
									local ReturnAnimations = {}

									for _, Animation: Instance in HitTool:WaitForChild("Animations"):GetChildren() do
										if string.find(Animation.Name, "Evade") then
											table.insert(ReturnAnimations, Animation)
										end
									end

									local AnimationObject = ReturnAnimations[math.random(#ReturnAnimations)]

									local HitAnimator = HitHumanoid:FindFirstChildOfClass("Animator")
										or Instance.new("Animator")
										HitAnimator.Parent = HitHumanoid

									if AnimationObject and AnimationObject.AnimationId ~= "" then
										local EvadeAnimation = HitAnimator:LoadAnimation(AnimationObject)
										EvadeAnimation:Play()
									end

									HitHumanoid:SetAttribute(
										"Stamina",
										HitHumanoid:GetAttribute("Stamina") - Tool:GetAttribute("StaminaDamage")
									)

									local SparkEffect = Tool.VFX.HitSparkEffect:Clone()

									local ParticlesAttachment = HitCharacter:FindFirstChild("Particles", true)

									if ParticlesAttachment and ParticlesAttachment:IsA("Attachment") then
										SparkEffect.Parent = ParticlesAttachment
										SparkEffect.Enabled = true
										Debris:AddItem(
											SparkEffect,
											SparkEffect.Emission:GetAttribute("Lifetime").Max or 1
										)
									end

									task.defer(function()
										Tool:SetAttribute("Stun", true)
										wait(0.5)
										Tool:SetAttribute("Stun", false)
									end)

									task.delay(0.1, function()
										CommonFunctions.PlayRandomSound(HitTool.SFX, "SFX_Block", HitRootPart)
									end)
								else
									Damage()
								end
							else
								Damage()
							end
						end
					end
				)
			elseif string.find(RequestedAnimation.Name, "GuardBreak") then
				if
					Humanoid:GetAttribute("Stamina") < Tool:GetAttribute("GuardBreakStaminaCost")
					or Humanoid:GetAttribute("Guard") == true
					or Humanoid:GetAttribute("Stun") == true
					or Tool:GetAttribute("Stun") == true
				then
					return
				end

				Connection = RunService.Heartbeat:Connect(function()
					Checks += 1

					if RequestedAnimation then
						if Connection then
							Connection:Disconnect()
							Connection = nil
						end

						SpamCount += 1

						local SCMultiplier = 1 + math.clamp(SpamCount, 0, 10) / 2
						-- print(SCMultiplier)

						Humanoid:SetAttribute(
							"Stamina",
							math.clamp(
								Humanoid:GetAttribute("Stamina") - Tool:GetAttribute("StaminaCost") * SCMultiplier,
								0,
								Humanoid:GetAttribute("MaxStamina")
							)
						)

						task.delay(1.5, function()
							SpamCount -= 1
						end)
					elseif Checks <= 100 then
						Connection:Disconnect()
						Connection = nil
					end
				end)

				local NewHitbox = Hitbox.new(Character)
				NewHitbox.Size = RequestedAnimation:GetAttribute("Range") or Vector3.new(5, 5, 5)
				NewHitbox.MultiHit = false
				NewHitbox.Lifetime = 0.1

				NewHitbox.OnHit:Connect(
					function(HitCharacter: Model, HitHumanoid: Humanoid, HitRootPart: BasePart)
						local Status =
							CommonFunctions.CheckStatus(Humanoid, HitHumanoid, Tool:GetAttribute("Damage") or 20)

						local function Damage()
							HitHumanoid:TakeDamage(Tool:GetAttribute("Damage") * 0.3)
							TagModule.Tag(HitCharacter, Character, Tool:GetAttribute("Damage") * 0.3)

							if HitHumanoid.Health - Tool:GetAttribute("Damage") * 0.3 <= 0 then
								HitHumanoid.Health = 1
							else
								HitHumanoid:TakeDamage(Tool:GetAttribute("Damage") * 0.3)
							end

							CommonFunctions.PlayRandomSound(
								Tool.SFX,
								RequestedAnimation:GetAttribute("SFX_Hit"),
								HitRootPart
							)
						end

						if Status == "Damaged" then
							Damage()
						elseif Status == "Blocked" then
							if HitHumanoid:GetAttribute("Stamina") >= Tool:GetAttribute("GuardBreakStaminaDrain") then
								HitHumanoid:SetAttribute(
									"Stamina",
									HitHumanoid:GetAttribute("Stamina") - Tool:GetAttribute("GuardBreakStaminaDrain")
								)

								CommonFunctions.PlayRandomSound(
									Tool.SFX,
									RequestedAnimation:GetAttribute("SFX_Hit"),
									HitRootPart
								)

								CommonFunctions.PlaySound(
									HitRootPart,
									ReplicatedStorage.Assets.Library.Sounds.GuardBreak,
									5
								)

								local BV = Instance.new("BodyVelocity")
								BV.MaxForce = Vector3.new(math.huge, 0, math.huge)
								BV.Velocity = Character.Torso.CFrame.LookVector * Tool:GetAttribute("Knockback") * 2
								BV.Parent = HitRootPart
								Debris:AddItem(BV, 0.1)

								HitHumanoid:SetAttribute("Guard", false)
							else
								Damage()
							end
						end
					end
				)
			end
		end, "Disconnect")
	)

	NewJanitor:Add(Tool.Remotes.Guard.OnServerEvent:Connect(function(ReceivedPlayer: Player, Value: boolean)
		if not Player or not Character or not Humanoid or not RootPart or not Equipped then
			return
		end

		if ReceivedPlayer ~= Player then
			ReceivedPlayer:Kick("nice going idiot")
			return
		end

		if
			Humanoid:GetState() == Enum.HumanoidStateType.Dead
			or Humanoid.PlatformStand == true
			or Humanoid:GetAttribute("Stun") == true
			or Tool:GetAttribute("Stun") == true
		then
			return
		end

		if Value == true and Equipped == true then
			Humanoid:SetAttribute("Guard", Value)

			task.defer(function()
				while Humanoid:GetAttribute("Guard") == true do
					if Humanoid:GetAttribute("Stamina") < Tool:GetAttribute("GuardStaminaCost") then
						Humanoid:SetAttribute("Guard", false)
						break
					end

					if Equipped ~= true then
						Humanoid:SetAttribute("Guard", false)
						break
					end

					task.wait(0.15)

					Humanoid:SetAttribute(
						"Stamina",
						math.clamp(
							Humanoid:GetAttribute("Stamina") - Tool:GetAttribute("GuardStaminaCost"),
							0,
							Humanoid:GetAttribute("MaxStamina")
						)
					)

					task.wait()
				end
			end)
		else
			Humanoid:SetAttribute("Guard", false)
		end
	end))
end

return MeleeToolModule
