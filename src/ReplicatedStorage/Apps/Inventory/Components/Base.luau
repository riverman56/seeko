local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactReflex = require(Packages.ReactReflex)

local Description = require(script.Parent.Description)
local Item = require(script.Parent.Item)

local function Base()
	local producer = ReactReflex.useProducer()

	local isOpen = ReactReflex.useSelector(function(state)
		return state.inventory.isOpen
	end)

	local playerData = ReactReflex.useSelector(function(state)
		return state.playerData[Players.LocalPlayer.Name]
	end)

	local weaponElements = {}
	if playerData then
		for _, weaponName in playerData.weapons do
			local viewportModel = ReplicatedStorage.Assets.ViewportModels:FindFirstChild(weaponName, true)
			table.insert(
				weaponElements,
				React.createElement(Item, {
					name = weaponName,
					displayModel = viewportModel,
				})
			)
		end
	end

	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(20, 21, 21),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.499, 0.499),
		Size = UDim2.fromOffset(756, 416),
		Visible = isOpen,
	}, {
		React.createElement(Description),

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
					Text = "Inventory",
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
			}, {
				React.createElement("Frame", {
					AnchorPoint = Vector2.new(1, 0),
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(1, 0),
					Size = UDim2.fromScale(0, 1),
				}, {
					React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						Padding = UDim.new(0, 12),
						SortOrder = Enum.SortOrder.LayoutOrder,
					}),

					React.createElement("TextButton", {
						Active = false,
						AutomaticSize = Enum.AutomaticSize.X,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						FontFace = Font.new(
							"rbxassetid://16658237174",
							Enum.FontWeight.SemiBold,
							Enum.FontStyle.Normal
						),
						LayoutOrder = 1,
						Selectable = false,
						Size = UDim2.fromScale(0, 1),
						Text = "Katanas",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 14,
						TextXAlignment = Enum.TextXAlignment.Left,
					}, {
						React.createElement("Frame", {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Position = UDim2.fromScale(0.5, 1),
							Size = UDim2.fromOffset(30, 2),
						}),
					}),

					React.createElement("TextButton", {
						Active = false,
						AutomaticSize = Enum.AutomaticSize.X,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						FontFace = Font.new(
							"rbxassetid://16658237174",
							Enum.FontWeight.SemiBold,
							Enum.FontStyle.Normal
						),
						Selectable = false,
						Size = UDim2.fromScale(0, 1),
						Text = "Hand Combat",
						TextColor3 = Color3.fromRGB(136, 137, 139),
						TextSize = 14,
						TextXAlignment = Enum.TextXAlignment.Left,
					}, {
						React.createElement("Frame", {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Position = UDim2.fromScale(0.5, 1),
							Size = UDim2.fromOffset(30, 2),
							Visible = false,
						}),
					}),
				}),

				React.createElement("UIPadding", {
					PaddingRight = UDim.new(0, 32),
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

		React.createElement("ScrollingFrame", {
			AnchorPoint = Vector2.new(0.5, 1),
			AutomaticCanvasSize = Enum.AutomaticSize.X,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			CanvasSize = UDim2.fromScale(1, 0),
			Position = UDim2.fromScale(0.5, 1),
			ScrollBarImageColor3 = Color3.fromRGB(69, 70, 70),
			ScrollBarThickness = 4,
			ScrollingDirection = Enum.ScrollingDirection.X,
			Selectable = false,
			Size = UDim2.new(1, 0, 1, -28),
		}, {
			React.createElement(React.Fragment, nil, weaponElements),

			React.createElement("UIGridLayout", {
				CellPadding = UDim2.fromOffset(12, 12),
				CellSize = UDim2.fromOffset(106, 106),
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),

			React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 12),
				PaddingLeft = UDim.new(0, 2),
				PaddingTop = UDim.new(0, 12),
			}),
		}),

		React.createElement("TextButton", {
			BackgroundColor3 = Color3.fromRGB(20, 21, 21),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.978, -0.109),
			Size = UDim2.fromOffset(32, 32),
			Text = "",
			[React.Event.MouseButton1Click] = function()
				producer.setIsInventoryOpen(not isOpen)
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

		React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(74, 75, 75),
		}),
	})
end

return Base
