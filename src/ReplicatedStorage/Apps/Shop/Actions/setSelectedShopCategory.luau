local function setSelectedShopCategory(state, category: string)
	local nextState = table.clone(state)
	nextState.selectedCategory = category

	return nextState
end

return setSelectedShopCategory
