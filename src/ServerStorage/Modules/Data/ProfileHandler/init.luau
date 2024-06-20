local Players = game:GetService("Players")

local ProfileService = require(script.ProfileService)
local DefaultData = require(script.DefaultData)

local ProfileHandler = {}
ProfileHandler.Profiles = {}
ProfileHandler.DefaultData = table.clone(DefaultData)
ProfileHandler.ProfileStore = ProfileService.GetProfileStore("OpenGameSave01", ProfileHandler.DefaultData)

function ProfileHandler.Add(Player : Player)
    assert(Player and typeof(Player) == "Instance" and Player:IsA("Player"), "Unexpected argument #1, expected Instance<Player>, got " .. typeof(Player))

    local LoadedProfile = ProfileHandler.ProfileStore:LoadProfileAsync(tostring(Player.UserId))

    if not LoadedProfile then
        Player:Kick("Profile could not be loaded. PLease rejoin.")
        return
    end

    LoadedProfile:AddUserId(Player.UserId)
    LoadedProfile:Reconcile()

    LoadedProfile:ListenToRelease(function()
        ProfileHandler.Profiles[Player] = nil
        Player:Kick("Profile loaded remotely.")
    end)

    if not Player:IsDescendantOf(Players) then
        LoadedProfile:Release()
        return
    end

    ProfileHandler.Profiles[Player] = LoadedProfile

    return LoadedProfile
end

function ProfileHandler.Remove(Player : Player)
    assert(Player and typeof(Player) == "Instance" and Player:IsA("Player"), "Unexpected argument #1, expected Instance<Player>, got " .. typeof(Player))

    local LoadedProfile = ProfileHandler.Profiles[Player]
    
    if not LoadedProfile then
        return
    end

    LoadedProfile:Release()
end

return ProfileHandler