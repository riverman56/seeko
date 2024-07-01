task.wait(1)

local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function ChangeLighting(Configuration: Configuration)
    if Configuration == nil then
        return
    end

	if not Configuration:IsA("Configuration") or Configuration:GetAttribute("Ambient") == nil then
		return
	end

	for _, Object in Lighting:GetChildren() do
		if Object:GetAttribute("Ambient") ~= nil then
			continue
		end

		Object:Destroy()
	end

	for _, Object in Configuration:GetChildren() do
		Object:Clone().Parent = Lighting
	end

	Lighting.Ambient = Configuration:GetAttribute("Ambient")
	Lighting.Brightness = Configuration:GetAttribute("Brightness")
	Lighting.ColorShift_Bottom = Configuration:GetAttribute("ColorShift_Bottom")
	Lighting.ColorShift_Top = Configuration:GetAttribute("ColorShift_Top")
	Lighting.EnvironmentDiffuseScale = Configuration:GetAttribute("EnvironmentDiffuseScale")
	Lighting.EnvironmentSpecularScale = Configuration:GetAttribute("EnvironmentSpecularScale")
	Lighting.GlobalShadows = Configuration:GetAttribute("GlobalShadows")
	Lighting.OutdoorAmbient = Configuration:GetAttribute("OutdoorAmbient")
	Lighting.ShadowSoftness = Configuration:GetAttribute("ShadowSoftness")

	Lighting.ClockTime = Configuration:GetAttribute("ClockTime")
	Lighting.GeographicLatitude = Configuration:GetAttribute("GeographicLatitude")
	Lighting.ExposureCompensation = Configuration:GetAttribute("ExposureCompensation")

	local HideEnhanceParts = Configuration:GetAttribute("HideEnhanceParts") or false

	if HideEnhanceParts ~= nil then
		for _, Part in workspace["Light_Enhance"]:GetChildren() do
			if not Part:IsA("BasePart") then
				continue
			end

			Part.Transparency = HideEnhanceParts and 1 or 0
		end
	end
end

local AmbientSound_Manager = require(ReplicatedStorage:WaitForChild("AmbientSound_Manager"))
AmbientSound_Manager.Run()

ChangeLighting(Lighting.CurrentAtmosphere.Value)

Lighting.CurrentAtmosphere:GetPropertyChangedSignal("Value"):Connect(function()
    ChangeLighting(Lighting.CurrentAtmosphere.Value)
end)