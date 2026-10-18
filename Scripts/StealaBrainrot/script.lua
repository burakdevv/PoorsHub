--[[
    ========================================================
    PoorsHub - Steal a Brainrot Edition (Ultra Clean & Working)
    Target: Delta / Xeno / Synapse X / Fluxus
    ========================================================
]]--

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Durum Hafızası
local States = {
    Noclip = false,
    InfJump = false,
    Fly = false,
    FlySpeed = 100,
    WalkSpeed = 100,
    BangLoop = nil,
    BangTarget = nil,
    BangAnim = nil
}

-- ScreenGui
local PoorsHubGui = Instance.new("ScreenGui")
PoorsHubGui.Name = "PoorsHub_BrainrotSteal"
PoorsHubGui.Parent = (syn and CoreGui) or (gethui and gethui()) or CoreGui
PoorsHubGui.ResetOnSpawn = false

-- Ana Çerçeve (Mor/Neon Brainrot Teması)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 720, 0, 470)
MainFrame.Position = UDim2.new(0.5, -360, 0.5, -235)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 10, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = PoorsHubGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(168, 85, 247)
MainStroke.Thickness = 2

-- Üst Bar
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(28, 15, 48)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 450, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "🧠 Steal a Brainrot | PoorsHub Ultra Mod"
Title.TextColor3 = Color3.fromRGB(216, 180, 254)
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
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 12, 38)
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
    btn.BackgroundColor3 = Color3.fromRGB(45, 24, 75)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(230, 210, 255)
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

local tAll = CreateTab("🔥 TÜMÜ (HİLELER)")
local tPlayers = CreateTab("👥 OYUNCULAR")
local tExec = CreateTab("💻 EXECUTOR")

-- =========================================================
-- 🔥 BANG SİSTEMİ (TROLL)
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
        States.BangAnim:Play(0.1, 1, 4.0)
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
-- 🔍 ARAMA ÇUBUĞU VE ÖZELLİKLER
-- =========================================================
local SearchBox = Instance.new("TextBox", tAll)
SearchBox.Size = UDim2.new(1, -10, 0, 32)
SearchBox.Position = UDim2.new(0, 0, 0, 0)
SearchBox.BackgroundColor3 = Color3.fromRGB(28, 15, 48)
SearchBox.PlaceholderText = "🔎 Özellik ara (Fly, Speed, Noclip, Click TP)..."
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
    btn.BackgroundColor3 = Color3.fromRGB(55, 28, 92)
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

-- OYUN ÖZELLİKLERİ
AddActionButton("1. Ultra Fly (Uçma Modu - F Tuşu / Hızlı Gezinme)", function()
    States.Fly = not States.Fly
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    if States.Fly then
        local bv = Instance.new("BodyVelocity", char.HumanoidRootPart)
        bv.Name = "BrainrotFlyBV"
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        local bg = Instance.new("BodyGyro", char.HumanoidRootPart)
        bg.Name = "BrainrotFlyBG"
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

AddActionButton("2. Fly Speed Artır (+50 Hız)", function()
    States.FlySpeed = States.FlySpeed + 50
    if States.FlySpeed > 300 then States.FlySpeed = 50 end
    print("Fly Speed: " .. States.FlySpeed)
end)

AddActionButton("3. Super WalkSpeed (Hızlı Koşma - 120)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = States.WalkSpeed
    end
end)

AddActionButton("4. Noclip (Üslerden Duvarlardan Geç Çal)", function()
    States.Noclip = not States.Noclip
    RunService.Stepped:Connect(function()
        if States.Noclip and LocalPlayer.Character then
            for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end)
end)

AddActionButton("5. Click TP (Tıkladığın Yere Anında Işınlan)", function()
    local mouse = LocalPlayer:GetMouse()
    local conn
    conn = mouse.Button1Down:Connect(function()
        if mouse.Target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
            conn:Disconnect()
        end
    end)
end)

AddActionButton("6. Infinite Jump (Sonsuz Havada Zıplama)", function()
    States.InfJump = true
    UserInputService.JumpRequest:Connect(function()
        if States.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end)

AddActionButton("7. Brainrot ESP (Tüm Oyuncuları Gör)", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = p.Character:FindFirstChildOfClass("Highlight") or Instance.new("Highlight", p.Character)
            hl.FillColor = Color3.fromRGB(168, 85, 247)
        end
    end
end)

-- =========================================================
-- 👥 OYUNCULAR LİSTESİ (TP, SEE, COPY, BANG)
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
            card.BackgroundColor3 = Color3.fromRGB(30, 16, 52)
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)

            local img = Instance.new("ImageLabel", card)
            img.Size = UDim2.new(0, 34, 0, 34)
            img.Position = UDim2.new(0, 5, 0.5, -17)
            img.BackgroundColor3 = Color3.fromRGB(15, 8, 25)
            img.Image = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
            Instance.new("UICorner", img).CornerRadius = UDim.new(1, 0)

            local lbl = Instance.new("TextLabel", card)
            lbl.Size = UDim2.new(0, 120, 1, 0)
            lbl.Position = UDim2.new(0, 45, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.GothamBold
            lbl.Text = p.Name
            lbl.TextColor3 = Color3.fromRGB(230, 210, 255)
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
            tpB.BackgroundColor3 = Color3.fromRGB(168, 85, 247)
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
            seeB.BackgroundColor3 = Color3.fromRGB(90, 30, 150)
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
execBox.BackgroundColor3 = Color3.fromRGB(12, 6, 22)
execBox.MultiLine = true
execBox.ClearTextOnFocus = false
execBox.Text = "print('Steal a Brainrot Hub Ready!')"
execBox.TextColor3 = Color3.fromRGB(168, 85, 247)
execBox.Font = Enum.Font.Code
execBox.TextSize = 11
execBox.TextXAlignment = Enum.TextXAlignment.Left
execBox.TextYAlignment = Enum.TextYAlignment.Top
Instance.new("UICorner", execBox).CornerRadius = UDim.new(0, 5)

local execBtn = Instance.new("TextButton", tExec)
execBtn.Size = UDim2.new(1, 0, 0, 32)
execBtn.Position = UDim2.new(0, 0, 0, 210)
execBtn.BackgroundColor3 = Color3.fromRGB(168, 85, 247)
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

print("PoorsHub Steal a Brainrot Edition Loaded Successfully!")
