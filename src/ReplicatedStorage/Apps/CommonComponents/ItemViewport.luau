local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Freeze = require(ReplicatedStorage.Packages.Freeze)
local React = require(Packages.React)

local ViewportCamera = ReplicatedStorage:WaitForChild("ViewportCamera")

local function ItemViewport(props: {}, model: Model)
	local viewportRef = React.useRef(nil)

	React.useEffect(function()
		if not viewportRef.current:FindFirstChildOfClass("Model") then
			model:Clone().Parent = viewportRef.current
		end
	end)

	return React.createElement(
		"ViewportFrame",
		Freeze.Dictionary.merge({
			ref = viewportRef,
			CurrentCamera = ViewportCamera,
			Ambient = Color3.fromRGB(252, 249, 231),
			LightColor = Color3.fromRGB(255, 173, 200),
			LightDirection = Vector3.new(1, 0.31, -0.3),
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
		}, props)
	)
end

return ItemViewport
