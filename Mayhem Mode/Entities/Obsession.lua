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

    for _, snd in pairs(entityModel:GetDescendants()) do
        if snd:IsA("Sound") then
            snd.Volume = snd.Volume * 0.5
        end
    end

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

local roomChangeConn
roomChangeConn = game.ReplicatedStorage.GameData.LatestRoom.Changed:Connect(function()
    cubeRemoved = true
    _G.GazeEntityActive = false
    cube:Destroy()
    entityModel:Destroy()
    roomChangeConn:Disconnect()
end)

local wasLookingAway = false
local nextDamageTime = 0

while true do
    task.wait(0.1)
    local RemoveGreed = _G.KillEntity
    if RemoveGreed and _G.KillEntity == "true" then
        cube:Destroy()
        cubeRemoved = true
        _G.GazeEntityActive = false
        pcall(function() roomChangeConn:Disconnect() end)
        pcall(function() entityModel:Destroy() end)
        break
    end
    if humanoid.Health <= 0 then
        _G.GazeEntityActive = false
        pcall(function() roomChangeConn:Disconnect() end)
        pcall(function() entityModel:Destroy() end)
        break
    end
    if cubeRemoved then break end

    -- Obsession = OPPOSITE of Eyes. You must maintain eye contact.
    -- If you look AWAY from it, you take damage -- starting immediately.
    local direction = (cube.Position - character.HumanoidRootPart.Position).Unit
    local dotProduct = direction:Dot(character.HumanoidRootPart.CFrame.LookVector)

    local function hitOnce()
        local wouldBeFatal = (humanoid.Health - 10) <= 0
        if wouldBeFatal then
            local msg = {"Oh... hello.", "Not this place again...", "Nevermind that... What'd you die to?", "Oh... that thing.", "It really wants attention...", "Maybe you could call it Obsession?", "Anyways, I hope you don't mind trying again. It would be helpful."}
            local color = "Yellow"
            pcall(function() SetDeathCause("Obsession") end)
            local hintOk, hintErr = pcall(firesignal, game:GetService("ReplicatedStorage").EntityInfo.DeathHint.OnClientEvent, msg, color)
            if not hintOk then
                warn("[Mayhem/Obsession] DeathHint firesignal failed: " .. tostring(hintErr))
            end
        end
        if wouldBeFatal then
            pcall(function() GuaranteeKill(humanoid) end)
        else
            humanoid.Health = math.max(humanoid.Health - 10, 0)
        end
        return wouldBeFatal
    end

    if dotProduct < 0.5 then
        if not wasLookingAway then
            -- just looked away -- damage right away
            wasLookingAway = true
            if hitOnce() then
                _G.GazeEntityActive = false
                pcall(function() roomChangeConn:Disconnect() end)
                pcall(function() entityModel:Destroy() end)
                break
            end
            nextDamageTime = tick() + 0.5
        elseif tick() >= nextDamageTime then
            if hitOnce() then
                _G.GazeEntityActive = false
                pcall(function() roomChangeConn:Disconnect() end)
                pcall(function() entityModel:Destroy() end)
                break
            end
            nextDamageTime = tick() + 0.5
        end
    else
        wasLookingAway = false
    end
end
end
end
