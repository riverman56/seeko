local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Assets = ReplicatedStorage.Assets
local Modules = ReplicatedStorage.Modules

local Library = Assets.Library

local Player = Players.LocalPlayer

local DamageIndicatorTween = TweenInfo.new(0.75, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local OtherIndicatorTween = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.In)

local DamageHighlightTween = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

local Effects = {}

function Effects.Hitbox(CFrame : CFrame, Size : Vector3)
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
    Visual.Transparency = 0.8
    Visual.Color = Color3.fromRGB(255, 0, 4)
    Visual.Parent = workspace.Visuals

    Debris:AddItem(Visual, 0.1)
end

function Effects.DamageIndicator(Object : BasePart, Damage : number)
    if Player:DistanceFromCharacter(Object.Position) >= 50 then
        return
    end

    if Object == nil or Damage == nil then
        return
    end

    local IndicatorPart : Part = Library.Parts.Damage:Clone()
    local Indicator : BillboardGui = IndicatorPart.UI

    Indicator.Text.Text = Damage
    Indicator.ExtentsOffset = Vector3.new(math.random(-4, 4), math.random(-2, 2), 0)
    Indicator.Size += UDim2.fromScale(1, 1)

    IndicatorPart.CFrame = Object.CFrame
    IndicatorPart.Parent = workspace.Visuals
    
    TweenService:Create(Indicator, DamageIndicatorTween, {ExtentsOffset = Indicator.ExtentsOffset + Vector3.new(0, 3, 0)}):Play()
    TweenService:Create(Indicator, OtherIndicatorTween, {Size = Indicator.Size - UDim2.fromScale(1, 1)}):Play()
    TweenService:Create(Indicator.Text, OtherIndicatorTween, {TextTransparency = 1, TextStrokeTransparency = 1}):Play()

    Debris:AddItem(IndicatorPart, 1)
end

function Effects.DamageHighlight(Character : Model)
    if Player:DistanceFromCharacter(Character.PrimaryPart.Position) >= 50 then
        return
    end
    
    local NewHighlight = Instance.new("Highlight")
    NewHighlight.OutlineTransparency = 1
    NewHighlight.FillTransparency = 0.3
    NewHighlight.FillColor = Color3.fromRGB(196, 0, 4)
    NewHighlight.DepthMode = Enum.HighlightDepthMode.Occluded
    NewHighlight.Parent = Character
    
    TweenService:Create(NewHighlight, DamageHighlightTween, {FillTransparency = 1}):Play()

    Debris:AddItem(NewHighlight, DamageHighlightTween.Time + 0.1)
end

return Effects