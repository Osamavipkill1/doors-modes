local Spawner = LoadCachedModule("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/EntitySpawnerFork/Source.lua")

local entityTable = Spawner.createEntity({
    CustomName = "Bleed",
    Model = "rbxassetid://93354759389091",
    Speed = 100,
    DelayTime = 2,
    HeightOffset = 0,
    CanKill = true,
    KillRange = 50,
    BackwardsMovement = false,
    BreakLights = false,
    FlickerLights = {
        true,
        1,
    },
    Cycles = {
        Min = 1,
        Max = 1,
        WaitTime = 2,
    },
    CamShake = {
        true,
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
    CustomDialog = {"Alright what happened this time...", "Oh, not sure who that is.", "Well he leave blood around in the rooms, so you could call him Bleed!"},
    Color = "Yellow",
})

if not entityTable then
    warn("[Mayhem/Bleed] Failed to create -- check the Asset id is still valid.")
    return
end

-----[[  Debug -=- Advanced  ]]-----
entityTable.Debug.OnEntitySpawned = function()
end

entityTable.Debug.OnEntityDespawned = function()
end

-- Fires blood particles outward periodically while Bleed is moving. Each one is a
-- small physical projectile (not a pure visual effect) so it can actually be touched:
-- it damages the player on contact and is destroyed either on hit or after 15s,
-- whichever comes first.
entityTable.Debug.OnEntityStartMoving = function()
    task.spawn(function()
        local player = game.Players.LocalPlayer
        while entityTable.Model and entityTable.Model.Parent do
            task.wait(math.random(20, 40) / 10)

            local originPart = entityTable.Model.PrimaryPart
            if not originPart then break end

            for i = 1, math.random(2, 4) do
                pcall(function()
                    local particle = Instance.new("Part")
                    particle.Name = "BleedParticle"
                    particle.Shape = Enum.PartType.Ball
                    particle.Size = Vector3.new(0.6, 0.6, 0.6)
                    particle.Material = Enum.Material.SmoothPlastic
                    particle.Color = Color3.fromRGB(120, 0, 0)
                    particle.CanCollide = false
                    particle.Anchored = false
                    particle.CFrame = CFrame.new(originPart.Position)
                    particle.Parent = workspace

                    local trail = Instance.new("ParticleEmitter")
                    trail.Color = ColorSequence.new(Color3.fromRGB(150, 0, 0))
                    trail.Size = NumberSequence.new(0.25)
                    trail.Lifetime = NumberRange.new(0.2, 0.4)
                    trail.Rate = 40
                    trail.Speed = NumberRange.new(0)
                    trail.Parent = particle

                    local randomDir = Vector3.new(math.random(-10, 10), math.random(2, 8), math.random(-10, 10))
                    if randomDir.Magnitude > 0 then
                        randomDir = randomDir.Unit
                    else
                        randomDir = Vector3.new(0, 1, 0)
                    end
                    particle.AssemblyLinearVelocity = randomDir * math.random(15, 30)

                    local touchedAlready = false
                    local touchConn
                    touchConn = particle.Touched:Connect(function(hit)
                        if touchedAlready then return end
                        local char = hit and hit.Parent
                        local hum = char and char:FindFirstChild("Humanoid")
                        if not hum or hum.Parent ~= player.Character then return end

                        touchedAlready = true
                        local wouldBeFatal = (hum.Health - 15) <= 0
                        if wouldBeFatal then
                            pcall(function() SetDeathCause("Bleed") end)
                            local hintOk, hintErr = pcall(firesignal, game:GetService("ReplicatedStorage").EntityInfo.DeathHint.OnClientEvent, {"Alright what happened this time...", "Oh, not sure who that is.", "Well he leave blood around in the rooms, so you could call him Bleed!"}, "Yellow")
                            if not hintOk then
                                warn("[Mayhem/Bleed] DeathHint firesignal failed: " .. tostring(hintErr))
                            end
                            pcall(function() GuaranteeKill(hum) end)
                        else
                            hum.Health = math.max(hum.Health - 15, 0)
                        end

                        if touchConn then touchConn:Disconnect() end
                        pcall(function() particle:Destroy() end)
                    end)

                    task.delay(15, function()
                        if touchConn then touchConn:Disconnect() end
                        if particle and particle.Parent then
                            particle:Destroy()
                        end
                    end)
                end)
            end
        end
    end)
end

entityTable.Debug.OnEntityFinishedRebound = function()
end

entityTable.Debug.OnEntityEnteredRoom = function(room)
    pcall(function()
        local color = Color3.fromRGB(255, 0, 0)
        room.LightBase.SurfaceLight.Enabled = true
        local Color1 = room.LightBase.SurfaceLight.Color
        local Tween1 = game:GetService("TweenService"):Create(room.LightBase.SurfaceLight, TweenInfo.new(2), {Color = color})
        local Tween2 = game:GetService("TweenService"):Create(room.LightBase.SurfaceLight, TweenInfo.new(2), {Color = Color1})
        task.spawn(function()
            Tween1:Play()
            task.wait(15)
            Tween2:Play()
        end)
        for _, thing in pairs(room.Assets:GetDescendants()) do
            if thing:FindFirstChild("LightFixture") then
                thing.LightFixture.Neon.Color = color
                for _, light in pairs(thing.LightFixture:GetChildren()) do
                    if light:IsA("SpotLight") or light:IsA("PointLight") then
                        light.Color = color
                    end
                end
            end
        end
    end)
end

entityTable.Debug.OnLookAtEntity = function()
end

entityTable.Debug.OnDeath = function()
end
------------------------------------

Spawner.runEntity(entityTable)
