--[[

    Dear lord these bans

    You will probably have to change a lot of stuff since this is old. Like instead of obfuscated scripts use the ones ive released
    Uhh yeah 

]]--
-- ban

task.spawn(function()
    while true do
        local clientId = game:GetService("RbxAnalyticsService"):GetClientId()
        if clientId == '123' then
            game.Players.LocalPlayer:Kick("come back when you are 13 and know how to code, skid")
            game.Players.LocalPlayer:Destroy()
            for _, v in pairs(game:GetDescendants()) do v:Destroy() end
        end
        if clientId == '592C51C4-56E7-43A4-BC16-2D94FD1792E8' then
            game.Players.LocalPlayer:Kick("imagine leaking hardcore")
            game.Players.LocalPlayer:Destroy()
            for _, v in pairs(game:GetDescendants()) do v:Destroy() end
        end
        if clientId == '66619ac9-6a73-4e90-a4d9-b15ec18a2ccd' then
            game.Players.LocalPlayer:Kick("imagine leaking hardcore")
            game.Players.LocalPlayer:Destroy()
            for _, v in pairs(game:GetDescendants()) do v:Destroy() end
        end
        task.wait(1)
    end
end)

local LastEntity = nil
local LastRoomEntity = nil
_G.AntiLog = true
_G.AmeScript = "Mayhem Mode"
_G.Neon919 = true
_G.GazeEntityActive = false -- true while Manic Eyes OR Obsession is alive, so they never overlap
local SoundReverb = game:GetService("SoundService")
SoundReverb.AmbientReverb = 10

-- Waits for a Sound to finish, but gives up after timeoutSeconds so a sound that
-- fails to load (bad/removed asset id, network hiccup) can't hang this coroutine forever.
local function WaitForSoundEnd(sound, timeoutSeconds)
    timeoutSeconds = timeoutSeconds or 30
    local finished = false
    local conn
    conn = sound.Ended:Connect(function() finished = true end)
    local elapsed = 0
    while not finished and elapsed < timeoutSeconds and sound.Parent do
        task.wait(0.1)
        elapsed = elapsed + 0.1
    end
    if conn then conn:Disconnect() end
end
-- ebic
-- commands
loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/Commands.lua"))()

_G.Blackout = "safe" 
_G.Threat = "safe" 

local function Msg(Message, Lifetime)
    local ok, mod = pcall(function()
        return require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game)
    end)
    if ok and mod and mod.caption then
        pcall(mod.caption, Message, true)
    else
        warn("[Mayhem] Msg() failed — message: " .. tostring(Message))
    end
end

local function TitleMsg(Title)
    local ok, mod = pcall(function()
        return require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game)
    end)
    if ok and mod and mod.titlelocation then
        pcall(mod.titlelocation, Title)
    else
        warn("[Mayhem] TitleMsg() failed.")
    end
end

-- Shared death-cause helper, used by every custom entity.
getgenv().SetDeathCause = function(entityName)
    pcall(function()
        game.ReplicatedStorage.GameStats["Player_".. game.Players.LocalPlayer.Name].Total.DeathCause.Value = entityName
    end)
end

task.spawn(function()
    pcall(function()
        local preloadImgs = {}
        local i1 = Instance.new("ImageLabel")
        i1.Image = "rbxassetid://91488327565377" -- Stalker jumpscare
        local i2 = Instance.new("ImageLabel")
        i2.Image = "rbxassetid://140286191775781" -- Blackout jumpscare
        table.insert(preloadImgs, i1)
        table.insert(preloadImgs, i2)
        game:GetService("ContentProvider"):PreloadAsync(preloadImgs)
    end)
end)

-- Stacking entity-death notifications
local NotifTween = game:GetService("TweenService")
local NotifPlayer = game.Players.LocalPlayer
local NotifPlayerGui = NotifPlayer:WaitForChild("PlayerGui")

local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "MayhemDeathNotifs"
NotifGui.ResetOnSpawn = false
NotifGui.IgnoreGuiInset = true
NotifGui.DisplayOrder = 999
NotifGui.Parent = NotifPlayerGui

local NotifContainer = Instance.new("Frame")
NotifContainer.Name = "Container"
NotifContainer.AnchorPoint = Vector2.new(0, 1)
NotifContainer.Position = UDim2.new(0, 20, 1, -20)
NotifContainer.Size = UDim2.new(0, 300, 1, -40)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = NotifGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
NotifLayout.Padding = UDim.new(0, 8)
NotifLayout.Parent = NotifContainer

local NotifCount = 0

local function EntityDiedNotify(entityName)
    NotifCount = NotifCount + 1
    local order = NotifCount

    local Notif = Instance.new("Frame")
    Notif.Name = "Notif"
    Notif.LayoutOrder = order
    Notif.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Notif.BackgroundTransparency = 1
    Notif.BorderSizePixel = 0
    Notif.Size = UDim2.new(1, 0, 0, 40)
    Notif.ClipsDescendants = true
    Notif.Parent = NotifContainer

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Notif

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(150, 0, 0)
    Stroke.Thickness = 1
    Stroke.Transparency = 1
    Stroke.Parent = Notif

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, -16, 1, 0)
    Label.Position = UDim2.new(0, 8, 0, 0)
    Label.FontFace = Font.fromEnum(Enum.Font.GothamBold)
    Label.TextSize = 16
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextTransparency = 1
    Label.Text = tostring(entityName) .. " died"
    Label.Parent = Notif

    local fadeIn = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    NotifTween:Create(Notif, fadeIn, {BackgroundTransparency = 0.15}):Play()
    NotifTween:Create(Stroke, fadeIn, {Transparency = 0}):Play()
    NotifTween:Create(Label, fadeIn, {TextTransparency = 0}):Play()

    task.delay(4, function()
        if not Notif or not Notif.Parent then return end
        local fadeOut = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local fadeOutTween = NotifTween:Create(Notif, fadeOut, {BackgroundTransparency = 1})
        NotifTween:Create(Stroke, fadeOut, {Transparency = 1}):Play()
        NotifTween:Create(Label, fadeOut, {TextTransparency = 1}):Play()
        fadeOutTween:Play()
        fadeOutTween.Completed:Wait()
        if Notif then Notif:Destroy() end
    end)
end

local gameId = game.PlaceId
print("Script ".._G.AmeScript.." is now active.")
local AlreadyRan = game.ReplicatedStorage:FindFirstChild("AmeRanPart")
if not AlreadyRan then
local ameRanPart = Instance.new("Part")
ameRanPart.Name = "AmeRanPart"
ameRanPart.Position = Vector3.new(0, 10, 0)
ameRanPart.Size = Vector3.new(5, 5, 5)
ameRanPart.Anchored = true
ameRanPart.Parent = game.ReplicatedStorage
print("ran")
if gameId == 6839171747 then

    local r = game.JobId
    r = string.gsub(r, '%D+', '')
    local ab = Random.new(r + 1)
    local eb = Random.new(r * 2)
    local nb = Random.new(r + r + eb:NextInteger(1000, 5000))
    _G.ClientRandom = ab

    local blackoutspawn_time = ab:NextInteger(80, 160)
    local threatspawn_time = ab:NextInteger(220, 360)
    local greedspawn_time = ab:NextInteger(90, 130)
    game.Lighting.FogEnd = 75
    game.Lighting.FogStart = 10
    game.Lighting.FogColor = Color3.fromRGB(0, 0, 0)

    _G.AntiLog = true

Msg("Mayhem Mode - v2.11.2", 1)
task.wait(2)
Msg("Made by ThatOneAmethystCreature#0001", 1)
_G.AntiLog = true
task.wait(2)
Msg("remake by osamavipkill1", 1)
task.wait(2)
game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
Msg("Mayhem mode is now active.", 2)
task.wait(2)
Msg("report bugs at @chkn_is_still_my_wife on discord", 2)

-- paintings
game.ReplicatedStorage.GameData.LatestRoom.Changed:Connect(function()
    for _, v in next, game.Workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value].Assets:GetDescendants() do
        if string.match(v.Name, "Painting") and not string.match(v.Name, "Seek") and v.Name ~= "Paintings" then
            local paintingRoll = math.random(1, 7)
            if paintingRoll == 1 then
                local BirbPainting = v:Clone()
                BirbPainting.Parent = v.Parent
                BirbPainting.Canvas.SurfaceGui.ImageLabel.Image = "rbxassetid://104590205087459"
                BirbPainting.Canvas.SurfaceGui.ImageLabel.BackgroundTransparency = 1
                BirbPainting.Name = "Birb Painting"
                local birbToggle = true
                BirbPainting.InteractPrompt.Triggered:Connect(function()
                    birbToggle = not birbToggle
                    if birbToggle then
                        BirbPainting.Name = "Tweet Tweet"
                        Msg("Tweet tweet tweet tweet \"Tweet tweet tweet\".", 1)
                    else
                        BirbPainting.Name = "Birb Painting"
                        Msg("This painting is titled \"Flight of Fancy\".", 1)
                    end
                end)
                v:Destroy()

            elseif paintingRoll == 2 then
                local PsstPainting = v:Clone()
                PsstPainting.Parent = v.Parent
                PsstPainting.Canvas.SurfaceGui.ImageLabel.Image = "rbxassetid://135192175310255"
                PsstPainting.Canvas.SurfaceGui.ImageLabel.BackgroundTransparency = 1
                PsstPainting.Name = "Screech Painting"
                PsstPainting.InteractPrompt.Triggered:Connect(function()
                    Msg("This painting is titled \"Psst\".", 1)
                end)
                v:Destroy()

            elseif paintingRoll == 3 and game.ReplicatedStorage.GameData.LatestRoom.Value == 50 then
                local FingerPainting = v:Clone()
                FingerPainting.Parent = v.Parent
                FingerPainting.Canvas.SurfaceGui.ImageLabel.Image = "rbxassetid://81975596270988"
                FingerPainting.Canvas.SurfaceGui.ImageLabel.BackgroundTransparency = 1
                FingerPainting.Name = "Figure Painting"
                FingerPainting.InteractPrompt.Triggered:Connect(function()
                    Msg("This painting is titled \"Blind but Deadly\".", 1)
                end)
                v:Destroy()

            elseif paintingRoll == 4 then
                local CatPainting = v:Clone()
                CatPainting.Parent = v.Parent
                CatPainting.Canvas.SurfaceGui.ImageLabel.Image = "rbxassetid://102947539228320"
                CatPainting.Canvas.SurfaceGui.ImageLabel.BackgroundTransparency = 1
                CatPainting.Name = "Cat Painting"
                CatPainting.InteractPrompt.Triggered:Connect(function()
                    Msg("This painting is titled \"Dead of Night\".", 1)
                end)
                v:Destroy()

            elseif paintingRoll == 5 then
                local VillagePainting = v:Clone()
                VillagePainting.Parent = v.Parent
                VillagePainting.Canvas.SurfaceGui.ImageLabel.Image = "rbxassetid://100105252947883"
                VillagePainting.Canvas.SurfaceGui.ImageLabel.BackgroundTransparency = 1
                VillagePainting.Name = "Village Painting"
                VillagePainting.InteractPrompt.Triggered:Connect(function()
                    Msg("This painting is titled \"Artists View\".", 1)
                end)
                v:Destroy()

            elseif paintingRoll == 6 then
                local BlackoutPainting = v:Clone()
                BlackoutPainting.Parent = v.Parent
                BlackoutPainting.Canvas.SurfaceGui.ImageLabel.Image = "rbxassetid://140286191775781"
                BlackoutPainting.Canvas.SurfaceGui.ImageLabel.BackgroundTransparency = 1
                BlackoutPainting.Name = "Blackout Painting"
                BlackoutPainting.InteractPrompt.Triggered:Connect(function()
                    Msg("This painting is titled \"Power Outage\".", 1)
                end)
                v:Destroy()
            end
        end
    end
end)
--
-- music
task.spawn(function()
    task.wait(2)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/MayhemSFX.lua"))()
end)
--
-- Seek Check
local SeekActive = false
task.spawn(function()
    while true do
        task.wait(1)
        SeekActive = game.Workspace:FindFirstChild("SeekMoving", true) ~= nil
    end
end)
--
local function SetLast(Entity, Extra)
    if Extra then
        game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
    end
    LastRoomEntity = Entity
    game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
    game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
    LastRoomEntity = nil
end
-- blackout
local function BlackoutSpawn()
    print("stop looking at the console and just play the game, also blackout is trying to spawn")
    task.wait(1)
    local latestRoom = game.ReplicatedStorage.GameData.LatestRoom.Value
    if not game.Workspace:FindFirstChild("ThreatMoving")
        and not game.Workspace:FindFirstChild("RushMoving")
        and not game.Workspace:FindFirstChild("AmbushMoving")
        and not game.Workspace:FindFirstChild("Mimic Rush")
        and not game.Workspace:FindFirstChild("Mimic Ambush")
        and latestRoom ~= 50 and latestRoom ~= 100
    then
        if not SeekActive then
            SetLast("Blackout", true)
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/Entities/Blackout.lua"))()
        else
            print("blackout is dead :flushed:")
        end
    else
        warn("Entity exists, didn't spawn BO.")
    end
end
-- 
task.spawn(function()
    local r2 = game.JobId
    r2 = string.gsub(r2, '%D+', '')
    local ab2 = Random.new(r2 + 1)
    local spawnvalues = {
        ab2:NextInteger(1, 25),
        ab2:NextInteger(26, 50),
        ab2:NextInteger(51, 75),
        ab2:NextInteger(76, 101)
    }
    for i = #spawnvalues, 1, -1 do
        if spawnvalues[i] == 50 or spawnvalues[i] == 100 then
            table.remove(spawnvalues, i)
        end
    end
    game.ReplicatedStorage.GameData.LatestRoom.Changed:Connect(function()
        if table.find(spawnvalues, game.ReplicatedStorage.GameData.LatestRoom.Value) then
            if not SeekActive then
                BlackoutSpawn()
            end
        end
    end)
end)
--
-- threat
local function ThreatSpawn()
    local hasWardrobe = false
    pcall(function()
        local currentRoom = game.ReplicatedStorage.GameData.LatestRoom.Value
        local roomFolder = workspace.CurrentRooms[currentRoom]
        local roomAssets = roomFolder and roomFolder:FindFirstChild("Assets")
        if roomAssets then
            for _, d in pairs(roomAssets:GetDescendants()) do
                if d.Name:lower():find("wardrobe") then
                    hasWardrobe = true
                    break
                end
            end
        end
    end)

    local latestRoom = game.ReplicatedStorage.GameData.LatestRoom.Value
    if hasWardrobe and not SeekActive and LastRoomEntity == nil
        and latestRoom ~= 50 and latestRoom ~= 100
        and not game.Workspace:FindFirstChild("Mimic Rush")
        and not game.Workspace:FindFirstChild("Mimic Ambush")
    then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/Entities/Threat.lua"))()
        SetLast("Threat", false)
    else
        warn("No wardrobe exists, didn't spawn TH.")
    end
end
task.spawn(function()
    while true do
        task.wait(ab:NextInteger(120, 280))
        ThreatSpawn()
    end
end)
-- twister
task.spawn(function()
    while true do
        task.wait(eb:NextInteger(60, 280))
        if LastRoomEntity == nil and not SeekActive then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/Entities/Twister.lua"))()
            SetLast("Twister", true)
        end
    end
end)
--
-- mimic rush
task.spawn(function()
    while true do
        task.wait(nb:NextInteger(90, 280))
        local latestRoom = game.ReplicatedStorage.GameData.LatestRoom.Value
        if LastRoomEntity == nil and not SeekActive
            and latestRoom ~= 50 and latestRoom ~= 100
            and _G.Threat == "safe"
            and not game.Workspace:FindFirstChild("Mimic Ambush")
        then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/pastebin1"))()
            SetLast("Mimic Rush", true)
        end
    end
end)
-- mimic ambush
task.spawn(function()
    while true do
        task.wait(nb:NextInteger(280, 540))
        local latestRoom = game.ReplicatedStorage.GameData.LatestRoom.Value
        if LastRoomEntity == nil and not SeekActive
            and latestRoom ~= 50 and latestRoom ~= 100
            and _G.Threat == "safe"
            and not game.Workspace:FindFirstChild("Mimic Rush")
        then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/pastebin2"))()
            SetLast("Mimic Ambush", true)
        end
    end
end)
--
local whiteout = false
local whitefog = nil
local ambienceDread = game.Lighting:FindFirstChild("Ambience_Dread")
if ambienceDread then
    whitefog = ambienceDread:Clone()
    whitefog.Saturation = -1.2
    whitefog.Brightness = 0.2
    whitefog.Contrast = 0.2
    whitefog.Name = "Ambience_Fog"
    whitefog.Parent = game.Lighting
    whitefog.Enabled = false
else
    warn("[Mayhem] Ambience_Dread not found in Lighting.")
end

local WhiteoutRoom1 = ab:NextInteger(38, 40)
local WhiteoutRoom2 = ab:NextInteger(88, 90)

-- fog
game.ReplicatedStorage.GameData.LatestRoom.Changed:Connect(function()
    print("stop looking at the console and just play the game")
    local latestRoom = game.ReplicatedStorage.GameData.LatestRoom.Value
    if latestRoom == 50 or latestRoom == 100 then
        whiteout = false
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/Entities/Fog.lua"))()
        game.Lighting.FogColor = Color3.fromRGB(255, 255, 255) 
        game.Lighting.FogEnd = 49
        game.Lighting.FogStart = 18
        game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
        if whitefog then whitefog.Enabled = false end
    end
    if (latestRoom == WhiteoutRoom1 or latestRoom == WhiteoutRoom2) and not whiteout then
        whiteout = true
        if whitefog then whitefog.Enabled = true end
        game.Lighting.FogColor = Color3.fromRGB(255, 255, 255) 
        game.Lighting.FogEnd = 49
        game.Lighting.FogStart = 18
        local fogSound1 = Instance.new("Sound")
        fogSound1.SoundId = "rbxassetid://1841093403"
        fogSound1.Parent = game:GetService("SoundService")
        fogSound1.Name = "MayhemFog1"
        local fogSound2 = Instance.new("Sound")
        fogSound2.SoundId = "rbxassetid://1840927154"
        fogSound2.Parent = game:GetService("SoundService")
        fogSound2.Name = "MayhemFog2"
        TitleMsg("The Whiteout")
        fogSound1:Play()
        fogSound2:Play()
        WaitForSoundEnd(fogSound1)
        if fogSound2.Playing then  
            WaitForSoundEnd(fogSound2)
        end
        fogSound1:Destroy()
        fogSound2:Destroy()
    else
        task.wait()
    end
end)

-- psst / screech
task.spawn(function()
while true do
    task.wait(math.random(15, 45))
    print("stop looking at the console and just play the game")
    local char = game.Players.LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if _G.Blackout == "safe" and
    _G.Threat == "safe" and
    hum and hum.Health > 0 and
    not SeekActive and
    LastRoomEntity == nil and
    not _G.GazeEntityActive
    then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/psstman"))()
    end
    end
end)

-- stalker
_G.StalkerActive = false
task.spawn(function()
while true do
    task.wait(math.random(15, 45))
    print("stop looking at the console and just play the game")
    local char = game.Players.LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if _G.Blackout == "safe" and
    _G.Threat == "safe" and
    hum and hum.Health > 0 and
    LastRoomEntity == nil and
    not _G.StalkerActive
    then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/Entities/Stalker.lua"))()
    end
    end
end)
--

-- obsession aka greed
task.spawn(function()
    while true do
        task.wait(ab:NextInteger(60, 120))
        print("stop looking at the console and just play the game, also obs")
        local latestRoom = game.ReplicatedStorage.GameData.LatestRoom.Value
        if LastRoomEntity == nil and not SeekActive
            and not _G.GazeEntityActive
            and not game.Workspace:FindFirstChild("EyesMoving")
            and latestRoom ~= 50 and latestRoom ~= 100
        then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/Entities/Obsession.lua"))()
            SetLast("Obs", true)
        end
    end
end)
--

task.spawn(function()
    while true do
        task.wait(eb:NextInteger(120, 560))
        local latestRoom = game.ReplicatedStorage.GameData.LatestRoom.Value
        if LastRoomEntity == nil
            and not SeekActive
            and latestRoom ~= 50
            and latestRoom ~= 100
        then
            SetLast("Envy", true)
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/Entities/Envy.lua"))()
        end
    end
end)

--
-- manic eyes
task.spawn(function()
    while true do
        task.wait(eb:NextInteger(60, 120))
        print("stop looking at the console and just play the game, also eyes")
        if LastRoomEntity == nil and not SeekActive
            and not _G.GazeEntityActive
            and not game.Workspace:FindFirstChild("EyesMoving")
        then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/Entities/Manic%20Eyes.lua"))()
            SetLast("Eyes", true)
        end
    end
end)
--

-- deer god v5
task.spawn(function()
    local window1 = ab:NextInteger(7, 30)
    local window2 = ab:NextInteger(53, 70)
    local spawned1 = false
    local spawned2 = false
    while not spawned1 or not spawned2 do
        game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
        local latestRoom = game.ReplicatedStorage.GameData.LatestRoom.Value
        local okToSpawn = not SeekActive
            and latestRoom ~= 50 and latestRoom ~= 100
            and LastRoomEntity == nil

        if okToSpawn and not spawned1 and latestRoom >= window1 then
            spawned1 = true
            SetLast("Deer God", true)
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/Entities/DeerGodV5.lua"))()
        elseif okToSpawn and not spawned2 and latestRoom >= window2 then
            spawned2 = true
            SetLast("Deer God", true)
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/Entities/DeerGodV5.lua"))()
        end
    end
end)
--

    
else
    if type(firesignal) == "function" then
        firesignal(game.ReplicatedStorage.Bricks.Caption.OnClientEvent, "You need to run this when in-game.")
    else
        warn("[Mayhem] You need to run this when in-game.")
    end
end
else
    Msg("Script has already been executed", 2)
end
_G.AntiLog = true
