--========================================================
-- 1x4 UNIFIED ADMIN HUB — SERVER
-- Place this Script in ServerScriptService.
--========================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

local ADMIN_USER_IDS = {
    [3216839590] = true,
}

local REMOTE_NAME = "1x4UnifiedAdminEvent"
local SLOW_SPEED = 8
local NORMAL_SPEED = 16

-- Put the Roblox audio asset ID for the exact Living Tombstone remix
-- that your experience is permitted to use.
local MUSIC_ID = "rbxassetid://YOUR_LIVING_TOMBSTONE_AUDIO_ID"

-- Replace these with a skybox you own/use if the example assets do not work.
local SKYBOX = {
    Bk = "rbxassetid://159454299",
    Dn = "rbxassetid://159454296",
    Ft = "rbxassetid://159454293",
    Lf = "rbxassetid://159454286",
    Rt = "rbxassetid://159454300",
    Up = "rbxassetid://159454288",
}

local slowMode = false

local remote = ReplicatedStorage:FindFirstChild(REMOTE_NAME)
if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = REMOTE_NAME
    remote.Parent = ReplicatedStorage
end

local function isAdmin(player)
    return ADMIN_USER_IDS[player.UserId] == true
end

local function getHumanoid(player)
    local character = player.Character
    return character and character:FindFirstChildOfClass("Humanoid")
end

local function setSpeed(player, speed)
    local humanoid = getHumanoid(player)
    if humanoid then
        humanoid.WalkSpeed = speed
    end
end

local function slowEveryone()
    slowMode = true
    for _, player in ipairs(Players:GetPlayers()) do
        setSpeed(player, SLOW_SPEED)
    end
end

local function restoreEveryone()
    slowMode = false
    for _, player in ipairs(Players:GetPlayers()) do
        setSpeed(player, NORMAL_SPEED)
    end
end

local function applySkybox()
    local old = Lighting:FindFirstChild("1x4UnifiedSky")
    if old then
        old:Destroy()
    end

    local sky = Instance.new("Sky")
    sky.Name = "1x4UnifiedSky"
    sky.SkyboxBk = SKYBOX.Bk
    sky.SkyboxDn = SKYBOX.Dn
    sky.SkyboxFt = SKYBOX.Ft
    sky.SkyboxLf = SKYBOX.Lf
    sky.SkyboxRt = SKYBOX.Rt
    sky.SkyboxUp = SKYBOX.Up
    sky.Parent = Lighting
end

local function removeSkybox()
    local sky = Lighting:FindFirstChild("1x4UnifiedSky")
    if sky then
        sky:Destroy()
    end
end

local function stopMusic()
    local sound = SoundService:FindFirstChild("1x4UnifiedMusic")
    if sound then
        sound:Stop()
        sound:Destroy()
    end
end

local function playMusic()
    stopMusic()

    if MUSIC_ID == "rbxassetid://YOUR_LIVING_TOMBSTONE_AUDIO_ID" then
        warn("[1x4 HUB] Set MUSIC_ID in the server script before using music.")
        return
    end

    local sound = Instance.new("Sound")
    sound.Name = "1x4UnifiedMusic"
    sound.SoundId = MUSIC_ID
    sound.Volume = 0.7
    sound.Looped = true
    sound.Parent = SoundService
    sound:Play()
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid", 10)
        if humanoid and slowMode then
            humanoid.WalkSpeed = SLOW_SPEED
        end
    end)
end)

remote.OnServerEvent:Connect(function(player, command)
    if not isAdmin(player) then
        warn("[1x4 HUB] Blocked command from non-admin: " .. player.Name)
        return
    end

    if command == "SlowEveryone" then
        slowEveryone()
    elseif command == "RestoreEveryone" then
        restoreEveryone()
    elseif command == "ApplySky" then
        applySkybox()
    elseif command == "RemoveSky" then
        removeSkybox()
    elseif command == "PlayMusic" then
        playMusic()
    elseif command == "StopMusic" then
        stopMusic()
    end
end)

print("[1x4 HUB] Unified admin server loaded for UserId 3216839590.")
