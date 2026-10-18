--[[
    ========================================================
    PoorsHub Prison Life v1.0 - Ultimate Edition
    Features: Gun Giver + Team Switch + Anti-Arrest + Bang + Search
    Target: Delta / Xeno / Synapse X / Fluxus
    ========================================================
]]--

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

-- Durum Hafızası
local States = {
    Noclip = false,
    InfJump = false,
    Fly = false,
    FlySpeed = 60,
    AntiArrest = false,
    BangLoop = nil,
    BangTarget = nil,
    BangAnim = nil
}

-- ScreenGui
local PoorsHubGui = Instance.new("ScreenGui")
PoorsHubGui.Name = "PoorsHub_PrisonLife"
PoorsHubGui.Parent = (syn and CoreGui) or (gethui and gethui()) or CoreGui
PoorsHubGui.ResetOnSpawn = false

-- Ana Çerçeve (Modern Mor/Koyu Tema)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 720, 0, 470)
MainFrame.Position = UDim2.new(0.5, -360, 0.5, -235)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = PoorsHubGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(139, 92, 246)
MainStroke.Thickness = 2

-- Üst Bar
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(24, 15, 38)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 400, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "/SYSTEMBROKEN/ - PoorsHub Prison Life"
Title.TextColor3 = Color3.fromRGB(235, 225, 255)
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(225, 29, 72)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() PoorsHubGui:Destroy() end)

-- Sol Sidebar
local Sidebar = Instance.new("ScrollingFrame", MainFrame)
Sidebar.Size = UDim2.new(0, 150, 1, -45)
Sidebar.Position = UDim2.new(0, 5, 0, 42)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 12, 32)
Sidebar.BorderSizePixel = 0
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 300)
Sidebar.ScrollBarThickness = 2
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 4)

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, -165, 1, -45)
Container.Position = UDim2.new(0, 160, 0, 42)
Container.BackgroundTransparency = 1

local tabs = {}
local function CreateTab(name)
    local tabContent = Instance.new("Frame", Container)
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false

    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, -6, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(33, 21, 54)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(220, 210, 245)
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do t.Visible = false end
        tabContent.Visible = true
    end)

    table.insert(tabs, tabContent)
    if #tabs == 1 then tabContent.Visible = true end
    return tabContent
end

local tAll = CreateTab("🔍 TÜMÜ & ARAMA")
local tPlayers = CreateTab("👥 OYUNCULAR")
local tExec = CreateTab("💻 EXECUTOR")

-- =========================================================
-- 🔥 BANG SİSTEMİ
-- =========================================================
local function StopBang()
    if States.BangLoop then States.BangLoop:Disconnect(); States.BangLoop = nil end
    if States.BangAnim then States.BangAnim:Stop(); States.BangAnim = nil end
    States.BangTarget = nil
end

local function StartBang(targetPlayer)
    StopBang()
    if not targetPlayer or not targetPlayer.Character then return end
    States.BangTarget = targetPlayer
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChildOfClass("Humanoid") then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://148840371"
    pcall(function()
        States.BangAnim = hum:LoadAnimation(anim)
        States.BangAnim:Play(0.1, 1, 3.5)
    end)
    States.BangLoop = RunService.RenderStepped:Connect(function()
        if States.BangTarget and States.BangTarget.Character and States.BangTarget.Character:FindFirstChild("HumanoidRootPart") and char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = States.BangTarget.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.1)
        else
            StopBang()
        end
    end)
end

-- =========================================================
-- 🔍 ARAMA ÇUBUĞU VE PRISON LIFE ÖZELLİKLERİ
-- =========================================================
local SearchBox = Instance.new("TextBox", tAll)
SearchBox.Size = UDim2.new(1, -10, 0, 32)
SearchBox.Position = UDim2.new(0, 0, 0, 0)
SearchBox.BackgroundColor3 = Color3.fromRGB(24, 15, 38)
SearchBox.PlaceholderText = "🔎 Prison Life Ara (Gun, Team, Teleport, ESP)..."
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 11
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 6)

local ActionScroll = Instance.new("ScrollingFrame", tAll)
ActionScroll.Size = UDim2.new(1, -10, 1, -38)
ActionScroll.Position = UDim2.new(0, 0, 0, 38)
ActionScroll.BackgroundTransparency = 1
ActionScroll.CanvasSize = UDim2.new(0, 0, 0, 1200)
ActionScroll.ScrollBarThickness = 4
Instance.new("UIListLayout", ActionScroll).Padding = UDim.new(0, 5)

local allButtons = {}
local function AddActionButton(name, callback)
    local btn = Instance.new("TextButton", ActionScroll)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(42, 26, 68)
    btn.Font = Enum.Font.Gotham
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(245, 245, 255)
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(callback)
    table.insert(allButtons, {Frame = btn, Text = name:lower()})
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local query = SearchBox.Text:lower()
    for _, item in pairs(allButtons) do
        item.Frame.Visible = (query == "" or string.find(item.Text, query))
    end
end)

-- PRISON LIFE FONKSİYONLARI
AddActionButton("1. Tüm Silahları Al (M4A1, Rem870, AK-47)", function()
    pcall(function()
        local Inv = Workspace:FindFirstChild("Prison_ITEMS") and Workspace.Prison_ITEMS.giver
        if Inv then
            for _, v in pairs(Inv:GetChildren()) do
                if v:FindFirstChild("ITEMPICKUP") then
                    local oldPos = LocalPlayer.Character.HumanoidRootPart.CFrame
                    LocalPlayer.Character.HumanoidRootPart.CFrame = v.ITEMPICKUP.CFrame
                    task.wait(0.2)
                    LocalPlayer.Character.HumanoidRootPart.CFrame = oldPos
                end
            end
        end
    end)
end)

AddActionButton("2. Takım Değiştir: Mahkum (Inmates)", function()
    pcall(function()
        local A_1 = "Inmates"
        Workspace.Remote.TeamEvent:FireServer(A_1)
    end)
end)

AddActionButton("3. Takım Değiştir: Polis (Guards)", function()
    pcall(function()
        local A_1 = "Guards"
        Workspace.Remote.TeamEvent:FireServer(A_1)
    end)
end)

AddActionButton("4. Takım Değiştir: Suçlu (Criminals)", function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local oldPos = LocalPlayer.Character.HumanoidRootPart.CFrame
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(940, 100, 2390) -- Gizli Suçlu Üssü Yeri
            task.wait(0.5)
            LocalPlayer.Character.HumanoidRootPart.CFrame = oldPos
        end
    end)
end)

AddActionButton("5. Tarafsız Ol (Neutral)", function()
    pcall(function()
        Workspace.Remote.TeamEvent:FireServer("Medium")
    end)
end)

AddActionButton("6. Hapishane Avlusu (Yard) Işınlan", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(789, 98, 2480)
    end
end)

AddActionButton("7. Hapishane Kafeterya Işınlan", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(903, 100, 2250)
    end
end)

AddActionButton("8. Gizli Suçlu Üssü (Criminal Base) Işınlan", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(940, 100, 2390)
    end
end)

AddActionButton("9. Yürüme Hızı (WalkSpeed 100)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 100
    end
end)

AddActionButton("10. Zıplama Gücü (JumpPower 120)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        hum.UseJumpPower = true
        hum.JumpPower = 120
    end
end)

AddActionButton("11. Noclip (Duvarlardan Geçme)", function()
    States.Noclip = not States.Noclip
    RunService.Stepped:Connect(function()
        if States.Noclip and LocalPlayer.Character then
            for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end)
end)

AddActionButton("12. Fly (Uçma Modu - F Tuşu)", function()
    States.Fly = not States.Fly
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    if States.Fly then
        local bv = Instance.new("BodyVelocity", char.HumanoidRootPart)
        bv.Name = "PoorsFlyBV"
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        local bg = Instance.new("BodyGyro", char.HumanoidRootPart)
        bg.Name = "PoorsFlyBG"
        bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        spawn(function()
            while States.Fly and char and char:FindFirstChild("HumanoidRootPart") do
                bg.CFrame = workspace.CurrentCamera.CFrame
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * States.FlySpeed
                task.wait()
            end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end)
    end
end)

AddActionButton("13. Oyuncu ESP (Highlight)", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChildOfClass("Highlight") then
            local hl = Instance.new("Highlight", p.Character)
            hl.FillColor = Color3.fromRGB(139, 92, 246)
        end
    end
end)

-- =========================================================
-- 👥 OYUNCULAR LİSTESİ
-- =========================================================
local PlayerScroll = Instance.new("ScrollingFrame", tPlayers)
PlayerScroll.Size = UDim2.new(1, 0, 1, 0)
PlayerScroll.BackgroundTransparency = 1
PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, 800)
PlayerScroll.ScrollBarThickness = 3
Instance.new("UIListLayout", PlayerScroll).Padding = UDim.new(0, 5)

local function UpdatePlayerList()
    for _, child in pairs(PlayerScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local card = Instance.new("Frame", PlayerScroll)
            card.Size = UDim2.new(1, 0, 0, 44)
            card.BackgroundColor3 = Color3.fromRGB(28, 18, 44)
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)

            local img = Instance.new("ImageLabel", card)
            img.Size = UDim2.new(0, 34, 0, 34)
            img.Position = UDim2.new(0, 5, 0.5, -17)
            img.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
            img.Image = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
            Instance.new("UICorner", img).CornerRadius = UDim.new(1, 0)

            local lbl = Instance.new("TextLabel", card)
            lbl.Size = UDim2.new(0, 120, 1, 0)
            lbl.Position = UDim2.new(0, 45, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.GothamBold
            lbl.Text = p.Name
            lbl.TextColor3 = Color3.fromRGB(240, 240, 255)
            lbl.TextSize = 11
            lbl.TextXAlignment = Enum.TextXAlignment.Left

            -- BANG
            local bangB = Instance.new("TextButton", card)
            bangB.Size = UDim2.new(0, 42, 0, 26)
            bangB.Position = UDim2.new(1, -175, 0.5, -13)
            bangB.BackgroundColor3 = Color3.fromRGB(225, 29, 72)
            bangB.Text = "Bang"
            bangB.Font = Enum.Font.GothamBold
            bangB.TextColor3 = Color3.fromRGB(255, 255, 255)
            bangB.TextSize = 10
            Instance.new("UICorner", bangB).CornerRadius = UDim.new(0, 4)
            bangB.MouseButton1Click:Connect(function() StartBang(p) end)

            -- TP
            local tpB = Instance.new("TextButton", card)
            tpB.Size = UDim2.new(0, 32, 0, 26)
            tpB.Position = UDim2.new(1, -125, 0.5, -13)
            tpB.BackgroundColor3 = Color3.fromRGB(124, 58, 237)
            tpB.Text = "TP"
            tpB.Font = Enum.Font.GothamBold
            tpB.TextColor3 = Color3.fromRGB(255, 255, 255)
            tpB.TextSize = 10
            Instance.new("UICorner", tpB).CornerRadius = UDim.new(0, 4)
            tpB.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                end
            end)

            -- See
            local seeB = Instance.new("TextButton", card)
            seeB.Size = UDim2.new(0, 35, 0, 26)
            seeB.Position = UDim2.new(1, -88, 0.5, -13)
            seeB.BackgroundColor3 = Color3.fromRGB(88, 28, 135)
            seeB.Text = "See"
            seeB.Font = Enum.Font.GothamBold
            seeB.TextColor3 = Color3.fromRGB(255, 255, 255)
            seeB.TextSize = 10
            Instance.new("UICorner", seeB).CornerRadius = UDim.new(0, 4)
            seeB.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
                    workspace.CurrentCamera.CameraSubject = p.Character:FindFirstChildOfClass("Humanoid")
                end
            end)

            -- Copy
            local cpB = Instance.new("TextButton", card)
            cpB.Size = UDim2.new(0, 38, 0, 26)
            cpB.Position = UDim2.new(1, -48, 0.5, -13)
            cpB.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
            cpB.Text = "Copy"
            cpB.Font = Enum.Font.GothamBold
            cpB.TextColor3 = Color3.fromRGB(255, 255, 255)
            cpB.TextSize = 10
            Instance.new("UICorner", cpB).CornerRadius = UDim.new(0, 4)
            cpB.MouseButton1Click:Connect(function()
                if p.Character and LocalPlayer.Character then
                    local desc = p.Character:FindFirstChildOfClass("Humanoid"):GetAppliedDescription()
                    LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ApplyDescription(desc)
                end
            end)
        end
    end
end
UpdatePlayerList()
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)

-- =========================================================
-- 💻 EXECUTOR
-- =========================================================
local execBox = Instance.new("TextBox", tExec)
execBox.Size = UDim2.new(1, 0, 0, 200)
execBox.BackgroundColor3 = Color3.fromRGB(10, 6, 18)
execBox.MultiLine = true
execBox.ClearTextOnFocus = false
execBox.Text = "print('PoorsHub Prison Life Ready!')"
execBox.TextColor3 = Color3.fromRGB(52, 211, 153)
execBox.Font = Enum.Font.Code
execBox.TextSize = 11
execBox.TextXAlignment = Enum.TextXAlignment.Left
execBox.TextYAlignment = Enum.TextYAlignment.Top
Instance.new("UICorner", execBox).CornerRadius = UDim.new(0, 5)

local execBtn = Instance.new("TextButton", tExec)
execBtn.Size = UDim2.new(1, 0, 0, 32)
execBtn.Position = UDim2.new(0, 0, 0, 210)
execBtn.BackgroundColor3 = Color3.fromRGB(124, 58, 237)
execBtn.Text = "Kodu Çalıştır (Execute)"
execBtn.Font = Enum.Font.GothamBold
execBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
execBtn.TextSize = 12
Instance.new("UICorner", execBtn).CornerRadius = UDim.new(0, 5)
execBtn.MouseButton1Click:Connect(function()
    local func, err = loadstring(execBox.Text)
    if func then func() else warn(err) end
end)

-- =========================================================
-- 💬 CHAT KOMUTLARI (@ KOMUTLARI & BANG)
-- =========================================================
local function FindPlayerByPartialName(name)
    local targetName = name:gsub("@", ""):lower()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name:lower():sub(1, #targetName) == targetName or p.DisplayName:lower():sub(1, #targetName) == targetName then
            return p
        end
    end
    return nil
end

LocalPlayer.Chatted:Connect(function(msg)
    local args = string.split(msg, " ")
    if msg == "&&cmd" then
        MainFrame.Visible = not MainFrame.Visible
    elseif msg == "unbang" then
        StopBang()
    elseif args[1] == "bang" and args[2] then
        local target = FindPlayerByPartialName(args[2])
        if target then StartBang(target) end
    elseif args[1] == "goto" and args[2] then
        local target = FindPlayerByPartialName(args[2])
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
        end
    elseif args[1] == "see" and args[2] then
        local target = FindPlayerByPartialName(args[2])
        if target and target.Character and target.Character:FindFirstChild("Humanoid") then
            workspace.CurrentCamera.CameraSubject = target.Character:FindFirstChild("Humanoid")
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("PoorsHub Prison Life Edition Loaded Successfully!")
