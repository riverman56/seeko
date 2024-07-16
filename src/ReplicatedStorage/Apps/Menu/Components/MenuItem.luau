local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)

local function MenuItem(name: string, keybind: Enum.KeyCode, callback: () -> ())
	return React.createElement("ImageButton", {
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = Color3.fromRGB(20, 21, 21),
		Position = UDim2.new(0, 18, 0.879, -18),
		Size = UDim2.fromOffset(217, 36),
		[React.Event.MouseButton1Click] = callback,
	}, {
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
		}),

		React.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(27, 42, 53),
			Image = "rbxassetid://10791872163",
			ImageRectOffset = Vector2.new(592, 220),
			ImageRectSize = Vector2.new(108, 108),
			Position = UDim2.fromScale(1, 0.5),
			Size = UDim2.fromOffset(28, 28),
		}, {
			React.createElement("UIAspectRatioConstraint"),

			React.createElement("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(27, 42, 53),
				FontFace = Font.fromEnum(Enum.Font.BuilderSansBold),
				Position = UDim2.fromScale(0.5, 0.1),
				Size = UDim2.fromScale(0.75, 0.7),
				Text = keybind.Name,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 20,
				TextWrapped = true,
			}, {
				React.createElement("UIPadding", {
					PaddingBottom = UDim.new(0.1, 0),
					PaddingTop = UDim.new(0.1, 0),
				}),
			}),
		}),

		React.createElement("TextLabel", {
			AnchorPoint = Vector2.new(0, 0.5),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			FontFace = Font.new("rbxassetid://16658237174", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.fromScale(0, 1),
			Text = name,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 20,
		}),
	})
end

return MenuItem
