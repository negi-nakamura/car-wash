local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.react)
local ReactRoblox = require(ReplicatedStorage.Packages:WaitForChild("react-roblox"))
local RootUI = require(ReplicatedStorage.shared.feature.app.ui.RootUI)
local e = React.createElement

local player = Players. LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

return function()
    local container = Instance.new("ScreenGui")
    container.Name = "React"
    container.IgnoreGuiInset = true
    container.ResetOnSpawn = false
    container. ZIndexBehavior = Enum. ZIndexBehavior.Sibling
    container.ClipToDeviceSafeArea = false
    container.Parent = playerGui
    local root = ReactRoblox.createRoot(container)
    local app = e(RootUI)
    root : render(app)
end