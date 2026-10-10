local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlotBuilder = require(ReplicatedStorage.shared.feature.plot.modules.PlotBuilder)

local SPAWN_OFFSET = Vector3.new(0, 5, 0)

local Plot = {}
Plot.__index = Plot

export type Plot = typeof(setmetatable({} :: {
	Id: string,
	Player: Player,
	Model: Model,
	Spawn: BasePart,
}, Plot))

function Plot.New(player: Player): Plot
	local id = HttpService:GenerateGUID(false)
	local model, spawn = PlotBuilder.Build(id, player)

	local self = setmetatable({
		Id = id,
		Player = player,
		Model = model,
		Spawn = spawn,
	}, Plot)

	return self
end

function Plot:SpawnPlayer()
	local function TeleportCharacter(character: Model)
		character:PivotTo(self.Spawn.CFrame + SPAWN_OFFSET)
	end

	self.Player.CharacterAdded:Connect(TeleportCharacter)

	local character = self.Player.Character
		or self.Player.CharacterAdded:Wait()

	TeleportCharacter(character)
end

function Plot:Destroy()
	self.Model:Destroy()
	self.Spawn:SetAttribute("Occupied", false)
end

return Plot