local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local PlayerState = require(ServerScriptService.server.core.PlayerState)
local PlotService = require(ServerScriptService.server.feature.plot.PlotService)

local initializing: {[Player]: boolean} = {}
local initialized: {[Player]: boolean} = {}

PlotService:Init()

local function OnPlayerAdded(player: Player)
	if initializing[player] or initialized[player] then
		return
	end

	initializing[player] = true

	local success = PlayerState.Init(player)

	initializing[player] = nil

	if not success then
		warn("[Server] Failed to initialize PlayerState for:", player.Name)
		return
	end

	-- The player may have left while their data was loading.
	if player.Parent ~= Players then
		return
	end

	initialized[player] = true
	PlotService:PlayerAdded(player)
end

local function OnPlayerRemoving(player: Player)
	if initialized[player] then
		PlotService:PlayerRemoving(player)
	end

	initialized[player] = nil
	initializing[player] = nil
end

Players.PlayerAdded:Connect(OnPlayerAdded)
Players.PlayerRemoving:Connect(OnPlayerRemoving)

for _, player in Players:GetPlayers() do
	task.spawn(OnPlayerAdded, player)
end