--========================================================
-- 1x4 UNIFIED ADMIN HUB — CLIENT
-- Place this LocalScript in StarterPlayerScripts.
--========================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")

local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("1x4UnifiedAdminEvent")

local gui = Instance.new("ScreenGui")
gui.Name = "1x4UnifiedAdminHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(390, 700)
main.Position = UDim2.new(0, 20, 0.5, -350)
main.BackgroundColor3 = Color3.fromRGB(18, 22, 20)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 0, 45)
title.Position = UDim2.fromOffset(15, 10)
title.BackgroundTransparency = 1
title.Text = "⚡ 1x4 ADMIN HUB"
title.TextColor3 = Color3.fromRGB(100, 255, 140)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -30, 0, 24)
status.Position = UDim2.fromOffset(15, 55)
status.BackgroundTransparency = 1
status.Text = "Ready — Admin UserId: 3216839590"
status.TextColor3 = Color3.fromRGB(170, 180, 175)
status.TextSize = 11
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = main

local function button(text, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -30, 0, 38)
    b.Position = UDim2.fromOffset(15, y)
    b.BackgroundColor3 = Color3.fromRGB(30, 65, 40)
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Color3.fromRGB(235, 245, 238)
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = true
    b.Parent = main

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = b

    return b
end

local function section(text, y)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -30, 0, 25)
    label.Position = UDim2.fromOffset(15, y)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(100, 255, 140)
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = main
end

section("⚡ SERVER ADMIN", 88)

local slow = button("🐌  SLOW EVERYONE", 115)
local restore = button("🏃  RESTORE EVERYONE", 159)
local sky = button("🌌  SPOOKY SKYBOX", 203)
local removeSky = button("☀️  REMOVE SKYBOX", 247)
local music = button("🎵  LIVING TOMBSTONE REMIX", 291)
local stopMusic = button("⏹  STOP MUSIC", 335)

section("🛠 PLAYER TOOLS", 385)

local infiniteJump = button("🦘  INFINITE JUMP: OFF", 412)
local chatToggle = button("💬  CHAT MONITOR: OFF", 456)

local chatBox = Instance.new("ScrollingFrame")
chatBox.Size = UDim2.new(1, -30, 0, 175)
chatBox.Position = UDim2.fromOffset(15, 500)
chatBox.BackgroundColor3 = Color3.fromRGB(10, 13, 11)
chatBox.BorderSizePixel = 0
chatBox.ScrollBarThickness = 5
chatBox.Visible = false
chatBox.AutomaticCanvasSize = Enum.AutomaticSize.Y
chatBox.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 3)
layout.Parent = chatBox

local function logChat(message)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = message
    label.TextColor3 = Color3.fromRGB(220, 230, 223)
    label.TextSize = 11
    label.Font = Enum.Font.Gotham
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = chatBox
end

local function command(name)
    remote:FireServer(name)
end

slow.MouseButton1Click:Connect(function()
    command("SlowEveryone")
    status.Text = "🐌 Slow Everyone command sent."
end)

restore.MouseButton1Click:Connect(function()
    command("RestoreEveryone")
    status.Text = "🏃 Restore Everyone command sent."
end)

sky.MouseButton1Click:Connect(function()
    command("ApplySky")
    status.Text = "🌌 Spooky skybox command sent."
end)

removeSky.MouseButton1Click:Connect(function()
    command("RemoveSky")
    status.Text = "☀️ Skybox removed."
end)

music.MouseButton1Click:Connect(function()
    command("PlayMusic")
    status.Text = "🎵 Music command sent."
end)

stopMusic.MouseButton1Click:Connect(function()
    command("StopMusic")
    status.Text = "⏹ Music stopped."
end)

local infiniteEnabled = false
local jumpConnection

infiniteJump.MouseButton1Click:Connect(function()
    infiniteEnabled = not infiniteEnabled

    if jumpConnection then
        jumpConnection:Disconnect()
        jumpConnection = nil
    end

    if infiniteEnabled then
        infiniteJump.Text = "🦘  INFINITE JUMP: ON"
        jumpConnection = UserInputService.JumpRequest:Connect(function()
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        status.Text = "🦘 Infinite jump enabled."
    else
        infiniteJump.Text = "🦘  INFINITE JUMP: OFF"
        status.Text = "🦘 Infinite jump disabled."
    end
end)

local chatEnabled = false

chatToggle.MouseButton1Click:Connect(function()
    chatEnabled = not chatEnabled
    chatBox.Visible = chatEnabled

    if chatEnabled then
        chatToggle.Text = "💬  CHAT MONITOR: ON"
        status.Text = "💬 Chat monitor enabled."
        logChat("SYSTEM: Chat monitor enabled.")
    else
        chatToggle.Text = "💬  CHAT MONITOR: OFF"
        status.Text = "💬 Chat monitor disabled."
    end
end)

local function senderName(message)
    if message.TextSource then
        local sender = Players:GetPlayerByUserId(message.TextSource.UserId)
        if sender then
            return sender.DisplayName
        end
    end

    if message.PrefixText and message.PrefixText ~= "" then
        return message.PrefixText:gsub("<[^>]->", "")
    end

    return "Unknown"
end

pcall(function()
    TextChatService.MessageReceived:Connect(function(message)
        if chatEnabled and message.Text and message.Text ~= "" then
            logChat(senderName(message) .. ": " .. message.Text)
        end
    end)
end)

-- Legacy chat fallback.
local legacyConnections = {}

local function connectLegacy(playerToConnect)
    if playerToConnect == player then
        return
    end

    if legacyConnections[playerToConnect] then
        legacyConnections[playerToConnect]:Disconnect()
    end

    legacyConnections[playerToConnect] = playerToConnect.Chatted:Connect(function(message)
        if chatEnabled and message and message ~= "" then
            logChat(playerToConnect.DisplayName .. ": " .. message)
        end
    end)
end

for _, p in ipairs(Players:GetPlayers()) do
    connectLegacy(p)
end

Players.PlayerAdded:Connect(connectLegacy)

Players.PlayerRemoving:Connect(function(p)
    if legacyConnections[p] then
        legacyConnections[p]:Disconnect()
        legacyConnections[p] = nil
    end
end)

print("[1x4 HUB] Unified admin client loaded.")
