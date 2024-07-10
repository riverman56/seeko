local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactReflex = require(Packages.ReactReflex)

local function Description()
	local producer = ReactReflex.useProducer()

	local selectedItem = ReactReflex.useSelector(function(state)
		return state.shop.selectedItem
	end)

	local decksState = ReactReflex.useSelector(function(state)
		return state.shop.decks
	end)

	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(20, 21, 21),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Visible = selectedItem ~= nil,
		Position = UDim2.fromScale(1.24, 0.499),
		Size = UDim2.fromOffset(291, 416),
	}, {
		React.createElement("UICorner"),

		React.createElement("Frame", {
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 28),
		}, {
			React.createElement("TextLabel", {
				FontFace = Font.new("rbxassetid://16658237174", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal),
				Text = if selectedItem then decksState[selectedItem].name else "Item",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 26,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
			}),
		}),

		React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 8),
			PaddingLeft = UDim.new(0, 24),
			PaddingRight = UDim.new(0, 24),
			PaddingTop = UDim.new(0, 20),
		}),

		React.createElement("TextLabel", {
			FontFace = Font.new("rbxassetid://16658237174"),
			Text = "Description",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 18,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.845),
			Size = UDim2.fromScale(1, 0.266),
		}),

		React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(74, 75, 75),
		}),

		React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 1),
			Size = UDim2.new(1, 0, 0, 48),
		}, {
			React.createElement("TextButton", {
				Text = "",
				Active = false,
				BackgroundColor3 = Color3.fromRGB(33, 93, 14),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Selectable = false,
				AutoButtonColor = false,
				Size = UDim2.fromOffset(144, 36),
			}, {
				React.createElement("UICorner"),

				React.createElement("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(74, 75, 75),
				}),

				React.createElement("TextLabel", {
					FontFace = Font.new("rbxassetid://16658237174", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal),
					Text = "Purchase",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 24,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 1),
				}),
			}),

			React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
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
			Position = UDim2.fromScale(0.5, 0.476),
			Size = UDim2.new(1, 0, 0.192, 72),
		}),

		React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundColor3 = Color3.fromRGB(20, 21, 21),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.495),
			Size = UDim2.fromOffset(0, 24),
		}, {
			React.createElement("UICorner"),

			React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(74, 75, 75),
			}),

			React.createElement("ImageLabel", {
				Image = "http://www.roblox.com/asset/?id=18413988613",
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
				Text = if selectedItem then tostring(decksState[selectedItem].cost) else 0,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 20,
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

return Description
