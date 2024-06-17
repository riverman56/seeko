local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)

local function LoadingBar(progressAlpha: number)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(400, 12),
		ZIndex = 2,
	}, {
		React.createElement("UICorner"),

		React.createElement("UIStroke", {
			Color = Color3.fromRGB(255, 255, 255),
			Thickness = 2,
		}),

		React.createElement("Frame", {
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Size = UDim2.fromScale(progressAlpha, 1),
		}),
	})
end

return LoadingBar
