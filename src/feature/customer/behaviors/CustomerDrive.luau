local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local PathFollower = require(ReplicatedStorage.shared.feature.customer.modules.PathFollower)
local CustomerController = require(ServerScriptService.server.feature.customer.classes.CustomerController)

local CustomerDrive = {}
CustomerDrive.__index = CustomerDrive

export type CustomerDrive = typeof(setmetatable({} :: {
	_follower: PathFollower.PathFollower,
	_onDone: () -> (),
}, CustomerDrive))

function CustomerDrive.New(
	controller: CustomerController.CustomerController,
	points: { Vector3 },
	onDone: () -> ()
): CustomerDrive
	return setmetatable({
		_follower = PathFollower.New(controller.Model, points, controller.Def.Speed),
		_onDone = onDone,
	}, CustomerDrive)
end

function CustomerDrive:Start()
	self._follower:Start(self._onDone)
end

function CustomerDrive:Cancel()
	self._follower:Cancel()
end

return CustomerDrive
