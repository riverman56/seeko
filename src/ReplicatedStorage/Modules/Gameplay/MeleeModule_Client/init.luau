local MeleeModule = {}

local ANIMATION_PRIORITY_OVERRIDES = {
    ["Attack"] = Enum.AnimationPriority.Action2,
    ["Guard"] = Enum.AnimationPriority.Action,
    ["Idle"] = Enum.AnimationPriority.Idle,
    ["Evade"] = Enum.AnimationPriority.Action4,
    ["Equip"] = Enum.AnimationPriority.Action3,
    ["GuardBreak"] = Enum.AnimationPriority.Action2,
}

function MeleeModule:LoadAnimations(Animator : Animator, AnimationFolder : Folder)
    local Animations = {}

    for _, AnimationObject in AnimationFolder:GetChildren() do
        if AnimationObject:IsA("Animation") and AnimationObject.AnimationId ~= "" then
            local LoadedAnimation = Animator:LoadAnimation(AnimationObject)

            Animations[AnimationObject.Name] = LoadedAnimation

            for AnimationName, Override in ANIMATION_PRIORITY_OVERRIDES do
                if string.find(AnimationObject.Name, AnimationName) then
                    LoadedAnimation.Priority = Override
                    break
                end
            end
        end
    end

    return Animations
end

return MeleeModule