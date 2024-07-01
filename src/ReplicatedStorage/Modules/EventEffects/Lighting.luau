local Lighting = game:GetService("Lighting")

local Effects = {}

function Effects.ChangeCurrentAtmosphere(Configuration : Configuration)
    Lighting.CurrentAtmosphere.Value = Configuration
end

return Effects