local CMTF = require(script.Parent.CommonToolFunctions)

local MeleeModule = {}

function MeleeModule:LoadAnimations(Animator : Animator, AnimationFolder : Folder)
    
    local Animations = {}

    for _, Animation in AnimationFolder:GetChildren() do
        if Animation:IsA("Animation") and Animation.AnimationId ~= "" then
            local LoadedAnimation = Animator:LoadAnimation(Animation)

            Animation[Animation.Name] = LoadedAnimation
        end
    end

    return Animations
end

return MeleeModule