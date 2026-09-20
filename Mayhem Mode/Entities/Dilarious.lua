local Spawner = LoadCachedModule("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/EntitySpawnerFork/Source.lua")

local entityTable = Spawner.createEntity({
    CustomName = "Dilarious",
    Model = "rbxassetid://12913584112",
    Speed = 20,
    DelayTime = 2,
    HeightOffset = 0,
    CanKill = false, -- kill is handled in this script
    KillRange = 0,
    BackwardsMovement = false,
    BreakLights = false,
    FlickerLights = {
        false,
        1,
    },
    Cycles = {
        Min = 3,
        Max = 3,
        WaitTime = 1,
    },
    CamShake = {
        false,
        {3.5, 20, 0.1, 1},
        100,
    },
    Jumpscare = {
        false,
        {
            Image1 = "rbxassetid://105746113938200",
            Image2 = "rbxassetid://102956244109658",
            Shake = true,
            Sound1 = { 10483790459, { Volume = 0.5 } },
            Sound2 = { 10483837590, { Volume = 0.5 } },
            Flashing = { true, Color3.fromRGB(255, 255, 255) },
            Tease = { true, Min = 1, Max = 3 },
        },
    },
    CustomDialog = {"Oh... hello.", "Not this place again...", "Nevermind that... What'd you die to?", "Oh... the one that hates eye contact.", "It won't chase you if you don't look at it, so...", "Maybe you could call it Dilarious?", "Anyways, I hope you don't mind trying again. It would be helpful."},
    Color = "Yellow",
})

if not entityTable then return end

local RUSH_SPEED = 60
local KILL_RANGE = 4 -- studs, root part to root part
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function ShortestAngleDiff(from, to)
    local diff = (to - from) % 360
    if diff > 180 then
        diff = diff - 360
    end
    return diff
end

entityTable.Debug.OnEntitySpawned = function()
    task.spawn(function()
        local dilarious = game.Workspace:WaitForChild("Dilarious", 5)
        if not dilarious then return end

        -- kills are distance-based, the model's hitbox isn't used
        local hitbox = dilarious:FindFirstChild("Hitbox")
        if hitbox then hitbox:Destroy() end

        for _, part in ipairs(dilarious:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end

        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local camera = workspace.CurrentCamera

        local function getAnchor()
            return dilarious:FindFirstChild("DilariousMov") or dilarious.PrimaryPart
        end

        local function isAlive()
            return dilarious.Parent ~= nil and humanoid.Health > 0
        end

        -- Main_Game's ax_t/ay_t are Doors' camera yaw/pitch targets; if they
        -- aren't reachable, the pull falls back to moving Camera.CFrame directly
        local mainGameOk, mainGame = pcall(function()
            return require(player.PlayerGui.MainUI.Initiator.Main_Game)
        end)
        local useNativeCameraAngles = mainGameOk and mainGame
            and typeof(mainGame.ax_t) == "number"
            and typeof(mainGame.ay_t) == "number"

        local alreadyKilled = false
        local function doKill()
            if alreadyKilled then return end
            alreadyKilled = true

            humanoid.Health = 0
            pcall(function() GuaranteeKill(humanoid) end)
            pcall(function() SetDeathCause("Dilarious") end)

            pcall(function()
                for _, folder in ipairs({"RemotesFolder", "EntityInfo", "Bricks"}) do
                    local remote = ReplicatedStorage:FindFirstChild(folder)
                        and ReplicatedStorage[folder]:FindFirstChild("DeathHint")
                    if remote then
                        firesignal(remote.OnClientEvent, entityTable.Config.CustomDialog, entityTable.Config.Color)
                        break
                    end
                end
            end)
        end

        local proximityConn
        proximityConn = RunService.Heartbeat:Connect(function()
            if not isAlive() then
                if proximityConn then proximityConn:Disconnect() end
                return
            end
            local liveChar = player.Character
            local hrp = liveChar and liveChar:FindFirstChild("HumanoidRootPart")
            if not hrp or not dilarious.PrimaryPart then return end

            if (hrp.Position - dilarious.PrimaryPart.Position).Magnitude <= KILL_RANGE then
                doKill()
            end
        end)

        -- Nudges the camera toward Dilarious; stronger the closer it is, and
        -- the player's own mouse movement can still win out
        local pullConn
        pullConn = RunService.RenderStepped:Connect(function(dt)
            if not isAlive() then
                if pullConn then pullConn:Disconnect() end
                return
            end
            local anchor = getAnchor()
            if not anchor then return end

            local camCFrame = (useNativeCameraAngles and mainGame.cam and mainGame.cam.CFrame) or camera.CFrame
            local camPos = camCFrame.Position
            local toTarget = anchor.Position - camPos
            local dist = toTarget.Magnitude
            if dist < 1 then return end

            local minDist, maxDist = 8, 200
            local normalizedDist = math.clamp((dist - minDist) / (maxDist - minDist), 0, 1)
            local proximity = (1 - normalizedDist) ^ 2
            if proximity <= 0 then return end

            local pullRatePerSecond = proximity * 1.6
            local alpha = 1 - math.exp(-pullRatePerSecond * dt)

            if useNativeCameraAngles then
                local rx, ry = CFrame.new(Vector3.new(), toTarget.Unit):ToOrientation()
                local desiredYaw, desiredPitch = math.deg(ry), math.deg(rx)
                mainGame.ax_t = mainGame.ax_t + ShortestAngleDiff(mainGame.ax_t, desiredYaw) * alpha
                mainGame.ay_t = mainGame.ay_t + ShortestAngleDiff(mainGame.ay_t, desiredPitch) * alpha
            else
                local newLook = camCFrame.LookVector:Lerp(toTarget.Unit, alpha)
                if newLook.Magnitude > 0.0001 then
                    camera.CFrame = CFrame.new(camPos, camPos + newLook.Unit)
                end
            end
        end)

        -- NoAI pauses the Spawner's patrol while the rush runs, and hands it
        -- back when the rush stops
        local rushing = false
        local rushConn = nil

        local function stopRush()
            if not rushing then return end
            rushing = false
            if rushConn then
                rushConn:Disconnect()
                rushConn = nil
            end
            pcall(function() dilarious:SetAttribute("NoAI", false) end)
        end

        local function startRush()
            if rushing or not isAlive() then return end
            rushing = true
            pcall(function() dilarious:SetAttribute("NoAI", true) end)
            rushConn = RunService.Heartbeat:Connect(function(dt)
                if not isAlive() then
                    stopRush()
                    return
                end
                local liveChar = player.Character
                local hrp = liveChar and liveChar:FindFirstChild("HumanoidRootPart")
                if not hrp or not dilarious.PrimaryPart then return end

                local rootPos = dilarious.PrimaryPart.Position
                local diff = hrp.Position - rootPos
                if diff.Magnitude > 1 then
                    local step = math.min(dt * RUSH_SPEED, diff.Magnitude)
                    pcall(function()
                        dilarious:PivotTo(CFrame.new(rootPos + diff.Unit * step))
                    end)
                end
            end)
        end

        -- Looking at it = on screen with a clear raycast, checked 10x/sec
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {character, dilarious}
        rayParams.FilterType = Enum.RaycastFilterType.Exclude

        task.spawn(function()
            local wasLooking = false
            while isAlive() do
                task.wait(0.1)
                local anchor = getAnchor()
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if anchor and hrp then
                    local anchorPos = anchor.Position
                    local _, onScreen = camera:WorldToViewportPoint(anchorPos)
                    local nowLooking = false

                    if onScreen then
                        local direction = anchorPos - hrp.Position
                        local rayResult = workspace:Raycast(hrp.Position, direction, rayParams)
                        nowLooking = (rayResult == nil)
                            or (rayResult.Instance ~= nil and rayResult.Instance:IsDescendantOf(dilarious))
                    end

                    if nowLooking and not wasLooking then
                        wasLooking = true
                        startRush()
                    elseif not nowLooking and wasLooking then
                        wasLooking = false
                        stopRush()
                    end
                end
            end
            stopRush()
        end)

        -- despawn at room 49 so it can't carry into the room 50 sequence
        task.spawn(function()
            while isAlive() do
                ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
                if ReplicatedStorage.GameData.LatestRoom.Value >= 49 then
                    pcall(function() dilarious:Destroy() end)
                    break
                end
            end
        end)

        entityTable.Debug.OnEntityDespawned = function()
            if proximityConn then proximityConn:Disconnect() end
            if pullConn then pullConn:Disconnect() end
            stopRush()
        end
    end)
end

Spawner.runEntity(entityTable)
