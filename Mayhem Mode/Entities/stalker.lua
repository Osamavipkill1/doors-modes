_G.StalkerActive = true

-- Executor-safe GUI container detection
local guiParent = (gethui and gethui()) or game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Clean up any lingering leftover GUIs from previous executions
pcall(function()
    for _, child in ipairs(guiParent:GetChildren()) do
        if child:IsA("ScreenGui") and child.Name == "StalkerJumpscareGui" then
            child:Destroy()
        end
    end
end)

local urld = "https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/audio/in_room%20(1).mp3"
local urle = "https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/audio/jumpscare%20(1).mp3"
local spawnsnd = Instance.new("Sound")
local killsnd = Instance.new("Sound")

local getAssetFn = getsynasset or getcustomasset
pcall(function()
    writefile("stspawnsnd.mp3", game:HttpGet(urld))
    writefile("stkillsnd.mp3", game:HttpGet(urle))
    spawnsnd.Parent = game.Workspace
    killsnd.Parent = game.Workspace
    spawnsnd.SoundId = getAssetFn("stspawnsnd.mp3")
    killsnd.SoundId = getAssetFn("stkillsnd.mp3")
    spawnsnd.Volume = 1
    killsnd.Volume = 1
    spawnsnd.Looped = false
    killsnd.Looped = false
end)

local lastroom = game:GetService("ReplicatedStorage").GameData.LatestRoom.Value
local SelfModules = {
    Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/EntitySpawnerFork/Functions.lua"))(),
}

local entityModel = SelfModules.Functions.LoadCustomInstance("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/modules/stalk.rbxm")

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

if typeof(entityModel) == "Instance" and entityModel.ClassName == "Model" then
    -- Preload entity textures, meshes, and jumpscare image before parenting to Workspace
    pcall(function()
        local ContentProvider = game:GetService("ContentProvider")
        local tempImage = Instance.new("ImageLabel")
        tempImage.Image = "rbxassetid://91488327565377"
        
        local assetsToPreload = { entityModel, tempImage }
        for _, desc in ipairs(entityModel:GetDescendants()) do
            if desc:IsA("MeshPart") or desc:IsA("Decal") or desc:IsA("Texture") or desc:IsA("SpecialMesh") then
                table.insert(assetsToPreload, desc)
            end
        end
        ContentProvider:PreloadAsync(assetsToPreload)
        tempImage:Destroy()
    end)

    entityModel.PrimaryPart = entityModel.PrimaryPart or entityModel:FindFirstChildWhichIsA("BasePart")
    if entityModel.PrimaryPart then
        local direction = character.HumanoidRootPart.CFrame.LookVector
        local spawnPosition = character.HumanoidRootPart.Position + direction * 10
        entityModel.PrimaryPart.Position = spawnPosition
        entityModel.Parent = game.Workspace
        entityModel.PrimaryPart.Anchored = true
        if entityModel.Name then
            entityModel.Name = "StalkerMonster"
        end
        entityModel:SetAttribute("IsCustomEntity", true)
        entityModel:SetAttribute("NoAI", false)

        for _, part in pairs(entityModel:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end

        local cube = Instance.new("Part")
        cube.Anchored = true
        cube.CanCollide = false
        cube.Size = Vector3.new(1, 1, 1)
        cube.Parent = workspace
        cube.Position = entityModel.PrimaryPart.Position
        cube.Transparency = 1

        spawnsnd:Play()

        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {character, entityModel, cube}
        rayParams.FilterType = Enum.RaycastFilterType.Exclude

        local lookTime = 0
        local lastSeenTick = tick()
        local despawnAfter = math.random(5, 10)
        local wv = 0.1
        local jumpscareTriggered = false

        while true do
            task.wait(wv)

            if humanoid.Health <= 0 then break end

            local toEntity = (cube.Position - character.HumanoidRootPart.Position)
            local dot = toEntity.Unit:Dot(character.HumanoidRootPart.CFrame.LookVector)
            local isLooking = false

            if dot > 0.7 then
                local rayResult = workspace:Raycast(character.HumanoidRootPart.Position, toEntity, rayParams)
                local hasLineOfSight = (rayResult == nil) or (rayResult.Instance ~= nil and rayResult.Instance:IsDescendantOf(entityModel))
                isLooking = hasLineOfSight
            end

            if isLooking then
                lastSeenTick = tick()
                lookTime = lookTime + wv

                -- Requires 1.5 seconds of direct continuous gaze to attack
                if lookTime >= 1.5 and not jumpscareTriggered then
                    jumpscareTriggered = true

                    local ScreenGui = Instance.new("ScreenGui")
                    ScreenGui.Name = "StalkerJumpscareGui"
                    ScreenGui.ResetOnSpawn = false
                    ScreenGui.IgnoreGuiInset = true
                    ScreenGui.DisplayOrder = 100

                    local Frame = Instance.new("Frame")
                    Frame.Parent = ScreenGui
                    Frame.BackgroundColor3 = Color3.new(0, 0, 0)
                    Frame.BackgroundTransparency = 0
                    Frame.Visible = true
                    Frame.Size = UDim2.new(1, 0, 1, 0)
                    Frame.Position = UDim2.new(0, 0, 0, 0)
                    Frame.BorderSizePixel = 0

                    local ImageLabel = Instance.new("ImageLabel")
                    ImageLabel.Parent = Frame
                    ImageLabel.Size = UDim2.new(1.2, 0, 1, 0)
                    ImageLabel.Position = UDim2.new(-0.1, 0, 0, 0)
                    ImageLabel.Image = "rbxassetid://91488327565377"
                    ImageLabel.ImageTransparency = 0
                    ImageLabel.BackgroundTransparency = 1
                    ImageLabel.Visible = true

                    ScreenGui.Parent = guiParent

                    -- Safe cleanup with single-execution flag
                    local cleanedUp = false
                    local function cleanupJumpscare()
                        if cleanedUp then return end
                        cleanedUp = true
                        pcall(function() ScreenGui.Enabled = false end)
                        pcall(function() ScreenGui:Destroy() end)
                    end

                    -- Fail-safe destruction fallback after 1.5s max
                    task.delay(1.5, cleanupJumpscare)

                    killsnd:Play()
                    humanoid:TakeDamage(34)

                    local msg = {"Oh... hello.", "Not this place again...", "Nevermind that... What'd you die to?", "Oh... the tall one.", "I don't usually give out hints, but it hates being seen, and much prefers being the one to do so...", "Maybe you could call it Stalker?", "Anyways, I hope you don't mind trying again. It would be helpful."}
                    local color = "Yellow"
                    pcall(function() SetDeathCause("Stalker") end)
                    pcall(function()
                        firesignal(game:GetService("ReplicatedStorage").EntityInfo.DeathHint.OnClientEvent, msg, color)
                    end)

                    pcall(function()
                        local tween1 = game:GetService("TweenService"):Create(ImageLabel, TweenInfo.new(0.175, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            Size = UDim2.new(2.4, 0, 2, 0),
                            Position = UDim2.new(-0.7, 0, -0.5, 0),
                        })
                        tween1:Play()
                        tween1.Completed:Wait()

                        local tween2 = game:GetService("TweenService"):Create(ImageLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            Size = UDim2.new(4.8, 0, 4, 0),
                            Position = UDim2.new(-1.9, 0, -1.5, 0),
                        })
                        tween2:Play()
                        tween2.Completed:Wait()

                        task.wait(0.2)
                    end)

                    cleanupJumpscare()
                    _G.StalkerActive = false
                    break
                end
            else
                lookTime = 0
            end

            if (tick() - lastSeenTick) >= despawnAfter then
                break
            end
        end

        _G.StalkerActive = false

        -- Sink entity into the floor and destroy
        pcall(function()
            game:GetService("TweenService"):Create(entityModel.RushNew.Attachment.PointLight, TweenInfo.new(1, Enum.EasingStyle.Linear), {Brightness = 0}):Play()
            game:GetService("TweenService"):Create(entityModel.RushNew.Attachment.PointLight, TweenInfo.new(1, Enum.EasingStyle.Linear), {Range = 0}):Play()
            game:GetService("TweenService"):Create(entityModel.RushNew.Attachment.PointLight2, TweenInfo.new(1, Enum.EasingStyle.Linear), {Brightness = 0}):Play()
            game:GetService("TweenService"):Create(entityModel.RushNew.Attachment.PointLight2, TweenInfo.new(1, Enum.EasingStyle.Linear), {Range = 0}):Play()
            entityModel.RushNew.Attachment.ParticleEmitter.Rate = 7.5
            task.wait(0.1)
            entityModel.RushNew.Attachment.ParticleEmitter.Enabled = false
            local entity = entityModel.PrimaryPart
            local endPosition = entity.Position - Vector3.new(0, 20, 0)
            local tween = game:GetService("TweenService"):Create(entity, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {Position = endPosition})
            tween:Play()
            entityModel.RushNew.Attachment.GlitchEffect:Destroy()
            task.wait(0.26)
            entityModel:Destroy()
        end)

        pcall(function()
            if entityModel and entityModel.Parent then
                entityModel:Destroy()
            end
        end)
        pcall(function() cube:Destroy() end)
    end
end
