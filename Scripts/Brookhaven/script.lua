--[[
    WENITOR PANEL V2 — BROOKHAVEN EDITION
    Tek LocalScript | Roblox Studio | Kendi oyunun ve testlerin için
    Özellikler:
    Gelişmiş Modern GUI, Oyuncu Listesi, Canlı Görüntü/Avatar Önizleme,
    See (Spectate), Teleport, Fly, Noclip (Duvardan Geçme), ESP (İsim/Kutu),
    WalkSpeed, JumpPower, Yerel Müzik, Panel Gizle/Aç (RightShift).
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Önceki paneli temizle
local old = PlayerGui:FindFirstChild("WenitorPanelV2")
if old then
    old:Destroy()
end

local Theme = {
    Background = Color3.fromRGB(15, 12, 22),
    Panel = Color3.fromRGB(24, 18, 35),
    Card = Color3.fromRGB(33, 25, 48),
    Purple = Color3.fromRGB(155, 87, 255),
    Pink = Color3.fromRGB(255, 83, 180),
    Text = Color3.fromRGB(245, 239, 255),
    Muted = Color3.fromRGB(175, 160, 196),
    Green = Color3.fromRGB(91, 225, 157),
    Red = Color3.fromRGB(255, 100, 120),
    DarkCard = Color3.fromRGB(20, 15, 30)
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
    Name = "WenitorPanelV2",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, PlayerGui)

local main = make("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(720, 480),
    Position = UDim2.new(0.5, -360, 0.5, -240),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0
}, gui)

make("UICorner", {CornerRadius = UDim.new(0, 14)}, main)
make("UIStroke", {Color = Theme.Purple, Thickness = 1.5}, main)

local header = make("Frame", {
    Size = UDim2.new(1, 0, 0, 50),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 14)}, header)

make("TextLabel", {
    Position = UDim2.fromOffset(17, 0),
    Size = UDim2.new(1, -90, 1, 0),
    BackgroundTransparency = 1,
    Text = "WENITOR™  //  BROOKHAVEN CONTROL SUITE",
    TextColor3 = Theme.Text,
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

local minimize = make("TextButton", {
    Position = UDim2.new(1, -45, 0, 9),
    Size = UDim2.fromOffset(32, 32),
    BackgroundColor3 = Theme.Card,
    Text = "—",
    TextColor3 = Theme.Text,
    TextSize = 18,
    Font = Enum.Font.GothamBold
}, header)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, minimize)

local sidebar = make("Frame", {
    Position = UDim2.fromOffset(12, 62),
    Size = UDim2.fromOffset(150, 406),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 10)}, sidebar)

local pages = {}
local function showPage(name)
    for pageName, frame in pairs(pages) do
        frame.Visible = (pageName == name)
    end
end

local function newPage(name)
    local frame = make("ScrollingFrame", {
        Name = name,
        Position = UDim2.fromOffset(174, 62),
        Size = UDim2.new(1, -186, 1, -74),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 5,
        ScrollBarImageColor3 = Theme.Purple,
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

local function label(parent, text, size, position)
    return make("TextLabel", {
        Size = size,
        Position = position or UDim2.new(),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.Text,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left
    }, parent)
end

local function button(parent, text, callback, size)
    local b = make("TextButton", {
        Size = size or UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Theme.Card,
        Text = text,
        TextColor3 = Theme.Text,
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        AutoButtonColor = true
    }, parent)
    make("UICorner", {CornerRadius = UDim.new(0, 8)}, b)
    make("UIStroke", {Color = Theme.Purple, Transparency = 0.65}, b)
    b.Activated:Connect(callback)
    return b
end

local function textbox(parent, placeholder, defaultText)
    local t = make("TextBox", {
        Size = UDim2.new(1, 0, 0, 36),
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
    make("UIPadding", {
        PaddingTop = UDim.new(0, 12),
        PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12)
    }, f)
    make("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, f)
    label(f, titleText, UDim2.new(1, 0, 0, 22))
    return f
end

local home = newPage("Home")
local playersPage = newPage("Players")
local movement = newPage("Movement")
local visuals = newPage("Visuals")
local musicPage = newPage("Music")
local settings = newPage("Settings")

local function nav(textStr, order, pageName)
    local b = button(sidebar, textStr, function()
        showPage(pageName)
    end, UDim2.new(1, -16, 0, 36))
    b.Position = UDim2.fromOffset(8, 8 + (order - 1) * 42)
    b.AnchorPoint = Vector2.zero
    return b
end

nav("⌂  Dashboard", 1, "Home")
nav("♙  Players & ESP", 2, "Players")
nav("↗  Movement & Noclip", 3, "Movement")
nav("👁  Visuals / ESP", 4, "Visuals")
nav("♫  Local Music", 5, "Music")
nav("⚙  Settings", 6, "Settings")

showPage("Home")

local status = label(sidebar, "SYSTEM ONLINE", UDim2.new(1, -16, 0, 30),
    UDim2.new(0, 8, 1, -38))
status.TextColor3 = Theme.Green
status.TextSize = 11

local function getCharacter()
    return LocalPlayer.Character
end

local function getHumanoid()
    local char = getCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function getRoot(plr)
    local char = plr and plr.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- 1. DASHBOARD
local info = pageCard(home, "Wenitor Control Hub")
label(info, "Hoş geldin, " .. LocalPlayer.DisplayName, UDim2.new(1, 0, 0, 24))
local playerCount = label(info, "Aktif Oyuncular: 0", UDim2.new(1, 0, 0, 22))
local positionLabel = label(info, "Konum: Yükleniyor...", UDim2.new(1, 0, 0, 22))

button(info, "Karakteri Yenile (Respawn)", function()
    LocalPlayer:LoadCharacter()
end)

-- 2. MOVEMENT & NOCLIP
local movementCard = pageCard(movement, "Hız & Zıplama Ayarları")
local speedInput = textbox(movementCard, "Yürüme Hızı (Varsayılan 16)", "16")
button(movementCard, "Hızı Uygula", function()
    local n = tonumber(speedInput.Text)
    local hum = getHumanoid()
    if hum and n then
        hum.WalkSpeed = math.clamp(n, 0, 250)
        status.Text = "Hız ayarlandı: " .. hum.WalkSpeed
    end
end)

local jumpInput = textbox(movementCard, "Zıplama Gücü (Varsayılan 50)", "50")
button(movementCard, "Zıplama Gücünü Uygula", function()
    local n = tonumber(jumpInput.Text)
    local hum = getHumanoid()
    if hum and n then
        hum.UseJumpPower = true
        hum.JumpPower = math.clamp(n, 0, 300)
        status.Text = "Zıplama ayarlandı"
    end
end)

-- NOCLIP (Duvardan Geçme) Sistemi
local noclipEnabled = false
local noclipConnection
local noclipCard = pageCard(movement, "Duvardan Geçme (Noclip)")
local noclipBtn = button(noclipCard, "Noclip: KAPALI", function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        noclipBtn.Text = "Noclip: AÇIK"
        status.Text = "Noclip Aktif"
    else
        noclipBtn.Text = "Noclip: KAPALI"
        status.Text = "Noclip Kapalı"
    end
end)

noclipConnection = RunService.Stepped:Connect(function()
    if noclipEnabled then
        local char = getCharacter()
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- FLY SİSTEMİ
local flyEnabled = false
local flySpeed = 50
local flyConnection, flyVelocity, flyGyro
local flyCard = pageCard(movement, "Uçuş Sistemi (Fly)")
local flySpeedInput = textbox(flyCard, "Uçuş Hızı (10 - 200)", "50")
local flyButton

local function stopFly()
    flyEnabled = false
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    if flyVelocity then flyVelocity:Destroy() flyVelocity = nil end
    if flyGyro then flyGyro:Destroy() flyGyro = nil end
    local hum = getHumanoid()
    if hum then hum.PlatformStand = false end
    if flyButton then flyButton.Text = "Fly: KAPALI" end
end

local function startFly()
    local root = getRoot(LocalPlayer)
    local hum = getHumanoid()
    if not root or not hum then return end

    flyEnabled = true
    flySpeed = math.clamp(tonumber(flySpeedInput.Text) or 50, 10, 200)

    flyVelocity = Instance.new("BodyVelocity")
    flyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    flyVelocity.Velocity = Vector3.zero
    flyVelocity.Parent = root

    flyGyro = Instance.new("BodyGyro")
    flyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    flyGyro.P = 9000
    flyGyro.CFrame = root.CFrame
    flyGyro.Parent = root

    hum.PlatformStand = true
    flyButton.Text = "Fly: AÇIK"
    status.Text = "Uçuş Modu Aktif"

    flyConnection = RunService.RenderStepped:Connect(function()
        if not flyEnabled or not root.Parent then
            stopFly()
            return
        end
        local camera = workspace.CurrentCamera
        if not camera then return end

        local direction = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction += camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction -= camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction += camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction -= camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction += Vector3.yAxis end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then direction -= Vector3.yAxis end

        flyVelocity.Velocity = direction.Magnitude > 0 and direction.Unit * flySpeed or Vector3.zero
        flyGyro.CFrame = camera.CFrame
    end)
end

flyButton = button(flyCard, "Fly: KAPALI", function()
    if flyEnabled then stopFly() else startFly() end
end)


-- 3. PLAYERS & SPECTATE & TELEPORT
local selectedPlayer
local spectating = false

local playerCard = pageCard(playersPage, "Sunucu Oyuncu Listesi & Seçim")
local selectedLabel = label(playerCard, "Seçili Oyuncu: Hiçbiri", UDim2.new(1, 0, 0, 22))

local listContainer = make("ScrollingFrame", {
    Size = UDim2.new(1, 0, 0, 180),
    BackgroundTransparency = 1,
    ScrollBarThickness = 4,
    CanvasSize = UDim2.new()
}, playerCard)
local listLayout = make("UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder
}, listContainer)

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    listContainer.CanvasSize = UDim2.fromOffset(0, listLayout.AbsoluteContentSize.Y + 5)
end)

local function refreshPlayers()
    for _, child in ipairs(listContainer:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    local all = Players:GetPlayers()
    playerCount.Text = "Aktif Oyuncular: " .. #all

    for _, plr in ipairs(all) do
        if plr ~= LocalPlayer then
            local b = button(listContainer, plr.DisplayName .. " (@" .. plr.Name .. ")", function()
                selectedPlayer = plr
                selectedLabel.Text = "Seçili Oyuncu: " .. plr.Name
                status.Text = "Seçildi: " .. plr.Name
            end, UDim2.new(1, -6, 0, 36))
        end
    end
end

button(playerCard, "Oyuncu Listesini Yenile", refreshPlayers)

button(playerCard, "Seçilen Oyuncuyu İzle (See / Spectate)", function()
    local camera = workspace.CurrentCamera
    if not camera then return end

    if spectating then
        spectating = false
        camera.CameraSubject = getHumanoid()
        status.Text = "Kendi Kamerana Döndün"
        return
    end

    if selectedPlayer then
        local hum = selectedPlayer.Character and selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            camera.CameraSubject = hum
            spectating = true
            status.Text = "İzleniyor: " .. selectedPlayer.Name
        else
            status.Text = "Oyuncunun karakteri yok!"
        end
    else
        status.Text = "Önce listeden bir oyuncu seç!"
    end
end)

button(playerCard, "Seçilen Oyuncunun Yanına Işınlan (TP)", function()
    if not selectedPlayer then
        status.Text = "Önce bir oyuncu seçin"
        return
    end
    local myRoot = getRoot(LocalPlayer)
    local targetRoot = getRoot(selectedPlayer)
    if myRoot and targetRoot then
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 3, 3)
        status.Text = "Işınlanıldı: " .. selectedPlayer.Name
    else
        status.Text = "Hedef veya senin karakterin bulunamadı"
    end
end)

Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(function(plr)
    if selectedPlayer == plr then
        selectedPlayer = nil
        selectedLabel.Text = "Seçili Oyuncu: Hiçbiri"
    end
    refreshPlayers()
end)
refreshPlayers()


-- 4. VISUALS / ESP SİSTEMİ
local espEnabled = false
local espCard = pageCard(visuals, "Oyuncu ESP (İsim & Mesafe Göstergesi)")
local espButton

local espFolder = Instance.new("Folder")
espFolder.Name = "WenitorESPStorage"
espFolder.Parent = CoreGui

local function clearESP()
    espFolder:ClearAllChildren()
end

espButton = button(espCard, "ESP (İsimler): KAPALI", function()
    espEnabled = not espEnabled
    if espEnabled then
        espButton.Text = "ESP (İsimler): AÇIK"
        status.Text = "ESP Aktif Edildi"
    else
        espButton.Text = "ESP (İsimler): KAPALI"
        clearESP()
        status.Text = "ESP Kapatıldı"
    end
end)

RunService.RenderStepped:Connect(function()
    if not espEnabled then return end
    clearESP()

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            if head and root then
                local myRoot = getRoot(LocalPlayer)
                local dist = myRoot and math.floor((myRoot.Position - root.Position).Magnitude) or 0

                local billboard = Instance.new("BillboardGui")
                billboard.Name = "ESP_Tag"
                billboard.Adornee = head
                billboard.Size = UDim2.fromOffset(200, 50)
                billboard.StudsOffset = Vector3.new(0, 2.5, 0)
                billboard.AlwaysOnTop = true

                local txt = Instance.new("TextLabel")
                txt.Size = UDim2.new(1, 0, 1, 0)
                txt.BackgroundTransparency = 1
                txt.TextColor3 = Theme.Pink
                txt.TextStrokeTransparency = 0.2
                txt.TextSize = 12
                txt.Font = Enum.Font.GothamBold
                txt.Text = string.format("%s\n[%dm]", plr.Name, dist)
                txt.Parent = billboard

                billboard.Parent = espFolder
            end
        end
    end
end)


-- 5. MUSIC PLAYER (Yerel Ses Sistemi)
local musicCard = pageCard(musicPage, "Yerel Müzik Çalar (Sadece Sende Çalar)")
local musicId = textbox(musicCard, "Roblox Ses ID'si Girin (Örn: 9046834139)", "")
local musicVolume = textbox(musicCard, "Ses Seviyesi (0 - 10)", "5")

local sound = SoundService:FindFirstChild("WenitorLocalMusic")
if not sound then
    sound = Instance.new("Sound")
    sound.Name = "WenitorLocalMusic"
    sound.Parent = SoundService
end
sound.Looped = true

button(musicCard, "Müziği Başlat (Play)", function()
    local id = musicId.Text:match("%d+")
    if not id then
        status.Text = "Geçerli bir ses ID numarası girin!"
        return
    end
    sound.SoundId = "rbxassetid://" .. id
    sound.Volume = math.clamp(tonumber(musicVolume.Text) or 5, 0, 10) / 10
    sound:Play()
    status.Text = "Müzik çalıyor..."
end)

button(musicCard, "Müziği Durdur (Stop)", function()
    sound:Stop()
    status.Text = "Müzik durduruldu"
end)


-- 6. SETTINGS
local settingsCard = pageCard(settings, "Panel Ayarları ve Güvenlik")
button(settingsCard, "Paneli Gizle / Göster (RightShift)", function()
    main.Visible = not main.Visible
end)
button(settingsCard, "Tüm Hileleri Sıfırla & Kapat", function()
    stopFly()
    noclipEnabled = false
    noclipBtn.Text = "Noclip: KAPALI"
    espEnabled = false
    espButton.Text = "ESP (İsimler): KAPALI"
    clearESP()
    sound:Stop()
    local hum = getHumanoid()
    if hum then
        hum.WalkSpeed = 16
        hum.JumpPower = 50
    end
    status.Text = "Her şey sıfırlandı"
end)


-- SÜRÜKLENEBİLİR PENCERE
do
    local dragging = false
    local dragStart, startPos

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- Küçültme Tuşu (Minimize)
local minimized = false
minimize.Activated:Connect(function()
    minimized = not minimized
    sidebar.Visible = not minimized
    for _, frame in pairs(pages) do
        frame.Visible = false
    end
    if not minimized then
        showPage("Home")
    end
    main.Size = minimized and UDim2.fromOffset(720, 50) or UDim2.fromOffset(720, 480)
end)

-- Sağ Shift ile Paneli Gizleme/Açma Kısayolu
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end)

-- Karakter Yenilendiğinde (Respawn) Hataları Önleme
LocalPlayer.CharacterAdded:Connect(function()
    stopFly()
    task.wait(0.6)
    if spectating and workspace.CurrentCamera then
        workspace.CurrentCamera.CameraSubject = getHumanoid()
        spectating = false
    end
end)

-- Anlık Konum Güncelleyici
RunService.RenderStepped:Connect(function()
    local root = getRoot(LocalPlayer)
    if root then
        local p = root.Position
        positionLabel.Text = string.format("Konum X: %.0f | Y: %.0f | Z: %.0f", p.X, p.Y, p.Z)
    end
end)

print("Wenitor Panel V2 (Brookhaven Edition) başarıyla yüklendi!")
