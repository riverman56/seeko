local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

local Janitor = require(ReplicatedStorage.Modules.Utility.Janitor)
local CommonFunctions = require(ReplicatedStorage.Modules.Utility.CommonFunctions)
local MeleeModule = require(script.Parent.MeleeModule_Client)

local MeleeToolModule = {}

function MeleeToolModule.Load(Tool: Tool)
	local NewJanitor = Janitor.new()

	local Character
	local Humanoid
	local RootPart

	local LastEquip = 0
	local LastStrike = 0
	local LastGuard = 0

	local StrikeOrder = 1

	local Equipped = false
	local Guarding = false
	local AttackDebounce = false

	local Loaded = false

	local Animations

	local function GetRandomAnimation(Name: string, DontRepeat: boolean?)
		local ReturnAnimations = {}

		for _, LoadedAnimation in Animations do
			if string.find(LoadedAnimation.Name, Name) then
				table.insert(ReturnAnimations, LoadedAnimation)
			end
		end

		if #ReturnAnimations <= 0 then
			if DontRepeat then
				return nil
			else
				return GetRandomAnimation(Name)
			end
		else
			return ReturnAnimations[math.random(#ReturnAnimations)]
		end
	end

	local function GetAnimationsWithName(Name: string)
		local ReturnAnimations = {}

		for _, Animation in Animations do
			if string.find(Animation.Name, Name) then
				local AnimationIndex = tonumber(Animation.Name:match("%d+"))
				ReturnAnimations[AnimationIndex] = Animation
				-- table.insert(ReturnAnimations, Animation)
			end
		end

		return ReturnAnimations
	end

	Tool.Equipped:Connect(function()
		Character = Tool:FindFirstAncestorOfClass("Model")
		Humanoid = Character:FindFirstChildOfClass("Humanoid")
		RootPart = Humanoid.RootPart

		LastEquip = os.clock()

		NewJanitor:LinkToInstances(Character, Tool)

		if
			Player.PlayerGui.UserInterface.Menus.Crosshair.Visible == false
			and UserInputService.MouseIconEnabled == true
		then
			Player.PlayerGui.UserInterface.Menus.Crosshair.Visible = true
			UserInputService.MouseIconEnabled = false
		end

		local Animator = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", Humanoid)

		if Loaded == false then
			Loaded = true
			Animations = MeleeModule:LoadAnimations(Animator, Tool.Animations)
		end

		Guarding = false

		if Animations.Guard and Animations.Guard.IsPlaying == true then
			Animations.Guard:Stop()
		end

		if Animations.SheathIdle.IsPlaying == false then
			Animations.SheathIdle:Play()
		end

		task.delay(0.2, function()
			Animations.Idle:Play()
		end)

		Equipped = true
	end)

	Tool.Unequipped:Connect(function()
		Equipped = false

		Guarding = false

		if
			Player.PlayerGui.UserInterface.Menus.Crosshair.Visible == true
			and UserInputService.MouseIconEnabled == false
		then
			Player.PlayerGui.UserInterface.Menus.Crosshair.Visible = false
			UserInputService.MouseIconEnabled = true
		end

		if Animations.Guard and Animations.Guard.IsPlaying == true then
			Animations.Guard:Stop()
		end

		task.delay(0.2, function()
			Animations.Idle:Stop()
		end)
	end)

	NewJanitor:Add(
		UserInputService.InputBegan:Connect(function(Input: InputObject, GPE: boolean)
			if GPE then
				return
			end

			if not Player or not Humanoid or not Character or not RootPart then
				return
			end

			if os.clock() - LastEquip < 1 then
				return
			end

			if
				Equipped == false
				or Humanoid.PlatformStand == true
				or Humanoid.Sit == true
				or Humanoid:GetState() == Enum.HumanoidStateType.Dead
				or RootPart.Anchored == true
			then
				return
			end

			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				and Humanoid:GetAttribute("Stamina") >= Tool:GetAttribute("StaminaCost")
				and Tool:GetAttribute("Debounce_Attack") == false
				and AttackDebounce == false
				and Humanoid:GetAttribute("Guard") == false
				and Guarding == false
			then
				if os.clock() - LastStrike >= 1 then
					StrikeOrder = 1
				end

				LastStrike = os.clock()

				Tool:SetAttribute("Debounce_Attack", true)
				AttackDebounce = true

				local AttackAnimations = GetAnimationsWithName("Attack_")

				for _, AttackAnimation in AttackAnimations do
					if AttackAnimation.IsPlaying == true then
						AttackAnimation:Stop(0.2)
					end
				end

				local AttackAnimation = AttackAnimations[StrikeOrder]

				if not AttackAnimation then
					Tool:SetAttribute("Debounce_Attack", false)
					StrikeOrder = 1
					return
				end

				AttackAnimation:Play()
				AttackAnimation:AdjustSpeed(Tool:GetAttribute("SpeedModifier"))

				if StrikeOrder < #AttackAnimations then
					StrikeOrder += 1
				else
					StrikeOrder = 1
				end

				AttackAnimation:GetMarkerReachedSignal("HitStart"):Once(function(...)
					CommonFunctions.PlayRandomSound(Tool.SFX, "SFX_Swing", RootPart)
					Tool.Remotes.Attack:FireServer(AttackAnimation)

					for _, Object in Character:GetDescendants() do
						if Object:IsA("Trail") and Object:GetAttribute("StrikeEnable") ~= nil then
							Object.Enabled = true
						end
					end
				end)

				AttackAnimation:GetMarkerReachedSignal("HitStop"):Once(function(...)
					Tool:SetAttribute("Debounce_Attack", false)
					AttackDebounce = false

					for _, Object in Character:GetDescendants() do
						if
							Object:IsA("Trail")
							and Object:GetAttribute("StrikeEnable") ~= nil
							and Object.Enabled == true
						then
							Object.Enabled = false
						end
					end
				end)
			end

			if
				Input.UserInputType == Enum.UserInputType.MouseButton2
				and Humanoid:GetAttribute("Stamina") > Tool:GetAttribute("GuardStaminaCost")
				and Tool:GetAttribute("Debounce_Attack") == false
				and Humanoid:GetAttribute("Guard") == false
				and AttackDebounce == false
			then
				if os.clock() - LastGuard < 0.5 then
					return
				end

				LastGuard = os.clock()

				Animations.Guard:Play()
				Tool.Remotes.Guard:FireServer(true)

				Guarding = true
			end
		end),
		"Disconnect"
	)

	NewJanitor:Add(
		UserInputService.InputEnded:Connect(function(Input: InputObject, GPE: boolean)
			if GPE then
				return
			end

			if not Player or not Humanoid or not Character or not RootPart then
				return
			end

			if Input.UserInputType == Enum.UserInputType.MouseButton2 then
				if Animations.Guard and Animations.Guard.IsPlaying == true then
					Animations.Guard:Stop()
					Tool.Remotes.Guard:FireServer(false)
					Guarding = false
				end
			end
		end),
		"Disconnect"
	)
end

return MeleeToolModule
