local RunService = game:GetService("RunService")

local PathFollower = {}
PathFollower.__index = PathFollower

export type PathFollower = typeof(setmetatable({} :: {
	_target: PVInstance,
	_points: { Vector3 },
	_speed: number,
	_index: number,
	_direction: Vector3,
	_connection: RBXScriptConnection?,
}, PathFollower))

function PathFollower.New(target: PVInstance, points: { Vector3 }, speed: number): PathFollower
	return setmetatable({
		_target = target,
		_points = points,
		_speed = speed,
		_index = 2,
		_direction = Vector3.zAxis,
		_connection = nil,
	}, PathFollower)
end

local function Face(target: PVInstance, position: Vector3, direction: Vector3)
	target:PivotTo(CFrame.lookAt(position, position + direction))
end

function PathFollower:Start(onDone: () -> ())
	if self._connection then
		return
	end

	if #self._points < 2 then
		onDone()
		return
	end

	local offset = self._points[2] - self._points[1]

	if offset.Magnitude > 0 then
		self._direction = offset.Unit
	end

	Face(self._target, self._points[1], self._direction)

	self._connection = RunService.Heartbeat:Connect(function(dt: number)
		self:_Step(dt)

		if self._index <= #self._points then
			return
		end

		self:Cancel()
		onDone()
	end)
end

function PathFollower:_Step(dt: number)
	local position = self._target:GetPivot().Position
	local remaining = self._speed * dt

	while remaining > 0 and self._index <= #self._points do
		local goal = self._points[self._index]
		local offset = goal - position
		local distance = offset.Magnitude

		if distance > 0 then
			self._direction = offset.Unit
		end

		if distance <= remaining then
			position = goal
			remaining -= distance
			self._index += 1
			continue
		end

		position += self._direction * remaining
		remaining = 0
	end

	Face(self._target, position, self._direction)
end

function PathFollower:Cancel()
	if not self._connection then
		return
	end

	self._connection:Disconnect()
	self._connection = nil
end

return PathFollower
