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

	local plot = Plot.New(player)
	plot:SpawnPlayer()
	plots[player] = plot

	PlayerState.SetPath(player, "session.plotId", plot.Id)
end

function PlotService:PlayerRemoving(player: Player)
	local plot = plots[player]

	if not plot then
		return
	end

	plot:Destroy()
	plots[player] = nil

	PlayerState.SetPath(player, "session.plotId", nil)
end

return PlotService