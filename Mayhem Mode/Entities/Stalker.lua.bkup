-- FIX: prevents two Stalkers ever being alive at once (the spawn loop never marked
-- LastRoomEntity for Stalker, so a second copy could spawn mid-encounter and leave
-- an extra, orphaned ScreenGui behind -- one plausible contributor to the "stuck
-- black screen" reports). Cleared on every exit path below.
_G.StalkerActive = true

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ImageLabel = Instance.new("ImageLabel")
ScreenGui.Name = "StalkerJumpscareGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 100

-- Executor-safe cleanup: remove any stale Stalker jumpscare GUI left by an
-- earlier execution before creating this one.
pcall(function()
    for _, child in ipairs(game.CoreGui:GetChildren()) do
        if child:IsA("ScreenGui") and child.Name == "StalkerJumpscareGui" then
            child.Enabled = false
            child:Destroy()
        end
    end
end)

ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.new(0, 0, 0)
Frame.BackgroundTransparency = 1
Frame.Visible = false
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.Position = UDim2.new(0, 0, 0, 0)
Frame.BorderSizePixel = 0

ImageLabel.Parent = Frame
ImageLabel.Size = UDim2.new(1.2, 0, 1, 0)
ImageLabel.Position = UDim2.new(-0.1, 0, 0, 0)
ImageLabel.Image = "rbxassetid://91488327565377"
ImageLabel.ImageTransparency = 1
ImageLabel.BackgroundTransparency = 1
ImageLabel.Visible = true

-- Preload the jumpscare image now so it's fully cached before the jumpscare fires.
-- Without this, Roblox loads it asynchronously and it may not be ready in time,
-- leaving only the black Frame background visible.
-- NOTE: if the screen is STILL just black after this, the image id itself is very
-- likely the same "asset id vs texture id" issue as the paintings had -- holding off
-- on swapping it per your request, but that's the next thing to try if this alone
-- doesn't fix it.
task.spawn(function()
    pcall(function()
        game:GetService("ContentProvider"):PreloadAsync({ ImageLabel })
    end)
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

    -- FIX: walk-through (no collision) but still fully visible, like Envy/Obsession
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

-- Raycast for wall (line-of-sight) detection, same approach as Manic Eyes
local rayParams = RaycastParams.new()
rayParams.FilterDescendantsInstances = {character, entityModel, cube}
rayParams.FilterType = Enum.RaycastFilterType.Exclude

-- lookTime tracks cumulative seconds of CONTINUOUS, unobstructed gaze needed to trigger
-- lastSeenTick tracks the last moment it was seen at all -- used for the despawn timer
local lookTime = 0
local lastSeenTick = tick()
-- FIX: despawns after 5-10s of NOT being looked at, instead of on room change
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
        -- FIX: raycast so walls block both the damage-trigger AND the "still seen" timer
        local rayResult = workspace:Raycast(character.HumanoidRootPart.Position, toEntity, rayParams)
        local hasLineOfSight = (rayResult == nil)
            or (rayResult.Instance ~= nil and rayResult.Instance:IsDescendantOf(entityModel))
        isLooking = hasLineOfSight
    end

    if isLooking then
        lastSeenTick = tick()
        lookTime = lookTime + wv

        -- FIX: 1 second, was 2
        if lookTime >= 1 and not jumpscareTriggered then
            jumpscareTriggered = true

            killsnd:Play()
            humanoid:TakeDamage(34)

            Frame.BackgroundTransparency = 0
            Frame.Visible = true
            ImageLabel.Visible = true
            ImageLabel.ImageTransparency = 0

            local msg = {"Oh... hello.", "Not this place again...", "Nevermind that... What'd you die to?", "Oh... the tall one.", "I don't usually give out hints, but it hates being seen, and much prefers being the one to do so...", "Maybe you could call it Stalker?", "Anyways, I hope you don't mind trying again. It would be helpful."}
            local color = "Yellow"
            pcall(function() SetDeathCause("Stalker") end)
            pcall(firesignal, game:GetService("ReplicatedStorage").EntityInfo.DeathHint.OnClientEvent, msg, color)

            -- Executor-safe cleanup. Do NOT rely on task.delay here: the jumpscare
            -- owns this GUI, so it is explicitly disabled and destroyed after the
            -- animation finishes. The cleanup is also safe if the tween errors.
            local function cleanupJumpscare()
                pcall(function()
                    ScreenGui.Enabled = false
                    Frame.Visible = false
                    ImageLabel.Visible = false
                end)
                pcall(function() ImageLabel:Destroy() end)
                pcall(function() Frame:Destroy() end)
                pcall(function() ScreenGui:Destroy() end)
            end

            -- Make absolutely sure the GUI is enabled when the jumpscare starts.
            ScreenGui.Enabled = true

            -- Visual sequence. Cleanup happens AFTER this pcall no matter whether
            -- the tween succeeds or errors.
            pcall(function()
                task.wait(0.5)
                game:GetService("TweenService"):Create(ImageLabel, TweenInfo.new(0.175, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Size = UDim2.new(2.4, 0, 2, 0),
                    Position = UDim2.new(-0.7, 0, -0.5, 0),
                }):Play()
                task.wait(0.175)
                game:GetService("TweenService"):Create(ImageLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Size = UDim2.new(4.8, 0, 4, 0),
                    Position = UDim2.new(-1.9, 0, -1.5, 0),
                }):Play()
                task.wait(0.2)
            end)

            -- HARD cleanup: this runs synchronously after the animation and cannot
            -- leave the full-screen Frame behind.
            cleanupJumpscare()
            _G.StalkerActive = false

            break
        end
    else
        -- Reset the continuous-gaze timer if the player looks away before hitting 2s,
        -- but keep tracking lastSeenTick separately for the despawn countdown below.
        lookTime = 0
    end

    -- FIX: despawn after 5-10s of not being seen at all, instead of waiting for a room change
    if (tick() - lastSeenTick) >= despawnAfter then
        break
    end
end

-- FIX: clears on EVERY exit path (health<=0, jumpscare, or the not-seen despawn timer),
-- not just the jumpscare path, so a Stalker that despawns quietly can't block the next one
_G.StalkerActive = false

-- sink entity into the floor and destroy
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
-- fallback in case the model doesn't have the RushNew visual rig for some reason
pcall(function()
    if entityModel and entityModel.Parent then
        entityModel:Destroy()
    end
end)
pcall(function() cube:Destroy() end)
end
end
