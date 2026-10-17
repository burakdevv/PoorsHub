--[[
    WENITOR™ V3 — BROOKHAVEN & COMMUNITY SUITE
    Yapımcı / Kredi: BurakDevv
    Özellikler: Animasyonlu Modern UI, Müzik Çalar (Image 1 Tarzı), 
    Community Dashboard (Image 2 Tarzı), Noclip, Fly, ESP, Spectate, Teleport.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Önceki paneli temizle
local old = PlayerGui:FindFirstChild("WenitorV3Suite")
if old then old:Destroy() end

local Theme = {
    Background = Color3.fromRGB(35, 14, 30),
    Panel = Color3.fromRGB(50, 20, 42),
    Card = Color3.fromRGB(68, 27, 56),
    AccentPink = Color3.fromRGB(255, 83, 180),
    AccentPurple = Color3.fromRGB(155, 87, 255),
    Text = Color3.fromRGB(245, 239, 255),
    Muted = Color3.fromRGB(175, 160, 196),
    Green = Color3.fromRGB(91, 225, 157),
}

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local gui = make("ScreenGui", {
    Name = "WenitorV3Suite",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, PlayerGui)

local main = make("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(780, 520),
    Position = UDim2.new(0.5, -390, 0.5, -260),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    Active = true,
    Draggable = true,
    ClipsDescendants = true
}, gui)

make("UICorner", {CornerRadius = UDim.new(0, 16)}, main)
make("UIStroke", {Color = Theme.AccentPink, Thickness = 1.8}, main)

-- Açılış Animasyonu (Küçükten büyüyerekfade in)
main.Size = UDim2.fromOffset(0, 0)
main.BackgroundTransparency = 1
TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.fromOffset(780, 520),
    BackgroundTransparency = 0
}):Play()

-- Üst Başlık & Logo Alanı
local header = make("Frame", {
    Size = UDim2.new(1, 0, 0, 56),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 16)}, header)

-- Logo (Belirttiğin Görsel URL Entegrasyonu)
local logoImg = make("ImageLabel", {
    Position = UDim2.fromOffset(16, 10),
    Size = UDim2.fromOffset(36, 36),
    BackgroundTransparency = true,
    Image = "rbxassetid://0" -- Fallback ID, harici URL doğrudan ImageLabel'da Asset ID gerektirir
}, header)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, logoImg)

make("TextLabel", {
    Position = UDim2.fromOffset(62, 0),
    Size = UDim2.new(1, -120, 1, 0),
    BackgroundTransparency = 1,
    Text = "WENITOR™  //  COMMUNITY & TEST HUB",
    TextColor3 = Theme.Text,
    TextSize = 15,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

local closeBtn = make("TextButton", {
    Position = UDim2.new(1, -45, 0, 12),
    Size = UDim2.fromOffset(32, 32),
    BackgroundColor3 = Theme.Card,
    Text = "×",
    TextColor3 = Theme.Text,
    TextSize = 22,
    Font = Enum.Font.GothamBold
}, header)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, closeBtn)
closeBtn.Activated:Connect(function()
    local tw = TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.fromOffset(0, 0),
        BackgroundTransparency = 1
    })
    tw:Play()
    tw.Completed:Connect(function() gui:Destroy() end)
end)

-- Sol Sidebar (Kategori Menüsü)
local sidebar = make("Frame", {
    Position = UDim2.fromOffset(12, 68),
    Size = UDim2.fromOffset(160, 440),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 12)}, sidebar)

local pages = {}
local function showPage(name)
    for pName, frame in pairs(pages) do
        frame.Visible = (pName == name)
    end
end

local function newPage(name)
    local frame = make("ScrollingFrame", {
        Name = name,
        Position = UDim2.fromOffset(184, 68),
        Size = UDim2.new(1, -196, 1, -80),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Theme.AccentPink,
        CanvasSize = UDim2.new(),
        Visible = false
    }, main)
    local layout = make("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, frame)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        frame.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 12)
    end)
    pages[name] = frame
    return frame
end

local function button(parent, textStr, callback)
    local b = make("TextButton", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Theme.Card,
        Text = textStr,
        TextColor3 = Theme.Text,
        TextSize, Font = 13, Enum.Font.GothamSemibold,
        AutoButtonColor = true
    }, parent)
    make("UICorner", {CornerRadius = UDim.new(0, 8)}, b)
    make("UIStroke", {Color = Theme.AccentPurple, Transparency = 0.5}, b)
    b.Activated:Connect(callback)
    return b
end

local function textbox(parent, placeholder, defaultText)
    local t = make("TextBox", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Theme.Card,
        Text = defaultText or "",
        PlaceholderText = placeholder,
        PlaceholderColor3 = Theme.Muted,
        TextColor3 = Theme.Text,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false
    }, parent)
    make("UICorner", {CornerRadius = UDim.new(0, 8)}, t)
    return t
end

local function pageCard(parent, titleText)
    local f = make("Frame", {
        Size = UDim2.new(1, -5, 0, 100),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0
    }, parent)
    make("UICorner", {CornerRadius = UDim.new(0, 10)}, f)
    make("UIPadding", {PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12)}, f)
    make("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, f)
    make("TextLabel", {Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Text = titleText, TextColor3 = Theme.Text, TextSize = 14, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left}, f)
    return f
end

-- Sayfalar
local home = newPage("Home")
local movementPage = newPage("Movement")
local playersPage = newPage("Players")
local visualsPage = newPage("Visuals")
local musicPage = newPage("Music")

local function nav(nameStr, order, pageName)
    local b = button(sidebar, nameStr, function() showPage(pageName) end)
    b.Size = UDim2.new(1, -16, 0, 36)
    b.Position = UDim2.fromOffset(8, 8 + (order - 1) * 44)
    return b
end

nav("⌂  Dashboard", 1, "Home")
nav("↗  Movement & Noclip", 2, "Movement")
nav("♙  Players & Teleport", 3, "Players")
nav("👁  ESP & Visuals", 4, "Visuals")
nav("♫  Music Player (UI)", 5, "Music")

showPage("Home")

-- Alt Durum Çubuğu (Wave Efekti Alanı)
local statusLabel = make("TextLabel", {
    Position = UDim2.new(0, 12, 1, -32),
    Size = UDim2.new(1, -24, 0, 24),
    BackgroundTransparency = 1,
    Text = "STATUS: ONLINE — WENITOR READY",
    TextColor3 = Theme.Green,
    TextSize = 11,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, main)

local function getRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

-- 1. HOME DASHBOARD
local homeCard = pageCard(home, "Hoş Geldin, " .. LocalPlayer.DisplayName)
make("TextLabel", {Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Text = "Sunucu: Roblox Deneyimi", TextColor3 = Theme.Muted, TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left}, homeCard)
button(homeCard, "Karakteri Yenile (Respawn)", function() LocalPlayer:LoadCharacter() end)

-- 2. MOVEMENT (Noclip, Fly, Speed)
local movCard = pageCard(movementPage, "Hız & Uçuş Kontrolleri")
local spdBox = textbox(movCard, "Yürüme Hızı (16)", "16")
button(movCard, "Hızı Uygula", function()
    local hum = getHumanoid()
    local val = tonumber(spdBox.Text)
    if hum and val then hum.WalkSpeed = val end
end)

-- NOCLIP ÖZELLİĞİ
local noclipOn = false
local noclipBtn = button(movCard, "Duvardan Geçme (Noclip): KAPALI", function()
    noclipOn = not noclipOn
    noclipBtn.Text = "Duvardan Geçme (Noclip): " .. (noclipOn and "AÇIK" or "KAPALI")
end)
RunService.Stepped:Connect(function()
    if noclipOn and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- FLY ÖZELLİĞİ
local flyOn = false
local bodyVel, bodyGyro
local flyBtn = button(movCard, "Uçuş Modu (Fly): KAPALI", function()
    flyOn = not flyOn
    local root = getRoot()
    local hum = getHumanoid()
    if flyOn and root and hum then
        flyBtn.Text = "Uçuş Modu (Fly): AÇIK"
        hum.PlatformStand = true
        bodyVel = Instance.new("BodyVelocity", root)
        bodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bodyVel.Velocity = Vector3.zero
        bodyGyro = Instance.new("BodyGyro", root)
        bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        bodyGyro.CFrame = root.CFrame
        
        task.spawn(function()
            while flyOn and root and root.Parent do
                local cam = workspace.CurrentCamera
                local dir = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
                bodyVel.Velocity = dir.Magnitude > 0 and dir.Unit * 60 or Vector3.zero
                bodyGyro.CFrame = cam.CFrame
                Task.wait()
            end
        end)
    else
        flyBtn.Text = "Uçuş Modu (Fly): KAPALI"
        if bodyVel then bodyVel:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        if hum then hum.PlatformStand = false end
    end
end)

-- 3. PLAYERS & TELEPORT & SPECTATE
local selectedTarget
local plyCard = pageCard(playersPage, "Oyuncu Listesi & Işınlanma")
local targetLbl = make("TextLabel", {Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Text = "Seçilen: Yok", TextColor3 = Theme.AccentPink, TextSize = 12, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left}, plyCard)

local scrollPlrs = make("ScrollingFrame", {Size = UDim2.new(1, 0, 0, 130), BackgroundTransparency = 1, ScrollBarThickness = 3, CanvasSize = UDim2.new()}, plyCard)
make("UIListLayout", {Padding = UDim.new(0, 4)}, scrollPlrs)

local function refreshPlrList()
    for _, c in ipairs(scrollPlrs:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            button(scrollPlrs, p.DisplayName .. " (@" .. p.Name .. ")", function()
                selectedTarget = p
                targetLbl.Text = "Seçilen: " .. p.Name
            end)
        end
    end
end
button(plyCard, "Listeyi Yenile", refreshPlrList)
refreshPlrList()

button(plyCard, "Seçilen Oyuncunun Yanına Git (Teleport)", function()
    if selectedTarget and selectedTarget.Character and selectedTarget.Character:FindFirstChild("HumanoidRootPart") then
        local myRoot = getRoot()
        if myRoot then myRoot.CFrame = selectedTarget.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 3) end
    end
end)

-- SPECTATE (SEE) ÖZELLİĞİ
local isSpectating = false
button(plyCard, "Seçilen Oyuncuyu İzle (Spectate / See)", function()
    local cam = workspace.CurrentCamera
    if not isSpectating and selectedTarget and selectedTarget.Character then
        local hum = selectedTarget.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            cam.CameraSubject = hum
            isSpectating = true
        end
    else
        cam.CameraSubject = getHumanoid()
        isSpectating = false
    end
end)

-- 4. VISUALS & ESP ÖZELLİĞİ
local espOn = false
local espFolder = Instance.new("Folder", CoreGui)
espFolder.Name = "WenitorESP"

local espCard = pageCard(visualsPage, "Oyuncu ESP (İsim & Mesafe)")
local espBtn = button(espCard, "ESP: KAPALI", function()
    espOn = not espOn
    espBtn.Text = "ESP: " .. (espOn and "AÇIK" or "KAPALI")
    if not espOn then espFolder:ClearAllChildren() end
end)

RunService.RenderStepped:Connect(function()
    if not espOn then return end
    espFolder:ClearAllChildren()
    local myRoot = getRoot()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = myRoot and math.floor((myRoot.Position - p.Character.HumanoidRootPart.Position).Magnitude) or 0
            local bb = Instance.new("BillboardGui", espFolder)
            bb.Adornee = p.Character.Head
            bb.Size = UDim2.fromOffset(150, 40)
            bb.AlwaysOnTop = true
            bb.StudsOffset = Vector3.new(0, 2.5, 0)
            local txt = Instance.new("TextLabel", bb)
            txt.Size = UDim2.new(1,0,1,0)
            txt.BackgroundTransparency = 1
            txt.TextColor3 = Theme.AccentPink
            txt.TextSize = 12
            txt.Font = Enum.Font.GothamBold
            txt.Text = string.format("%s\n[%dm]", p.Name, dist)
        end
    end
end)

-- 5. MUSIC PLAYER (Image 1 Tarzı Şık Müzik Kontrol Paneli)
local musicCard = pageCard(musicPage, "Müzik Kontrol Paneli (Image 1 Tasarımı)")
local trackBox = textbox(musicCard, "Roblox Ses Varlık ID (Asset ID)", "")

-- Image 1'e birebir benzeyen çalma butonları alanı
local playerWidget = make("Frame", {Size = UDim2.new(1, 0, 0, 80), BackgroundColor3 = Theme.Card}, musicCard)
make("UICorner", {CornerRadius = UDim.new(0, 10)}, playerWidget)

-- Zaman Etiketleri ve İlerleme Çubuğu (Image 1 stili)
local timeStart = make("TextLabel", {Position = UDim2.fromOffset(12, 52), Size = UDim2.fromOffset(40, 20), BackgroundTransparency = 1, Text = "0:00", TextColor3 = Theme.AccentPink, TextSize = 11, Font = Enum.Font.Gotham}, playerWidget)
local timeEnd = make("TextLabel", {Position = UDim2.new(1, -52, 0, 52), Size = UDim2.fromOffset(40, 20), BackgroundTransparency = 1, Text = "4:11", TextColor3 = Theme.Muted, TextSize = 11, Font = Enum.Font.Gotham}, playerWidget)

local progressBarBg = make("Frame", {Position = UDim2.new(0, 56, 0, 60), Size = UDim2.new(1, -112, 0, 4), BackgroundColor3 = Theme.Muted}, playerWidget)
make("UICorner", {CornerRadius = UDim.new(0, 2)}, progressBarBg)

local activeSound = SoundService:FindFirstChild("WenitorAudioPlayer") or Instance.new("Sound", SoundService)
activeSound.Name = "WenitorAudioPlayer"
activeSound.Looped = true

local playToggleBtn = make("TextButton", {Position = UDim2.new(0.5, -22, 0, 8), Size = UDim2.fromOffset(38, 38), BackgroundColor3 = Theme.Text, Text = "▶", TextColor3 = Theme.Background, TextSize = 16, Font = Enum.Font.GothamBold}, playerWidget)
make("UICorner", {CornerRadius = UDim.new(0, 19)}, playToggleBtn)

playToggleBtn.Activated:Connect(function()
    local idNum = tonumber(trackBox.Text:match("%d+"))
    if idNum then
        if activeSound.IsPlaying then
            activeSound:Pause()
            playToggleBtn.Text = "▶"
        else
            activeSound.SoundId = "rbxassetid://" .. idNum
            activeSound:Play()
            playToggleBtn.Text = "❚❚"
        end
    end
end)

-- Sağ Shift Kısayolu ile Paneli Gizleme/Açma
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end)

print("[Wenitor™ V3] Başarıyla yüklendi! Yapımcı: BurakDevv")
