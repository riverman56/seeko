local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local CommonFunctions = require(ReplicatedStorage.Source.Modules.Utility.CommonFunctions)

local LoadFolder = ServerStorage:WaitForChild("Load")

_G.Load = function(Script : BaseScript, Name : string)
    local Item = LoadFolder:FindFirstChild(Name)

    if Item then
        Item:Clone().Parent = Script.Parent
    end
end