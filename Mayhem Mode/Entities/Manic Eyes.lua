_G.KillEntity = "false"
game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
local lastroom = game:GetService("ReplicatedStorage").GameData.LatestRoom.Value
-- Load the Functions module
local SelfModules = {
Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/EntitySpawnerFork/Functions.lua"))(),
}

-- Load a custom instance model from a URL or local file
local entityModel = game:GetObjects("rbxassetid://12802831625")[1]

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
        entityModel.Name = "ManicEyes"
    end

    entityModel:SetAttribute("IsCustomEntity", true)
    entityModel:SetAttribute("NoAI", false)
local sound = entityModel:FindFirstChild("Core"):FindFirstChild("Initiate")
if sound then
    sound:Play()
end
game:GetService("TweenService"):Create(entityModel.Core.PointLight2, TweenInfo.new(1, Enum.EasingStyle.Linear), {Brightness = 2}):Play()
game:GetService("TweenService"):Create(entityModel.Core.PointLight1, TweenInfo.new(1, Enum.EasingStyle.Linear), {Brightness = 2}):Play()
task.wait(0.2)
entityModel.Core.MainEyes.Angry.Enabled = true
task.wait(0.1)
entityModel.Core.MainEyes.Eyes.Enabled = true
task.wait(0.2)
entityModel.Core.MainEyes.Bite.Enabled = true
task.wait(0.75)
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
cube.Position = entityModel.PrimaryPart.Position + Vector3.new(0, 0.5, 0)
cube.Transparency = 1
-- create a flag that indicates whether the cube has been removed
local cubeRemoved = false

-- register a callback function for the RemoveEntity event
--[[RemoveEntityEvent.OnClientEvent:Connect(function()
    cube:Destroy()
    cubeRemoved = true
end)]]--
-- register a callback function for the Changed event
game.ReplicatedStorage.GameData.LatestRoom.Changed:Connect(function()
  -- remove the cube
  cube:Destroy()

  -- set the flag to indicate that the cube has been removed
  cubeRemoved = true

  -- remove the entity
game:GetService("TweenService"):Create(entityModel.Core.PointLight2, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {Brightness = 0}):Play()
game:GetService("TweenService"):Create(entityModel.Core.PointLight1, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {Brightness = 0}):Play()
task.wait(0.1)
entityModel.Core.MainEyes.Angry.Enabled = true
task.wait(0.05)
entityModel.Core.MainEyes.Eyes.Enabled = true
task.wait(0.1)
entityModel.Core.MainEyes.Bite.Enabled = true
task.wait(0.3)
  entityModel:Destroy()
end)

-- create a while loop to check if the player is facing the cube
while true do
  -- wait 0.1 seconds before checking again
    wait(0.1)
    RemoveGreed = _G.KillEntity
    if RemoveGreed then
        if _G.KillEntity == "true" then
            -- remove the cube
            cube:Destroy()
            -- set the flag to indicate that the cube has been removed
            cubeRemoved = true
            break
        end
    end
   -- check if the player should be killed
  if humanoid.Health <= 5 then
    -- player is nearly dead, so we don't need to check if they are facing the cube, and we can activate the death message.
  end
    -- check if the player is dead
  if humanoid.Health <= 0 then
  local msg = {"Oh... hello.", "Not this place again...", "Nevermind that... What'd you die to?", "Oh... the golden eyes.", "They are very similar to the eyes...", "Maybe you could call them Manic Eyes?", "Anyways, I hope you don't mind trying again. It would be helpful."} -- death message
local color = "Yellow"
firesignal(game:GetService("ReplicatedStorage").EntityInfo.DeathHint.OnClientEvent, msg, color)
game.ReplicatedStorage.GameStats["Player_".. game.Players.LocalPlayer.Name].Total.DeathCause.Value = "Manic Eyes"
    -- player is dead, so we don't need to check if they are facing the cube
    break
  end

  -- check if the cube has been removed
  if cubeRemoved then
    -- the cube has been removed, so we don't need to check if the player is facing it
    break
  end

  -- calculate the direction vector from the player's head to the cube
  local direction = (cube.Position - character.HumanoidRootPart.Position).unit

  -- check if the player's lookVector is close to the direction vector
  if direction:Dot(character.HumanoidRootPart.CFrame.lookVector.unit) > 0.6 then
    -- player is not facing the cube, apply damage
    humanoid:TakeDamage(10)
  end
end
end
end
