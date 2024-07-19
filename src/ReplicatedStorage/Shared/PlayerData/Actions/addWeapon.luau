local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Freeze = require(ReplicatedStorage.Packages.Freeze)

local function addWeapon(state, playerName: string, weaponName: string)
	return Freeze.Dictionary.merge(state, {
		[playerName] = Freeze.Dictionary.merge(state[playerName], {
			weapons = Freeze.Dictionary.merge(state[playerName].weapons, { weaponName }),
		}),
	})
end

return addWeapon
