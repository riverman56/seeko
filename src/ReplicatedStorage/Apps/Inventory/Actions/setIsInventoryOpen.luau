local function setIsInventoryOpen(state, isOpen: boolean)
	local nextState = table.clone(state)
	nextState.isOpen = isOpen

	return nextState
end

return setIsInventoryOpen
