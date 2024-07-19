local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactReflex = require(Packages.ReactReflex)

local ItemViewport = require(script.Parent.Parent.Parent.CommonComponents.ItemViewport)

local CircleElement = require(script.Parent.Animations.Circle)

local formatCurrency = require(ReplicatedStorage.Utilities.formatCurrency)

local function Item(name: string, cost: number, id: number, displayModel: Model)
	local producer = ReactReflex.useProducer()
	local selectedItem = ReactReflex.useSelector(function(state)
		return state.shop.selectedItem
	end)

	local ShowCircle, SetShowCicle = React.useState(false)

	local isSelected = selectedItem == id

	local koCost = formatCurrency(cost) or "N/A"

	return React.createElement("ImageButton", {
		BackgroundColor3 = if isSelected then Color3.fromRGB(18, 18, 18) else Color3.fromRGB(31, 31, 31),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		AutoButtonColor = false,
		ClipsDescendants = true,
		Size = UDim2.new(0, 256, 1, 0),
		[React.Event.MouseButton1Click] = function()
			producer.setSelectedShopItem(if isSelected then nil else id)
			SetShowCicle(true)

			task.delay(1.1, function()
				SetShowCicle(false)
			end)
		end,
	}, {
		React.createElement("UICorner"),

		React.createElement("UIStroke", {
			Color = if isSelected then Color3.fromRGB(159, 159, 159) else Color3.fromRGB(74, 75, 75),
		}),

		if ShowCircle then React.createElement(CircleElement) else nil,

		React.createElement("TextLabel", {
			FontFace = Font.new("rbxassetid://16658237174", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
			Text = name,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 30,
			TextWrapped = true,
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 1),
			Size = UDim2.new(1, 0, 0, 60),
			ZIndex = 2,
			TextYAlignment = Enum.TextYAlignment.Bottom,
		}),

		React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 8),
			PaddingLeft = UDim.new(0, 16),
			PaddingRight = UDim.new(0, 16),
			PaddingTop = UDim.new(0, 8),
		}),

		ItemViewport({
			Position = UDim2.fromScale(0.5, 0.922),
			Size = UDim2.new(1, 0, 0.714, 72),
		}, displayModel),

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

		React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 1),
			Size = UDim2.new(1, 16, 0.68, 24),
			Visible = isSelected,
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
	})
end

return Item
