local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local PlayerState = require(ServerScriptService.server.core.PlayerState)
local Plot = require(ReplicatedStorage.shared.feature.plot.classes.Plot)

local PlotService = {}

type PlotService = typeof(PlotService)

local plots: {[Player]: Plot.Plot} = {}

function PlotService:Init()
end

function PlotService:GetPlot(player: Player): Plot.Plot?
	return plots[player]
end

function PlotService:PlayerAdded(player: Player)
	if plots[player] then
		return
	end

	local success, result = pcall(Plot.New, player)
	if not success then
		warn(`[PlotService] Failed to create plot for {player.Name}: {result}`)
		player:Kick("No plot available. Please rejoin in a moment.")
		return
	end

	local plot = result :: Plot.Plot

	plots[player] = plot
	PlayerState.SetPath(player, "session.plotId", plot.Id)

	plot:SpawnPlayer()
end

function PlotService:PlayerRemoving(player: Player)
	local plot = plots[player]

	if not plot then
		return
	end

	plots[player] = nil
	plot:Destroy()

	PlayerState.SetPath(player, "session.plotId", nil)
end

return PlotService