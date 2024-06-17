local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)

local function Background()
	return React.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(110, 28, 28),
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
	})
end

return Background
