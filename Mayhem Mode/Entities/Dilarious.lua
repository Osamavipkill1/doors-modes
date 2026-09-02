local Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/EntitySpawnerFork/Source.lua"))()
local Character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
-- Create entity
local entityTable = Spawner.createEntity({
    CustomName = "Dilarious", -- Custom name of your entity
    Model = "rbxassetid://12913584112", -- Can be GitHub file or rbxassetid
    Speed = 20, -- Percentage, 100 = default Rush speed
    DelayTime = 2, -- Time before starting cycles (seconds)
    HeightOffset = 0,
    CanKill = false,
    KillRange = 5,
    BackwardsMovement = false,
    BreakLights = true,
    FlickerLights = {
        true, -- Enabled/Disabled
        5, -- Time (seconds)
    },
    Cycles = {
        Min = 3,
        Max = 3,
        WaitTime = 1,
    },
    CamShake = {
        true, -- Enabled/Disabled
        {3.5, 20, 0.1, 1}, -- Shake values (don't change if you don't know)
        100, -- Shake start distance (from Entity to you)
    },
    Jumpscare = {
        false, -- Enabled/Disabled
        {
            Image1 = "rbxassetid://10483855823", -- Image1 url
            Image2 = "rbxassetid://10483999903", -- Image2 url
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
    CustomDialog = {""}, -- Custom death message
    Color = "Yellow"
})

local thisgone = false
-----[[  Debug -=- Advanced  ]]-----
entityTable.Debug.OnEntitySpawned = function()
coroutine.wrap(function()
local dilarious = game.Workspace:WaitForChild("Dilarious")
local function DilariousPart()
local modelPos = game:GetService("Workspace")["Dilarious"].WorldPivot.Position
local Part = dilarious.Hitbox
Part.Parent = game.Workspace
Part.Transparency = 1
Part.CanCollide = false
Part.CanQuery = false
Part.Position = modelPos
local function dmg()
    local Players = game:GetService("Players")
    local Plr = Players.LocalPlayer
    local ReSt = game:GetService("ReplicatedStorage")
    ReSt.GameStats["Player_".. Plr.Name].Total.DeathCause.Value = "Dilarious"
    game.Players.LocalPlayer.Character.Humanoid.Health = game.Players.LocalPlayer.Character.Humanoid.Health - 10
end
Part.Touched:Connect(function()
    dmg()
end)
task.spawn(function()
local part = dilarious.DilariousMov
local player = game:GetService('Players').LocalPlayer
repeat wait() until workspace:FindFirstChild(player.Name)
local cam = workspace.Camera
local workspaceplayer = workspace[player.Name]
local ended = false
local treshold = 65 -- how close the player needs to be for pull to start happening
local accelerationSpeed = 1500 -- the lower the faster acceleration the pull will have
game:GetService('RunService').RenderStepped:Connect(function()
    if not ended then
	local Mag = -treshold + (part.Position - workspaceplayer.HumanoidRootPart.Position).Magnitude
	if Mag <= 0 and workspaceplayer.Humanoid.Health ~= 0 then
        cam.DiagonalFieldOfView = 144.717 + Mag*5
        local newframe = workspaceplayer.HumanoidRootPart.CFrame * CFrame.new(0, 0, -0.1 + (Mag/accelerationSpeed)) -- Move Player closer
        workspaceplayer.HumanoidRootPart.Position = newframe.Position
        workspaceplayer.HumanoidRootPart.CFrame = CFrame.lookAt(workspaceplayer.HumanoidRootPart.CFrame.Position,part.CFrame.Position)-- Force player to look at part (NEEDED)
    else
        cam.DiagonalFieldOfView = 144.717
    end
	if not workspace:FindFirstChild(part.Parent.Name) or game.ReplicatedStorage.GameData.LatestRoom.Value == 49 then
		if game.ReplicatedStorage.GameData.LatestRoom.Value == 49 then
		   part.Parent:Destroy() 
		end
		cam.FieldOfView = 70
		wait()
		ended = true
		
	end
	end
end)
end)
end
local Dilarious_exist = game.Workspace:FindFirstChild("Dilarious")
DilariousPart()
local part = game.Workspace.Hitbox
repeat
wait(0.05)
local modelPos = game:GetService("Workspace")["Dilarious"].WorldPivot.Position
part.Position = modelPos
until Dilarious_exist == nil
if Dilarious_exist == nil then
    part:Destroy()
end
end)()
end

entityTable.Debug.OnEntityDespawned = function()
    thisgone = true
end

entityTable.Debug.OnEntityStartMoving = function()
end

entityTable.Debug.OnEntityFinishedRebound = function()
end

entityTable.Debug.OnEntityEnteredRoom = function(room)
end

entityTable.Debug.OnLookAtEntity = function()
end

entityTable.Debug.OnDeath = function()
    warn("Player has died.")
end
------------------------------------


-- Run the created entity
Spawner.runEntity(entityTable)
