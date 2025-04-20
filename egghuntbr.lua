-- made by leeozyeb 
-- https://www.youtube.com/channel/UCu8AGJu9yGVb5Djb5e7H7Dw

-- // Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- // Player Variables
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local mouse = localPlayer:GetMouse() -- Useful for position sometimes, but UIS is better

-- // --- Configuration ---
local GUI_NAME = "no skid"
local FRAME_TITLE = "Egg Hunt Script"
local CREDITS_TEXT = "credits: leeozyeb"

local BUTTON_INFO = {
	-- Key: Button Name, Value: {Text Label, Target Folder Name}
	Baby = {"Baby", "EggHunt_Baby"},
	Easy = {"Easy", "EggHunt_Easy"},
	Medium = {"Medium", "EggHunt_Medium"},
	Hard = {"Hard", "EggHunt_Hard"},
	Extreme = {"Extreme", "EggHunt_Extreme"},
}

-- GUI Appearance
local FRAME_SIZE = UDim2.new(0, 200, 0, 250) -- Main draggable frame size
local HEADER_HEIGHT = 30 -- Pixels
local BUTTON_HEIGHT = 30 -- Pixels
local PADDING = 5 -- Pixels
local CREDITS_HEIGHT = 20 -- Pixels

local COLOR_BACKGROUND = Color3.fromRGB(40, 40, 40)
local COLOR_HEADER = Color3.fromRGB(60, 60, 60)
local COLOR_BUTTON = Color3.fromRGB(75, 125, 175)
local COLOR_BUTTON_HOVER = Color3.fromRGB(95, 145, 195)
local COLOR_CLOSE_BUTTON = Color3.fromRGB(200, 50, 50)
local COLOR_CLOSE_BUTTON_HOVER = Color3.fromRGB(230, 80, 80)
local COLOR_TEXT = Color3.fromRGB(230, 230, 230)
local FONT = Enum.Font.SourceSansBold

-- // --- State Variables ---
local isDragging = false
local dragStartPos = Vector2.zero
local frameStartPos = UDim2.zero
local guiElements = {} -- To store created GUI elements for later access if needed
local guiVisible = true

-- // --- Core Function: Bring Parts ---
local function bringPartsFromFolder(folderName: string)
	-- (Function remains the same as previous versions)
	if not folderName or folderName == "" then warn("BringParts: Invalid folder name provided.") return end
	local character = localPlayer.Character
	if not character then warn("BringParts: Character not found for", localPlayer.Name) return end
	local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
	if not rootPart or not rootPart:IsA("BasePart") then warn("BringParts: Could not find valid Root Part for", localPlayer.Name) return end
	local destinationCFrame = rootPart.CFrame
	local targetFolder = Workspace:FindFirstChild(folderName)
	if not targetFolder then warn(`BringParts: Could not find folder named '{folderName}' in workspace.`) return end
	print(`BringParts: Found target folder: {targetFolder:GetFullName()}`)
	local partsMoved, errors = 0, 0
	for _, descendant in ipairs(targetFolder:GetDescendants()) do
		if descendant:IsA("BasePart") then
			local success, err = pcall(function() descendant.CFrame = destinationCFrame end)
			if success then partsMoved += 1 else errors += 1 warn(`BringParts: Error moving part '{descendant:GetFullName()}': {err}`) end
		end
	end
	print(`BringParts: Finished moving parts from '{folderName}' for {localPlayer.Name}. Moved: {partsMoved}, Errors: {errors}`)
end

-- // --- Function: Create GUI ---
local function createEggHuntGui()
	-- Check if GUI already exists
	if playerGui:FindFirstChild(GUI_NAME) then
		warn("BringParts: GUI '"..GUI_NAME.."' already exists. Skipping creation.")
		guiElements.ScreenGui = playerGui:FindFirstChild(GUI_NAME)
		-- Potentially find other elements if needed, or just return
		return guiElements.ScreenGui
	end

	print("BringParts: Creating GUI", GUI_NAME)

	-- 1. ScreenGui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = GUI_NAME
	screenGui.ResetOnSpawn = false
	screenGui.DisplayOrder = 10
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	guiElements.ScreenGui = screenGui

	-- 2. Main Draggable Frame
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = FRAME_SIZE
	mainFrame.Position = UDim2.new(0.1, 0, 0.1, 0) -- Initial position (top-left-ish)
	mainFrame.BackgroundColor3 = COLOR_BACKGROUND
	mainFrame.BorderSizePixel = 1
	mainFrame.BorderColor3 = COLOR_HEADER
	mainFrame.Active = true -- Allows detecting input within its bounds
	mainFrame.Draggable = false -- We implement custom dragging
	mainFrame.ClipsDescendants = true
	mainFrame.Parent = screenGui
	guiElements.MainFrame = mainFrame

	-- 3. Header Frame (for dragging and title)
	local headerFrame = Instance.new("Frame")
	headerFrame.Name = "Header"
	headerFrame.Size = UDim2.new(1, 0, 0, HEADER_HEIGHT)
	headerFrame.Position = UDim2.new(0, 0, 0, 0)
	headerFrame.BackgroundColor3 = COLOR_HEADER
	headerFrame.BorderSizePixel = 0
	headerFrame.Parent = mainFrame
	guiElements.HeaderFrame = headerFrame

	-- 4. Title Label
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -HEADER_HEIGHT - PADDING, 1, 0) -- Leave space for close button
	titleLabel.Position = UDim2.new(0, PADDING, 0, 0)
	titleLabel.BackgroundColor3 = COLOR_HEADER
	titleLabel.BackgroundTransparency = 1
	titleLabel.BorderSizePixel = 0
	titleLabel.Font = FONT
	titleLabel.Text = FRAME_TITLE
	titleLabel.TextColor3 = COLOR_TEXT
	titleLabel.TextSize = 18
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center
	titleLabel.Parent = headerFrame
	guiElements.TitleLabel = titleLabel

	-- 6. Content Frame (holds buttons and credits)
	local contentFrame = Instance.new("Frame")
	contentFrame.Name = "ContentFrame"
	contentFrame.Size = UDim2.new(1, 0, 1, -HEADER_HEIGHT)
	contentFrame.Position = UDim2.new(0, 0, 0, HEADER_HEIGHT)
	contentFrame.BackgroundTransparency = 1 -- Make it invisible, just a container
	contentFrame.BorderSizePixel = 0
	contentFrame.ClipsDescendants = true
	contentFrame.Parent = mainFrame
	guiElements.ContentFrame = contentFrame

	-- 7. Button Container Frame (inside content frame)
	local buttonContainer = Instance.new("Frame")
	buttonContainer.Name = "ButtonContainer"
	-- Calculate height needed for buttons + padding
	local numButtons = 0
	for _ in pairs(BUTTON_INFO) do numButtons += 1 end
	local buttonsTotalHeight = (numButtons * BUTTON_HEIGHT) + ((numButtons - 1) * PADDING)
	buttonContainer.Size = UDim2.new(1, -(PADDING * 2), 0, buttonsTotalHeight)
	buttonContainer.Position = UDim2.new(0, PADDING, 0, PADDING)
	buttonContainer.BackgroundTransparency = 1
	buttonContainer.BorderSizePixel = 0
	buttonContainer.Parent = contentFrame
	guiElements.ButtonContainer = buttonContainer

	-- 8. UIListLayout for Buttons
	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, PADDING)
	listLayout.FillDirection = Enum.FillDirection.Vertical
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder -- Can use Name if buttons are named alphabetically
	listLayout.Parent = buttonContainer

	-- 9. Create Action Buttons
	local layoutOrder = 0
	for buttonKey, info in pairs(BUTTON_INFO) do
		local buttonLabel = info[1]
		local folderName = info[2]

		local actionButton = Instance.new("TextButton")
		actionButton.Name = buttonKey .. "Button"
		actionButton.Text = buttonLabel
		actionButton.Size = UDim2.new(1, 0, 0, BUTTON_HEIGHT) -- Width 100%, Height fixed
		actionButton.BackgroundColor3 = COLOR_BUTTON
		actionButton.BorderSizePixel = 1
		actionButton.BorderColor3 = Color3.new(0,0,0)
		actionButton.Font = FONT
		actionButton.TextColor3 = COLOR_TEXT
		actionButton.TextSize = 14
		actionButton.LayoutOrder = layoutOrder
		actionButton.AutoButtonColor = false -- Handle hover manually
		actionButton.Parent = buttonContainer

		-- Click Action
		actionButton.MouseButton1Click:Connect(function()
			print(`BringParts: Button '{actionButton.Name}' clicked, targeting folder '{folderName}'`)
			bringPartsFromFolder(folderName)
		end)

		-- Hover Effect
		actionButton.MouseEnter:Connect(function() actionButton.BackgroundColor3 = COLOR_BUTTON_HOVER end)
		actionButton.MouseLeave:Connect(function() actionButton.BackgroundColor3 = COLOR_BUTTON end)

		layoutOrder += 1
	end

	-- 10. Credits Label
	local creditsLabel = Instance.new("TextLabel")
	creditsLabel.Name = "Credits"
	creditsLabel.Size = UDim2.new(1, -(PADDING*2), 0, CREDITS_HEIGHT)
	-- Position below buttons (AnchorPoint 1,1 means position is bottom-right corner)
	creditsLabel.AnchorPoint = Vector2.new(0.5, 1)
	creditsLabel.Position = UDim2.new(0.5, 0, 1, -PADDING) -- Center horizontally, PADDING from bottom
	creditsLabel.BackgroundColor3 = COLOR_BACKGROUND
	creditsLabel.BackgroundTransparency = 1
	creditsLabel.BorderSizePixel = 0
	creditsLabel.Font = Enum.Font.SourceSans -- Use a standard font maybe
	creditsLabel.Text = CREDITS_TEXT
	creditsLabel.TextColor3 = COLOR_TEXT:Lerp(Color3.new(0,0,0), 0.5) -- Slightly dimmer text
	creditsLabel.TextSize = 12
	creditsLabel.TextXAlignment = Enum.TextXAlignment.Center
	creditsLabel.TextYAlignment = Enum.TextYAlignment.Center
	creditsLabel.Parent = contentFrame
	guiElements.CreditsLabel = creditsLabel


	-- // --- GUI Interactions ---

	-- Dragging Logic
	headerFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = true
			dragStartPos = input.Position
			frameStartPos = mainFrame.Position
			-- Optional: Bring GUI to front visually if needed (using DisplayOrder or ZIndex)
			-- screenGui.DisplayOrder = screenGui.DisplayOrder + 1 -- Simple way, might stack up
		end
	end)

	headerFrame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = false
		end
	end)

	-- Use RenderStepped for smooth dragging update while mouse is held
	RunService.RenderStepped:Connect(function()
		if isDragging then
			local currentMousePos = UserInputService:GetMouseLocation()
			local delta = currentMousePos - dragStartPos
			-- Calculate new position based on starting position + mouse movement delta
			mainFrame.Position = UDim2.new(frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X,
			                                frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y)
		end
	end)

	-- 11. Parent ScreenGui to PlayerGui LAST
	screenGui.Parent = playerGui
	print("BringParts: GUI created and interactions connected.")
	return screenGui
end

-- // --- Main Execution ---
-- Wait for PlayerGui to be ready
if not playerGui then
	localPlayer.ChildAdded:Wait()
	playerGui = localPlayer:FindFirstChild("PlayerGui")
end

if playerGui then
	createEggHuntGui() -- Call the function to create the GUI
else
	warn("BringParts: Could not find PlayerGui for", localPlayer.Name, "- GUI cannot be created.")
end

print("EggHunt Teleport GUI (Client-Side, Draggable, Toggleable) script loaded.")
