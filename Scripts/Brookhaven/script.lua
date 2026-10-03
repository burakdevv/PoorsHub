local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local ParentGui
if gethui then
    ParentGui = gethui()
elseif game:FindFirstChild("CoreGui") then
    ParentGui = game:GetService("CoreGui")
else
    ParentGui = LocalPlayer:FindFirstChild("PlayerGui")
end

if ParentGui:FindFirstChild("PoorsHubModern") then
    ParentGui:FindFirstChild("PoorsHubModern"):Destroy()
end

local Colors = {
    Background = Color3.fromRGB(15, 15, 15),
    Red = Color3.fromRGB(200, 0, 0),
    RedDark = Color3.fromRGB(90, 0, 0),
    Text = Color3.fromRGB(235, 235, 235),
    Button = Color3.fromRGB(28, 28, 28)
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PoorsHubModern"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = ParentGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 380)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -190)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Colors.Red
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Active = true
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Poors Hub Modern Version By BurakDevv"
Title.TextColor3 = Colors.Text
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 28, 0, 24)
MinimizeBtn.Position = UDim2.new(1, -62, 0, 4)
MinimizeBtn.BackgroundColor3 = Colors.Button
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Colors.Text
MinimizeBtn.TextSize = 16
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 24)
CloseBtn.Position = UDim2.new(1, -32, 0, 4)
CloseBtn.BackgroundColor3 = Colors.RedDark
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Colors.Text
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 34)
TabBar.Position = UDim2.new(0, 0, 0, 32)
TabBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 4)
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.Parent = TabBar

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -66)
ContentFrame.Position = UDim2.new(0, 0, 0, 66)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local Dragging, DragStart, StartPos = false, nil, nil
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

local Minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    ContentFrame.Visible = not Minimized
    TabBar.Visible = not Minimized
    MainFrame.Size = Minimized and UDim2.new(0, 520, 0, 32) or UDim2.new(0, 520, 0, 380)
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local Tabs = {}
local function CreateTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 124, 1, 0)
    btn.BackgroundColor3 = Colors.Button
    btn.Text = name
    btn.TextColor3 = Colors.Text
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = TabBar

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -20, 1, -20)
    page.Position = UDim2.new(0, 10, 0, 10)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Colors.Red
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = ContentFrame

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 6)
    list.Parent = page

    Tabs[name] = {Button = btn, Page = page}
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            t.Button.BackgroundColor3 = Colors.Button
        end
        page.Visible = true
        btn.BackgroundColor3 = Colors.RedDark
    end)
    return page
end

local function CreateButton(parent, text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 34)
    b.BackgroundColor3 = Colors.Button
    b.Text = text
    b.TextColor3 = Colors.Text
    b.TextSize = 13
    b.Font = Enum.Font.Gotham
    b.BorderSizePixel = 0
    b.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = b

    local s = Instance.new("UIStroke")
    s.Color = Colors.RedDark
    s.Thickness = 1
    s.Parent = b

    b.MouseButton1Click:Connect(function()
        b.BackgroundColor3 = Colors.RedDark
        task.wait(0.15)
        b.BackgroundColor3 = Colors.Button
        callback()
    end)
    return b
end

local function CreateToggle(parent, text, callback)
    local state = false
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 34)
    b.BackgroundColor3 = Colors.Button
    b.Text = text .. "  [OFF]"
    b.TextColor3 = Colors.Text
    b.TextSize = 13
    b.Font = Enum.Font.Gotham
    b.BorderSizePixel = 0
    b.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = b

    local s = Instance.new("UIStroke")
    s.Color = Colors.RedDark
    s.Thickness = 1
    s.Parent = b

    b.MouseButton1Click:Connect(function()
        state = not state
        b.Text = text .. (state and "  [ON]" or "  [OFF]")
        b.TextColor3 = state and Colors.Red or Colors.Text
        callback(state)
    end)
    return b
end

local function CreateSlider(parent, text, min, max, default, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Colors.Text
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 0, 14)
    bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    bar.BorderSizePixel = 0
    bar.Parent = parent

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 6)
    barCorner.Parent = bar

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Colors.Red
    fill.BorderSizePixel = 0
    fill.Parent = bar

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 6)
    fillCorner.Parent = fill

    local draggingSlider = false
    local function update(input)
        local rel = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * rel)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        label.Text = text .. ": " .. tostring(val)
        callback(val)
    end
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
            update(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end)
    return bar
end

local Tab1 = CreateTab("Server & Audio")
local Tab2 = CreateTab("Player / Motion")
local Tab3 = CreateTab("Visuals & Char")
local Tab4 = CreateTab("Network & Sniffer")

local MusicPlaying = false
local Sound = Instance.new("Sound")
Sound.Name = "PoorsHubMusic"
Sound.SoundId = "rbxassetid://18483545"
Sound.Volume = 1
Sound.Looped = true
Sound.Parent = game:GetService("SoundService")

CreateButton(Tab1, "Muzigi Baslat (Play)", function()
    Sound:Play()
    MusicPlaying = true
end)

CreateButton(Tab1, "Muzigi Durdur (Stop)", function()
    Sound:Stop()
    MusicPlaying = false
end)

CreateSlider(Tab1, "Ses Seviyesi", 0, 10, 1, function(v)
    Sound.Volume = v
end)

local chatBox = Instance.new("TextBox")
chatBox.Size = UDim2.new(1, 0, 0, 34)
chatBox.BackgroundColor3 = Colors.Button
chatBox.PlaceholderText = "Chat mesajini buraya yaz..."
chatBox.Text = ""
chatBox.TextColor3 = Colors.Text
chatBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
chatBox.TextSize = 13
chatBox.Font = Enum.Font.Gotham
chatBox.ClearTextOnFocus = false
chatBox.BorderSizePixel = 0
chatBox.Parent = Tab1

local chatCorner = Instance.new("UICorner")
chatCorner.CornerRadius = UDim.new(0, 6)
chatCorner.Parent = chatBox

CreateButton(Tab1, "Mesaji Gonder", function()
    local msg = chatBox.Text
    if msg == "" then return end
    local sent = false
    local TextChatService = game:GetService("TextChatService")
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local channel = TextChatService:FindFirstChild("TextChannels") and TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        if channel and channel:IsA("TextChannel") then
            channel:SendAsync(msg)
            sent = true
        end
    end
    if not sent then
        local events = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if events and events.SayMessageRequest then
            events.SayMessageRequest:FireServer(msg, "All")
            sent = true
        else
            for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                if v:IsA("RemoteEvent") and v.Name:lower():find("saymessage") then
                    v:FireServer(msg, "All")
                    sent = true
                    break
                end
            end
        end
    end
end)

local getChar = function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        return char, char.Humanoid, char.HumanoidRootPart
    end
    return nil, nil, nil
end

local FlyConnection, BodyVelocity, BodyGyro = nil, nil, nil
CreateToggle(Tab2, "Fly (WASD ile uc)", function(on)
    local char, humanoid, hrp = getChar()
    if not char then return end
    if on then
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        BodyVelocity.Velocity = Vector3.zero
        BodyVelocity.Parent = hrp

        BodyGyro = Instance.new("BodyGyro")
        BodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        BodyGyro.P = 1e4
        BodyGyro.Parent = hrp

        FlyConnection = RunService.RenderStepped:Connect(function()
            local c, hum, root = getChar()
            if not c or not BodyVelocity then return end
            local cam = workspace.CurrentCamera
            local moveDir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
            BodyVelocity.Velocity = moveDir * 60
            BodyGyro.CFrame = cam.CFrame
        end)
    else
        if FlyConnection then FlyConnection:Disconnect() FlyConnection = nil end
        if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end
        if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
    end
end)

local WalkSpeedVal = 16
CreateSlider(Tab2, "WalkSpeed", 16, 200, 16, function(v)
    WalkSpeedVal = v
    local _, hum = getChar()
    if hum and WalkSpeedEnabled then hum.WalkSpeed = v end
end)

local WalkSpeedEnabled = false
CreateToggle(Tab2, "Speed Hack", function(on)
    WalkSpeedEnabled = on
    local _, hum = getChar()
    if hum then hum.WalkSpeed = on and WalkSpeedVal or 16 end
end)

local JumpVal = 50
CreateSlider(Tab2, "Jump Power", 50, 300, 50, function(v)
    JumpVal = v
    local _, hum = getChar()
    if hum and JumpEnabled then hum.UseJumpPower = true hum.JumpPower = v end
end)

local JumpEnabled = false
CreateToggle(Tab2, "Jump Power Hack", function(on)
    JumpEnabled = on
    local _, hum = getChar()
    if hum then
        hum.UseJumpPower = true
        hum.JumpPower = on and JumpVal or 50
    end
end)

local ESPEnabled = false
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "PoorsHubESP"
ESPFolder.Parent = ScreenGui

local function ApplyESP(char, color)
    if char and not char:FindFirstChild("PoorsHubHighlight") then
        local hl = Instance.new("Highlight")
        hl.Name = "PoorsHubHighlight"
        hl.FillColor = color
        hl.OutlineColor = Colors.Red
        hl.FillTransparency = 0.6
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = char
    end
end

local function ClearESP()
    for _, v in pairs(ESPFolder:GetChildren()) do v:Destroy() end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("PoorsHubHighlight") then
            plr.Character.PoorsHubHighlight:Destroy()
        end
    end
end

CreateToggle(Tab3, "Player ESP", function(on)
    ESPEnabled = on
    if not on then ClearESP() return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            ApplyESP(plr.Character, Color3.fromHSV(math.random(), 1, 1))
        end
    end
end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        task.wait(1)
        if ESPEnabled and plr ~= LocalPlayer then
            ApplyESP(char, Color3.fromHSV(math.random(), 1, 1))
        end
    end)
end)

for _, plr in pairs(Players:GetPlayers()) do
    plr.CharacterAdded:Connect(function(char)
        task.wait(1)
        if ESPEnabled and plr ~= LocalPlayer then
            ApplyESP(char, Color3.fromHSV(math.random(), 1, 1))
        end
    end)
end

CreateButton(Tab3, "Karakteri Resetle (Respawn)", function()
    local _, hum = getChar()
    if hum then hum.Health = 0 end
end)

local MonitoredRemotes = {}
local SniffEnabled = false
local SniffLog = {}

local logBox = Instance.new("ScrollingFrame")
logBox.Size = UDim2.new(1, 0, 0, 110)
logBox.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
logBox.BorderSizePixel = 0
logBox.ScrollBarThickness = 4
logBox.CanvasSize = UDim2.new(0, 0, 0, 0)
logBox.AutomaticCanvasSize = Enum.AutomaticSize.Y
logBox.Parent = Tab4

local logCorner = Instance.new("UICorner")
logCorner.CornerRadius = UDim.new(0, 6)
logCorner.Parent = logBox

local logLabel = Instance.new("TextLabel")
logLabel.Size = UDim2.new(1, -10, 0, 20)
logLabel.Position = UDim2.new(0, 5, 0, 0)
logLabel.BackgroundTransparency = 1
logLabel.Text = "Monitor: (henüz kayıt yok)"
logLabel.TextColor3 = Colors.Text
logLabel.TextSize = 11
logLabel.Font = Enum.Font.Code
logLabel.TextXAlignment = Enum.TextXAlignment.Left
logLabel.TextYAlignment = Enum.TextYAlignment.Top
logLabel.AutomaticSize = Enum.AutomaticSize.Y
logLabel.Parent = logBox

local logList = Instance.new("UIListLayout")
logList.Parent = logBox

local function Log(text)
    local entry = Instance.new("TextLabel")
    entry.Size = UDim2.new(1, -10, 0, 16)
    entry.Position = UDim2.new(0, 5, 0, 0)
    entry.BackgroundTransparency = 1
    entry.Text = text
    entry.TextColor3 = Colors.Red
    entry.TextSize = 11
    entry.Font = Enum.Font.Code
    entry.TextXAlignment = Enum.TextXAlignment.Left
    entry.Parent = logBox
    table.insert(SniffLog, text)
end

local function SafeName(obj)
    local ok, path = pcall(function()
        return obj:GetFullName()
    end)
    if ok then return path end
    return obj.Name
end

local function Serialize(args, depth)
    depth = depth or 0
    if depth > 3 then return "..." end
    local parts = {}
    for i, v in ipairs(args) do
        local t = typeof(v)
        if t == "string" then
            parts[i] = string.format("%q", v)
        elseif t == "Instance" then
            parts[i] = 'Instance("' .. SafeName(v) .. '")'
        elseif t == "Vector3" then
            parts[i] = string.format("Vector3.new(%s, %s, %s)", tostring(v.X), tostring(v.Y), tostring(v.Z))
        elseif t == "CFrame" then
            parts[i] = "CFrame.new(" .. tostring(v) .. ")"
        elseif t == "Color3" then
            parts[i] = string.format("Color3.new(%s, %s, %s)", tostring(v.R), tostring(v.G), tostring(v.B))
        elseif t == "table" then
            parts[i] = "{" .. Serialize(v, depth + 1) .. "}"
        else
            parts[i] = tostring(v)
        end
    end
    return table.concat(parts, ", ")
end

local function SniffRemote(remote)
    if remote:IsA("RemoteEvent") then
        remote.OnClientEvent:Connect(function(...)
            if SniffEnabled then
                local args = {...}
                Log("[IN] " .. remote.Name .. " (" .. Serialize(args) .. ")")
                table.insert(MonitoredRemotes, {Name = SafeName(remote), Type = "RemoteEvent", Direction = "Incoming", Args = Serialize(args), Time = os.clock()})
            end
        end)
    elseif remote:IsA("RemoteFunction") then
        local old
        local ok, result = pcall(function()
            old = hookmetamethod and nil or nil
            return nil
        end)
        local hookFunc
        if hookfunction then
            local original = remote.InvokeClient
            hookFunc = hookfunction(remote, {InvokeClient = function(self, ...)
                if SniffEnabled then
                    local args = {...}
                    Log("[FN-CALL] " .. remote.Name .. " (" .. Serialize(args) .. ")")
                    table.insert(MonitoredRemotes, {Name = SafeName(remote), Type = "RemoteFunction", Direction = "Outgoing", Args = Serialize(args), Time = os.clock()})
                end
                return original(self, ...)
            end})
        end
        if not hookFunc then
            Log("[BILGI] " .. remote.Name .. " hooklanamadi, sadece dinleme modunda")
        end
    end
end

local function ScanRemotes()
    Log("[TARAMA] ReplicatedStorage taraniyor...")
    local count = 0
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            count = count + 1
            pcall(SniffRemote, v)
        end
    end
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            count = count + 1
            pcall(SniffRemote, v)
        end
    end
    Log("[TARAMA] Tamamlandi. " .. tostring(count) .. " remote bulundu ve izleniyor.")
end

local function SetClipboard(text)
    if setclipboard then
        setclipboard(text)
        Log("[PANO] Icerik panoya kopyalandi.")
    elseif toclipboard then
        toclipboard(text)
        Log("[PANO] Icerik panoya kopyalandi.")
    elseif syn and syn.write_clipboard then
        syn.write_clipboard(text)
        Log("[PANO] Icerik panoya kopyalandi.")
    else
        Log("[HATA] Bu executor clipboard fonksiyonunu desteklemiyor.")
    end
end

CreateToggle(Tab4, "Remote Monitor (Sniff)", function(on)
    SniffEnabled = on
    if on then
        Log("[SISTEM] Sniffer acildi, remote taramasi baslatiliyor...")
        ScanRemotes()
    else
        Log("[SISTEM] Sniffer kapatildi.")
    end
end)

CreateButton(Tab4, "Kayitlari Temizle", function()
    MonitoredRemotes = {}
    SniffLog = {}
    for _, child in pairs(logBox:GetChildren()) do
        if child:IsA("TextLabel") then child:Destroy() end
    end
end)

CreateButton(Tab4, "Copy JSON", function()
    if #MonitoredRemotes == 0 then
        Log("[BILGI] Kopyalanacak kayit yok.")
        return
    end
    local ok, json = pcall(function()
        return HttpService:JSONEncode(MonitoredRemotes)
    end)
    if ok then
        SetClipboard(json)
    else
        Log("[HATA] JSON encode basarisiz.")
    end
end)

CreateButton(Tab4, "Copy Lua", function()
    if #MonitoredRemotes == 0 then
        Log("[BILGI] Kopyalanacak kayit yok.")
        return
    end
    local lines = {"local CapturedRequests = {"}
    for _, r in ipairs(MonitoredRemotes) do
        table.insert(lines, string.format('    {Name = "%s", Type = "%s", Direction = "%s", Args = "%s", Time = %s},',
            r.Name:gsub('"', '\\"'), r.Type, r.Direction, r.Args:gsub('[%c"\\]', " "), tostring(r.Time)))
    end
    table.insert(lines, "}")
    SetClipboard(table.concat(lines, "\n"))
end)

local function CopyLogText()
    if #SniffLog == 0 then
        Log("[BILGI] Kopyalanacak kayit yok.")
        return
    end
    SetClipboard(table.concat(SniffLog, "\n"))
end

CreateButton(Tab4, "Copy Log (Ham Metin)", CopyLogText)

Tabs["Server & Audio"].Page.Visible = true
Tabs["Server & Audio"].Button.BackgroundColor3 = Colors.RedDark

print("[Poors Hub Modern] By BurakDevv yuklendi - GUI: " .. tostring(ParentGui == game:GetService("CoreGui") and "CoreGui" or ParentGui.Name))
