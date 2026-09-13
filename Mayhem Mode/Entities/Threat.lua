_G.Threat = "safe"
local Spawner = loadstring(CachedHttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/EntitySpawnerFork/VynixuSpawner.luau"))()

local entity = Spawner:Create({
    Entity = {
        Name = "Threat",
        Asset = "rbxassetid://12802441490",
        HeightOffset = 0
    },
    Lights = {
        Flicker = { Enabled = false, Duration = 1 },
        Shatter = false,
        Repair = false
    },
    Earthquake = { Enabled = false },
    CameraShake = {
        Enabled = true,
        Range = 150,
        Values = {3.5, 20, 0.1, 1} -- Magnitude, Roughness, FadeIn, FadeOut
    },
    Movement = {
        Speed = 225, -- Percentage, 100 = default speed
        Delay = 3.5,
        Reversed = true
    },
    Rebounding = {
        Enabled = true,
        Type = "Ambush",
        Min = 4,
        Max = 7,
        Delay = 3
    },
    Damage = {
        Enabled = true,
        Range = 75,
        Amount = 125000,
        IgnoreHiding = false
    },
    Crucifixion = {
        Type = "Guiding",
        Enabled = true,
        Range = 40,
        Resist = false,
        Break = true
    },
    Death = {
        Type = "Guiding",
        Hints = {"Oh... hello.", "Not this place again...", "Nevermind that... What'd you die to?", "Oh... the red thing.", "It seems to get faster over time, so...", "Maybe you could call it Threat?", "Anyways, I hope you don't mind trying again. It would be helpful."},
        Cause = "" -- falls back to Entity.Name ("Threat") automatically
    }
})

if not entity then
    warn("[Mayhem/Threat] Failed to create -- check the Asset id is still valid.")
    return
end

-----[[  Debug -=- Advanced  ]]-----
entity:SetCallback("OnSpawned", function()
    print("Threat has spawned")
    _G.Threat = "unsafe"
end)

entity:SetCallback("OnStartMoving", function()
    print("Threat has started moving")
end)

entity:SetCallback("OnEnterRoom", function(room, firstTime)
    print("Threat entered room:", room.Name)
end)

entity:SetCallback("OnLookAt", function(lineOfSight)
    -- kept quiet, no per-frame print spam
end)

entity:SetCallback("OnRebounding", function(startOfRebound)
    print("Threat rebounding:", startOfRebound)
end)

entity:SetCallback("OnDespawning", function()
    print("Threat is despawning")
end)

entity:SetCallback("OnDespawned", function()
    _G.Threat = "safe"
    print("Threat has despawned")
end)

entity:SetCallback("OnDamagePlayer", function(newHealth)
    if newHealth <= 0 then
        print("Threat has killed the player")
    end
end)

---====== Run entity ======---

entity:Run(true)
