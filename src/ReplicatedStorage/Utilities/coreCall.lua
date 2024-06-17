local StarterGui = game:GetService("StarterGui")

local MAX_RETRIES = 50

local function coreCall(name: string, value)
	local tries = 0

	local function try()
		tries += 1
		local success = pcall(function()
			return StarterGui:SetCore(name, value)
		end)

		if not success and tries < MAX_RETRIES then
			task.wait(0.1)
			return try()
		else
			return
		end
	end

	return try()
end

return coreCall
