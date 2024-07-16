local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactReflex = require(Packages.ReactReflex)

local function Button()
	local producer = ReactReflex.useProducer()
	local isOpen = ReactReflex.useSelector(function(state)
		return state.menu.isOpen
	end)

	return React.createElement("TextButton", {
		AnchorPoint = Vector2.new(0, 1),
		AutoButtonColor = false,
		BackgroundColor3 = Color3.fromRGB(20, 21, 21),
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.fromOffset(48, 48),
		Text = "",
		[React.Event.MouseButton1Click] = function()
			producer.setIsMenuOpen(not isOpen)
		end,
	}, {
		React.createElement("UIAspectRatioConstraint", {
			AspectRatio = 1,
			AspectType = Enum.AspectType.FitWithinMaxSize,
			DominantAxis = Enum.DominantAxis.Width,
		}),

		React.createElement("UICorner"),

		React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 8),
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8),
			PaddingTop = UDim.new(0, 8),
		}),

		React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(74, 75, 75),
			LineJoinMode = Enum.LineJoinMode.Round,
			Thickness = 1,
			Transparency = 0,
		}),

		React.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0.85, 0, 0.85, 0),
			ZIndex = 2,
			Image = "rbxassetid://14126800599",
			ImageTransparency = 0.25,
		}),
	})
end

return Button
