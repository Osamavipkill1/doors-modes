---====== Load spawner ======---

local Spawner = LoadCachedModule("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/EntitySpawnerFork/VynixuSpawner.luau")

local RUSH_SPEED = 70
local KILL_RANGE = 4 -- studs, root part to root part
-- The old spawner reset the model's rotation every frame; this one keeps the room's facing.
-- If Dilarious looks sideways/backwards in game, set this to 90, -90 or 180.
local FACING_OFFSET_DEG = 0

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local HINTS = {"Oh... hello.", "Not this place again...", "Nevermind that... What'd you die to?", "Oh... the one that hates but wants eye contact.", "It won't chase you if you don't look at it", "and it will beg for your attention, so...", "maybe try resisting better next time", "Anyways, I hope you don't mind trying again. It would be helpful."}
local HINT_COLOUR = "Yellow"

---====== Create entity ======---

local entity = Spawner:Create({
    Entity = {
        Name = "Dilarious",
        Asset = "rbxassetid://12913584112",
        HeightOffset = 0
    },
    Lights = {
        Flicker = { Enabled = false, Duration = 1 },
        Shatter = false,
        Repair = false
    },
    Earthquake = { Enabled = false },
    CameraShake = {
        Enabled = false,
        Range = 100,
        Values = {3.5, 20, 0.1, 1} -- Magnitude, Roughness, FadeIn, FadeOut
    },
    Movement = {
        Speed = 20, -- patrol speed
        Delay = 2,
        Reversed = false
    },
    Rebounding = {
        Enabled = true,
        Type = "Ambush",
        Min = 3,
        Max = 3,
        Delay = 1
    },
    Damage = {
        Enabled = false, -- kill is handled in this script
        Range = 40,
        Amount = 125000,
        IgnoreHiding = false
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
        Cause = "Dilarious"
    }
})

if not entity then
    warn("[Mayhem/Dilarious] Failed to create -- check the Asset id is still valid.")
    return
end

---====== Helpers ======---

local function getHumanoid()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function ShortestAngleDiff(from, to)
    local diff = (to - from) % 360
    if diff > 180 then
        diff = diff - 360
    end
    return diff
end

-- The spawner has no way to stop an entity that's already walking its route, so before
-- destroying Dilarious make the rest of that (now invisible) route finish almost instantly.
local function despawnNow()
    if not entity:IsAlive() then return end
    entity.Model:SetAttribute("Paused", false)
    entity.Config.Movement.Speed = 1000000
    entity:Despawn()
end

---====== Callbacks ======---

entity:SetCallback("OnSpawned", function()
    local dilarious = entity.Model

    -- kills are distance-based, the model's hitbox isn't used
    -- (if the spawner picked the Hitbox as the model's PrimaryPart it has to stay, so just hide it)
    local hitbox = dilarious:FindFirstChild("Hitbox")
    if hitbox then
        if hitbox == dilarious.PrimaryPart then
            hitbox.Transparency = 1
        else
            hitbox:Destroy()
        end
    end

    for _, part in ipairs(dilarious:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    if FACING_OFFSET_DEG ~= 0 then
        dilarious:PivotTo(dilarious:GetPivot() * CFrame.Angles(0, math.rad(FACING_OFFSET_DEG), 0))
    end

    local player = LocalPlayer
    local camera = workspace.CurrentCamera

    local function getAnchor()
        return dilarious:FindFirstChild("DilariousMov") or dilarious.PrimaryPart
    end

    local function isAlive()
        local humanoid = getHumanoid()
        return dilarious.Parent ~= nil and humanoid ~= nil and humanoid.Health > 0
    end

    -- Main_Game's ax_t/ay_t are Doors' camera yaw/pitch targets; if they
    -- aren't reachable, the pull falls back to moving Camera.CFrame directly
    local mainGameOk, mainGame = pcall(function()
        return require(player.PlayerGui.MainUI.Initiator.Main_Game)
    end)
    local useNativeCameraAngles = mainGameOk and mainGame
        and typeof(mainGame.ax_t) == "number"
        and typeof(mainGame.ay_t) == "number"

    local alreadyKilled = false
    local function doKill()
        if alreadyKilled then return end
        local humanoid = getHumanoid()
        if not humanoid then return end
        alreadyKilled = true

        humanoid.Health = 0
        pcall(function() GuaranteeKill(humanoid) end)
        pcall(function() SetDeathCause("Dilarious") end)

        local hintOk, hintErr = pcall(FireDeathHint, HINTS, HINT_COLOUR)
        if not hintOk then
            warn("[Mayhem/Dilarious] DeathHint failed: " .. tostring(hintErr))
        end
    end

    local proximityConn
    proximityConn = RunService.Heartbeat:Connect(function()
        if not isAlive() then
            if proximityConn then proximityConn:Disconnect() end
            return
        end
        local liveChar = player.Character
        local hrp = liveChar and liveChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not dilarious.PrimaryPart then return end

        if (hrp.Position - dilarious.PrimaryPart.Position).Magnitude <= KILL_RANGE then
            doKill()
        end
    end)

    -- Nudges the camera toward Dilarious; stronger the closer it is, and
    -- the player's own mouse movement can still win out
    local pullConn
    pullConn = RunService.RenderStepped:Connect(function(dt)
        if not isAlive() then
            if pullConn then pullConn:Disconnect() end
            return
        end
        local anchor = getAnchor()
        if not anchor then return end

        local camCFrame = (useNativeCameraAngles and mainGame.cam and mainGame.cam.CFrame) or camera.CFrame
        local camPos = camCFrame.Position
        local toTarget = anchor.Position - camPos
        local dist = toTarget.Magnitude
        if dist < 1 then return end

        local minDist, maxDist = 8, 200
        local normalizedDist = math.clamp((dist - minDist) / (maxDist - minDist), 0, 1)
        local proximity = (1 - normalizedDist) ^ 2
        if proximity <= 0 then return end

        local pullRatePerSecond = proximity * 1.6
        local alpha = 1 - math.exp(-pullRatePerSecond * dt)

        if useNativeCameraAngles then
            local rx, ry = CFrame.new(Vector3.new(), toTarget.Unit):ToOrientation()
            local desiredYaw, desiredPitch = math.deg(ry), math.deg(rx)
            mainGame.ax_t = mainGame.ax_t + ShortestAngleDiff(mainGame.ax_t, desiredYaw) * alpha
            mainGame.ay_t = mainGame.ay_t + ShortestAngleDiff(mainGame.ay_t, desiredPitch) * alpha
        else
            local newLook = camCFrame.LookVector:Lerp(toTarget.Unit, alpha)
            if newLook.Magnitude > 0.0001 then
                camera.CFrame = CFrame.new(camPos, camPos + newLook.Unit)
            end
        end
    end)

    -- "Paused" halts the Spawner's patrol while the rush runs, and the patrol
    -- picks straight back up (toward the node it was heading to) when the rush stops
    local rushing = false
    local rushConn = nil

    local function stopRush()
        if not rushing then return end
        rushing = false
        if rushConn then
            rushConn:Disconnect()
            rushConn = nil
        end
        pcall(function() dilarious:SetAttribute("Paused", false) end)
    end

    local function startRush()
        if rushing or not isAlive() then return end
        rushing = true
        pcall(function() dilarious:SetAttribute("Paused", true) end)
        rushConn = RunService.Heartbeat:Connect(function(dt)
            if not isAlive() then
                stopRush()
                return
            end
            local liveChar = player.Character
            local hrp = liveChar and liveChar:FindFirstChild("HumanoidRootPart")
            if not hrp or not dilarious.PrimaryPart then return end

            local rootPos = dilarious.PrimaryPart.Position
            local diff = hrp.Position - rootPos
            if diff.Magnitude > 1 then
                local step = math.min(dt * RUSH_SPEED, diff.Magnitude)
                pcall(function()
                    dilarious:PivotTo(dilarious:GetPivot() + diff.Unit * step)
                end)
            end
        end)
    end

    -- Looking at it = on screen with a clear raycast, checked 10x/sec
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude

    task.spawn(function()
        local wasLooking = false
        while isAlive() do
            task.wait(0.1)
            local anchor = getAnchor()
            local liveChar = player.Character
            local hrp = liveChar and liveChar:FindFirstChild("HumanoidRootPart")
            if anchor and hrp then
                local anchorPos = anchor.Position
                local _, onScreen = camera:WorldToViewportPoint(anchorPos)
                local nowLooking = false

                if onScreen then
                    rayParams.FilterDescendantsInstances = {liveChar, dilarious}
                    nowLooking = workspace:Raycast(hrp.Position, anchorPos - hrp.Position, rayParams) == nil
                end

                if nowLooking and not wasLooking then
                    wasLooking = true
                    startRush()
                elseif not nowLooking and wasLooking then
                    wasLooking = false
                    stopRush()
                end
            end
        end
        stopRush()
    end)

    -- despawn at room 49 so it can't carry into the room 50 sequence
    local roomConn = ReplicatedStorage.GameData.LatestRoom.Changed:Connect(function()
        if ReplicatedStorage.GameData.LatestRoom.Value >= 49 then
            despawnNow()
        end
    end)

    -- Runs however Dilarious goes away (room 49, natural end of its route)
    dilarious.Destroying:Connect(function()
        roomConn:Disconnect()
        if proximityConn then proximityConn:Disconnect() end
        if pullConn then pullConn:Disconnect() end
        stopRush()
    end)
end)

---====== Run entity ======---

entity:Run(false)
