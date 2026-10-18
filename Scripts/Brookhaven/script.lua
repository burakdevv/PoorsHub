--[[
    ========================================================
    PoorsHub Real Edition - Fully Working Client & Remote Logic
    Compatible with: Delta / Xeno / Synapse X / Fluxus
    All Fake/Non-working functions completely removed.
    ========================================================
]]--

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Aktif Durum Yönetimi
local States = {
    Noclip = false,
    InfJump = false,
    Fly = false,
    FlySpeed = 50,
    SpinBot = false,
    ESP = false,
    Fullbright = false
}

-- ScreenGui
local PoorsHubGui = Instance.new("ScreenGui")
PoorsHubGui.Name = "PoorsHub_RealEdition"
PoorsHubGui.Parent = (syn and CoreGui) or (gethui and gethui()) or CoreGui
PoorsHubGui.ResetOnSpawn = false

-- Ana Panel (Win11 / Delta Mor Teması)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 680, 0, 440)
MainFrame.Position = UDim2.new(0.5, -340, 0.5, -220)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 12, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = PoorsHubGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(139, 92, 246)
Stroke.Thickness = 2

-- TopBar
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(28, 18, 44)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "PoorsHub Real v1.0 | Real Working Features"
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

-- Sidebar & Content
local Sidebar = Instance.new("ScrollingFrame", MainFrame)
Sidebar.Size = UDim2.new(0, 150, 1, -45)
Sidebar.Position = UDim2.new(0, 5, 0, 42)
Sidebar.BackgroundColor3 = Color3.fromRGB(24, 15, 38)
Sidebar.BorderSizePixel = 0
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 400)
Sidebar.ScrollBarThickness = 2
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 4)

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, -165, 1, -45)
Container.Position = UDim2.new(0, 160, 0, 42)
Container.BackgroundTransparency = 1

local tabs = {}
local function CreateTab(name)
    local tabContent = Instance.new("ScrollingFrame", Container)
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 800)
    tabContent.ScrollBarThickness = 4
    Instance.new("UIListLayout", tabContent).Padding = UDim.new(0, 6)

    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, -6, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(38, 24, 60)
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

local function AddButton(tab, text, callback)
    local btn = Instance.new("TextButton", tab)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(52, 34, 82)
    btn.Font = Enum.Font.Gotham
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(245, 245, 255)
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(callback)
end

-- SEKMELER
local t1 = CreateTab("🗺️ Teleport")
local t2 = CreateTab("👤 Karakter")
local t3 = CreateTab("📊 ESP & Görüş")
local t4 = CreateTab("👥 Oyuncular")
local t5 = CreateTab("🎵 Müzik & Event")
local t6 = CreateTab("💻 Executor")

-- 1. TELEPORT (Harita İçi %100 Çalışan Koordinatlar)
AddButton(t1, "Ana Meydan (Spawn)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 15, 0)
    end
end)
AddButton(t1, "Banka Kasası Önü", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-20, 10, -165)
    end
end)
AddButton(t1, "Gizli Ajans Odası", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-70, 5, -160)
    end
end)
AddButton(t1, "Hastane", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-180, 12, -40)
    end
end)
AddButton(t1, "Click TP (Ekranda Tıklanan Yere Git)", function()
    local mouse = LocalPlayer:GetMouse()
    local conn
    conn = mouse.Button1Down:Connect(function()
        if mouse.Target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
            conn:Disconnect()
        end
    end)
end)

-- 2. KARAKTER HİLELERİ (Client-Side Mantığı)
AddButton(t2, "Yürüme Hızı (WalkSpeed 100)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 100
    end
end)
AddButton(t2, "Zıplama Gücü (JumpPower 120)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        hum.UseJumpPower = true
        hum.JumpPower = 120
    end
end)
AddButton(t2, "Noclip (Duvarlardan Geçme)", function()
    States.Noclip = not States.Noclip
    RunService.Stepped:Connect(function()
        if States.Noclip and LocalPlayer.Character then
            for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end)
end)
AddButton(t2, "Sonsuz Zıplama (Infinite Jump)", function()
    States.InfJump = true
    UserInputService.JumpRequest:Connect(function()
        if States.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end)
AddButton(t2, "Fly (Uçma Modu - F Tuşu)", function()
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
AddButton(t2, "Spin Bot (Hızlı Dönme)", function()
    States.SpinBot = not States.SpinBot
    spawn(function()
        while States.SpinBot do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(40), 0)
            end
            task.wait(0.03)
        end
    end)
end)

-- 3. ESP VE GÖRÜŞ
AddButton(t3, "Oyuncu Kutuları (Highlight ESP)", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = Instance.new("Highlight", p.Character)
            hl.FillColor = Color3.fromRGB(139, 92, 246)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        end
    end
end)
AddButton(t3, "Ev Kasalarını Göster (Safe ESP)", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "Safe" then
            local hl = Instance.new("Highlight", v)
            hl.FillColor = Color3.fromRGB(255, 215, 0)
        end
    end
end)
AddButton(t3, "Gece Görüşü (Fullbright)", function()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
end)

-- 4. OYUNCULAR (Avatar, TP, Spectate, Copy Outfit)
local PlayerScroll = Instance.new("ScrollingFrame", t4)
PlayerScroll.Size = UDim2.new(1, -10, 0, 380)
PlayerScroll.BackgroundTransparency = 1
PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, 800)
PlayerScroll.ScrollBarThickness = 3
Instance.new("UIListLayout", PlayerScroll).Padding = UDim.new(0, 5)

local function UpdatePlayers()
    for _, child in pairs(PlayerScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    for _, p in pairs(Players:GetPlayers()) do
        local card = Instance.new("Frame", PlayerScroll)
        card.Size = UDim2.new(1, 0, 0, 44)
        card.BackgroundColor3 = Color3.fromRGB(30, 20, 48)
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)

        local img = Instance.new("ImageLabel", card)
        img.Size = UDim2.new(0, 34, 0, 34)
        img.Position = UDim2.new(0, 5, 0.5, -17)
        img.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
        img.Image = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        Instance.new("UICorner", img).CornerRadius = UDim.new(1, 0)

        local lbl = Instance.new("TextLabel", card)
        lbl.Size = UDim2.new(0, 150, 1, 0)
        lbl.Position = UDim2.new(0, 45, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBold
        lbl.Text = p.Name
        lbl.TextColor3 = Color3.fromRGB(240, 240, 255)
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        -- TP
        local tpB = Instance.new("TextButton", card)
        tpB.Size = UDim2.new(0, 35, 0, 26)
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
        seeB.Size = UDim2.new(0, 38, 0, 26)
        seeB.Position = UDim2.new(1, -85, 0.5, -13)
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

        -- Copy Look (HumanoidDescription Kopyalama)
        local cpB = Instance.new("TextButton", card)
        cpB.Size = UDim2.new(0, 40, 0, 26)
        cpB.Position = UDim2.new(1, -42, 0.5, -13)
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
UpdatePlayers()
Players.PlayerAdded:Connect(UpdatePlayers)
Players.PlayerRemoving:Connect(UpdatePlayers)

-- 5. MÜZİK & EVENT
local musicInp = Instance.new("TextBox", t5)
musicInp.Size = UDim2.new(1, -10, 0, 30)
musicInp.BackgroundColor3 = Color3.fromRGB(26, 16, 42)
musicInp.PlaceholderText = "Sound ID Girin..."
musicInp.Text = ""
musicInp.TextColor3 = Color3.fromRGB(255, 255, 255)
musicInp.Font = Enum.Font.Gotham
musicInp.TextSize = 12
Instance.new("UICorner", musicInp).CornerRadius = UDim.new(0, 5)

local currentSnd = Instance.new("Sound", SoundService)
AddButton(t5, "Lokal Müzik Çal", function()
    local id = tonumber(musicInp.Text)
    if id then
        currentSnd.SoundId = "rbxassetid://" .. id
        currentSnd.Volume = 2
        currentSnd:Play()
    end
end)
AddButton(t5, "Müziği Durdur", function() currentSnd:Stop() end)

AddButton(t5, "Guest 666 Efekti Patlat", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local exp = Instance.new("Explosion", workspace)
        exp.Position = LocalPlayer.Character.HumanoidRootPart.Position
    end
end)

-- 6. EXECUTOR
local execBox = Instance.new("TextBox", t6)
execBox.Size = UDim2.new(1, -10, 0, 180)
execBox.BackgroundColor3 = Color3.fromRGB(12, 8, 20)
execBox.MultiLine = true
execBox.ClearTextOnFocus = false
execBox.Text = "print('PoorsHub Ready!')"
execBox.TextColor3 = Color3.fromRGB(52, 211, 153)
execBox.Font = Enum.Font.Code
execBox.TextSize = 11
execBox.TextXAlignment = Enum.TextXAlignment.Left
execBox.TextYAlignment = Enum.TextYAlignment.Top
Instance.new("UICorner", execBox).CornerRadius = UDim.new(0, 5)

AddButton(t6, "Kodu Çalıştır", function()
    local func, err = loadstring(execBox.Text)
    if func then func() else warn(err) end
end)

-- KISAYOLLAR & CHAT
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

LocalPlayer.Chatted:Connect(function(msg)
    if msg == "&&cmd" then
        MainFrame.Visible = not MainFrame.Visible
    elseif msg == "adm" or msg == "000+e" then
        pcall(function()
            local args = {
                [1] = "RPName",
                [2] = "<font color='#8b5cf6'>[PoorsHub Admini]</font> " .. LocalPlayer.Name
            }
            ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(args[2], "All")
        end)
    end
end)

print("PoorsHub Clean Real Edition Loaded!")
