local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local ReactReflex = require(ReplicatedStorage.Packages.ReactReflex)
local React = require(Packages.React)

local Setting = require(script.Parent.Setting)

local function Base()
	local producer = ReactReflex.useProducer()
	local settings = ReactReflex.useSelector(function(state)
		return state.settings
	end)

	local isOpen = settings.isOpen
	local settingsElements = {}
	for _, setting in settings.settings do
		table.insert(settingsElements, Setting(setting.name, setting.value))
	end

	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(20, 21, 21),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.499, 0.499),
		Size = UDim2.fromOffset(289, 439),
		Visible = isOpen,
	}, {
		React.createElement("UICorner"),

		React.createElement("TextButton", {
			AnchorPoint = Vector2.new(1, 0),
			BackgroundColor3 = Color3.fromRGB(20, 21, 21),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.new(1, 16, 0, -46),
			Selectable = false,
			Size = UDim2.fromOffset(32, 32),
			Text = "",
			[React.Event.MouseButton1Click] = function()
				producer.setIsSettingsOpen(false)
			end,
		}, {
			React.createElement("UICorner"),

			React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(74, 75, 75),
			}),

			React.createElement("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(20, 21, 21),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Image = "rbxassetid://18395613912",
				ImageColor3 = Color3.fromRGB(255, 74, 96),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(24, 24),
			}),
		}),

		React.createElement("Frame", {
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 28),
		}, {
			React.createElement("Frame", {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Size = UDim2.fromScale(0.5, 1),
			}, {
				React.createElement("TextLabel", {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					FontFace = Font.new("rbxassetid://16658237174", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal),
					Size = UDim2.fromScale(1, 1),
					Text = "Settings",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 18,
					TextXAlignment = Enum.TextXAlignment.Left,
				}),
			}),

			React.createElement("Frame", {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				LayoutOrder = 1,
				Size = UDim2.fromScale(0.5, 1),
			}),

			React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
		}),

		React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 8),
			PaddingLeft = UDim.new(0, 16),
			PaddingRight = UDim.new(0, 16),
			PaddingTop = UDim.new(0, 6),
		}),

		React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(74, 75, 75),
		}),

		React.createElement("ScrollingFrame", {
			AnchorPoint = Vector2.new(0.5, 1),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			CanvasSize = UDim2.new(),
			Position = UDim2.fromScale(0.5, 1),
			ScrollBarImageColor3 = Color3.fromRGB(131, 130, 132),
			ScrollBarThickness = 2,
			Selectable = false,
			SelectionGroup = false,
			Size = UDim2.new(1, 0, 1, -28),
		}, {
			React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 2),
				PaddingRight = UDim.new(0, 8),
				PaddingTop = UDim.new(0, 8),
			}),

			React.createElement("UIListLayout", {
				Padding = UDim.new(0, 8),
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),

			React.createElement(React.Fragment, nil, settingsElements),
		}),
	})
end

return Base
