local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactReflex = require(Packages.ReactReflex)

local function Base()
    return React.createElement("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(20, 21, 21),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0.3, 0, 0.6, 0),
        Visible = false,
    }, {
        React.createElement("UICorner"),

        React.createElement("UIListLayout", {
            Padding = UDim.new(0.021, 0),
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center,
        }),

        React.createElement("UIPadding", {
            PaddingBottom = UDim.new(0, 0),
            PaddingLeft = UDim.new(0.01, 0),
            PaddingRight = UDim.new(0.01, 0),
            PaddingTop = UDim.new(0, 0)
        }),

        React.createElement("UIStroke", {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Color3.fromRGB(74, 75, 75),
            LineJoinMode = Enum.LineJoinMode.Round,
            Thickness = 1,
            Transparency = 0,
        }),
    })
end

return Base