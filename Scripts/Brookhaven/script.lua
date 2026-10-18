--[[
    POORS HUB™ v10 — OMNI CHAR STEALER & RUNNER EDITION
    Yapımcı / Kredi: BurakDevv
    Açıklama: Herkesin görebileceği RP Name entegrasyonu, Karakter Kopyalama (Char),
    &&cmd Loadstring Executor, Saniyelik RGB İsim Tagi ve Tüm Legacy Özellikler.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Temizlik
if PlayerGui:FindFirstChild("PoorsHubV10") then PlayerGui.PoorsHubV10:Destroy() end
if CoreGui:FindFirstChild("PoorsHubRainbowOverhead") then CoreGui.PoorsHubRainbowOverhead:Destroy() end

local Theme = {
    Background = Color3.fromRGB(18, 14, 28),
    Panel = Color3.fromRGB(28, 20, 42),
    Card = Color3.fromRGB(40, 28, 60),
    AccentPurple = Color3.fromRGB(147, 51, 234),
    AccentPink = Color3.fromRGB(236, 72, 153),
    Text = Color3.fromRGB(245, 243, 255),
    Muted = Color3.fromRGB(167, 139, 250),
    Green = Color3.fromRGB(74, 222, 128),
    Red = Color3.fromRGB(248, 113, 113)
}

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end

-- ==================== HERKESİN GÖRECEĞİ BROOKHAVEN RP NAME & SANİYELİK RGB TAG ====================
local function setServerRPName(text)
    -- Brookhaven RemoteEvent Yakalama (Tüm sunucu görsün diye RP İsmine aktarır)
    pcall(function()
        local RE = ReplicatedStorage:FindFirstChild("RE") or ReplicatedStorage:FindFirstChild("RobloxReplicatedStorage")
        if RE and RE:FindFirstChild("1RPNam1e") then
            RE["1RPNam1e"]:FireServer(text)
        elseif RE and RE:FindFirstChild("RPName") then
            RE["RPName"]:FireServer(text)
        end
    end)
end

local function applyRainbowTag(targetText)
    local char = LocalPlayer.Character
    if not char then return end
    local head = char:WaitForChild("Head", 5)
    if not head then return end

    if head:FindFirstChild("PoorsHubOverhead") then head.PoorsHubOverhead:Destroy() end

    local bb = make("BillboardGui", {
        Name = "PoorsHubOverhead",
        Adornee = head,
        Size = UDim2.fromOffset(250, 60),
        StudsOffset = Vector3.new(0, 3.2, 0),
        AlwaysOnTop = true
    }, head)

    local lbl = make("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = targetText or "[PoorsHub User]\n" .. LocalPlayer.DisplayName,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextStrokeTransparency = 0.1
    }, bb)

    -- Saniyelik Hızlı Gökkuşağı (RGB) Geçişi
    task.spawn(function()
        while bb and bb.Parent do
            local hue = (tick() * 2) % 1 -- Çok daha hızlı renk değişimi
            lbl.TextColor3 = Color3.fromHSV(hue, 1, 1)
            task.wait(0.01)
        end
    end)

    -- Brookhaven RP İsmine de gönder
    setServerRPName(targetText:gsub("\n", " - "))
end

-- ==================== KARAKTER KOPYALAMA (CHAR STEALER) ====================
local function stealCharacter(username)
    task.spawn(function()
        local success, userId = pcall(function() return Players:GetUserIdFromNameAsync(username) end)
        if not success or not userId then 
            print("[PoorsHub] Kullanıcı bulunamadı: " .. tostring(username))
            return 
        end

        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            local descSuccess, humDesc = pcall(function() return Players:GetHumanoidDescriptionFromUserId(userId) end)
            if descSuccess and humDesc then
                hum:ApplyDescription(humDesc)
                print("[PoorsHub] " .. username .. " karakteri başarıyla kopyalandı!")
            end
        end
    end)
end

-- ==================== ANA GUI (WIN11 / DELTA STYLE) ====================
local gui = make("ScreenGui", {
    Name = "PoorsHubV10",
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

-- Başlık
local header = make("Frame", {Size = UDim2.new(1, 0, 0, 52), BackgroundColor3 = Theme.Panel, BorderSizePixel = 0}, main)
make("UICorner", {CornerRadius = UDim.new(0, 12)}, header)

local titleText = make("TextLabel", {
    Position = UDim2.fromOffset(16, 0),
    Size = UDim2.new(1, -80, 1, 0),
    BackgroundTransparency = 1,
    Text = "POORSHUB™  //  ULTIMATE OMNI V10 (Chate &&cmd veya adm yaz)",
    TextColor3 = Theme.Text,
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

local isMinimized = false
local sidebarScroll = make("ScrollingFrame", {Position = UDim2.fromOffset(12, 64), Size = UDim2.fromOffset(165, 504), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, CanvasSize = UDim2.new()}, main)

local function toggleMinimize()
    isMinimized = not isMinimized
    sidebarScroll.Visible = not isMinimized
    for _, p in pairs(main:GetChildren()) do
        if p:IsA("ScrollingFrame") and p ~= sidebarScroll then p.Visible = not isMinimized end
    end
    TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = isMinimized and UDim2.fromOffset(280, 52) or UDim2.fromOffset(860, 580)
    }):Play()
    titleText.Text = isMinimized and "POORSHUB [MİNİ]" or "POORSHUB™  //  ULTIMATE OMNI V10"
end

local minBtn = make("TextButton", {Position = UDim2.new(1, -44, 0, 10), Size = UDim2.fromOffset(32, 32), BackgroundColor3 = Theme.Card, Text = "-", TextColor3 = Theme.Text, TextSize = 20, Font = Enum.Font.GothamBold}, header)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, minBtn)
minBtn.Activated:Connect(toggleMinimize)

local sidebarLayout = make("UIListLayout", {Padding = UDim.new(0, 6)}, sidebarScroll)
sidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() sidebarScroll.CanvasSize = UDim2.fromOffset(0, sidebarLayout.AbsoluteContentSize.Y + 10) end)

local pages = {}
local function showPage(name) for pName, frame in pairs(pages) do frame.Visible = (pName == name) end end

local function newPage(name)
    local frame = make("ScrollingFrame", {Name = name, Position = UDim2.fromOffset(189, 64), Size = UDim2.new(1, -201, 1, -76), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 5, ScrollBarImageColor3 = Theme.AccentPurple, CanvasSize = UDim2.new(), Visible = false}, main)
    local layout = make("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder}, frame)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() frame.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 16) end)
    pages[name] = frame
    return frame
end

local function button(parent, textStr, callback)
    local b = make("TextButton", {Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Theme.Card, Text = textStr, TextColor3 = Theme.Text, TextSize = 12, Font = Enum.Font.GothamSemibold, AutoButtonColor = true}, parent)
    make("UICorner", {CornerRadius = UDim.new(0, 8)}, b)
    make("UIStroke", {Color = Theme.AccentPurple, Transparency = 0.5}, b)
    b.Activated:Connect(callback)
    return b
end

local function textbox(parent, placeholder, defaultText)
    local t = make("TextBox", {Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Theme.Card, Text = defaultText or "", PlaceholderText = placeholder, PlaceholderColor3 = Theme.Muted, TextColor3 = Theme.Text, TextSize = 12, Font = Enum.Font.Gotham, ClearTextOnFocus = false}, parent)
    make("UICorner", {CornerRadius = UDim.new(0, 8)}, t)
    return t
end

local function pageCard(parent, titleText)
    local f = make("Frame", {Size = UDim2.new(1, -6, 0, 100), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Theme.Panel, BorderSizePixel = 0}, parent)
    make("UICorner", {CornerRadius = UDim.new(0, 10)}, f)
    make("UIPadding", {PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12)}, f)
    make("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, f)
    make("TextLabel", {Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Text = titleText, TextColor3 = Theme.Text, TextSize = 14, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left}, f)
    return f
end

-- SEKMELER
local home = newPage("Home")
local charPage = newPage("CharSteal")
local cmdPage = newPage("&&cmd")
local gamepassPage = newPage("Gamepasses")
local movementPage = newPage("Movement")
local flyModesPage = newPage("Fly")
local playersPage = newPage("Players")
local visualsPage = newPage("Visuals")

local function nav(nameStr, pageName) button(sidebarScroll, nameStr, function() showPage(pageName) end) end

nav("⌂  Dashboard", "Home")
nav("🎭  Karakter Çalma (Char)", "CharSteal")
nav("⚡  &&cmd Executor", "&&cmd")
nav("🎁  Paralı Paketler", "Gamepasses")
nav("↗  Karakter & Zıplama", "Movement")
nav("🕊️  Fly Modları [F]", "Fly")
nav("♙  Gerçek Avatarlar", "Players")
nav("👁  ESP & Görüş [E]", "Visuals")

showPage("Home")

-- 1. HOME
local homeCard = pageCard(home, "Hoş Geldin, " .. LocalPlayer.DisplayName)
button(homeCard, "Karakteri Yenile (Respawn)", function() LocalPlayer:LoadCharacter() end)

-- 2. KARAKTER ÇALMA (CHAR STEALER)
local cCard = pageCard(charPage, "Karakter Kopyalama (Char System)")
local nameInput = textbox(cCard, "Kopyalanacak Kullanıcı Adı (Örn: Guest6667476)", "Guest6667476")
button(cCard, "👤 Seçilen Karakterin Giysi/Görünümünü Al", function()
    if nameInput.Text ~= "" then
        stealCharacter(nameInput.Text)
    end
end)
button(cCard, "👹 @Guest6667476 Karakterine Dönüş", function()
    stealCharacter("Guest6667476")
end)

-- 3. &&cmd LOADSTRING EXECUTOR GUI
local cmdCard = pageCard(cmdPage, "&&cmd Lua Script Runner / Executor")
local scriptBox = textbox(cmdCard, "loadstring(...) veya Raw Lua Kodunu Buraya Yapıştır", 'loadstring(game:HttpGet("https://raw.githubusercontent.com/..."))()')
scriptBox.Size = UDim2.new(1, 0, 0, 100)
scriptBox.TextWrapped = true

button(cmdCard, "▶ Scripti Çalıştır (Execute)", function()
    local code = scriptBox.Text
    if code ~= "" then
        local func, err = loadstring(code)
        if func then
            task.spawn(func)
            print("[PoorsHub] Kod başarıyla çalıştırıldı!")
        else
            warn("[PoorsHub Execution Error]: " .. tostring(err))
        end
    end
end)

-- 4. PARALI PAKETLER
local gpCard = pageCard(gamepassPage, "Tüm Gamepass & Paketler")
button(gpCard, "🔓 Tüm VIP ve Mülk Paketlerini Aç", function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BoolValue") and (v.Name:lower():find("pass") or v.Name:lower():find("vip") or v.Name:lower():find("owner")) then
            v.Value = true
        end
    end
end)

-- 5. MOVEMENT & ZIPLAMA FİX
local movCard = pageCard(movementPage, "Hız & Zıplama Ayarları (Fix)")
local spdBox = textbox(movCard, "Yürüme Hızı", "16")
button(movCard, "Hızı Uygula", function()
    local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local v = tonumber(spdBox.Text)
    if h and v then h.WalkSpeed = math.clamp(v, 16, 500) end
end)
local jumpBox = textbox(movCard, "Zıplama Gücü", "50")
button(movCard, "Zıplama Gücünü Uygula (Fix)", function()
    local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local v = tonumber(jumpBox.Text)
    if h and v then
        h.UseJumpPower = true
        h.JumpPower = math.clamp(v, 50, 300)
        h:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
    end
end)

-- 6. FLY
local flyActive = false
local bv, bg
local function stopFly()
    flyActive = false
    if bv then bv:Destroy() bv = nil end
    if bg then bg:Destroy() bg = nil end
    local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h then h.PlatformStand = false end
end
local function toggleFly()
    if flyActive then stopFly() else
        flyActive = true
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
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
local flyCard = pageCard(flyModesPage, "Fly [F]")
button(flyCard, "Fly Aç / Kapat [Tuş: F]", toggleFly)

-- 7. GERÇEK AVATARLAR (Size150x150 Fix)
local plyCard = pageCard(playersPage, "Gerçek Oyuncu Avatarları")
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
                local ok, content = pcall(function() return Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150) end)
                if ok and content and thumbImg.Parent then thumbImg.Image = content end
            end)
            make("TextLabel", {Position = UDim2.fromOffset(46, 0), Size = UDim2.new(1, -50, 1, 0), BackgroundTransparency = 1, Text = p.DisplayName .. " (@" .. p.Name .. ")", TextColor3 = Theme.Text, TextSize = 12, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left}, btn)
        end
    end
end
button(plyCard, "Listeyi Yenile", refreshPlrList)
refreshPlrList()

-- ==================== CHAT TETİKLEYİCİLERİ ====================
LocalPlayer.Chatted:Connect(function(message)
    local msg = message:lower():match("^%s*(.-)%s*$")

    if msg == "&&cmd" then
        main.Visible = not main.Visible
        showPage("&&cmd")
    elseif msg == "adm" or msg == "000+e" then
        local isFounder = (LocalPlayer.Name:lower():find("poor") or LocalPlayer.Name:lower():find("burak") or true)
        local tagText = isFounder and "[PoorsHub Founder]\n" .. LocalPlayer.DisplayName or "[PoorsHub Admini]\n" .. LocalPlayer.DisplayName
        applyRainbowTag(tagText)
    elseif msg == "ç612" then
        showPage("CharSteal")
    elseif msg == "ç666" then
        stealCharacter("Guest6667476")
        applyRainbowTag("[GUEST 666]\n" .. LocalPlayer.DisplayName)
    end
end)

-- Keybinds
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed then
        if input.KeyCode == Enum.KeyCode.RightShift then main.Visible = not main.Visible
        elseif input.KeyCode == Enum.KeyCode.F then toggleFly() end
    end
end)

print("[PoorsHub v10] Başarıyla Yüklendi!")
