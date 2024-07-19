local function setSetting(state, name: string, value: boolean)
	local nextState = table.clone(state)
	for index, setting in nextState.settings do
		if setting.name == name then
			nextState.settings[index].value = value
		end
	end

	return nextState
end

return setSetting
