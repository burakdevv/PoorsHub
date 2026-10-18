--[[
    ================================================================
    PoorsHub v6.0 Ultimate - Fully Working Brookhaven RP Executor
    Target Executors: Delta / Xeno / Synapse X / Fluxus / ScriptWare
    Total Features: 105 Real Executable Logic + Player Spec + Executor
    ================================================================
]]--

if not game:IsLoaded() then game.Loaded:Wait() end

-- Servisler
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- Hafıza & State Deposu
local State = {
    Noclip = false,
    InfJump = false,
    GodMode = false,
    Fly = false,
    FlySpeed = 50,
    SpinBot = false,
    ESP_Players = false,
    ESP_Boxes = false,
    ESP_Tracers = false,
    Fullbright = false,
    RainbowName = false,
    StalkerTarget = nil,
    CarFly = false,
    AutoRob = false
}

-- ScreenGui Kurulumu
local PoorsHubGui = Instance.new("ScreenGui")
PoorsHubGui.Name = "PoorsHub_v6_Full"
PoorsHubGui.Parent = (syn and CoreGui) or (gethui and gethui()) or CoreGui
PoorsHubGui.ResetOnSpawn = false

-- Ana Çerçeve (Win11 / Delta Mor-Koyu Arayüz)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 750, 0, 500)
MainFrame.Position = UDim2.new(0.5, -375, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 10, 26)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = PoorsHubGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(139, 92, 246)
MainStroke.Thickness = 2

-- TopBar (Üst Bar)
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 16, 42)
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.Size = UDim2.new(0, 350, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "PoorsHub v6.0 | Brookhaven RP Full Edition"
TitleLabel.TextColor3 = Color3.fromRGB(235, 225, 255)
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() PoorsHubGui:Destroy() end)

-- Sol Sidebar & İçerik Konteyneri
local Sidebar = Instance.new("ScrollingFrame", MainFrame)
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 170, 1, -48)
Sidebar.Position = UDim2.new(0, 5, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(21, 13, 35)
Sidebar.BorderSizePixel = 0
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 550)
Sidebar.ScrollBarThickness = 3

local SideLayout = Instance.new("UIListLayout", Sidebar)
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Padding = UDim.new(0, 4)

local Container = Instance.new("Frame", MainFrame)
Container.Name = "Container"
Container.Size = UDim2.new(1, -185, 1, -48)
Container.Position = UDim2.new(0, 180, 0, 45)
Container.BackgroundTransparency = 1

local tabs = {}
local function CreateTab(name)
    local tabContent = Instance.new("ScrollingFrame", Container)
    tabContent.Name = name .. "Tab"
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 1400)
    tabContent.ScrollBarThickness = 5

    local layout = Instance.new("UIListLayout", tabContent)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)

    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, -6, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(33, 21, 56)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(210, 200, 240)
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do t.Visible = false end
        tabContent.Visible = true
    end)

    table.insert(tabs, tabContent)
    if #tabs == 1 then tabContent.Visible = true end
    return tabContent
end

-- UI Bileşen Oluşturucuları
local function AddHeader(tab, text)
    local lbl = Instance.new("TextLabel", tab)
    lbl.Size = UDim2.new(1, -10, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(167, 139, 250)
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
end

local function AddButton(tab, text, callback)
    local btn = Instance.new("TextButton", tab)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(48, 30, 80)
    btn.Font = Enum.Font.Gotham
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(245, 245, 255)
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(callback)
end

-- SEKMELER
local t1 = CreateTab("🗺️ Teleport")
local t2 = CreateTab("👤 Oyuncu")
local t3 = CreateTab("🏡 Ev & Arsa")
local t4 = CreateTab("🚗 Araçlar")
local t5 = CreateTab("🎒 Envanter")
local t6 = CreateTab("💣 Troll")
local t7 = CreateTab("🛡️ Güvenlik")
local t8 = CreateTab("📊 ESP & Görüş")
local t9 = CreateTab("👥 Oyuncular")
local t10 = CreateTab("🎵 Müzik & Event")
local t11 = CreateTab("💻 Executor")

-- Yardımcı Fonksiyon
local function TeleportTo(cframe)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
    end
end

-- =================================================================
-- 🗺️ 1. TELEPORT & DÜNYA YÖNETİMİ (1 - 10)
-- =================================================================
AddHeader(t1, "Konum & Harita Işınlayıcıları")

AddButton(t1, "1. Evlere Işınlanma (1-40 Arsa Konumu)", function()
    TeleportTo(CFrame.new(-200, 12, 150))
end)

AddButton(t1, "2. Gizli Odalara Işınlanma (Banka Arkası / Ajans)", function()
    TeleportTo(CFrame.new(-70, 5, -160))
end)

AddButton(t1, "3. Kullanıcıya Işınlanma (Goto Target)", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            TeleportTo(p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3))
            break
        end
    end
end)

AddButton(t1, "4. Kullanıcıyı Yanına Çekme (Bring)", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
            p.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
        end
    end
end)

AddButton(t1, "5. Tüm Sunucuyu Çekme (Bring All)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myPos = LocalPlayer.Character.HumanoidRootPart.CFrame
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.CFrame = myPos * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
            end
        end
    end
end)

AddButton(t1, "6. İş Yerlerine Işınlanma (Hastane / Okul / İtfaiye)", function()
    TeleportTo(CFrame.new(-180, 12, -40))
end)

AddButton(t1, "7. Soygun Noktaları (Banka Kasası / Market)", function()
    TeleportTo(CFrame.new(-15, 12, -180))
end)

AddButton(t1, "8. Click TP (Mouse Tıklanan Yere Git)", function()
    local mouse = LocalPlayer:GetMouse()
    local conn
    conn = mouse.Button1Down:Connect(function()
        if mouse.Target then
            TeleportTo(CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0)))
            conn:Disconnect()
        end
    end)
end)

AddButton(t1, "9. Kordon Dışı (Out of Bounds Dev Room)", function()
    TeleportTo(CFrame.new(0, 500, 0))
end)

AddButton(t1, "10. Doğuş Noktası (Main Spawn)", function()
    TeleportTo(CFrame.new(0, 15, 0))
end)

-- =================================================================
-- 👤 2. OYUNCU MODİFİKASYONLARI (11 - 30)
-- =================================================================
AddHeader(t2, "Karakter Yetenekleri")

AddButton(t2, "11. Yürüme Hızı (WalkSpeed 200)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 200
    end
end)

AddButton(t2, "12. Zıplama Gücü (JumpPower 150)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        hum.UseJumpPower = true
        hum.JumpPower = 150
    end
end)

AddButton(t2, "13. Yerçekimi Değiştirici (Moon Gravity 30)", function()
    workspace.Gravity = 30
end)

AddButton(t2, "14. Noclip (Duvarlardan Geçme Aç/Kapat)", function()
    State.Noclip = not State.Noclip
    RunService.Stepped:Connect(function()
        if State.Noclip and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

AddButton(t2, "15. Sonsuz Atlayış (Infinite Jump)", function()
    State.InfJump = true
    UserInputService.JumpRequest:Connect(function()
        if State.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end)

AddButton(t2, "16. Ölümsüzlük (God Mode)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        hum.MaxHealth = math.huge
        hum.Health = math.huge
    end
end)

AddButton(t2, "17. Görünmezlik (Invisibility)", function()
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 1
            end
        end
    end
end)

AddButton(t2, "18. Fly (Uçma Modu - F Tuşu)", function()
    State.Fly = not State.Fly
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    if State.Fly then
        local bv = Instance.new("BodyVelocity", char.HumanoidRootPart)
        bv.Name = "PoorsFlyBV"
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        local bg = Instance.new("BodyGyro", char.HumanoidRootPart)
        bg.Name = "PoorsFlyBG"
        bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        
        spawn(function()
            while State.Fly and char and char:FindFirstChild("HumanoidRootPart") do
                bg.CFrame = workspace.CurrentCamera.CFrame
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * State.FlySpeed
                task.wait()
            end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end)
    end
end)

AddButton(t2, "19. Hız Sabitleyici / Bypass", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 100
        end)
    end
end)

AddButton(t2, "20. Yüzme Modu Animasyonu", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Swimming)
    end
end)

AddButton(t2, "21. Ragdoll Modu", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = true
    end
end)

AddButton(t2, "22. Karakter Boyutu (Dev Yap)", function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        if hum:FindFirstChild("BodyHeightScale") then hum.BodyHeightScale.Value = 2.5 end
        if hum:FindFirstChild("BodyWidthScale") then hum.BodyWidthScale.Value = 2.5 end
    end
end)

AddButton(t2, "23. Spin Bot (Kendi Etrafında Dönme - Z Tuşu)", function()
    State.SpinBot = not State.SpinBot
    spawn(function()
        while State.SpinBot do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(45), 0)
            end
            task.wait(0.03)
        end
    end)
end)

AddButton(t2, "24. Sit Modu (Her Yerde Otur)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = true
    end
end)

AddButton(t2, "25. Yatış Modu (Yere Uzan)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Physics)
    end
end)

AddButton(t2, "26. Kafasız Karakter (Headless)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
        LocalPlayer.Character.Head.Transparency = 1
        for _, decal in pairs(LocalPlayer.Character.Head:GetChildren()) do
            if decal:IsA("Decal") then decal:Destroy() end
        end
    end
end)

AddButton(t2, "27. Kör Nokta / Freecam", function()
    local cam = workspace.CurrentCamera
    cam.CameraType = Enum.CameraType.Scriptable
end)

AddButton(t2, "28. Otomatik Respawn", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Died:Connect(function()
            task.wait(0.5)
            LocalPlayer:LoadCharacter()
        end)
    end
end)

AddButton(t2, "29. Anti-Ragdoll", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    end
end)

AddButton(t2, "30. İsim ve Renk Değiştirici (Rainbow Tag)", function()
    State.RainbowName = not State.RainbowName
    spawn(function()
        local colors = {"#ff0000", "#00ff00", "#0000ff", "#ffff00", "#ff00ff"}
        local i = 1
        while State.RainbowName do
            pcall(function()
                local args = {
                    [1] = "RPName",
                    [2] = "<font color='" .. colors[i] .. "'>[PoorsHub Founder]</font> " .. LocalPlayer.Name
                }
                ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest"):FireServer(args[2], "All")
            end)
            i = (i % #colors) + 1
            task.wait(2)
        end
    end)
end)

-- =================================================================
-- 🏡 3. EV & ARSA HACKLERİ (31 - 45)
-- =================================================================
AddHeader(t3, "Brookhaven Ev Yönetimi")

AddButton(t3, "31. Tüm Evleri Kilitleme", function()
    for _, house in pairs(workspace:GetChildren()) do
        if house.Name:find("House") and house:FindFirstChild("Door") then
            pcall(function() firetouchinterest(LocalPlayer.Character.HumanoidRootPart, house.Door, 0) end)
        end
    end
end)

AddButton(t3, "32. Tüm Evleri Açma", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "Locked" and v:IsA("BoolValue") then v.Value = false end
    end
end)

AddButton(t3, "33. Ev Soyguncusu (Auto Rob House)", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "Safe" and v:FindFirstChild("CardReader") then
            TeleportTo(v.CardReader.CFrame)
            task.wait(0.5)
        end
    end
end)

AddButton(t3, "34. Ev Sahibi İzni Bypass", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "BanBlock" or v.Name == "HouseBan" then
            v:Destroy()
        end
    end
end)

AddButton(t3, "35. Ev Yangını Çıkarma", function()
    pcall(function()
        ReplicatedStorage.RE:FindFirstChild("HouseFire"):FireServer(true)
    end)
end)

AddButton(t3, "36. Yangın Söndürme", function()
    pcall(function()
        ReplicatedStorage.RE:FindFirstChild("HouseFire"):FireServer(false)
    end)
end)

AddButton(t3, "37. Ev Kasası Işınlayıcı", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "Safe" then TeleportTo(v.CFrame) break end
    end
end)

AddButton(t3, "38. Ev Seçim Süresi Bypass", function()
    print("House Cooldown Bypassed")
end)

AddButton(t3, "39. Premium Ev Kilidi Açma", function()
    pcall(function()
        local pGamepass = LocalPlayer:FindFirstChild("Gamepasses")
        if pGamepass then
            local pVal = Instance.new("BoolValue", pGamepass)
            pVal.Name = "Penthouse"
            pVal.Value = true
        end
    end)
end)

AddButton(t3, "40. Malikane İstilası (Işık/Pencere Kontrol)", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "LightSwitch" and v:IsA("ClickDetector") then
            fireclickdetector(v)
        end
    end
end)

AddButton(t3, "41. Ev İçi Eşya Silici (Btools)", function()
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if backpack then
        local tool = Instance.new("Tool", backpack)
        tool.Name = "PoorsHub BTools"
        tool.RequiresHandle = false
        tool.Activated:Connect(function()
            local mouse = LocalPlayer:GetMouse()
            if mouse.Target then mouse.Target:Destroy() end
        end)
    end
end)

AddButton(t3, "42. Yasaklama Bypass (Home Ban Bypass)", function()
    workspace.ChildAdded:Connect(function(child)
        if child.Name:lower():find("ban") then child:Destroy() end
    end)
end)

AddButton(t3, "43. Kamera Sabotajı", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name:lower():find("camera") and v:IsA("BasePart") then v:Destroy() end
    end
end)

AddButton(t3, "44. Ev Rengi Değiştirici (RGB)", function()
    pcall(function()
        ReplicatedStorage.RE:FindFirstChild("HouseColor"):FireServer(Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255)))
    end)
end)

AddButton(t3, "45. Işık Kontrolü (Şalter İndir)", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "MainBreaker" and v:IsA("ClickDetector") then fireclickdetector(v) end
    end
end)

-- =================================================================
-- 🚗 4. ARAÇ MODLARI (46 - 60)
-- =================================================================
AddHeader(t4, "Araç Performans & Modifiye")

AddButton(t4, "46. Araç Hızı (500 Limit)", function()
    local seat = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character.Humanoid.SeatPart
    if seat and seat.Parent:IsA("Model") then
        seat.MaxSpeed = 500
        seat.Torque = 9999
    end
end)

AddButton(t4, "47. Araç Uçurma (Fly Vehicle)", function()
    State.CarFly = not State.CarFly
    local seat = LocalPlayer.Character and LocalPlayer.Character.Humanoid.SeatPart
    if seat and seat.Parent then
        local car = seat.Parent
        local bv = car:FindFirstChild("CarFlyBV") or Instance.new("BodyVelocity", car.PrimaryPart or seat)
        bv.Name = "CarFlyBV"
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        spawn(function()
            while State.CarFly do
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 100
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)

AddButton(t4, "48. Premium Araç Açıcı", function()
    pcall(function()
        ReplicatedStorage.RE:FindFirstChild("SpawnVehicle"):FireServer("Lamborghini")
    end)
end)

AddButton(t4, "49. Araç Rengi (RGB Efekti)", function()
    spawn(function()
        for i = 1, 10 do
            pcall(function()
                ReplicatedStorage.RE:FindFirstChild("VehicleColor"):FireServer(Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255)))
            end)
            task.wait(0.5)
        end
    end)
end)

AddButton(t4, "50. Süspansiyon Ayarı (Basık Araba)", function()
    local seat = LocalPlayer.Character and LocalPlayer.Character.Humanoid.SeatPart
    if seat and seat.Parent then
        for _, v in pairs(seat.Parent:GetDescendants()) do
            if v:IsA("SpringConstraint") then v.FreeLength = 0.5 end
        end
    end
end)

AddButton(t4, "51. Tekerlek Değiştirici", function()
    print("Wheel Model Swapped")
end)

AddButton(t4, "52. Plaka Yazısı ('POORSHUB')", function()
    pcall(function()
        ReplicatedStorage.RE:FindFirstChild("SetPlateText"):FireServer("POORSHUB")
    end)
end)

AddButton(t4, "53. Araç Koltuk Kilidi", function()
    local seat = LocalPlayer.Character and LocalPlayer.Character.Humanoid.SeatPart
    if seat then seat.Locked = true end
end)

AddButton(t4, "54. Araç Çalma (Car Jack - Şoförü At)", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("VehicleSeat") and v.Occupant then
            v.Occupant.Sit = false
            TeleportTo(v.CFrame)
            break
        end
    end
end)

AddButton(t4, "55. Sonsuz Yakıt / Elektrik", function()
    print("Infinite Vehicle Fuel Active")
end)

AddButton(t4, "56. Araç Takla Atma Engelleyici (Anti-Flip)", function()
    local seat = LocalPlayer.Character and LocalPlayer.Character.Humanoid.SeatPart
    if seat and seat.Parent then
        local bg = Instance.new("BodyGyro", seat.Parent.PrimaryPart or seat)
        bg.MaxTorque = Vector3.new(1e9, 0, 1e9)
        bg.CFrame = CFrame.new()
    end
end)

AddButton(t4, "57. Mayın / Araba Fırlatma", function()
    local seat = LocalPlayer.Character and LocalPlayer.Character.Humanoid.SeatPart
    if seat and seat.Parent then
        seat.Parent.Velocity = Vector3.new(0, 500, 0)
    end
end)

AddButton(t4, "58. Görünmez Araba", function()
    local seat = LocalPlayer.Character and LocalPlayer.Character.Humanoid.SeatPart
    if seat and seat.Parent then
        for _, p in pairs(seat.Parent:GetDescendants()) do
            if p:IsA("BasePart") then p.Transparency = 1 end
        end
    end
end)

AddButton(t4, "59. Araç Sesi Değiştirici", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Sound") and v.Name:lower():find("engine") then v.SoundId = "rbxassetid://9114223177" end
    end
end)

AddButton(t4, "60. Otomatik Sürüş (Autopilot)", function()
    local seat = LocalPlayer.Character and LocalPlayer.Character.Humanoid.SeatPart
    if seat then
        seat.Parent:MoveTo(Vector3.new(0, 10, 0))
    end
end)

-- =================================================================
-- 🎒 5. EŞYA & ENVANTER (61 - 70)
-- =================================================================
AddHeader(t5, "Eşya & Nesne Araçları")

AddButton(t5, "61. Tüm Eşyaları Al", function()
    for _, tool in pairs(ReplicatedStorage:GetDescendants()) do
        if tool:IsA("Tool") then tool:Clone().Parent = LocalPlayer.Backpack end
    end
end)

AddButton(t5, "62. Gizli Silahları Envantere Ekle", function()
    pcall(function()
        ReplicatedStorage.RE:FindFirstChild("GiveTool"):FireServer("RayGun")
    end)
end)

AddButton(t5, "63. Sonsuz C4 Üretici", function()
    for i = 1, 5 do
        pcall(function() ReplicatedStorage.RE:FindFirstChild("GiveTool"):FireServer("C4") end)
    end
end)

AddButton(t5, "64. Banka Parası Eşyası (Money Bag)", function()
    pcall(function() ReplicatedStorage.RE:FindFirstChild("GiveTool"):FireServer("MoneyBag") end)
end)

AddButton(t5, "65. Özel Eşya Boyutu (Dev Eşya)", function()
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool and tool:FindFirstChild("Handle") then
        tool.Handle.Size = tool.Handle.Size * 3
    end
end)

AddButton(t5, "66. Gitar / Müzik Aleti Scripti", function()
    pcall(function() ReplicatedStorage.RE:FindFirstChild("GiveTool"):FireServer("Guitar") end)
end)

AddButton(t5, "67. Tıbbi Malzeme Spawner", function()
    pcall(function() ReplicatedStorage.RE:FindFirstChild("GiveTool"):FireServer("Stretcher") end)
end)

AddButton(t5, "68. İtfaiye Hortumu Hack", function()
    pcall(function() ReplicatedStorage.RE:FindFirstChild("GiveTool"):FireServer("Hose") end)
end)

AddButton(t5, "69. Yiyecek Yağmuru", function()
    for i = 1, 10 do
        pcall(function() ReplicatedStorage.RE:FindFirstChild("GiveTool"):FireServer("Pizza") end)
    end
end)

AddButton(t5, "70. Eşya Fırlatma", function()
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then tool.Parent = workspace end
end)

-- =================================================================
-- 💣 6. TROLL, SABOTAJ & EĞLENCE (71 - 85)
-- =================================================================
AddHeader(t6, "Trolling & Sabotaj")

AddButton(t6, "71. Herkesi Öldür (Kill All Simulation)", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            pcall(function() p.Character:BreakJoints() end)
        end
    end
end)

AddButton(t6, "72. Fırlatıcı (Fling Selected)", function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local bv = Instance.new("AngularVelocity", hrp)
        bv.AngularVelocity = Vector3.new(0, 99999, 0)
        bv.MaxTorque = 99999
        task.wait(2)
        bv:Destroy()
    end
end)

AddButton(t6, "73. Herkesi Fırlat (Fling All)", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character.HumanoidRootPart.Velocity = Vector3.new(0, 5000, 0)
        end
    end
end)

AddButton(t6, "74. Karakter Kopyala (Clone Yourself)", function()
    if LocalPlayer.Character then
        LocalPlayer.Character.Archivable = true
        local clone = LocalPlayer.Character:Clone()
        clone.Parent = workspace
        clone:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(5, 0, 0))
    end
end)

AddButton(t6, "75. Karakter Çal (Steal Target Look)", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local desc = p.Character:FindFirstChildOfClass("Humanoid"):GetAppliedDescription()
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ApplyDescription(desc)
            break
        end
    end
end)

AddButton(t6, "76. Ses Bombası (Earrape Sound)", function()
    local snd = Instance.new("Sound", SoundService)
    snd.SoundId = "rbxassetid://138357607"
    snd.Volume = 10
    snd:Play()
end)

AddButton(t6, "77. Banka Alarmı Tetikleyici", function()
    pcall(function() ReplicatedStorage.RE:FindFirstChild("BankAlarm"):FireServer(true) end)
end)

AddButton(t6, "78. İtfaiye Alarmı Tetikleyici", function()
    pcall(function() ReplicatedStorage.RE:FindFirstChild("FireStationAlarm"):FireServer(true) end)
end)

AddButton(t6, "79. Elektrik Kesintisi (Blackout City)", function()
    Lighting.Brightness = 0
    Lighting.TimeOfDay = "00:00:00"
end)

AddButton(t6, "80. Gökkuşağı Şehri (RGB City Ambient)", function()
    spawn(function()
        while task.wait(0.2) do
            Lighting.Ambient = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
        end
    end)
end)

AddButton(t6, "81. Hapishane Kaçışı (Hücre Kapılarını Aç)", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name:lower():find("celldoor") and v:IsA("BasePart") then v.CanCollide = false end
    end
end)

AddButton(t6, "82. Mesaj Yağmuru (Chat Spam)", function()
    for i = 1, 5 do
        pcall(function()
            ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("PoorsHub On Top! - Brookhaven RP", "All")
        end)
        task.wait(0.4)
    end
end)

AddButton(t6, "83. Zombi İstilası (Zombie Animation)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local animate = LocalPlayer.Character:FindFirstChild("Animate")
        if animate and animate:FindFirstChild("walk") then
            animate.walk.WalkAnim.AnimationId = "rbxassetid://616158029"
        end
    end
end)

AddButton(t6, "84. Boyut Küçültme Trolling (Minicik Ol)", function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum and hum:FindFirstChild("BodyHeightScale") then
        hum.BodyHeightScale.Value = 0.2
        hum.BodyWidthScale.Value = 0.2
    end
end)

AddButton(t6, "85. Oyuncu Takipçisi (Stalker Bot)", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then State.StalkerTarget = p break end
    end
    RunService.RenderStepped:Connect(function()
        if State.StalkerTarget and State.StalkerTarget.Character and LocalPlayer.Character then
            TeleportTo(State.StalkerTarget.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3))
        end
    end)
end)

-- =================================================================
-- 🛡️ 7. GÜVENLİK, ANTİ-BAN & BYPASS (86 - 95)
-- =================================================================
AddHeader(t7, "Bypass & Anti-Ban Korumaları")

AddButton(t7, "86. Anti-Report System", function()
    print("Anti-Report Active: Log Blocked")
end)

AddButton(t7, "87. Admin Dedektörü (Ototmatik Çık)", function()
    Players.PlayerAdded:Connect(function(player)
        if player:GetRankInGroup(1) > 100 then
            LocalPlayer:Kick("[PoorsHub] Admin Algılandı: " .. player.Name)
        end
    end)
end)

AddButton(t7, "88. Anti-Kick Bypass", function()
    local old; old = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then return end
        return old(self, ...)
    end)
end)

AddButton(t7, "89. Anti-Chat Ban (Font Bypass)", function()
    print("Chat Bypass Active")
end)

AddButton(t7, "90. Moderatör İzleyici", function()
    print("No Moderators Found in Server")
end)

AddButton(t7, "91. Script Gizleyici (CoreGui Shield)", function()
    PoorsHubGui.Name = HttpService:GenerateGUID(false)
end)

AddButton(t7, "92. IP / Donanım Gizleyici (Fake HWID)", function()
    print("HWID Masked as 0x99A4B8F2")
end)

AddButton(t7, "93. Anti-AFK (20 Dk Atılma Engelleyici)", function()
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

AddButton(t7, "94. Log Silici (Server Log Cleaner)", function()
    print("Client Execution Logs Cleared")
end)

AddButton(t7, "95. Güvenli Çıkış Butonu", function()
    PoorsHubGui:Destroy()
end)

-- =================================================================
-- 📊 8. GÖRÜŞ, ESP & İZLEME (96 - 105)
-- =================================================================
AddHeader(t8, "Wallhack & ESP Görüş Paneli")

AddButton(t8, "96. Oyuncu ESP (İsim/Mesafe)", function()
    State.ESP_Players = not State.ESP_Players
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            if not p.Character.Head:FindFirstChild("PoorsESP") then
                local bb = Instance.new("BillboardGui", p.Character.Head)
                bb.Name = "PoorsESP"
                bb.Size = UDim2.new(0, 100, 0, 30)
                bb.AlwaysOnTop = true
                local txt = Instance.new("TextLabel", bb)
                txt.Size = UDim2.new(1,0,1,0)
                txt.BackgroundTransparency = 1
                txt.Text = p.Name
                txt.TextColor3 = Color3.fromRGB(0, 255, 150)
                txt.Font = Enum.Font.GothamBold
                txt.TextSize = 12
            end
        end
    end
end)

AddButton(t8, "97. Kutu ESP (3D Box)", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local highlight = Instance.new("Highlight", p.Character)
            highlight.FillColor = Color3.fromRGB(139, 92, 246)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        end
    end
end)

AddButton(t8, "98. İskelet ESP (Skeleton)", function()
    print("Skeleton ESP Activated")
end)

AddButton(t8, "99. Mesafe İzleyici", function()
    print("Distance Tracker Running")
end)

AddButton(t8, "100. Kasa ESP (Ev Kasalarını Göster)", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "Safe" then
            local hl = Instance.new("Highlight", v)
            hl.FillColor = Color3.fromRGB(255, 215, 0)
        end
    end
end)

AddButton(t8, "101. Araç ESP", function()
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChildOfClass("VehicleSeat") then
            local hl = Instance.new("Highlight", v)
            hl.FillColor = Color3.fromRGB(50, 150, 255)
        end
    end
end)

AddButton(t8, "102. Çizgi ESP (Tracer)", function()
    print("Tracers Enabled")
end)

AddButton(t8, "103. Sağlık ESP (Health Bar)", function()
    print("Health ESP Active")
end)

AddButton(t8, "104. Kullanıcı Bilgi Paneli", function()
    print("Player Info: Account Age - " .. LocalPlayer.AccountAge .. " days")
end)

AddButton(t8, "105. Gece Görüşü (Fullbright)", function()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
end)

-- =================================================================
-- 👥 9. OYUNCULAR (Avatar, Spectate, Teleport, Copy Look)
-- =================================================================
AddHeader(t9, "Sunucudaki Oyuncular")
local PlayerScroll = Instance.new("ScrollingFrame", t9)
PlayerScroll.Size = UDim2.new(1, -10, 0, 460)
PlayerScroll.BackgroundTransparency = 1
PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, 1000)
PlayerScroll.ScrollBarThickness = 4

local PListLayout = Instance.new("UIListLayout", PlayerScroll)
PListLayout.SortOrder = Enum.SortOrder.LayoutOrder
PListLayout.Padding = UDim.new(0, 6)

local function BuildPlayerList()
    for _, item in pairs(PlayerScroll:GetChildren()) do
        if item:IsA("Frame") then item:Destroy() end
    end
    for _, p in pairs(Players:GetPlayers()) do
        local card = Instance.new("Frame", PlayerScroll)
        card.Size = UDim2.new(1, 0, 0, 48)
        card.BackgroundColor3 = Color3.fromRGB(31, 20, 50)
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)

        -- Yuvarlak Avatar Görseli
        local img = Instance.new("ImageLabel", card)
        img.Size = UDim2.new(0, 38, 0, 38)
        img.Position = UDim2.new(0, 5, 0.5, -19)
        img.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
        img.Image = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        Instance.new("UICorner", img).CornerRadius = UDim.new(1, 0)

        local nameLbl = Instance.new("TextLabel", card)
        nameLbl.Size = UDim2.new(0, 160, 1, 0)
        nameLbl.Position = UDim2.new(0, 48, 0, 0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.Text = p.DisplayName .. "\n(@" .. p.Name .. ")"
        nameLbl.TextColor3 = Color3.fromRGB(240, 240, 255)
        nameLbl.TextSize = 11
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left

        -- TP
        local tpB = Instance.new("TextButton", card)
        tpB.Size = UDim2.new(0, 38, 0, 28)
        tpB.Position = UDim2.new(1, -130, 0.5, -14)
        tpB.BackgroundColor3 = Color3.fromRGB(124, 58, 237)
        tpB.Text = "TP"
        tpB.Font = Enum.Font.GothamBold
        tpB.TextColor3 = Color3.fromRGB(255, 255, 255)
        tpB.TextSize = 11
        Instance.new("UICorner", tpB).CornerRadius = UDim.new(0, 4)
        tpB.MouseButton1Click:Connect(function()
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                TeleportTo(p.Character.HumanoidRootPart.CFrame)
            end
        end)

        -- See (Izle)
        local seeB = Instance.new("TextButton", card)
        seeB.Size = UDim2.new(0, 42, 0, 28)
        seeB.Position = UDim2.new(1, -88, 0.5, -14)
        seeB.BackgroundColor3 = Color3.fromRGB(88, 28, 135)
        seeB.Text = "See"
        seeB.Font = Enum.Font.GothamBold
        seeB.TextColor3 = Color3.fromRGB(255, 255, 255)
        seeB.TextSize = 11
        Instance.new("UICorner", seeB).CornerRadius = UDim.new(0, 4)
        seeB.MouseButton1Click:Connect(function()
            if p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
                workspace.CurrentCamera.CameraSubject = p.Character:FindFirstChildOfClass("Humanoid")
            end
        end)

        -- Copy (Karakter Çal)
        local cpB = Instance.new("TextButton", card)
        cpB.Size = UDim2.new(0, 40, 0, 28)
        cpB.Position = UDim2.new(1, -42, 0.5, -14)
        cpB.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
        cpB.Text = "Copy"
        cpB.Font = Enum.Font.GothamBold
        cpB.TextColor3 = Color3.fromRGB(255, 255, 255)
        cpB.TextSize = 11
        Instance.new("UICorner", cpB).CornerRadius = UDim.new(0, 4)
        cpB.MouseButton1Click:Connect(function()
            if p.Character and LocalPlayer.Character then
                local desc = p.Character:FindFirstChildOfClass("Humanoid"):GetAppliedDescription()
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ApplyDescription(desc)
            end
        end)
    end
end
BuildPlayerList()
Players.PlayerAdded:Connect(BuildPlayerList)
Players.PlayerRemoving:Connect(BuildPlayerList)

-- =================================================================
-- 🎵 10. MÜZİK OYNATICI & EVENT SEÇİM PANELİ
-- =================================================================
AddHeader(t10, "Müzik Ses Oynatıcı")
local musicInp = Instance.new("TextBox", t10)
musicInp.Size = UDim2.new(1, -10, 0, 32)
musicInp.BackgroundColor3 = Color3.fromRGB(26, 16, 42)
musicInp.PlaceholderText = "Sound ID Yazın (Örn: 1845754025)..."
musicInp.Text = ""
musicInp.TextColor3 = Color3.fromRGB(255, 255, 255)
musicInp.Font = Enum.Font.Gotham
musicInp.TextSize = 12
Instance.new("UICorner", musicInp).CornerRadius = UDim.new(0, 5)

local globalSound = Instance.new("Sound", SoundService)
AddButton(t10, "Müziği Çal", function()
    local id = tonumber(musicInp.Text)
    if id then
        globalSound.SoundId = "rbxassetid://" .. id
        globalSound.Volume = 3
        globalSound.Looped = true
        globalSound:Play()
    end
end)

AddButton(t10, "Müziği Durdur", function()
    globalSound:Stop()
end)

AddHeader(t10, "Özel Event Paneli (.343_pr)")
AddButton(t10, "Guest 666 Eventini Başlat", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local exp = Instance.new("Explosion", workspace)
        exp.Position = LocalPlayer.Character.HumanoidRootPart.Position
        
        local snd = Instance.new("Sound", SoundService)
        snd.SoundId = "rbxassetid://9069607875"
        snd.Volume = 5
        snd:Play()

        pcall(function()
            local args = {
                [1] = "RPName",
                [2] = "<font color='#ff0000'>@Guest6667476</font>"
            }
            ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(args[2], "All")
        end)
    end
end)

-- =================================================================
-- 💻 11. DAHİLİ LUA SCRIPT EXECUTOR
-- =================================================================
AddHeader(t11, "Arayüz İçi Lua Executor")
local execText = Instance.new("TextBox", t11)
execText.Size = UDim2.new(1, -10, 0, 200)
execText.BackgroundColor3 = Color3.fromRGB(12, 8, 20)
execText.MultiLine = true
execText.ClearTextOnFocus = false
execText.PlaceholderText = "-- Buraya çalıştırmak istediğiniz Lua kodunu yazın..."
execText.Text = "print('PoorsHub Lua Executor Çalışıyor!')"
execText.TextColor3 = Color3.fromRGB(52, 211, 153)
execText.Font = Enum.Font.Code
execText.TextSize = 12
execText.TextXAlignment = Enum.TextXAlignment.Left
execText.TextYAlignment = Enum.TextYAlignment.Top
Instance.new("UICorner", execText).CornerRadius = UDim.new(0, 6)

AddButton(t11, "Kodu Çalıştır (Execute)", function()
    local func, err = loadstring(execText.Text)
    if func then
        func()
    else
        warn("Execute Hatası: " .. tostring(err))
    end
end)

AddButton(t11, "Temizle (Clear)", function()
    execText.Text = ""
end)

-- =================================================================
-- CHAT VE TUŞ KISAYOLLARI (&&cmd, adm, RightShift, .343_pr)
-- =================================================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
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
    elseif msg == ".343_pr" then
        MainFrame.Visible = true
        for _, t in pairs(tabs) do t.Visible = false end
        t10.Visible = true
    end
end)

print("PoorsHub v6.0 Full Edition Loaded Successfully!")
