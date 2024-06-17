local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)

local Utilities = ReplicatedStorage.Utilities
local coreCall = require(Utilities.coreCall)

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer.PlayerGui

local LoadingScreenRoot = ReplicatedStorage.Apps.LoadingScreen

local App = require(LoadingScreenRoot.App)

local root = ReactRoblox.createRoot(Instance.new("Folder"))

root:render(ReactRoblox.createPortal(React.createElement(App), playerGui))

local preliminaryLoadingScreen = playerGui:FindFirstChild("PreliminaryLoadingScreen")
if preliminaryLoadingScreen then
	preliminaryLoadingScreen:Destroy()
end

coreCall("TopbarEnabled", false)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
coreCall("ResetButtonCallback", false)
