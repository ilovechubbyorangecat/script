-- you can skid whatever you want idc

-- // Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService") -- Used for WaitForChild alternative if needed

-- // Player and Camera Variables
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- // Configuration
local MIN_FOV = 30  -- Minimum allowed FOV
local MAX_FOV = 120 -- Maximum allowed FOV
local DEFAULT_FOV = camera.FieldOfView -- Get the default FOV when the script starts
local FRAME_WIDTH = 200 -- Define width for easier centering calculation
local FRAME_HEIGHT = 100 -- Define height for easier centering calculation

-- // Create GUI Elements
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FovChangerGui_Leeozyeb"
screenGui.ResetOnSpawn = false -- Keep the GUI when the player respawns
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling -- Use sibling order for ZIndex

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, FRAME_WIDTH, 0, FRAME_HEIGHT) -- Use defined variables
-- V V V Position it in the center V V V
mainFrame.Position = UDim2.new(0.5, -FRAME_WIDTH / 2, 0.5, -FRAME_HEIGHT / 2) -- Center X, Offset by -half width; Center Y, Offset by -half height
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Dark grey background
mainFrame.BorderColor3 = Color3.fromRGB(80, 80, 80) -- Lighter grey border
mainFrame.BorderSizePixel = 1
mainFrame.Active = true -- IMPORTANT: Needs to be true for Draggable to work
mainFrame.Draggable = true -- Makes it draggable

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 20) -- Full width, 20px height
titleLabel.Position = UDim2.new(0, 0, 0, 0) -- Top of the frame
titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Slightly lighter grey for title bar
titleLabel.BorderColor3 = Color3.fromRGB(80, 80, 80)
titleLabel.BorderSizePixel = 0 -- No border for title itself
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Text = "FOV Changer"
titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220) -- Light grey text
titleLabel.TextScaled = false
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.ZIndex = 2 -- Above frame background

local fovInput = Instance.new("TextBox")
fovInput.Name = "FovInput"
fovInput.Size = UDim2.new(0.6, -5, 0, 30) -- 60% width minus 5px padding, 30px height
fovInput.Position = UDim2.new(0.05, 0, 0.5, -15) -- Centered vertically inside frame, slight left padding
fovInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- Dark input background
fovInput.BorderColor3 = Color3.fromRGB(100, 100, 100)
fovInput.BorderSizePixel = 1
fovInput.Font = Enum.Font.SourceSans
fovInput.PlaceholderText = "Enter FOV (" .. MIN_FOV .. "-" .. MAX_FOV .. ")"
fovInput.Text = tostring(DEFAULT_FOV) -- Start with current FOV
fovInput.TextColor3 = Color3.fromRGB(200, 200, 200)
fovInput.TextScaled = false
fovInput.TextSize = 14
fovInput.ClearTextOnFocus = false -- Don't clear when clicked
fovInput.ZIndex = 2

local applyButton = Instance.new("TextButton")
applyButton.Name = "ApplyButton"
applyButton.Size = UDim2.new(0.3, -5, 0, 30) -- 30% width minus 5px padding, 30px height
applyButton.Position = UDim2.new(0.65, 0, 0.5, -15) -- Next to input box, centered vertically inside frame
applyButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180) -- Steel blue
applyButton.BorderColor3 = Color3.fromRGB(100, 160, 210)
applyButton.BorderSizePixel = 1
applyButton.Font = Enum.Font.SourceSansBold
applyButton.Text = "Apply"
applyButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
applyButton.TextScaled = false
applyButton.TextSize = 14
applyButton.ZIndex = 2

-- // Function to Apply FOV
local function applyFov()
	local inputText = fovInput.Text
	local number = tonumber(inputText)

	if number then
		-- Clamp the number to the allowed range
		number = math.clamp(number, MIN_FOV, MAX_FOV)
		camera.FieldOfView = number
		fovInput.Text = tostring(number) -- Update textbox with the clamped value
		print("FOV changed to:", number) -- Optional: Output confirmation
	else
		-- If input is not a valid number, reset to current FOV or default
		print("Invalid input. Please enter a number between " .. MIN_FOV .. " and " .. MAX_FOV .. ".")
		fovInput.Text = tostring(camera.FieldOfView) -- Reset text to the actual current FOV
	end
end

-- // Connect Events
applyButton.MouseButton1Click:Connect(applyFov)

-- Apply when Enter key is pressed after editing the TextBox
fovInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		applyFov()
	else
		-- If focus is lost without pressing Enter, validate and potentially reset
        local number = tonumber(fovInput.Text)
        if not number then
            fovInput.Text = tostring(camera.FieldOfView) -- Reset if invalid text remains
        end
	end
end)

-- // Parent Elements (do this last)
titleLabel.Parent = mainFrame
fovInput.Parent = mainFrame
applyButton.Parent = mainFrame
mainFrame.Parent = screenGui
screenGui.Parent = playerGui

print("Center-spawned, Draggable FOV Changer GUI by leeozyeb loaded.")

-- Optional: Clean up GUI when the script is destroyed (e.g., player leaves)
--[[
script.Destroying:Connect(function()
	if screenGui and screenGui.Parent then
		screenGui:Destroy()
	end
end)
--]]
