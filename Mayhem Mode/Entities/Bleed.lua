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

local FindPartOnRayWithIgnoreList = workspace.FindPartOnRayWithIgnoreList
local WorldToViewportPoint = Camera.WorldToViewportPoint

local SelfModules = {
    DefaultConfig = loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/EntitySpawnerFork/DefaultConfig.lua"))(),
    Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/EntitySpawnerFork/Functions.lua"))(),
}
local ModuleScripts = {
    ModuleEvents = require(ReSt.ClientModules.Module_Events),
    MainGame = require(Plr.PlayerGui.MainUI.Initiator.Main_Game),
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

            entityModel:SetAttribute("IsCustomEntity", true)
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
        end
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
        ModuleScripts.ModuleEvents.flicker(workspace.CurrentRooms[ReSt.GameData.LatestRoom.Value], entityTable.Config.FlickerLights[2])
    end

    -- Movement

    task.wait(entityTable.Config.DelayTime)

    local enteredRooms = {}

    entityConnections.movementTick = RS.Stepped:Connect(function()
        if entityModel.Parent and not entityModel:GetAttribute("NoAI") then
            local entityPos = entityModel.PrimaryPart.Position
            local rootPos = getPlayerRoot().Position
            local floorRay = FindPartOnRayWithIgnoreList(workspace, Ray.new(entityPos, Vector3.new(0, -10, 0)), {entityModel, Char})
            local playerInSight = FindPartOnRayWithIgnoreList(workspace, Ray.new(entityPos, rootPos - entityPos), {entityModel, Char}) == nil
            
            -- Entered room

            if floorRay ~= nil and floorRay.Name == "Floor" then
                for _, room in next, workspace.CurrentRooms:GetChildren() do
                    if floorRay:IsDescendantOf(room) and not table.find(enteredRooms, room) then
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

                ModuleScripts.MainGame.camShaker.ShakeOnce(ModuleScripts.MainGame.camShaker, table.unpack(shakeRep))
            end

            -- Player in sight

            if playerInSight then
                -- Look at entity

                local _, onScreen = WorldToViewportPoint(Camera, entityModel.PrimaryPart.Position)

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
                        Hum.Health = 0
                        ReSt.GameStats["Player_".. Plr.Name].Total.DeathCause.Value = entityModel.Name
                        
                        if #entityTable.Config.CustomDialog > 0 then
                            firesignal(ReSt.Bricks.DeathHint.OnClientEvent, entityTable.Config.CustomDialog, "Yellow")
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

    local BLOOD_TOUCH_DAMAGE = 6
    local BLOOD_TOUCH_DEBOUNCE = 1 -- seconds before the same player can be hurt by blood again
    local touchDebounce = {} -- shared across every puddle this Bleed run spawns, keyed per-character

    function generateBlood()
        local blood = Instance.new("Part")
        blood.Anchored = true
        blood.CanCollide = false -- don't let leftover blood physically block movement
        blood.CanTouch = true    -- this (not CanCollide/CanQuery) is what makes .Touched fire
        blood.Parent = workspace
        blood.Size = Vector3.new(2, 0.1, 2) -- small hazard footprint, not a physics obstacle
        blood.Transparency = 1
        blood.Name = "Blood"

        local particle = Instance.new("ParticleEmitter")
        particle.Parent = blood
        particle.Orientation = Enum.ParticleOrientation.VelocityParallel
        particle.EmissionDirection = Enum.NormalId.Top
        particle.Color = ColorSequence.new(Color3.fromRGB(98, 0, 0))
        particle.LightEmission = -1
        particle.LightInfluence = 0.45
        particle.ZOffset = -1
        particle.Transparency = NumberSequence.new(.2)
        particle.Lifetime = NumberRange.new(0.6, 1.3)
        particle.Rate = 60 -- was 10000003288 - that was emitting ~10 billion particles/sec, a crash/lag bug
        particle.LockedToPart = true
        particle.Rotation = NumberRange.new(90, 90)
        particle.RotSpeed = NumberRange.new(-5, 5)
        particle.Speed = NumberRange.new(8, 18)
        particle.SpreadAngle = Vector2.new(-360,360)
        particle.Acceleration = Vector3.new(0, -15, 0)
        particle.VelocityInheritance = 0.15
        particle.Texture = "rbxassetid://92114008645309"

        -- Position it near the entity's actual, guaranteed root part (PrimaryPart),
        -- not the unverified "Main" part that could silently fail and drop blood at (0,0,0)
        local pos = entityModel.PrimaryPart.Position
        local spawnPos = Vector3.new(pos.X + math.random(-5,5), pos.Y + math.random(-5,5), pos.Z + math.random(-5,5))

        -- Snap it down onto the floor beneath it (not a random direction for 5000 studs,
        -- which could send it onto an unrelated, distant surface)
        local floorRay = workspace:Raycast(spawnPos, Vector3.new(0, -20, 0))
        blood.Position = floorRay and floorRay.Position or spawnPos
        blood.Orientation = Vector3.new(0, math.random(0, 360), 0)

        -- Touch damage. Debounce is shared across all puddles (see touchDebounce above),
        -- so standing across two nearby puddles can't double up damage in the same window.
        blood.Touched:Connect(function(hit)
            local touchedChar = hit.Parent
            local touchedHum = touchedChar and touchedChar:FindFirstChildOfClass("Humanoid")
            if not touchedHum or touchedHum.Health <= 0 then return end
            if touchDebounce[touchedChar] then return end

            touchDebounce[touchedChar] = true
            touchedHum:TakeDamage(BLOOD_TOUCH_DAMAGE)

            task.delay(BLOOD_TOUCH_DEBOUNCE, function()
                touchDebounce[touchedChar] = nil
            end)
        end)

        return blood
    end

    -- Spawn blood continuously for as long as the entity is actually alive/moving,
    -- instead of a fixed 75-particle burst that only covered the first 0.75 seconds
    task.spawn(function()
        while entityModel.Parent and not entityModel:GetAttribute("NoAI") do
            local blood = generateBlood()

            task.delay(15, function()
                if blood and blood.Parent then
                    blood.ParticleEmitter.Enabled = false
                    task.wait(3)
                    blood:Destroy()
                end
            end)

            task.wait(0.1)
        end
    end)

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

        sound1:Play()
        
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
    sound2:Play()
    
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

-- Create entity
local entityTable = Spawner.createEntity({
    CustomName = "Bleed", -- Custom name of your entity
    Model = "rbxassetid://93354759389091", -- Can be GitHub file or rbxassetid
    Speed = 100, -- Percentage, 100 = default Rush speed
    DelayTime = 2, -- Time before starting cycles (seconds)
    HeightOffset = 0,
    CanKill = true,
    KillRange = 50,
    BackwardsMovement = false,
    BreakLights = false,
    FlickerLights = {
        true, -- Enabled/Disabled
        1, -- Time (seconds)
    },
    Cycles = {
        Min = 1,
        Max = 1,
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
            Image1 = "rbxassetid://105746113938200", -- Image1 url
            Image2 = "rbxassetid://102956244109658", -- Image2 url
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
    CustomDialog = {"Alright what happened this time...", "Oh, not sure who that is.", "Well he leave blood around in the rooms, so you could call him Bleed!"}, -- Custom death message
})


-----[[  Debug -=- Advanced  ]]-----
entityTable.Debug.OnEntitySpawned = function()
end

entityTable.Debug.OnEntityDespawned = function()
end

entityTable.Debug.OnEntityStartMoving = function()
end

entityTable.Debug.OnEntityFinishedRebound = function()
end

entityTable.Debug.OnEntityEnteredRoom = function(room)
    local color = Color3.fromRGB(255, 0, 0)
	room.LightBase.SurfaceLight.Enabled = true
	local Tween1 = game.TweenService:Create(room.LightBase.SurfaceLight, TweenInfo.new(2), {Color = color})
	local Color1 = room.LightBase.SurfaceLight.Color
	local Tween2 = game.TweenService:Create(room.LightBase.SurfaceLight, TweenInfo.new(2), {Color = Color1})
	task.spawn(function()
	    Tween1:Play()
	    task.wait(15)
	    Tween2:Play()
	end)
	for _, thing in pairs(room.Assets:GetDescendants()) do
	if thing:FindFirstChild("LightFixture") then
		thing.LightFixture.Neon.Color = color
		for _, light in pairs(thing.LightFixture:GetChildren()) do					if light:IsA("SpotLight") or light:IsA("PointLight") then
			light.Color = color
		end
	end
	end
	end
end

entityTable.Debug.OnLookAtEntity = function()
end

entityTable.Debug.OnDeath = function()
end
------------------------------------


-- Run the created entity
Spawner.runEntity(entityTable)
