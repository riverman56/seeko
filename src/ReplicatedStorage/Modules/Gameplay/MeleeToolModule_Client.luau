local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

local Player = Players.LocalPlayer

local Janitor = require(ReplicatedStorage.Modules.Utility.Janitor)
local CommonFunctions = require(ReplicatedStorage.Modules.Utility.CommonFunctions)
local MeleeModule = require(script.Parent.MeleeModule_Client)
local PlayerControls = require(ReplicatedStorage.Modules.Gameplay.PlayerControls)

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
	local GuardBreakDebounce = false

	local Loaded = false

	local Animations

	local RemotesFolder = Tool:WaitForChild("Remotes")
	local AnimationsFolder = Tool:WaitForChild("Animations")
	local SFXFolder = Tool:WaitForChild("SFX")

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
			end
		end

		return ReturnAnimations
	end

	local function RunAttack()
		Tool:SetAttribute("Debounce_Attack", true)
		AttackDebounce = true

		if os.clock() - LastStrike >= 1 then
			StrikeOrder = 1
		end

		LastStrike = os.clock()

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

		AttackAnimation:GetMarkerReachedSignal("HitStart"):Once(function()
			CommonFunctions.PlayRandomSound(SFXFolder, AttackAnimation.Animation:GetAttribute("SFX_Swing"), RootPart)
			RemotesFolder.Attack:FireServer(AttackAnimation.Animation)

			for _, Object in Character:GetDescendants() do
				if Object:IsA("Trail") and Object:GetAttribute("StrikeEnable") ~= nil then
					Object.Enabled = true
				end
			end
		end)

		AttackAnimation:GetMarkerReachedSignal("HitStop"):Once(function()
			Tool:SetAttribute("Debounce_Attack", false)
			AttackDebounce = false

			for _, Object in Character:GetDescendants() do
				if Object:IsA("Trail") and Object:GetAttribute("StrikeEnable") ~= nil and Object.Enabled == true then
					Object.Enabled = false
				end
			end
		end)
	end

	local function RunBlock()
		if os.clock() - LastGuard < 0.5 then
			return
		end

		LastGuard = os.clock()

		RemotesFolder.Guard:FireServer(true)

		Guarding = true
	end

	local function RunGuardBreak()
		Tool:SetAttribute("Debounce_Attack", true)
		Tool:SetAttribute("Debounce_GuardBreak", true)
		AttackDebounce = true
		GuardBreakDebounce = true

		local AttackAnimations = GetAnimationsWithName("Attack_")

		for _, AttackAnimation in AttackAnimations do
			if AttackAnimation.IsPlaying == true then
				AttackAnimation:Stop(0.2)
			end
		end

		local AttackAnimation = Animations.GuardBreak
		AttackAnimation:Play(0.1)
		AttackAnimation:AdjustSpeed(Tool:GetAttribute("SpeedModifier"))

		AttackAnimation:GetMarkerReachedSignal("HitStart"):Once(function()
			CommonFunctions.PlayRandomSound(SFXFolder, AttackAnimation.Animation:GetAttribute("SFX_Swing"), RootPart)
			RemotesFolder.Attack:FireServer(AttackAnimation.Animation)
		end)

		AttackAnimation:GetMarkerReachedSignal("HitStop"):Once(function()
			Tool:SetAttribute("Debounce_Attack", false)
			AttackDebounce = false

			task.delay(3, function()
				GuardBreakDebounce = false
				Tool:SetAttribute("Debounce_GuardBreak", false)
			end)
		end)
	end

	local function RunGuardFalse()
		if Guarding == true and Equipped == true then
			RemotesFolder.Guard:FireServer(false)
			Guarding = false
		end
	end

	local function HandleAction(Action: string, InputState: Enum.UserInputState)
		if
			Equipped == false
			or Humanoid.PlatformStand == true
			or Humanoid.Sit == true
			or Humanoid:GetState() == Enum.HumanoidStateType.Dead
			or RootPart.Anchored == true
		then
			return
		end

		if InputState == Enum.UserInputState.Begin then
			if
				Action == "Attack"
				and Humanoid:GetAttribute("Stamina") >= Tool:GetAttribute("StaminaCost")
				and Tool:GetAttribute("Debounce_Attack") == false
				and AttackDebounce == false
				and Humanoid:GetAttribute("Guard") == false
				and Guarding == false
				and Humanoid:GetAttribute("Stun") ~= true
				and Tool:GetAttribute("Stun") ~= true
			then
				RunAttack()
			elseif
				Action == "Guard"
				and Humanoid:GetAttribute("Stamina") > Tool:GetAttribute("GuardStaminaCost")
				and Tool:GetAttribute("Debounce_Attack") == false
				and Humanoid:GetAttribute("Guard") == false
				and AttackDebounce == false
				and Humanoid:GetAttribute("Stun") ~= true
				and Tool:GetAttribute("Stun") ~= true
			then
				RunBlock()
			elseif
				Action == "Guardbreak"
				and Humanoid:GetAttribute("Stamina") > Tool:GetAttribute("GuardBreakStaminaCost")
				and Tool:GetAttribute("Debounce_Attack") == false
				and Tool:GetAttribute("Debounce_GuardBreak") == false
				and Humanoid:GetAttribute("Guard") == false
				and AttackDebounce == false
				and Humanoid:GetAttribute("Stun") ~= true
				and Tool:GetAttribute("Stun") ~= true
				and GuardBreakDebounce == false
			then
				RunGuardBreak()
			end
		elseif InputState == Enum.UserInputState.End then
			if Guarding == true then
				RunGuardFalse()
			end
		end
	end

	local function BindCASActions()
		ContextActionService:BindAction("Attack", HandleAction, true)
		ContextActionService:SetTitle("Attack", "Attack")
		ContextActionService:SetPosition("Attack", UDim2.new(0.2, 0, 0, 0))

		ContextActionService:BindAction("Guard", HandleAction, true)
		ContextActionService:SetTitle("Guard", "Guard")
		ContextActionService:SetPosition("Guard", UDim2.new(0.45, 0, 0, 0))

		ContextActionService:BindAction("Guardbreak", HandleAction, true)
		ContextActionService:SetTitle("Guardbreak", "Guardbreak")
		ContextActionService:SetPosition("Guardbreak", UDim2.new(0.7, 0, 0, 0))
	end

	local function UnbindCASActions()
		ContextActionService:UnbindAllActions()
	end

	Tool.Equipped:Connect(function()
		Character = Tool:FindFirstAncestorOfClass("Model")
		Humanoid = Character:FindFirstChildOfClass("Humanoid")
		RootPart = Humanoid.RootPart

		LastEquip = os.clock()

		NewJanitor:LinkToInstances(Character, Tool)

		BindCASActions()

		if
			Player.PlayerGui.Crosshair.Frame.Crosshair.Visible == false
			and UserInputService.MouseIconEnabled == true
		then
			Player.PlayerGui.Crosshair.Frame.Crosshair.Visible = true
			UserInputService.MouseIconEnabled = false
		end

		local Animator = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator")
		Animator.Parent = Humanoid

		if Loaded == false then
			Loaded = true
			Animations = MeleeModule:LoadAnimations(Animator, AnimationsFolder)
		end

		Guarding = false

		for _, AnimationTrack: AnimationTrack in Animator:GetPlayingAnimationTracks() do
			if not AnimationTrack:IsA("AnimationTrack") or not string.find(AnimationTrack.Name, "SheathIdle") then
				continue
			end

			AnimationTrack:Stop()
		end

		if Animations.Guard and Animations.Guard.IsPlaying == true then
			Animations.Guard:Stop()
		end

		if Animations.SheathIdle and Animations.SheathIdle.IsPlaying == false then
			Animations.SheathIdle:Play()
		end

		task.delay(0.2, function()
			if Animations.Idle and Animations.Idle.IsPlaying == false then
				Animations.Idle:Play()
			end
		end)

		Equipped = true
	end)

	Tool.Unequipped:Connect(function()
		Equipped = false

		Guarding = false
		UnbindCASActions()

		local OtherTool = Character:FindFirstChildOfClass("Tool")

		if OtherTool and OtherTool ~= Tool then
			if Animations.SheathIdle and Animations.SheathIdle.IsPlaying == true then
				Animations.SheathIdle:Stop()
			end
		end

		if
			Player.PlayerGui.Crosshair.Frame.Crosshair.Visible == true
			and UserInputService.MouseIconEnabled == false
		then
			Player.PlayerGui.Crosshair.Frame.Crosshair.Visible = false
			UserInputService.MouseIconEnabled = true
		end

		if Animations.Guard and Animations.Guard.IsPlaying == true then
			Animations.Guard:Stop()
		end

		task.delay(0.2, function()
			if Animations.Idle and Animations.Idle.IsPlaying == true then
				Animations.Idle:Stop()
			end
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
				(
					Input.KeyCode == PlayerControls["Attack"]
					or Input.UserInputType == PlayerControls["Attack"]
					or Input.KeyCode == Enum.KeyCode.ButtonR2
				)
				and Humanoid:GetAttribute("Stamina") >= Tool:GetAttribute("StaminaCost")
				and Tool:GetAttribute("Debounce_Attack") == false
				and AttackDebounce == false
				and Humanoid:GetAttribute("Guard") == false
				and Guarding == false
				and Humanoid:GetAttribute("Stun") ~= true
				and Tool:GetAttribute("Stun") ~= true
			then
				RunAttack()
			end

			if
				(
					Input.UserInputType == PlayerControls["Block"]
					or Input.KeyCode == PlayerControls["Block"]
					or Input.KeyCode == Enum.KeyCode.ButtonL2
				)
				and Humanoid:GetAttribute("Stamina") > Tool:GetAttribute("GuardStaminaCost")
				and Tool:GetAttribute("Debounce_Attack") == false
				and Humanoid:GetAttribute("Guard") == false
				and AttackDebounce == false
				and Humanoid:GetAttribute("Stun") ~= true
				and Tool:GetAttribute("Stun") ~= true
			then
				RunBlock()
			end

			if
				(
					Input.UserInputType == PlayerControls["Guardbreak"]
					or Input.KeyCode == PlayerControls["Guardbreak"]
					or Input.KeyCode == Enum.KeyCode.ButtonX
				)
				and Humanoid:GetAttribute("Stamina") > Tool:GetAttribute("GuardBreakStaminaCost")
				and Tool:GetAttribute("Debounce_Attack") == false
				and Tool:GetAttribute("Debounce_GuardBreak") == false
				and Humanoid:GetAttribute("Guard") == false
				and AttackDebounce == false
				and Humanoid:GetAttribute("Stun") ~= true
				and Tool:GetAttribute("Stun") ~= true
				and GuardBreakDebounce == false
			then
				RunGuardBreak()
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

			if
				Input.UserInputType == PlayerControls["Block"]
				or Input.KeyCode == PlayerControls["Block"]
				or Input.KeyCode == Enum.KeyCode.ButtonL2
			then
				RunGuardFalse()
			end
		end),
		"Disconnect"
	)
end

return MeleeToolModule
