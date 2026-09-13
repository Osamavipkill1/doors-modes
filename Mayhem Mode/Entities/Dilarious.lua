-- Dilarious, rebuilt (v2). Old version: wandered its path, physically dragged the
-- player toward it, ground them down with repeated small touch damage. Rebuilt
-- version: no collision (you can walk straight through it, but it's fully
-- visible), a proximity-based instant kill (like Threat's own kill condition --
-- Touched is unreliable for anything moved via PivotTo, so distance is the real
-- trigger, Touched is just a bonus path), and a camera pull that goes through
-- Doors' own camera-angle system instead of writing Camera.CFrame directly (which
-- gets silently overwritten every frame by Doors' own camera script).
local Spawner = LoadCachedModule("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/EntitySpawnerFork/Source.lua")

local entityTable = Spawner.createEntity({
    CustomName = "Dilarious",
    Model = "rbxassetid://12913584112",
    Speed = 20, -- patrol speed, unchanged from the old version (~12 studs/sec)
    DelayTime = 2,
    HeightOffset = 0,
    CanKill = false, -- touch/proximity kill is handled below, not the Spawner's own kill
    KillRange = 0,
    BackwardsMovement = false,
    BreakLights = false,
    FlickerLights = {
        false,
        1,
    },
    Cycles = {
        Min = 3,
        Max = 3,
        WaitTime = 1,
    },
    CamShake = {
        false,
        {3.5, 20, 0.1, 1},
        100,
    },
    Jumpscare = {
        false,
        {
            Image1 = "rbxassetid://105746113938200",
            Image2 = "rbxassetid://102956244109658",
            Shake = true,
            Sound1 = { 10483790459, { Volume = 0.5 } },
            Sound2 = { 10483837590, { Volume = 0.5 } },
            Flashing = { true, Color3.fromRGB(255, 255, 255) },
            Tease = { true, Min = 1, Max = 3 },
        },
    },
    CustomDialog = {"Oh... hello.", "Not this place again...", "Nevermind that... What'd you die to?", "Oh... the one that hates eye contact.", "It won't chase you if you don't look at it, so...", "Maybe you could call it Dilarious?", "Anyways, I hope you don't mind trying again. It would be helpful."},
    Color = "Yellow",
})

if not entityTable then
    warn("[Mayhem/Dilarious] Failed to create -- check the Asset id is still valid.")
    return
end

-- 2x Mimic Rush's real speed. VynixuSpawner scales Movement.Speed=150 against a base
-- of 65 studs/sec, so Rush actually moves at 65/100*150 = 97.5 studs/sec -- doubled.
local RUSH_SPEED = 195
-- How close counts as "touching" for the proximity kill -- root-part to root-part,
-- not surface to surface, so this is deliberately larger than it looks.
local KILL_RANGE = 5
local RunService = game:GetService("RunService")

-- Shortest signed distance from one angle to another in degrees, wrapping correctly
-- at +/-180 so a nudge never sends the camera spinning the long way around.
local function ShortestAngleDiff(from, to)
    local diff = (to - from) % 360
    if diff > 180 then
        diff = diff - 360
    end
    return diff
end

-----[[  Debug -=- Advanced  ]]-----
entityTable.Debug.OnEntitySpawned = function()
    task.spawn(function()
        local dilarious = game.Workspace:WaitForChild("Dilarious", 5)
        if not dilarious then
            warn("[Mayhem/Dilarious] Model never appeared in workspace, aborting.")
            return
        end

        -- Noclip: strip collision from every part so the player can walk straight
        -- through it. It stays fully visible -- this only affects physical
        -- blocking, not rendering, and not the raycast/FOV checks below (CanQuery
        -- is a separate property from CanCollide).
        for _, part in ipairs(dilarious:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end

        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local camera = workspace.CurrentCamera

        -- Same fallback the old version used: a dedicated anchor part if the model
        -- has one, otherwise PrimaryPart. Used for the camera-pull target, the
        -- raycast target, and the point the rush chases toward.
        local function getAnchor()
            return dilarious:FindFirstChild("DilariousMov") or dilarious.PrimaryPart
        end

        local function isAlive()
            return dilarious.Parent ~= nil and humanoid.Health > 0
        end

        -- Doors runs its camera fully scripted: Main_Game keeps target yaw/pitch
        -- (ax_t/ay_t) and recomputes Camera.CFrame from them every frame, the same
        -- system Screech's own camera-lock nudges. If that module isn't reachable
        -- for some reason, fall back to nudging Camera.CFrame directly -- weaker,
        -- but better than nothing.
        local mainGameOk, mainGame = pcall(function()
            return require(player.PlayerGui.MainUI.Initiator.Main_Game)
        end)
        local useNativeCameraAngles = mainGameOk and mainGame
            and typeof(mainGame.ax_t) == "number"
            and typeof(mainGame.ay_t) == "number"
        if not useNativeCameraAngles then
            warn("[Mayhem/Dilarious] Main_Game angle targets not found -- falling back to a direct camera nudge.")
        end

        -- Kill: proximity is the real trigger (matches how Threat's own kill
        -- condition works -- a distance check, not a physical collision), Touched
        -- is kept as a bonus path in case it does fire. Both are guarded by the
        -- same alreadyKilled flag so this can't double-fire.
        local alreadyKilled = false
        local function doKill()
            if alreadyKilled then return end
            alreadyKilled = true
            pcall(function() SetDeathCause("Dilarious") end)
            local hintOk, hintErr = pcall(firesignal, game:GetService("ReplicatedStorage").EntityInfo.DeathHint.OnClientEvent, entityTable.Config.CustomDialog, entityTable.Config.Color)
            if not hintOk then
                warn("[Mayhem/Dilarious] DeathHint firesignal failed: " .. tostring(hintErr))
            end
            pcall(function() GuaranteeKill(humanoid) end)
        end

        -- Hitbox is pulled out to workspace directly and kept in sync by hand,
        -- instead of just leaving it as a child of the model and trusting PivotTo
        -- to carry it along -- an earlier version of this entity did exactly that
        -- reparenting, which strongly suggests leaving it nested wasn't reliable
        -- enough for Touched to actually register.
        local Hitbox = dilarious:FindFirstChild("Hitbox")
        local touchConn
        local hitboxSyncConn
        if Hitbox then
            Hitbox.Parent = workspace
            Hitbox.CanCollide = false
            Hitbox.CanQuery = false
            Hitbox.Transparency = 1
            hitboxSyncConn = RunService.Heartbeat:Connect(function()
                if not isAlive() or not dilarious.PrimaryPart then
                    if hitboxSyncConn then hitboxSyncConn:Disconnect() end
                    return
                end
                local anchor = getAnchor()
                if anchor then
                    Hitbox.Position = anchor.Position
                end
            end)
            touchConn = Hitbox.Touched:Connect(function(hit)
                local hitChar = hit and hit.Parent
                local hitHum = hitChar and hitChar:FindFirstChild("Humanoid")
                if hitHum == humanoid then
                    doKill()
                end
            end)
        else
            warn("[Mayhem/Dilarious] No 'Hitbox' child on the model -- relying on proximity only for this spawn.")
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
            if liveChar:GetAttribute("Hiding") then return end -- matches Threat's own IgnoreHiding=false behavior

            local dist = (hrp.Position - dilarious.PrimaryPart.Position).Magnitude
            if dist <= KILL_RANGE then
                doKill()
            end
        end)

        -- Camera pull. Nudges Main_Game's target angles a little further toward
        -- looking at Dilarious every frame -- additive, not a hard set, so the
        -- player's own mouse movement (which drives those same targets) can win
        -- out over it by actively turning away. Strength scales with distance:
        -- barely noticeable far away, hard to resist up close.
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

            -- Extended range: full strength at/under 8 studs, but now reaches out
            -- to 200 studs instead of 80 -- a quadratic (not linear) falloff so it
            -- stays genuinely weak/barely-there across most of that range and only
            -- really ramps up once you're within roughly the last 40-50 studs.
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

        -- Rush control. Flips the Spawner's own NoAI attribute, which its patrol
        -- movement (dragEntity, in Source.lua) already checks and pauses on -- so
        -- starting a rush cleanly freezes the patrol in place, and ending one hands
        -- control straight back to the Spawner, which resumes toward the same node
        -- it was already walking to.
        local rushing = false
        local rushConn = nil

        local function stopRush()
            if not rushing then return end
            rushing = false
            if rushConn then
                rushConn:Disconnect()
                rushConn = nil
            end
            pcall(function() dilarious:SetAttribute("NoAI", false) end)
        end

        local function startRush()
            if rushing or not isAlive() then return end
            rushing = true
            pcall(function() dilarious:SetAttribute("NoAI", true) end)
            rushConn = RunService.Heartbeat:Connect(function(dt)
                if not isAlive() then
                    stopRush()
                    return
                end
                local liveChar = player.Character
                local hrp = liveChar and liveChar:FindFirstChild("HumanoidRootPart")
                if not hrp or not dilarious.PrimaryPart then return end

                -- PrimaryPart, not getAnchor(), is the ground truth for where the
                -- model actually is -- matches the convention Source.lua's own
                -- dragEntity uses, so this can't drift relative to a
                -- possibly-offset DilariousMov anchor.
                local rootPos = dilarious.PrimaryPart.Position
                local diff = hrp.Position - rootPos
                if diff.Magnitude > 1 then
                    local step = math.min(dt * RUSH_SPEED, diff.Magnitude)
                    pcall(function()
                        dilarious:PivotTo(CFrame.new(rootPos + diff.Unit * step))
                    end)
                end
            end)
        end

        -- Look detection: on-screen AND a clear raycast, exactly like Manic Eyes.
        -- Checked ~10x/sec instead of every frame -- responsive enough without
        -- throwing out a raycast every single frame.
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = Hitbox and {character, dilarious, Hitbox} or {character, dilarious}
        rayParams.FilterType = Enum.RaycastFilterType.Exclude

        task.spawn(function()
            local wasLooking = false
            while isAlive() do
                task.wait(0.1)
                local anchor = getAnchor()
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if anchor and hrp then
                    local anchorPos = anchor.Position
                    local _, onScreen = camera:WorldToViewportPoint(anchorPos)
                    local nowLooking = false

                    if onScreen then
                        local direction = anchorPos - hrp.Position
                        local rayResult = workspace:Raycast(hrp.Position, direction, rayParams)
                        nowLooking = (rayResult == nil)
                            or (rayResult.Instance ~= nil and rayResult.Instance:IsDescendantOf(dilarious))
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

        -- Safety despawn: same room-49 checkpoint the old version used, so this
        -- can't linger into the room 50 sequence even if its cycles haven't
        -- finished by then.
        task.spawn(function()
            while isAlive() do
                game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
                local latestRoom = game.ReplicatedStorage.GameData.LatestRoom.Value
                if latestRoom >= 49 then
                    pcall(function() dilarious:Destroy() end)
                    break
                end
            end
        end)

        entityTable.Debug.OnEntityDespawned = function()
            if touchConn then touchConn:Disconnect() end
            if hitboxSyncConn then hitboxSyncConn:Disconnect() end
            if Hitbox then pcall(function() Hitbox:Destroy() end) end
            if proximityConn then proximityConn:Disconnect() end
            if pullConn then pullConn:Disconnect() end
            stopRush()
        end
    end)
end

entityTable.Debug.OnEntityDespawned = function() end
entityTable.Debug.OnEntityStartMoving = function() end
entityTable.Debug.OnEntityFinishedRebound = function() end
entityTable.Debug.OnEntityEnteredRoom = function(room) end
entityTable.Debug.OnLookAtEntity = function() end
entityTable.Debug.OnDeath = function() end
------------------------------------

Spawner.runEntity(entityTable)
