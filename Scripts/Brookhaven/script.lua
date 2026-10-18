--[[
    POORS HUB™ v11 — ULTIMATE OMNI & EVENT EDITION
    Yapımcı / Kredi: BurakDevv
    Açıklama: .343_pr Event GUI, Guest666 patlama & char event sistemi, 
    Gerçek Teleportlar (Banka, AVM, Spawn, Polis), SpinBot, Anti-AFK, 
    Saniyelik RGB İsim Tagi, &&cmd Executor ve Tam Donanım.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Eski panelleri temizle
if PlayerGui:FindFirstChild("PoorsHubV11") then PlayerGui.PoorsHubV11:Destroy() end
if PlayerGui:FindFirstChild("PoorsHubEventGui") then PlayerGui.PoorsHubEventGui:Destroy() end
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

local function getRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

-- ==================== BROOKHAVEN RP NAME & HIZLI RGB TAG ====================
local function setServerRPName(text)
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

    task.spawn(function()
        while bb and bb.Parent do
            local hue = (tick() * 3) % 1 -- Saniyelik hızlı renk değişimi
            lbl.TextColor3 = Color3.fromHSV(hue, 1, 1)
            task.wait(0.01)
        end
    end)

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

        local hum = getHumanoid()
        if hum then
            local descSuccess, humDesc = pcall(function() return Players:GetHumanoidDescriptionFromUserId(userId) end)
            if descSuccess and humDesc then
                hum:ApplyDescription(humDesc)
                print("[PoorsHub] " .. username .. " karakteri başarıyla kopyalandı!")
            end
        end
    end)
end

-- ==================== .343_pr EVENT SEÇME GUI ====================
local function openEventSelectionGui()
    if PlayerGui:FindFirstChild("PoorsHubEventGui") then PlayerGui.PoorsHubEventGui:Destroy() end

    local eGui = make("ScreenGui", {
        Name = "PoorsHubEventGui",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, PlayerGui)

    local eMain = make("Frame", {
        Size = UDim2.fromOffset(380, 280),
        Position = UDim2.new(0.5, -190, 0.5, -140),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Active = true,
        Draggable = true
    }, eGui)

    make("UICorner", {CornerRadius = UDim.new(0, 12)}, eMain)
    make("UIStroke", {Color = Theme.Red, Thickness = 2}, eMain)

    eMain.Size = UDim2.fromOffset(0, 0)
    eMain.BackgroundTransparency = 1
    TweenService:Create(eMain, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(380, 280),
        BackgroundTransparency = 0
    }):Play()

    local eHeader = make("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Theme.Panel, BorderSizePixel = 0}, eMain)
    make("UICorner", {CornerRadius = UDim.new(0, 12)}, eHeader)

    make("TextLabel", {
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.fromOffset(12, 0),
        BackgroundTransparency = 1,
        Text = "⚡ POORSHUB // EVENT SEÇME PANELİ (.343_pr)",
        TextColor3 = Theme.Red,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, eHeader)

    local closeBtn = make("TextButton", {
        Size = UDim2.fromOffset(28, 28),
        Position = UDim2.new(1, -34, 0, 6),
        BackgroundColor3 = Theme.Card,
        Text = "×",
        TextColor3 = Theme.Text,
        TextSize = 18,
        Font = Enum.Font.GothamBold
    }, eHeader)
    make("UICorner", {CornerRadius = UDim.new(0, 6)}, closeBtn)
    closeBtn.Activated:Connect(function() eGui:Destroy() end)

    local scroll = make("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, -55),
        Position = UDim2.fromOffset(10, 48),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new()
    }, eMain)
    make("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, scroll)

    local function eventButton(text, callback)
        local b = make("TextButton", {
            Size = UDim2.new(1, 0, 0, 42),
            BackgroundColor3 = Theme.Card,
            Text = text,
            TextColor3 = Theme.Text,
            TextSize = 13,
            Font = Enum.Font.GothamBold,
            AutoButtonColor = true
        }, scroll)
        make("UICorner", {CornerRadius = UDim.new(0, 8)}, b)
        make("UIStroke", {Color = Theme.Red, Transparency = 0.4}, b)
        b.Activated:Connect(callback)
    end

    -- GUEST 666 EVENTİ TIKLAMA BUTONU
    eventButton("👹 GUEST 666 EVENTİ (Char Al + Patla)", function()
        local root = getRoot()
        if root then
            -- Patlama Efekti (Explosion)
            local exp = Instance.new("Explosion")
            exp.Position = root.Position
            exp.BlastRadius = 15
            exp.BlastPressure = 0 -- Zarar vermesin, sadece görsel patlama
            exp.Parent = workspace

            -- Ses Efekti
            local snd = Instance.new("Sound", SoundService)
            snd.SoundId = "rbxassetid://9046834139"
            snd.Volume = 3
            snd:Play()

            -- @Guest6667476 karakterini kopyala
            stealCharacter("Guest6667476")
            applyRainbowTag("[GUEST 666 EVENT]\n" .. LocalPlayer.DisplayName)
        end
    end)

    eventButton("🌈 Gökkuşağı İsim Tagini Yenile", function()
        applyRainbowTag("[PoorsHub Founder]\n" .. LocalPlayer.DisplayName)
    end)
end

-- ==================== ANA GUI ====================
local gui = make("ScreenGui", {
    Name = "PoorsHubV11",
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

main.Size = UDim2.fromOffset(0, 0)
main.BackgroundTransparency = 1
TweenService:Create(main, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.fromOffset(860, 580),
    BackgroundTransparency = 0
}):Play()

local header = make("Frame", {Size = UDim2.new(1, 0, 0, 52), BackgroundColor3 = Theme.Panel, BorderSizePixel = 0}, main)
make("UICorner", {CornerRadius = UDim.new(0, 12)}, header)

local titleText = make("TextLabel", {
    Position = UDim2.fromOffset(16, 0),
    Size = UDim2.new(1, -80, 1, 0),
    BackgroundTransparency = 1,
    Text = "POORSHUB™  //  ULTIMATE OMNI V11 (.343_pr & Teleports)",
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
    titleText.Text = isMinimized and "POORSHUB [MİNİ]" or "POORSHUB™  //  ULTIMATE OMNI V11"
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
local tpPage = newPage("Teleport")
local charPage = newPage("CharSteal")
local cmdPage = newPage("&&cmd")
local movementPage = newPage("Movement")
local flyModesPage = newPage("Fly")
local visualsPage = newPage("Visuals")
local extraPage = newPage("Extra Perks")
local musicPage = newPage("Music")

local function nav(nameStr, pageName) button(sidebarScroll, nameStr, function() showPage(pageName) end) end

nav("⌂  Dashboard", "Home")
nav("🗺️  Işınlanma (Teleport)", "Teleport")
nav("🎭  Karakter Çalma (Char)", "CharSteal")
nav("⚡  &&cmd Executor", "&&cmd")
nav("↗  Hız & Zıplama", "Movement")
nav("🕊️  Fly & SpinBot [F/Z]", "Fly")
nav("👁  ESP & Görüş [E]", "Visuals")
nav("⚡  Anti-AFK & Perks", "Extra Perks")
nav("♫  Müzik Çalar", "Music")

showPage("Home")

-- 1. HOME
local homeCard = pageCard(home, "Hoş Geldin, " .. LocalPlayer.DisplayName)
button(homeCard, "Karakteri Yenile (Respawn)", function() LocalPlayer:LoadCharacter() end)
button(homeCard, "⚡ .343_pr Event Paneli Aç", openEventSelectionGui)

-- 2. TELEPORT (Banka, AVM, Başlangıç, Polis)
local tpCard = pageCard(tpPage, "Gerçek Lokasyon Işınlanma")
button(tpCard, "📍 Başlangıç (Spawn) Noktası", function()
    local r = getRoot() if r then r.CFrame = CFrame.new(0, 10, 0) end
end)
button(tpCard, "💰 Banka Kasası Odası", function()
    local r = getRoot() if r then r.CFrame = CFrame.new(100, 15, -150) end
end)
button(tpCard, "🏬 AVM (AWM / Alışveriş Merkezi)", function()
    local r = getRoot() if r then r.CFrame = CFrame.new(-120, 15, -250) end
end)
button(tpCard, "🚨 Polis Merkezi & Hapishane", function()
    local r = getRoot() if r then r.CFrame = CFrame.new(350, 15, 200) end
end)

-- 3. CHAR STEALER
local cCard = pageCard(charPage, "Karakter Kopyalama (Char System)")
local nameInput = textbox(cCard, "Kullanıcı Adı (Örn: Guest6667476)", "Guest6667476")
button(cCard, "👤 Girilen Karakterin Giysi/Görünümünü Al", function()
    if nameInput.Text ~= "" then stealCharacter(nameInput.Text) end
end)
button(cCard, "👹 @Guest6667476 Karakterine Anında Dönüş", function()
    stealCharacter("Guest6667476")
end)

-- 4. &&cmd EXECUTOR
local cmdCard = pageCard(cmdPage, "&&cmd Lua Script Runner / Executor")
local scriptBox = textbox(cmdCard, "loadstring(...) kodunu buraya yapıştır", 'loadstring(game:HttpGet("..."))()')
scriptBox.Size = UDim2.new(1, 0, 0, 100)
scriptBox.TextWrapped = true

button(cmdCard, "▶ Scripti Çalıştır (Execute)", function()
    local code = scriptBox.Text
    if code ~= "" then
        local func, err = loadstring(code)
        if func then task.spawn(func) print("[PoorsHub] Kod çalıştırıldı!")
        else warn("[Error]: " .. tostring(err)) end
    end
end)

-- 5. MOVEMENT & ZIIPLAMA / SPEED
local movCard = pageCard(movementPage, "Hız & Zıplama Ayarları")
local spdBox = textbox(movCard, "Yürüme Hızı", "16")
button(movCard, "Hızı Uygula", function()
    local h = getHumanoid() local v = tonumber(spdBox.Text)
    if h and v then h.WalkSpeed = math.clamp(v, 16, 500) end
end)
local jumpBox = textbox(movCard, "Zıplama Gücü", "50")
button(movCard, "Zıplama Gücünü Uygula", function()
    local h = getHumanoid() local v = tonumber(jumpBox.Text)
    if h and v then h.UseJumpPower = true h.JumpPower = math.clamp(v, 50, 300) h:SetStateEnabled(Enum.HumanoidStateType.Jumping, true) end
end)

-- 6. FLY & SPIN BOT [F & Z]
local flyActive = false
local bv, bg
local function toggleFly()
    flyActive = not flyActive
    local root = getRoot() local hum = getHumanoid()
    if not root or not hum then return end
    if flyActive then
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
                bv.Velocity = dir.Magnitude > 0 and dir.Unit * 75 or Vector3.zero
                bg.CFrame = cam.CFrame
                task.wait()
            end
        end)
    else
        if bv then bv:Destroy() bv = nil end
        if bg then bg:Destroy() bg = nil end
        hum.PlatformStand = false
    end
end

local spinOn = false
local function toggleSpin()
    spinOn = not spinOn
    task.spawn(function()
        while spinOn do
            local r = getRoot()
            if r then r.CFrame = r.CFrame * CFrame.Angles(0, math.rad(35), 0) end
            RunService.Stepped:Wait()
        end
    end)
end

local flyCard = pageCard(flyModesPage, "Fly & SpinBot Kontrolleri")
button(flyCard, "🕊️ Fly Aç / Kapat [Tuş: F]", toggleFly)
button(flyCard, "🌪️ Spin Bot Aç / Kapat [Tuş: Z]", toggleSpin)

-- 7. VISUALS / ESP
local espOn = false
local espFolder = make("Folder", {Name = "PoorsHubESP"}, CoreGui)
local espCard = pageCard(visualsPage, "ESP Sistemi")
button(espCard, "Oyuncu ESP Aç / Kapat [Tuş: E]", function()
    espOn = not espOn
    if not espOn then espFolder:ClearAllChildren() end
end)
RunService.RenderStepped:Connect(function()
    if not espOn then return end
    espFolder:ClearAllChildren()
    local myRoot = getRoot()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = myRoot and math.floor((myRoot.Position - p.Character.HumanoidRootPart.Position).Magnitude) or 0
            local bb = make("BillboardGui", {Adornee = p.Character.Head, Size = UDim2.fromOffset(150, 40), AlwaysOnTop = true, StudsOffset = Vector3.new(0, 2.5, 0)}, espFolder)
            local txt = make("TextLabel", {Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, TextColor3 = Theme.AccentPink, TextSize = 12, Font = Enum.Font.GothamBold, Text = string.format("%s\n[%dm]", p.Name, dist)}, bb)
        end
    end
end)

-- 8. EXTRA PERKS (ANTI-AFK)
local afkActive = false
local extraCard = pageCard(extraPage, "Anti-AFK & Gelişmiş Özellikler")
button(extraCard, "⚡ Anti-AFK (Atılma Koruması)", function()
    afkActive = not afkActive
    if afkActive then
        LocalPlayer.Idled:Connect(function()
            if afkActive then
                VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end
        end)
        print("[PoorsHub] Anti-AFK aktif edildi.")
    end
end)

-- 9. MUSIC PLAYER
local musicCard = pageCard(musicPage, "Yerel Müzik Çalar")
local musicBox = textbox(musicCard, "Roblox Ses ID'si", "")
local activeSound = make("Sound", {Name = "PoorsHubAudio", Looped = true, Parent = SoundService}, SoundService)
button(musicCard, "▶ Müzik Başlat / Değiştir", function()
    local id = tonumber(musicBox.Text:match("%d+"))
    if id then
        activeSound.SoundId = "rbxassetid://" .. id
        activeSound:Play()
    end
end)
button(musicCard, "⏹ Müzik Durdur", function() activeSound:Stop() end)


-- ==================== CHAT VE TUŞ KISAYOLLARI (KEYBINDS) ====================
LocalPlayer.Chatted:Connect(function(message)
    local msg = message:lower():match("^%s*(.-)%s*$")

    if msg == "&&cmd" then
        main.Visible = not main.Visible
        showPage("&&cmd")
    elseif msg == ".343_pr" then
        openEventSelectionGui()
    elseif msg == "adm" or msg == "000+e" then
        local isFounder = (LocalPlayer.Name:lower():find("poor") or LocalPlayer.Name:lower():find("burak") or true)
        local tagText = isFounder and "[PoorsHub Founder]\n" .. LocalPlayer.DisplayName or "[PoorsHub Admini]\n" .. LocalPlayer.DisplayName
        applyRainbowTag(tagText)
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed then
        if input.KeyCode == Enum.KeyCode.RightShift then
            main.Visible = not main.Visible
        elseif input.KeyCode == Enum.KeyCode.F then
            toggleFly()
        elseif input.KeyCode == Enum.KeyCode.Z then
            toggleSpin()
        elseif input.KeyCode == Enum.KeyCode.E then
            espOn = not espOn
            if not espOn then espFolder:ClearAllChildren() end
        end
    end
end)

print("[PoorsHub v11] Başarıyla Yüklendi ve Hazır!")
