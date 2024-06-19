local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

local Janitor = require(ReplicatedStorage.Source.Modules.Utility.Janitor)
local MeleeModule = require(script.Parent.MeleeModule_Client)

local Character
local Humanoid
local RootPart

local StrikeOrder = 1

local Equipped = false

local Loaded = false

local Animations

local function GetRandomAnimation(Name : string, DontRepeat : boolean?)
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

local function GetAnimationsWithName(Name : string)
    local ReturnAnimations = {}

    for _, Animation in Animations do
        if string.find(Animation.Name, Name) then
            table.insert(ReturnAnimations, Animation)
        end
    end

    return ReturnAnimations
end

local MeleeToolModule = {}

function MeleeToolModule.Load(Tool : Tool)
    local NewJanitor = Janitor.new()
    NewJanitor:LinkToInstances(Character, Tool)

    Tool.Equipped:Connect(function()
        Character = Tool:FindFirstAncestorOfClass("Model")
        Humanoid = Character:FindFirstChildOfClass("Humanoid")
        RootPart = Humanoid.RootPart

        local Animator = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", Humanoid)

        if Loaded == false then
            Loaded = true
            Animations = MeleeModule:LoadAnimations(Animator, Tool.Animations)
        end

        Animations.SheathIdle:Play()
        
        task.delay(0.2, function()
            Animations.Idle:Play()
        end)

        Equipped = true
    end)

    Tool.Unequipped:Connect(function()
        Equipped = false

        task.delay(0.2, function()
            Animations.Idle:Stop()
        end)
    end)

    NewJanitor:Add(UserInputService.InputBegan:Connect(function(Input : InputObject, GPE : boolean)
        if GPE then
            return
        end

        if not Player or not Humanoid or not Character or not RootPart then
            return
        end

        if Equipped == false or Humanoid.PlatformStand == true or Humanoid.Sit == true or Humanoid:GetState() == Enum.HumanoidStateType.Dead or RootPart.Anchored == true then
            return
        end

        if Input.UserInputType == Enum.UserInputType.MouseButton1 and Humanoid:GetAttribute("Stamina") >= Tool:GetAttribute("StaminaCost") and Tool:GetAttribute("Debounce_Attack") == false then
            Tool:SetAttribute("Debounce_Attack", true)

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

            Tool:SetAttribute("Debounce_Attack", false)
        end
    end), "Disconnect")

end

return MeleeToolModule