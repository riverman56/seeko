local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local Assets = ReplicatedStorage.Assets

local Library = Assets.Library

local Player = Players.LocalPlayer

local HitmarkerInfo = TweenInfo.new(0.12, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

local KillEffectShort = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local KillEffectLong = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

local DamageIndicatorTween = TweenInfo.new(0.75, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local OtherIndicatorTween = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.In)

local DamageHighlightTween = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

local Effects = {}

function Effects.Hitbox(CFrame: CFrame, Size: Vector3)
	if Player:GetAttribute("Hitbox") ~= true then
		return
	end

	if Player:DistanceFromCharacter(CFrame.Position) >= 50 then
		return
	end

	local Visual = Instance.new("Part")
	Visual.Anchored = true
	Visual.CanCollide = false
	Visual.CanQuery = false
	Visual.CanTouch = false
	Visual.CFrame = CFrame
	Visual.Size = Size
	Visual.Material = Enum.Material.Neon
	Visual.Transparency = 0.75
	Visual.Color = Color3.fromRGB(92, 145, 255)
	Visual.Parent = workspace.Visuals

	Debris:AddItem(Visual, 0.1)
end

function Effects.DamageEffects(Character : Model, Object : BasePart, Damage : number)
	if Player:DistanceFromCharacter(Object.Position) >= 50 or Player:DistanceFromCharacter(Character.PrimaryPart.Position) >= 50 then
		return
	end

	if Object == nil or Damage == nil then
		return
	end

	local NewHighlight = Instance.new("Highlight")
	NewHighlight.OutlineTransparency = 1
	NewHighlight.FillTransparency = 0.3
	NewHighlight.FillColor = Color3.fromRGB(196, 0, 4)
	NewHighlight.DepthMode = Enum.HighlightDepthMode.Occluded
	NewHighlight.Parent = Character

	TweenService:Create(NewHighlight, DamageHighlightTween, { FillTransparency = 1 }):Play()

	Debris:AddItem(NewHighlight, DamageHighlightTween.Time + 0.1)

	local IndicatorPart: Part = Library.Parts.Damage:Clone()
	local Indicator: BillboardGui = IndicatorPart.UI

	Indicator.Text.Text = Damage
	Indicator.ExtentsOffset = Vector3.new(math.random(-4, 4), math.random(-2, 2), 0)
	Indicator.Size += UDim2.fromScale(1, 1)

	IndicatorPart.CFrame = Object.CFrame
	IndicatorPart.Parent = workspace.Visuals

	TweenService
		:Create(Indicator, DamageIndicatorTween, { ExtentsOffset = Indicator.ExtentsOffset + Vector3.new(0, 3, 0) })
		:Play()
	TweenService:Create(Indicator, OtherIndicatorTween, { Size = Indicator.Size - UDim2.fromScale(1, 1) }):Play()
	TweenService:Create(Indicator.Text, OtherIndicatorTween, { TextTransparency = 1, TextStrokeTransparency = 1 })
		:Play()

	Debris:AddItem(IndicatorPart, 1)
end

function Effects.Hitmarker()
	local Gui = Player.PlayerGui.Crosshair.Frame

	local Crosshair = Gui.Crosshair
	local Hitmarker = Crosshair.Hitmarker

	Hitmarker.Rotation = math.random(-15, 15)
	Hitmarker.ImageTransparency = 0

	task.wait(0.1)

	TweenService:Create(Hitmarker, HitmarkerInfo, { ImageTransparency = 1 }):Play()
end

function Effects.KillEffect()
	local Gui = Player.PlayerGui:WaitForChild("ScreenEffects")

	local Viginette = Gui:WaitForChild("Viginette")

	Library.Sounds.KillSound:Play()

	for _, ColorCorrection in Lighting:GetChildren() do
		if not ColorCorrection:IsA("ColorCorrectionEffect") or ColorCorrection.Enabled ~= true then
			continue
		end

		local OriginalSettings = {
			["Brightness"] = ColorCorrection.Brightness,
			["Contrast"] = ColorCorrection.Contrast,
			["Saturation"] = ColorCorrection.Saturation,
			["TintColor"] = ColorCorrection.TintColor,
		}

		ColorCorrection.Brightness = 0
		ColorCorrection.Contrast = 0
		ColorCorrection.Saturation = 0
		ColorCorrection.TintColor = Color3.new(1, 1, 1)

		task.delay(0.25, function()
			TweenService:Create(ColorCorrection, KillEffectLong, OriginalSettings)
		end)
	end

	local KillCC = Assets.Effects.KillCC:Clone()
	KillCC.Parent = Lighting

	Viginette.Visible = false
	Viginette.ImageTransparency = 0

	KillCC.Enabled = true

	TweenService:Create(KillCC, KillEffectShort, {
		["Brightness"] = 0,
		["Contrast"] = 0.5,
		["Saturation"] = -1,
		["TintColor"] = Color3.fromRGB(255, 47, 47),
	}):Play()

	task.wait(0.25)

	TweenService:Create(KillCC, KillEffectLong, {
		["Brightness"] = 0,
		["Contrast"] = 0,
		["Saturation"] = 0,
		["TintColor"] = Color3.fromRGB(255, 255, 255),
	}):Play()

	TweenService:Create(Viginette, KillEffectLong, { ImageTransparency = 1 }):Play()

	task.wait(0.5)

	KillCC:Destroy()
	Viginette.Visible = false
end

return Effects
