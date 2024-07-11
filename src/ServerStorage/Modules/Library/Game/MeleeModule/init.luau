local MeleeModule = {}

local WhitelistedAnimations = {
    "unequip",
    "equip",
    "guard"
}

local Overrides = {
    ["Equip"] = Enum.AnimationPriority.Action3,
    ["Guard"] = Enum.AnimationPriority.Action,
}

function MeleeModule:LoadServerAnimations(Animator : Animator, AnimationFolder : Folder)
    local Animations = {}

    for _, Animation in AnimationFolder:GetChildren() do
        for _, WhitelistedAnimationName in WhitelistedAnimations do
            if Animation:IsA("Animation") and string.find(string.lower(Animation.Name), WhitelistedAnimationName) then
                local LoadedAnimation = Animator:LoadAnimation(Animation)
    
                Animations[Animation.Name] = LoadedAnimation

                for AnimationName, Override in Overrides do
                    if string.find(Animation.Name, AnimationName) then
                        LoadedAnimation.Priority = Override
                        break
                    end
                end
            end
        end
    end

    return Animations
end

function MeleeModule:LoadAnimations(Animator : Animator, AnimationFolder : Folder)
    
    local Animations = {}

    for _, Animation in AnimationFolder:GetChildren() do
        if Animation:IsA("Animation") and Animation.AnimationId ~= "" then
            local LoadedAnimation = Animator:LoadAnimation(Animation)

            Animations[Animation.Name] = LoadedAnimation
        end
    end

    return Animations
end

function MeleeModule.CheckEquip(Character : Model, Tool : Tool)
    local Value = Tool:GetAttribute("InHand")

    if Value == true then
        return true
    else
        return false
    end
end

return MeleeModule