task.wait(1)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AmbientSound_Manager = require(ReplicatedStorage:WaitForChild("AmbientSound_Manager"))
AmbientSound_Manager.Run()