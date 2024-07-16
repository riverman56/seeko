local InitialState = {
	isOpen = false,
	items = {
		{
			name = "Shop",
			keybind = Enum.KeyCode.N,
			callback = function(producer)
				local isShopOpen = producer:getState(function(state)
					return state.shop.isOpen
				end)
				producer.setIsShopOpen(not isShopOpen)
			end,
		},
		{
			name = "Inventory",
			keybind = Enum.KeyCode.G,
			callback = function(producer)
				local isInventoryOpen = producer:getState(function(state)
					return state.inventory.isOpen
				end)
				producer.setIsInventoryOpen(not isInventoryOpen)
			end,
		},
		{
			name = "Settings",
			keybind = Enum.KeyCode.B,
			callback = function(producer)
				local isSettingsOpen = producer:getState(function(state)
					return state.settings.isOpen
				end)
				producer.setIsSettingsOpen(not isSettingsOpen)
			end,
		},
	},
}

return InitialState
