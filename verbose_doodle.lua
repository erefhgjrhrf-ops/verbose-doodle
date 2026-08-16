local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- لابردنی مێنوی کۆن ئەگەر هەبێت
if playerGui:FindFirstChild("DgzHubGUI") then
    playerGui.DgzHubGUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DgzHubGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

-- مێنوی سەرەکی (دیزاینی مۆدێرن و سەرنجڕاکێشی سور)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 450)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(160, 30, 30)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- ناونیشان (Title Bar)
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local FixBar = Instance.new("Frame")
FixBar.Size = UDim2.new(1, 0, 0, 12)
FixBar.Position = UDim2.new(0, 0, 1, -12)
FixBar.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
FixBar.BorderSizePixel = 0
FixBar.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -45, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 80, 80)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Text = "Dgz Hub"
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- دوگمەی بچووککردنەوە (-)
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 32, 0, 32)
MinBtn.Position = UDim2.new(1, -38, 0.5, -16)
MinBtn.BackgroundTransparency = 1
MinBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
MinBtn.TextSize = 18
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "-"
MinBtn.Parent = TitleBar

local isOpen = true
MinBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    for _, child in ipairs(MainFrame:GetChildren()) do
        if child ~= TitleBar and child ~= UIStroke and child ~= UICorner then
            child.Visible = isOpen
        end
    end
    if isOpen then
        MainFrame.Size = UDim2.new(0, 280, 0, 450)
    else
        MainFrame.Size = UDim2.new(0, 280, 0, 45)
    end
end)

-- فەنکشنی دروستکردنی دوگمەکان بە دیزاینی نایاب
local function createToggle(name, yPos, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -24, 0, 42)
    button.Position = UDim2.new(0, 12, 0, yPos)
    button.BackgroundColor3 = Color3.fromRGB(140, 25, 25)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 13
    button.Font = Enum.Font.GothamBold
    button.Text = name .. " [Off]"
    button.Parent = MainFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = button

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(180, 40, 40)
    btnStroke.Thickness = 1
    btnStroke.Parent = button

    local active = false
    button.MouseButton1Click:Connect(function()
        active = not active
        if active then
            button.Text = name .. " [On]"
            button.BackgroundColor3 = Color3.fromRGB(35, 150, 80)
            btnStroke.Color = Color3.fromRGB(50, 200, 100)
        else
            button.Text = name .. " [Off]"
            button.BackgroundColor3 = Color3.fromRGB(140, 25, 25)
            btnStroke.Color = Color3.fromRGB(180, 40, 40)
        end
        callback(active)
    end)
end

-- ١. Infinite Jump
local infJumpEnabled = false
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled then
        local character = player.Character
        if character and character:FindFirstChildOfClass("Humanoid") then
            character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)
createToggle("Infinite Jump", 55, function(state) infJumpEnabled = state end)

-- ٢. NoClip
local noclipEnabled = false
RunService.Stepped:Connect(function()
    if noclipEnabled then
        local character = player.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)
createToggle("NoClip", 102, function(state) noclipEnabled = state end)

-- ٣. Big Character
createToggle("Big Character", 149, function(state)
    local character = player.Character
    if character then
        pcall(function()
            if state then character:ScaleTo(3.5) else character:ScaleTo(1.0) end
        end)
    end
end)

-- ✨ ٤. Clone Player Full Character ✨
-- Label for TextBox
local CloneLabel = Instance.new("TextLabel")
CloneLabel.Size = UDim2.new(1, -24, 0, 25)
CloneLabel.Position = UDim2.new(0, 12, 0, 196)
CloneLabel.BackgroundTransparency = 1
CloneLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CloneLabel.TextSize = 12
CloneLabel.Font = Enum.Font.GothamBold
CloneLabel.Text = "Enter Username:"
CloneLabel.TextXAlignment = Enum.TextXAlignment.Left
CloneLabel.Parent = MainFrame

-- TextBox for player username
local CloneTextBox = Instance.new("TextBox")
CloneTextBox.Size = UDim2.new(1, -24, 0, 35)
CloneTextBox.Position = UDim2.new(0, 12, 0, 221)
CloneTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
CloneTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
CloneTextBox.TextSize = 13
CloneTextBox.Font = Enum.Font.Gotham
CloneTextBox.PlaceholderText = "Username here..."
CloneTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
CloneTextBox.Parent = MainFrame

local TextBoxCorner = Instance.new("UICorner")
TextBoxCorner.CornerRadius = UDim.new(0, 8)
TextBoxCorner.Parent = CloneTextBox

local TextBoxStroke = Instance.new("UIStroke")
TextBoxStroke.Color = Color3.fromRGB(160, 30, 30)
TextBoxStroke.Thickness = 1
TextBoxStroke.Parent = CloneTextBox

-- Clone Player Button
local ClonePlayerBtn = Instance.new("TextButton")
ClonePlayerBtn.Size = UDim2.new(1, -24, 0, 42)
ClonePlayerBtn.Position = UDim2.new(0, 12, 0, 256)
ClonePlayerBtn.BackgroundColor3 = Color3.fromRGB(140, 25, 25)
ClonePlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClonePlayerBtn.TextSize = 13
ClonePlayerBtn.Font = Enum.Font.GothamBold
ClonePlayerBtn.Text = "Clone Player [Off]"
ClonePlayerBtn.Parent = MainFrame

local CloneCorner = Instance.new("UICorner")
CloneCorner.CornerRadius = UDim.new(0, 8)
CloneCorner.Parent = ClonePlayerBtn

local CloneStroke = Instance.new("UIStroke")
CloneStroke.Color = Color3.fromRGB(180, 40, 40)
CloneStroke.Thickness = 1
CloneStroke.Parent = ClonePlayerBtn

local cloneEnabled = false

function ClonePlayerFullCharacter(username)
    local targetPlayer = Players:FindFirstChild(username)
    if not targetPlayer or not targetPlayer.Character then
        return false
    end
    
    local targetChar = targetPlayer.Character
    local myChar = player.Character
    
    if not myChar then
        return false
    end
    
    pcall(function()
        -- کۆپی کردنی تێدابووی کۆمەل
        for _, bodyPart in ipairs(targetChar:GetDescendants()) do
            if bodyPart:IsA("BasePart") then
                local myPart = myChar:FindFirstChild(bodyPart.Name)
                if myPart then
                    -- کۆپی کردنی رەنگ
                    pcall(function()
                        myPart.Color = bodyPart.Color
                    end)
                    
                    -- کۆپی کردنی Material
                    pcall(function()
                        myPart.Material = bodyPart.Material
                    end)
                    
                    -- کۆپی کردنی Texture
                    pcall(function()
                        for _, decal in ipairs(bodyPart:GetChildren()) do
                            if decal:IsA("Decal") then
                                local newDecal = decal:Clone()
                                newDecal.Parent = myPart
                            end
                        end
                    end)
                end
            elseif bodyPart:IsA("Accessory") then
                -- کۆپی کردنی ئەکسێسۆریز
                local newAccessory = bodyPart:Clone()
                newAccessory.Parent = myChar
            end
        end
    end)
    
    return true
end

ClonePlayerBtn.MouseButton1Click:Connect(function()
    cloneEnabled = not cloneEnabled
    if cloneEnabled then
        local username = CloneTextBox.Text
        if username == "" or username == nil then
            ClonePlayerBtn.Text = "Enter Username!"
            ClonePlayerBtn.BackgroundColor3 = Color3.fromRGB(170, 50, 50)
            task.wait(1.5)
            ClonePlayerBtn.Text = "Clone Player [Off]"
            ClonePlayerBtn.BackgroundColor3 = Color3.fromRGB(140, 25, 25)
            cloneEnabled = false
            return
        end
        
        if ClonePlayerFullCharacter(username) then
            ClonePlayerBtn.Text = "Player Cloned!"
            ClonePlayerBtn.BackgroundColor3 = Color3.fromRGB(35, 150, 80)
            CloneStroke.Color = Color3.fromRGB(50, 200, 100)
            task.wait(1.5)
            ClonePlayerBtn.Text = "Clone Player [On]"
            ClonePlayerBtn.BackgroundColor3 = Color3.fromRGB(35, 150, 80)
            CloneStroke.Color = Color3.fromRGB(50, 200, 100)
        else
            ClonePlayerBtn.Text = "User Not Found!"
            ClonePlayerBtn.BackgroundColor3 = Color3.fromRGB(170, 50, 50)
            task.wait(1.5)
            ClonePlayerBtn.Text = "Clone Player [Off]"
            ClonePlayerBtn.BackgroundColor3 = Color3.fromRGB(140, 25, 25)
            cloneEnabled = false
        end
    else
        ClonePlayerBtn.Text = "Clone Player [Off]"
        ClonePlayerBtn.BackgroundColor3 = Color3.fromRGB(140, 25, 25)
        CloneStroke.Color = Color3.fromRGB(180, 40, 40)
    end
end)

-- ٥. Save Checkpoint Button
local savedCFrame = nil
local SaveCPBtn = Instance.new("TextButton")
SaveCPBtn.Size = UDim2.new(1, -24, 0, 42)
SaveCPBtn.Position = UDim2.new(0, 12, 0, 303)
SaveCPBtn.BackgroundColor3 = Color3.fromRGB(140, 25, 25)
SaveCPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveCPBtn.TextSize = 13
SaveCPBtn.Font = Enum.Font.GothamBold
SaveCPBtn.Text = "Save Checkpoint"
SaveCPBtn.Parent = MainFrame

local SaveCPCorner = Instance.new("UICorner")
SaveCPCorner.CornerRadius = UDim.new(0, 8)
SaveCPCorner.Parent = SaveCPBtn

local SaveCPStroke = Instance.new("UIStroke")
SaveCPStroke.Color = Color3.fromRGB(180, 40, 40)
SaveCPStroke.Thickness = 1
SaveCPStroke.Parent = SaveCPBtn

SaveCPBtn.MouseButton1Click:Connect(function()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        savedCFrame = character.HumanoidRootPart.CFrame
        SaveCPBtn.Text = "Checkpoint Saved!"
        SaveCPBtn.BackgroundColor3 = Color3.fromRGB(35, 150, 80)
        SaveCPStroke.Color = Color3.fromRGB(50, 200, 100)
        task.wait(1.5)
        SaveCPBtn.Text = "Save Checkpoint"
        SaveCPBtn.BackgroundColor3 = Color3.fromRGB(140, 25, 25)
        SaveCPStroke.Color = Color3.fromRGB(180, 40, 40)
    end
end)

-- ٦. Teleport to Checkpoint Button
local TPCPBtn = Instance.new("TextButton")
TPCPBtn.Size = UDim2.new(1, -24, 0, 42)
TPCPBtn.Position = UDim2.new(0, 12, 0, 350)
TPCPBtn.BackgroundColor3 = Color3.fromRGB(140, 25, 25)
TPCPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TPCPBtn.TextSize = 13
TPCPBtn.Font = Enum.Font.GothamBold
TPCPBtn.Text = "Teleport to Checkpoint"
TPCPBtn.Parent = MainFrame

local TPCPCorner = Instance.new("UICorner")
TPCPCorner.CornerRadius = UDim.new(0, 8)
TPCPCorner.Parent = TPCPBtn

local TPCPStroke = Instance.new("UIStroke")
TPCPStroke.Color = Color3.fromRGB(180, 40, 40)
TPCPStroke.Thickness = 1
TPCPStroke.Parent = TPCPBtn

TPCPBtn.MouseButton1Click:Connect(function()
    if savedCFrame then
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = savedCFrame
            TPCPBtn.Text = "Teleported!"
            TPCPBtn.BackgroundColor3 = Color3.fromRGB(35, 150, 80)
            TPCPStroke.Color = Color3.fromRGB(50, 200, 100)
            task.wait(1.5)
            TPCPBtn.Text = "Teleport to Checkpoint"
            TPCPBtn.BackgroundColor3 = Color3.fromRGB(140, 25, 25)
            TPCPStroke.Color = Color3.fromRGB(180, 40, 40)
        end
    else
        TPCPBtn.Text = "No Checkpoint!"
        TPCPBtn.BackgroundColor3 = Color3.fromRGB(170, 50, 50)
        TPCPStroke.Color = Color3.fromRGB(220, 70, 70)
        task.wait(1.5)
        TPCPBtn.Text = "Teleport to Checkpoint"
        TPCPBtn.BackgroundColor3 = Color3.fromRGB(140, 25, 25)
        TPCPStroke.Color = Color3.fromRGB(180, 40, 40)
    end
end)

-- ٧. TikTok Link Button
local TikTokBtn = Instance.new("TextButton")
TikTokBtn.Size = UDim2.new(1, -24, 0, 42)
TikTokBtn.Position = UDim2.new(0, 12, 0, 397)
TikTokBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
TikTokBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
TikTokBtn.TextSize = 13
TikTokBtn.Font = Enum.Font.GothamBold
TikTokBtn.Text = "TikTok: @e68a4"
TikTokBtn.Parent = MainFrame

local TikTokCorner = Instance.new("UICorner")
TikTokCorner.CornerRadius = UDim.new(0, 8)
TikTokCorner.Parent = TikTokBtn

local TikTokStroke = Instance.new("UIStroke")
TikTokStroke.Color = Color3.fromRGB(160, 30, 30)
TikTokStroke.Thickness = 1
TikTokStroke.Parent = TikTokBtn

TikTokBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then
            setclipboard("https://www.tiktok.com/@e68a4")
            TikTokBtn.Text = "Copied!"
            task.wait(1.5)
            TikTokBtn.Text = "TikTok: @e68a4"
        end
    end)
end)

-- دوگمەی مەلەوان بۆ نیشاندان و شاردنەوەی مێنوی سەرەکی
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -25)
ToggleButton.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
ToggleButton.TextColor3 = Color3.fromRGB(255, 80, 80)
ToggleButton.TextSize = 20
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "D"
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(160, 30, 30)
ToggleStroke.Thickness = 2
ToggleStroke.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
