local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactReflex = require(Packages.ReactReflex)
local Reflex = require(Packages.Reflex)

local Components = script.Components
local Base = require(Components.Base)

local RootProducer = require(script.Parent.Parent.RootProducer)

local app = ReactReflex.ReflexProvider({
	producer = RootProducer,
	children = {
		Base(),
	},
})
