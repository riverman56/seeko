local RbxScriptConnection = {}
RbxScriptConnection.Connected = true
RbxScriptConnection.__index = RbxScriptConnection

function RbxScriptConnection.new(RBXScriptConnection : RBXScriptConnection)
	local self = setmetatable({}, RbxScriptConnection)
	
	self.Connection = RBXScriptConnection
	
	return self
end

function RbxScriptConnection:Disconnect()
	if self.Connected then
		self.Connected = false
		self.Connection:Disconnect()
		self.Connection = nil
	end
end

function RbxScriptConnection:__tostring()
	return "RbxScriptConnection<" .. tostring(self.Connected) .. ">"
end

export type RbxScriptConnection = typeof(game:GetPropertyChangedSignal("ClassName"):Connect(function() end))

return RbxScriptConnection