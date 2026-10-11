local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local CustomerTypes = require(ReplicatedStorage.shared.feature.customer.types.CustomerTypes)
local CustomerController = require(ServerScriptService.server.feature.customer.classes.CustomerController)
local CustomerDrive = require(ReplicatedStorage.shared.feature.customer.behaviors.CustomerDrive)

local CustomerRoadDrive = {}

local function GetGroundOffset(model: Model): number
	local pivot = model:GetPivot()
	local boundingCFrame, boundingSize = model:GetBoundingBox()
	local bottom = boundingCFrame.Position.Y - boundingSize.Y / 2

	return pivot.Position.Y - bottom
end

-- Assembles a customer that drives the road from start to end, then despawns.
function CustomerRoadDrive.Create(
	def: CustomerTypes.CustomerDef,
	model: Model,
	roadPoints: { Vector3 }
): CustomerController.CustomerController
	local controller = CustomerController.New(def, model)

	local lift = Vector3.yAxis * GetGroundOffset(model)
	local points = {}

	for _, point in roadPoints do
		table.insert(points, point + lift)
	end

	local drive = CustomerDrive.New(controller, points, function()
		controller:SetState(CustomerTypes.State.Finished)
		controller:Destroy()
	end)

	controller:RunBehavior(drive)

	return controller
end

return CustomerRoadDrive