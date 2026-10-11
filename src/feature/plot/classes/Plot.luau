local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlotBuilder = require(ReplicatedStorage.shared.feature.plot.modules.PlotBuilder)

local SPAWN_OFFSET = Vector3.new(0, 5, 0)
local ROOT_PART_TIMEOUT = 5

local Plot = {}
Plot.__index = Plot

export type Plot = typeof(setmetatable({} :: {
	Id: string,
	Player: Player,
	Model: Model,
	SpawnPart: BasePart,
	_characterConnection: RBXScriptConnection?,
	_destroyed: boolean,
}, Plot))

function Plot.New(player: Player): Plot
	local id = HttpService:GenerateGUID(false)
	local model, spawnPart = PlotBuilder.Build(id, player)

	local self = setmetatable({
		Id = id,
		Player = player,
		Model = model,
		SpawnPart = spawnPart,
		_characterConnection = nil,
		_destroyed = false,
	}, Plot)

	return self
end

function Plot:_TeleportCharacter(character: Model)
	if self._destroyed then
		return
	end

	local rootPart = character:WaitForChild("HumanoidRootPart", ROOT_PART_TIMEOUT)
	if not rootPart then
		return
	end

	if self._destroyed then
		return
	end

	character:PivotTo(self.SpawnPart.CFrame + SPAWN_OFFSET)
end

function Plot:SpawnPlayer()
	if self._destroyed then
		return
	end

	if self._characterConnection then
		self._characterConnection:Disconnect()
	end

	self._characterConnection = self.Player.CharacterAdded:Connect(function(character)
		self:_TeleportCharacter(character)
	end)

	local character = self.Player.Character
	if not character then
		-- The CharacterAdded handler teleports once it spawns
		return
	end

	self:_TeleportCharacter(character)
end

function Plot:Destroy()
	if self._destroyed then
		return
	end
	self._destroyed = true

	if self._characterConnection then
		self._characterConnection:Disconnect()
		self._characterConnection = nil
	end

	self.Model:Destroy()
	self.SpawnPart:SetAttribute("Occupied", false)
end

return Plot