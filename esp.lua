--[[
    ESP Script with Outlines, Team Colors & Health (Educational Purposes Only)
    Demonstrates using Highlights and BillboardGuis for player info.

    WARNING: Using scripts like this for cheating violates Roblox ToS and can lead to bans.
             This script is ONLY for learning about client-side scripting and UI.
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui") -- Parent Highlight instances here

-- Local Player (to exclude self)
local localPlayer = Players.LocalPlayer
if not localPlayer then
    warn("[ESP Script] Could not get LocalPlayer. Script may not function correctly.")
    return -- Stop if not running on a client
end

-- Configuration
local OUTLINE_THICKNESS = 0.1 -- Adjust for desired outline thickness
local TEXT_COLOR = Color3.fromRGB(255, 255, 255) -- White text
local TEXT_SIZE = 14
local MAX_DISTANCE = 500 -- Max distance (studs) to show ESP. Set to math.huge for infinite.
local VERTICAL_OFFSET_TEXT = 3.5 -- How many studs above the target part to show the text (increased slightly)
local DEFAULT_TEAM_COLOR = Color3.fromRGB(200, 200, 200) -- Color for players without a team (Light Grey)

-- Storage for active ESP elements (Player -> {Highlight = HighlightInstance, Billboard = BillboardGuiInstance})
local activeEspElements = {}

-- Function to create or update ESP elements for a target player
local function updateOrCreateEsp(player)
    local character = player.Character
    local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
    local targetPart = character and character:FindFirstChild("HumanoidRootPart") -- Anchor for BillboardGui

    -- === Validation ===
    -- Check if player is valid, has character/humanoid/rootpart, is alive, and is not the local player
    if not player or player == localPlayer or not character or not humanoid or humanoid.Health <= 0 or not targetPart then
        -- Cleanup if invalid
        if activeEspElements[player] then
            if activeEspElements[player].Highlight and activeEspElements[player].Highlight.Parent then
                activeEspElements[player].Highlight:Destroy()
            end
            if activeEspElements[player].Billboard and activeEspElements[player].Billboard.Parent then
                activeEspElements[player].Billboard:Destroy()
            end
            activeEspElements[player] = nil
        end
        return -- Stop processing this player
    end

    -- === Distance Check ===
    local distance = 0
    local localCharacter = localPlayer.Character
    local localRootPart = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
    if localRootPart then
        distance = (targetPart.Position - localRootPart.Position).Magnitude
        if distance > MAX_DISTANCE then
            -- Cleanup if too far
            if activeEspElements[player] then
                 if activeEspElements[player].Highlight and activeEspElements[player].Highlight.Parent then
                    activeEspElements[player].Highlight:Destroy()
                end
                if activeEspElements[player].Billboard and activeEspElements[player].Billboard.Parent then
                    activeEspElements[player].Billboard:Destroy()
                end
                activeEspElements[player] = nil
            end
            return
        end
    else
         -- Can't calculate distance if local player has no root part yet
         if activeEspElements[player] then
             if activeEspElements[player].Highlight and activeEspElements[player].Highlight.Parent then
                activeEspElements[player].Highlight:Destroy()
            end
            if activeEspElements[player].Billboard and activeEspElements[player].Billboard.Parent then
                activeEspElements[player].Billboard:Destroy()
            end
            activeEspElements[player] = nil
         end
        return
    end

    -- === Get or Create Elements ===
    local elements = activeEspElements[player]
    local teamColor = player.TeamColor and player.TeamColor.Color or DEFAULT_TEAM_COLOR
    local health = math.floor(humanoid.Health)
    local maxHealth = humanoid.MaxHealth -- Get max health for potential percentage later

    -- --- Highlight ---
    local highlight = elements and elements.Highlight
    if not highlight or not highlight.Parent then
        highlight = Instance.new("Highlight")
        highlight.Name = "PlayerESP_Highlight"
        highlight.Adornee = character -- Highlight the whole character model
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- See through walls
        highlight.OutlineTransparency = 0 -- Visible outline
        highlight.OutlineColor = teamColor
        highlight.FillTransparency = 1 -- Invisible fill
        highlight.FillColor = teamColor -- Set anyway, good practice
        highlight.Enabled = true
        highlight.Parent = CoreGui -- Parent to CoreGui to keep it client-side

        -- Store/update the reference
        if not elements then elements = {} end
        elements.Highlight = highlight
        activeEspElements[player] = elements
    else
        -- Update existing highlight if needed (e.g., team changed)
        if highlight.Adornee ~= character then highlight.Adornee = character end -- Re-assign if character reset
        if highlight.OutlineColor ~= teamColor then highlight.OutlineColor = teamColor end
         if highlight.FillColor ~= teamColor then highlight.FillColor = teamColor end
         if not highlight.Enabled then highlight.Enabled = true end -- Ensure it's enabled
    end

    -- --- BillboardGui (for Text) ---
    local billboard = elements and elements.Billboard
    if not billboard or not billboard.Parent then
        billboard = Instance.new("BillboardGui")
        billboard.Name = "PlayerESP_Billboard"
        billboard.Adornee = targetPart -- Attach text to the root part
        billboard.Size = UDim2.new(0, 150, 0, 50) -- Slightly taller for health
        billboard.StudsOffset = Vector3.new(0, VERTICAL_OFFSET_TEXT, 0)
        billboard.AlwaysOnTop = true -- See through walls
        billboard.MaxDistance = MAX_DISTANCE + 10
        billboard.Enabled = true

        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "InfoLabel"
        textLabel.BackgroundTransparency = 1
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.TextSize = TEXT_SIZE
        textLabel.TextColor3 = TEXT_COLOR
        textLabel.TextStrokeTransparency = 0.5
        textLabel.Text = string.format("%s\n[HP: %d]", player.Name, health) -- Display name and health
        textLabel.Parent = billboard

        billboard.Parent = targetPart -- Parent to the part last

        -- Store/update the reference
        if not elements then elements = {} end -- Should exist from Highlight, but safety check
        elements.Billboard = billboard
        activeEspElements[player] = elements

    elseif billboard.Adornee ~= targetPart then
        -- Re-assign Adornee if character reset
        billboard.Adornee = targetPart
        if billboard.Parent ~= targetPart then billboard.Parent = targetPart end
    end

    -- Update Text Label Content (only if changed)
    local textLabel = billboard and billboard:FindFirstChild("InfoLabel")
    if textLabel then
        local newText = string.format("%s\n[HP: %d]", player.Name, health)
        if textLabel.Text ~= newText then
            textLabel.Text = newText
        end
        if not billboard.Enabled then billboard.Enabled = true end -- Ensure enabled
    end

end

-- Function to clean up ESP elements for players who are no longer valid
local function cleanupEspElements()
    for player, elements in pairs(activeEspElements) do
        local character = player.Character
        local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
        local targetPart = character and character:FindFirstChild("HumanoidRootPart")

        -- Check if player left, character/humanoid/part is gone, or health is 0
        if not player:IsDescendantOf(Players) or not character or not humanoid or humanoid.Health <= 0 or not targetPart or not elements then
            if elements then
                 if elements.Highlight and elements.Highlight.Parent then elements.Highlight:Destroy() end
                 if elements.Billboard and elements.Billboard.Parent then elements.Billboard:Destroy() end
            end
            activeEspElements[player] = nil -- Remove from tracking
        end
    end
end

-- Main loop connected to RenderStepped
local function onRenderStep(deltaTime)
    -- Update ESP for all valid players
    for _, player in ipairs(Players:GetPlayers()) do
        updateOrCreateEsp(player)
    end

    -- Clean up elements for players who became invalid since the last check
    cleanupEspElements()
end

-- Connect the main loop
local connection = RunService.RenderStepped:Connect(onRenderStep)

-- Cleanup when the script is destroyed
script.Destroying:Connect(function()
    if connection then
        connection:Disconnect()
    end
    -- Clean up all remaining ESP elements
    for player, elements in pairs(activeEspElements) do
         if elements then
             if elements.Highlight and elements.Highlight.Parent then elements.Highlight:Destroy() end
             if elements.Billboard and elements.Billboard.Parent then elements.Billboard:Destroy() end
        end
    end
    activeEspElements = {}
    print("[ESP Script] Cleaned up.")
end)

print("[ESP Script] Outline/Health ESP Loaded (Educational Purposes Only).")
