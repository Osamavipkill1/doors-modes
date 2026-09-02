local function seekeye(seek)
   seek.SeekRig.Head.Eye.Decal:Destroy() 
end
local seek = game.Workspace:FindFirstChild("SeekMoving")
    if seek then
        pcall(function()
            seekeye(seek)
        end)
    end
game:GetService("ReplicatedStorage").GameData.LatestRoom.Changed:Connect(function()
    local seek = game.Workspace:FindFirstChild("SeekMoving")
    if seek then
        pcall(function()
            seekeye(seek)
        end)
    end
    for i, v in pairs(game.Workspace.CurrentRooms:GetChildren()) do
        for _, x in pairs(v:GetChildren()) do
            if x.Name == "Eye" and v:IsA("Model") then
                local eyeball = x:FindFirstChild("Eye")
                local goo = x:FindFirstChild("Black")
                local part = x:FindFirstChild("Part")
                if eyeball and goo and part then
                    print("gone")
                    x.Eye.Decal:Destroy() 
                end
            end
        end
    end
end)