local envy = game:GetObjects("rbxassetid://12908979782")[1]
envy.Parent = game.ReplicatedStorage.Entities
game:GetService("ReplicatedStorage").GameData.LatestRoom.Changed:Connect(function()
local lastroom = game:GetService("ReplicatedStorage").GameData.LatestRoom.Value
-- Load the Functions module
local SelfModules = {
    Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua"))(),
}

-- Load a custom instance model from a URL or local file
local entityModel = envy:Clone()
print(entityModel.Name)
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
        entityModel.PrimaryPart.Position = entityModel.PrimaryPart.Position + Vector3.new(0, 4, 0)
        -- Set the parent of the model to game.Workspace
        entityModel.Parent = game.Workspace

        entityModel.PrimaryPart.Anchored = true

        -- Set the name of the model
        if entityModel.Name then
            entityModel.Name = "envy"
        end

        entityModel:SetAttribute("IsCustomEntity", true)
        entityModel:SetAttribute("NoAI", false)
    end
end
local player = game:GetService('Players').LocalPlayer
local workspaceplayer = workspace[player.Name]
local start = true
task.spawn(function()
    while start do
        task.wait()
        CFrame.lookAt(workspaceplayer.HumanoidRootPart.CFrame.Position,entityModel.GreenWithEnvy.CFrame.Position)
    end
end)
task.spawn(function()
    local ent = entityModel
    task.wait(10)
    if ent then
        entityModel.GreenWithEnvy.PlaySound.PlaybackSpeed = 0.5
        entityModel.GreenWithEnvy.Footsteps.PlaybackSpeed = 0.5
        entityModel.GreenWithEnvy.Attachment.ParticleEmitter.Size = NumberSequence.new(6)
        entityModel.GreenWithEnvy.Attachment.ParticleEmitter.Color = Color3.fromRGB(255, 0, 0)
    end
end)
--
game:GetService("ReplicatedStorage").GameData.LatestRoom.Changed:Wait()
entityModel:Destroy()
start = false
end)