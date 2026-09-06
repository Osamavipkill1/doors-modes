local Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/EntitySpawnerFork/Source.lua"))()
local Times = 0
local Character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
-- Create entity
local entityTable = Spawner.createEntity({
    CustomName = "Fog", -- Custom name of your entity
    Model = "rbxassetid://12802386940", -- Can be GitHub file or rbxassetid
    Speed = 50, -- Percentage, 100 = default Rush speed
    DelayTime = 2, -- Time before starting cycles (seconds)
    HeightOffset = 0,
    CanKill = false,
    KillRange = 5,
    BackwardsMovement = true,
    BreakLights = false,
    FlickerLights = {
        true, -- Enabled/Disabled
        5, -- Time (seconds)
    },
    Cycles = {
        Min = 1000,
        Max = 1000,
        WaitTime = 2,
    },
    CamShake = {
        true, -- Enabled/Disabled
        {3.5, 20, 0.1, 1}, -- Shake values (don't change if you don't know)
        100, -- Shake start distance (from Entity to you)
    },
    Jumpscare = {
        false, -- Enabled/Disabled
        {
            Image1 = "rbxassetid://136212819987673", -- Image1 url
            Image2 = "rbxassetid://77350187016650", -- Image2 url
            Shake = true,
            Sound1 = {
                10483790459, -- SoundId
                { Volume = 0.5 }, -- Sound properties
            },
            Sound2 = {
                10483837590, -- SoundId
                { Volume = 0.5 }, -- Sound properties
            },
            Flashing = {
                true, -- Enabled/Disabled
                Color3.fromRGB(255, 255, 255), -- Color
            },
            Tease = {
                true, -- Enabled/Disabled
                Min = 1,
                Max = 3,
            },
        },
    },
    CustomDialog = {"Oh... hello.", "Not this place again...", "Nevermind that... What'd you die to?", "Oh... the white one.", "It fills the room with fog, so...", "Maybe you could call it Fog?", "You shold avoid it...", "Anyways, I hope you don't mind trying again. It would be helpful."}, -- Custom death message
    Color = "Yellow"
})


-----[[  Debug -=- Advanced  ]]-----
entityTable.Debug.OnEntitySpawned = function()
   coroutine.wrap(function()
  game.Workspace:WaitForChild("Fog")
-- Function to create the part and start the timer
local function fogPart()
  -- Get the position of the model "Common Sense"
local modelPos = game:GetService("Workspace")["Fog"].WorldPivot.Position

  -- Create a part and add it to the workspace
local part = Instance.new("Part")
part.Parent = game.Workspace
part.Size = Vector3.new(7,10,7)
part.Anchored = true
part.Name = "FogKill"
part.Transparency = 1
part.CanCollide = false
part.CanQuery = false
part.Position = modelPos
local function dmg()
      game.Players.LocalPlayer.Character.Humanoid.Health = game.Players.LocalPlayer.Character.Humanoid.Health - 100
      local Players = game:GetService("Players")
      local Plr = Players.LocalPlayer
      local ReSt = game:GetService("ReplicatedStorage")
      ReSt.GameStats["Player_".. Plr.Name].Total.DeathCause.Value = "Fog"
end
--
  -- Deal damage to any players that touch the part
part.Touched:Connect(function()
    dmg()
end)
--
part.TouchEnded:Connect(function()
    dmg()
end)
--
end

-- Call the function to create the part
local fog_exist = game.Workspace:FindFirstChild("Fog")
fogPart()
local part = game.Workspace.FogKill
repeat
wait(0.05)
local modelPos = game:GetService("Workspace")["Fog"].WorldPivot.Position
part.Position = modelPos
until fog_exist == nil
if fog_exist == nil then
    part:Destroy()
end
end)()
    game.Lighting.FogColor = Color3.fromRGB(255, 255, 255) 
    game.Lighting.FogEnd = "25"
    game.Lighting.FogStart = "4"
    print("Entity has spawned:", entityTable)
    game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
    workspace:FindFirstChild("Fog"):Destroy()
    game.Lighting.FogEnd = "75"
    game.Lighting.FogStart = "10"
    game.Lighting.FogColor = Color3.fromRGB(0, 0, 0)
end

entityTable.Debug.OnEntityDespawned = function()
    print("Entity has despawned:", entityTable)
end

entityTable.Debug.OnEntityStartMoving = function()
    print("Entity has started moving:", entityTable)
end

entityTable.Debug.OnEntityFinishedRebound = function()
    print("Entity has finished rebound:", entityTable)
    Times = Times + 1
    print(Times)
    if Times > 1 then
        Times = 0
        Humanoid.Health = Humanoid.Health - 10
        print(Times .. " Player Damaged. Health: " .. Humanoid.Health)
        local msg = {"Oh... hello.", "Not this place again...", "Nevermind that... What'd you die to?", "Oh... the white one.", "It fills the room with fog, so...", "Maybe you could call it Fog?", "You shold avoid it...", "Anyways, I hope you don't mind trying again. It would be helpful."} -- death message
local color = "Yellow"
firesignal(game:GetService("ReplicatedStorage").EntityInfo.DeathHint.OnClientEvent, msg, color)

    end
end

entityTable.Debug.OnEntityEnteredRoom = function(room)
    print("Entity:", entityTable, "has entered room:", room)
end

entityTable.Debug.OnLookAtEntity = function()
    print("Player has looked at entity:", entityTable)
end

entityTable.Debug.OnDeath = function()
    warn("Player has died.")
    local msg = {"Oh... hello.", "Not this place again...", "Nevermind that... What'd you die to?", "Oh... the white one.", "It fills the room with fog, so...", "Maybe you could call it Fog?", "You shold avoid it...", "Anyways, I hope you don't mind trying again. It would be helpful."} -- death message
local color = "Yellow"
firesignal(game:GetService("ReplicatedStorage").EntityInfo.DeathHint.OnClientEvent, msg, color)
game.ReplicatedStorage.GameStats["Player_".. game.Players.LocalPlayer.Name].Total.DeathCause.Value = "Fog"
end
------------------------------------


-- Run the created entity
Spawner.runEntity(entityTable)
