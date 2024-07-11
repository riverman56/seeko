local function setPlayerData(state, name: string, data: { ko: number })
	local nextState = table.clone(state)
	nextState[name] = data
	return nextState
end

return setPlayerData
