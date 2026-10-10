export type PlayerData = {
	session: {
		plotId: string?,
	},
	Server: {},
	leaderstats: {
		["💰 Coins"]: string,
	},
	Coins: number,
	Inventory: {
		Pills: { [string]: { itemName: string, quantity: number } },
		Elixirs: { [string]: { itemName: string, quantity: number } },
	},
}

return {
	Coins = 0,

	Inventory = {
		Pills = {},
		Elixirs = {},
	},

	session = {
		plotId = nil :: string?,
	},

	Server = {},

	leaderstats = {
		["💰 Coins"] = "Coins",
	},
}