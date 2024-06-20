local Debris = game:GetService("Debris")

local CommonFunctions = {}

local EmissionFaces = {
	"Back",
	"Bottom",
	"Front",
	"Left",
	"Right",
	"Top"
}

function CommonFunctions.GetRandom(Minimum : any, Maximum : any)
	if typeof(Minimum) == "Vector3" and typeof(Maximum) == "Vector3" then
		local X = CommonFunctions.GetRandom(Minimum.X, Maximum.X)
		local Y = CommonFunctions.GetRandom(Minimum.Y, Maximum.Y)
		local Z = CommonFunctions.GetRandom(Minimum.Z, Maximum.Z)
		
		return Vector3.new(X, Y, Z)
	elseif typeof(Minimum) == "Vector3" and (typeof(Maximum) == "boolean" or Maximum == nil) then
		if Maximum == true then
			local X = CommonFunctions.GetRandom(-Minimum.X, Minimum.X)
			local Y = CommonFunctions.GetRandom(-Minimum.Y, Minimum.Y)
			local Z = CommonFunctions.GetRandom(-Minimum.Z, Minimum.Z)
			
			return Vector3.new(X, Y, Z)
		else
			local X = CommonFunctions.GetRandom(0, Minimum.X)
			local Y = CommonFunctions.GetRandom(0, Minimum.Y)
			local Z = CommonFunctions.GetRandom(0, Minimum.Z)
			
			return Vector3.new(X, Y, Z)
		end

	elseif typeof(Minimum) == "number" and (typeof(Maximum) == "boolean" or Maximum == nil) then
		if Maximum == true then
			return Random.new():NextNumber(-Minimum, Minimum)
		else
			return Random.new():NextNumber(0, Minimum)
		end

	elseif typeof(Minimum) == "number" and typeof(Maximum) == "number" then
		return Random.new():NextNumber(Minimum, Maximum)
	elseif typeof(Minimum) == "NumberRange" then
		return Random.new():NextNumber(Minimum.Min, Minimum.Max)
	end
end

function CommonFunctions.PlaySound(Origin : (BasePart | Vector3), Sound : Sound, CleanTime : number?, PitchRange : NumberRange?)
	local Holder = (typeof(Origin) == "Instance" and Origin) or (function()
		local Part = Instance.new("Part")
		Part.Anchored = true
		Part.CanCollide = false
		Part.CanQuery = false
		Part.CanTouch = false
		Part.Position = Origin
		Part.Transparency = 1
		
		Part.Parent = workspace.Visuals
		
		return Part
	end)()
	
	local Clone : Sound = Sound:Clone()
	
	if PitchRange then
		Clone.PlaybackSpeed = CommonFunctions.GetRandom(PitchRange)
	end
	
	Clone.Parent = Holder
	Clone:Play()
	
	local Connection : RBXScriptConnection
	Connection = Clone.Ended:Once(function()
		if Connection then
			Connection:Disconnect()
			Connection = nil
		end
		
		Clone:Destroy()
		
		if typeof(Origin) == "Vector3" then
			Holder:Destroy()
		end
	end)
	
	local DestroyTime = CleanTime or 100
	
	Debris:AddItem(Clone, DestroyTime)
	
	return Clone
end

function CommonFunctions.PlayRandomSound(Origin : Instance, SoundName : string, Parent : Instance)
	local Sounds = {}

	for _, Object in Origin:GetDescendants() do
		if not Object:IsA("Sound") then
			continue
		end

		if string.find(Object.Name, SoundName) then
			table.insert(Sounds, Object)
		end
	end

	if Parent and typeof(Origin) == "Instance" then
		local ChosenSound = Sounds[math.random(#Sounds)]:Clone()
		ChosenSound.Parent = Parent
		ChosenSound:Play()

		Debris:AddItem(ChosenSound, ChosenSound.TimeLength / ChosenSound.PlaybackSpeed)
	elseif typeof(Parent) == "Vector3" then
		local ChosenSound = Sounds[math.random(#Sounds)]:Clone()
		
		local SoundPart = Instance.new("Part")
		SoundPart.Anchored = true
		SoundPart.CanCollide = false
		SoundPart.CanTouch = false
		SoundPart.CanQuery = false
		SoundPart.Size = Vector3.zero
		SoundPart.Transparency = 1
		SoundPart.Position = Parent
		SoundPart.Parent = workspace.Visuals 

		ChosenSound.Parent = SoundPart
		ChosenSound:Play()

		Debris:AddItem(ChosenSound, ChosenSound.TimeLength / ChosenSound.PlaybackSpeed)
		Debris:AddItem(SoundPart, ChosenSound.TimeLength / ChosenSound.PlaybackSpeed)
	end
end

function CommonFunctions.SpawnParticle(Origin : Instance, Name : string, NewParent : Instance, RandomEmissionFace : boolean?)
	RandomEmissionFace = RandomEmissionFace or false

	task.spawn(function()
		for _, Particle in Origin:GetDescendants() do
			if not Particle:IsA("ParticleEmitter") then
				continue
			end

			if string.find(Particle.Name, Name) then
				local NewParticle = Particle:Clone()
				NewParticle.Name = "TemporaryParticle"
				NewParticle.Parent = NewParent
				
				if RandomEmissionFace then
					if NewParticle:GetAttribute("AdvancedParticle") ~= nil then
						NewParticle.Emission:SetAttribute("EmissionFace", EmissionFaces[math.random(#EmissionFaces)])
					else
						NewParticle.EmissionFace = Enum.NormalId[EmissionFaces[math.random(#EmissionFaces)]]
					end
				end

				NewParticle.Enabled = true

				task.delay(0.1, function()
					NewParticle.Enabled = false
					Debris:AddItem(NewParticle, 10)
				end)
			end
		end
	end)
end

function CommonFunctions.CheckStatus(Humanoid : Humanoid, HitHumanoid : Humanoid, Damage : number, Settings : any)
	local Character = Humanoid:FindFirstAncestorOfClass("Model")
	local HitCharacter = HitHumanoid:FindFirstAncestorOfClass("Model")

	local RootPart = Humanoid.RootPart
	local HitRootPart = HitHumanoid.RootPart

	local Tool = Character:FindFirstChildOfClass("Tool")
	local HitCharacterTool = HitCharacter:FindFirstChildOfClass("Tool")
	
	if HitHumanoid:GetAttribute("Guard") == true then
		local Direction = (HitRootPart.Position - RootPart.Position).Unit
		local Result = Direction:Dot(HitRootPart.CFrame.LookVector.Unit)

		if Result > -0.15  then
			return "Damaged"
		end

		return "Blocked"
	end

	return "Damaged"
end

return CommonFunctions