-- 12802441490
_G.Threat = "safe" 
local Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/Osamavipkill1/doors-modes/refs/heads/main/Mayhem%20Mode/misc/EntitySpawnerFork/ThreatSource.lua"))()
local r = game.JobId
r = string.gsub(r, '%D+', '')
local ab = Random.new(r + 1)
-- THREAT
local Threat = Spawner.createEntity({
    CustomName = "Threat", -- Custom name of your entity
    Model = "rbxassetid://12802441490", -- Can be GitHub file or rbxassetid
    Speed = 225, -- Percentage, 100 = default Rush speed
    DelayTime = 3.5, -- Time before starting cycles (seconds)
    HeightOffset = 0,
    CanKill = true,
    KillRange = 75,
    BackwardsMovement = true,
    BreakLights = false,
    FlickerLights = {
        false, -- Enabled/Disabled
        1, -- Time (seconds)
    },
    Cycles = {
        Min = 6,
        Max = 6,
        WaitTime = 3,
    },
    CamShake = {
        true, -- Enabled/Disabled
        {3.5, 20, 0.1, 1}, -- Shake values (don't change if you don't know)
        150, -- Shake start distance (from Entity to you)
    },
    Jumpscare = {
        false, -- Enabled/Disabled
        {
            Image1 = "rbxassetid://10483855823", -- Image1 url
            Image2 = "rbxassetid://10483999903", -- Image2 url
            Shake = true,
            Sound1 = {
                3359047385, -- SoundId
                { Volume = 0.5 }, -- Sound properties
            },
            Flashing = {
                true, -- Enabled/Disabled
                Color3.fromRGB(255, 255, 255), -- Color
            },
            Tease = {
                true, -- Enabled/Disabled
                Min = 0.25,
                Max = 1,
            },
        },
    },
	CustomDialog = {"Oh... hello.", "Not this place again...", "Nevermind that... What'd you die to?", "Oh... the red thing.", "It seems to get faster over time, so...", "Maybe you could call it Threat?", "Anyways, I hope you don't mind trying again. It would be helpful."}, -- Custom death message
	Color = "Yellow"
})


-----[[  Debug -=- Advanced  ]]-----
Threat.Debug.OnEntitySpawned = function()
    print("Entity has spawned:", Threat)
    _G.Threat = "unsafe" 
        local sound = Instance.new("Sound", game.Workspace)
sound.SoundId = "rbxassetid://3359047385" -- Replace with the ID of the sound you want to play

local soundService = game:GetService("SoundService")
soundService:PlayLocalSound(sound)
local TS = game:GetService("TweenService")
local tweentime = TweenInfo.new(2)
local correction = Instance.new("ColorCorrectionEffect")
correction.Parent = game.Lighting
correction.Brightness = 0.05
correction.Contrast = 0
correction.Name = "ThreatCorrection"
correction.Enabled = true
correction.TintColor = Color3.fromRGB(50, 4, 178)
correction.Saturation = 0
local finish = {}
finish.Contrast = 0
finish.Saturation = 0
finish.TintColor = Color3.fromRGB(242, 4, 178)
local tw = TS:Create(correction, tweentime, finish)
tw:Play()
local room = workspace.CurrentRooms[game.Players.LocalPlayer:GetAttribute("CurrentRoom")]
local color = Color3.fromRGB(242, 4, 178)
		room.LightBase.SurfaceLight.Enabled = true
		room.LightBase.SurfaceLight.Color = color
		for _, thing in pairs(room.Assets:GetDescendants()) do
			if thing:FindFirstChild"LightFixture" then
				thing.LightFixture.Neon.Color = color
				for _, light in pairs(thing.LightFixture:GetChildren()) do
					if light:IsA("SpotLight") or light:IsA("PointLight") then
						light.Color = color
					end
				end
			end
		end
wait(2)
local finish2 = {}
finish2.Contrast = 0
finish2.Saturation = -1
finish2.TintColor = Color3.fromRGB(242, 4, 178)
finish2.Brightness = 0
local tw2 = TS:Create(correction, tweentime, finish2)
tw2:Play()
end

Threat.Debug.OnEntityDespawned = function()
_G.Threat = "safe" 
    print("Entity has despawned:", Threat)
    game.Lighting.ThreatCorrection:Destroy()
        local Flash = Instance.new("ColorCorrectionEffect")
Flash.Parent = game.Lighting

spawn(function()
		Flash.TintColor = Color3.fromRGB(0, 255, 0) -- to change the screen flash color then change 255, 0, 0 to what color you want!
		game:GetService("TweenService"):Create(Flash, TweenInfo.new(1.75), {TintColor = Color3.fromRGB(255, 255, 255)}):Play()
	end)
end

Threat.Debug.OnEntityStartMoving = function()
    print("Entity has started moving:", Threat)
end

Threat.Debug.OnEntityFinishedRebound = function()
    print("Entity has finished rebound:", Threat)
    local random = ab:NextInteger(25,75)
    Threat.Config.Speed = Threat.Config.Speed + random
    print("added speed:".. random)
        local Flash = Instance.new("ColorCorrectionEffect")
Flash.Parent = game.Lighting

spawn(function()
		Flash.TintColor = Color3.fromRGB(127.5, 0, 0) -- to change the screen flash color then change 255, 0, 0 to what color you want!
		game:GetService("TweenService"):Create(Flash, TweenInfo.new(1.75), {TintColor = Color3.fromRGB(255, 255, 255)}):Play()
	end)
end

Threat.Debug.OnEntityEnteredRoom = function(room)
    print("Entity:", Threat, "has entered room:", room)
end
Threat.Debug.OnLookAtEntity = function()
    print("Player has looked at entity:", Threat)
end

Threat.Debug.OnDeath = function()
    warn("Player has died.")
end
------------------------------------
Spawner.runEntity(Threat)

