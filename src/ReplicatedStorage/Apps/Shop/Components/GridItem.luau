local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactReflex = require(Packages.ReactReflex)

local formatCurrency = require(ReplicatedStorage.Utilities.formatCurrency)

local function GridItem(name: string, cost: number, id: number, displayModel: Model?)
	local producer = ReactReflex.useProducer()
	local selectedItem = ReactReflex.useSelector(function(state)
		return state.shop.selectedItem
	end)

	local isSelected = selectedItem == id

	local koCost = formatCurrency(cost) or "N/A"

	return React.createElement("ImageButton", {
		BackgroundColor3 = if isSelected then Color3.fromRGB(18, 18, 18) else Color3.fromRGB(31, 31, 31),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		AutoButtonColor = false,
		[React.Event.MouseButton1Click] = function()
			producer.setSelectedShopItem(if isSelected then nil else id)
		end,
	}, {
		React.createElement("UICorner"),

		React.createElement("UIStroke", {
			Color = if isSelected then Color3.fromRGB(159, 159, 159) else Color3.fromRGB(74, 75, 75),
		}),

		React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 8),
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8),
			PaddingTop = UDim.new(0, 8),
		}),

		React.createElement("ViewportFrame", {
			Ambient = Color3.fromRGB(252, 249, 231),
			LightColor = Color3.fromRGB(255, 173, 200),
			LightDirection = Vector3.new(1, 0.31, -0.3),
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 1),
			Size = UDim2.new(1, 0, 0, 72),
		}),

		React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Visible = isSelected,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 1),
			Size = UDim2.new(1, 16, 0.258, 24),
		}, {
			React.createElement("UIGradient", {
				Color = ColorSequence.new(Color3.fromRGB(19, 19, 19)),
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0),
				}),
			}),
		}),

		React.createElement("TextLabel", {
			FontFace = Font.new("rbxassetid://16658237174", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
			Text = name,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 18,
			TextWrapped = true,
			AnchorPoint = Vector2.new(0.5, 1),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 1),
			Size = UDim2.fromScale(1, 0),
			Visible = isSelected,
		}),

		React.createElement("Frame", {
			AnchorPoint = Vector2.new(1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundColor3 = Color3.fromRGB(20, 21, 21),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromOffset(0, 19),
		}, {
			React.createElement("UICorner"),

			React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(74, 75, 75),
			}),

			React.createElement("ImageLabel", {
				Image = "rbxassetid://6857443163",
				ImageColor3 = Color3.fromRGB(255, 252, 144),
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundColor3 = Color3.fromRGB(20, 21, 21),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0, 0.5),
				Size = UDim2.fromOffset(12, 12),
			}),

			React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 8),
			}),

			React.createElement("TextLabel", {
				FontFace = Font.new("rbxassetid://16658237174", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal),
				Text = koCost,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Position = UDim2.fromOffset(16, 0),
				Size = UDim2.fromScale(0, 1),
			}, {
				React.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(60, math.huge),
				}),
			}),
		}),
	})
end

return GridItem
