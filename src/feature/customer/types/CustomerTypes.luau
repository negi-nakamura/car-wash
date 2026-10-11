local CustomerTypes = {}

export type CustomerState = "Driving" | "Finished"

export type CustomerDef = {
	Name: string,
	Size: Vector3,
	Color: Color3,
	Speed: number,
}

export type Behavior = {
	Start: (any) -> (),
	Cancel: (any) -> (),
}

CustomerTypes.State = table.freeze({
	Driving = "Driving" :: CustomerState,
	Finished = "Finished" :: CustomerState,
})

return CustomerTypes
