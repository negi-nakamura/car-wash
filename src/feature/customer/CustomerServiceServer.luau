local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local CustomerController = require(ServerScriptService.server.feature.customer.classes.CustomerController)
local CustomerBuilder = require(ReplicatedStorage.shared.feature.customer.modules.CustomerBuilder)
local CustomerRoadDrive = require(ReplicatedStorage.shared.feature.customer.factory.CustomerHighwayDrive)
local CustomerTypes = require(ReplicatedStorage.shared.feature.customer.types.CustomerTypes)
local BasicCustomer = require(ReplicatedStorage.shared.feature.customer.customers.BasicCustomer)
local HighwayPath = require(ReplicatedStorage.shared.feature.customer.modules.HighwayPath)

local SPAWN_INTERVAL = 4
local MAX_CUSTOMERS = 10

local CustomerService = {}

local customers: { [string]: CustomerController.CustomerController } = {}
local customerCount = 0
local running = false

type CustomerService = typeof(CustomerService)

function CustomerService:Init()
    if running then
        return
    end
    running = true

    task.spawn(function()
        while running do
            CustomerService:Spawn(BasicCustomer)
            task.wait(SPAWN_INTERVAL)
        end
    end)
end

function CustomerService:GetCustomer(id: string): CustomerController.CustomerController?
   return customers[id]
end

function CustomerService:Spawn(def: CustomerTypes.CustomerDef): CustomerController.CustomerController?
	if customerCount >= MAX_CUSTOMERS then
		return nil
	end

	if #Players:GetPlayers() == 0 then
		return nil
	end

	local points = HighwayPath.GetPoints()

	if not points then
		return nil
	end

	local model = CustomerBuilder.Build(def)
	local controller = CustomerRoadDrive.Create(def, model, points)

	if controller:IsDestroyed() then
		return nil
	end

	customers[controller.Id] = controller
	customerCount += 1

	controller:OnDestroy(function()
		customers[controller.Id] = nil
		customerCount -= 1
	end)

	return controller
end

function CustomerService:Stop()
	running = false

	for _, controller in customers do
		controller:Destroy()
	end
end

return CustomerService