local function setSelectedInventoryItem(state, item: string?)
	local nextState = table.clone(state)
	nextState.selectedItem = item

	return nextState
end

return setSelectedInventoryItem
