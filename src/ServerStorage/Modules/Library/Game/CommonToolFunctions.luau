local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommonToolFunctions = {}

function CommonToolFunctions.CreateM6D(Part0: BasePart, Part1: BasePart)
	local Motor6D = Instance.new("Motor6D")
	Motor6D.Part0 = Part0
	Motor6D.Part1 = Part1
	Motor6D.Name = Part1.Name
	Motor6D.Parent = Part1

	return Motor6D
end

function CommonToolFunctions.GetCharacterInstances(Player: Player)
	local Character = Player.Character or Player.CharacterAdded:Wait()
	local Humanoid: Humanoid = Character:FindFirstChildOfClass("Humanoid")
	local Animator: Animator = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", Humanoid)
	local RootPart: BasePart = Humanoid.RootPart

	return Character, Humanoid, RootPart, Animator
end

function CommonToolFunctions.LoadModel_Other(Model: Model, Character: Model, Tool: Tool)
	assert(
		Model and typeof(Model) == "Instance" and Model:IsA("Model"),
		"Unexpected argument #1, expected Instance<Model>, got " .. typeof(Model)
	)
	assert(
		Character and typeof(Character) == "Instance" and Character:IsA("Model"),
		"Unexpected argument #2, expected Instance<Model>, got " .. typeof(Character)
	)
	assert(
		Tool and typeof(Tool) == "Instance" and Tool:IsA("Tool"),
		"Unexpected argument #3, expected Instance<Tool>, got " .. typeof(Tool)
	)

	local ToolModel = Model:Clone()

	local MainHandle
	local SheathHandle

	for _, Object in ToolModel:GetDescendants() do
		if not Object:IsA("BasePart") then
			continue
		end

		if Object:GetAttribute("MainHandle") == true then
			MainHandle = Object
		elseif Object:GetAttribute("SheathHandle") == true then
			SheathHandle = Object
		end
	end

	if not SheathHandle then
		CommonToolFunctions.CreateM6D(Character["Right Arm"], MainHandle)
	else
		local Weld = Instance.new("Weld")
		Weld.Part0 = SheathHandle
		Weld.Parent = SheathHandle
		CommonToolFunctions.CreateM6D(SheathHandle, MainHandle)
	end

	ToolModel.Name = Tool:GetAttribute("ToolType")
	ToolModel.Parent = Character

	return ToolModel
end

function CommonToolFunctions.LoadModelSkin(Player: Player, Model: Model, Tool: Tool)
	assert(
		Player and typeof(Player) == "Instance" and Player:IsA("Player"),
		"Unexpected argument #1, expected Instance<Player>, got " .. typeof(Player)
	)
	assert(
		Tool and typeof(Tool) == "Instance" and Tool:IsA("Tool"),
		"Unexpected argument #3, expected Instance<Tool>, got " .. typeof(Tool)
	)

	local Character, Humanoid, RootPart = CommonToolFunctions.GetCharacterInstances(Player)

	if not Character or not Humanoid or not RootPart then
		return
	end

	for _, Object in Character:GetChildren() do
		if Object.Name == "WeaponModel" then
			Object:Destroy()
		end
	end

	local WeaponModel = Model:Clone()

	local MainHandle
	local SheathHandle

	for _, Object in WeaponModel:GetDescendants() do
		if not Object:IsA("BasePart") then
			continue
		end

		if Object:GetAttribute("MainHandle") == true then
			MainHandle = Object
		elseif Object:GetAttribute("SheathHandle") == true then
			CommonToolFunctions.CreateM6D(Character.Torso, Object)
			SheathHandle = Object
		elseif Object:GetAttribute("Handle") ~= nil and Object ~= MainHandle and Object ~= SheathHandle then
			CommonToolFunctions.CreateM6D(
				Character:FindFirstChild(Object:GetAttribute("Handle")) or Character.Torso,
				Object
			)
		end
	end

	if MainHandle:GetAttribute("LoadDefaultEffects") == true then
		for _, Object in ReplicatedStorage.Assets.Effects.DefaultPreset.Particles:GetChildren() do
			Object:Clone().Parent = MainHandle.Particles
		end

		for _, Object in ReplicatedStorage.Assets.Effects.DefaultPreset.Trails:GetChildren() do
			local Trail = Object:Clone()
			Trail.Attachment0 = MainHandle.Shaft
			Trail.Attachment1 = MainHandle.Tip
			Trail.Parent = MainHandle
		end
	end

	if not SheathHandle then
		CommonToolFunctions.CreateM6D(
			Character:FindFirstChild(MainHandle:GetAttribute("Handle")) or Character["Right Arm"],
			MainHandle
		)
	else
		local Weld = Instance.new("Weld")
		Weld.Part0 = SheathHandle
		Weld.Parent = SheathHandle
		CommonToolFunctions.CreateM6D(SheathHandle, MainHandle)
	end

	WeaponModel.Name = "WeaponModel"
	WeaponModel.Parent = Character

	return WeaponModel
end

return CommonToolFunctions
