local function setIsClassSelectorOpen(state, isOpen: boolean)
	local nextState = table.clone(state)
	nextState.isOpen = isOpen

	return nextState
end

return setIsClassSelectorOpen
