local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local screen = script.PreliminaryLoadingScreen

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

screen.Parent = playerGui

ReplicatedFirst:RemoveDefaultLoadingScreen()
