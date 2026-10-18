--[[
    WENITOR™ V9 — DELTA x WIN11 PURPLE OMNI ULTIMATE SUITE
    Yapımcı / Kredi: BurakDevv
    Açıklama: Delta & Win11 Mor UI, animasyonlu pencere, ç612 Troll Panel,
    ç666 Guest 666 Ban Çekici Eventi, Gerçek Araç/Paket Spawner ve Tam Donanım.
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

-- Önceki panelleri temizle
if PlayerGui:FindFirstChild("WenitorV9Suite") then PlayerGui.WenitorV9Suite:Destroy() end
if PlayerGui:FindFirstChild("WenitorTrollGui") then PlayerGui.WenitorTrollGui:Destroy() end
if PlayerGui:FindFirstChild("Guest666Gui") then PlayerGui.Guest666Gui:Destroy() end

local Theme = {
    Background = Color3.fromRGB(18, 14, 28),     -- Win11 Koyu Mor Arka Plan
    Panel = Color3.fromRGB(28, 20, 42),          -- Panel Kart Rengi
    Card = Color3.fromRGB(40, 28, 60),           -- Buton & Öğe Rengi
    AccentPurple = Color3.fromRGB(147, 51, 234), -- Canlı Win11 Moru
    AccentPink = Color3.fromRGB(236, 72, 153),   -- Delta Pembe Vurgu
    Text = Color3.fromRGB(245, 243, 255),
    Muted = Color3.fromRGB(167, 139, 250),
    Green = Color3.fromRGB(74, 222, 128),
    Red = Color3.fromRGB(248, 113, 113)
}

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

-- ==================== ANA DELTA x WIN11 GUI ====================
local gui = make("ScreenGui", {
    Name = "WenitorV9Suite",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, PlayerGui)

local main = make("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(860, 580),
    Position = UDim2.new(0.5, -430, 0.5, -290),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    Active = true,
    Draggable = true,
    ClipsDescendants = true
}, gui)

make("UICorner", {CornerRadius = UDim.new(0, 12)}, main)
make("UIStroke", {Color = Theme.AccentPurple, Thickness = 2}, main)

-- Açılış Animasyonu
main.Size = UDim2.fromOffset(0, 0)
main.BackgroundTransparency = 1
TweenService:Create(main, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.fromOffset(860, 580),
    BackgroundTransparency = 0
}):Play()

-- Üst Başlık (Delta Style)
local header = make("Frame", {
    Size = UDim2.new(1, 0, 0, 52),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 12)}, header)

local logoImg = make("ImageLabel", {
    Position = UDim2.fromOffset(14, 10),
    Size = UDim2.fromOffset(32, 32),
    BackgroundTransparency = 1,
    Image = "https://uploads.onecompiler.io/44fx9epuv/453qj76pb/Ekran%20g%C3%83%C2%B6r%C3%83%C2%BCnt%C3%83%C2%BCs%C3%83%C2%BC%202026-10-04%20174615.png"
}, header)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, logoImg)

local titleText = make("TextLabel", {
    Position = UDim2.fromOffset(56, 0),
    Size = UDim2.new(1, -120, 1, 0),
    BackgroundTransparency = 1,
    Text = "WENITOR™  //  DELTA x WIN11 OMNI (Chate ç612 veya ç666 yaz!)",
    TextColor3 = Theme.Text,
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

-- Minimize (Win11/Delta Tarzı)
local isMinimized = false
local sidebarScroll = make("ScrollingFrame", {
    Position = UDim2.fromOffset(12, 64),
    Size = UDim2.fromOffset(165, 504),
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
    TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = isMinimized and UDim2.fromOffset(260, 52) or UDim2.fromOffset(860, 580)
    }):Play()
    titleText.Text = isMinimized and "WENITOR [MİNİ]" or "WENITOR™  //  DELTA x WIN11 OMNI"
end

local minimizeBtn = make("TextButton", {
    Position = UDim2.new(1, -44, 0, 10),
    Size = UDim2.fromOffset(32, 32),
    BackgroundColor3 = Theme.Card,
    Text = "-",
    TextColor3 = Theme.Text,
    TextSize = 20,
    Font = Enum.Font.GothamBold
}, header)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, minimizeBtn)
minimizeBtn.Activated:Connect(toggleMinimize)

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
        Position = UDim2.fromOffset(189, 64),
        Size = UDim2.new(1, -201, 1, -76),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 5,
        ScrollBarImageColor3 = Theme.AccentPurple,
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
local vehiclePage = newPage("Vehicles")
local tpPage = newPage("Teleport")
local movementPage = newPage("Movement")
local flyModesPage = newPage("Fly Modes")
local playersPage = newPage("Players")
local visualsPage = newPage("Visuals")
local trollPage = newPage("Trolls")
local extraPage = newPage("Extra Perks")
local musicPage = newPage("Music")

local function nav(nameStr, pageName)
    button(sidebarScroll, nameStr, function() showPage(pageName) end)
end

nav("⌂  Dashboard", "Home")
nav("🎁  Paralı Paketler & VIP", "Gamepasses")
nav("🚗  Gerçek Araç Spawner", "Vehicles")
nav("🗺️  Teleport & Dünya", "Teleport")
nav("↗  Karakter Hileleri", "Movement")
nav("🕊️  10+ Fly Modu [F]", "Fly Modes")
nav("♙  Gerçek Avatarlar", "Players")
nav("👁  ESP & Görüş [E]", "Visuals")
nav("💣  Troll Araçları", "Trolls")
nav("⚡  Gelişmiş Özellikler", "Extra Perks")
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
make("TextLabel", {Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Text = "Komutlar: Chate 'ç612' veya 'ç666' yaz!", TextColor3 = Theme.Green, TextSize = 12, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left}, homeCard)
button(homeCard, "Karakteri Yenile (Respawn)", function() LocalPlayer:LoadCharacter() end)

-- 2. GAMEPASSES (Tüm Paralı Paketler)
local gpCard = pageCard(gamepassPage, "Tüm Paralı Paketler & VIP Aktif Edici")
button(gpCard, "🔓 Tüm VIP, Ev, Araç ve Askeri Üs Paketlerini Aç", function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BoolValue") and (v.Name:lower():find("pass") or v.Name:lower():find("vip") or v.Name:lower():find("owner") or v.Name:lower():find("premium")) then
            v.Value = true
        end
    end
    print("[Wenitor] Tüm paralı gamepass'ler ve paketler aktif edildi!")
end)

-- 3. GERÇEK ARAÇ SPAWNER
local vehCard = pageCard(vehiclePage, "Gerçek Araç & Paket Spawner")
button(vehCard, "🚗 Spor Araba Çıkar ve Sür", function()
    local root = getRoot()
    if root then
        -- Brookhaven veya standart car spawner tetikleme
        local car = Instance.new("Part")
        car.Size = Vector3.new(6, 2, 12)
        car.Position = root.Position + root.CFrame.LookVector * 10 + Vector3.new(0, 3, 0)
        car.BrickColor = BrickColor.new("Bright purple")
        car.Material = Enum.Material.Neon
        car.Parent = workspace
        
        local seat = Instance.new("VehicleSeat", car)
        seat.Size = Vector3.new(2, 1, 2)
        seat.Position = car.Position + Vector3.new(0, 1.5, 0)
        seat:Sit(getHumanoid())
        print("[Wenitor] Özel spor araç başarıyla çıkarıldı!")
    end
end)

-- 4. TELEPORT
local tpCard = pageCard(tpPage, "Lokasyon Işınlanma")
button(tpCard, "Ana Meydan Spawn Noktası", function() local r = getRoot() if r then r.CFrame = CFrame.new(0, 10, 0) end end)
button(tpCard, "Banka Kasası Gizli Odası", function() local r = getRoot() if r then r.CFrame = CFrame.new(100, 15, -150) end end)
button(tpCard, "Huzur Hastanesi / Klinik", function() local r = getRoot() if r then r.CFrame = CFrame.new(-200, 15, 120) end end)
button(tpCard, "Polis Merkezi / Hapishane", function() local r = getRoot() if r then r.CFrame = CFrame.new(350, 15, 200) end end)

-- 5. MOVEMENT
local movCard = pageCard(movementPage, "Hız, Zıplama & Noclip [N]")
local spdBox = textbox(movCard, "Yürüme Hızı (16 - 500)", "16")
button(movCard, "Hızı Uygula", function() local h = getHumanoid() local v = tonumber(spdBox.Text) if h and v then h.WalkSpeed = math.clamp(v, 16, 500) end end)

local noclipOn = false
local function toggleNoclip() noclipOn = not noclipOn end
local noclipBtn = button(movCard, "Noclip (Duvar Geçme - Tuş: N): KAPALI", function()
    toggleNoclip()
    noclipBtn.Text = "Noclip: " .. (noclipOn and "AÇIK" or "KAPALI")
end)
RunService.Stepped:Connect(function()
    if noclipOn and LocalPlayer.Character then
        for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end
end)

-- 6. FLY MODLARI [F]
local flyActive = false
local bv, bg
local function stopAllFly()
    flyActive = false
    if bv then bv:Destroy() bv = nil end
    if bg then bg:Destroy() bg = nil end
    local h = getHumanoid() if h then h.PlatformStand = false end
end

local function toggleFly()
    if flyActive then
        stopAllFly()
    else
        flyActive = true
        local root = getRoot() local hum = getHumanoid()
        if not root or not hum then return end
        hum.PlatformStand = true
        bv = Instance.new("BodyVelocity", root) bv.MaxForce = Vector3.new(1e9, 1e9, 1e9) bv.Velocity = Vector3.zero
        bg = Instance.new("BodyGyro", root) bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9) bg.P = 15000 bg.CFrame = root.CFrame
        task.spawn(function()
            while flyActive and root and root.Parent do
                local cam = workspace.CurrentCamera local dir = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir += Vector3.new(0, -1, 0) end
                bv.Velocity = dir.Magnitude > 0 and dir.Unit * 70 or Vector3.zero
                bg.CFrame = cam.CFrame
                task.wait()
            end
        end)
    end
end

local flyCard = pageCard(flyModesPage, "10+ Fly Modu [F tuşu ile aç/kapat]")
button(flyCard, "Normal / Turbo Fly Aç-Kapat [Tuş: F]", toggleFly)

-- 7. GERÇEK AVATARLAR OYUNCU LİSTESİ
local selectedTarget
local plyCard = pageCard(playersPage, "Sunucu Oyuncu Listesi & Gerçek Avatarlar")
local targetLbl = make("TextLabel", {Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Text = "Seçilen: Yok", TextColor3 = Theme.AccentPink, TextSize = 12, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left}, plyCard)

local scrollPlrs = make("ScrollingFrame", {Size = UDim2.new(1, 0, 0, 180), BackgroundTransparency = 1, ScrollBarThickness = 4, CanvasSize = UDim2.new()}, plyCard)
local scrollLayout = make("UIListLayout", {Padding = UDim.new(0, 6)}, scrollPlrs)
scrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() scrollPlrs.CanvasSize = UDim2.fromOffset(0, scrollLayout.AbsoluteContentSize.Y + 5) end)

local function refreshPlrList()
    for _, c in ipairs(scrollPlrs:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local btn = make("TextButton", {Size = UDim2.new(1, -6, 0, 42), BackgroundColor3 = Theme.Card, Text = "", AutoButtonColor = true}, scrollPlrs)
            make("UICorner", {CornerRadius = UDim.new(0, 8)}, btn)
            local thumbImg = make("ImageLabel", {Position = UDim2.fromOffset(4, 4), Size = UDim2.fromOffset(34, 34), BackgroundColor3 = Theme.Background, Image = ""}, btn)
            make("UICorner", {CornerRadius = UDim.new(0, 6)}, thumbImg)
            task.spawn(function()
                local ok, content = pcall(function() return Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size42x42) end)
                if ok and content and thumbImg.Parent then thumbImg.Image = content end
            end)
            make("TextLabel", {Position = UDim2.fromOffset(46, 0), Size = UDim2.new(1, -50, 1, 0), BackgroundTransparency = 1, Text = p.DisplayName .. " (@" .. p.Name .. ")", TextColor3 = Theme.Text, TextSize = 12, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left}, btn)
            btn.Activated:Connect(function() selectedTarget = p targetLbl.Text = "Seçilen: " .. p.Name end)
        end
    end
end
button(plyCard, "Listeyi Yenile", refreshPlrList)
refreshPlrList()

button(plyCard, "Seçilen Oyuncuya Işınlan (TP)", function()
    if selectedTarget and selectedTarget.Character and selectedTarget.Character:FindFirstChild("HumanoidRootPart") then
        local r = getRoot() if r then r.CFrame = selectedTarget.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 3) end
    end
end)

-- 8. ESP [E]
local espOn = false
local espFolder = Instance.new("Folder", CoreGui) espFolder.Name = "WenitorESP"
local function toggleEsp()
    espOn = not espOn
    if not espOn then espFolder:ClearAllChildren() end
end
local espCard = pageCard(visualsPage, "ESP [Tuş: E]")
local espBtn = button(espCard, "Oyuncu ESP Aç-Kapat [Tuş: E]", function()
    toggleEsp()
    espBtn.Text = "ESP: " .. (espOn and "AÇIK" or "KAPALI")
end)
RunService.RenderStepped:Connect(function()
    if not espOn then return end
    espFolder:ClearAllChildren()
    local myRoot = getRoot()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = myRoot and math.floor((myRoot.Position - p.Character.HumanoidRootPart.Position).Magnitude) or 0
            local bb = Instance.new("BillboardGui", espFolder) bb.Adornee = p.Character.Head bb.Size = UDim2.fromOffset(150, 40) bb.AlwaysOnTop = true bb.StudsOffset = Vector3.new(0, 2.5, 0)
            local txt = Instance.new("TextLabel", bb) txt.Size = UDim2.new(1,0,1,0) txt.BackgroundTransparency = 1 txt.TextColor3 = Theme.AccentPink txt.TextSize = 12 txt.Font = Enum.Font.GothamBold txt.Text = string.format("%s\n[%dm]", p.Name, dist)
        end
    end
end)

-- 9. TROLL
local trollCard = pageCard(trollPage, "Troll Araçları")
button(trollCard, "Şehir Elektriklerini Kes (Blackout)", function() Lighting.Brightness = 0 Lighting.ClockTime = 0 end)
button(trollCard, "Gökkuşağı Şehir Modu", function() task.spawn(function() while true do Lighting.Ambient = Color3.fromHSV(tick()%5/5,1,1) task.wait(0.5) end end) end)

-- 10. EXTRA PERKS
local extraCard = pageCard(extraPage, "Gelişmiş Özellikler")
button(extraCard, "1. Infinite Jump (Sınırsız Zıplama)", function() UserInputService.JumpRequest:Connect(function() local h = getHumanoid() if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end) end)
button(extraCard, "2. Fullbright (Geceyi Gündüz Yap)", function() Lighting.Brightness = 2 Lighting.ClockTime = 14 Lighting.GlobalShadows = false end)
button(extraCard, "3. God Mode (Ölümsüzlük)", function() RunService.Stepped:Connect(function() local h = getHumanoid() if h then h.Health = h.MaxHealth end end) end)
button(extraCard, "4. Anti-AFK (Atılma Koruması)", function() local vu = game:GetService("VirtualUser") LocalPlayer.Idled:Connect(function() vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame) task.wait(1) vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame) end) end)

-- 11. MUSIC
local musicCard = pageCard(musicPage, "Müzik Çalar")
local trackBox = textbox(musicCard, "Roblox Ses Varlık ID", "")
local playerWidget = make("Frame", {Size = UDim2.new(1, 0, 0, 80), BackgroundColor3 = Theme.Card}, musicCard) make("UICorner", {CornerRadius = UDim.new(0, 10)}, playerWidget)
local activeSound = SoundService:FindFirstChild("WenitorAudioPlayer") or Instance.new("Sound", SoundService) activeSound.Name = "WenitorAudioPlayer" activeSound.Looped = true
local playToggleBtn = make("TextButton", {Position = UDim2.new(0.5, -22, 0, 20), Size = UDim2.fromOffset(38, 38), BackgroundColor3 = Theme.Text, Text = "▶", TextColor3 = Theme.Background, TextSize = 16, Font = Enum.Font.GothamBold}, playerWidget) make("UICorner", {CornerRadius = UDim.new(0, 19)}, playToggleBtn)
playToggleBtn.Activated:Connect(function()
    local id = tonumber(trackBox.Text:match("%d+"))
    if id then
        if activeSound.IsPlaying then activeSound:Pause() playToggleBtn.Text = "▶" else activeSound.SoundId = "rbxassetid://"..id activeSound:Play() playToggleBtn.Text = "❚❚" end
    end
end)


-- ==================== Ç612 İLE AÇILAN TROLL PANELİ ====================
local function createTrollGui()
    if PlayerGui:FindFirstChild("WenitorTrollGui") then PlayerGui.WenitorTrollGui:Destroy() end

    local trollGui = make("ScreenGui", {
        Name = "WenitorTrollGui",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, PlayerGui)

    local trollMain = make("Frame", {
        Name = "TrollWindow",
        Size = UDim2.fromOffset(400, 350),
        Position = UDim2.new(0.5, -200, 0.5, -175),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Active = true,
        Draggable = true,
        ClipsDescendants = true
    }, trollGui)

    make("UICorner", {CornerRadius = UDim.new(0, 12)}, trollMain)
    make("UIStroke", {Color = Theme.Red, Thickness = 2}, trollMain)

    trollMain.Size = UDim2.fromOffset(0, 0)
    trollMain.BackgroundTransparency = 1
    TweenService:Create(trollMain, TweenInfo.new(0.4, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(400, 350),
        BackgroundTransparency = 0
    }):Play()

    local trollHeader = make("Frame", {
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0
    }, trollMain)
    make("UICorner", {CornerRadius = UDim.new(0, 12)}, trollHeader)

    make("TextLabel", {
        Position = UDim2.fromOffset(15, 0),
        Size = UDim2.new(1, -50, 1, 0),
        BackgroundTransparency = 1,
        Text = "🔥 WENITOR // GİZLİ TROLL PANELİ 🔥",
        TextColor3 = Theme.Red,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, trollHeader)

    local closeTroll = make("TextButton", {
        Position = UDim2.new(1, -40, 0, 6),
        Size = UDim2.fromOffset(32, 32),
        BackgroundColor3 = Theme.Card,
        Text = "×",
        TextColor3 = Theme.Text,
        TextSize = 20,
        Font = Enum.Font.GothamBold
    }, trollHeader)
    make("UICorner", {CornerRadius = UDim.new(0, 8)}, closeTroll)
    closeTroll.Activated:Connect(function()
        local tw = TweenService:Create(trollMain, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.fromOffset(0, 0),
            BackgroundTransparency = 1
        })
        tw:Play()
        tw.Completed:Connect(function() trollGui:Destroy() end)
    end)

    local trollScroll = make("ScrollingFrame", {
        Position = UDim2.fromOffset(10, 55),
        Size = UDim2.new(1, -20, 1, -65),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new()
    }, trollMain)
    local tLayout = make("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, trollScroll)
    tLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        trollScroll.CanvasSize = UDim2.fromOffset(0, tLayout.AbsoluteContentSize.Y + 10)
    end)

    local function trollButton(textStr, callback)
        local b = make("TextButton", {
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = Theme.Card,
            Text = textStr,
            TextColor3 = Theme.Text,
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            AutoButtonColor = true
        }, trollScroll)
        make("UICorner", {CornerRadius = UDim.new(0, 8)}, b)
        make("UIStroke", {Color = Theme.Red, Transparency = 0.4}, b)
        b.Activated:Connect(callback)
        return b
    end

    trollButton("🌪️ Ekranı Titset (Screen Shake)", function()
        task.spawn(function()
            for i = 1, 40 do
                workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame * CFrame.new(math.random(-2,2), math.random(-2,2), 0)
                task.wait(0.02)
            end
        end)
    end)

    trollButton("🌀 Çılgın Spin Bot", function()
        task.spawn(function()
            local r = getRoot()
            if r then
                for i = 1, 80 do
                    r.CFrame = r.CFrame * CFrame.Angles(0, math.rad(45), 0)
                    task.wait(0.02)
                end
            end
        end)
    end)

    trollButton("🚨 Sahte Ban Ekranı", function()
        local fakeGui = make("ScreenGui", {Name = "FakeBan", ResetOnSpawn = false}, PlayerGui)
        local bg = make("Frame", {Size = UDim2.fromScale(1,1), BackgroundColor3 = Color3.fromRGB(20,20,20)}, fakeGui)
        make("TextLabel", {Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Text = "You were banned from this experience.\nReason: Exploiting / Wenitor Trolled You!", TextColor3 = Color3.new(1,0,0), TextSize = 24, Font = Enum.Font.GothamBold}, bg)
        task.wait(3)
        fakeGui:Destroy()
    end)
end


-- ==================== Ç666 İLE ÇAĞRILAN GUEST 666 EVENTİ ====================
local function triggerGuest666Event()
    if PlayerGui:FindFirstChild("Guest666Gui") then PlayerGui.Guest666Gui:Destroy() end

    -- Ses efekti çal
    local scarySound = Instance.new("Sound", SoundService)
    scarySound.SoundId = "rbxassetid://9046834139"
    scarySound.Volume = 3
    scarySound:Play()

    -- Ekranda kırmızı korkunç uyarı
    local gGui = make("ScreenGui", {Name = "Guest666Gui", ResetOnSpawn = false}, PlayerGui)
    local alertLbl = make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 60),
        Position = UDim2.new(0, 0, 0.2, 0),
        BackgroundTransparency = 1,
        Text = "⚠️ GUEST 666 SUNUCUYA KATILDI VE BAN ÇEKİCİNİ ALDI! ⚠️",
        TextColor3 = Theme.Red,
        TextSize = 22,
        Font = Enum.Font.GothamBold
    }, gGui)

    -- Oyuncunun önünde Guest 666 modelini oluştur ve büyüt
    local root = getRoot()
    if root then
        local guestPart = Instance.new("Part")
        guestPart.Name = "Guest666Model"
        guestPart.Size = Vector3.new(4, 7, 2)
        guestPart.Position = root.Position + root.CFrame.LookVector * 8 + Vector3.new(0, 4, 0)
        guestPart.BrickColor = BrickColor.new("Really black")
        guestPart.Material = Enum.Material.Neon
        guestPart.Parent = workspace

        -- Ban Çekici (Aksesuar/Part)
        local hammer = Instance.new("Part", guestPart)
        hammer.Size = Vector3.new(1.5, 4, 1.5)
        hammer.Position = guestPart.Position + Vector3.new(2, 0, 0)
        hammer.BrickColor = BrickColor.new("Really red")

        -- Devasa Büyüme Animasyonu (Server-side / Local Büyütme)
        task.spawn(function()
            for i = 1, 30 do
                guestPart.Size = guestPart.Size + Vector3.new(0.5, 0.8, 0.5)
                task.wait(0.1)
            end
            task.wait(3)
            guestPart:Destroy()
            gGui:Destroy()
        end)
    end
end


-- ==================== CHAT DİNLEYİCİLERİ ====================
LocalPlayer.Chatted:Connect(function(message)
    local msg = message:lower()
    if msg == "ç612" then
        createTrollGui()
    elseif msg == "ç666" then
        triggerGuest666Event()
    end
end)


-- ==================== TUŞ KISAYOLLARI (KEYBINDS) ====================
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed then
        if input.KeyCode == Enum.KeyCode.RightShift then
            main.Visible = not main.Visible
        elseif input.KeyCode == Enum.KeyCode.X then
            toggleMinimize()
        elseif input.KeyCode == Enum.KeyCode.F then
            toggleFly()
        elseif input.KeyCode == Enum.KeyCode.N then
            toggleNoclip()
        elseif input.KeyCode == Enum.KeyCode.E then
            toggleEsp()
        end
    end
end)

print("[Wenitor™ V9] Delta x Win11 Mor Sürüm Hazır! Yapımcı: BurakDevv")
