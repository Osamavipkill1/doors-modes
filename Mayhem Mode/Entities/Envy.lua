-- FIX: this used to register a PERMANENT LatestRoom.Changed:Connect (never disconnected),
-- so every time Mayhem.lua's periodic loop loaded this file again, ANOTHER listener got
-- stacked on top of the old ones -- eventually there were many, all spawning a fresh Envy
-- on every single room change. This file is now a straight-line one-shot script:
-- spawn once, wait for ONE room change, despawn, end. No self-reinstalling connection.

local envy = game:GetObjects("rbxassetid://12908979782")[1]
pcall(function()
    envy.Parent = game.ReplicatedStorage.Entities
end)

local lastroom = game:GetService("ReplicatedStorage").GameData.LatestRoom.Value
local SelfModules = {
    Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/EntitySpawnerFork/Functions.lua"))(),
}

local entityModel = envy:Clone()

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local floor = game:GetService("Workspace").CurrentRooms[lastroom].Parts.Floor.Position
if typeof(entityModel) == "Instance" and entityModel.ClassName == "Model" then
    entityModel.PrimaryPart = entityModel.PrimaryPart or entityModel:FindFirstChildWhichIsA("BasePart")

    if entityModel.PrimaryPart then
        entityModel.PrimaryPart.Position = floor + Vector3.new(0, 4, 0)
        entityModel.Parent = game.Workspace
        entityModel.PrimaryPart.Anchored = true
        entityModel.Name = "Envy"
        entityModel:SetAttribute("IsCustomEntity", true)
        entityModel:SetAttribute("NoAI", false)

        -- FIX: make it walk-through (no collision) but still fully visible, like Obsession
        for _, part in pairs(entityModel:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end

        local running = true

        -- Cosmetic escalation after 10s (unchanged from original, just pcall-guarded)
        task.spawn(function()
            task.wait(10)
            if running and entityModel and entityModel.Parent then
                pcall(function()
                    entityModel.GreenWithEnvy.PlaySound.PlaybackSpeed = 0.5
                    entityModel.GreenWithEnvy.Footsteps.PlaybackSpeed = 0.5
                    entityModel.GreenWithEnvy.Attachment.ParticleEmitter.Size = NumberSequence.new(6)
                    entityModel.GreenWithEnvy.Attachment.ParticleEmitter.Color = Color3.fromRGB(255, 0, 0)
                end)
            end
        end)

        -- NEW LOGIC: if you stop moving, you take gradual damage (10 per ~1s) --
        -- NOT an instant kill. Keep moving toward the next door and you're fine.
        task.spawn(function()
            local dmgCooldown = 0
            while running and entityModel and entityModel.Parent and humanoid.Health > 0 do
                task.wait(0.1)
                if humanoid.MoveDirection.Magnitude <= 0.01 then
                    dmgCooldown = dmgCooldown + 0.1
                    if dmgCooldown >= 1 then
                        humanoid:TakeDamage(10)
                        dmgCooldown = 0
                        if humanoid.Health <= 0 then
                            pcall(function() SetDeathCause("Envy") end)
                        end
                    end
                else
                    dmgCooldown = 0
                end
            end
        end)

        -- One room change and it's gone -- no lingering connection.
        game:GetService("ReplicatedStorage").GameData.LatestRoom.Changed:Wait()
        running = false
        pcall(function() entityModel:Destroy() end)
    end
end
