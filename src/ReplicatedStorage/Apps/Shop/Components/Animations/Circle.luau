local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactSpring = require(Packages.ReactSpring)

local function Circle()
	local CircleReference = React.useRef(nil)

	local styles, api = ReactSpring.useSpring(function()
		return {
			from = { Size = UDim2.fromScale(0, 0), ImageTransparency = 0.5 },
			to = { Size = UDim2.fromScale(3, 3), ImageTransparency = 1 },
			config = { duration = 0.4 }
		}
	end)

	local MousePosition = UserInputService:GetMouseLocation()
	local CirclePosition

	React.useEffect(function()
		local CircleObject = CircleReference.current

		if CircleObject then
			api.start()

			local CircleSize = Vector2.new(CircleObject.AbsoluteSize.X, CircleObject.AbsoluteSize.Y)
			CirclePosition = UDim2.fromOffset(MousePosition.X - (CircleSize.X / 2), MousePosition.Y - (CircleSize.Y / 2))
		end
	end, {MousePosition}) 

	return React.createElement("ImageLabel", {
		ref = CircleReference,
		Size = styles.Size,
		BackgroundTransparency = 1,
		Image = "rbxassetid://266543268",
		ImageTransparency = styles.ImageTransparency,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = CirclePosition,
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