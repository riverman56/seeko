local ReplicatedStorage = game:GetService("ReplicatedStorage")

local displayModel =
	ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Models"):WaitForChild("Decks"):WaitForChild("Fuji")
local pivot = displayModel:GetPivot()

local camera = Instance.new("Camera")
camera.Name = "ViewportCamera"
camera.CFrame = CFrame.new(pivot.Position - Vector3.new(4.5, 0, 0), pivot.Position)
camera.Parent = ReplicatedStorage
