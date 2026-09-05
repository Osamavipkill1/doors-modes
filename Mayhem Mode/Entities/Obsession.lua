_G.KillEntity = "false"
_G.GazeEntityActive = true -- blocks Manic Eyes from spawning while this is alive
game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
local lastroom = game:GetService("ReplicatedStorage").GameData.LatestRoom.Value
local SelfModules = {
Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/EntitySpawnerFork/Functions.lua"))(),
}

local entityModel = game:GetObjects("rbxassetid://12802595163")[1]

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local floor = game:GetService("Workspace").CurrentRooms[lastroom].Parts.Floor.Position
if typeof(entityModel) == "Instance" and entityModel.ClassName == "Model" then
entityModel.PrimaryPart = entityModel.PrimaryPart or entityModel:FindFirstChildWhichIsA("BasePart")
if entityModel.PrimaryPart then
    entityModel.PrimaryPart.Position = floor
    entityModel.PrimaryPart.Position = entityModel.PrimaryPart.Position + Vector3.new(0, 5, 0)
    entityModel.Parent = game.Workspace
    entityModel.PrimaryPart.Anchored = true
    if entityModel.Name then
        entityModel.Name = "greed"
    end
    entityModel:SetAttribute("IsCustomEntity", true)
    entityModel:SetAttribute("NoAI", false)

    -- FIX: lower the ambient sound(s) on this model a little
    for _, snd in pairs(entityModel:GetDescendants()) do
        if snd:IsA("Sound") then
            snd.Volume = snd.Volume * 0.5
        end
    end

    -- FIX: was using Plr:GetAttribute("CurrentRoom") which is nil in practice, causing
    -- this whole block to error before the room-change Connect below was ever registered
    -- -- that's why it never disappeared when you opened the next door.
    local currentRoomNum = game.ReplicatedStorage.GameData.LatestRoom.Value
    local room = workspace.CurrentRooms[currentRoomNum]
    local room2 = workspace.CurrentRooms[currentRoomNum + 1]
    if room then
        pcall(function()
            room.LightBase.SurfaceLight.Enabled = false
            for _, thing in pairs(room.Assets:GetDescendants()) do
                if thing:FindFirstChild("LightFixture") then
                    thing:Destroy()
                end
            end
        end)
    end
    if room2 then
        pcall(function()
            room2.LightBase.SurfaceLight.Enabled = false
            for _, thing in pairs(room2.Assets:GetDescendants()) do
                if thing:FindFirstChild("LightFixture") then
                    thing:Destroy()
                end
            end
        end)
    end

local player = game.Players.LocalPlayer
local character = player.Character
local humanoid = character:WaitForChild("Humanoid")

local cube = Instance.new("Part")
cube.Anchored = true
cube.CanCollide = false
cube.Material = Enum.Material.Glass
cube.Size = Vector3.new(1,1,1)
cube.BrickColor = BrickColor.new("Bright green")
cube.Parent = workspace
cube.Position = entityModel.PrimaryPart.Position
cube.Transparency = 1
local cubeRemoved = false

game.ReplicatedStorage.GameData.LatestRoom.Changed:Connect(function()
    cubeRemoved = true
    _G.GazeEntityActive = false
    cube:Destroy()
    entityModel:Destroy()
end)

-- FIX: damage cooldown so it applies gradually (~10 per second) instead of every
-- 0.1s tick (which was ~150 dmg/sec -- basically an instant kill after looking
-- away for a single frame). Now you have real time to react and look back.
local dmgCooldown = 0

while true do
    task.wait(0.1)
    local RemoveGreed = _G.KillEntity
    if RemoveGreed and _G.KillEntity == "true" then
        cube:Destroy()
        cubeRemoved = true
        _G.GazeEntityActive = false
        break
    end
    if humanoid.Health <= 0 then
        local msg = {"Oh... hello.", "Not this place again...", "Nevermind that... What'd you die to?", "Oh... that thing.", "It really wants attention...", "Maybe you could call it Obsession?", "Anyways, I hope you don't mind trying again. It would be helpful."}
        local color = "Yellow"
        pcall(firesignal, game:GetService("ReplicatedStorage").EntityInfo.DeathHint.OnClientEvent, msg, color)
        pcall(function() SetDeathCause("Obsession") end)
        _G.GazeEntityActive = false
        break
    end
    if cubeRemoved then break end

    -- Obsession = OPPOSITE of Eyes. You must maintain eye contact.
    -- If you look AWAY from it, you take damage -- gradually.
    local direction = (cube.Position - character.HumanoidRootPart.Position).Unit
    local dotProduct = direction:Dot(character.HumanoidRootPart.CFrame.LookVector)

    if dotProduct < 0.5 then
        dmgCooldown = dmgCooldown + 0.1
        if dmgCooldown >= 1 then
            humanoid:TakeDamage(10)
            dmgCooldown = 0
        end
    else
        dmgCooldown = 0
    end
end
end
end
