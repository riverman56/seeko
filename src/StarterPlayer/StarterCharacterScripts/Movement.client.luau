local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Character = script:FindFirstAncestorOfClass("Model")
local Humanoid: Humanoid = Character:WaitForChild("Humanoid")
local Animator: Animator = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator")
Animator.Parent = Humanoid

local PlayerControls = require(ReplicatedStorage.Modules.Gameplay.PlayerControls)

local CanRun = false
local Moving = false
local Running = false

local SpeedBoost = 6

local RunCycle = Animator:LoadAnimation(ReplicatedStorage.Assets.Animations.RunCycle)

local function RunStart()
    if Running == true or Humanoid:GetState() == Enum.HumanoidStateType.Dead or Humanoid:GetAttribute("Stamina") <= 100 or Character:FindFirstChildOfClass("Tool") ~= nil then
        return
    end

    Running = true
    
    if RunCycle then
        RunCycle:Play(0.5)
        RunCycle:AdjustSpeed((Humanoid.WalkSpeed / 16) + 0.25)
    end

    Humanoid.WalkSpeed += SpeedBoost
    Humanoid:SetAttribute("Running", true)
end

local function RunStop()
    if not Running then
        return
    end

    Running = false
    
    if RunCycle then
        RunCycle:Stop(0.5)
    end

    Humanoid.WalkSpeed -= SpeedBoost
    Humanoid:SetAttribute("Running", false)
end

UserInputService.InputBegan:Connect(function(Input : InputObject, GPE : boolean)
    if GPE then
        return
    end

    if Input.KeyCode == PlayerControls["Run"] or Input.UserInputType == PlayerControls["Run"] or Input.KeyCode == Enum.KeyCode.ButtonL1 then
        CanRun = true

        if Moving then
            RunStart()
        end
    end
end)

UserInputService.InputEnded:Connect(function(Input : InputObject, GPE : boolean)
    if GPE then
        return
    end

    if Input.KeyCode == PlayerControls["Run"] or Input.UserInputType == PlayerControls["Run"] or Input.KeyCode == Enum.KeyCode.ButtonL1 then
        CanRun = false

        if Moving then
            RunStop()
        end
    end
end)

Humanoid.Running:Connect(function(Speed : number)
    if Speed > 2 then
        Moving = true

        if CanRun then
            RunStart()
        end
    else
        Moving = false
        
        if CanRun then
            RunStop()
        end
    end
end)

Character.ChildAdded:Connect(function(Child : Instance)
    if not Child:IsA("Tool") then
        return
    end

    RunStop()
end)

Humanoid:GetAttributeChangedSignal("Stamina"):Connect(function()
    if Humanoid:GetAttribute("Stamina") <= 5 then
        RunStop()
    end
end)