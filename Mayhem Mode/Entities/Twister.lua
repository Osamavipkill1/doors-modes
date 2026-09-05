local urla = "https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/audio/Twister_apperiance.mp3"
local urlb = "https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/audio/Twister_apperiance_3.mp3"
local urlc = "https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/audio/Twister_apperiance_next.mp3"
local urld = "https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/audio/twister_scream_appereance.mp3"
local urle = "https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/audio/death_jumpscare.mp3"
local appear1 = Instance.new("Sound")
local appear2 = Instance.new("Sound")
local appear3 = Instance.new("Sound")
local spawnsnd = Instance.new("Sound")
local killsnd = Instance.new("Sound")

local getAssetFn = getsynasset or getcustomasset
pcall(function()
    writefile("spawn1.mp3", game:HttpGet(urla))
    writefile("spawn2.mp3", game:HttpGet(urlb))
    writefile("spawn3.mp3", game:HttpGet(urlc))
    writefile("spawnsnd.mp3", game:HttpGet(urld))
    writefile("killsnd.mp3", game:HttpGet(urle))
    appear1.Parent = game.Workspace
    appear2.Parent = game.Workspace
    appear3.Parent = game.Workspace
    spawnsnd.Parent = game.Workspace
    killsnd.Parent = game.Workspace
    appear1.SoundId = getAssetFn("spawn1.mp3")
    appear2.SoundId = getAssetFn("spawn2.mp3")
    appear3.SoundId = getAssetFn("spawn3.mp3")
    spawnsnd.SoundId = getAssetFn("spawnsnd.mp3")
    killsnd.SoundId = getAssetFn("killsnd.mp3")
    appear1.Volume = 1
    appear2.Volume = 1
    appear3.Volume = 1
    spawnsnd.Volume = 1
    killsnd.Volume = 1
    appear1.Looped = false
    appear2.Looped = false
    appear3.Looped = false
    spawnsnd.Looped = false
    killsnd.Looped = false
end)

appear1:Play()
task.wait(0.25)
appear2:Play()
task.wait(0.25)
appear3:Play()
game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()

local lastroom = game:GetService("ReplicatedStorage").GameData.LatestRoom.Value
local SelfModules = {
Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/EntitySpawnerFork/Functions.lua"))(),
}

local entityModel = game:GetObjects("rbxassetid://12802494019")[1]

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local floor = game:GetService("Workspace").CurrentRooms[lastroom].Parts.Floor.Position
if typeof(entityModel) == "Instance" and entityModel.ClassName == "Model" then
entityModel.PrimaryPart = entityModel.PrimaryPart or entityModel:FindFirstChildWhichIsA("BasePart")
if entityModel.PrimaryPart then
    entityModel.PrimaryPart.Position = floor + Vector3.new(0, 5, 0)
    entityModel.Parent = game.Workspace
    entityModel.PrimaryPart.Anchored = true
    if entityModel.Name then
        entityModel.Name = "ScreamStare"
    end
    entityModel:SetAttribute("IsCustomEntity", true)
    entityModel:SetAttribute("NoAI", false)

local CanMove = false
local StopChecking = false

task.spawn(function()
    while true do
        if StopChecking then
            game:GetService("TweenService"):Create(entityModel.ScreamNew.Attachment.PointLight, TweenInfo.new(1, Enum.EasingStyle.Linear), {Brightness = 0}):Play()
            game:GetService("TweenService"):Create(entityModel.ScreamNew.Attachment.PointLight, TweenInfo.new(1, Enum.EasingStyle.Linear), {Range = 0}):Play()
            entityModel.ScreamNew.Attachment.ParticleEmitter.Enabled = false
            task.wait(0.75)
            entityModel.ScreamNew.Attachment.BlackTrail.Enabled = false
            task.wait(1)
            entityModel:Destroy()
            break
        end
        task.wait(0.5)
        if humanoid.Health <= 0 then
            killsnd:Play()
            pcall(function() appear1:Destroy() end)
            pcall(function() appear2:Destroy() end)
            pcall(function() appear3:Destroy() end)
            pcall(function() spawnsnd:Destroy() end)
            local msg = {"Oh... hello.", "Not this place again...", "Nevermind that... What'd you die to?", "Oh... those eyes.", "It is very loud...", "I don't usually give hints, but it likes to come back, and hates movement...", "It also loves a plot twist...", "Maybe you could call it Twister?", "Anyways, I hope you don't mind trying again. It would be helpful."}
            local color = "Yellow"
            pcall(firesignal, game:GetService("ReplicatedStorage").EntityInfo.DeathHint.OnClientEvent, msg, color)
            pcall(function() game.ReplicatedStorage.GameStats["Player_".. player.Name].Total.DeathCause.Value = "Twister" end)
            StopChecking = true
        end
        -- FIX: damage increased from 15 to 33
        if not StopChecking and not CanMove and humanoid.MoveDirection.Magnitude > 0 then
            humanoid:TakeDamage(33)
        end
        task.wait(0.5)
    end
end)

-- volume fade out
task.wait(2)
for vol = 9, 0, -1 do
    entityModel.ScreamNew.Footsteps.Volume = vol / 10
    entityModel.ScreamNew.PlaySound.Volume = vol / 10
    task.wait(0.1)
end
StopChecking = true
end
end
