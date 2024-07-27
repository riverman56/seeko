local function setSelectedInventoryCategory(state, item: string?)
	local nextState = table.clone(state)
	nextState.selectedCategory = item

	return nextState
end

return setSelectedInventoryCategory
