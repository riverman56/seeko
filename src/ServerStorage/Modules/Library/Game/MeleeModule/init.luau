local CMTF = require(script.Parent.CommonToolFunctions)

local MeleeModule = {}

local WhitelistedAnimations = {
    "unequip",
    "equip",
    "guard"
}

function MeleeModule:LoadServerAnimations(Animator : Animator, AnimationFolder : Folder)
    local Animations = {}

    for _, Animation in AnimationFolder:GetChildren() do
        for _, WhitelistedAnimationName in WhitelistedAnimations do
            if Animation:IsA("Animation") and string.find(string.lower(Animation.Name), WhitelistedAnimationName) then
                local LoadedAnimation = Animator:LoadAnimation(Animation)
    
                Animations[Animation.Name] = LoadedAnimation
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