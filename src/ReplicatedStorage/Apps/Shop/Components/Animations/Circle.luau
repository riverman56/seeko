local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactSpring = require(Packages.ReactSpring)

local function Circle()
	local styles = ReactSpring.useSpring({
		ImageTransparency = 1,
	})

	local CircleRef = React.useRef(nil)

	local CurrentCircle = CircleRef.current

	local MousePosition = UserInputService:GetMouseLocation()
	local X = MousePosition.X
	local Y = MousePosition.Y

	return React.createElement("ImageLabel", {
		ref = CircleRef,
		Size = UDim2.fromScale(0, 0),
		BackgroundTransparency = 1,
		Image = "rbxassetid://266543268",
		ImageTransparency = styles.ImageTransparency,
		AnchorPoint = Vector2.new(0.5, 0.5),
		ZIndex = 10,
	}, {
		React.createElement("UIAspectRatioConstraint", {
			AspectRatio = 1,
			AspectType = Enum.AspectType.FitWithinMaxSize,
			DominantAxis = Enum.DominantAxis.Width,
		}),
	})
end

return Circle
