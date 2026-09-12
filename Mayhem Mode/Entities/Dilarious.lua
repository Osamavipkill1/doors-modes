-- Dilarious, rebuilt. Old version: wandered its path, physically dragged the player
-- toward it, ground them down with repeated small touch damage. New version keeps
-- the same asset and the same patrol movement, but the challenge is now "don't look
-- at it": touching it is an instant kill, it can't hurt you just by being seen, and
-- looking directly at it with a clear line of sight (same raycast technique Manic
-- Eyes uses) is what makes it lock on and rush you at double Mimic Rush's speed. It
-- also constantly, passively tries to turn your camera onto it -- stronger the
-- closer it is -- and fighting that with your own mouse movement is how you keep
-- from ever looking at it in the first place.
local Spawner = LoadCachedModule("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/EntitySpawnerFork/Source.lua")

local entityTable = Spawner.createEntity({
    CustomName = "Dilarious",
    Model = "rbxassetid://12913584112",
    Speed = 20, -- patrol speed, unchanged from the old version (~12 studs/sec)
    DelayTime = 2,
    HeightOffset = 0,
    CanKill = false, -- touch-kill is handled by the Hitbox below, not the Spawner's own proximity/sight kill
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
local RunService = game:GetService("RunService")

-----[[  Debug -=- Advanced  ]]-----
entityTable.Debug.OnEntitySpawned = function()
    task.spawn(function()
        local dilarious = game.Workspace:WaitForChild("Dilarious", 5)
        if not dilarious then
            warn("[Mayhem/Dilarious] Model never appeared in workspace, aborting.")
            return
        end

        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local camera = workspace.CurrentCamera

        -- Same fallback the old version used: a dedicated anchor part if the model
        -- has one, otherwise PrimaryPart. Reused for the camera-pull target, the
        -- raycast target, and the point the rush chases toward.
        local function getAnchor()
            return dilarious:FindFirstChild("DilariousMov") or dilarious.PrimaryPart
        end

        local function isAlive()
            return dilarious.Parent ~= nil and humanoid.Health > 0
        end

        -- Instant kill on touch. No more gradual damage -- one touch ends the run.
        local Part = dilarious:FindFirstChild("Hitbox")
        if not Part then
            warn("[Mayhem/Dilarious] No 'Hitbox' child on the model -- touch-kill disabled for this spawn.")
        end

        local alreadyKilled = false
        local touchConn
        local function dmg(hit)
            if alreadyKilled then return end
            local hitChar = hit and hit.Parent
            local hitHum = hitChar and hitChar:FindFirstChild("Humanoid")
            if not hitHum or hitHum ~= humanoid then return end
            alreadyKilled = true

            pcall(function() SetDeathCause("Dilarious") end)
            local hintOk, hintErr = pcall(firesignal, game:GetService("ReplicatedStorage").EntityInfo.DeathHint.OnClientEvent, entityTable.Config.CustomDialog, entityTable.Config.Color)
            if not hintOk then
                warn("[Mayhem/Dilarious] DeathHint firesignal failed: " .. tostring(hintErr))
            end
            pcall(function() GuaranteeKill(hitHum) end)
        end
        if Part then
            touchConn = Part.Touched:Connect(dmg)
        end

        -- Camera pull. Runs on plain RenderStepped, which resolves after the
        -- engine's own camera update for the frame, so this is a small nudge added
        -- on top of wherever the player's mouse just put the camera -- not a hard
        -- override. Actively turning away wins out over it instead of fighting a
        -- losing battle. Strength scales with distance: barely noticeable far away,
        -- hard to resist up close.
        local pullConn
        pullConn = RunService.RenderStepped:Connect(function(dt)
            if not isAlive() then
                if pullConn then pullConn:Disconnect() end
                return
            end
            local anchor = getAnchor()
            if not anchor then return end

            local camPos = camera.CFrame.Position
            local toTarget = anchor.Position - camPos
            local dist = toTarget.Magnitude
            if dist < 1 then return end

            -- Full strength at/under 8 studs, fading to nothing by 80 studs out.
            local minDist, maxDist = 8, 80
            local proximity = 1 - math.clamp((dist - minDist) / (maxDist - minDist), 0, 1)
            if proximity <= 0 then return end

            local pullRatePerSecond = proximity * 1.6
            local alpha = 1 - math.exp(-pullRatePerSecond * dt)
            local newLook = camera.CFrame.LookVector:Lerp(toTarget.Unit, alpha)
            if newLook.Magnitude > 0.0001 then
                camera.CFrame = CFrame.new(camPos, camPos + newLook.Unit)
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
        rayParams.FilterDescendantsInstances = {character, dilarious}
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
