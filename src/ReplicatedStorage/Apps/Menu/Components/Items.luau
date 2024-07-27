local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactReflex = require(Packages.ReactReflex)

local MenuItem = require(script.Parent.MenuItem)

local function Items()
	local producer = ReactReflex.useProducer()
	local menuItems = ReactReflex.useSelector(function(state)
		return state.menu.items
	end)

	local isOpen = ReactReflex.useSelector(function(state)
		return state.menu.isOpen
	end)

	local menuElements = {}
	for _, menuItem in menuItems do
		table.insert(
			menuElements,
			React.createElement(MenuItem, {
				name = menuItem.name,
				keybind = menuItem.keybind,
				callback = function()
					menuItem.callback(producer)
				end,
			})
		)
	end

	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0.938, -36),
		Size = UDim2.fromOffset(262, 387),
		Visible = isOpen,
	}, {
		React.createElement("UIListLayout", {
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
		}),

		React.createElement(React.Fragment, nil, menuElements),
	})
end

return Items
