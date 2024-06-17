local Debris = game:GetService("Debris")

local CommonFunctions = {}

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

return CommonFunctions