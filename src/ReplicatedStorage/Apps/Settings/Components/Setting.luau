local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local ReactReflex = require(ReplicatedStorage.Packages.ReactReflex)
local React = require(Packages.React)

local function Setting(props: { name: string, value: boolean })
	local producer = ReactReflex.useProducer()

	return React.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(26, 26, 26),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, -0.129, 84),
	}, {
		React.createElement("UICorner"),

		React.createElement("UIStroke", {
			Color = Color3.fromRGB(110, 110, 110),
		}),

		React.createElement("TextLabel", {
			AnchorPoint = Vector2.new(0, 0.5),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			FontFace = Font.new("rbxassetid://16658237174"),
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.fromOffset(0, 14),
			Text = props.name,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 18,
			TextWrapped = true,
		}),

		React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
		}),

		React.createElement("ImageButton", {
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundColor3 = Color3.fromRGB(11, 11, 11),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(1, 0.5),
			Size = UDim2.fromOffset(49, 18),
			[React.Event.MouseButton1Click] = function()
				producer.setSetting(props.name, not props.value)
			end,
		}, {
			React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),

			React.createElement("Frame", {
				AnchorPoint = Vector2.new(if props.value then 1 else 0, 0.5),
				BackgroundColor3 = if props.value then Color3.fromRGB(97, 255, 93) else Color3.fromRGB(255, 67, 77),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(if props.value then 1 else 0, 0.5),
				Size = UDim2.fromOffset(12, 12),
			}, {
				React.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),
			}),

			React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 4),
				PaddingRight = UDim.new(0, 4),
			}),
		}),
	})
end

return Setting
