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

-- Create a TextLabel
local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 200, 0, 50)
label.Position = UDim2.new(0.5, -100, 0.2, -25)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextScaled = true
label.Text = "Penguin auto fling by Penguincre8te"
label.Parent = screenGui

-- Create Buttons
local startButton = Instance.new("TextButton")
startButton.Size = UDim2.new(0, 100, 0, 50)
startButton.Position = UDim2.new(0.5, -110, 0.9, -25)
startButton.Text = "Start"
startButton.Parent = screenGui

local pauseButton = Instance.new("TextButton")
pauseButton.Size = UDim2.new(0, 100, 0, 50)
pauseButton.Position = UDim2.new(0.5, 10, 0.9, -25)
pauseButton.Text = "Reset"
pauseButton.Parent = screenGui

-- Create Status Label
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

-- Function to teleport to players dynamically
local function teleportToPlayers()
    spawn(function()
        while teleporting and wait() do
            updateStatusLabel()
            
            for _, targetPlayer in ipairs(Players:GetPlayers()) do
                if not teleporting then break end
                
                if targetPlayer ~= localPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
                    
                    if humanoid and humanoid.Health > 0 then
                        local previousPosition = targetPlayer.Character.HumanoidRootPart.Position
                        local startTime = tick()

                        while tick() - startTime < 10 and teleporting do
                            if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then break end
                            
                            local currentPosition = targetPlayer.Character.HumanoidRootPart.Position
                            local speed = (currentPosition - previousPosition).Magnitude / 0.01

                            if speed > 100 then
                                break
                            end

                            localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(currentPosition)
                            previousPosition = currentPosition

                            wait(0.01)
                        end
                    end
                end
            end
        end
        updateStatusLabel()
    end)
end

-- Start Infinite Yield fling when script runs
execCmd('fling')

-- Button Functions
startButton.MouseButton1Click:Connect(function()
    if not teleporting then
        teleporting = true
        updateStatusLabel()
        teleportToPlayers()
        execCmd('fling')
    end
end)

pauseButton.MouseButton1Click:Connect(function()
    teleporting = false
    execCmd('unfling')
    updateStatusLabel()
    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(fallbackPosition)
    end
end)

-- Detect local player's death and restart fling
localPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    
    humanoid.Died:Connect(function()
        wait(1) -- Small delay to ensure character reloads
        if teleporting then
            execCmd('fling') -- Restart fling upon death
        end
    end)
end)
