-- V2 Hitbox by leeozyeb.
-- Update log: 
-- Close Button
-- Now, size is automatically updated without clicking the "Submit" Button.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer or Players.LocalPlayerAdded:Wait()
local playerGui = localPlayer:WaitForChild("PlayerGui")

local config = {
    size = 50,
    targetTransparency = 0.7,
    targetColor = BrickColor.new("Really blue"),
    targetMaterial = Enum.Material.Neon,
    canCollide = false
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SizeControllerScreenGui_Submit"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "SizeControlFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 130)
mainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -30, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18
titleLabel.Text = "Hitbox Changer V2"
titleLabel.Parent = mainFrame

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.Text = "X"
closeButton.Parent = mainFrame

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local sizeLabel = Instance.new("TextLabel")
sizeLabel.Name = "SizeLabel"
sizeLabel.Size = UDim2.new(0, 50, 0, 25)
sizeLabel.Position = UDim2.new(0, 10, 0, 40)
sizeLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
sizeLabel.BackgroundTransparency = 1
sizeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
sizeLabel.Font = Enum.Font.SourceSans
sizeLabel.TextSize = 16
sizeLabel.Text = "Size:"
sizeLabel.TextXAlignment = Enum.TextXAlignment.Left
sizeLabel.Parent = mainFrame

local sizeInput = Instance.new("TextBox")
sizeInput.Name = "SizeInput"
sizeInput.Size = UDim2.new(1, -70, 0, 25)
sizeInput.Position = UDim2.new(0, 60, 0, 40)
sizeInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
sizeInput.BorderColor3 = Color3.fromRGB(30, 30, 30)
sizeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
sizeInput.Font = Enum.Font.SourceSans
sizeInput.TextSize = 16
sizeInput.Text = tostring(config.size)
sizeInput.ClearTextOnFocus = false
sizeInput.Parent = mainFrame

local submitButton = Instance.new("TextButton")
submitButton.Name = "SubmitButton"
submitButton.Size = UDim2.new(1, -20, 0, 25)
submitButton.Position = UDim2.new(0, 10, 0, 75)
submitButton.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
submitButton.BorderColor3 = Color3.fromRGB(40, 60, 100)
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.Font = Enum.Font.SourceSansBold
submitButton.TextSize = 16
submitButton.Text = "Submit Size"
submitButton.Parent = mainFrame

local creditLabel = Instance.new("TextLabel")
creditLabel.Name = "CreditLabel"
creditLabel.Size = UDim2.new(1, -20, 0, 15)
creditLabel.Position = UDim2.new(0, 10, 0, 105)
creditLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
creditLabel.BackgroundTransparency = 1
creditLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
creditLabel.Font = Enum.Font.SourceSansItalic
creditLabel.TextSize = 12
creditLabel.Text = "Made by @leeozyeb"
creditLabel.TextXAlignment = Enum.TextXAlignment.Right
creditLabel.Parent = mainFrame

local function applyChanges(sizeValue)
    local sizeVector = Vector3.new(sizeValue, sizeValue, sizeValue)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local character = player.Character
            if character then
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    pcall(function()
                        hrp.Size = sizeVector
                        hrp.Transparency = config.targetTransparency
                        hrp.BrickColor = config.targetColor
                        hrp.Material = config.targetMaterial
                        hrp.CanCollide = config.canCollide
                    end)
                end
            end
        end
    end
    print("Applied size", sizeValue, "to other players.")
end

submitButton.MouseButton1Click:Connect(function()
    local inputText = sizeInput.Text
    local num = tonumber(inputText)
    if num and num > 0 then
        config.size = num
        applyChanges(config.size)
    else
        warn("Invalid size input:", inputText, "- Please enter a positive number.")
        sizeInput.Text = tostring(config.size)
        local originalColor = submitButton.BackgroundColor3
        submitButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        task.wait(0.3)
        submitButton.BackgroundColor3 = originalColor
    end
end)

while true do
    task.wait(1)
    applyChanges(config.size)
end

print("Size Control GUI (Submit Only) Created and Loaded - Made by @leeozyeb")
