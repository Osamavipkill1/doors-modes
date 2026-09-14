-- Dilarious, rebuilt (v3: on-screen debug HUD to find the kill bug without
-- console access). Rebuilt version: no collision (walk straight through it, but
-- fully visible), a proximity-based instant kill (like Threat's own kill
-- condition) plus a reparented/manually-synced Hitbox as a second trigger path,
-- and a camera pull that goes through Doors' own camera-angle system instead of
-- writing Camera.CFrame directly.
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
    return
end

-- 2x Mimic Rush's real speed. VynixuSpawner scales Movement.Speed=150 against a base
-- of 65 studs/sec, so Rush actually moves at 65/100*150 = 97.5 studs/sec -- doubled.
local RUSH_SPEED = 195
-- How close counts as "touching" for the proximity kill -- root-part to root-part,
-- not surface to surface, so this is deliberately larger than it looks.
local KILL_RANGE = 7
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
            return
        end

        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local camera = workspace.CurrentCamera

        -- ===== On-screen debug HUD -- temporary, no console needed. Remove the
        -- whole block between the ===== markers once the kill issue is found. =====
        local DebugState = {
            hitboxFound = "?",
            distance = "?",
            touchedFired = "no",
            proximityFired = "no",
            doKillCalled = "no",
            healthNow = tostring(humanoid.Health),
        }
        local debugGui = Instance.new("ScreenGui")
        debugGui.Name = "DilariousDebugHUD"
        debugGui.ResetOnSpawn = false
        debugGui.IgnoreGuiInset = true
        debugGui.DisplayOrder = 999
        debugGui.Parent = player:WaitForChild("PlayerGui")

        local debugLabel = Instance.new("TextLabel")
        debugLabel.Size = UDim2.new(0, 360, 0, 190)
        debugLabel.Position = UDim2.new(0, 10, 0, 40)
        debugLabel.BackgroundColor3 = Color3.new(0, 0, 0)
        debugLabel.BackgroundTransparency = 0.25
        debugLabel.BorderSizePixel = 0
        debugLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        debugLabel.TextXAlignment = Enum.TextXAlignment.Left
        debugLabel.TextYAlignment = Enum.TextYAlignment.Top
        debugLabel.Font = Enum.Font.Code
        debugLabel.TextSize = 16
        debugLabel.TextWrapped = true
        debugLabel.Parent = debugGui

        local function RefreshDebug()
            debugLabel.Text = string.format(
                "Dilarious Debug\nHitbox found: %s\nDistance: %s\nTouched fired: %s\nProximity fired: %s\ndoKill called: %s\nHealth now: %s",
                DebugState.hitboxFound, DebugState.distance, DebugState.touchedFired,
                DebugState.proximityFired, DebugState.doKillCalled, DebugState.healthNow
            )
        end
        RefreshDebug()

        humanoid.HealthChanged:Connect(function(newHealth)
            DebugState.healthNow = string.format("%.1f", newHealth)
            RefreshDebug()
        end)
        -- ===== end HUD setup (the rest of the HUD wiring is inline below) =====

        -- Same fallback the old version used: a dedicated anchor part if the model
        -- has one, otherwise PrimaryPart. Used for the camera-pull target, the
        -- raycast target, and the point the rush chases toward.
        local function getAnchor()
            return dilarious:FindFirstChild("DilariousMov") or dilarious.PrimaryPart
        end

        local function isAlive()
            return dilarious.Parent ~= nil and humanoid.Health > 0
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

        -- Doors runs its camera fully scripted: Main_Game keeps target yaw/pitch
        -- (ax_t/ay_t) and recomputes Camera.CFrame from them every frame, the same
        -- system Screech's own camera-lock nudges. If that module isn't reachable
        -- for some reason, fall back to nudging Camera.CFrame directly.
        local mainGameOk, mainGame = pcall(function()
            return require(player.PlayerGui.MainUI.Initiator.Main_Game)
        end)
        local useNativeCameraAngles = mainGameOk and mainGame
            and typeof(mainGame.ax_t) == "number"
            and typeof(mainGame.ay_t) == "number"

        -- Kill: proximity is the main trigger (matches how Threat's own kill
        -- condition works -- a distance check, not a physical collision), Touched
        -- is kept as a second path in case it fires. Both guarded by the same
        -- alreadyKilled flag so this can't double-fire.
        local alreadyKilled = false
        local function doKill()
            if alreadyKilled then return end
            alreadyKilled = true
            DebugState.doKillCalled = "YES"
            RefreshDebug()
            pcall(function() SetDeathCause("Dilarious") end)
            pcall(firesignal, game:GetService("ReplicatedStorage").EntityInfo.DeathHint.OnClientEvent, entityTable.Config.CustomDialog, entityTable.Config.Color)
            -- Direct write first -- this is the exact technique confirmed to
            -- reliably kill in this game. GuaranteeKill runs right after purely
            -- as reinforcement, not the primary mechanism.
            humanoid.Health = 0
            pcall(function() GuaranteeKill(humanoid) end)
        end

        -- Hitbox is pulled out to workspace directly and kept in sync by hand,
        -- instead of just leaving it as a child of the model and trusting PivotTo
        -- to carry it along.
        local Hitbox = dilarious:FindFirstChild("Hitbox")
        DebugState.hitboxFound = Hitbox and "yes" or "NO -- proximity only"
        RefreshDebug()
        local touchConn
        local hitboxSyncConn
        if Hitbox then
            Hitbox.Parent = workspace
            Hitbox.CanCollide = false
            Hitbox.CanQuery = false
            Hitbox.CanTouch = true -- forced explicitly, in case the asset shipped with this false
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
                game.Players.LocalPlayer.Character.Humanoid.Health = 0
                local hitChar = hit and hit.Parent
                local hitHum = hitChar and hitChar:FindFirstChild("Humanoid")
                if hitHum == humanoid then
                    game.Players.LocalPlayer.Character.Humanoid.Health = 0
                    DebugState.touchedFired = "YES1"
                    RefreshDebug()
                    doKill()
                end
            end)
        end

        local lastDistUpdate = 0
        local proximityConn
        proximityConn = RunService.Heartbeat:Connect(function()
            if not isAlive() then
                if proximityConn then proximityConn:Disconnect() end
                return
            end
            local liveChar = player.Character
            local hrp = liveChar and liveChar:FindFirstChild("HumanoidRootPart")
            if not hrp or not dilarious.PrimaryPart then return end
            if liveChar:GetAttribute("Hiding") then return end

            local dist = (hrp.Position - dilarious.PrimaryPart.Position).Magnitude
            local now = tick()
            if now - lastDistUpdate > 0.15 then
                lastDistUpdate = now
                DebugState.distance = string.format("%.1f", dist)
                RefreshDebug()
            end
            if dist <= KILL_RANGE then
                DebugState.proximityFired = "YES at " .. string.format("%.1f", dist)
                RefreshDebug()
                doKill()
            end
        end)

        -- Camera pull. Nudges Main_Game's target angles a little further toward
        -- looking at Dilarious every frame -- additive, not a hard set.
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

        -- Rush control. Flips the Spawner's own NoAI attribute, which its patrol
        -- movement already checks and pauses on.
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

        -- Safety despawn: same room-49 checkpoint the old version used.
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
            if debugGui then pcall(function() debugGui:Destroy() end) end
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
