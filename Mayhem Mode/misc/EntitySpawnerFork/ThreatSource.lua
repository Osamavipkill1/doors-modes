-- Services

local Players = game:GetService("Players")
local ReSt = game:GetService("ReplicatedStorage")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local CG = game:GetService("CoreGui")

-- Variables

local Plr = Players.LocalPlayer
local Char = Plr.Character or Plr.CharacterAdded:Wait()
local Hum = Char:WaitForChild("Humanoid")
local Camera = workspace.CurrentCamera

local StaticRushSpeed = 60

local SelfModules = {
    DefaultConfig = loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/EntitySpawnerFork/DefaultConfig.lua"))(),
    Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/EntitySpawnerFork/Functions.lua"))(),
}

-- FIX: THIS is why Threat never spawned. These two requires were unconditional --
-- no pcall, nothing. The instant either path (Module_Events or Main_Game) doesn't
-- match the current Doors version, this throws and kills the ENTIRE file before
-- Threat.createEntity is ever even called. ThreatSource.lua is a separate copy of
-- Source.lua that didn't get this same fix last time -- fixed now, identically.
local okEvents, ModuleEvents = pcall(function()
    return require(ReSt.ClientModules.Module_Events)
end)
if not okEvents then
    warn("[Mayhem/ThreatSource] Module_Events require failed — flicker/shatter disabled.")
    ModuleEvents = {
        flicker = function() end,
        shatter = function() end,
    }
end

local okMain, MainGame = pcall(function()
    return require(Plr.PlayerGui.MainUI.Initiator.Main_Game)
end)
if not okMain then
    warn("[Mayhem/ThreatSource] Main_Game require failed — cam shake disabled.")
    MainGame = {
        camShaker = { ShakeOnce = function() end },
    }
end

local ModuleScripts = {
    ModuleEvents = ModuleEvents,
    MainGame = MainGame,
}
local EntityConnections = {}

local Spawner = {}

-- Misc Functions

function onCharacterAdded(char)
    Char, Hum = char, char:WaitForChild("Humanoid")
end

function getPlayerRoot()
    return Char:FindFirstChild("HumanoidRootPart") or Char:FindFirstChild("Head")
end

function dragEntity(entityModel, pos, speed)
    local entityConnections = EntityConnections[entityModel]

    if entityConnections.movementNode then
        entityConnections.movementNode:Disconnect()
    end

    entityConnections.movementNode = RS.Stepped:Connect(function(_, step)
        if entityModel.Parent and not entityModel:GetAttribute("NoAI") then
            local rootPos = entityModel.PrimaryPart.Position
            local diff = Vector3.new(pos.X, pos.Y, pos.Z) - rootPos

            if diff.Magnitude > 0.1 then
                entityModel:PivotTo(CFrame.new(rootPos + diff.Unit * math.min(step * speed, diff.Magnitude)))
            else
                entityConnections.movementNode:Disconnect()
            end
        end
    end)

    repeat task.wait() until not entityConnections.movementNode.Connected
end

function loadSound(soundData)
    local sound = Instance.new("Sound")
    local soundId = tostring(soundData[1])
    local properties = soundData[2]

    for i, v in next, properties do
        if i ~= "SoundId" and i ~= "Parent" then
            sound[i] = v
        end
    end

    if soundId:find("rbxasset://") then -- Custom audio
        sound.SoundId = soundId
    else
        local numberId = soundId:gsub("%D", "")

        sound.SoundId = "rbxassetid://".. numberId
    end
    
    sound.Parent = workspace

    return sound
end

-- FIX: workspace.FindPartOnRayWithIgnoreList is deprecated. Replaced with workspace:Raycast()
-- to match Source.lua and Manic Eyes/Stalker, for consistency and future-proofing.
local function castIgnoreRay(origin, direction, ignoreList)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = ignoreList
    params.FilterType = Enum.RaycastFilterType.Exclude
    return workspace:Raycast(origin, direction, params)
end

-- Functions

Spawner.createEntity = function(config)
    for i, v in next, SelfModules.DefaultConfig do
        if config[i] == nil then
            config[i] = v
        end
    end

    config.Speed = StaticRushSpeed / 100 * config.Speed

    -- Model

    local entityModel = LoadCustomInstance(config.Model)

    if typeof(entityModel) == "Instance" and entityModel.ClassName == "Model" then
        entityModel.PrimaryPart = entityModel.PrimaryPart or entityModel:FindFirstChildWhichIsA("BasePart")
        
        if entityModel.PrimaryPart then
            entityModel.PrimaryPart.Anchored = true
            
            if config.CustomName then
                entityModel.Name = config.CustomName
            end
            entityModel:SetAttribute("NoAI", false)

            -- EntityTable

            local entityTable = {
                Model = entityModel,
                Config = config,
                Debug = {
                    OnEntitySpawned = function() end,
                    OnEntityDespawned = function() end,
                    OnEntityStartMoving = function() end,
                    OnEntityFinishedRebound = function() end,
                    OnEntityEnteredRoom = function() end,
                    OnLookAtEntity = function() end,
                    OnDeath = function() end
                }
            }

            return entityTable
        else
            warn("[Mayhem/ThreatSource] createEntity: no PrimaryPart/BasePart on model: " .. tostring(config.Model))
        end
    else
        warn("[Mayhem/ThreatSource] createEntity: invalid model for: " .. tostring(config.Model))
    end
end

Spawner.runEntity = function(entityTable)
    -- Nodes

    local nodes = {}

    for _, room in next, workspace.CurrentRooms:GetChildren() do
        local pathfindNodes = room:FindFirstChild("PathfindNodes")
        
        if pathfindNodes then
            pathfindNodes = pathfindNodes:GetChildren()
        else
            local fakeNode = Instance.new("Part")
            fakeNode.Name = "1"
            fakeNode.CFrame = room:WaitForChild("RoomExit").CFrame - Vector3.new(0, room.RoomExit.Size.Y / 2, 0)

            pathfindNodes = {fakeNode}
        end

        table.sort(pathfindNodes, function(a, b)
            return tonumber(a.Name) < tonumber(b.Name)
        end)

        for _, node in next, pathfindNodes do
            nodes[#nodes + 1] = node
        end
    end

    -- Spawn

    local entityModel = entityTable.Model:Clone()
    local startNodeIndex = entityTable.Config.BackwardsMovement and #nodes or 1
    local startNodeOffset = entityTable.Config.BackwardsMovement and -50 or 50

    EntityConnections[entityModel] = {}
    local entityConnections = EntityConnections[entityModel]
    
    entityModel:PivotTo(nodes[startNodeIndex].CFrame * CFrame.new(0, 0, startNodeOffset) + Vector3.new(0, 3.5 + entityTable.Config.HeightOffset, 0))
    entityModel.Parent = workspace
    task.spawn(entityTable.Debug.OnEntitySpawned)

    -- Mute entity on spawn

    if CG:FindFirstChild("JumpscareGui") or (Plr.PlayerGui.MainUI.Death.HelpfulDialogue.Visible and not Plr.PlayerGui.MainUI.DeathPanelDead.Visible) then
        warn("on death screen, mute entity")

        for _, v in next, entityModel:GetDescendants() do
            if v.ClassName == "Sound" and v.Playing then
                v:Stop()
            end
        end
    end

    -- Flickering

    if entityTable.Config.FlickerLights[1] then
        ModuleScripts.ModuleEvents.flicker(workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value], entityTable.Config.FlickerLights[2])
    end

    -- Movement

    task.wait(entityTable.Config.DelayTime)

    local enteredRooms = {}

    entityConnections.movementTick = RS.Stepped:Connect(function()
        if entityModel.Parent and not entityModel:GetAttribute("NoAI") then
            local entityPos = entityModel.PrimaryPart.Position
            local rootPos = getPlayerRoot().Position
            local floorRay = castIgnoreRay(entityPos, Vector3.new(0, -10, 0), {entityModel, Char})
            local playerInSight = castIgnoreRay(entityPos, rootPos - entityPos, {entityModel, Char}) == nil
            
            -- Entered room

            if floorRay ~= nil and floorRay.Instance.Name == "Floor" then
                for _, room in next, workspace.CurrentRooms:GetChildren() do
                    if floorRay.Instance:IsDescendantOf(room) and not table.find(enteredRooms, room) then
                        enteredRooms[#enteredRooms + 1] = room
                        task.spawn(entityTable.Debug.OnEntityEnteredRoom, room)

                        -- Break lights
                        
                        if entityTable.Config.BreakLights then
                            ModuleScripts.ModuleEvents.shatter(room)
                        end

                        break
                    end
                end
            end

            -- Camera shaking
            
            local shakeConfig = entityTable.Config.CamShake
            local shakeMag = (getPlayerRoot().Position - entityModel.PrimaryPart.Position).Magnitude

            if shakeConfig[1] and shakeMag <= shakeConfig[3] then
                local shakeRep = {}

                for i, v in next, shakeConfig[2] do
                    shakeRep[i] = v
                end
                shakeRep[1] = shakeConfig[2][1] / shakeConfig[3] * (shakeConfig[3] - shakeMag)

                pcall(function()
                    ModuleScripts.MainGame.camShaker:ShakeOnce(table.unpack(shakeRep))
                end)
            end

            -- Player in sight

            if playerInSight then
                -- Look at entity

                local _, onScreen = Camera:WorldToViewportPoint(entityModel.PrimaryPart.Position)

                if onScreen then
                    task.spawn(entityTable.Debug.OnLookAtEntity)
                end

                -- Kill player

                if entityTable.Config.CanKill and not Char:GetAttribute("IsDead") and not Char:GetAttribute("Invincible") and not Char:GetAttribute("Hiding") and (getPlayerRoot().Position - entityModel.PrimaryPart.Position).Magnitude <= entityTable.Config.KillRange then
                    task.spawn(function()
                        Char:SetAttribute("IsDead", true)

                        -- Mute entity

                        warn("mute entity")

                        for _, v in next, entityModel:GetDescendants() do
                            if v.ClassName == "Sound" and v.Playing then
                                v:Stop()
                            end
                        end

                        -- Jumpscare
                        
                        if entityTable.Config.Jumpscare[1] then
                            Spawner.runJumpscare(entityTable.Config.Jumpscare[2])
                        end

                        -- Death handling
                        
                        task.spawn(entityTable.Debug.OnDeath)

                        -- FIX: removed a large broken block that used to sit here (a
                        -- duplicated "death cutscene" that cloned+destroyed entityModel
                        -- inside a `local entityModel` that shadowed the outer one, then
                        -- called entityModel.Jumpscare:Play() -- a child that doesn't
                        -- exist on this model, which threw and killed this ENTIRE
                        -- coroutine before it ever reached the DeathCause/dialog lines
                        -- below. It also tried to swap cameras in a way that never
                        -- actually became the active camera, so it did nothing useful
                        -- even when it didn't error. Simplified to just the working part.
                        Hum.Health = 0
                        pcall(function() ReSt.GameStats["Player_".. Plr.Name].Total.DeathCause.Value = entityModel.Name end)
                        pcall(function() SetDeathCause(entityModel.Name) end)
                        
                        if #entityTable.Config.CustomDialog > 0 then
                            pcall(firesignal, ReSt.EntityInfo.DeathHint.OnClientEvent, entityTable.Config.CustomDialog, entityTable.Config.Color)
                        end
                        
                        -- Unmute entity

                        task.spawn(function()
                            repeat task.wait() until Plr.PlayerGui.MainUI.DeathPanelDead.Visible

                            warn("unmute entity:", entityModel)

                            for _, v in next, entityModel:GetDescendants() do
                                if v.ClassName == "Sound" then
                                    local oldVolume = v.Volume
                                
                                    v.Volume = 0
                                    v:Play()
                                    TS:Create(v, TweenInfo.new(2), {Volume = oldVolume}):Play()
                                end
                            end
                        end)
                    end)
                end
            end
        end
    end)

    task.spawn(entityTable.Debug.OnEntityStartMoving)

    -- Cycles

    local cyclesConfig = entityTable.Config.Cycles

    if entityTable.Config.BackwardsMovement then
        local inverseNodes = {}

        for nodeIdx = #nodes, 1, -1 do
            inverseNodes[#inverseNodes + 1] = nodes[nodeIdx]
        end

        nodes = inverseNodes
    end

    for cycle = 1, math.max(math.random(cyclesConfig.Min, cyclesConfig.Max), 1) do
        for nodeIdx = 1, #nodes, 1 do
            dragEntity(entityModel, nodes[nodeIdx].Position + Vector3.new(0, 3.5 + entityTable.Config.HeightOffset, 0), entityTable.Config.Speed)
        end

        if cyclesConfig.Max > 1 then
            for nodeIdx = #nodes, 1, -1 do
                dragEntity(entityModel, nodes[nodeIdx].Position + Vector3.new(0, 3.5 + entityTable.Config.HeightOffset, 0), entityTable.Config.Speed)
            end
        end

        -- Rebound finished

        task.spawn(entityTable.Debug.OnEntityFinishedRebound)
        
        if cycle < cyclesConfig.Max then
            task.wait(cyclesConfig.WaitTime)
        end
    end

    -- Destroy

    if not entityModel:GetAttribute("NoAI") then
        for _, v in next, entityConnections do
            v:Disconnect()
        end
        
        entityModel:Destroy()
        task.spawn(entityTable.Debug.OnEntityDespawned)
    end
end

Spawner.runJumpscare = function(config)
    -- Variables

    local image1 = LoadCustomAsset(config.Image1)
    local image2 = LoadCustomAsset(config.Image2)
    local sound1, sound2 = nil, nil

    if config.Sound1 then
        sound1 = loadSound(config.Sound1)
    end

    if config.Sound2 then
        sound2 = loadSound(config.Sound2)
    end

    -- UI Construction

    local JumpscareGui = Instance.new("ScreenGui")
    local Background = Instance.new("Frame")
    local Face = Instance.new("ImageLabel")

    JumpscareGui.Name = "JumpscareGui"
    JumpscareGui.IgnoreGuiInset = true
    JumpscareGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Background.Name = "Background"
    Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Background.BorderSizePixel = 0
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.ZIndex = 999

    Face.Name = "Face"
    Face.AnchorPoint = Vector2.new(0.5, 0.5)
    Face.BackgroundTransparency = 1
    Face.Position = UDim2.new(0.5, 0, 0.5, 0)
    Face.ResampleMode = Enum.ResamplerMode.Pixelated
    Face.Size = UDim2.new(0, 150, 0, 150)
    Face.Image = image1

    Face.Parent = Background
    Background.Parent = JumpscareGui
    JumpscareGui.Parent = CG
    
    -- Tease

    local teaseConfig = config.Tease
    local absHeight = JumpscareGui.AbsoluteSize.Y
    local minTeaseSize = absHeight / 5
    local maxTeaseSize = absHeight / 2.5

    if teaseConfig[1] then
        local teaseAmount = math.random(teaseConfig.Min, teaseConfig.Max)

        if sound1 then sound1:Play() end
        
        for _ = teaseConfig.Min, teaseAmount do
            task.wait(math.random(100, 200) / 100)

            local growFactor = (maxTeaseSize - minTeaseSize) / teaseAmount
            Face.Size = UDim2.new(0, Face.AbsoluteSize.X + growFactor, 0, Face.AbsoluteSize.Y + growFactor)
        end

        task.wait(math.random(100, 200) / 100)
    end
    
    -- Flashing

    if config.Flashing[1] then
        task.spawn(function()
            while JumpscareGui.Parent do
                Background.BackgroundColor3 = config.Flashing[2]
                task.wait(math.random(25, 100) / 1000)
                Background.BackgroundColor3 = Color3.new(0, 0, 0)
                task.wait(math.random(25, 100) / 1000)
            end
        end)
    end
    
    -- Shaking

    if config.Shake then
        task.spawn(function()
            local origin = Face.Position

            while JumpscareGui.Parent do
                Face.Position = origin + UDim2.new(0, math.random(-10, 10), 0, math.random(-10, 10))
                Face.Rotation = math.random(-5, 5)

                task.wait()
            end
        end)
    end

    -- Jumpscare
    
    Face.Image = image2
    Face.Size = UDim2.new(0, maxTeaseSize, 0, maxTeaseSize)
    if sound2 then sound2:Play() end
    
    TS:Create(Face, TweenInfo.new(0.75), {Size = UDim2.new(0, absHeight * 3, 0,  absHeight * 3), ImageTransparency = 0.5}):Play()
    task.wait(0.75)
    JumpscareGui:Destroy()
    
    if sound1 then
        sound1:Destroy()
    end
    
    if sound2 then
        sound2:Destroy()
    end
end

-- Scripts

Plr.CharacterAdded:Connect(onCharacterAdded)

if not SpawnerSetup then
    getgenv().SpawnerSetup = true

    workspace.DescendantRemoving:Connect(function(des)
        if des.Name == "PathfindNodes" then
            des:Clone().Parent = des.Parent
        end
    end)
end

return Spawner
