local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactReflex = require(Packages.ReactReflex)

local Description = require(script.Parent.Description)
local Item = require(script.Parent.Item)
local GridItem = require(script.Parent.GridItem)

local formatCurrency = require(ReplicatedStorage.Utilities.formatCurrency)

local function Base()
	local producer = ReactReflex.useProducer()
	local selectedCategory = ReactReflex.useSelector(function(state)
		return state.shop.selectedCategory
	end)

	local decksState = ReactReflex.useSelector(function(state)
		return state.shop.decks
	end)

	local isOpen = ReactReflex.useSelector(function(state)
		return state.shop.isOpen
	end)

	local playerData = ReactReflex.useSelector(function(state)
		return state.playerData[Players.LocalPlayer.Name]
	end)

	local ko = if playerData then formatCurrency(playerData.ko) else "N/A"

	local decks = {}
	for id, deck in decksState do
		table.insert(
			decks,
			Item(deck.name, deck.cost, id, ReplicatedStorage.Assets.Models.Decks:FindFirstChild(deck.name))
		)
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
					FontFace = Font.new("rbxassetid://16658237174", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal),
					Text = "Shop",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 18,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 1),
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
						Padding = UDim.new(0, 12),
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder,
					}),

					React.createElement("TextButton", {
						FontFace = Font.new(
							"rbxassetid://16658237174",
							Enum.FontWeight.SemiBold,
							Enum.FontStyle.Normal
						),
						Text = "Decks",
						TextColor3 = if selectedCategory == "Decks"
							then Color3.fromRGB(255, 255, 255)
							else Color3.fromRGB(136, 137, 139),
						TextSize = 14,
						TextXAlignment = Enum.TextXAlignment.Left,
						AutomaticSize = Enum.AutomaticSize.X,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						LayoutOrder = 1,
						Selectable = false,
						Size = UDim2.fromScale(0, 1),
						[React.Event.Activated] = function()
							producer.setSelectedItem(nil)
							producer.setSelectedCategory("Decks")
						end,
					}, {
						React.createElement("Frame", {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Position = UDim2.fromScale(0.5, 1),
							Size = UDim2.fromOffset(30, 2),
							Visible = selectedCategory == "Decks",
						}),
					}),

					React.createElement("TextButton", {
						FontFace = Font.new(
							"rbxassetid://16658237174",
							Enum.FontWeight.SemiBold,
							Enum.FontStyle.Normal
						),
						Text = "Limited",
						TextColor3 = if selectedCategory == "Limited"
							then Color3.fromRGB(255, 255, 255)
							else Color3.fromRGB(136, 137, 139),
						TextSize = 14,
						TextXAlignment = Enum.TextXAlignment.Left,
						AutomaticSize = Enum.AutomaticSize.X,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Selectable = false,
						Size = UDim2.fromScale(0, 1),
						[React.Event.Activated] = function()
							producer.setSelectedItem(nil)
							producer.setSelectedCategory("Limited")
						end,
					}, {
						React.createElement("Frame", {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Position = UDim2.fromScale(0.5, 1),
							Size = UDim2.fromOffset(30, 2),
							Visible = selectedCategory == "Limited",
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
			AutomaticCanvasSize = Enum.AutomaticSize.X,
			CanvasSize = UDim2.fromScale(1, 0),
			ScrollBarImageColor3 = Color3.fromRGB(69, 70, 70),
			ScrollBarThickness = 4,
			ScrollingDirection = Enum.ScrollingDirection.X,
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 1),
			Selectable = false,
			Size = UDim2.new(1, 0, 1, -28),
			SelectionGroup = false,
			Visible = selectedCategory == "Decks",
		}, {
			React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 12),
				PaddingLeft = UDim.new(0, 2),
				PaddingTop = UDim.new(0, 12),
			}),

			React.createElement("UIListLayout", {
				Padding = UDim.new(0, 12),
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),

			React.createElement(React.Fragment, nil, decks),
		}),

		React.createElement("ScrollingFrame", {
			AutomaticCanvasSize = Enum.AutomaticSize.X,
			CanvasSize = UDim2.fromScale(1, 0),
			ScrollBarImageColor3 = Color3.fromRGB(69, 70, 70),
			ScrollBarThickness = 4,
			ScrollingDirection = Enum.ScrollingDirection.X,
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 1),
			Selectable = false,
			Size = UDim2.new(1, 0, 1, -28),
			Visible = selectedCategory == "Limited",
			SelectionGroup = false,
		}, {
			React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 12),
				PaddingLeft = UDim.new(0, 2),
				PaddingTop = UDim.new(0, 12),
			}),

			React.createElement("UIListLayout", {
				Padding = UDim.new(0, 12),
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),

			React.createElement("Frame", {
				BackgroundColor3 = Color3.fromRGB(31, 31, 31),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				LayoutOrder = 1e+09,
				Position = UDim2.fromScale(0.371, 0),
				Size = UDim2.new(0.364, 256, 1, 0),
			}, {
				React.createElement("UICorner"),

				React.createElement("UIGridLayout", {
					CellPadding = UDim2.fromOffset(12, 12),
					CellSize = UDim2.fromOffset(109, 109),
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),
			}),
		}),

		React.createElement("TextButton", {
			Text = "",
			BackgroundColor3 = Color3.fromRGB(20, 21, 21),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.978, -0.109),
			Selectable = false,
			Size = UDim2.fromOffset(32, 32),
			[React.Event.MouseButton1Down] = function()
				producer.setIsOpen(not isOpen)
			end,
		}, {
			React.createElement("UICorner"),

			React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(74, 75, 75),
			}),

			React.createElement("ImageLabel", {
				Image = "rbxassetid://18395613912",
				ImageColor3 = Color3.fromRGB(255, 74, 96),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(20, 21, 21),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(24, 24),
			}),
		}),

		React.createElement("TextButton", {
			Text = "",
			Active = false,
			BackgroundColor3 = Color3.fromRGB(20, 21, 21),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.new(0, -16, -0.111, 0),
			Selectable = false,
			Size = UDim2.fromOffset(135, 32),
		}, {
			React.createElement("UICorner"),

			React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(74, 75, 75),
			}),

			React.createElement("TextLabel", {
				FontFace = Font.new("rbxassetid://16658237174", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal),
				Text = ko,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromOffset(28, 0),
				Size = UDim2.fromScale(0, 1),
			}),

			React.createElement("ImageLabel", {
				Image = "rbxassetid://18413988613",
				ImageColor3 = Color3.fromRGB(255, 252, 144),
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundColor3 = Color3.fromRGB(20, 21, 21),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0, 0.5),
				Size = UDim2.fromOffset(20, 20),
			}),

			React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 12),
				PaddingRight = UDim.new(0, 12),
			}),
		}),

		React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(74, 75, 75),
		}),
	})
end

return Base
