if not script:IsDescendantOf(workspace) then
    repeat task.wait()
    until script:IsDescendantOf(workspace)
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Character = script:FindFirstAncestorOfClass("Model")
local Humanoid: Humanoid = Character:WaitForChild("Humanoid")

repeat task.wait()
until Humanoid:GetAttribute("Stamina") ~= nil

local Player = Players:GetPlayerFromCharacter(Character)

local StaminaCanRegen = false
local StaminaSkipCheck = false

local MaxStaminaCanRegen = false
local MaxStaminaSkipCheck = false

local DefMaxStamina = Humanoid:GetAttribute("MaxStamina")
local DefMaxHealth = Humanoid.MaxHealth

Humanoid:SetAttribute("DefMaxHealth", DefMaxHealth)

local StaminaRegenMultiplier = 1

local LastTick = os.clock()

Humanoid.Running:Connect(function(Speed : number)
    if Speed > 20 then
        Humanoid:SetAttribute("Running", true)
    else
        Humanoid:SetAttribute("Running", false)
    end

    if Speed > 2 then
        StaminaRegenMultiplier = 1
    else
        StaminaRegenMultiplier = 1.5
    end
end)

Humanoid:GetAttributeChangedSignal("Stamina"):Connect(function()
    Humanoid:SetAttribute("Stamina", math.clamp(Humanoid:GetAttribute("Stamina"), 0, DefMaxStamina))

    if StaminaSkipCheck then
        StaminaSkipCheck = false
        return
    end

    local OldValue = Humanoid:GetAttribute("Stamina")
    StaminaCanRegen = false

    task.wait(1)

    if Humanoid:GetAttribute("Stamina") == OldValue then
        StaminaCanRegen = true
    end
end)

Humanoid:GetAttributeChangedSignal("MaxStamina"):Connect(function()
    Humanoid:SetAttribute("MaxStamina", math.clamp(Humanoid:GetAttribute("MaxStamina"), 0, math.huge))
    
    if MaxStaminaSkipCheck then
        MaxStaminaSkipCheck = false
        return
    end
end)

script:WaitForChild("JumpRemote").OnServerEvent:Connect(function(ReceivedPlayer : Player)
    if ReceivedPlayer ~= Player then
        ReceivedPlayer:Kick("?? lmao")
        return
    end

    if Humanoid:GetAttribute("Stamina") >= 35 then
        Humanoid:SetAttribute("Stamina", Humanoid:GetAttribute("Stamina") - 35)
    else
        Humanoid:SetAttribute("Stamina", 0)
    end
end)

RunService.Heartbeat:Connect(function()
    if Humanoid:GetAttribute("Stamina") > Humanoid:GetAttribute("MaxStamina") then
        Humanoid:SetAttribute("Stamina", Humanoid:GetAttribute("MaxStamina"))
    end

    if Humanoid:GetAttribute("MaxStamina") <= 0 then
        Humanoid:SetAttribute("MaxStamina", 0)
    end

    -- if Humanoid:GetAttribute("MaxStamina") <= 5 then
    --     Humanoid:SetAttribute("KnockedOut", true)
    --     Humanoid.PlatformStand = true
    -- elseif Humanoid:GetAttribute("KnockedOut") == true and Humanoid:GetAttribute("Carried") ~= true then
    --     Humanoid:SetAttribute("KnockedOut", false)
    --     Humanoid.PlatformStand = false
    -- end

    if Humanoid:GetAttribute("Running") == true then
        Humanoid:SetAttribute("Stamina", math.clamp(Humanoid:GetAttribute("Stamina") - 0.35, 0, DefMaxStamina))
    end

    if os.clock() - LastTick >= 0.05 then
        LastTick = os.clock()

        if StaminaCanRegen then
            StaminaSkipCheck = true
            Humanoid:SetAttribute("Stamina", Humanoid:GetAttribute("Stamina") + 2 * StaminaRegenMultiplier)

            if Humanoid:GetAttribute("Stamina") > Humanoid:GetAttribute("MaxStamina") then
                Humanoid:SetAttribute("Stamina", Humanoid:GetAttribute("MaxStamina"))

                if not MaxStaminaCanRegen then
                    StaminaSkipCheck = true
                    StaminaCanRegen = false
                end
            end
        end
        if MaxStaminaCanRegen then
            MaxStaminaSkipCheck = true
            Humanoid:SetAttribute("MaxStamina", Humanoid:GetAttribute("MaxStamina") + 0.5)
            
            if Humanoid:GetAttribute("MaxStamina") > Humanoid:GetAttribute("DefMaxStamina") then
                Humanoid:SetAttribute("MaxStamina", Humanoid:GetAttribute("DefMaxStamina"))

                MaxStaminaSkipCheck = true
                MaxStaminaCanRegen = false
            end
        end
    end
end)