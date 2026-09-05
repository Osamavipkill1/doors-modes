local Players = game:GetService("Players")
local ReSt = game:GetService("ReplicatedStorage")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local CG = game:GetService("CoreGui")

local Plr = Players.LocalPlayer
local Char = Plr.Character or Plr.CharacterAdded:Wait()
local humanoid = Char:WaitForChild("Humanoid")
local Camera = workspace.CurrentCamera
local CanMove = true

function setup_blackout()
    local bo_time = 7
    local audios = {
        { id = "rbxassetid://176554627",  name = "hardcore_heartbeat",  looped = true,  PlaybackSpeed = 1 },
        { id = "rbxassetid://8316701225", name = "lights_shutdown",     looped = false, PlaybackSpeed = 1 },
        { id = "rbxassetid://876800936",  name = "lights_turnon",       looped = false, PlaybackSpeed = 1 },
        { id = "rbxassetid://8991674830", name = "jumpscare_blackout",  looped = false, PlaybackSpeed = 1 },
    }

    for _, audio in pairs(audios) do
        local sound = Instance.new("Sound", workspace)
        sound.SoundId = audio.id
        sound.Name = audio.name
        sound.Looped = audio.looped
        sound.PlaybackSpeed = audio.PlaybackSpeed
        if sound.Name == "jumpscare_blackout" then
            local pitchshift = Instance.new("PitchShiftSoundEffect", sound)
            pitchshift.Octave = 0.5
        -- FIX: was  `sound.Name == lights_turnon` (missing quotes, always false)
        elseif sound.Name == "lights_turnon" then
            local reverb = Instance.new("ReverbSoundEffect", sound)
            reverb.WetLevel = -40
        end
    end

    game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
    _G.Blackout = "unsafe"

    local spawn_waittime = 1
    task.wait(spawn_waittime)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 100

    local Frame = Instance.new("Frame")
    local ImageLabel = Instance.new("ImageLabel")

    ScreenGui.Parent = CG
    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.new(0, 0, 0)
    Frame.BackgroundTransparency = 0
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.Position = UDim2.new(0, 0, 0, 0)
    Frame.BorderSizePixel = 0

    ImageLabel.Parent = Frame
    ImageLabel.Size = UDim2.new(1.2, 0, 1, 0)
    ImageLabel.Position = UDim2.new(-0.1, 0, 0, 0)
    ImageLabel.Image = "rbxassetid://93331162433769"
    ImageLabel.ImageTransparency = 1
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Visible = false
    ImageLabel.ScaleType = Enum.ScaleType.Stretch

    local lightsdownsnd = workspace:FindFirstChild("lights_shutdown")
    if lightsdownsnd then
        lightsdownsnd:Play()
    end

    task.wait(1.5)
    CanMove = false

    local heartbeatsnd = workspace:FindFirstChild("hardcore_heartbeat")
    -- FIX: jumpscare_active scoped here so the timeout block can read it
    local jumpscare_active = false

    RS.Stepped:Connect(function()
        if not CanMove
            and not jumpscare_active
            and (humanoid.MoveDirection.Magnitude > 0)
        then
            jumpscare_active = true
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0

            -- show jumpscare image
            ImageLabel.Visible = true
            ImageLabel.ImageTransparency = 0
            ImageLabel.Size = UDim2.new(1.2, 0, 1, 0)
            ImageLabel.Position = UDim2.new(-0.1, 0, 0, 0)

            local killsndob = workspace:FindFirstChild("jumpscare_blackout")
            task.wait(0.5)
            if killsndob then killsndob:Play() end
            task.wait(0.3)

            -- FIX: zoom the image and then kill the player
            TS:Create(ImageLabel, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(2.4, 0, 2.2, 0),
                Position = UDim2.new(-0.7, 0, -0.6, 0),
            }):Play()
            task.wait(0.15)
            TS:Create(ImageLabel, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(4.8, 0, 4.4, 0),
                Position = UDim2.new(-1.9, 0, -1.7, 0),
            }):Play()
            task.wait(0.15)

            -- FIX: actually kill the player (original never called TakeDamage)
            humanoid.Health = 0

            if heartbeatsnd then heartbeatsnd:Stop() end
            task.wait(1.5)
            pcall(function() ScreenGui:Destroy() end)
            if killsndob then
                task.wait(2)
                killsndob:Destroy()
            end
        end
    end)

    if heartbeatsnd then
        heartbeatsnd:Play()
    end

    -- FIX: don't destroy the ScreenGui from the timeout path if jumpscare already fired
    task.wait(bo_time - 1.5)
    CanMove = true

    local lightsonsnd = workspace:FindFirstChild("lights_turnon")
    if lightsonsnd then
        if heartbeatsnd then heartbeatsnd:Stop() end
        lightsonsnd:Play()
    end

    -- only destroy if jumpscare didn't already handle it
    if not jumpscare_active then
        pcall(function() ScreenGui:Destroy() end)
    end

    _G.Blackout = "safe"
end

setup_blackout()
