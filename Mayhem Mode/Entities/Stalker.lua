local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Visible = false
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.new(0, 0, 0)
Frame.Transparency = 1
Frame.Visible = false
Frame.Size = UDim2.new(1, 0.5, 1.1, 1)
Frame.Position = UDim2.new(0,0,-0.1,0)

ImageLabel.Parent = Frame
ImageLabel.Size = UDim2.new(1.2, 0.4, 1, 0.4)
ImageLabel.Position = UDim2.new(-0.1,0,0,0)
ImageLabel.Image = "rbxassetid://107254484547011"
ImageLabel.ImageTransparency = 1
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
    spawnsnd.Name = "spawnsnd.mp3"
    killsnd.Name = "killsnd.mp3"
    spawnsnd.Looped = false
    killsnd.Looped = false
end)
local lastroom = game:GetService("ReplicatedStorage").GameData.LatestRoom.Value
-- Load the Functions module
local SelfModules = {
Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/EntitySpawnerFork/Functions.lua"))(),
}
Frame.Transparency = 0.99
ImageLabel.ImageTransparency = 0.99
Frame.Visible = true
ImageLabel.Visible = true
task.wait(0.001)
Frame.Transparency = 1
ImageLabel.ImageTransparency = 1
Frame.Visible = false
ImageLabel.Visible = false
-- Load a custom instance model from a URL or local file
local entityModel = SelfModules.Functions.LoadCustomInstance("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/modules/stalk.rbxm")

-- Get the player's character and humanoid
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

if typeof(entityModel) == "Instance" and entityModel.ClassName == "Model" then
entityModel.PrimaryPart = entityModel.PrimaryPart or entityModel:FindFirstChildWhichIsA("BasePart")
if entityModel.PrimaryPart then
    -- Calculate position in front of player
    local direction = character.HumanoidRootPart.CFrame.lookVector
    local spawnDistance = 10 -- distance from player to spawn the entity
    local spawnPosition = character.HumanoidRootPart.Position + direction * spawnDistance
    entityModel.PrimaryPart.Position = spawnPosition
    -- Set the parent of the model to game.Workspace
    entityModel.Parent = game.Workspace

    entityModel.PrimaryPart.Anchored = true

    -- Set the name of the model
    if entityModel.Name then
        entityModel.Name = "StalkerMonster"
    end

    entityModel:SetAttribute("IsCustomEntity", true)
    entityModel:SetAttribute("NoAI", false)
    

-- look at entity script
local player = game.Players.LocalPlayer
local character = player.Character
local humanoid = character:WaitForChild("Humanoid")

-- create a new cube object
local cube = Instance.new("Part")
cube.Anchored = true
cube.CanCollide = false
cube.Material = Enum.Material.Glass
cube.Size = Vector3.new(1,1,1)
cube.BrickColor = BrickColor.new("Bright green")
cube.Parent = workspace
cube.Position = entityModel.PrimaryPart.Position
cube.Transparency = 1
spawnsnd:Play()
local tme = 0
local wv = 0.1
local stopchecking = false
while true do
    task.wait(wv)
    tme = tme + wv
    local direction = (cube.Position - character.HumanoidRootPart.Position).unit
    if direction:Dot(character.HumanoidRootPart.CFrame.lookVector.unit) > 0.7 then
        if tme >= 2 and stopchecking == false then
-- player is not facing the cube, apply damage
stopchecking = true
killsnd:Play()
humanoid:TakeDamage(35)
Frame.Transparency = 0
Frame.Visible = true
ImageLabel.Visible = true
ImageLabel.ImageTransparency = 0
local msg = {"Oh... hello.", "Not this place again...", "Nevermind that... What'd you die to?", "Oh... the tall one.", "I don't usually give out hints, but it hates being seen, and much prefers being the one to do so...", "Maybe you could call it Stalker?", "Anyways, I hope you don't mind trying again. It would be helpful."} -- death message
local color = "Yellow"
game.ReplicatedStorage.GameStats["Player_".. game.Players.LocalPlayer.Name].Total.DeathCause.Value = "Stalker"
firesignal(game:GetService("ReplicatedStorage").EntityInfo.DeathHint.OnClientEvent, msg, color)
task.wait(0.1)
game.ReplicatedStorage.GameStats["Player_".. game.Players.LocalPlayer.Name].Total.DeathCause.Value = "Stalker"
firesignal(game:GetService("ReplicatedStorage").EntityInfo.DeathHint.OnClientEvent, msg, color)
task.wait(0.5)
ImageLabel.Size = UDim2.new(2.4, 0.8, 2, 0.8)
ImageLabel.Position = UDim2.new(-0.75,0.75,-0.5,0.75)
game.ReplicatedStorage.GameStats["Player_".. game.Players.LocalPlayer.Name].Total.DeathCause.Value = "Stalker"
firesignal(game:GetService("ReplicatedStorage").EntityInfo.DeathHint.OnClientEvent, msg, color)
task.wait(0.1)
game.ReplicatedStorage.GameStats["Player_".. game.Players.LocalPlayer.Name].Total.DeathCause.Value = "Stalker"
firesignal(game:GetService("ReplicatedStorage").EntityInfo.DeathHint.OnClientEvent, msg, color)
task.wait(0.2)
game.ReplicatedStorage.GameStats["Player_".. game.Players.LocalPlayer.Name].Total.DeathCause.Value = "Stalker"
firesignal(game:GetService("ReplicatedStorage").EntityInfo.DeathHint.OnClientEvent, msg, color)
ImageLabel.Size = UDim2.new(4.8, 1.6, 4, 1.6)
ImageLabel.Position = UDim2.new(-2,0,2,2)
task.wait(0.175)
ImageLabel.Size = UDim2.new(5.2, 1.8, 4.25, 1.8)
ImageLabel.Position = UDim2.new(-3,0,3,2)
task.wait(0.2)
ImageLabel:Destroy()
Frame:Destroy()
ScreenGui:Destroy()
break
end
else
break
end
end
game:GetService("TweenService"):Create(entityModel.RushNew.Attachment.PointLight, TweenInfo.new(1, Enum.EasingStyle.Linear), {Brightness = 0}):Play()
game:GetService("TweenService"):Create(entityModel.RushNew.Attachment.PointLight, TweenInfo.new(1, Enum.EasingStyle.Linear), {Range = 0}):Play()
game:GetService("TweenService"):Create(entityModel.RushNew.Attachment.PointLight2, TweenInfo.new(1, Enum.EasingStyle.Linear), {Brightness = 0}):Play()
game:GetService("TweenService"):Create(entityModel.RushNew.Attachment.PointLight2, TweenInfo.new(1, Enum.EasingStyle.Linear), {Range = 0}):Play()
entityModel.RushNew.Attachment.ParticleEmitter.Rate = 7.5
task.wait(0.1)
entityModel.RushNew.Attachment.ParticleEmitter.Enabled = false
local TweenService = game:GetService("TweenService")
local entity = entityModel.PrimaryPart
local endPosition = entity.Position - Vector3.new(0, 20, 0) -- move down by 10 studs
local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Linear) -- duration of 2 seconds, linear easing

local tween = TweenService:Create(entity, tweenInfo, {Position = endPosition})
tween:Play()
entityModel.RushNew.Attachment.GlitchEffect:Destroy()
task.wait(0.26)
entityModel:Destroy()
ImageLabel:Destroy()
Frame:Destroy()
ScreenGui:Destroy()
end
task.wait(0.075)
task.wait(math.random(1.500, 2.500))
end
