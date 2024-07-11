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

	local Location = UserInputService:GetMouseLocation()
	local MousePosition =  Vector2.new(Location.X, Location.Y)

	local X, Y = nil

	React.useEffect(function()
		if CircleReference.current then
			local CircleObject = CircleReference.current
			
			Location = UserInputService:GetMouseLocation()
			MousePosition = Vector2.new(Location.X, Location.Y)
			
			local ParentPosition = CircleObject.Parent.AbsolutePosition

			X = MousePosition.X - ParentPosition.X
			Y = MousePosition.Y - ParentPosition.Y

			api.start()
		else
			X = 0.5
			Y = 0.5
		end
	end, {})

	return React.createElement("ImageLabel", {
		ref = CircleReference,
		Size = styles.Size,
		BackgroundTransparency = 1,
		Image = "rbxassetid://266543268",
		Position = UDim2.new(0, X, 0, Y),
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
