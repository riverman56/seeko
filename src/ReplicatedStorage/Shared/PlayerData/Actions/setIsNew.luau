local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Freeze = require(ReplicatedStorage.Packages.Freeze)

local function setIsNew(state, playerName: string, isNew: boolean)
	return Freeze.Dictionary.merge(state, {
		[playerName] = Freeze.Dictionary.merge(state[playerName], {
			isNew = isNew,
		}),
	})
end

return setIsNew
