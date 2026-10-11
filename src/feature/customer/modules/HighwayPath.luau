local CollectionService = game:GetService("CollectionService")

local HighwayPath = {}

local HIGHWAY_TAG = "Highway"
local START_NAME = "Start"
local END_NAME = "End"

local warned: { [string]: boolean } = {}

local function Warn(message: string)
	if warned[message] then
		return
	end

	warned[message] = true
	warn(`[HighwayPath] {message}`)
end

local function GetHighway(): Instance?
	for _, instance in CollectionService:GetTagged(HIGHWAY_TAG) do
		if instance:IsDescendantOf(workspace) then
			return instance
		end
	end

	Warn(`no instance in workspace tagged "{HIGHWAY_TAG}"`)
	return nil
end

local function GetPart(highway: Instance, name: string): BasePart?
	local part = highway:FindFirstChild(name, true)

	if not part or not part:IsA("BasePart") then
		Warn(`"{name}" (BasePart) not found inside the "{HIGHWAY_TAG}" highway`)
		return nil
	end

	return part
end

-- Returns the Start and End positions. Place each marker's center at road-surface height.
function HighwayPath.GetPoints(): { Vector3 }?
	local highway = GetHighway()

	if not highway then
		return nil
	end

	local start = GetPart(highway, START_NAME)
	local finish = GetPart(highway, END_NAME)

	if not start or not finish then
		return nil
	end

	return {
		start.Position,
		finish.Position,
	}
end

return HighwayPath
