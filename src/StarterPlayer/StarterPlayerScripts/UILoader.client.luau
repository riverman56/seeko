local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Apps = ReplicatedStorage.Apps

for _, App in Apps:GetChildren() do
    if not App:IsA("ModuleScript") or not App:HasTag("UIComponent") then
        continue
    end

    if App:GetAttribute("Enabled") == false then
        continue
    end

    local LoadedApp = require(App)

    task.defer(LoadedApp)
end