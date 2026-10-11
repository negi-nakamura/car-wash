local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local CustomerTypes = require(ReplicatedStorage.shared.feature.customer.types.CustomerTypes)

local CustomerBuilder = {}

local CONTAINER_NAME = "Customers"

local function GetContainer(): Folder
	local existing = workspace:FindFirstChild(CONTAINER_NAME)

	if existing and existing:IsA("Folder") then
		return existing
	end

	local container = Instance.new("Folder")
	container.Name = CONTAINER_NAME
	container.Parent = workspace

	return container
end

local function GetTemplate(def: CustomerTypes.CustomerDef): Model?
	local assets = ServerStorage:FindFirstChild("Assets")
	local customers = assets and assets:FindFirstChild("Cars")
	local template = customers and customers:FindFirstChild(def.Name)

	if not template or not template:IsA("Model") then
		warn(`ServerStorage.Assets.Cars.{def.Name} (Model) not found`)
		return nil
	end

	return template
end

local function Prepare(model: Model)
	for _, descendant in model:GetDescendants() do
		if not descendant:IsA("BasePart") then
			continue
		end

		descendant.Anchored = true
		descendant.CanCollide = false
		descendant.CanQuery = false
		descendant.CanTouch = false
	end
end

function CustomerBuilder.Build(def: CustomerTypes.CustomerDef): Model?
	local template = GetTemplate(def)

	if not template then
		return nil
	end

	local model = template:Clone()
	model.Name = def.Name
	Prepare(model)
	model.Parent = GetContainer()

	return model
end

return CustomerBuilder
