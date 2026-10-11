local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CustomerTypes = require(ReplicatedStorage.shared.feature.customer.types.CustomerTypes)

local BasicCustomer: CustomerTypes.CustomerDef = {
	Name = "Nissan",
	Size = Vector3.new(6, 3, 12),
	Color = Color3.fromRGB(70, 130, 220),
	Speed = 30,
}

return table.freeze(BasicCustomer)