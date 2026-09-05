local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ImageLabel = Instance.new("ImageLabel")
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 100
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
ImageLabel.Image = "rbxassetid://107254484547011"
ImageLabel.ImageTransparency = 1
ImageLabel.BackgroundTransparency = 1
ImageLabel.Visible = true

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

local cube = Instance.new("Part")
cube.Anchored = true
cube.CanCollide = false
cube.Size = Vector3.new(1, 1, 1)
cube.Parent = workspace
cube.Position = entityModel.PrimaryPart.Position
cube.Transparency = 1

-- despawn entity if player leaves the room
game.ReplicatedStorage.GameData.LatestRoom.Changed:Connect(function()
    pcall(function() cube:Destroy() end)
    pcall(function() entityModel:Destroy() end)
    pcall(function() ScreenGui:Destroy() end)
end)

spawnsnd:Play()

-- lookTime tracks cumulative seconds the player has been looking at the Stalker
local lookTime = 0
local wv = 0.1
local jumpscareTriggered = false

while true do
    task.wait(wv)

    if humanoid.Health <= 0 then break end

    local toEntity = (cube.Position - character.HumanoidRootPart.Position)
    local dot = toEntity.Unit:Dot(character.HumanoidRootPart.CFrame.LookVector)

    if dot > 0.7 then
        -- player is looking at the Stalker — accumulate gaze time
        lookTime = lookTime + wv

        if lookTime >= 2 and not jumpscareTriggered then
            jumpscareTriggered = true

            -- jumpscare sequence
            killsnd:Play()
            -- FIX: damage is 33 as intended
            humanoid:TakeDamage(33)

            Frame.BackgroundTransparency = 0
            Frame.Visible = true
            ImageLabel.Visible = true
            ImageLabel.ImageTransparency = 0

            local msg = {"Oh... hello.", "Not this place again...", "Nevermind that... What'd you die to?", "Oh... the tall one.", "I don't usually give out hints, but it hates being seen, and much prefers being the one to do so...", "Maybe you could call it Stalker?", "Anyways, I hope you don't mind trying again. It would be helpful."}
            local color = "Yellow"
            pcall(function() game.ReplicatedStorage.GameStats["Player_".. player.Name].Total.DeathCause.Value = "Stalker" end)
            pcall(firesignal, game:GetService("ReplicatedStorage").EntityInfo.DeathHint.OnClientEvent, msg, color)

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
            game:GetService("TweenService"):Create(ImageLabel, TweenInfo.new(0.175, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(5.2, 0, 4.25, 0),
                Position = UDim2.new(-2.1, 0, -1.6, 0),
            }):Play()
            task.wait(0.175)
            pcall(function() ImageLabel:Destroy() end)
            pcall(function() Frame:Destroy() end)
            pcall(function() ScreenGui:Destroy() end)
            break
        end
    else
        -- FIX: was `else break` which exited the loop the moment the player
        -- looked at the Stalker before 2s had passed, making it impossible to trigger.
        -- Now we just reset the gaze timer so the player must hold the stare continuously.
        lookTime = 0
    end
end

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
pcall(function() cube:Destroy() end)
end
end
