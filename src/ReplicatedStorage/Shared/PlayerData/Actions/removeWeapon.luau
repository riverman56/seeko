local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Freeze = require(ReplicatedStorage.Packages.Freeze)

local function removeWeapon(state, playerName: string, weaponName: string)
	local weaponIndex = table.find(state[playerName].weapons, weaponName)

	if weaponIndex then
		return Freeze.Dictionary.merge(state, {
			[playerName] = Freeze.Dictionary.merge(state[playerName], {
				weapons = Freeze.Dictionary.merge(state[playerName].weapons, { [weaponIndex] = Freeze.None }),
			}),
		})
	end

	return state
end

return removeWeapon
