local TagSystem = {}
TagSystem.CharacterEvents = {}

function TagSystem.Tag(Character: Model, Tagger: Model, Damage: number?, Duration: number?)
	assert(
		Character and typeof(Character) == "Instance" and Character:IsA("Model"),
		"Unexpected argument #1, expected Instance<Model>, got "
			.. string.format("%s<%s>", typeof(Character), Character.ClassName)
	)
	assert(
		Tagger and typeof(Tagger) == "Instance" and Tagger:IsA("Model"),
		"Unexpected argument #2, expected Instance<Model>, got "
			.. string.format("%s<%s>", typeof(Tagger), Tagger.ClassName or nil)
	)

	if Damage then
		assert(Damage and typeof(Damage) == "number", "Unexpected argument #3, expected number, got " .. typeof(Damage))
	end

	if Duration then
		assert(
			Duration and typeof(Duration) == "number",
			"Unexpected argument #4, expected number, got " .. typeof(Duration)
		)
	end

	local TagFolder = Character:FindFirstChild("TagFolder")

	if not TagFolder then
		warn("No TagFolder Found")
		return
	end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local TagHumanoid = Tagger:FindFirstChildOfClass("Humanoid")

    assert(Humanoid and typeof(Humanoid) == "Instance" and Humanoid:IsA("Humanoid"), "\"Character\" does not contain a Humanoid.")
    assert(TagHumanoid and typeof(TagHumanoid) == "Instance" and TagHumanoid:IsA("Humanoid"), "\"Tagger\" does not contain a Humanoid.")

    Humanoid:SetAttribute("CombatTime", Duration or 10)
    TagHumanoid:SetAttribute("CombatTime", Duration or 10)

	if not TagFolder:FindFirstChild(Tagger.Name) then
		local TagObject = Instance.new("ObjectValue")
		TagObject.Name = Tagger.Name
		TagObject.Value = Tagger
		TagObject.Parent = TagFolder

        TagObject:SetAttribute("TagTime", Duration or 10)

        task.spawn(function()
			repeat
				wait(1)
				TagObject:SetAttribute("TagTime", TagObject:GetAttribute("TagTime") - 1)
			until TagObject:GetAttribute("TagTime") <= 0

			TagObject:Destroy()
		end)
	else
        TagFolder[Tagger.Name]:SetAttribute("TagTime", Duration or 10)
    end
end

return TagSystem
