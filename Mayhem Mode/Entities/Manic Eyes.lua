_G.KillEntity = "false"
_G.GazeEntityActive = true -- blocks Obsession from spawning while this is alive
game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
local lastroom = game:GetService("ReplicatedStorage").GameData.LatestRoom.Value
local SelfModules = {
Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/EntitySpawnerFork/Functions.lua"))(),
}

local entityModel = game:GetObjects("rbxassetid://12802831625")[1]

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local camera = workspace.CurrentCamera

local floor = game:GetService("Workspace").CurrentRooms[lastroom].Parts.Floor.Position
if typeof(entityModel) == "Instance" and entityModel.ClassName == "Model" then
entityModel.PrimaryPart = entityModel.PrimaryPart or entityModel:FindFirstChildWhichIsA("BasePart")
if entityModel.PrimaryPart then
    entityModel.PrimaryPart.Position = floor
    entityModel.PrimaryPart.Position = entityModel.PrimaryPart.Position + Vector3.new(0, 5, 0)
    entityModel.Parent = game.Workspace
    entityModel.PrimaryPart.Anchored = true
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
cube.Position = entityModel.PrimaryPart.Position + Vector3.new(0, 0.5, 0)
cube.Transparency = 1
local cubeRemoved = false

game.ReplicatedStorage.GameData.LatestRoom.Changed:Connect(function()
    cube:Destroy()
    cubeRemoved = true
    _G.GazeEntityActive = false
    game:GetService("TweenService"):Create(entityModel.Core.PointLight2, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {Brightness = 0}):Play()
    game:GetService("TweenService"):Create(entityModel.Core.PointLight1, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {Brightness = 0}):Play()
    task.wait(0.3)
    entityModel:Destroy()
end)

-- Raycast for wall (line-of-sight) detection
local rayParams = RaycastParams.new()
rayParams.FilterDescendantsInstances = {character, entityModel, cube}
rayParams.FilterType = Enum.RaycastFilterType.Exclude

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
        local msg = {"Oh... hello.", "Not this place again...", "Nevermind that... What'd you die to?", "Oh... the golden eyes.", "They are very similar to the eyes...", "Maybe you could call them Manic Eyes?", "Anyways, I hope you don't mind trying again. It would be helpful."}
        local color = "Yellow"
        pcall(firesignal, game:GetService("ReplicatedStorage").EntityInfo.DeathHint.OnClientEvent, msg, color)
        pcall(function() SetDeathCause("Manic Eyes") end)
        _G.GazeEntityActive = false
        break
    end
    if cubeRemoved then break end

    -- FIX: "look box" was a wide dot-product cone (0.6 threshold, ~53deg half-angle),
    -- which is wider than the camera's actual visible frame -- especially vertically --
    -- so it could damage you while the entity wasn't actually on your screen at all.
    -- WorldToViewportPoint checks the REAL camera frustum (both axes), so this now only
    -- triggers when the entity is genuinely visible on screen.
    local screenPos, onScreen = camera:WorldToViewportPoint(cube.Position)

    if onScreen then
        local playerPos = character.HumanoidRootPart.Position
        local direction = (cube.Position - playerPos)

        -- Raycast to check for walls between player and entity
        local rayResult = workspace:Raycast(playerPos, direction, rayParams)
        local hasLineOfSight = (rayResult == nil)
            or (rayResult.Instance ~= nil and rayResult.Instance:IsDescendantOf(entityModel))

        if hasLineOfSight then
            humanoid:TakeDamage(6)
        end
    end
end
end
end
