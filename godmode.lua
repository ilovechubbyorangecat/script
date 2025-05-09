-- GOD MODE (Improved GUI)

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner_Frame = Instance.new("UICorner") -- For rounded corners on the frame
local UIPadding_Frame = Instance.new("UIPadding") -- For internal spacing
local TitleLabel = Instance.new("TextLabel") -- Renamed for clarity
local ToggleButton = Instance.new("TextButton") -- Renamed for clarity
local UICorner_Button = Instance.new("UICorner") -- For rounded corners on the button

--Properties:

ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true -- Allows GUI to use the top bar space

Frame.Parent = ScreenGui
Frame.AnchorPoint = Vector2.new(0.5, 0.5) -- Center anchor
Frame.Position = UDim2.new(0.5, 0, 0.5, 0) -- Center position
Frame.Size = UDim2.new(0, 220, 0, 130) -- Slightly larger and more proportional
Frame.BackgroundColor3 = Color3.fromRGB(35, 37, 43) -- Darker, modern background
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0 -- Keep no border, rely on UICorner
Frame.Active = true
Frame.Draggable = true

UICorner_Frame.CornerRadius = UDim.new(0, 12) -- Rounded corners
UICorner_Frame.Parent = Frame

UIPadding_Frame.PaddingTop = UDim.new(0, 10)
UIPadding_Frame.PaddingBottom = UDim.new(0, 10)
UIPadding_Frame.PaddingLeft = UDim.new(0, 10)
UIPadding_Frame.PaddingRight = UDim.new(0, 10)
UIPadding_Frame.Parent = Frame

TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = Frame
TitleLabel.BackgroundColor3 = Color3.fromRGB(45, 47, 53) -- Slightly different for title bar look
TitleLabel.Size = UDim2.new(1, 0, 0, 35) -- Full width, fixed height
TitleLabel.Font = Enum.Font.GothamSemibold -- A cleaner, modern font (if available, else SourceSansSemibold)
TitleLabel.Text = "Killbrick Toggle"
TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 220) -- Off-white for better readability
TitleLabel.TextSize = 18.000
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
TitleLabel.TextYAlignment = Enum.TextYAlignment.Center
local TitleCorner = Instance.new("UICorner") -- Round title bar corners too
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleLabel


ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = Frame
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60) -- Initial OFF state color (Reddish)
ToggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0.5, 0, 0.65, 0) -- Positioned below title, centered
ToggleButton.AnchorPoint = Vector2.new(0.5, 0.5) -- Center anchor for the button
ToggleButton.Size = UDim2.new(0.8, 0, 0, 45) -- 80% of frame width, fixed height
ToggleButton.Font = Enum.Font.GothamMedium -- Cleaner font (if available, else SourceSans)
ToggleButton.Text = "OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
ToggleButton.TextSize = 16.000
ToggleButton.AutoButtonColor = false -- Disable default hover/press color changes

UICorner_Button.CornerRadius = UDim.new(0, 8)
UICorner_Button.Parent = ToggleButton

-- Lua Script for ToggleButton
local function LILMOQ_fake_script()
	local script = Instance.new('LocalScript', ToggleButton)

	local player = game:GetService("Players").LocalPlayer
	local isEnabled = false -- Changed variable name for clarity (nega was a bit confusing)

	local button = script.Parent

	-- Define colors for states
	local onColor = Color3.fromRGB(60, 179, 113) -- Greenish
	local offColor = Color3.fromRGB(200, 60, 60) -- Reddish
	local onTextColor = Color3.fromRGB(255, 255, 255)
	local offTextColor = Color3.fromRGB(255, 255, 255)

	local function updateButtonAppearance()
		if isEnabled then
			button.Text = "ON"
			button.BackgroundColor3 = onColor
			button.TextColor3 = onTextColor
		else
			button.Text = "OFF"
			button.BackgroundColor3 = offColor
			button.TextColor3 = offTextColor
		end
	end

	local function toggleFeature()
		isEnabled = not isEnabled
		updateButtonAppearance()
	end

	button.MouseButton1Click:Connect(function()
		toggleFeature()
	end)

	-- This part remains functionally the same, just using the 'isEnabled' variable
	local function applyToggleEffect()
		while task.wait(0.1) do -- Added a small wait to prevent extreme looping if character is nil
			local character = player.Character -- No need to wait if it's already there
			if not character then
				-- If character is not available, try to get it on next CharacterAdded
				-- This prevents the loop from yielding indefinitely if character is removed
				-- and then re-added quickly.
				return
			end
			
			local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
			if not humanoidRootPart then return end

			local parts = workspace:GetPartBoundsInRadius(humanoidRootPart.Position, 10)
			for _, part in ipairs(parts) do
				if part:IsA("BasePart") then -- Ensure it's a part that has CanTouch
					part.CanTouch = not isEnabled -- if enabled, parts are NOT touchable (killbrick disabled)
                                                -- if disabled, parts ARE touchable (killbrick active)
                                                -- The original logic was: nega = true (OFF) -> CanTouch = true
                                                --                     nega = false (ON) -> CanTouch = false
                                                -- This means "ON" = killbricks are disabled. "OFF" = killbricks are active.
                                                -- So if isEnabled (feature is ON), CanTouch should be false.
                                                -- If not isEnabled (feature is OFF), CanTouch should be true.
                                                -- Thus, part.CanTouch = not isEnabled
				end
			end
		end
	end
	
	-- Initial setup
	updateButtonAppearance() -- Set initial button look
	
	-- Connect to CharacterAdded and run the effect loop
	player.CharacterAdded:Connect(function(character)
		-- Wait for HumanoidRootPart to ensure the character is fully loaded
		character:WaitForChild("HumanoidRootPart") 
		task.spawn(applyToggleEffect) -- Use task.spawn to avoid yielding CharacterAdded
		updateButtonAppearance() -- Refresh button state, in case it was toggled while dead
	end)

	-- If character already exists when script runs
	if player.Character then
		player.Character:WaitForChild("HumanoidRootPart") -- Ensure HRP exists
		task.spawn(applyToggleEffect)
	end
end
coroutine.wrap(LILMOQ_fake_script)()
