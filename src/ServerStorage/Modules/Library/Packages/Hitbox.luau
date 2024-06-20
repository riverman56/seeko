local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Remotes = ReplicatedStorage.Remotes

local FastSignal = require(ReplicatedStorage.Modules.Utility.FastSignal)
local Janitor = require(ReplicatedStorage.Modules.Utility.Janitor)

local Hitbox = {}
Hitbox.__index = Hitbox
Hitbox.Size = Vector3.new(5, 5, 5)
Hitbox.Offset = CFrame.new(0, 0, -3)
Hitbox.Lifetime = 0.2
Hitbox.DirectionGuess = false
Hitbox.MultiHit = true
Hitbox.IgnoreRagdoll = false

local Overlap = OverlapParams.new()
Overlap.FilterType = Enum.RaycastFilterType.Exclude
Overlap.FilterDescendantsInstances = {}

function Hitbox.new(Character: Model, Object: BasePart | Attachment)
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	local RootPart = Humanoid.RootPart

	local self = setmetatable({}, Hitbox)

	self.Janitor = Janitor.new()
	self.Janitor:LinkToInstance(Object ~= nil and Object or Character)

	self.OnHit = FastSignal.new()

	self.HitHumanoids = {}

	self.StartTime = os.clock()

	local Exists = Object ~= nil and Object:IsDescendantOf(game) or Character:IsDescendantOf(game)

	self.Connection = self.Janitor:Add(
		RunService.Heartbeat:Connect(function()
			if os.clock() - self.StartTime >= self.Lifetime or not Exists then
				self.Janitor:Destroy()

				table.clear(self)
				setmetatable(self, nil)

				return
			end

			local HitboxCFrame: CFrame

			if Object == nil then
				local StartCFrame = RootPart.CFrame

				if self.DirectionGuess == true then
					local RCF = RootPart.CFrame
					local MD = Humanoid.MoveDirection

					local Waa = Vector3.new(math.abs(MD:Dot(RCF.LookVector)), 0, math.abs(MD:Dot(RCF.RightVector)) / 2)

					HitboxCFrame = CFrame.new(MD * Waa:Dot(self.Size) / 2) * StartCFrame
				else
					HitboxCFrame = StartCFrame
				end
			else
				HitboxCFrame = Object:IsA("Attachment") and Object.WorldCFrame or Object.CFrame
			end

			local FinalHitboxCFrame = HitboxCFrame * self.Offset
			local Bounds = workspace:GetPartBoundsInBox(FinalHitboxCFrame, self.Size, Overlap)

			local Player = Players:GetPlayerFromCharacter(Character)

			if Player then
				Remotes.Effects:FireClient(Player, "Game", "Hitbox", FinalHitboxCFrame, self.Size)
			end

			for _, Part in Bounds do
				if not Part:IsA("BasePart") then
					continue
				end

				local HitCharacter = Part:FindFirstAncestorOfClass("Model")

				if not HitCharacter then
					continue
				end

				local HitHumanoid = HitCharacter:FindFirstChildOfClass("Humanoid")

				if not HitHumanoid then
					continue
				end

				if
					HitHumanoid
					and HitHumanoid:GetState() ~= Enum.HumanoidStateType.Dead
					and not table.find(self.HitHumanoids, HitHumanoid)
				then
					if HitHumanoid.PlatformStand == true then
						if self.IgnoreRagdoll == true then
							self.OnHit:Fire(HitCharacter, HitHumanoid, HitHumanoid.RootPart, Part)
							table.insert(self.HitHumanoids, HitHumanoid)

							HitHumanoid.PlatformStand = false

							if not self.MultiHit then
								self.Janitor:Destroy()
								break
							end
						end
					else
						self.OnHit:Fire(HitCharacter, HitHumanoid, HitHumanoid.RootPart, Part)
						table.insert(self.HitHumanoids, HitHumanoid)

						if not self.MultiHit then
							self.Janitor:Destroy()
							break
						end
					end
				end
			end
		end),
		"Disconnect"
	)

	return self
end

return Hitbox
