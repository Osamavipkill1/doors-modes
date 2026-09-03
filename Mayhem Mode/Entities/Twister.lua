-- 12802494019
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
if syn then
writefile("spawn1.mp3", game:HttpGet(urla))
writefile("spawn2.mp3", game:HttpGet(urlb))
writefile("spawn3.mp3", game:HttpGet(urlc))
writefile("spawnsnd.mp3", game:HttpGet(urld))
writefile("killsnd.mp3", game:HttpGet(urle))
local a = appear1
local b = appear2
local c = appear3
local d = spawnsnd
local e = killsnd
a.Parent = game.Workspace
b.Parent = game.Workspace
c.Parent = game.Workspace
d.Parent = game.Workspace
e.Parent = game.Workspace
a.SoundId = getsynasset("spawn1.mp3")
b.SoundId = getsynasset("spawn2.mp3")
c.SoundId = getsynasset("spawn3.mp3")
d.SoundId = getsynasset("spawnsnd.mp3")
e.SoundId = getsynasset("killsnd.mp3")
a.Volume = 1
b.Volume = 1
c.Volume = 1
d.Volume = 1
e.Volume = 1
a.Name = "spawn1.mp3"
b.Name = "spawn2.mp3"
c.Name = "spawn3.mp3"
d.Name = "spawnsnd.mp3"
e.Name = "killsnd.mp3"
a.Looped = false
b.Looped = false
c.Looped = false
d.Looped = false
e.Looped = false
else
writefile("spawn1.mp3", game:HttpGet(urla))
writefile("spawn2.mp3", game:HttpGet(urlb))
writefile("spawn3.mp3", game:HttpGet(urlc))
writefile("spawnsnd.mp3", game:HttpGet(urld))
writefile("killsnd.mp3", game:HttpGet(urle))
local a = appear1
local b = appear2
local c = appear3
local d = spawnsnd
local e = killsnd
a.Parent = game.Workspace
b.Parent = game.Workspace
c.Parent = game.Workspace
d.Parent = game.Workspace
e.Parent = game.Workspace
a.SoundId = getcustomasset("spawn1.mp3")
b.SoundId = getcustomasset("spawn2.mp3")
c.SoundId = getcustomasset("spawn3.mp3")
d.SoundId = getcustomasset("spawnsnd.mp3")
e.SoundId = getcustomasset("killsnd.mp3")
a.Volume = 1
b.Volume = 1
c.Volume = 1
d.Volume = 1
e.Volume = 1
a.Name = "spawn1.mp3"
b.Name = "spawn2.mp3"
c.Name = "spawn3.mp3"
d.Name = "spawnsnd.mp3"
e.Name = "killsnd.mp3"
a.Looped = false
b.Looped = false
c.Looped = false
d.Looped = false
e.Looped = false
end

function Scream()
    spawnsnd:Play()
end
appear1:Play()
task.wait(0.25)
appear2:Play()
task.wait(0.25)
appear3:Play()
game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()


local lastroom = game:GetService("ReplicatedStorage").GameData.LatestRoom.Value
-- Load the Functions module
local SelfModules = {
Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/EntitySpawnerFork/Functions.lua"))(),
}

-- Load a custom instance model from a URL or local file
local entityModel = game:GetObjects("rbxassetid://12802494019")[1]

-- Get the player's character and humanoid
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local floor = game:GetService("Workspace").CurrentRooms[lastroom].Parts.Floor.Position
if typeof(entityModel) == "Instance" and entityModel.ClassName == "Model" then
entityModel.PrimaryPart = entityModel.PrimaryPart or entityModel:FindFirstChildWhichIsA("BasePart")
if entityModel.PrimaryPart then
    -- Position
    entityModel.PrimaryPart.Position = floor
    entityModel.PrimaryPart.Position = entityModel.PrimaryPart.Position + Vector3.new(0, 5, 0)
    -- Set the parent of the model to game.Workspace
    entityModel.Parent = game.Workspace

    entityModel.PrimaryPart.Anchored = true

    -- Set the name of the model
    if entityModel.Name then
        entityModel.Name = "ScreamStare"
    end

    entityModel:SetAttribute("IsCustomEntity", true)
    entityModel:SetAttribute("NoAI", false)



-- look at entity script
local canmove = false
local player = game.Players.LocalPlayer
local character = player.Character
local humanoid = character:WaitForChild("Humanoid")
local StopChecking = false



-- create a while loop to check if the player is facing the cube
coroutine.wrap(function()
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
    -- check if the player is dead
  if humanoid.Health <= 0 then
      killsnd:Play()
appear1:Destroy()
appear2:Destroy()
appear3:Destroy()
spawnsnd:Destroy()
  local msg = {"Oh... hello.", "Not this place again...", "Nevermind that... What'd you die to?", "Oh... those eyes.", "It is very loud...", "I don't usually give hints, but it likes to come back, and hates movement...", "It also loves a plot twist...", "Maybe you could call it Twister?", "Anyways, I hope you don't mind trying again. It would be helpful."} -- death message
local color = "Yellow"
firesignal(game:GetService("ReplicatedStorage").EntityInfo.DeathHint.OnClientEvent, msg, color)
game.ReplicatedStorage.GameStats["Player_".. game.Players.LocalPlayer.Name].Total.DeathCause.Value = "Twister"
    -- player is dead, so we don't need to check if they are facing the cube
    StopChecking = true
  end

  if not StopChecking and not CanMove and (humanoid.MoveDirection.X > 0 or humanoid.MoveDirection.X < 0 or humanoid.MoveDirection.Z > 0 or humanoid.MoveDirection.Z < 0 or humanoid.MoveDirection.Y > 0 or humanoid.MoveDirection.Y < 0) then
    -- player is not facing the cube, apply damage
    humanoid:TakeDamage(15)
  end
  task.wait(0.5)
end
end)()
task.wait(2)
entityModel.ScreamNew.Footsteps.Volume = 0.9
entityModel.ScreamNew.PlaySound.Volume = 0.9
task.wait(0.1)
entityModel.ScreamNew.Footsteps.Volume = 0.8
entityModel.ScreamNew.PlaySound.Volume = 0.8
task.wait(0.1)
entityModel.ScreamNew.Footsteps.Volume = 0.7
entityModel.ScreamNew.PlaySound.Volume = 0.7
task.wait(0.1)
entityModel.ScreamNew.Footsteps.Volume = 0.6
entityModel.ScreamNew.PlaySound.Volume = 0.6
task.wait(0.1)
entityModel.ScreamNew.Footsteps.Volume = 0.5
entityModel.ScreamNew.PlaySound.Volume = 0.5
task.wait(0.1)
entityModel.ScreamNew.Footsteps.Volume = 0.4
entityModel.ScreamNew.PlaySound.Volume = 0.4
task.wait(0.1)
entityModel.ScreamNew.Footsteps.Volume = 0.3
entityModel.ScreamNew.PlaySound.Volume = 0.3
task.wait(0.1)
entityModel.ScreamNew.Footsteps.Volume = 0.2
entityModel.ScreamNew.PlaySound.Volume = 0.2
task.wait(0.1)
entityModel.ScreamNew.Footsteps.Volume = 0.1
entityModel.ScreamNew.PlaySound.Volume = 0.1
task.wait(0.1)
entityModel.ScreamNew.Footsteps.Volume = 0
entityModel.ScreamNew.PlaySound.Volume = 0
StopChecking = true
end
end
