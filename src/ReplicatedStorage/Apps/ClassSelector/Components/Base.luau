local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactReflex = require(Packages.ReactReflex)

local remotes = require(ReplicatedStorage.Shared.remotes)

local function Base()
	local producer = ReactReflex.useProducer()

	local isOpen = ReactReflex.useSelector(function(state)
		return state.classSelector.isOpen
	end)

	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(20, 21, 21),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.484, 0.447),
		Size = UDim2.fromOffset(553, 182),
		Visible = isOpen,
	}, {
		React.createElement("UICorner"),

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
					Text = "Choose Your Class",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 18,
					TextXAlignment = Enum.TextXAlignment.Left,
				}),
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

		React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Position = UDim2.fromScale(0.5, 1),
			SelectionGroup = true,
			Size = UDim2.new(1, 0, 1, -28),
		}, {
			React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 12),
				PaddingTop = UDim.new(0, 12),
			}),

			React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 24),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),

			React.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = Color3.fromRGB(20, 20, 20),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(0, 36),
				Text = "",
				[React.Event.MouseButton1Click] = function()
					producer.setIsClassSelectorOpen(false)
					remotes.selectClass:fire("Katanas")
				end,
			}, {
				React.createElement("UICorner"),

				React.createElement("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(74, 75, 75),
				}),

				React.createElement("TextLabel", {
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					FontFace = Font.new("rbxassetid://16658237174", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal),
					Size = UDim2.fromScale(0, 1),
					Text = "Katanas",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 24,
				}),

				React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 12),
					PaddingRight = UDim.new(0, 12),
				}),
			}),

			React.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = Color3.fromRGB(20, 20, 20),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(0, 36),
				Text = "",
				[React.Event.MouseButton1Click] = function()
					producer.setIsClassSelectorOpen(false)
					remotes.selectClass:fire("HandCombat")
				end,
			}, {
				React.createElement("UICorner"),

				React.createElement("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(74, 75, 75),
				}),

				React.createElement("TextLabel", {
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					FontFace = Font.new("rbxassetid://16658237174", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal),
					Size = UDim2.fromScale(0, 1),
					Text = "Hand Combat",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 24,
				}),

				React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 12),
					PaddingRight = UDim.new(0, 12),
				}),
			}),
		}),
	})
end

return Base
