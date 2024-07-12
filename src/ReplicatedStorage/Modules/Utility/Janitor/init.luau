--!optimize 2

local Promise = if script.Parent:FindFirstChild("Promise") then require(script.Parent.Promise) else nil

local IndicesReference = setmetatable({}, {
	["__tostring"] = function()
		return "IndicesReference"
	end,
})

local LinkToInstanceIndex = setmetatable({}, {
	["__tostring"] = function()
		return "LinkToInstanceIndex"
	end,
})

local INVALID_METHOD_NAME =
	"Object is a %* and as such expected `true?` for the method name and instead got %*. Traceback: %*"
local METHOD_NOT_FOUND_ERROR = "Object %* doesn't have method %*, are you sure you want to add it? Traceback: %*"
local NOT_A_PROMISE = "Invalid argument #1 to 'Janitor:AddPromise' (Promise expected, got %* (%*)) Traceback: %*"

--[=[
	Janitor is a light-weight, flexible object for cleaning up connections, instances, or anything. This implementation covers all use cases,
	as it doesn't force you to rely on naive typechecking to guess how an instance should be cleaned up.
	Instead, the developer may specify any behavior for any object.

	@class Janitor
]=]

local Janitor = {}
Janitor.ClassName = "Janitor"
Janitor.CurrentlyCleaning = true
Janitor.SuppressInstanceReDestroy = false
Janitor[IndicesReference] = nil
Janitor.__index = Janitor

--[=[
	@prop CurrentlyCleaning boolean
	@readonly
	@within Janitor

	Whether or not the Janitor is currently cleaning up.
]=]

--[=[
	@prop SuppressInstanceReDestroy boolean
	@within Janitor
	@since 1.15.4

	Whether or not you want to suppress the re-destroying
	of instances. Default is false, which is the original
	behavior.
]=]

local TypeDefaults = {
	["function"] = true,
	["thread"] = true,
	["RBXScriptConnection"] = "Disconnect",
}

--[=[
	Instantiates a new Janitor object.
	@return Janitor
]=]

function Janitor.new()
	local self : Janitor = setmetatable({}, Janitor)

	self.CurrentlyCleaning = false
	self.TrackedObjects = {}
	self[IndicesReference] = nil

	return self
end

--[=[
	Determines if the passed object is a Janitor. This checks the metatable directly.

	@param Object any -- The object you are checking.
	@return boolean -- `true` if `Object` is a Janitor.
]=]

function Janitor.Is(Object: any): boolean
	return typeof(Object) == "table" and getmetatable(Object) == Janitor
end

--[=[
	Adds an `Object` to Janitor for later cleanup, where `MethodName` is the key of the method within `Object` which should be called at cleanup time.
	If the `MethodName` is `true` the `Object` itself will be called if it's a function or have `task.cancel` called on it if it is a thread. If passed
	an index it will occupy a namespace which can be `Remove()`d or overwritten. Returns the `Object`.

	:::info
	Objects not given an explicit `MethodName` will be passed into the `typeof` function for a very naive typecheck.
	RBXConnections will be assigned to "Disconnect", functions and threads will be assigned to `true`, and everything else will default to "Destroy".
	Not recommended, but hey, you do you.
	:::

	@param Object T -- The object you want to clean up.
	@param MethodName? boolean | string -- The name of the method that will be used to clean up. If not passed, it will first check if the object's type exists in TypeDefaults, and if that doesn't exist, it assumes `Destroy`.
	@param Index? any -- The index that can be used to clean up the object manually.
	@return T -- The object that was passed as the first argument.
]=]

function Janitor:Add<T>(Object: T, MethodName: boolean | string, Index: any): T
	if Index then
		self:Remove(Index)

		local This = self[IndicesReference]
		if not This then
			This = {}
			self[IndicesReference] = This
		end

		This[Index] = Object
	end

	local TypeOf = typeof(Object)
	local NewMethodName = MethodName or TypeDefaults[TypeOf] or "Destroy"

	if TypeOf == "function" or TypeOf == "thread" then
		if NewMethodName ~= true then
			warn(string.format(INVALID_METHOD_NAME, TypeOf, `{NewMethodName}`, debug.traceback(nil, 2)))
		end
	else
		if not (Object :: any)[NewMethodName] then
			warn(string.format(METHOD_NOT_FOUND_ERROR, `{Object}`, `{NewMethodName}`, debug.traceback(nil, 2)))
		end
	end

	self.TrackedObjects[Object] = NewMethodName

	return Object
end

--[=[
	Constructs an object for you and adds it to the Janitor. It's really just shorthand for `Janitor:Add(Object.new(), MethodName, Index)`.

    @since v1.16.0
	@param Constructor {new: (A...) -> T} -- The constructor for the object you want to add to the Janitor.
	@param MethodName? boolean | string -- The name of the method that will be used to clean up. If not passed, it will first check if the object's type exists in TypeDefaults, and if that doesn't exist, it assumes `Destroy`.
	@param Index? any -- The index that can be used to clean up the object manually.
	@param ... A... -- The arguments that will be passed to the constructor.
	@return T -- The object that was passed as the first argument.
]=]

function Janitor:AddObject<T, A...>(
	Constructor: { new: (A...) -> T },
	MethodName: (boolean | string)?,
	Index: any?,
	...: A...
): T
	return self:Add(Constructor.new(...), MethodName, Index)
end

--[=[
	Adds a [Promise](https://github.com/evaera/roblox-lua-promise) to the Janitor. If the Janitor is cleaned up and the Promise is not completed, the Promise will be cancelled.

	@param PromiseObject Promise -- The promise you want to add to the Janitor.
	@return Promise
]=]

function Janitor:AddPromise(PromiseObject)
	if not Promise then
		return PromiseObject
	end

	if not Promise.is(PromiseObject) then
		error(string.format(NOT_A_PROMISE, typeof(PromiseObject), `{PromiseObject}`, debug.traceback(nil, 2)))
	end

	if PromiseObject:getStatus() == Promise.Status.Started then
		local Id = newproxy(false)
		local NewPromise = self:Add(
			Promise.new(function(Resolve, _, OnCancel)
				if OnCancel(function()
						PromiseObject:cancel()
					end) then
					return
				end

				Resolve(PromiseObject)
			end),
			"cancel",
			Id
		)

		NewPromise:finally(function()
			self:Remove(Id)
		end)

		return NewPromise
	end

	return PromiseObject
end

--[=[
	Cleans up whatever `Object` was set to this namespace by the 3rd parameter of [Janitor.Add](#Add).

	@param Index any -- The index you want to remove.
	@return Janitor
]=]

function Janitor:Remove(Index: any)
	local This = self[IndicesReference]

	if This then
		local Object = This[Index]

		if Object then
			local MethodName = self.TrackedObjects[Object]

			if MethodName then
				if type(Object) == "function" then
					Object()
				else
					local Cancelled
					if coroutine.running() ~= Object then
						Cancelled = pcall(function()
							task.cancel(Object)
						end)
					end

					if not Cancelled then
						task.defer(function()
							if Object then
								task.cancel(Object)
							end
						end)
					end
				end
			else
				local ObjectMethod = Object[MethodName]
				if ObjectMethod then
					if self.SuppressInstanceReDestroy and MethodName == "Destroy" and typeof(Object) == "Instance" then
						pcall(ObjectMethod, Object)
					else
						ObjectMethod(Object)
					end
				end
			end

			self.TrackedObjects[Object] = nil
		end

		This[Index] = nil
	end

	return self
end

--[=[
	Removes an object from the Janitor without running a cleanup.

	@since v1.15
	@param Index any -- The index you are removing.
	@return Janitor
]=]

function Janitor:RemoveNoClean(Index : any)
	local This = self[IndicesReference]

	if This then
		local Object = This[Index]
		if Object then
			self.TrackedObjects[Object] = nil
		end

		This[Index] = nil
	end

	return self
end

--[=[
	Cleans up multiple objects at once.

	@since v1.14
	@param ... any -- The indices you want to remove.
	@return Janitor
]=]

function Janitor:RemoveList(... : any)
	local This = self[IndicesReference]
	if This then
		local Length = select("#", ...)
		if Length == 1 then
			return self:Remove(...)
		end

		for SelectIndex = 1, Length do
			local Remove = select(SelectIndex, ...)
			self:Remove(Remove)
		end
	end

	return self
end

--[=[
	Cleans up multiple objects at once without running their cleanup.

	@since v1.15
	@param ... any -- The indices you want to remove.
	@return Janitor
]=]

function Janitor:RemoveListNoClean(... : any)
	local This = self[IndicesReference]
	if This then
		local Length = select("#", ...)
		if Length == 1 then
			return self:RemoveNoClean(...)
		end

		for SelectIndex = 1, Length do
			local Index = select(SelectIndex, ...)
			local Object = This[Index]
			if Object then
				self.TrackedObjects[Object] = nil
			end

			This[Index] = nil
		end
	end

	return self
end

--[=[
	Gets whatever object is stored with the given index, if it exists. This was added since Maid allows getting the task using `__index`.

	@param Index any -- The index that the object is stored under.
	@return any? -- This will return the object if it is found, but it won't return anything if it doesn't exist.
]=]

function Janitor:Get(Index : any) : any?
	local This = self[IndicesReference]
	return if This then This[Index] else nil
end

--[=[
	Returns a frozen copy of the Janitor's indices.

	@since v1.15.1
	@return {[any]: any}
]=]

function Janitor:GetAll() : {[any] : any}
	local This = self[IndicesReference]
	return if This then table.freeze(table.clone(This)) else {}
end

local function GetFenv(self)
	return function()
		for Object, MethodName in self.TrackedObjects do
			if Object ~= IndicesReference and Object ~= "SuppressInstanceReDestroy" then
				return Object, MethodName
			end
		end
	end
end

--[=[
	Calls each Object's `MethodName` (or calls the Object if `MethodName == true`) and removes them from the Janitor. Also clears the namespace.
	This function is also called when you call a Janitor Object (so it can be used as a destructor callback).
]=]

function Janitor:Cleanup()
	if not self.CurrentlyCleaning then
		self.CurrentlyCleaning = nil

		local Get = GetFenv(self)
		local Object, MethodName = Get()

		while Object and MethodName do -- changed to a while loop so that if you add to the janitor inside of a callback it doesn't get untracked (instead it will loop continuously which is a lot better than a hard to pindown edgecase)
			if MethodName == true then
				if type(Object) == "function" then
					Object()
				else
					local Cancelled
					if coroutine.running() ~= Object then
						Cancelled = pcall(function()
							task.cancel(Object)
						end)
					end

					if not Cancelled then
						task.defer(function()
							if Object then
								task.cancel(Object)
							end
						end)
					end
				end
			else
				local ObjectMethod = Object[MethodName]
				if ObjectMethod then
					if self.SuppressInstanceReDestroy and MethodName == "Destroy" and typeof(Object) == "Instance" then
						pcall(ObjectMethod, Object)
					else
						ObjectMethod(Object)
					end
				end
			end

			self.TrackedObjects[Object] = nil
			Object, MethodName = Get()
		end

		local This = self[IndicesReference]
		if This then
			table.clear(This)
			self[IndicesReference] = {}
		end

		self.CurrentlyCleaning = false
	end
end

--[=[
	Calls [Janitor.Cleanup](#Cleanup) and renders the Janitor unusable.

	:::warning
	Running this will make any further attempts to call a method of Janitor error.
	:::
]=]

function Janitor:Destroy()
	self:Cleanup()
	table.clear(self)
	setmetatable(self, nil)
end

Janitor.__call = Janitor.Cleanup

--[=[
	"Links" this Janitor to an Instance, such that the Janitor will `Cleanup` when the Instance is `Destroyed()` and garbage collected.
	A Janitor may only be linked to one instance at a time, unless `AllowMultiple` is true. When called with a truthy `AllowMultiple` parameter,
	the Janitor will "link" the Instance without overwriting any previous links, and will also not be overwritable.
	When called with a falsy `AllowMultiple` parameter, the Janitor will overwrite the previous link which was also called with a falsy `AllowMultiple` parameter, if applicable.

	@param Object Instance -- The instance you want to link the Janitor to.
	@param AllowMultiple? boolean -- Whether or not to allow multiple links on the same Janitor.
	@return RBXScriptConnection -- A RBXScriptConnection that can be disconnected to prevent the cleanup of LinkToInstance.
]=]

function Janitor:LinkToInstance(Object : Instance, AllowMultiple : boolean?) : RBXScriptConnection
	local IndexToUse = if AllowMultiple then newproxy(false) else LinkToInstanceIndex

	return self:Add(Object.Destroying:Connect(function()
		self:Cleanup()
	end), "Disconnect", IndexToUse)
end

Janitor.LegacyLinkToInstance = Janitor.LinkToInstance

--[=[
	Links several instances to a new Janitor, which is then returned.

	@param ... Instance -- All the Instances you want linked.
	@return Janitor -- A new Janitor that can be used to manually disconnect all LinkToInstances.
]=]

function Janitor:LinkToInstances(... : Instance)
	local ManualCleanup = Janitor.new()
	for Index = 1, select("#", ...) do
		local Object = select(Index, ...)
		if typeof(Object) ~= "Instance" then
			continue
		end

		ManualCleanup:Add(self:LinkToInstance(Object, true), "Disconnect")
	end

	return ManualCleanup
end

function Janitor:__tostring()
	return "Janitor"
end

export type Janitor = typeof(setmetatable({
	{} :: {
		["ClassName"]: "Janitor",
		["CurrentlyCleaning"]: boolean,
		["TrackedObjects"]: { [Instance]: string },
		["SuppressInstanceReDestroy"]: boolean,

		["Add"]: <T>(self: Janitor, Object: T, MethodName: (boolean | string)?, Index: any?) -> T,
		["AddObject"]: <T, A...>(
			self: Janitor,
			Constructor: { new: (A...) -> T },
			MethodName: (boolean | string)?,
			Index: any?,
			A...
		) -> T,
		["AddPromise"]: <T>(self: Janitor, PromiseObject: T) -> T,

		["Remove"]: (self: Janitor, Index: any) -> Janitor,
		["RemoveNoClean"]: (self: Janitor, Index: any) -> Janitor,

		["RemoveList"]: (self: Janitor, ...any) -> Janitor,
		["RemoveListNoClean"]: (self: Janitor, ...any) -> Janitor,

		["Get"]: (self: Janitor, Index: any) -> any?,
		["GetAll"]: (self: Janitor) -> { [any]: any },

		["Cleanup"]: (self: Janitor) -> (),
		["Destroy"]: (self: Janitor) -> (),

		["LinkToInstance"]: (self: Janitor, Object: Instance, AllowMultiple: boolean?) -> RBXScriptConnection,
		["LinkToInstances"]: (self: Janitor, ...Instance) -> Janitor,
	}, 
	{} :: { __call: (self: Janitor) -> () },
}))

return table.freeze(Janitor :: {
	["ClassName"]: "Janitor",
	["new"]: () -> Janitor,
	["Is"]: (Value: any) -> boolean,
})