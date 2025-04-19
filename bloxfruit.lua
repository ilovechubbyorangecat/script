-- Roblox GUI Script for Blox Fruits Hub (No Library - Scrollable - No Banana Hub)

-- Ensure the game is loaded and the player exists
if not game:IsLoaded() then
    game.Loaded:Wait()
end
local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Prevent the GUI from being created multiple times
local guiName = "BloxFruitsHubNoLibScrollNB" -- Changed name slightly
if PlayerGui:FindFirstChild(guiName) then
    PlayerGui[guiName]:Destroy()
end

-- === GUI Creation ===

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = guiName
ScreenGui.ResetOnSpawn = false -- Keep GUI open after respawn
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 500) -- Width, Height in pixels
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -250) -- Center the frame
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MainFrame.BorderColor3 = Color3.fromRGB(80, 80, 90)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true -- Allow input processing (for dragging)
MainFrame.Draggable = true -- Make the frame draggable
MainFrame.Selectable = true -- Required for Draggable
MainFrame.Parent = ScreenGui

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 0, 30) -- Full width, 30 pixels height
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
TitleLabel.BorderColor3 = Color3.fromRGB(80, 80, 90)
TitleLabel.BorderSizePixel = 1
TitleLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 18
TitleLabel.Text = "Blox Fruits Script Hub"
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
TitleLabel.Parent = MainFrame

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -28, 0, 3) -- Top right corner
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BorderColor3 = Color3.fromRGB(255, 100, 100)
CloseButton.BorderSizePixel = 1
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 16
CloseButton.Text = "X"
CloseButton.Parent = TitleLabel -- Parent to title bar for positioning ease

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Name = "ScrollingFrame"
ScrollingFrame.Size = UDim2.new(1, -10, 1, -40) -- Adjust size to fit within MainFrame padding (leaving space for title and border)
ScrollingFrame.Position = UDim2.new(0, 5, 0, 35) -- Position below title bar
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ScrollingFrame.BorderColor3 = Color3.fromRGB(80, 80, 90)
ScrollingFrame.BorderSizePixel = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- IMPORTANT: This will be controlled by UIListLayout
ScrollingFrame.ScrollBarThickness = 8
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 110)
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5) -- Spacing between buttons
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center -- Center buttons if ScrollingFrame is wider
UIListLayout.FillDirection = Enum.FillDirection.Vertical -- Stack vertically (default)

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end)


-- === Script Data (Banana Hub Removed) ===
local scripts = {
    {Title = "Maru Blox Fruits", Code = [[
getgenv().Team = "Marines"
loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaCrack/KimP/refs/heads/main/MaruHub"))()
]]},
    {Title = "Quartyz Script - Farm/Level/Stats", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/xQuartyx/QuartyzScript/main/Loader.lua"))()
]]},
    {Title = "Zinner Hub (No Key)", Code = [[
getgenv().Team = "Pirates"
loadstring(game:HttpGet('https://raw.githubusercontent.com/HoangNguyenk8/Scripts/refs/heads/main/Loader.lua'))()
]]},
    {Title = "Monster Hub", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/giahuy2511-coder/MonsterHub/refs/heads/main/MonsterHub"))()
]]},
    {Title = "Mukuro Hub", Code = [[
loadstring(game:HttpGet("https://auth.quartyz.com/scripts/Loader.lua"))()
]]},
    {Title = "Vxeze Hub", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/Skidlamcho.txt"))()
]]},
    {Title = "TheBillDevHub", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/selciawashere/screepts/refs/heads/main/BFKEYSYS",true))()
]]},
    {Title = "Forge Hub", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/Skzuppy/forge-hub/main/loader.lua"))()
]]},
    {Title = "Ronix Hub v2.0.0", Code = [[
loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/b5f968ca22436160479678e830766cc4.lua"))()
]]},
    -- Banana Hub entry removed from here
    {Title = "Lumin Hub", Code = [[
loadstring(game:HttpGet("http://lumin-hub.lol/BloxFruits.lua"))()
]]},
    {Title = "BlueX Hub (No Key)", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-BlueX/BlueX-Hub/refs/heads/main/EN.lua"))()
]]},
    {Title = "Nicuse Hub", Code = [[
loadstring(game:HttpGet("https://nicuse.xyz/MainHub.lua"))()
]]},
    {Title = "Ziner Hub (Tienvn123tkvn)", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/Tienvn123tkvn/Test/main/ZINERHUB.lua"))()
]]},
    {Title = "Solara Hub (PC GUI)", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/zenzon23/new-bf/refs/heads/main/onyx%20f"))()
]]},
    {Title = "Lap Hub", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/Jadelly261/BloxFruits/refs/heads/main/LapHub", true))()
]]},
    {Title = "Master Hub (onepicesenpai)", Code = [[
loadstring(game:HttpGet('https://raw.githubusercontent.com/onepicesenpai/onepicesenpai/main/onichanokaka'))()
]]},
    {Title = "Strawberry Hub (No Key)", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/CheemsNhuChiAl/Sotringhuhu/main/StrawberryHubBeta1.35"))()
]]},
    {Title = "Zis Hub", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaCrack/Zis/refs/heads/main/ZisRobloxHub"))()
]]},
    {Title = "Tinh Linh Hub", Code = [[
repeat wait() until game:IsLoaded()
_G.Team = "Pirates" -- Pirates / Marines
loadstring(game:HttpGet("https://raw.githubusercontent.com/HuyLocDz/Blox-Fruit/main/TinhLinhHub.lua"))()
]]},
    {Title = "Astral Hub 2025", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/Overgustx2/Main/refs/heads/main/BloxFruits_25.html"))()
]]},
    {Title = "DMS Hub", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/king-08/DMSHub/main/dms.lua",true))()
]]},
    {Title = "Mashii Hub", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/Flontium2/Mashii-Hub/refs/heads/main/Main.lua"))()
]]},
    {Title = "Aimbot Pastebin (No Key)", Code = [[
loadstring(game:HttpGet("https://pastebin.com/raw/d5BcMzyC"))()
]]},
    {Title = "Rise Hub (Free)", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/TrashLua/BloxFruits/main/FreeScripts.lua"))()
]]},
    {Title = "Teach Hub (No Key)", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/Scriptztyz/robloxscript/main/Teach_Hub"))()
]]},
    {Title = "Zola Hub (Dec 2024)", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/barlossxi/barlossxi/main/ZO.lua"))()
]]},
    {Title = "Experience Hub", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/Memories0912/Experience-Script/main/Gen2Beta.lua"))()
]]},
    {Title = "Redeem Codes / Farm Mobs", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/SkibidiSupremacy/Loader.xyz/main/Beta.Loader"))()
]]},
    {Title = "Wolf Hub 2025", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/FreeeScripts/FREEHub/main/Loader", true))()
]]},
    {Title = "Auto Kaitun (Includes Config)", Code = [[
getgenv().Hide_UI = true
getgenv().BlackScreen = false
_G.HopFruit1M = false
_G.KaitunConfig = {
    ["Actions Allowed"] = {
      ["Awakening Fruit"] = true,["Shark Anchor"] = true,["Mirror Fractal"] = true,["Soul Guitar"] = true,
      ["Pole (1st Form)"] = true,["Upgrading Race"] = true,["Farming Boss Drop When Maxed Level"] = false,
      ["Rainbown Haki"] = true,["Cursed Dual Katana"] = true,["Buy accessories"] = true,["Buy Hakis"] = true,
      ["Buy Guns"] = true,["Buy Swords"] = true,["Upgrade Weapons"] = true,
      ["Farming Boss Drops When X2 Expired"] = true,["Mirage Puzzle"] = true,["Saber"] = true
    },
    ["Fps Boosting"] = true,["Fruit Snipping"] = true,["Fruit Eating"] = false,["High Ping Hop"] = true,
    ["Fruit Choosen"] = {
      ["T-Rex-T-Rex"] = true,["Shadow-Shadow"] = true,["Mammoth-Mammoth"] = true,["Gravity-Gravity"] = true,
      ["Spirit-Spirit"] = true,["Dark-Dark"] = true,["Rocket-Rocket"] = true,["Control-Control"] = true,
      ["Dough-Dough"] = true,["Leopard-Leopard"] = true,["Venom-Venom"] = true,["Dragon-Dragon"] = true,
      ["Diamond-Diamond"] = true,["Kitsune-Kitsune"] = true,["Spring-Spring"] = true
    },
    ["Player Nearing Hop"] = true,["Allow Stored"] = true,["Race Choosen"] = {["Human"] = true},
    ["Race Snipping"] = true,["Tween Speed"] = 350,["Same Y Tween"] = true,
}
loadstring(game:HttpGet('https://raw.githubusercontent.com/memaybeohub/NewPage/main/Kaitun.lua'))()
]]},
    {Title = "Beni Hub (Super Auto Farm)", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/Jadelly261/BloxFruits/main/BeniHub", true))()
]]},
    {Title = "ORG Hub (Free 2025)", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/ORG-hubb/ORG/main/output.lua"))()
]]},
    {Title = "Mera Hub", Code = [[
loadstring(game:HttpGet('https://raw.githubusercontent.com/Hungtu2121/Mera-Hub-Game/main/MeraHubBloxFruitNew'))()
]]},
    {Title = "Youm Hub", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/Jadelly261/BloxFruits/main/YoumHub", true))()
]]},
    {Title = "AnDepZai Hub", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/AnDepZaiHub/AnDepZaiHubBeta/main/AnDepZaiHubBeta.lua"))()
]]},
    {Title = "Cokka Hub", Code = [[
loadstring(game:HttpGet"https://raw.githubusercontent.com/UserDevEthical/Loadstring/main/CokkaHub.lua")()
]]},
    {Title = "Xero Hub (Includes Config)", Code = [[
getgenv().Team = "Marines" -- Pirates/Marines
getgenv().Fix_Lag = true -- true/false
getgenv().Auto_Execute = false -- true/false
getgenv().Clear_Settings = false -- true/false
loadstring(game:HttpGet("https://raw.githubusercontent.com/verudous/Xero-Hub/main/main.lua"))()
]]},
    {Title = "Ragnarok Hub", Code = [[
loadstring(game:HttpGet('https://raw.githubusercontent.com/Script-Blox/Script/main/Ragnarok.Lua'))()
]]},
    {Title = "Infinite Hub", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/Baokhanh208/Infinite/main/filesrc.lua"))()
]]},
    {Title = "Xeter Hub (No Key)", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaCrack/Loader/main/Xeter.lua"))()
]]},
    {Title = "Kee Hub V2", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/Nghia11n/Kee-Hub/main/keev2.lua"))()
]]},
    {Title = "Auto Bounty (Includes Config)", Code = [[
getgenv().Setting = {
    ["Team"] = "Pirates", ["Chat"] = {""}, ["Skip Race V4"] = true,
    ["Misc"] = {
        ["Enable Lock Bounty"] = false, ["Lock Bounty"] = {0, 300000000}, ["Hide Health"] = {4500,5000},
        ["Lock Camera"] = true, ["Enable Cam Farm"] = false, ["White Screen"] = false, ["FPS Boost"] = false,
        ["Bypass TP"] = true, ["Random & Store Fruit"] = true
    },
    ["Item"] = {
        ["Melee"] = {["Enable"] = true, ["Z"] = {["Enable"] = true, ["Hold Time"] = 1.5}, ["X"] = {["Enable"] = true, ["Hold Time"] = 0.1}, ["C"] = {["Enable"] = true, ["Hold Time"] = 0.1}},
        ["Blox Fruit"] = {["Enable"] = false, ["Z"] = {["Enable"] = true, ["Hold Time"] = 1.5}, ["X"] = {["Enable"] = true, ["Hold Time"] = 0}, ["C"] = {["Enable"] = true, ["Hold Time"] = 0}, ["V"] = {["Enable"] = true, ["Hold Time"] = 0}, ["F"] = {["Enable"] = true, ["Hold Time"] = 0}},
        ["Sword"] = {["Enable"] = true, ["Z"] = {["Enable"] = true, ["Hold Time"] = 0.1}, ["X"] = {["Enable"] = true, ["Hold Time"] = 0.1}},
        ["Gun"] = {["Enable"] = false, ["Z"] = {["Enable"] = true, ["Hold Time"] = 0.1}, ["X"] = {["Enable"] = true, ["Hold Time"] = 0.1}}
    }
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/ItzWindy01/WindyXBypass/main/BountyLoadder.lua"))()
]]},
    {Title = "Spectrum Hub", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/xZPUHigh/Project-Spectrum/main/SpectrumX.lua"))()
]]},
    {Title = "Valk Hub", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/Scriptssz/Folder_Script/main/Valk_Hub"))()
]]},
    {Title = "Sunny Hub", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/hihiae/Sunny/main/SunnyMain"))()
]]},
    {Title = "Quantum Hub", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/Trustmenotcondom/QTONYX/refs/heads/main/QuantumOnyx.lua"))()
]]},
    {Title = "Dominance Hub", Code = [[
loadstring(game:HttpGet('https://raw.githubusercontent.com/Script-Blox/Script/main/Dominance'))()
]]},
    {Title = "Hyper Hub V2", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/2133121233/Hyper_Hub/main/menu.lua"))()
]]},
    {Title = "Pear Cat Hub", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/NguyenLam2504/pearcathub.lua/main/vaicapia.lua"))()
]]},
    {Title = "X-Ray Hub v3.0", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/XRayDerxDOne/Loader/main/XRayMain"))()
]]},
    {Title = "Zuesz Hub", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/KhanhTranVan/Guest/main/thankforbuying"))()
]]},
    {Title = "Rinx Hub V3", Code = [[
loadstring(game:HttpGetAsync"https://github.com/RinXHub/Oowo22./raw/main/output.lua")("RinXHub")
]]},
    {Title = "Grayx Hub (New)", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/mkhoidzvl13/Grayx/main/GrayXLoader.lua"))()
]]},
    {Title = "Strike Hub", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/StormSKz12/StirkeHub1/main/Gameincluded"))()
]]},
    {Title = "Zamex Hub (Mobile)", Code = [[
loadstring(game:HttpGet('https://raw.githubusercontent.com/Sixnumz/ZamexMobile/main/Zamex_Mobile.lua'))()
]]},
    {Title = "Chest Farm (Unknownproootest)", Code = [[
loadstring(game:HttpGet('https://raw.githubusercontent.com/Unknownproootest/Bloxfruit-speedboat/main/ChestFarm'))()
]]},
    {Title = "Fai Fao Hub", Code = [[
loadstring(game:HttpGet"https://raw.githubusercontent.com/PNguyen0199/Script/main/Fai-Fao-Ver2.lua")()
]]},
    {Title = "NEVAHUB", Code = [[
loadstring(game:HttpGet("https://pastebin.com/raw/XFTUAe56"))();
]]},
    {Title = "MTriet Hub", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/Minhtriettt/Free-Script/main/MTriet-Hub.lua"))()
]]},
    {Title = "OMG Hub", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua"))()
]]},
    {Title = "Radon Hub", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/x2-Neptune/RadonHub/main/Script.lua"))()
]]},
    {Title = "REDz Hub", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/BloxFruits/main/redz9999"))()
]]},
    {Title = "Alchemy Hub (2025 Updated)", Code = [[
loadstring(game:HttpGet("https://scripts.alchemyhub.xyz"))()
]]},
    {Title = "Annie Hub", Code = [[
loadstring(game:HttpGet('https://raw.githubusercontent.com/1st-Mars/Annie/main/1st.lua'))()
]]},
    {Title = "Zekram Hub X", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/ahmadsgamer2/Zekrom-Hub-X/main/Blox-Fruit.lua"))()
]]},
    {Title = "ZenHub", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/Zenhubtop/zenhubnextgen/main/Loader", true))()
]]},
    {Title = "Race V4 Update (EgoLoaderMain)", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/SuperIkka/Main/main/EgoLoaderMain", true))()
]]},
    {Title = "Zaque Kaitun Script", Code = [[
loadstring(game:HttpGet('https://raw.githubusercontent.com/ZaqueHub/BloxFruitPC/05507b61c0092197a3b6233ca305f2dfacd20050/KaitunZaque.lua'))()
]]},
    {Title = "Zamex Hub (PC)", Code = [[
loadstring(game:HttpGet('https://raw.githubusercontent.com/Sixnumz/ZamexHub/main/Zamex_PC.lua'))()
]]},
    {Title = "Atomic Hub (Race V4/Auto Farm)", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/ArceusXHub/atomic-hub/main/atomic-hub"))()
]]},
    {Title = "KimaHub (2025)", Code = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/malfume/KimaHub/main/KimaHub",true))();
]]},
    {Title = "Auto Farm Level (Script Game)", Code = [[
loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ahmadsgamer2/Script--Game/main/Script%20Game"))()
]]},
    -- Add more scripts here following the same format
}

-- === Create Buttons ===
for i, scriptInfo in ipairs(scripts) do
    local Button = Instance.new("TextButton")
    Button.Name = "ScriptButton_" .. i
    Button.LayoutOrder = i -- Ensure order matches the table
    Button.Size = UDim2.new(1, -10, 0, 30) -- Slightly less than full width to prevent touching scrollbar, 30 pixels high
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    Button.BorderColor3 = Color3.fromRGB(90, 90, 105)
    Button.BorderSizePixel = 1
    Button.TextColor3 = Color3.fromRGB(210, 210, 210)
    Button.Font = Enum.Font.SourceSans
    Button.TextSize = 14
    Button.Text = scriptInfo.Title
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.TextWrapped = true -- Wrap text if button is too narrow (unlikely here)
    Button.Parent = ScrollingFrame

    -- Add padding to the text
    local TextPadding = Instance.new("UIPadding")
    TextPadding.PaddingLeft = UDim.new(0, 10)
    TextPadding.Parent = Button

    -- Hover effect (optional)
    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(75, 75, 90)
    end)
    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    end)

    -- Click action
    Button.MouseButton1Click:Connect(function()
        print("[Script Hub] Attempting to execute: " .. scriptInfo.Title)
        -- Execute the script code safely
        local success, err = pcall(function()
            loadstring(scriptInfo.Code)()
        end)

        if success then
            print("[Script Hub] Successfully executed: " .. scriptInfo.Title)
        else
            warn("[Script Hub] FAILED to execute: " .. scriptInfo.Title .. " | Error: " .. tostring(err))
            -- Optionally show an error message GUI element
        end
    end)
end

-- Parent the ScreenGui to PlayerGui last to ensure all elements are loaded
ScreenGui.Parent = PlayerGui -- Or use CoreGui if preferred: game:GetService("CoreGui")

print("[Script Hub] Scrollable GUI Loaded (No Library, No Banana Hub).")

-- Cleanup function (optional, useful if you want to re-run the script)
local function cleanup()
    if PlayerGui:FindFirstChild(guiName) then
        PlayerGui[guiName]:Destroy()
    end
end
-- You can call cleanup() if needed, e.g., before re-executing this main script.
