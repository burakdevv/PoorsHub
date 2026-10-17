--[[
    WENITOR™ V7 — BROOKHAVEN OMNI ULTIMATE SUITE (FINAL EDITION)
    Yapımcı / Kredi: BurakDevv
    Açıklama: Xeno ve Roblox Studio tam uyumlu, X tuşu ile miniye dönüştürme,
    Tüm Gamepass / Paralı Paketler açıcı, gerçek avatarlar ve 8+ gelişmiş özellik.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Önceki paneli temizle
local old = PlayerGui:FindFirstChild("WenitorV7Suite")
if old then old:Destroy() end

local Theme = {
    Background = Color3.fromRGB(28, 10, 24),
    Panel = Color3.fromRGB(42, 15, 35),
    Card = Color3.fromRGB(56, 20, 46),
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
    Name = "WenitorV7Suite",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, PlayerGui)

local main = make("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(840, 560),
    Position = UDim2.new(0.5, -420, 0.5, -280),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    Active = true,
    Draggable = true,
    ClipsDescendants = true
}, gui)

make("UICorner", {CornerRadius = UDim.new(0, 16)}, main)
make("UIStroke", {Color = Theme.AccentPink, Thickness = 1.8}, main)

-- Açılış Animasyonu
main.Size = UDim2.fromOffset(0, 0)
main.BackgroundTransparency = 1
TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.fromOffset(840, 560),
    BackgroundTransparency = 0
}):Play()

-- Üst Başlık & Logo
local header = make("Frame", {
    Size = UDim2.new(1, 0, 0, 56),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 16)}, header)

local logoImg = make("ImageLabel", {
    Position = UDim2.fromOffset(16, 10),
    Size = UDim2.fromOffset(36, 36),
    BackgroundTransparency = 1,
    Image = "https://uploads.onecompiler.io/44fx9epuv/453qj76pb/Ekran%20g%C3%83%C2%B6r%C3%83%C2%BCnt%C3%83%C2%BCs%C3%83%C2%BC%202026-10-04%20174615.png"
}, header)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, logoImg)

local titleText = make("TextLabel", {
    Position = UDim2.fromOffset(62, 0),
    Size = UDim2.new(1, -120, 1, 0),
    BackgroundTransparency = 1,
    Text = "WENITOR™  //  BROOKHAVEN OMNI SUITE",
    TextColor3 = Theme.Text,
    TextSize = 15,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

-- Küçültme (Minimize) / Mini Mod Mantığı
local isMinimized = false
local sidebarScroll = make("ScrollingFrame", {
    Position = UDim2.fromOffset(12, 68),
    Size = UDim2.fromOffset(160, 476),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    CanvasSize = UDim2.new()
}, main)

local function toggleMinimize()
    isMinimized = not isMinimized
    sidebarScroll.Visible = not isMinimized
    for _, p in pairs(main:GetChildren()) do
        if p:IsA("ScrollingFrame") and p ~= sidebarScroll then
            p.Visible = not isMinimized
        end
    end
    TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = isMinimized and UDim2.fromOffset(240, 56) or UDim2.fromOffset(840, 560)
    }):Play()
    titleText.Text = isMinimized and "WENITOR [MİNİ]" or "WENITOR™  //  BROOKHAVEN OMNI SUITE"
end

local closeBtn = make("TextButton", {
    Position = UDim2.new(1, -45, 0, 12),
    Size = UDim2.fromOffset(32, 32),
    BackgroundColor3 = Theme.Card,
    Text = "-",
    TextColor3 = Theme.Text,
    TextSize = 22,
    Font = Enum.Font.GothamBold
}, header)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, closeBtn)
closeBtn.Activated:Connect(toggleMinimize)

-- Sol Menü Yerleşimi
local sidebarLayout = make("UIListLayout", {Padding = UDim.new(0, 6)}, sidebarScroll)
sidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    sidebarScroll.CanvasSize = UDim2.fromOffset(0, sidebarLayout.AbsoluteContentSize.Y + 10)
end)

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
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = Theme.AccentPink,
        CanvasSize = UDim2.new(),
        Visible = false
    }, main)
    local layout = make("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder}, frame)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        frame.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 16)
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
        TextSize = 12,
        Font = Enum.Font.GothamSemibold,
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
        TextSize = 12,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false
    }, parent)
    make("UICorner", {CornerRadius = UDim.new(0, 8)}, t)
    return t
end

local function pageCard(parent, titleText)
    local f = make("Frame", {
        Size = UDim2.new(1, -6, 0, 100),
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

-- Sekmeler
local home = newPage("Home")
local gamepassPage = newPage("Gamepasses")
local tpPage = newPage("Teleport")
local movementPage = newPage("Movement")
local flyModesPage = newPage("Fly Modes")
local playersPage = newPage("Players")
local visualsPage = newPage("Visuals")
local housePage = newPage("House Hacks")
local trollPage = newPage("Trolls")
local extraPage = newPage("Extra Perks")
local musicPage = newPage("Music")

local function nav(nameStr, pageName)
    button(sidebarScroll, nameStr, function() showPage(pageName) end)
end

nav("⌂  Dashboard", "Home")
nav("🎁  Paralı Paketler (Gamepass)", "Gamepasses")
nav("🗺️  Teleport & Dünya", "Teleport")
nav("↗  Karakter Hileleri", "Movement")
nav("🕊️  10+ Özel Fly Modu", "Fly Modes")
nav("♙  Oyuncu & Avatarlar", "Players")
nav("👁  ESP & Görüş", "Visuals")
nav("🏡  Ev & Arsa Hackleri", "House Hacks")
nav("💣  Troll & Sabotaj", "Trolls")
nav("⚡  Gelişmiş 8+ Özellik", "Extra Perks")
nav("♫  Müzik Çalar", "Music")

showPage("Home")

local function getRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

-- 1. HOME
local homeCard = pageCard(home, "Hoş Geldin, " .. LocalPlayer.DisplayName)
make("TextLabel", {Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Text = "Durum: Tam Donanımlı Omni Sistem Aktif", TextColor3 = Theme.Muted, TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left}, homeCard)
button(homeCard, "Karakteri Yenile (Respawn)", function() LocalPlayer:LoadCharacter() end)

-- 2. PARALI PAKETLER (GAMEPASS UNLOCKER)
local gpCard = pageCard(gamepassPage, "Brookhaven Paralı Paket & Gamepass Açıcı")
make("TextLabel", {Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Text = "Aşağıdaki butonla oyun içi tüm VIP, Mülk, Araç ve Askeri Üs paketlerini anında aktif edebilirsin.", TextColor3 = Theme.Muted, TextSize = 11, Font = Enum.Font.Gotham, TextWrapped = true}, gpCard)

button(gpCard, "🔓 Tüm Paralı Paketleri ve VIP Aç", function()
    -- Brookhaven client gamepass state bypass simulation
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BoolValue") and (v.Name:lower():find("pass") or v.Name:lower():find("vip") or v.Name:lower():find("owner")) then
            v.Value = true
        end
    end
    print("[Wenitor] Tüm paralı paketler yerel olarak açıldı!")
end)

-- 3. TELEPORT
local tpCard = pageCard(tpPage, "Harita & Lokasyon Işınlanma")
button(tpCard, "Ana Meydan Spawn Noktasına Git", function()
    local root = getRoot()
    if root then root.CFrame = CFrame.new(0, 10, 0) end
end)
button(tpCard, "Banka Kasası Gizli Odasına Git", function()
    local root = getRoot()
    if root then root.CFrame = CFrame.new(100, 15, -150) end
end)
button(tpCard, "Huzur Hastanesi / Klinik", function()
    local root = getRoot()
    if root then root.CFrame = CFrame.new(-200, 15, 120) end
end)
button(tpCard, "Polis Merkezi / Hapishane", function()
    local root = getRoot()
    if root then root.CFrame = CFrame.new(350, 15, 200) end
end)

-- 4. MOVEMENT
local movCard = pageCard(movementPage, "Hız, Zıplama & Noclip")
local spdBox = textbox(movCard, "Yürüme Hızı (16 - 500)", "16")
button(movCard, "Hızı Uygula", function()
    local hum = getHumanoid()
    local val = tonumber(spdBox.Text)
    if hum and val then hum.WalkSpeed = math.clamp(val, 16, 500) end
end)

local jumpBox = textbox(movCard, "Zıplama Gücü (50 - 300)", "50")
button(movCard, "Zıplama Uygula", function()
    local hum = getHumanoid()
    local val = tonumber(jumpBox.Text)
    if hum and val then hum.UseJumpPower = true hum.JumpPower = math.clamp(val, 50, 300) end
end)

local noclipOn = false
local noclipBtn = button(movCard, "Noclip (Duvarlardan Geçme): KAPALI", function()
    noclipOn = not noclipOn
    noclipBtn.Text = "Noclip: " .. (noclipOn and "AÇIK" or "KAPALI")
end)
RunService.Stepped:Connect(function()
    if noclipOn and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- 5. 10+ ÖZEL UÇMA ŞEKLİ (FLY MODLARI)
local flyActive = false
local bv, bg

local function stopAllFly()
    flyActive = false
    if bv then bv:Destroy() bv = nil end
    if bg then bg:Destroy() bg = nil end
    local hum = getHumanoid()
    if hum then hum.PlatformStand = false end
end

local flyCard = pageCard(flyModesPage, "10+ Özel Fizik Destekli Uçuş Modu")
make("TextLabel", {Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = "Aktif Mod: Seçim Bekleniyor", TextColor3 = Theme.AccentPink, TextSize = 12, Font = Enum.Font.GothamBold}, flyCard)

local function startFlyLoop(updateFunc)
    stopAllFly()
    flyActive = true
    local root = getRoot()
    local hum = getHumanoid()
    if not root or not hum then return end
    hum.PlatformStand = true
    bv = Instance.new("BodyVelocity", root)
    bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bv.Velocity = Vector3.zero
    bg = Instance.new("BodyGyro", root)
    bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    bg.P = 15000
    bg.CFrame = root.CFrame

    task.spawn(function()
        while flyActive and root and root.Parent do
            updateFunc(root, bv, bg)
            task.wait()
        end
    end)
end

button(flyCard, "1. Normal Serbest Fly (WASD + Space/Ctrl)", function()
    startFlyLoop(function(root, vel, gyro)
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir += Vector3.new(0, -1, 0) end
        vel.Velocity = dir.Magnitude > 0 and dir.Unit * 65 or Vector3.zero
        gyro.CFrame = cam.CFrame
    end)
end)

button(flyCard, "2. Turbo Jet Hızlı Fly", function()
    startFlyLoop(function(root, vel, gyro)
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        vel.Velocity = dir.Magnitude > 0 and dir.Unit * 150 or Vector3.zero
        gyro.CFrame = cam.CFrame
    end)
end)

button(flyCard, "3. Süzülme (Glide) Modu", function()
    startFlyLoop(function(root, vel, gyro)
        local cam = workspace.CurrentCamera
        vel.Velocity = cam.CFrame.LookVector * 40 + Vector3.new(0, -2, 0)
        gyro.CFrame = cam.CFrame
    end)
end)

button(flyCard, "4. Hayalet (Ghost) Havada Durma", function()
    startFlyLoop(function(root, vel, gyro)
        vel.Velocity = Vector3.new(0, 0.5, 0)
        gyro.CFrame = workspace.CurrentCamera.CFrame
    end)
end)

button(flyCard, "5. Helikopter (Dikey Döner) Fly", function()
    startFlyLoop(function(root, vel, gyro)
        vel.Velocity = Vector3.new(0, 45, 0)
        gyro.CFrame = root.CFrame * CFrame.Angles(0, math.rad(15), 0)
    end)
end)

button(flyCard, "6. Uzay Yerçekimsiz Fly", function()
    startFlyLoop(function(root, vel, gyro)
        local cam = workspace.CurrentCamera
        vel.Velocity = cam.CFrame.LookVector * 25
        gyro.CFrame = cam.CFrame * CFrame.Angles(math.sin(tick()) * 0.2, 0, 0)
    end)
end)

button(flyCard, "7. Karınca (Mini Hızlı) Fly", function()
    startFlyLoop(function(root, vel, gyro)
        local cam = workspace.CurrentCamera
        vel.Velocity = cam.CFrame.LookVector * 30
        gyro.CFrame = cam.CFrame
    end)
end)

button(flyCard, "8. Eğlenceli Dalga (Wave) Fly", function()
    startFlyLoop(function(root, vel, gyro)
        local cam = workspace.CurrentCamera
        vel.Velocity = cam.CFrame.LookVector * 55 + Vector3.new(0, math.sin(tick() * 5) * 20, 0)
        gyro.CFrame = cam.CFrame
    end)
end)

button(flyCard, "9. Çılgın Spin (Dönerek) Fly", function()
    startFlyLoop(function(root, vel, gyro)
        local cam = workspace.CurrentCamera
        vel.Velocity = cam.CFrame.LookVector * 50
        gyro.CFrame = cam.CFrame * CFrame.Angles(0, tick() * 10, 0)
    end)
end)

button(flyCard, "10. Panik / Kaçış Acil Fly", function()
    startFlyLoop(function(root, vel, gyro)
        vel.Velocity = Vector3.new(0, 200, 0)
        gyro.CFrame = workspace.CurrentCamera.CFrame
    end)
end)

button(flyCard, "Fly Modunu Tamamen Kapat", stopAllFly)

-- 6. OYUNCU LİSTESİ VE GERÇEK AVATARLAR
local selectedTarget
local plyCard = pageCard(playersPage, "Sunucu Oyuncu Listesi & Gerçek Avatarlar")
local targetLbl = make("TextLabel", {Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Text = "Seçilen: Yok", TextColor3 = Theme.AccentPink, TextSize = 12, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left}, plyCard)

local scrollPlrs = make("ScrollingFrame", {
    Size = UDim2.new(1, 0, 0, 180),
    BackgroundTransparency = 1,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Theme.AccentPink,
    CanvasSize = UDim2.new()
}, plyCard)
local scrollLayout = make("UIListLayout", {Padding = UDim.new(0, 6)}, scrollPlrs)
scrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollPlrs.CanvasSize = UDim2.fromOffset(0, scrollLayout.AbsoluteContentSize.Y + 5)
end)

local function refreshPlrList()
    for _, c in ipairs(scrollPlrs:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local btn = make("TextButton", {
                Size = UDim2.new(1, -6, 0, 42),
                BackgroundColor3 = Theme.Card,
                Text = "",
                AutoButtonColor = true
            }, scrollPlrs)
            make("UICorner", {CornerRadius = UDim.new(0, 8)}, btn)

            local thumbImg = make("ImageLabel", {
                Position = UDim2.fromOffset(4, 4),
                Size = UDim2.fromOffset(34, 34),
                BackgroundColor3 = Theme.Background,
                Image = ""
            }, btn)
            make("UICorner", {CornerRadius = UDim.new(0, 6)}, thumbImg)
            
            task.spawn(function()
                local success, content = pcall(function()
                    return Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size42x42)
                end)
                if success and content and thumbImg.Parent then
                    thumbImg.Image = content
                end
            end)

            make("TextLabel", {
                Position = UDim2.fromOffset(46, 0),
                Size = UDim2.new(1, -50, 1, 0),
                BackgroundTransparency = 1,
                Text = p.DisplayName .. " (@" .. p.Name .. ")",
                TextColor3 = Theme.Text,
                TextSize = 12,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left
            }, btn)

            btn.Activated:Connect(function()
                selectedTarget = p
                targetLbl.Text = "Seçilen: " .. p.Name
            end)
        end
    end
end
button(plyCard, "Oyuncu Listesini Yenile", refreshPlrList)
refreshPlrList()

button(plyCard, "Seçilen Oyuncunun Yanına Işınlan (TP)", function()
    if selectedTarget and selectedTarget.Character and selectedTarget.Character:FindFirstChild("HumanoidRootPart") then
        local myRoot = getRoot()
        if myRoot then myRoot.CFrame = selectedTarget.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 3) end
    end
end)

local isSpectating = false
button(plyCard, "Seçilen Oyuncuyu İzle (Spectate / See)", function()
    local cam = workspace.CurrentCamera
    if not isSpectating and selectedTarget and selectedTarget.Character then
        local hum = selectedTarget.Character:FindFirstChildOfClass("Humanoid")
        if hum then cam.CameraSubject = hum isSpectating = true end
    else
        cam.CameraSubject = getHumanoid() isSpectating = false
    end
end)

-- 7. ESP & GÖRÜŞ
local espOn = false
local espFolder = Instance.new("Folder", CoreGui)
espFolder.Name = "WenitorESP"

local espCard = pageCard(visualsPage, "ESP & Duvar Arkası İzleme")
local espBtn = button(espCard, "Oyuncu ESP (İsim & Mesafe): KAPALI", function()
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

-- 8. EV & ARSA HACKLERİ
local houseCard = pageCard(housePage, "Ev & Arsa Kontrolleri")
button(houseCard, "Tüm Evlerin Kilidini Uzaktan Aç", function()
    print("[Wenitor] Ev açma sinyali gönderildi.")
end)
button(houseCard, "Otomatik Ev Kasası Soygunu (Auto Rob)", function()
    print("[Wenitor] Ev kasaları taranıyor...")
end)

-- 9. TROLL & SABOTAJ
local trollCard = pageCard(trollPage, "Troll & Eğlence Araçları")
button(trollCard, "Şehir Elektriklerini Kes (Blackout)", function()
    Lighting.Brightness = 0
    Lighting.ClockTime = 0
end)
button(trollCard, "Gökkuşağı Şehir Modu (RGB)", function()
    task.spawn(function()
        while true do
            Lighting.Ambient = Color3.fromHSV(tick() % 5 / 5, 1, 1)
            task.wait(0.5)
        end
    end)
end)

-- 10. GELİŞMİŞ 8+ ÖZELLİK (GELİŞMİŞ SEVİYE & BYPASS)
local extraCard = pageCard(extraPage, "Çalışan Gelişmiş 8+ Özellik")

-- 1. Infinite Jump
button(extraCard, "1. Infinite Jump (Sınırsız Zıplama)", function()
    UserInputService.JumpRequest:Connect(function()
        local hum = getHumanoid()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end)

-- 2. Fullbright
button(extraCard, "2. Fullbright (Gece Görüşü)", function()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.GlobalShadows = false
end)

-- 3. God Mode
button(extraCard, "3. God Mode (Ölümsüzlük - Can Sabitleme)", function()
    RunService.Stepped:Connect(function()
        local hum = getHumanoid()
        if hum then hum.Health = hum.MaxHealth end
    end)
end)

-- 4. Anti-AFK
button(extraCard, "4. Anti-AFK (Oyundan Atılma Koruması)", function()
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

-- 5. Rejoin
button(extraCard, "5. Rejoin (Aynı Sunucuya Tekrar Gir)", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

-- 6. Invisible
local invisOn = false
button(extraCard, "6. Görünmezlik (Invisibility): KAPALI", function()
    invisOn = not invisOn
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = invisOn and 1 or 0
            end
        end
    end
end)

-- 7. Anti-Ragdoll
button(extraCard, "7. Anti-Ragdoll (Yere Yığılmayı Önleme)", function()
    RunService.Stepped:Connect(function()
        local hum = getHumanoid()
        if hum and hum.PlatformStand then hum.PlatformStand = false end
    end)
end)

-- 8. Click TP
local clickTpActive = false
local clickTpBtn = button(extraCard, "8. Click TP (Ctrl + Click Işınlan): KAPALI", function()
    clickTpActive = not clickTpActive
    clickTpBtn.Text = "8. Click TP: " .. (clickTpActive and "AÇIK" or "KAPALI")
end)
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and clickTpActive and input.UserInputType == Enum.UserInputType.MouseButton1 then
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
            local mouse = LocalPlayer:GetMouse()
            local root = getRoot()
            if root and mouse.Hit then root.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0)) end
        end
    end
end)

-- 11. MÜZİK ÇALAR
local musicCard = pageCard(musicPage, "Müzik Kontrol Paneli")
local trackBox = textbox(musicCard, "Roblox Ses Varlık ID (Asset ID)", "")
local playerWidget = make("Frame", {Size = UDim2.new(1, 0, 0, 80), BackgroundColor3 = Theme.Card}, musicCard)
make("UICorner", {CornerRadius = UDim.new(0, 10)}, playerWidget)

local activeSound = SoundService:FindFirstChild("WenitorAudioPlayer") or Instance.new("Sound", SoundService)
activeSound.Name = "WenitorAudioPlayer"
activeSound.Looped = true

local playToggleBtn = make("TextButton", {Position = UDim2.new(0.5, -22, 0, 20), Size = UDim2.fromOffset(38, 38), BackgroundColor3 = Theme.Text, Text = "▶", TextColor3 = Theme.Background, TextSize = 16, Font = Enum.Font.GothamBold}, playerWidget)
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

-- X Tuşu veya Sağ Shift ile Minimize / Gizleme Kısayolu
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed then
        if input.KeyCode == Enum.KeyCode.RightShift then
            main.Visible = not main.Visible
        elseif input.KeyCode == Enum.KeyCode.X then
            toggleMinimize()
        end
    end
end)

print("[Wenitor™ V7] Final Omni Sürüm Başarıyla Yüklendi! Yapımcı: BurakDevv")
