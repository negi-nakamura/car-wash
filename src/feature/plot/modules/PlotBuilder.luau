local CollectionService = game:GetService("CollectionService")
local ServerStorage = game:GetService("ServerStorage")

local PlotBuilder = {}

local TAG_NAME = "PlotSpawn"

local function ClaimSpawn(): BasePart
	for _, instance in CollectionService:GetTagged(TAG_NAME) do
		if not instance:IsA("BasePart") then
			continue
		end

		if instance:GetAttribute("Occupied") == true then
			continue
		end

		instance:SetAttribute("Occupied", true)
		return instance
	end

	error("[PlotBuilder] No available plot spawn found!")
end

function PlotBuilder.Build(id: string, player: Player): (Model, BasePart)
	local template = ServerStorage:WaitForChild("Assets"):WaitForChild("Plots"):WaitForChild("DefaultPlot") :: Model

	local spawn = ClaimSpawn()

	local success, result = pcall(function()
		local model = template:Clone()

		model.Name = `Plot_{id}`
		model:SetAttribute("Id", id)
		model:SetAttribute("OwnerUserId", player.UserId)
		model:PivotTo(spawn.CFrame)
		model.Parent = workspace:WaitForChild("PlayerPlots")

		return model
	end)

	if not success then
		spawn:SetAttribute("Occupied", false)
		error(`[PlotBuilder] Failed to build plot: {result}`)
	end

	return result :: Model, spawn
end

return PlotBuilder