local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage.Remotes
local Modules = ReplicatedStorage.Modules

local LoadedEffects = {}

for _, Module in Modules.EventEffects:GetDescendants() do
    if not Module:IsA("ModuleScript") then
        continue
    end

    local LoadedModule = require(Module)

    LoadedEffects[Module.Name] = LoadedModule
end

Remotes.Effects.OnClientEvent:Connect(function(Directory : string, Name : string, ...)
    
    local Module : {any} = LoadedEffects[Directory]
    local Function : (any) -> any = Module[Name]

    if Module and Function then
        Function(...)
    end
end)