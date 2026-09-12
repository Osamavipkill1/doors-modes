
local envy = game:GetObjects("rbxassetid://12908979782")[1]
pcall(function()
    envy.Parent = game.ReplicatedStorage.Entities
end)

local lastroom = game:GetService("ReplicatedStorage").GameData.LatestRoom.Value

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

        task.spawn(function()
            local wasStopped = false
            local nextDamageTime = 0

            local function hitOnce()
                local wouldBeFatal = (humanoid.Health - 10) <= 0
                if wouldBeFatal then
                    local msg = {"Oh... hello.", "Not this place again...", "Nevermind that... What'd you die to?", "Oh... the green one.", "It hates when you stop, so...", "Maybe you could call it Envy?", "Anyways, I hope you don't mind trying again. It would be helpful."}
                    local color = "Yellow"
                    pcall(function() SetDeathCause("Envy") end)
                    local hintOk, hintErr = pcall(firesignal, game:GetService("ReplicatedStorage").EntityInfo.DeathHint.OnClientEvent, msg, color)
                    if not hintOk then
                        warn("[Mayhem/Envy] DeathHint firesignal failed: " .. tostring(hintErr))
                    end
                end
                -- Always apply the same clamped decrement, fatal or not -- that write is the
                -- one that's proven to actually stick. GuaranteeKill runs on top of it as
                -- reinforcement so the death sticks even if something else tries to undo it,
                -- instead of being the only thing standing between this hit and a kill.
                humanoid.Health = math.max(humanoid.Health - 10, 0)
                if wouldBeFatal then
                    pcall(function() GuaranteeKill(humanoid) end)
                end
                return wouldBeFatal
            end

            while running and entityModel and entityModel.Parent and humanoid.Health > 0 do
                task.wait(0.1)
                if humanoid.MoveDirection.Magnitude <= 0.01 then
                    if not wasStopped then
                        -- just stopped moving -- damage right away
                        wasStopped = true
                        hitOnce()
                        nextDamageTime = tick() + 0.3
                    elseif tick() >= nextDamageTime then
                        hitOnce()
                        nextDamageTime = tick() + 0.3
                    end
                else
                    wasStopped = false
                end
            end
        end)

        -- One room change and it's gone -- no lingering connection.
        game:GetService("ReplicatedStorage").GameData.LatestRoom.Changed:Wait()
        running = false
        pcall(function() entityModel:Destroy() end)
    end
end
