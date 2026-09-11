local Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/EntitySpawnerFork/Source.lua"))()

local entityTable = Spawner.createEntity({
    CustomName = "Dilarious",
    Model = "rbxassetid://12913584112",
    Speed = 20,
    DelayTime = 2,
    HeightOffset = 0,
    CanKill = false,
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
    CustomDialog = {"Oh... hello.", "Not this place again...", "Nevermind that... What'd you die to?", "Oh... the slow one.", "It doesn't chase, it pulls -- get too close and it doesn't let you leave easily, so...", "Maybe you could call it Dilarious?", "Anyways, I hope you don't mind trying again. It would be helpful."},
    Color = "Yellow",
})

if not entityTable then
    warn("[Mayhem/Dilarious] Failed to create -- check the Asset id is still valid.")
    return
end

entityTable.Debug.OnEntitySpawned = function()
    task.spawn(function()
        local dilarious = game.Workspace:WaitForChild("Dilarious", 5)
        if not dilarious then
            warn("[Mayhem/Dilarious] Model never appeared in workspace, aborting.")
            return
        end

        local Part = dilarious:FindFirstChild("Hitbox")
        if not Part then
            warn("[Mayhem/Dilarious] No 'Hitbox' child on the model -- touch damage disabled for this spawn.")
        end

        local player = game.Players.LocalPlayer
        local hum = player.Character and player.Character:FindFirstChild("Humanoid")

        local lastHitTime = 0
        local function dmg(hit)
            local char = hit and hit.Parent
            local hitHum = char and char:FindFirstChild("Humanoid")
            if not hitHum or hitHum ~= hum then return end
            if tick() - lastHitTime < 0.5 then return end
            lastHitTime = tick()

            local wouldBeFatal = (hitHum.Health - 10) <= 0
            if wouldBeFatal then
                pcall(function() SetDeathCause("Dilarious") end)
                local hintOk, hintErr = pcall(firesignal, game:GetService("ReplicatedStorage").EntityInfo.DeathHint.OnClientEvent, {"Oh... hello.", "Not this place again...", "Nevermind that... What'd you die to?", "Oh... the slow one.", "It doesn't chase, it pulls -- get too close and it doesn't let you leave easily, so...", "Maybe you could call it Dilarious?", "Anyways, I hope you don't mind trying again. It would be helpful."}, "Yellow")
                if not hintOk then
                    warn("[Mayhem/Dilarious] DeathHint firesignal failed: " .. tostring(hintErr))
                end
                pcall(function() GuaranteeKill(hitHum) end)
            else
                hitHum.Health = math.max(hitHum.Health - 10, 0)
            end
        end

        local touchConn
        if Part then
            touchConn = Part.Touched:Connect(dmg)
        end

        -- Pull effect: get within 65 studs and the game starts dragging you toward it
        task.spawn(function()
            local movPart = dilarious:FindFirstChild("DilariousMov") or dilarious.PrimaryPart
            if not movPart then
                warn("[Mayhem/Dilarious] No movement reference part found -- pull effect disabled.")
                return
            end

            repeat task.wait() until workspace:FindFirstChild(player.Name) or not dilarious.Parent
            if not dilarious.Parent then return end

            local cam = workspace.CurrentCamera
            local ended = false

            local renderConn
            renderConn = game:GetService("RunService").RenderStepped:Connect(function()
                if ended then
                    if renderConn then renderConn:Disconnect() end
                    return
                end

                if not dilarious.Parent or not workspace:FindFirstChild(player.Name) then
                    ended = true
                    cam.FieldOfView = 70
                    if renderConn then renderConn:Disconnect() end
                    return
                end

                local latestRoom = game.ReplicatedStorage.GameData.LatestRoom.Value
                if latestRoom == 49 then
                    ended = true
                    cam.FieldOfView = 70
                    if renderConn then renderConn:Disconnect() end
                    pcall(function() dilarious:Destroy() end)
                    return
                end

                local workspaceplayer = workspace:FindFirstChild(player.Name)
                if not workspaceplayer or not workspaceplayer:FindFirstChild("HumanoidRootPart") then
                    return
                end

                local dist = (workspaceplayer.HumanoidRootPart.Position - movPart.Position).Magnitude
                local threshold = 65

                if dist <= threshold then
                    local Mag = dist - threshold
                    local accelerationSpeed = 25
                    local newframe = workspaceplayer.HumanoidRootPart.CFrame * CFrame.new(0, 0, -0.1 + (Mag / accelerationSpeed))
                    workspaceplayer.HumanoidRootPart.CFrame = newframe
                    workspaceplayer.HumanoidRootPart.CFrame = CFrame.lookAt(workspaceplayer.HumanoidRootPart.Position, movPart.Position)
                    cam.FieldOfView = math.clamp(70 - Mag, 70, 120)
                else
                    cam.FieldOfView = 70
                end
            end)
        end)

        entityTable.Debug.OnDespawned = function()
            if touchConn then touchConn:Disconnect() end
        end
    end)
end

entityTable.Debug.OnEntityDespawned = function() end
entityTable.Debug.OnEntityStartMoving = function() end
entityTable.Debug.OnEntityFinishedRebound = function() end
entityTable.Debug.OnEntityEnteredRoom = function(room) end
entityTable.Debug.OnLookAtEntity = function() end
entityTable.Debug.OnDeath = function() end

Spawner.runEntity(entityTable)
