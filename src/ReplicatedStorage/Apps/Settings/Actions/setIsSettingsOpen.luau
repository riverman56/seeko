local function setIsSettingsOpen(state, isOpen: boolean)
	local nextState = table.clone(state)
	nextState.isOpen = isOpen

	return nextState
end

return setIsSettingsOpen
