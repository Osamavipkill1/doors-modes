-- Services

local Players = game:GetService("Players")
local ReSt = game:GetService("ReplicatedStorage")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local CG = game:GetService("CoreGui")

-- Variables

local Plr = Players.LocalPlayer
local Char = Plr.Character or Plr.CharacterAdded:Wait()
local humanoid = Char:WaitForChild("Humanoid")
local Camera = workspace.CurrentCamera
local CanMove = true

function setup_blackout()
    local bo_time = (7)
    local audios = {
    { id = "rbxassetid://176554627", name = "hardcore_heartbeat", looped = true, PlaybackSpeed = 1}, -- hardcore_heartbeat
    { id = "rbxassetid://8316701225", name = "lights_shutdown", looped = false, PlaybackSpeed = 1 }, -- lights_shutdown
    { id = "rbxassetid://876800936", name = "lights_turnon", looped = false, PlaybackSpeed = 1 }, -- lights_turnon
    { id = "rbxassetid://8991674830", name = "jumpscare_blackout", looped = false, PlaybackSpeed = 1,  } -- jumpscare_blackout
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
        print("pitchshift for jumpscare_blackout added")
    elseif sound.Name == lights_turnon then
        local reverb = Instance.new("ReverbSoundEffect")
        reverb.WetLevel = -40
        print("reverb for lights_turnon added")
    end
end
if humanoid.Health <= 0 then
    local BlackoutDead = true
else
    local BlackoutDead = false
end
game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
_G.Blackout = "unsafe" 
local spawn_waittime = 1
wait(spawn_waittime)
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Visible = false
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.new(0, 0, 0)
Frame.Size = UDim2.new(1, 0.5, 1.1, 1)
Frame.Position = UDim2.new(0,0,-0.1,0)

ImageLabel.Parent = Frame
ImageLabel.Size = UDim2.new(1.2, 0.4, 1, 0.4)
ImageLabel.Position = UDim2.new(-0.1,0,0,0)
ImageLabel.Image = "rbxassetid://12269324941"
ImageLabel.Visible = false
local Flash = Instance.new("ColorCorrectionEffect")
local lightsdownsnd = game.Workspace:findFirstChild("lights_shutdown")
if lightsdownsnd then
  lightsdownsnd:Play()
else
  print("Sound not found")
end
wait(1.5)
CanMove = false
local heartbeatsnd = game.Workspace:findFirstChild("hardcore_heartbeat")
local jumpscare_active = false
game:GetService("RunService").Stepped:Connect(function()
    if not CanMove and (humanoid.MoveDirection.X > 0 or humanoid.MoveDirection.X < 0 or humanoid.MoveDirection.Z > 0 or humanoid.MoveDirection.Z < 0 or humanoid.MoveDirection.Y > 0 or humanoid.MoveDirection.Y < 0) and not jumpscare_active then
	  jumpscare_active = true
	  humanoid.WalkSpeed = 0
	  humanoid.JumpPower = 0
	  ImageLabel.Visible = true
	  ImageLabel.Size = UDim2.new(1.2, 0.4, 1, 0.4)
      ImageLabel.Position = UDim2.new(-0.1,0,0,0)
      local killsndob = game.Workspace:findFirstChild("jumpscare_blackout")
      wait(1)
      killsndob:Play()
      wait(0.3)
        loadstring(game:HttpGet("https://gist.githubusercontent.com/wubbubunga-tll/755765666ce31ddeb91c907831961eef/raw/2a8ef3ef9c5a345e2fa9898c4e7b360b047d1855/thmsg"))()
        ImageLabel.Size = UDim2.new(2, 1, 2.2, 2)
        ImageLabel.Position = UDim2.new(-0.5,0,-0.5,0)
        local heartbeatsnd = game.Workspace:findFirstChild("hardcore_heartbeat")
        heartbeatsnd:Stop()
        wait(1.5)
        ScreenGui:Destroy()
        wait(2.5)
        killsndob:Destroy()
        wait(0.1)
	end
end)
wait(1.5)
if heartbeatsnd then
  heartbeatsnd:Play()
else
  print("Sound not found")
end
wait(bo_time - 0.1)
-- Death Check
if humanoid == nil then
    local Dead = true
    print("player is dead")
else
    local Dead = false
end
wait(0.1)
CanMove = true
local lightsonsnd = game.Workspace:findFirstChild("lights_turnon")
if lightsonsnd then
  heartbeatsnd:Stop()
  lightsonsnd:Play()
else
  print("Sound not found")
end
ScreenGui:Destroy()
_G.Blackout = "safe" 
end

setup_blackout()