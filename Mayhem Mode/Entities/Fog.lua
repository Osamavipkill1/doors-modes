---====== Load spawner ======---

local Spawner = LoadCachedModule("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/EntitySpawnerFork/VynixuSpawner.luau")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local LatestRoom = ReplicatedStorage.GameData.LatestRoom

local HINTS = {"Oh... hello.", "Not this place again...", "Nevermind that... What'd you die to?", "Oh... the white one.", "It fills the room with fog, so...", "Maybe you could call it Fog?", "You should avoid it...", "Anyways, I hope you don't mind trying again. It would be helpful."}
local HINT_COLOUR = "Yellow"

-- Fog also drains the player while it patrols: DRAIN_AMOUNT health every DRAIN_EVERY_N_LEGS
-- finished passes through the rooms (4 = every second there-and-back, same as before).
local DRAIN_AMOUNT = 10
local DRAIN_EVERY_N_LEGS = 4

local FOG_ON = { Color = Color3.fromRGB(255, 255, 255), Start = 45, End = 135 }
local FOG_OFF = { Color = Color3.fromRGB(0, 0, 0), Start = 10, End = 75 }

---====== Create entity ======---

local entity = Spawner:Create({
    Entity = {
        Name = "Fog",
        Asset = "rbxassetid://12802386940",
        HeightOffset = 0
    },
    Lights = {
        Flicker = { Enabled = true, Duration = 5 },
        Shatter = false,
        Repair = false
    },
    Earthquake = { Enabled = false },
    CameraShake = {
        Enabled = true,
        Range = 100,
        Values = {3.5, 20, 0.1, 1} -- Magnitude, Roughness, FadeIn, FadeOut
    },
    Movement = {
        Speed = 50,
        Delay = 2,
        Reversed = true
    },
    Rebounding = {
        Enabled = true,
        Type = "Ambush",
        Min = 1000, -- keeps going until the next room opens (see OnSpawned)
        Max = 1000,
        Delay = 2
    },
    Damage = {
        Enabled = true,
        Range = 5, -- standing inside the fog kills you
        Amount = 125000,
        IgnoreHiding = true -- the old touch-kill ignored hiding too
    },
    Crucifixion = {
        Type = "Curious",
        Enabled = false, -- the old spawner had no crucifix
        Range = 40,
        Resist = false,
        Break = true
    },
    Death = {
        Type = "Curious",
        Hints = HINTS,
        Cause = "Fog"
    }
})

if not entity then
    warn("[Mayhem/Fog] Failed to create -- check the Asset id is still valid.")
    return
end

---====== Helpers ======---

local function getHumanoid()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

-- The drain doesn't go through the spawner's damage, so it sets the death cause/hint itself.
local function killPlayer()
    local humanoid = getHumanoid()
    if not humanoid or humanoid.Health <= 0 then return end

    humanoid.Health = 0
    pcall(GuaranteeKill, humanoid)
    pcall(SetDeathCause, "Fog")

    local hintOk, hintErr = pcall(FireDeathHint, HINTS, HINT_COLOUR)
    if not hintOk then
        warn("[Mayhem/Fog] DeathHint failed: " .. tostring(hintErr))
    end
end

local function hurtPlayer(amount)
    local humanoid = getHumanoid()
    if not humanoid or humanoid.Health <= 0 then return end

    if humanoid.Health - amount <= 0 then
        killPlayer()
    else
        humanoid.Health = humanoid.Health - amount
    end
end

local function setFog(fog)
    Lighting.FogColor = fog.Color
    Lighting.FogStart = fog.Start
    Lighting.FogEnd = fog.End
end

-- The spawner has no way to stop an entity that's already walking its route, so before
-- destroying Fog make the rest of that (now invisible) route finish almost instantly.
local function despawnNow()
    if not entity:IsAlive() then return end
    entity.Model:SetAttribute("Paused", false)
    entity.Config.Movement.Speed = 1000000
    entity:Despawn()
end

---====== Lifecycle ======---

local fogApplied = false
local roomConn = nil

-- Runs however Fog goes away (next room, natural despawn), so the lighting always resets.
entity.Model.Destroying:Connect(function()
    if roomConn then
        roomConn:Disconnect()
        roomConn = nil
    end
    if fogApplied then
        fogApplied = false
        setFog(FOG_OFF)
    end
end)

---====== Callbacks ======---

entity:SetCallback("OnSpawned", function()
    fogApplied = true
    setFog(FOG_ON)

    -- Fog lasts until the next room opens
    roomConn = LatestRoom.Changed:Connect(despawnNow)
end)

local legsDone = 1 -- the opening pass through the rooms
entity:SetCallback("OnRebounding", function(startOfRebound)
    -- fires when a pass starts and again when it ends; only count the ends
    if startOfRebound or not entity:IsAlive() then return end

    legsDone = legsDone + 1
    if legsDone % DRAIN_EVERY_N_LEGS == 0 then
        hurtPlayer(DRAIN_AMOUNT)
    end
end)

---====== Run entity ======---

-- pcall: this file is loaded from Mayhem.lua's room handler, which shouldn't die if Fog can't spawn
local ok, err = pcall(entity.Run, entity, false)
if not ok then
    warn("[Mayhem/Fog] Failed to run: " .. tostring(err))
end
