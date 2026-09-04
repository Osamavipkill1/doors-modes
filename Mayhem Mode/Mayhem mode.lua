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

--
local LastEntity = nil
local LastRoomEntity = nil
_G.AntiLog = true
_G.AmeScript = "Mayhem Mode"
_G.Neon919 = true
local SoundReverb = game:GetService("SoundService")
SoundReverb.AmbientReverb = 10
-- ebic
-- commands
loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/Commands.lua"))()

_G.Blackout = "safe" 
_G.Threat = "safe" 

function Msg(Message, Lifetime)
    local ok, mod = pcall(function()
        return require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game)
    end)
    if ok and mod and mod.caption then
        pcall(mod.caption, Message, true)
    else
        warn("[Mayhem] Msg() failed — message: " .. tostring(Message))
    end
end

function TitleMsg(Title)
    local ok, mod = pcall(function()
        return require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game)
    end)
    if ok and mod and mod.titlelocation then
        pcall(mod.titlelocation, Title)
    else
        warn("[Mayhem] TitleMsg() failed.")
    end
end

-- Stacking entity-death notifications (replaces the old print() spam)
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

-- entityName: display name shown in the notification, e.g. "Stalker", "Psst"
function EntityDiedNotify(entityName)
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
        if Notif then
            Notif:Destroy()
        end
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

Msg("Mayhem Mode - v2.5", 1)
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
        -- Painting
        if string.match(v.Name, "Painting") and not string.match(v.Name, "Seek") and v.Name ~= "Paintings" then
            local paintingRoll = math.random(1, 6)
            if paintingRoll == 1 then
                local BirbPainting = v:Clone()
                BirbPainting.Parent = v.Parent
                BirbPainting.Canvas.SurfaceGui.ImageLabel.Image = "rbxassetid://91452104822736"
                BirbPainting.Canvas.SurfaceGui.ImageLabel.BackgroundTransparency = 0
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
                PsstPainting.Canvas.SurfaceGui.ImageLabel.Image = "rbxassetid://88174709585315"
                PsstPainting.Canvas.SurfaceGui.ImageLabel.BackgroundTransparency = 0
                PsstPainting.Name = "Screech Painting"
                PsstPainting.InteractPrompt.Triggered:Connect(function()
                    Msg("This painting is titled \"Psst\".", 1)
                end)
                v:Destroy()
            elseif paintingRoll == 3 and game.ReplicatedStorage.GameData.LatestRoom.Value == 50 then
                local FingerPainting = v:Clone()
                FingerPainting.Parent = v.Parent
                FingerPainting.Canvas.SurfaceGui.ImageLabel.Image = "rbxassetid://120827636037741"
                FingerPainting.Canvas.SurfaceGui.ImageLabel.BackgroundTransparency = 0
                FingerPainting.Name = "Figure Painting"
                FingerPainting.InteractPrompt.Triggered:Connect(function()
                    Msg("This painting is titled \"Blind but Deadly\".", 1)
                end)
                v:Destroy()
            elseif paintingRoll == 4 then
                local CatPainting = v:Clone()
                CatPainting.Parent = v.Parent
                CatPainting.Canvas.SurfaceGui.ImageLabel.Image = "rbxassetid://134191008351903"
                CatPainting.Canvas.SurfaceGui.ImageLabel.BackgroundTransparency = 0
                CatPainting.Name = "Cat Painting"
                CatPainting.InteractPrompt.Triggered:Connect(function()
                    Msg("This painting is titled \"Dead of Night\".", 1)
                end)
                v:Destroy()
            elseif paintingRoll == 5 then
                local VillagePainting = v:Clone()
                VillagePainting.Parent = v.Parent
                VillagePainting.Canvas.SurfaceGui.ImageLabel.Image = "rbxassetid://86351095154741"
                VillagePainting.Canvas.SurfaceGui.ImageLabel.BackgroundTransparency = 0
                VillagePainting.Name = "Village Painting"
                VillagePainting.InteractPrompt.Triggered:Connect(function()
                    Msg("This painting is titled \"Artists View\".", 1)
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
function SetLast(Entity, Extra)
    if Extra then
        game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
    end
    LastRoomEntity = Entity
    game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
    game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
    LastRoomEntity = nil
end
-- blackout
function BlackoutSpawn()
    print("stop looking at the console and just play the game, also blackout is trying to spawn")
    task.wait(1)
    if not game.Workspace:FindFirstChild("ThreatMoving")
        and not game.Workspace:FindFirstChild("RushMoving")
        and not game.Workspace:FindFirstChild("AmbushMoving")
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
function ThreatSpawn()
    while true do
        game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
        task.wait(0.1)
        local currentRoom = game.ReplicatedStorage.GameData.LatestRoom.Value
        local roomFolder = workspace.CurrentRooms[currentRoom]
        local roomAssets = roomFolder and roomFolder:FindFirstChild("Assets")
        if roomAssets
            and roomAssets:FindFirstChild("Wardrobe")
            and not SeekActive
            and LastRoomEntity == nil
        then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/Entities/Threat.lua"))()
            SetLast("Threat", false)
            break
        else
            warn("No wardobe exists, didn't spawn TH.")
        end
    end
end
--
task.spawn(function()
    while true do
        task.wait(ab:NextInteger(160, 360))
        ThreatSpawn()
    end
end)
--
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
-- nightmare rush
task.spawn(function()
    while true do
        task.wait(nb:NextInteger(120, 360))
        if LastRoomEntity == nil and not SeekActive then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/pastebin1"))()
            SetLast("NM Rush", true)
        end
    end
end)
-- nightmare ambush
task.spawn(function()
    while true do
        task.wait(nb:NextInteger(360, 680))
        if LastRoomEntity == nil and not SeekActive then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/pastebin2"))()
            SetLast("NM Ambush", true)
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
        fogSound1.Ended:Wait()
        if fogSound2.Playing then  
            fogSound2.Ended:Wait()
        end
        fogSound1:Destroy()
        fogSound2:Destroy()
    else
        task.wait()
    end
end)

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
    LastRoomEntity == nil
    then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/psstman"))()
    end
    end
end)
task.spawn(function()
while true do
    local minv = math.random(10, 50)
    local maxv = math.random(80, 120)
    task.wait(math.random(minv, maxv))
    print("stop looking at the console and just play the game")
    local char = game.Players.LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if _G.Blackout == "safe" and
    _G.Threat == "safe" and
    hum and hum.Health > 0 and
    not SeekActive and
    LastRoomEntity == nil
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
        if LastRoomEntity == nil and not SeekActive then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/Entities/Obsession.lua"))()
            SetLast("Obs", true)
        end
    end
end)
--

-- april fools!!!
task.spawn(function()
    while true do
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/Entities/Envy.lua"))()
        task.wait(ab:NextInteger(30, 300))
    end
end)

--
-- manic eyes
task.spawn(function()
    while true do
        task.wait(eb:NextInteger(250, 320))
        print("stop looking at the console and just play the game, also eyes")
        if LastRoomEntity == nil and not SeekActive then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/Entities/Manic%20Eyes.lua"))()
            SetLast("Eyes", true)
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
