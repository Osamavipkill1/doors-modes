---====== Load spawner ======---

local Spawner = LoadCachedModule("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/EntitySpawnerFork/VynixuSpawner.luau")

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local HINTS = {"Alright what happened this time...", "Oh, not sure who that is.", "Well he leave blood around in the rooms, so you could call him Bleed!"}
local HINT_COLOUR = "Yellow"
local BLOOD_DAMAGE = 15
local MODEL_URL = "https://raw.githubusercontent.com/Osamavipkill1/doors-modes/main/Mayhem%20Mode/misc/modules/bleed.rbxm"
-- The old spawner reset the model's rotation every frame; this one keeps the room's facing.
-- If Bleed looks sideways/backwards in game, set this to 90, -90 or 180.
local FACING_OFFSET_DEG = 0

---====== Load model ======---

-- Downloading + unpacking the rbxm happens on every Create, so do it once and hand the
-- spawner a fresh clone each time (it destroys the model when Bleed is done).
local function getModel()
    local cache = getgenv().MayhemInstanceCache
    if not cache then
        cache = {}
        getgenv().MayhemInstanceCache = cache
    end

    local template = cache[MODEL_URL]
    if not template then
        template = LoadCustomInstance(MODEL_URL)
        if typeof(template) ~= "Instance" then return nil end
        cache[MODEL_URL] = template
    end
    return template:Clone()
end

local model = getModel()
if not model then
    warn("[Mayhem/Bleed] Couldn't load bleed.rbxm -- check the link.")
    return
end

---====== Create entity ======---

local entity = Spawner:Create({
    Entity = {
        Name = "Bleed",
        Asset = model,
        HeightOffset = 0
    },
    Lights = {
        Flicker = { Enabled = true, Duration = 1 },
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
        Speed = 100,
        Delay = 2,
        Reversed = false
    },
    Rebounding = {
        Enabled = false,
        Type = "Ambush",
        Min = 1,
        Max = 1,
        Delay = 2
    },
    Damage = {
        Enabled = true,
        Range = 50,
        Amount = 125000,
        IgnoreHiding = false
    },
    Crucifixion = {
        Type = "Curious",
        Enabled = false, -- the old spawner had no crucifix; set true to let it banish Bleed
        Range = 40,
        Resist = false,
        Break = true
    },
    Death = {
        Type = "Curious",
        Hints = HINTS,
        Cause = "Bleed"
    }
})

if not entity then
    warn("[Mayhem/Bleed] Failed to create -- the model in bleed.rbxm must be a Model with at least one part.")
    return
end

-- Create() pads hint lists shorter than 4 lines with the spawner's default "Here", so set them directly.
entity.Config.Death.Hints = HINTS

---====== Helpers ======---

local function getHumanoid()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

-- Blood hits don't go through the spawner's damage, so they set the death cause/hint themselves.
local function killPlayer()
    local humanoid = getHumanoid()
    if not humanoid or humanoid.Health <= 0 then return end

    humanoid.Health = 0
    pcall(GuaranteeKill, humanoid)
    pcall(SetDeathCause, "Bleed")

    local hintOk, hintErr = pcall(FireDeathHint, HINTS, HINT_COLOUR)
    if not hintOk then
        warn("[Mayhem/Bleed] DeathHint failed: " .. tostring(hintErr))
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

-- Physical blood projectile: damages the player on contact, gone on hit or after 15s.
local function spawnBlood(origin)
    local particle = Instance.new("Part")
    particle.Name = "BleedParticle"
    particle.Shape = Enum.PartType.Ball
    particle.Size = Vector3.new(0.6, 0.6, 0.6)
    particle.Material = Enum.Material.SmoothPlastic
    particle.Color = Color3.fromRGB(120, 0, 0)
    particle.CanCollide = false
    particle.CanQuery = false -- otherwise blood can block the spawner's line-of-sight check to the player
    particle.Anchored = false
    particle.CFrame = CFrame.new(origin)
    particle.Parent = workspace

    local trail = Instance.new("ParticleEmitter")
    trail.Color = ColorSequence.new(Color3.fromRGB(150, 0, 0))
    trail.Size = NumberSequence.new(0.25)
    trail.Lifetime = NumberRange.new(0.2, 0.4)
    trail.Rate = 40
    trail.Speed = NumberRange.new(0)
    trail.Parent = particle

    local direction = Vector3.new(math.random(-10, 10), math.random(2, 8), math.random(-10, 10))
    if direction.Magnitude > 0 then
        direction = direction.Unit
    else
        direction = Vector3.new(0, 1, 0)
    end
    particle.AssemblyLinearVelocity = direction * math.random(15, 30)

    local touched = false
    particle.Touched:Connect(function(other)
        if touched then return end
        local char = other and other.Parent
        if not char or char ~= LocalPlayer.Character then return end
        if not char:FindFirstChildOfClass("Humanoid") then return end

        touched = true
        hurtPlayer(BLOOD_DAMAGE)
        particle:Destroy()
    end)

    task.delay(15, function()
        if particle.Parent then
            particle:Destroy()
        end
    end)
end

local RED = Color3.fromRGB(255, 0, 0)

local function tintRoomRed(room)
    local lightBase = room:FindFirstChild("LightBase")
    local surfaceLight = lightBase and lightBase:FindFirstChild("SurfaceLight")
    if surfaceLight then
        local original = surfaceLight.Color
        surfaceLight.Enabled = true
        TweenService:Create(surfaceLight, TweenInfo.new(2), {Color = RED}):Play()
        task.delay(15, function()
            if surfaceLight.Parent then
                TweenService:Create(surfaceLight, TweenInfo.new(2), {Color = original}):Play()
            end
        end)
    end

    local assets = room:FindFirstChild("Assets")
    if assets then
        for _, thing in ipairs(assets:GetDescendants()) do
            local fixture = thing:FindFirstChild("LightFixture")
            if fixture then
                local neon = fixture:FindFirstChild("Neon")
                if neon then
                    neon.Color = RED
                end
                for _, light in ipairs(fixture:GetChildren()) do
                    if light:IsA("SpotLight") or light:IsA("PointLight") then
                        light.Color = RED
                    end
                end
            end
        end
    end
end

---====== Callbacks ======---

entity:SetCallback("OnSpawned", function()
    if FACING_OFFSET_DEG ~= 0 then
        local model = entity.Model
        model:PivotTo(model:GetPivot() * CFrame.Angles(0, math.rad(FACING_OFFSET_DEG), 0))
    end
end)

-- Every 2-4s Bleed sprays 2-4 blood particles outward while it's moving.
entity:SetCallback("OnStartMoving", function()
    while entity:IsAlive() do
        task.wait(math.random(20, 40) / 10)
        if not entity:IsAlive() then break end

        local origin = entity.Model:GetPivot().Position
        for _ = 1, math.random(2, 4) do
            pcall(spawnBlood, origin)
        end
    end
end)

entity:SetCallback("OnEnterRoom", function(room, firstTime)
    if not firstTime then return end
    pcall(tintRoomRed, room)
end)

---====== Run entity ======---

entity:Run(false)
