local InitialState = {
	isOpen = false,
	selectedCategory = "Limited",
	selectedItem = nil,
	decks = {
		{
			name = "Geisha's Gambit",
			cost = 1000,
		},
		{
			name = "Fuji",
			cost = 1000,
		},
		{
			name = "Kamikaze Kards",
			cost = 1000,
		},
		{
			name = "Dragon's Hoard",
			cost = 1000,
		},
		{
			name = "Emperor's Emblems",
			cost = 1000,
		},
		{
			name = "Kyudo Collection",
			cost = 1000,
		},
	},
	limitedDecks = {},
	limitedItems = {},
}

return InitialState
