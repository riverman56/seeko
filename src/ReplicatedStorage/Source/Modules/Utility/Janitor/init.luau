--[[

	Janitor is a light-weight, flexible object for cleaning up connections, instances, and anything else you can think of. This implementation covers all use cases,
	as it doesn't force you to rely on naive typechecking to guess how an Instance should be cleaned up.
	Instead, the developer may specify any behavior for any object.

]]--

local Symbol = require(script.Symbol)
local RbxScriptConnection = require(script.RbxScriptConnection)

local FoundPromiseLibrary, Promise = false, nil
local IndicesReference = Symbol("IndicesReference")
local LinkToInstanceIndex = Symbol("LinkToInstanceIndex")

local METHOD_NOT_FOUND_ERROR = "Object %s doesn't have method %s, are you sure you want to add it? Traceback: %s"
local NOT_A_PROMISE = "Unexpected argument #1, Promise expected, got %s (%s)"

local TypeDefaults = {
	["function"] = true,
	["RBXScriptConnection"] = "Disconnect",
}

local Janitor = {}
Janitor.CurrentlyCleaning = true
Janitor[IndicesReference] = nil
Janitor.__index = Janitor

--// Functions

local function PreprocessObject(Object : any) : (any, string)
	local ObjectType = typeof(Object)

	return TypeDefaults[ObjectType] or "Destroy", ObjectType
end

--// Methods

function Janitor.new()
	local self = setmetatable({}, Janitor)

	self.CurrentlyCleaning = false
	self.TrackedObjects = {}
	self[IndicesReference] = nil

	return self
end

function Janitor:Add(Object : any, MethodName : (string | boolean?), Index : any?) : any
	assert(self and typeof(self) == "table" and getmetatable(self) == Janitor, "Invalid class type, expected \"Janitor\"")
	assert(Object, "Unexpected argument #1, expected non-nil object, got " .. typeof(Object))

	if Index then
		self:Remove(Index)

		local This = self[IndicesReference] or {}
		This[Index] = Object

		self[IndicesReference] = This
	end

	MethodName = MethodName or PreprocessObject(Object)
	if typeof(Object) ~= "function" and not Object[MethodName] then
		warn(string.format(METHOD_NOT_FOUND_ERROR, tostring(Object), tostring(MethodName), debug.traceback(nil :: any, 2)))
	end

	self.TrackedObjects[Object] = MethodName

	return Object
end

function Janitor:Remove(Index : any)
	assert(self and typeof(self) == "table" and getmetatable(self) == Janitor, "Invalid class type, expected \"Janitor\"")

	local This = self[IndicesReference]

	if This then
		local Object = This[Index]

		if Object then
			local MethodName = self.TrackedObjects[Object]

			if MethodName then
				if MethodName == true then
					Object()
				else
					local ObjectMethod = Object[MethodName]

					if ObjectMethod then
						ObjectMethod(Object)
					end
				end

				self.TrackedObjects[Object] = nil
			end

			This[Index] = nil
		end
	end

	return self
end

function Janitor:Get(Index : any) : any?
	assert(self and typeof(self) == "table" and getmetatable(self) == Janitor, "Invalid class type, expected \"Janitor\"")

	local This = self[IndicesReference]

	if This then
		return This[Index]
	else
		return nil
	end
end

function Janitor:AddPromise(PromiseObject)
	if FoundPromiseLibrary then
		assert(Promise.is(PromiseObject), string.format(NOT_A_PROMISE, typeof(PromiseObject), tostring(PromiseObject)))

		if PromiseObject:getStatus() == Promise.Status.Started then
			local ID = newproxy(false)

			local NewPromise = self:Add(Promise.new(function(Resolve, _, OnCancel)
				if OnCancel(function()
						PromiseObject:cancel()
					end) then
					return
				end

				Resolve(PromiseObject)
			end), "cancel", ID)

			NewPromise:finallyCall(self.Remove, self, ID)

			return NewPromise
		else
			return PromiseObject
		end	
	else
		return PromiseObject
	end
end

function Janitor:LinkToInstance(Object : Instance, AllowMultiple : boolean?) : RbxScriptConnection.RbxScriptConnection
	local Connection : RBXScriptConnection
	
	local IndexToUse = AllowMultiple and newproxy(false) or LinkToInstanceIndex
	local IsNilParented = Object.Parent == nil
	local ManualDisconnect = setmetatable({}, RbxScriptConnection)

	local function ChangedFunction(_DoNotUse, NewParent)
		if ManualDisconnect.Connected then
			_DoNotUse = nil
			IsNilParented = NewParent == nil

			if IsNilParented then
				task.defer(function()
					if not ManualDisconnect.Connected then
						return
					elseif not Connection.Connected then
						self:Cleanup()
					else
						while IsNilParented and Connection.Connected and ManualDisconnect.Connected do
							task.wait()
						end

						if ManualDisconnect.Connected and IsNilParented then
							self:Cleanup()
						end
					end
				end)
			end
		end
	end

	Connection = Object.AncestryChanged:Connect(ChangedFunction)
	ManualDisconnect.Connection = Connection

	if IsNilParented then
		ChangedFunction(nil, Object.Parent)
	end

	Object = nil :: any
	
	return self:Add(ManualDisconnect, "Disconnect", IndexToUse)
end

function Janitor:LinkToInstances(... : Instance)
	local ManualCleanup = Janitor.new()
	
	for _, Object : Instance in {...} do
		ManualCleanup:Add(self:LinkToInstance(Object, true), "Disconnect")
	end
	
	return ManualCleanup
end

function Janitor:Cleanup() : ()
	assert(self and typeof(self) == "table" and getmetatable(self) == Janitor, "Invalid class type, expected \"Janitor\"")
	
	if not self.CurrentlyCleaning then
		self.CurrentlyCleaning = nil

		for Object, MethodName in self.TrackedObjects do
			if Object == IndicesReference then
				continue
			end

			if MethodName == true then
				Object()
			elseif Object[MethodName] then
				Object[MethodName](Object)
			end

			self.TrackedObjects[Object] = nil
		end

		local This = self[IndicesReference]

		if This then
			table.clear(This)
			self[IndicesReference] = {}
		end

		self.CurrentlyCleaning = false
	end
end

function Janitor:Destroy() : ()
	assert(self and typeof(self) == "table" and getmetatable(self) == Janitor, "Invalid class type, expected \"Janitor\"")

	self:Cleanup()

	table.clear(self)
	setmetatable(self, nil)
end

Janitor.__call = Janitor.Cleanup

return Janitor