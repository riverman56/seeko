local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactReflex = require(Packages.ReactReflex)

local ItemViewport = require(script.Parent.Parent.Parent.CommonComponents.ItemViewport)

local function Item(props: { name: string, displayModel: Model })
	local producer = ReactReflex.useProducer()

	local selectedItem = ReactReflex.useSelector(function(state)
		return state.inventory.selectedItem
	end)

	local isSelected = selectedItem == props.name

	return React.createElement("ImageButton", {
		BackgroundColor3 = Color3.fromRGB(31, 31, 31),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(-0.148, -0.00143),
		Size = UDim2.new(0.273, 256, 1, 0),
		[React.Event.MouseButton1Click] = function()
			producer.setSelectedInventoryItem(if isSelected then nil else props.name)
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

		React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 1),
			Size = UDim2.new(1, 16, 0.258, 24),
			ZIndex = 2,
		}, {
			React.createElement("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(19, 19, 19)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(19, 19, 19)),
				}),
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0),
				}),
			}),
		}),

		React.createElement("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 1),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			FontFace = Font.new("rbxassetid://16658237174", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
			Position = UDim2.fromScale(0.5, 1),
			Size = UDim2.fromScale(1, 0),
			Text = props.name,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 18,
			TextWrapped = true,
			ZIndex = 3,
		}),

		React.createElement(ItemViewport, {
			viewportProps = {
				Position = UDim2.fromScale(0.5, 1),
				Size = UDim2.new(1, 0, 0, 72),
			},
			model = props.displayModel,
		}),
	})
end

return Item
