-- Script by @leeozyeb
-- Creates its own GUI using Instance.new with a Submit button
-- Place this LocalScript in StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService") -- Keep for potential future use, though not strictly needed for core logic now
local UserInputService = game:GetService("UserInputService") -- Keep for TextBox focus events if needed later

-- Get the Local Player and their PlayerGui (where ScreenGuis live)
local localPlayer = Players.LocalPlayer or Players.LocalPlayerAdded:Wait()
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- Configuration (Store default/last size and appearance properties)
local config = {
	size = 50,        -- Default/last submitted size
	targetTransparency = 0.7,
	targetColor = BrickColor.new("Really blue"),
	targetMaterial = Enum.Material.Neon,
	canCollide = false
}

-- --- GUI Element Creation using Instance.new ---

-- 1. Create the ScreenGui container
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SizeControllerScreenGui_Submit"
screenGui.ResetOnSpawn = false -- Keep GUI when player respawns
screenGui.Parent = playerGui

-- 2. Create the Main Frame (Draggable)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "SizeControlFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 130) -- Adjusted height slightly
mainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- 3. Create the Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18
titleLabel.Text = "Hitbox Changer"
titleLabel.Parent = mainFrame

-- 4. Create the Size Input Label
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

-- 5. Create the Size Input TextBox
local sizeInput = Instance.new("TextBox")
sizeInput.Name = "SizeInput"
sizeInput.Size = UDim2.new(1, -70, 0, 25)
sizeInput.Position = UDim2.new(0, 60, 0, 40)
sizeInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
sizeInput.BorderColor3 = Color3.fromRGB(30, 30, 30)
sizeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
sizeInput.Font = Enum.Font.SourceSans
sizeInput.TextSize = 16
sizeInput.Text = tostring(config.size) -- Set initial text
sizeInput.ClearTextOnFocus = false
sizeInput.Parent = mainFrame

-- 6. Create the Submit Button (Replaces Toggle Button)
local submitButton = Instance.new("TextButton")
submitButton.Name = "SubmitButton"
submitButton.Size = UDim2.new(1, -20, 0, 25)
submitButton.Position = UDim2.new(0, 10, 0, 75) -- Same position as old toggle button
submitButton.BackgroundColor3 = Color3.fromRGB(80, 120, 200) -- A blue color for submit
submitButton.BorderColor3 = Color3.fromRGB(40, 60, 100)
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.Font = Enum.Font.SourceSansBold
submitButton.TextSize = 16
submitButton.Text = "Submit Size"
submitButton.Parent = mainFrame

-- 7. Create the Credit Label
local creditLabel = Instance.new("TextLabel")
creditLabel.Name = "CreditLabel"
creditLabel.Size = UDim2.new(1, -20, 0, 15)
creditLabel.Position = UDim2.new(0, 10, 0, 105) -- Below button
creditLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
creditLabel.BackgroundTransparency = 1
creditLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
creditLabel.Font = Enum.Font.SourceSansItalic
creditLabel.TextSize = 12
creditLabel.Text = "Made by @leeozyeb"
creditLabel.TextXAlignment = Enum.TextXAlignment.Right
creditLabel.Parent = mainFrame


-- --- Functionality ---

-- Function to apply the size and appearance to other players
local function applyChanges(sizeValue)
	local sizeVector = Vector3.new(sizeValue, sizeValue, sizeValue)

	-- Loop through all players currently in the game
	for _, player in ipairs(Players:GetPlayers()) do
		-- Important: Skip the LocalPlayer to not affect yourself
		if player ~= localPlayer then
			local character = player.Character
			-- Check if the player's character model exists
			if character then
				local hrp = character:FindFirstChild("HumanoidRootPart")
				-- Check if the HumanoidRootPart exists within the character
				if hrp then
					-- Use pcall (protected call) to prevent errors
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

-- Handle Submit Button Click
submitButton.MouseButton1Click:Connect(function()
	-- 1. Get the text from the input box
	local inputText = sizeInput.Text
	-- 2. Try to convert it to a number
	local num = tonumber(inputText)

	-- 3. Validate the number
	if num and num > 0 then
		-- Valid number: Update the config and apply changes
		config.size = num -- Store the valid size
		applyChanges(config.size)
	else
		-- Invalid number: Show warning and reset input box text
		warn("Invalid size input:", inputText, "- Please enter a positive number.")
		sizeInput.Text = tostring(config.size) -- Revert text to last valid size
        -- Optionally give visual feedback like changing button color briefly
        local originalColor = submitButton.BackgroundColor3
        submitButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Red flash
        wait(0.3)
        submitButton.BackgroundColor3 = originalColor
	end
end)

-- No RenderStepped loop needed for continuous application

print("Size Control GUI (Submit Only) Created and Loaded - Made by @leeozyeb")
