local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CustomerTypes = require(ReplicatedStorage.shared.feature.customer.types.CustomerTypes)

local CustomerController = {}
CustomerController.__index = CustomerController

export type CustomerController = typeof(setmetatable({} :: {
	Id: string,
	Def: CustomerTypes.CustomerDef,
	Model: PVInstance,
	State: CustomerTypes.CustomerState,
	_behavior: CustomerTypes.Behavior?,
	_destroyed: boolean,
	_destroyCallbacks: { () -> () },
}, CustomerController))

function CustomerController.New(def: CustomerTypes.CustomerDef, model: PVInstance): CustomerController
	return setmetatable({
		Id = HttpService:GenerateGUID(false),
		Def = def,
		Model = model,
		State = CustomerTypes.State.Driving,
		_behavior = nil,
		_destroyed = false,
		_destroyCallbacks = {},
	}, CustomerController)
end

function CustomerController:SetState(state: CustomerTypes.CustomerState)
	self.State = state
end

function CustomerController:RunBehavior(behavior: CustomerTypes.Behavior)
	if self._destroyed then
		return
	end

	if self._behavior then
		self._behavior:Cancel()
	end

	self._behavior = behavior
	behavior:Start()
end

function CustomerController:IsDestroyed(): boolean
	return self._destroyed
end

function CustomerController:OnDestroy(callback: () -> ())
	if self._destroyed then
		callback()
		return
	end

	table.insert(self._destroyCallbacks, callback)
end

function CustomerController:Destroy()
	if self._destroyed then
		return
	end

	self._destroyed = true

	if self._behavior then
		self._behavior:Cancel()
		self._behavior = nil
	end

	self.Model:Destroy()

	for _, callback in self._destroyCallbacks do
		callback()
	end

	table.clear(self._destroyCallbacks)
end

return CustomerController