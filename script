local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local teleporting = false
local walkingSpeedThreshold = 16 -- Normal walking speed in Roblox
local fallbackPosition = Vector3.new(-278.85, 179.70, 343.26) -- Position to teleport when stopping

-- Create UI
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false -- Keep UI after player dies
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

local startButton = Instance.new("TextButton")
startButton.Size = UDim2.new(0, 100, 0, 50)
startButton.Position = UDim2.new(0.5, -110, 0.9, -25)
startButton.Text = "Start"
startButton.Parent = screenGui

local pauseButton = Instance.new("TextButton")
pauseButton.Size = UDim2.new(0, 100, 0, 50)
pauseButton.Position = UDim2.new(0.5, 10, 0.9, -25)
pauseButton.Text = "Pause"
pauseButton.Parent = screenGui

-- Create Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 200, 0, 50)
statusLabel.Position = UDim2.new(0.5, -100, 0.8, -25)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
statusLabel.TextScaled = true
statusLabel.Text = "Teleporting: false" -- Initial state
statusLabel.Parent = screenGui

-- Function to update status label
local function updateStatusLabel()
    statusLabel.Text = "Teleporting: " .. tostring(teleporting)
end

function teleportToPlayers()
    local playerList = Players:GetPlayers()
    local index = 1

    while teleporting do
        updateStatusLabel() -- Update label when teleporting starts

        if #playerList > 1 then
            local targetPlayer = playerList[index]
            if targetPlayer ~= localPlayer and targetPlayer.Character and localPlayer.Character then
                local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")

                if humanoid then
                    local previousPosition = targetPlayer.Character.PrimaryPart.Position
                    local startTime = tick()

                    while tick() - startTime < 3 and teleporting do
                        local currentPosition = targetPlayer.Character.PrimaryPart.Position
                        local speed = (currentPosition - previousPosition).Magnitude / 0.01

                        if speed > walkingSpeedThreshold then
                            localPlayer.Character:SetPrimaryPartCFrame(CFrame.new(fallbackPosition))
                            break
                        end

                        localPlayer.Character:SetPrimaryPartCFrame(CFrame.new(currentPosition))
                        previousPosition = currentPosition

                        wait(0.01)
                    end
                end
            end
            
            index = index + 1
            if index > #playerList then
                index = 1
            end
        end
    end

    updateStatusLabel() -- Update label when teleporting stops
end

-- Button Functions
startButton.MouseButton1Click:Connect(function()
    if not teleporting then
        teleporting = true
        updateStatusLabel() -- Refresh label
        teleportToPlayers()
    end
end)

pauseButton.MouseButton1Click:Connect(function()
    teleporting = false
    updateStatusLabel() -- Refresh label
    localPlayer.Character:SetPrimaryPartCFrame(CFrame.new(fallbackPosition))
end)
