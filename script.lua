-- Load Infinite Yield
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local teleporting = false
local walkingSpeedThreshold = 16
local fallbackPosition = Vector3.new(-278.85, 179.70, 343.26)

-- Create UI
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
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

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 200, 0, 50)
statusLabel.Position = UDim2.new(0.5, -100, 0.8, -25)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextScaled = true
statusLabel.Text = "Teleporting: false"
statusLabel.Parent = screenGui

local function updateStatusLabel()
    statusLabel.Text = "Teleporting: " .. tostring(teleporting)
end

function teleportToPlayers()
    local playerList = Players:GetPlayers()
    local index = 1

    while teleporting do
        updateStatusLabel()

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

    updateStatusLabel()
end

-- Function to execute fling using Infinite Yield
local function runFlingCommand()
    local InfiniteYield = getrenv()._G.InfiniteYield
    if InfiniteYield then
        InfiniteYield.ExecuteCommand("fling")
    end
end

-- Start Infinite Yield fling when script runs
runFlingCommand()

-- Detect when player dies and restart fling
localPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        wait(1) -- Small delay to ensure character reloads
        runFlingCommand() -- Restart fling upon death
    end)
end)

-- Button Functions
startButton.MouseButton1Click:Connect(function()
    if not teleporting then
        teleporting = true
        updateStatusLabel()
        teleportToPlayers()
    end
end)

pauseButton.MouseButton1Click:Connect(function()
    teleporting = false
    updateStatusLabel()
    localPlayer.Character:SetPrimaryPartCFrame(CFrame.new(fallbackPosition))
end)
